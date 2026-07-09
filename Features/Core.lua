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

local function GetPlayerBuffSpellID(index)
	if C_UnitAuras and C_UnitAuras.GetBuffDataByIndex then
		local data = C_UnitAuras.GetBuffDataByIndex("player", index)
		return data and data.spellId
	end
	-- Classic ERA: spellId at position 10. TBC: rank at position 2 shifts spellId to position 11.
	-- Read both; use the one that is a number (the other will be nil or boolean).
	local _, _, _, _, _, _, _, _, _, pos10, pos11 = _G.UnitBuff("player", index)
	if type(pos10) == "number" then
		return pos10
	end
	if type(pos11) == "number" then
		return pos11
	end
	return nil
end
local GetCVarBool = (C_CVar and C_CVar.GetCVarBool) or function(cvar)
	return GetCVar(cvar) == "1"
end
local SetCVar = (C_CVar and C_CVar.SetCVar) or _G.SetCVar

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
    Add-on identity. Read from TOC metadata; the @project-version@ token is only
    replaced at build time, so an unreplaced token (the @ is the signal) means a
    local dev copy and displays as "Dev".
]]
local GetMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local version = GetMetadata and GetMetadata(ADDON_NAME, "Version") or "Dev"
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
		ns.PrintMessage(L["AUTO_LOOT_ENABLED"])
	end
end

local function PrintWelcome()
	if not ns.db.profile.showWelcome then
		return
	end
	ns.PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
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

local scanTooltip = CreateFrame("GameTooltip", "OS_ScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function IsItemLocked(bag, slot)
	scanTooltip:ClearLines()
	scanTooltip:SetBagItem(bag, slot)
	for lineIndex = 1, scanTooltip:NumLines() do
		local line = _G["OS_ScanTooltipTextLeft" .. lineIndex]
		local text = line and line:GetText()
		if text and text == LOCKED then
			return true
		end
	end
	return false
end

local function IsPlayerStealthed()
	if _G.IsStealthed and _G.IsStealthed() then
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
	if UnitAffectingCombat("player") or IsInteractionActive() or IsPlayerStealthed() then
		return false
	end
	if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
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
	return ns.isPaused and free < (ns.MIN_FREE_SLOTS + 1) or free < ns.MIN_FREE_SLOTS
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
            Resume only fires once free slots reach MIN_FREE_SLOTS + 1 (the
            ShouldPause hysteresis). This message promises the resume count, so it
            must format with + 1 — using MIN_FREE_SLOTS itself tells the player
            they need 4 free slots when 4 still leaves them paused.
        ]]
		ns.StatusPrint(L["PAUSED_BAG_SLOTS"], ns.MIN_FREE_SLOTS + 1)
	else
		ns.StatusPrint(L["RESUMED"])
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
			if itemId then
				local allowed = ns.AllowedItems[itemId]
				if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
					QueuePush(bag, slot, itemId)
				end
			end
		end
	end
end

local function OpenTick()
	ns.state.openTimerLive = false
	if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
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
			if still == cachedId then
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

local function ScheduleScan(force)
	local function run()
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
					ns.UpdateMinimapIcon()
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

	if force then
		run()
		return
	end
	local wantAt = GetTime() + ns.SCAN_DEBOUNCE
	if ns.state.scanPending and wantAt >= ns.state.scanTimerAt then
		return
	end
	ns.state.scanPending, ns.state.scanTimerAt = true, wantAt
	C_Timer.After(ns.SCAN_DEBOUNCE, function()
		if GetTime() >= ns.state.scanTimerAt then
			run()
		end
	end)
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

	if ns.SetMinimapShown then
		ns.SetMinimapShown(ns.db.profile.showMinimap)
	end
	if ns.isEnabled or ns.isSpeedyLoot then
		ns.EnsureAutoLoot()
	end
	ns.ScheduleScan(true)
	ns.UpdateMinimapIcon()
	LibStub("AceConfigRegistry-3.0"):NotifyChange(ns.OPTIONS_REGISTRY.General)
end

--------------------------------------------------------------------------------
-- PLAYER_LOGIN, PLAYER_ENTERING_WORLD
--------------------------------------------------------------------------------

local EventHandlers = {}

