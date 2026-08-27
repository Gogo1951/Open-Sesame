local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L

--------------------------------------------------------------------------------
-- API References
--------------------------------------------------------------------------------

local CreateFrame, C_Timer, UnitAffectingCombat, GetTime = CreateFrame, C_Timer, UnitAffectingCombat, GetTime
local tonumber, wipe, UnitRace, UnitSex = tonumber, wipe, UnitRace, UnitSex
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

--[[
    Both target clients expose C_UnitAuras.GetBuffDataByIndex, which returns a
    named-field table and so sidesteps the old UnitBuff return-position problem
    (Era put spellId at 10, TBC's extra rank return shifted it to 11).
]]
local GetBuffDataByIndex = C_UnitAuras.GetBuffDataByIndex

local function GetPlayerBuffSpellID(index)
	local data = GetBuffDataByIndex("player", index)
	return data and data.spellId
end

local GetCVarBool, SetCVar = C_CVar.GetCVarBool, C_CVar.SetCVar

--[[
    Loot-message prefixes, derived once from the global loot format strings
    (e.g. "You receive loot: %s."). Guarded in case the globals are absent at
    load; CHAT_MSG_LOOT references these cached upvalues.
]]
local lootSelfPrefix = LOOT_ITEM_SELF and LOOT_ITEM_SELF:gsub("%%s", ""):gsub("%.$", "")
local lootPushedPrefix = LOOT_ITEM_PUSHED_SELF and LOOT_ITEM_PUSHED_SELF:gsub("%%s", ""):gsub("%.$", "")

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

--[[
    Add-on identity. Read from TOC metadata; the TOC Version field carries the
    @project-version@ token, replaced only at build time, so an unreplaced token
    (the @ is the signal) means a local dev copy and displays as "Dev".
]]
local version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version") or "Dev"
if version:find("@") then
	version = "Dev"
end
ns.Version = version

--------------------------------------------------------------------------------
-- Flags
--------------------------------------------------------------------------------

ns.isEnabled = true
ns.isPaused = false
ns.isSpeedyLoot = true

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.state = {
	announcedPaused = false,
	lastBagFullAt = 0,
	lastFreeSlots = 0,
	lastLootAt = 0,
	lastWorldLootAt = 0,
	-- When Pick Pocket last landed; 0 once its sound has played or nothing came.
	pickPocketAt = 0,
	lastStatusAt = 0,
	lastStatusMsg = nil,
	openTimerLive = false,
	quietUntil = 0,
	recentAnnouncements = {},
	scanPending = false,
	scanTimerAt = 0,
}

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

function ns.EnsureAutoLoot()
	if not GetCVarBool("autoLootDefault") then
		SetCVar("autoLootDefault", "1")
		ns:PrintMessage(L["AUTO_LOOT_ENABLED"])
	end
end

local function PrintWelcome()
	if not ns.db.profile.showWelcome then
		return
	end
	ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

--[[
    Both target clients carry the inventory-full message id as the
    LE_GAME_ERR_INV_FULL global; neither has Enum.UIERRORS. Since that global is
    a number, comparing a non-number errorID against it is already false, so no
    type guard is needed. This is the only inventory-full test in the add-on —
    the handler and Diagnostics' event-log filter both classify UI_ERROR_MESSAGE
    through it, so a firing can never pause the add-on while the log files it
    away as uncorrelated noise. Never add a message-text match beside it: the
    two would disagree exactly when a bug report needs the log line.
]]
function ns.IsBagFullErrorID(errorID)
	return errorID == LE_GAME_ERR_INV_FULL
end

local function PlayBagFullSound()
	local _, raceEnglish = UnitRace("player")
	local gender = UnitSex("player")
	if raceEnglish and ns.RACE_SOUNDS[raceEnglish] and ns.RACE_SOUNDS[raceEnglish][gender] then
		PlaySound(ns.RACE_SOUNDS[raceEnglish][gender], "Master")
	else
		PlaySound(ns.BAG_FULL_SOUND_FALLBACK, "Master")
	end
end

local scanTooltip = CreateFrame("GameTooltip", "OpenSesameScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

--[[
    Does a tooltip carry this exact line? Split out from the two scanners below so
    the reading and the scanning are separable.

    Matched against the WHOLE line, never as a substring: LOCKED is a short word,
    and other add-ons write lines that contain it without meaning it.
]]
local function TooltipHasLine(tooltip, needle)
	local tooltipName = tooltip:GetName()
	if not tooltipName or not needle then
		return false
	end
	for lineIndex = 1, tooltip:NumLines() do
		local line = _G[tooltipName .. "TextLeft" .. lineIndex]
		local text = line and line:GetText()
		if text and text == needle then
			return true
		end
	end
	return false
end

--[[
    The same question asked of a bag slot, for callers with no tooltip to read.
    Exported as ns.IsItemLocked for the queue in this file and the mini-map's
    Locked Items list. One scan tooltip, one implementation — a second copy would
    drift.

    THE OWNER IS SET ON EVERY CALL, not once at file scope, and that is
    load-bearing: hiding a tooltip drops its owner, and an unowned tooltip takes a
    SetBagItem without complaint and populates NOTHING. Every box then reads as
    unlocked: no Locked Items list on the mini-map and no tooltip line.

    Setting a tooltip also shows it, hence that Hide: this one is anchored nowhere
    in particular and has no business being on screen. Shown and hidden inside a
    single frame, it never renders.
]]
local function IsItemLocked(bag, slot)
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetBagItem(bag, slot)
	local locked = TooltipHasLine(scanTooltip, LOCKED)
	scanTooltip:Hide()
	return locked
end
ns.IsItemLocked = IsItemLocked

--[[
    "Does this item begin a quest", which the client will say in a tooltip and
    nowhere else: no API on either target flags it, and the item's CLASS does not
    give it away either, since quest starters are ordinary weapons, armour and
    trinkets as often as they are class 12. Read by hyperlink because the caller
    has an item, not a bag slot -- this is asked of loot, which may never reach the
    bags at all.

    The scan is the most expensive question Loot Toasts asks, so it is also the
    last one asked: everything cheaper has already failed by the time it runs, and
    it only runs for loot the quality threshold would otherwise have hidden.
]]
local function ItemStartsQuest(itemId)
	if not itemId then
		return false
	end
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetHyperlink("item:" .. itemId)
	local startsQuest = TooltipHasLine(scanTooltip, ITEM_STARTS_QUEST)
	scanTooltip:Hide()
	return startsQuest
end
ns.ItemStartsQuest = ItemStartsQuest

local function IsPlayerStealthed()
	if IsStealthed() then
		return true
	end
	for buffIndex = 1, 40 do
		local spellID = GetPlayerBuffSpellID(buffIndex)
		if not spellID then
			break
		end
		if spellID == ns.SPELLS.SHADOWMELD then
			return true
		end
	end
	return false
end

local function IsInteractionActive()
	return (MerchantFrame and MerchantFrame:IsShown())
		or (MailFrame and MailFrame:IsShown())
		or (TradeFrame and TradeFrame:IsShown())
		or (BankFrame and BankFrame:IsShown())
		or (GuildBankFrame and GuildBankFrame:IsShown())
		or (AuctionFrame and AuctionFrame:IsShown())
		or (GossipFrame and GossipFrame:IsShown())
		or (QuestFrame and QuestFrame:IsShown())
		or (StaticPopup1 and StaticPopup1:IsShown())
end

local function IsSafeToOpen()
	if not ns.isEnabled or ns.isPaused then
		return false
	end

	--[[
        Where and Group are the player's own hold-off rules: bag slots stay free
        for drops while in an instance or grouped, and the boxes open once they
        are back on their own time. GROUP_ROSTER_UPDATE and the non-initial
        PLAYER_ENTERING_WORLD branch both rescan, so leaving either state resumes
        opening without waiting on a bag event.
    ]]
	if ns.db.profile.autoOpenWhere == "OUTSIDE_INSTANCES" and IsInInstance() then
		return false
	end
	if ns.db.profile.autoOpenGroup == "SOLO_ONLY" and IsInGroup() then
		return false
	end

	if UnitAffectingCombat("player") or IsInteractionActive() or IsPlayerStealthed() then
		return false
	end
	if UnitCastingInfo("player") or UnitChannelInfo("player") then
		return false
	end

	if GameTooltip:IsShown() then
		local hasItem, itemLink = GameTooltip:GetItem()
		if hasItem or itemLink then
			return false
		end
	end

	ns.state.lastFreeSlots = ns.GetFreeSlots()
	return ns.state.lastFreeSlots >= ns.MIN_FREE_SLOTS
end

local function ShouldPause(free)
	return free < ns.MIN_FREE_SLOTS
end

--[[
    Pause/resume status prints are held while a merchant, mail, auction, bank,
    gossip, or quest window is open (IsInteractionActive) — otherwise "Resumed"
    is lost in the player's vendoring. ns.state.announcedPaused tracks what the
    player was last told; OnInteractionClosed flushes a held message once the
    window closes.
]]
local function AnnounceStatus()
	if IsInteractionActive() or ns.isPaused == ns.state.announcedPaused then
		return
	end
	if ns.isPaused then
		--[[
            Pause and resume share a single threshold: MIN_FREE_SLOTS. The player
            is paused below it and resumes on reaching it, so the message reports
            MIN_FREE_SLOTS directly — the count it promises is the count that
            actually resumes opening.
        ]]
		ns:StatusPrint(L["PAUSED_BAG_SLOTS"], ns.MIN_FREE_SLOTS)
	else
		ns:StatusPrint(L["RESUMED"])
	end
	ns.state.announcedPaused = ns.isPaused
end

--------------------------------------------------------------------------------
-- Queue System
--------------------------------------------------------------------------------

local queue, queueHead, queueTail = {}, 1, 0

local function QueuePush(bag, slot, itemId)
	queueTail = queueTail + 3
	queue[queueTail - 2], queue[queueTail - 1], queue[queueTail] = bag, slot, itemId
end

local function QueuePop()
	if queueHead > queueTail then
		return nil
	end
	local bag, slot, itemId = queue[queueHead], queue[queueHead + 1], queue[queueHead + 2]
	queueHead = queueHead + 3
	if queueHead > queueTail then
		wipe(queue)
		queueHead, queueTail = 1, 0
	end
	return bag, slot, itemId
end

local function SafeFastItemID(bag, slot)
	local itemId = ns.GetContainerItemID(bag, slot)
	if itemId then
		return itemId
	end
	local link = ns.GetContainerItemLink(bag, slot)
	return link and tonumber(link:match("item:(%d+)"))
end

local function BuildQueue()
	wipe(queue)
	queueHead, queueTail = 1, 0
	for bag = 0, 4 do
		local slots = ns.GetContainerNumSlots(bag)
		for slot = 1, slots or 0 do
			local itemId = SafeFastItemID(bag, slot)
			if itemId and not ns:IsIgnored(itemId) then
				local allowed = ns.AllowedItems[itemId]
				if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
					QueuePush(bag, slot, itemId)
				end
			end
		end
	end
end

--[[
    The locked boxes sitting in the bags waiting on a rogue: allowed but needing
    an unlock, not on the Ignore List, and still reporting LOCKED. Returned as one
    row per distinct item with a stack count, sorted by name, for the mini-map
    tooltip's Locked Items list.

    Computed on demand and deliberately not cached — it runs once per tooltip
    render, not per frame, and a cache would need invalidating on every bag,
    trade, and pick-lock event. IsItemLocked is reached only for ids AllowedItems
    already marks as needing an unlock, so the tooltip scan costs a handful of
    reads rather than one per bag slot.

    The name is taken from the container's own item link, so it arrives already
    localized and quality-coloured without a GetItemInfo round trip.
]]
function ns.GetLockedBoxes()
	local rowsById, rows = {}, {}
	for bag = 0, 4 do
		local slots = ns.GetContainerNumSlots(bag)
		for slot = 1, slots or 0 do
			local itemId = SafeFastItemID(bag, slot)
			if itemId and ns.AllowedItems[itemId] == false and not ns:IsIgnored(itemId) and IsItemLocked(bag, slot) then
				local row = rowsById[itemId]
				if row then
					row.count = row.count + 1
				else
					local link = ns.GetContainerItemLink(bag, slot)
					row = {
						itemId = itemId,
						count = 1,
						icon = GetItemIcon(itemId),
						name = link and link:match("|h%[(.-)%]|h"),
						link = link,
					}
					rowsById[itemId] = row
					rows[#rows + 1] = row
				end
			end
		end
	end
	table.sort(rows, function(a, b)
		if (a.name ~= nil) ~= (b.name ~= nil) then
			return a.name ~= nil
		end
		if a.name and b.name and a.name ~= b.name then
			return a.name < b.name
		end
		return a.itemId < b.itemId
	end)
	return rows
end

local function OpenTick()
	ns.state.openTimerLive = false
	if UnitCastingInfo("player") or UnitChannelInfo("player") then
		ns.state.openTimerLive = true
		C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
		return
	end
	if not IsSafeToOpen() then
		return
	end

	local bag, slot, cachedId = QueuePop()
	if not bag then
		return
	end

	if SafeFastItemID(bag, slot) == cachedId then
		ns.UseContainerItem(bag, slot)
		C_Timer.After(ns.OPEN_RECHECK_DELAY, function()
			local still = SafeFastItemID(bag, slot)
			if still == cachedId and not ns:IsIgnored(still) then
				local allowed = ns.AllowedItems[still]
				if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
					QueuePush(bag, slot, still)
				end
			end
			if IsSafeToOpen() and not ns.state.openTimerLive and queueHead <= queueTail then
				ns.state.openTimerLive = true
				C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
			end
		end)
	end
	if queueHead <= queueTail then
		ns.state.openTimerLive = true
		C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
	end
end

--[[
    RunScan and the debounce callback are file-locals rather than closures built
    inside ScheduleScan: both read only ns.state, so every bag or loot event
    would otherwise allocate two throwaway functions before deciding whether a
    scan is even needed.
]]
local function RunScan()
	ns.state.scanPending = false
	ns.state.lastFreeSlots = ns.GetFreeSlots()
	if ns.isEnabled then
		local shouldPause = ShouldPause(ns.state.lastFreeSlots)
		if shouldPause ~= ns.isPaused then
			ns.isPaused = shouldPause
			if shouldPause then
				ns.state.openTimerLive = false
			end
			if ns.UpdateMinimapIcon then
				ns:UpdateMinimapIcon()
			end
		end
		AnnounceStatus()
	end
	-- Nothing below runs while disabled: skip the bag walk and tick start.
	if not ns.isEnabled then
		return
	end
	BuildQueue()
	if IsSafeToOpen() and not ns.state.openTimerLive and queueHead <= queueTail then
		ns.state.openTimerLive = true
		C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
	end
end

local function OnScanDebounceElapsed()
	if GetTime() >= ns.state.scanTimerAt then
		RunScan()
	end
end

local function ScheduleScan(force)
	if force then
		RunScan()
		return
	end
	local wantAt = GetTime() + ns.SCAN_DEBOUNCE
	if ns.state.scanPending and wantAt >= ns.state.scanTimerAt then
		return
	end
	ns.state.scanPending, ns.state.scanTimerAt = true, wantAt
	C_Timer.After(ns.SCAN_DEBOUNCE, OnScanDebounceElapsed)
end
ns.ScheduleScan = ScheduleScan

--------------------------------------------------------------------------------
-- Profile Application
--------------------------------------------------------------------------------

--[[
    Push the active profile's settings onto the runtime flags and dependent UI.
    Registered on AceDB's profile-change/reset/copy callbacks so switching or
    resetting a profile from the stock Profiles panel takes effect live instead
    of waiting for a reload. Not called on initial login — PLAYER_LOGIN and
    PLAYER_ENTERING_WORLD own the first-time setup and ordering.
]]
local function ApplyProfile()
	ns.isEnabled = ns.db.profile.autoOpen
	ns.isSpeedyLoot = ns.db.profile.speedyLoot

	if ns.isEnabled or ns.isSpeedyLoot then
		ns.EnsureAutoLoot()
	end
	ns.ScheduleScan(true)
	ns:UpdateMinimapIcon()
	if ns.ApplyLootToastPosition then
		ns.ApplyLootToastPosition()
	end
	if ns.ApplyLootToastSettings then
		ns.ApplyLootToastSettings()
	end
	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
	for _, registryName in pairs(ns.OPTIONS_REGISTRY) do
		AceConfigRegistry:NotifyChange(registryName)
	end
end

--------------------------------------------------------------------------------
-- PLAYER_LOGIN, PLAYER_ENTERING_WORLD
--------------------------------------------------------------------------------

local EventHandlers = {}

function EventHandlers:PLAYER_LOGIN()
	ns.db = LibStub("AceDB-3.0"):New("OpenSesameDB", ns.DATABASE_DEFAULTS, true)

	-- Deprecated key: the mini-map subtable moved to the profile under the Simple model.
	if type(ns.db.global.minimap) == "table" then
		ns.db.global.minimap = nil
	end

	-- Deprecated keys: the outline and bold toggles became lootToastFontFlags.
	ns.db.profile.lootToastFontOutline = nil
	ns.db.profile.lootToastFontBold = nil

	ns:SeedIgnoreList()

	ns.isEnabled = ns.db.profile.autoOpen
	ns.isSpeedyLoot = ns.db.profile.speedyLoot

	ns:RegisterOptionsPanels()

	ns.db.RegisterCallback(ns, "OnProfileChanged", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileReset", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileCopied", ApplyProfile)

	if ns.ApplyLootToastPosition then
		ns.ApplyLootToastPosition()
	end
	--[[
        Toasts ship on, so a profile that has never dismissed the drag handle is
        shown it here: the feature introducing itself, once, rather than a player
        meeting it as loot drawn somewhere they did not choose. It stays up until
        they put it away.
    ]]
	if ns.ShowLootToastIntro then
		ns.ShowLootToastIntro()
	end
	if ns.InitMinimap then
		ns:InitMinimap()
	end
	--[[
        Deliberately hooked HERE rather than while Lockbox-Tooltips.lua loads.
        Tooltip post-hooks run in the order they were registered, and by
        PLAYER_LOGIN every add-on has loaded and hooked, so ours runs after
        theirs and our block reads last. See the note above the hook itself.
    ]]
	if ns.InstallTooltipHook then
		ns.InstallTooltipHook()
	end
	ns:UpdateMinimapIcon()
	PrintWelcome()
end

function EventHandlers:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
	if isInitialLogin or isReloadingUi then
		C_Timer.After(ns.WORLD_LOAD_DELAY, function()
			ns.state.lastFreeSlots = ns.GetFreeSlots()
			if ns.isEnabled then
				ns.isPaused = ShouldPause(ns.state.lastFreeSlots)
				ns.state.announcedPaused = ns.isPaused
				ns.ScheduleScan(true)
			end
			if ns.isEnabled or ns.isSpeedyLoot then
				ns.EnsureAutoLoot()
			end
			ns:UpdateMinimapIcon()
		end)
	else
		ns:SetQuiet(2)
		-- Zoning out of an instance can lift the Where hold-off, so rescan.
		ns.ScheduleScan()
	end
end

--------------------------------------------------------------------------------
-- Combat, Stealth, Spellcast
--------------------------------------------------------------------------------

function EventHandlers:PLAYER_REGEN_ENABLED()
	if ns.isEnabled then
		ScheduleScan(true)
	end
end

function EventHandlers:UPDATE_STEALTH()
	if not IsPlayerStealthed() and ns.isEnabled then
		ScheduleScan(true)
	end
end

--[[
    A successful Pick Pocket cast ARMS the sound; it does not play it. The cast
    succeeding says nothing about whether the pockets held anything -- picking a
    target whose pockets are already emptied fires this event and a
    "Your target has already had its pockets picked" error together -- so what the
    player hears has to wait for loot to actually turn up. See PlayPickPocketSound.
]]
function EventHandlers:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
	if unit ~= "player" then
		return
	end
	if spellID == ns.SPELLS.PICK_LOCK then
		C_Timer.After(ns.PICK_LOCK_RESCAN_DELAY, function()
			ns.ScheduleScan(true)
		end)
	elseif spellID == ns.SPELLS.PICK_POCKET then
		ns.state.pickPocketAt = GetTime()
	end
end

--------------------------------------------------------------------------------
-- UI_ERROR_MESSAGE
--------------------------------------------------------------------------------

function EventHandlers:UI_ERROR_MESSAGE(errTypeOrID)
	if not ns.isEnabled then
		return
	end
	if ns.IsBagFullErrorID(errTypeOrID) then
		local now = GetTime()
		if (now - ns.state.lastBagFullAt) > ns.BAG_FULL_COOLDOWN then
			ns.state.lastBagFullAt = now
			ns.isPaused = true
			ns.state.announcedPaused = true
			ns.state.openTimerLive = false
			ns:UpdateMinimapIcon()
			ns:StatusPrint(L["INVENTORY_FULL"])
			PlayBagFullSound()
		end
	end
end

--------------------------------------------------------------------------------
-- Bag, Loot, Interaction Events
--------------------------------------------------------------------------------

local function OnScanRequest()
	ScheduleScan()
end
local function OnInteractionClosed()
	ScheduleScan(true)
	C_Timer.After(ns.STATUS_FLUSH_DELAY, AnnounceStatus)
end
local function OnLoadStart()
	ns:SetQuiet(10)
end
local function OnLoadEnd()
	ns:SetQuiet(3)
end

--[[
    Distinguishes genuine corpse/chest looting from item-produced loot. A loot
    window alone is not enough: disenchanting, prospecting/milling, opening a
    container, and the server's white-into-green item merge all deliver their
    results through the same LOOT_OPENED + CHAT_MSG_LOOT path a corpse does. They
    differ only in the loot source GUID — an item carries an "Item-..." source,
    a corpse is "Creature-..."/"Vehicle-...", and a chest/node is "GameObject-...".

    Returns one of three states so StampWorldLoot can treat each differently:
    "world" when at least one open slot is a corpse/chest/node
    (Creature-/Vehicle-/GameObject-); "item" when every resolved source is an
    item (Item-) — disenchant, prospect/mill, container open, or the
    white-into-green merge; and "unknown" when there is nothing to go on yet,
    i.e. the window is empty or the GUIDs have not populated. "unknown" is kept
    distinct from "item" on purpose: source info can arrive late (and Speedy Loot
    may loot instantly), so a not-yet-populated corpse must not be mistaken for
    item loot.
]]
local function CurrentLootFromWorldSource()
	local numItems = GetNumLootItems()
	local sawItem = false
	for slot = 1, numItems do
		local guid = GetLootSourceInfo(slot)
		local guidType = guid and guid:match("^(%a+)")
		if guidType == "Creature" or guidType == "Vehicle" or guidType == "GameObject" then
			return "world"
		elseif guidType == "Item" then
			sawItem = true
		end
	end
	if sawItem then
		return "item"
	end
	return "unknown"
end

--[[
    Drive lastWorldLootAt, the timestamp that gates the loot sound in
    CHAT_MSG_LOOT, from the classified source:

      world   - stamp now. Run on both LOOT_READY and LOOT_OPENED because the
                source GUID can populate on either and Speedy Loot may empty the
                slots between them; whichever event sees the world GUID records it.
      item    - clear the stamp so a disenchant or merge within LOOT_SOUND_WINDOW
                of a real corpse loot can't reuse that window and play the sound.
      unknown - leave it alone: a late-arriving world GUID on a later event must
                still be able to stamp, and a stamp just set for this same corpse
                must survive an empty or not-yet-populated re-read.
]]
local function StampWorldLoot()
	local source = CurrentLootFromWorldSource()
	if source == "world" then
		ns.state.lastWorldLootAt = GetTime()
	elseif source == "item" then
		ns.state.lastWorldLootAt = 0
	end
end

--[[
    The other half of the Pick Pocket sound, and the half that decides whether it
    is heard at all: a loot window with something in it, opening within
    PICK_POCKET_LOOT_WINDOW of the cast. A pickpocket that yields nothing opens no
    window, so nothing here fires and the arming simply times out -- which is the
    whole point, because the cast alone succeeds either way.

    Disarms as it plays, so the one cast sounds once no matter how many loot
    events the window generates on the way through.

    MUST BE CALLED BEFORE ns.HandleSpeedyLoot: Speedy Loot empties the slots, and
    an emptied window is indistinguishable from a pickpocket that came up empty.
]]
local function PlayPickPocketSound()
	if ns.state.pickPocketAt == 0 or not ns.db or not ns.db.profile.pickPocketSound then
		return
	end
	if (GetTime() - ns.state.pickPocketAt) >= ns.PICK_POCKET_LOOT_WINDOW or GetNumLootItems() == 0 then
		return
	end
	ns.state.pickPocketAt = 0
	PlaySound(ns.PICK_POCKET_SOUND, "Master")
end

--[[
    One registration owns LOOT_READY. Stamp world-loot state first so the source
    GUIDs are read while the slots are still populated, then run Speedy Loot,
    which empties them via LootSlot. This is the order the two former event
    frames relied on; making it explicit also removes their non-deterministic
    dispatch order.
]]
function EventHandlers:LOOT_READY()
	StampWorldLoot()
	PlayPickPocketSound()
	ns.HandleSpeedyLoot()
end

function EventHandlers:LOOT_OPENED()
	StampWorldLoot()
	PlayPickPocketSound()
end

--[[
    Clear Speedy Loot's window-suppression verdict when the loot session ends, so
    a throttled LOOT_READY on the next corpse can't reuse this corpse's "fully
    looted" state to hide a window that still has items in it. Registered
    automatically like every handler here (see the EventHandlers loop below).
]]
function EventHandlers:LOOT_CLOSED()
	if ns.ResetSpeedyLootWindow then
		ns.ResetSpeedyLootWindow()
	end
end

EventHandlers.BAG_UPDATE_DELAYED = OnScanRequest
EventHandlers.BAG_NEW_ITEMS_UPDATED = OnScanRequest
-- Joining or leaving a group can flip the Group hold-off either way.
EventHandlers.GROUP_ROSTER_UPDATE = OnScanRequest

--[[
    The Ignore List panel draws item links, and GetItemInfo returns nil until the
    client has the item cached. Options-Utilities sets ns.OnItemInfoReceived while
    any row is still uncached and clears it once nothing is outstanding; routing
    it through the dispatcher rather than a private frame keeps the single
    registration rule and puts the event in ns.EVENT_NAMES for the diagnostics
    probe.
]]
function EventHandlers:GET_ITEM_INFO_RECEIVED(itemId)
	if ns.OnItemInfoReceived then
		ns.OnItemInfoReceived(itemId)
	end
end

--[[
    Coin is the loot Speedy Loot hides most completely: it has no item, no quality
    and no link, so nothing else in this file has anything to say about it, and
    with the loot window gone the only record is the chat line this event carries.
    The amount comes back out of that sentence -- see ns.ParseMoney.
]]
function EventHandlers:CHAT_MSG_MONEY(msg)
	if ns.ShowMoneyToast then
		ns.ShowMoneyToast(ns.ParseMoney(msg))
	end
end

function EventHandlers:CHAT_MSG_LOOT(msg)
	if not msg then
		OnScanRequest()
		return
	end

	if
		not (
			(lootSelfPrefix and msg:find(lootSelfPrefix, 1, true))
			or (lootPushedPrefix and msg:find(lootPushedPrefix, 1, true))
		)
	then
		OnScanRequest()
		return
	end

	local link = msg:match("(|c%x+|Hitem:.-|h%[.-%]|h|r)")
	if not link then
		OnScanRequest()
		return
	end

	local itemId = tonumber(link:match("item:(%d+)"))

	if
		itemId
		and ns.AllowedItems
		and ns.AllowedItems[itemId] == false
		and not ns:IsIgnored(itemId)
		and ns.db.profile.autoOpen
		and ns.LockboxNotificationsEnabled()
	then
		ns:PrintMessage(string.format(L["ITEM_WILL_AUTO_OPEN"], link))
	end

	if itemId and ns:IsIgnored(itemId) and ns.db.profile.ignoreListNotifications then
		ns:AnnounceItemOnce("ITEM_IGNORED", itemId, link)
	end

	--[[
        Only sound off for loot that came from a corpse or chest within the last
        ns.LOOT_SOUND_WINDOW seconds. Item-produced loot (disenchant, prospect,
        merge, container opens) never stamps lastWorldLootAt, so it stays silent
        even though it travels the same loot + CHAT_MSG_LOOT path.
    ]]
	if ns.db.profile.lootSounds and (GetTime() - ns.state.lastWorldLootAt) < ns.LOOT_SOUND_WINDOW then
		local quality = ns.GetLinkQuality(link)
		if quality and quality >= ns.db.profile.lootSoundThreshold then
			PlaySoundFile(ns.LOOT_SOUND_FILE, "Master")
		end
	end

	if ns.ShowLootToast then
		ns.ShowLootToast(link, msg)
	end

	OnScanRequest()
end

EventHandlers.BANKFRAME_CLOSED = OnInteractionClosed
EventHandlers.GOSSIP_CLOSED = OnInteractionClosed
EventHandlers.MAIL_CLOSED = OnInteractionClosed
EventHandlers.MERCHANT_CLOSED = OnInteractionClosed
EventHandlers.QUEST_FINISHED = OnInteractionClosed
EventHandlers.PLAYER_INTERACTION_MANAGER_FRAME_HIDE = OnInteractionClosed
EventHandlers.LOADING_SCREEN_ENABLED = OnLoadStart
EventHandlers.LOADING_SCREEN_DISABLED = OnLoadEnd

--[[
    Trade close needs more than the shared immediate rescan. When another rogue
    picks the locks on boxes sitting in the trade window there is no event on our
    side to hear it — UNIT_SPELLCAST_SUCCEEDED only fires for our own casts — and
    the freshly unlocked state often has not settled client-side by the time
    TRADE_CLOSED fires, so an immediate scan still reads the boxes as locked. Run
    the shared immediate scan, then a second forced scan after
    PICK_LOCK_RESCAN_DELAY (the same settle delay our own Pick Lock uses) so boxes
    another rogue unlocked open on their own instead of sitting in the bags until
    the next bag update.
]]
function EventHandlers:TRADE_CLOSED()
	OnInteractionClosed()
	C_Timer.After(ns.PICK_LOCK_RESCAN_DELAY, function()
		ns.ScheduleScan(true)
	end)
end

--------------------------------------------------------------------------------
-- Event Frame
--------------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	if ns.diagnostics and ns.diagnostics.logging then
		ns:LogEvent(event, ...)
	end
	if EventHandlers[event] then
		EventHandlers[event](self, ...)
	end
end)

--[[
    Exported for Features/Diagnostics.lua so the event probe can never drift
    from the events the addon actually registers.
]]
ns.EVENT_NAMES = {}
for event in pairs(EventHandlers) do
	ns.EVENT_NAMES[#ns.EVENT_NAMES + 1] = event
end
table.sort(ns.EVENT_NAMES)

--[[
    Register only events valid on the running client. Every event in the list is
    valid on both target clients today; the check guards future builds where an
    event name may not exist, so one bad name can't abort the whole loop.
]]
local IsEventValid = C_EventUtils.IsEventValid
for event in pairs(EventHandlers) do
	if IsEventValid(event) then
		--[[
            UNIT_SPELLCAST_SUCCEEDED fires for every unit; only the player's own
            Pick Lock matters here, so filter it to "player" at registration to
            avoid waking on every group member's cast. The handler keeps its
            unit == "player" guard as a belt-and-suspenders check.
        ]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			eventFrame:RegisterUnitEvent(event, "player")
		else
			eventFrame:RegisterEvent(event)
		end
	end
end
