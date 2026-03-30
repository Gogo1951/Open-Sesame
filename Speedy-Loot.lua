local ADDON_NAME, OS = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("OpenSesame")

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

        local autoLoot = (C_CVar and C_CVar.GetCVarBool("autoLootDefault")) or GetCVar("autoLootDefault") == "1"
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

        for slot = numItems, 1, -1 do
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

            if shouldLoot and OS.GetFreeSlots() > 0 then
                LootSlot(slot)
            end
        end
        OS.state.lastLootAt = now
    end
)