function EventHandlers:PLAYER_LOGIN()
	ns.db = LibStub("AceDB-3.0"):New("OpenSesameDB", ns.DATABASE_DEFAULTS, true)

	--[[
        MIGRATION (remove after 2026-10-06): move flat OpenSesameDB settings into AceDB profile
        The pre-AceDB model stored each setting as a flat top-level key on
        OpenSesameDB and the minimap position at OpenSesameDB.minimap. AceDB
        leaves unknown top-level keys untouched, so lift them into the profile
        (and the minimap table into global) once, then clear them so the leftover
        state can't shadow future edits.
    ]]
	for _, key in ipairs({
		"autoOpen",
		"speedyLoot",
		"lootSounds",
		"showWelcome",
		"showMinimap",
		"lockboxNotifications",
	}) do
		if OpenSesameDB[key] ~= nil then
			ns.db.profile[key] = OpenSesameDB[key]
			OpenSesameDB[key] = nil
		end
	end
	if type(OpenSesameDB.minimap) == "table" then
		for field, value in pairs(OpenSesameDB.minimap) do
			if ns.db.global.minimap[field] == nil then
				ns.db.global.minimap[field] = value
			end
		end
		OpenSesameDB.minimap = nil
	end

	ns.isEnabled = ns.db.profile.autoOpen
	ns.isSpeedyLoot = ns.db.profile.speedyLoot

	-- Re-derive the LibDBIcon hide flag from showMinimap so a profile reset restores the button to on.
	ns.db.global.minimap.hide = not ns.db.profile.showMinimap

	ns.db.RegisterCallback(ns, "OnProfileChanged", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileReset", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileCopied", ApplyProfile)

	if ns.InitMinimap then
		ns.InitMinimap()
	end
	ns.UpdateMinimapIcon()
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
			ns.UpdateMinimapIcon()
		end)
	else
		ns.SetQuiet(2)
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

function EventHandlers:UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellID)
	if unit == "player" and spellID == ns.SPELLS.PICK_LOCK then
		C_Timer.After(ns.PICK_LOCK_RESCAN_DELAY, function()
			ns.ScheduleScan(true)
		end)
	end
end

--------------------------------------------------------------------------------
-- UI_ERROR_MESSAGE
--------------------------------------------------------------------------------

function EventHandlers:UI_ERROR_MESSAGE(errTypeOrID, msg)
	local isBagFull = (msg and msg:find(ERR_INV_FULL or "Inventory is full", 1, true))
	if not isBagFull and type(errTypeOrID) == "number" then
		isBagFull = (errTypeOrID == (LE_GAME_ERR_INV_FULL or 0))
			or (Enum and Enum.UIERRORS and errTypeOrID == Enum.UIERRORS.ERR_INV_FULL)
	end
	if isBagFull then
		local now = GetTime()
		if (now - ns.state.lastBagFullAt) > ns.BAG_FULL_COOLDOWN then
			ns.state.lastBagFullAt = now
			ns.isPaused = true
			ns.state.announcedPaused = true
			ns.state.openTimerLive = false
			ns.UpdateMinimapIcon()
			ns.StatusPrint(L["INVENTORY_FULL"])
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
	ns.SetQuiet(10)
end
local function OnLoadEnd()
	ns.SetQuiet(3)
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
    i.e. GetLootSourceInfo is missing, the window is empty, or the GUIDs have not
    populated. "unknown" is kept distinct from "item" on purpose: source info can
    arrive late (and Speedy Loot may loot instantly), so a not-yet-populated
    corpse must not be mistaken for item loot.
]]
local function CurrentLootFromWorldSource()
	if type(GetLootSourceInfo) ~= "function" then
		return "unknown"
	end
	local numItems = (GetNumLootItems and GetNumLootItems()) or 0
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
    One registration owns LOOT_READY. Stamp world-loot state first so the source
    GUIDs are read while the slots are still populated, then run Speedy Loot,
    which empties them via LootSlot. This is the order the two former event
    frames relied on; making it explicit also removes their non-deterministic
    dispatch order.
]]
function EventHandlers:LOOT_READY()
	StampWorldLoot()
	ns.HandleSpeedyLoot()
end

function EventHandlers:LOOT_OPENED()
	StampWorldLoot()
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
		and ns.db.profile.autoOpen
		and ns.db.profile.lockboxNotifications
	then
		ns.PrintMessage(string.format(L["ITEM_WILL_AUTO_OPEN"], link))
	end

	--[[
        Only sound off for loot that came from a corpse or chest within the last
        ns.LOOT_SOUND_WINDOW seconds. Item-produced loot (disenchant, prospect,
        merge, container opens) never stamps lastWorldLootAt, so it stays silent
        even though it travels the same loot + CHAT_MSG_LOOT path.
    ]]
	if ns.db.profile.lootSounds and (GetTime() - ns.state.lastWorldLootAt) < ns.LOOT_SOUND_WINDOW then
		local colorSequence = link:match("|c(%x+)|H")
		if colorSequence and #colorSequence == 8 then
			local hex = string.lower(string.sub(colorSequence, 3, 8))
			if hex ~= "9d9d9d" and hex ~= "ffffff" then
				PlaySound(ns.LOOT_SOUND_ID, "Master")
			end
		end
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
    Register only events valid on the running client. Harmless on current
    builds (every event is valid on 11508/20505); guards future builds where
    an event name may not exist, so one bad name can't abort the whole loop.
]]
local IsEventValid = C_EventUtils and C_EventUtils.IsEventValid
for event in pairs(EventHandlers) do
	if IsEventValid then
		if IsEventValid(event) then
			eventFrame:RegisterEvent(event)
		end
	else
		pcall(eventFrame.RegisterEvent, eventFrame, event)
	end
end
