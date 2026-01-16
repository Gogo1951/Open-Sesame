local ADDON_NAME, OS = ...
local LOOT_DELAY = 0.3
local lastLootTime = 0

local function Print(msg)
    if not OS.BRAND_PREFIX or not OS.COLORS then return end
    local output = OS.BRAND_PREFIX .. OS.COLORS.TEXT .. msg .. "|r"
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(output)
    else
        print(output)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("LOOT_READY")
frame:SetScript("OnEvent", function(self)
    if not OS.isSpeedyLoot then return end
    
    local autoLoot = (C_CVar and C_CVar.GetCVarBool("autoLootDefault")) or GetCVar("autoLootDefault") == "1"
    local modified = IsModifiedClick("AUTOLOOTTOGGLE")
    local shouldAutoLoot = (autoLoot ~= modified)

    if shouldAutoLoot then
        local now = GetTime()
        if (now - lastLootTime) >= LOOT_DELAY then
            
            local numItems = GetNumLootItems()
            if numItems > 0 then
                if LootFrame then LootFrame:Hide() end
                
                for slot = numItems, 1, -1 do
                    local link = GetLootSlotLink(slot)
                    local shouldLoot = true
                    
                    if link then
                        local id = tonumber(link:match("item:(%d+)"))
                        if id then
                            if OS.IgnoreItems and OS.IgnoreItems[id] then
                                shouldLoot = false
                                Print(link .. " requires manual opening. It may contain a Unique or Bind on Pickup item, or was dropped by a raid boss.")
                                if LootFrame then LootFrame:Show() end
                            elseif shouldLoot and OS.AllowedItems and OS.AllowedItems[id] == false then
                                Print(link .. " will be automatically opened once it's unlocked.")
                            end
                        end
                    end
                    
                    if shouldLoot and OS.GetFreeSlots() > 0 then
                        LootSlot(slot)
                    end
                end
                lastLootTime = now
            end
        end
    end
end)