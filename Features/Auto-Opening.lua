local _, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L

--------------------------------------------------------------------------------
-- API References
--------------------------------------------------------------------------------

local C_Timer, UnitAffectingCombat, GetTime, UnitLevel = C_Timer, UnitAffectingCombat, GetTime, UnitLevel
local tonumber, wipe, UnitRace, UnitSex = tonumber, wipe, UnitRace, UnitSex
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

--[[
    All three target clients expose C_UnitAuras.GetBuffDataByIndex, which
    returns a named-field table and so sidesteps the old UnitBuff
    return-position problem (Era put spellId at 10, TBC's extra rank return
    shifted it to 11).
]]
local GetBuffDataByIndex = C_UnitAuras.GetBuffDataByIndex

local function GetPlayerBuffSpellID(index)
	local data = GetBuffDataByIndex("player", index)
	return data and data.spellId
end

--------------------------------------------------------------------------------
-- Safety Checks
--------------------------------------------------------------------------------

local function PlayBagFullSound()
	local _, raceEnglish = UnitRace("player")
	local gender = UnitSex("player")
	if
		raceEnglish
		and ns.SOUND_KIT_IDS.BAG_FULL_BY_RACE[raceEnglish]
		and ns.SOUND_KIT_IDS.BAG_FULL_BY_RACE[raceEnglish][gender]
	then
		PlaySound(ns.SOUND_KIT_IDS.BAG_FULL_BY_RACE[raceEnglish][gender], "Master")
	else
		PlaySound(ns.SOUND_KIT_IDS.BAG_FULL_FALLBACK, "Master")
	end
end

--[[
    On WoW Forever, aura and cast reads can come back secret, and a secret value
    errors when compared. C_Secrets is asked first, and an answer that would be
    secret reads as "not safe to open".
]]
local function IsPlayerStealthed()
	if IsStealthed() then
		return true
	end
	if C_Secrets.ShouldAurasBeSecret() then
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

local function IsPlayerCasting()
	if C_Secrets.ShouldUnitSpellCastingBeSecret("player") then
		return true
	end
	return UnitCastingInfo("player") or UnitChannelInfo("player")
end

local function IsInteractionActive()
	return (MerchantFrame and MerchantFrame:IsShown())
		or (MailFrame and MailFrame:IsShown())
		or (TradeFrame and TradeFrame:IsShown())
		or (BankFrame and BankFrame:IsShown())
		or (GuildBankFrame and GuildBankFrame:IsShown())
		or (AuctionFrame and AuctionFrame:IsShown())
		or (AuctionHouseFrame and AuctionHouseFrame:IsShown())
		or (GossipFrame and GossipFrame:IsShown())
		or (QuestFrame and QuestFrame:IsShown())
		or (LootFrame and LootFrame:IsShown())
end

--[[
    The player is busy with something no event reports the end of: an item
    under the cursor, or an open confirmation pop-up. The tick waits these out
    itself rather than stopping, since nothing would start it again.
]]
local function IsWaitingOnPlayer()
	if StaticPopup1 and StaticPopup1:IsShown() then
		return true
	end
	-- The player is looking at an item; opening under the cursor would move it.
	if GameTooltip:IsShown() then
		local hasItem, itemLink = GameTooltip:GetItem()
		if hasItem or itemLink then
			return true
		end
	end
	return false
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
	if IsPlayerCasting() then
		return false
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
    player was last told; Core's OnInteractionClosed flushes a held message once
    the window closes.
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
ns.AnnounceStatus = AnnounceStatus

--------------------------------------------------------------------------------
-- Queue System
--------------------------------------------------------------------------------

local queue, queueHead, queueTail = {}, 1, 0

--[[
    The open still waiting on its answer. A container the game opens answers
    with a loot window, so one still unanswered ns.OPEN_ANSWER_TIMEOUT later was
    refused: a holiday, or another rule no API reports, rules it out for this
    character. After ns.OPEN_REFUSAL_LIMIT refusals in a row the item is left
    alone until the next level-up or login, rather than tried every tick into
    the same red error.
]]
local pendingOpenItem, pendingOpenAt = nil, 0
local refusedOpenCounts = {}
local refusedItems = {}

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

local function ShouldOpen(bag, slot, itemId)
	if ns:IsIgnored(itemId) or refusedItems[itemId] then
		return false
	end
	local allowed = ns.ALLOWED_ITEMS[itemId]
	if allowed == nil then
		return false
	end
	-- Uncached reads nil and is tried; the refusal count catches it if the game says no.
	local requiredLevel = select(5, C_Item.GetItemInfo(itemId))
	if requiredLevel and requiredLevel > UnitLevel("player") then
		return false
	end
	return allowed == true or not ns.IsItemLocked(bag, slot)
end

-- The last open went unanswered past its timeout, so it counts toward setting its item aside.
local function CountRefusedOpen()
	if not pendingOpenItem then
		return
	end
	local count = (refusedOpenCounts[pendingOpenItem] or 0) + 1
	refusedOpenCounts[pendingOpenItem] = count
	if count >= ns.OPEN_REFUSAL_LIMIT then
		refusedItems[pendingOpenItem] = true
	end
	pendingOpenItem = nil
end

