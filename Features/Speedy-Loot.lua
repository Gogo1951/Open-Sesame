local _, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L

--------------------------------------------------------------------------------
-- API Compatibility
--------------------------------------------------------------------------------

--[[
    Pick the auto-loot CVar API by availability, not by truthy result. The
    previous `(modern call) or (legacy call)` pattern fell through to the
    legacy check whenever the modern API returned false (auto-loot off).
]]
local IsAutoLootEnabled
if C_CVar and C_CVar.GetCVarBool then
	IsAutoLootEnabled = function()
		return C_CVar.GetCVarBool("autoLootDefault")
	end
else
	IsAutoLootEnabled = function()
		return GetCVar("autoLootDefault") == "1"
	end
end

--[[
    Returns (method, masterLooterPartyID). The legacy GetLootMethod returns the
    method as a string ("master", ...); C_PartyInfo.GetLootMethod returns it as an
    enum NUMBER. Enum.LootMethod is nil on some Classic builds (2.5.5), so map the
    enum to the legacy string form, falling back to its numeric value 2 for master.
]]
local GetLootMethodCompat
if type(GetLootMethod) == "function" then
	GetLootMethodCompat = function()
		return GetLootMethod()
	end
elseif C_PartyInfo and C_PartyInfo.GetLootMethod then
	GetLootMethodCompat = function()
		local methodEnum, masterLooterPartyID = C_PartyInfo.GetLootMethod()
		if (Enum and Enum.LootMethod and methodEnum == Enum.LootMethod.MasterLoot) or methodEnum == 2 then
			return "master", masterLooterPartyID
		end
		return methodEnum, masterLooterPartyID
	end
else
	GetLootMethodCompat = function()
		return "freeforall"
	end
end

--------------------------------------------------------------------------------
-- Loot Slot Type
--------------------------------------------------------------------------------

--[[
    Money and currency slots take no bag space, so they must never count against
    the free-slot budget. When GetLootSlotType is unavailable, treat every slot
    as an item (conservative: counts against the budget).
]]
local function IsItemLootSlot(slot)
	if type(GetLootSlotType) ~= "function" then
		return true
	end
	return GetLootSlotType(slot) == (LOOT_SLOT_ITEM or 1)
end

--------------------------------------------------------------------------------
-- Loot Window Suppression
--------------------------------------------------------------------------------

