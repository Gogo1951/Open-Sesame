local ADDON_NAME, OS = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = OS.L

--------------------------------------------------------------------------------
-- API Compatibility
--------------------------------------------------------------------------------

-- Pick the auto-loot CVar API by availability, not by truthy result. The
-- previous `(modern call) or (legacy call)` pattern fell through to the
-- legacy check whenever the modern API returned false (auto-loot off).
local IsAutoLootEnabled
if C_CVar and C_CVar.GetCVarBool then
    IsAutoLootEnabled = function() return C_CVar.GetCVarBool("autoLootDefault") end
else
    IsAutoLootEnabled = function() return GetCVar("autoLootDefault") == "1" end
end

local GetLootMethodCompat
if C_PartyInfo and C_PartyInfo.GetLootMethod then
    GetLootMethodCompat = function() return C_PartyInfo.GetLootMethod() end
elseif GetLootMethod then
    GetLootMethodCompat = GetLootMethod
else
    GetLootMethodCompat = function() return "freeforall" end
end

--------------------------------------------------------------------------------
-- Speedy Loot
--------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("LOOT_READY")
frame:SetScript(
    "OnEvent",
    function(self)
        if not OS.isSpeedyLoot then
            return
        end

        local autoLoot = IsAutoLootEnabled()
        local modified = IsModifiedClick("AUTOLOOTTOGGLE")
        local shouldAutoLoot = (autoLoot ~= modified)

        if not shouldAutoLoot then
            return
        end

        local now = GetTime()
        if (now - OS.state.lastLootAt) < OS.LOOT_DELAY then
            return
        end

        local numItems = GetNumLootItems()
        if numItems < 1 then
            return
        end

        if LootFrame then
            LootFrame:Hide()
        end

        -- Skip auto-loot for items Blizzard wants to route through the
        -- Master Looter dialog. Calling LootSlot on a threshold item
        -- when we're the master looter pops MasterLooterFrame_Show with
        -- no selectedLootButton, which crashes on a nil colorInfo.
        local lootMethod, mlPartyID = GetLootMethodCompat()
        local isMasterLooter = (lootMethod == "master" and mlPartyID == 0)
        local lootThreshold = (GetLootThreshold and GetLootThreshold()) or 2

        local freeSlots = OS.GetFreeSlots()

        for slot = numItems, 1, -1 do
            if freeSlots <= 0 then
                break
            end

            local link = GetLootSlotLink(slot)
            local shouldLoot = true

            if link then
                local itemId = tonumber(link:match("item:(%d+)"))
                if itemId and OS.IgnoreItems and OS.IgnoreItems[itemId] then
                    shouldLoot = false

                    local lastAnnounced = OS.state.recentAnnouncements[itemId] or 0
                    if (now - lastAnnounced) > 5 then
                        OS.Print(string.format(L["ITEM_OPEN_MANUALLY"], link))
                        OS.state.recentAnnouncements[itemId] = now
                    end

                    if LootFrame then
                        LootFrame:Show()
                    end
                end
            end

            if shouldLoot and isMasterLooter then
                local _, _, _, _, quality = GetLootSlotInfo(slot)
                if quality and quality >= lootThreshold then
                    shouldLoot = false
                    if LootFrame then
                        LootFrame:Show()
                    end
                end
            end

            if shouldLoot then
                LootSlot(slot)
                freeSlots = freeSlots - 1
            end
        end
        OS.state.lastLootAt = now
    end
)