-- Open Sesame Add-on
local OpenSesame = {}
OpenSesame.AllowedItems = OpenSesame_AllowedOpenItems or {}

-- Constants
local BAG_FULL_DELAY = 10 -- Delay before showing "Bag Full" messages again (seconds)
local OPEN_ITEM_DELAY = 0.1 -- Delay between opening items
local WORLD_LOAD_DELAY = 10 -- Delay before processing items after login

local ADDON_NAME = "OpenSesame"

-- State Variables
OpenSesame.lastBagFullTime = 0
OpenSesame.isProcessing = false
OpenSesame.isEnabled = true
OpenSesame.isPaused = false

-- Minimap Icons
local ICONS = {
    enabled = "Interface\\Icons\\inv_misc_key_03",
    disabled = "Interface\\Icons\\inv_misc_key_01",
    paused = "Interface\\Icons\\inv_misc_key_02"
}

-- Minimap Button Setup
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local minimapButton =
    LDB:NewDataObject(
    ADDON_NAME,
    {
        type = "launcher",
        text = ADDON_NAME,
        icon = ICONS.enabled,
        OnClick = function(_, button)
            if button == "LeftButton" then
                OpenSesame.isEnabled = not OpenSesame.isEnabled
                OpenSesame.isPaused = false
                UpdateMinimapIcon()

                print(
                    "|cff4FC3F7Open Sesame|r : Auto-open " ..
                        (OpenSesame.isEnabled and "|cff00FF00ENABLED|r" or "|cffFF0000DISABLED|r")
                )

                if OpenSesame.isEnabled then
                    ProcessItems()
                end
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cff4FC3F7Open Sesame|r", 1, 1, 1)
            tooltip:AddLine(" ", 1, 1, 1)
            local status =
                OpenSesame.isPaused and "|cffFFAA00Paused|r" or
                (OpenSesame.isEnabled and "|cff00FF00Enabled|r" or "|cffFF0000Disabled|r")
            tooltip:AddDoubleLine("Status:", status, 1, 1, 1, 1, 1, 1)
            tooltip:AddLine(" ", 1, 1, 1)
            tooltip:AddLine("Click to Enable or Disable.", 0.8, 0.8, 0.8)
        end
    }
)

LDBIcon:Register(ADDON_NAME, minimapButton, {})

function UpdateMinimapIcon()
    if minimapButton then
        minimapButton.icon =
            ICONS[OpenSesame.isPaused and "paused" or (OpenSesame.isEnabled and "enabled" or "disabled")]
    end
end

local function GetBagSpace()
    local freeSlots = 0
    for bag = 0, 4 do
        local slots, bagType = C_Container.GetContainerNumFreeSlots(bag)
        if bagType == 0 then
            freeSlots = freeSlots + slots
        end
    end
    return freeSlots
end

-- Check if any UI windows are open
local function IsAnyWindowOpen()
    return (AuctionFrame and AuctionFrame:IsVisible()) or (BankFrame and BankFrame:IsVisible()) or
        (ContainerFrame1 and ContainerFrame1:IsVisible()) or
        (ContainerFrame2 and ContainerFrame2:IsVisible()) or
        (ContainerFrame3 and ContainerFrame3:IsVisible()) or
        (ContainerFrame4 and ContainerFrame4:IsVisible()) or
        (ContainerFrame5 and ContainerFrame5:IsVisible()) or
        (CraftFrame and CraftFrame:IsVisible()) or
        (GossipFrame and GossipFrame:IsVisible()) or
        (LootFrame and LootFrame:IsVisible()) or
        (MailFrame and MailFrame:IsVisible()) or
        (MerchantFrame and MerchantFrame:IsVisible()) or
        (ReagentBankFrame and ReagentBankFrame:IsVisible()) or
        (TradeFrame and TradeFrame:IsVisible()) or
        (TradeSkillFrame and TradeSkillFrame:IsVisible())
end

local function IsPlayerCasting()
    return UnitCastingInfo("player") ~= nil
end

-- Opens items one by one with a delay
function ProcessItems()
    if not OpenSesame.isEnabled then
        return
    end
    if OpenSesame.isProcessing or UnitAffectingCombat("player") or IsPlayerCasting() or IsAnyWindowOpen() then
        return
    end

    OpenSesame.isProcessing = true
    local freeSlots = GetBagSpace()

    if freeSlots < 4 then
        if not OpenSesame.isPaused then
            print("|cff4FC3F7Open Sesame|r : Paused until you have at least 4 free bag slots!")
        end
        OpenSesame.isPaused = true
        UpdateMinimapIcon()

        OpenSesame.isProcessing = false
        return
    end

    if OpenSesame.isPaused and freeSlots >= 4 then
        OpenSesame.isPaused = false
        UpdateMinimapIcon()
        print("|cff4FC3F7Open Sesame|r : Auto-open Resuming!")
    end

    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and OpenSesame.AllowedItems[itemInfo.itemID] then
                C_Container.UseContainerItem(bag, slot)

                -- Open one item at a time with delay
                C_Timer.After(
                    OPEN_ITEM_DELAY,
                    function()
                        OpenSesame.isProcessing = false
                        ProcessItems()
                    end
                )
                return -- Exit loop so only one item is processed at a time
            end
        end
    end

    OpenSesame.isProcessing = false
end

-- Event Handling
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("LOOT_OPENED")
eventFrame:RegisterEvent("LOOT_READY")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD") -- Waits 10 seconds after login before processing items
eventFrame:RegisterEvent("UI_ERROR_MESSAGE")

eventFrame:SetScript(
    "OnEvent",
    function(_, event, ...)
        if not OpenSesame.isEnabled then
            return
        end

        if event == "PLAYER_ENTERING_WORLD" then
            C_Timer.After(
                WORLD_LOAD_DELAY,
                function()
                    OpenSesame.isProcessing = false -- Reset processing flag on login
                    ProcessItems()
                end
            )
        elseif event == "BAG_UPDATE" then
            local freeSlots = GetBagSpace()
            if freeSlots >= 4 and OpenSesame.isPaused then
                print("|cff4FC3F7Open Sesame|r : Auto-open Resuming!")
                OpenSesame.isPaused = false
                UpdateMinimapIcon()
                ProcessItems()
            end
        elseif event == "LOOT_OPENED" or event == "LOOT_READY" or event == "PLAYER_REGEN_ENABLED" then
            ProcessItems()
        elseif event == "UI_ERROR_MESSAGE" and select(2, ...) == ERR_INV_FULL then
            print("|cff4FC3F7Open Sesame|r : Inventory is full!")
        end
    end
)

C_Timer.After(1, UpdateMinimapIcon)