--[[
    True only when the most recent Speedy Loot pass took everything, so nothing
    was left in the loot window. The LootFrame OnShow hook at the bottom of this
    file re-hides the window the instant the default UI re-shows it on
    LOOT_OPENED. That re-show is what makes the window flash for ~0.5s: a plain
    LootFrame:Hide() on LOOT_READY is a no-op because the frame is not shown yet,
    and the default UI then shows it, with nothing re-hiding it until
    LOOT_CLOSED. Using OnShow (rather than a LOOT_OPENED handler) makes
    suppression robust to event-handler ordering — it hides after whatever
    showed the frame.

    Reset to false on LOOT_CLOSED via ns.ResetSpeedyLootWindow (called from
    Core's EventHandlers:LOOT_CLOSED) so a throttled LOOT_READY can't carry one
    corpse's "fully looted" verdict onto the next corpse's unlooted window.
]]
local suppressLootWindow = false

--------------------------------------------------------------------------------
-- Speedy Loot
--------------------------------------------------------------------------------

--[[
    The LOOT_READY response, invoked from Core's central dispatcher
    (EventHandlers:LOOT_READY) so a single registration owns the event. Core
    stamps world-loot state first and then calls this, preserving the order the
    two separate event frames previously ran in.
]]
function ns.HandleSpeedyLoot()
	if not ns.isSpeedyLoot then
		return
	end

	local autoLoot = IsAutoLootEnabled()
	local modified = IsModifiedClick("AUTOLOOTTOGGLE")
	local shouldAutoLoot = (autoLoot ~= modified)

	if not shouldAutoLoot then
		return
	end

	local now = GetTime()
	if (now - ns.state.lastLootAt) < ns.LOOT_DELAY then
		return
	end

	local numItems = GetNumLootItems()
	if numItems < 1 then
		return
	end

	--[[
        Stand down entirely when we are the master looter. Master loot is a
        managed flow: at-or-above-threshold items are assigned through the ML
        window and sub-threshold items are handed out by the group method, so
        there is nothing here for Speedy Loot to take. Calling LootSlot on a
        threshold item also pops MasterLooterFrame_Show with no
        selectedLootButton, which crashes on a nil colorInfo on some clients.
    ]]
	local lootMethod, masterLooterPartyID = GetLootMethodCompat()
	if lootMethod == "master" and masterLooterPartyID == 0 then
		return
	end

	--[[
        Only general-purpose bag space counts, by design: profession bags
        and quivers are intentionally ignored. Money/currency take no bag
        space and are looted regardless, so they never count against this.
    ]]
	local freeSlots = ns.GetFreeSlots()

	--[[
        General bags are full and real items are waiting: loot nothing and
        leave the loot window visible so items can be taken manually. Hiding
        it here would strand the loot.
    ]]
	if freeSlots <= 0 then
		for slot = 1, numItems do
			if IsItemLootSlot(slot) then
				return
			end
		end
	end

	if LootFrame then
		LootFrame:Hide()
	end

	--[[
        Set whenever a slot is left in the loot window — either an ignored item
        we open manually (e.g. a lockbox) or an item skipped because bags filled
        up partway through this loop. Drives both re-showing the window and the
        suppressLootWindow flag below: the window is only suppressed when this
        pass took everything, so anything left behind stays reachable.
    ]]
	local leftBehind = false

	for slot = numItems, 1, -1 do
		if not IsItemLootSlot(slot) then
			-- Money/currency: no bag cost, always loot.
			LootSlot(slot)
		elseif freeSlots > 0 then
			local link = GetLootSlotLink(slot)
			local shouldLoot = true

			if link then
				local itemId = tonumber(link:match("item:(%d+)"))
				if itemId and ns.IgnoreItems and ns.IgnoreItems[itemId] then
					shouldLoot = false

					local lastAnnounced = ns.state.recentAnnouncements[itemId] or 0
					if (now - lastAnnounced) > 5 and ns.db.profile.autoOpen and ns.db.profile.lockboxNotifications then
						ns:PrintMessage(string.format(L["ITEM_OPEN_MANUALLY"], link))
						ns.state.recentAnnouncements[itemId] = now
					end

					--[[
                        We deliberately leave this item in the window for the
                        player to open by hand. Flag it so the window is re-shown
                        below and stays unsuppressed; the single post-loop
                        LootFrame:Show() covers it.
                    ]]
					leftBehind = true
				end
			end

			if shouldLoot then
				LootSlot(slot)
				freeSlots = freeSlots - 1
			end
		else
			--[[
                Item slot we can't take: bags filled up earlier in this
                loop. Flag it so the loot window is re-shown below.
            ]]
			leftBehind = true
		end
	end

	--[[
        Suppress the window only when this pass took everything. When something
        was left behind, keep it visible: the OnShow hook stays a no-op and the
        explicit Show below (belt-and-suspenders with the natural LOOT_OPENED
        show) reveals the stranded loot.
    ]]
	suppressLootWindow = not leftBehind

	if leftBehind and LootFrame then
		LootFrame:Show()
	end

	ns.state.lastLootAt = now
end

--------------------------------------------------------------------------------
-- Loot Window OnShow Hook
--------------------------------------------------------------------------------

-- Reset on LOOT_CLOSED (from Core's dispatcher); see the suppressLootWindow comment above for why.
function ns.ResetSpeedyLootWindow()
	suppressLootWindow = false
end

--[[
    Re-hide the loot window the instant the default UI shows it, but only when the
    last pass took everything. This is what actually kills the flash — see the
    suppressLootWindow comment above. Hooked once at load; LootFrame exists by
    then (FrameXML loads before addons).
]]
if LootFrame then
	LootFrame:HookScript("OnShow", function(self)
		if suppressLootWindow then
			self:Hide()
		end
	end)
end
