local _, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L

--------------------------------------------------------------------------------
-- API References
--------------------------------------------------------------------------------

local C_Timer, UnitAffectingCombat, GetTime = C_Timer, UnitAffectingCombat, GetTime
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
	if raceEnglish and ns.RACE_SOUNDS[raceEnglish] and ns.RACE_SOUNDS[raceEnglish][gender] then
		PlaySound(ns.RACE_SOUNDS[raceEnglish][gender], "Master")
	else
		PlaySound(ns.BAG_FULL_SOUND_FALLBACK, "Master")
	end
end

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
				if allowed == true or (allowed == false and not ns.IsItemLocked(bag, slot)) then
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
				and ns.AllowedItems[itemId] == false
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
				if allowed == true or (allowed == false and not ns.IsItemLocked(bag, slot)) then
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
			ns:StatusPrint(L["INVENTORY_FULL"])
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
		and ns.AllowedItems
		and ns.AllowedItems[itemId] == false
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