local function BuildQueue()
	wipe(queue)
	queueHead, queueTail = 1, 0
	for bag = 0, 4 do
		local slots = ns.GetContainerNumSlots(bag)
		for slot = 1, slots or 0 do
			local itemId = SafeFastItemID(bag, slot)
			if itemId and ShouldOpen(bag, slot, itemId) then
				QueuePush(bag, slot, itemId)
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
    trade, and pick-lock event. IsItemLocked is reached only for ids ALLOWED_ITEMS
    already marks as needing an unlock, so the tooltip scan costs a handful of
    reads rather than one per bag slot.

    The name is taken from the container's own item link, so it arrives already
    localized and quality-coloured without a C_Item.GetItemInfo round trip.
]]
function ns.GetLockedBoxes()
	local rowsById, rows = {}, {}
	for bag = 0, 4 do
		local slots = ns.GetContainerNumSlots(bag)
		for slot = 1, slots or 0 do
			local itemId = SafeFastItemID(bag, slot)
			if
				itemId
				and ns.ALLOWED_ITEMS[itemId] == false
				and not ns:IsIgnored(itemId)
				and ns.IsItemLocked(bag, slot)
			then
				local row = rowsById[itemId]
				if row then
					row.count = row.count + 1
				else
					local link = ns.GetContainerItemLink(bag, slot)
					row = {
						itemId = itemId,
						count = 1,
						icon = ns.GetItemIconByID(itemId),
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

--------------------------------------------------------------------------------
-- Open Tick
--------------------------------------------------------------------------------

local function OpenTick()
	ns.state.openTimerLive = false
	if UnitAffectingCombat("player") then
		return
	end
	if IsPlayerCasting() then
		ns.state.openTimerLive = true
		C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
		return
	end
	if not IsSafeToOpen() or queueHead > queueTail then
		return
	end
	if IsWaitingOnPlayer() then
		ns.state.openTimerLive = true
		C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
		return
	end
	-- The last open's loot may still be on its way; the next one waits for it or for its timeout.
	if pendingOpenItem and GetTime() - pendingOpenAt < ns.OPEN_ANSWER_TIMEOUT then
		ns.state.openTimerLive = true
		C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
		return
	end
	CountRefusedOpen()

	local bag, slot, cachedId = QueuePop()

	if SafeFastItemID(bag, slot) == cachedId and not refusedItems[cachedId] then
		pendingOpenItem, pendingOpenAt = cachedId, GetTime()
		ns.UseContainerItem(bag, slot)
		C_Timer.After(ns.OPEN_RECHECK_DELAY, function()
			local still = SafeFastItemID(bag, slot)
			if still == cachedId and ShouldOpen(bag, slot, still) then
				QueuePush(bag, slot, still)
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

--------------------------------------------------------------------------------
-- Scan
--------------------------------------------------------------------------------

--[[
    RunScan and the debounce callback are file-locals rather than closures built
    inside ScheduleScan: both read only ns.state, so every bag or loot event
    would otherwise allocate two throwaway functions before deciding whether a
    scan is even needed.
]]
local function RunScan()
	ns.state.scanPending = false
	-- An event can reach here before PLAYER_LOGIN has built the database.
	if not ns.db then
		return
	end
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
	-- Nothing below runs while disabled or in combat: skip the bag walk and tick start.
	if not ns.isEnabled or UnitAffectingCombat("player") then
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

function ns.ScheduleScan(force)
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

--------------------------------------------------------------------------------
-- Event Responses
--------------------------------------------------------------------------------

-- Called by Core's PLAYER_ENTERING_WORLD, ns.WORLD_LOAD_DELAY after a login or reload.
function ns.OnWorldLoaded()
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
end

-- A loot window answers the last open, so the game took it.
function ns.OnOpenAnswered()
	if pendingOpenItem then
		refusedOpenCounts[pendingOpenItem] = nil
		pendingOpenItem = nil
	end
end

-- A level-up can lift a level requirement, so every item set aside gets another try.
function ns.OnLevelUp()
	wipe(refusedItems)
	wipe(refusedOpenCounts)
	if ns.isEnabled then
		ns.ScheduleScan()
	end
end

function ns.OnCombatEnded()
	if ns.isEnabled then
		ns.ScheduleScan(true)
	end
end

function ns.OnStealthChanged()
	if UnitAffectingCombat("player") then
		return
	end
	if not IsPlayerStealthed() and ns.isEnabled then
		ns.ScheduleScan(true)
	end
end

--[[
    A lock just picked has not settled client-side the moment the cast lands, so
    the rescan waits PICK_LOCK_RESCAN_DELAY. Core also runs this on TRADE_CLOSED,
    for boxes another rogue unlocked in the trade window.
]]
function ns.RescanAfterUnlock()
	C_Timer.After(ns.PICK_LOCK_RESCAN_DELAY, function()
		ns.ScheduleScan(true)
	end)
end

function ns.OnBagFullError(errTypeOrID)
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
			ns:StatusPrint(ERR_INV_FULL)
			PlayBagFullSound()
		end
	end
end

local function LockboxNotificationsEnabled()
	return ns.db ~= nil
		and ns.db.profile.lockboxNotifications
		and ns.LockboxScopeAllows(ns.db.profile.lockboxNotificationsScope)
end

--[[
    What the player is told about a container they just looted: a locked box
    that will open itself once picked, or an item the Ignore List keeps it from
    touching.
]]
function ns.AnnounceLootedContainer(itemId, link)
	if
		itemId
		and ns.ALLOWED_ITEMS
		and ns.ALLOWED_ITEMS[itemId] == false
		and not ns:IsIgnored(itemId)
		and ns.db.profile.autoOpen
		and LockboxNotificationsEnabled()
	then
		ns:PrintMessage(string.format(L["ITEM_WILL_AUTO_OPEN"], link))
	end

	if itemId and ns:IsIgnored(itemId) and ns.db.profile.ignoreListNotifications then
		ns:AnnounceItemOnce("ITEM_IGNORED", itemId, link)
	end
end
