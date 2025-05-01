-- Open Sesame Add-on
local ADDON_NAME = "OpenSesame"
local OpenSesame = {}

-- Attempt to load saved variables, default to empty table if none exist.
-- Note: Management of this list is external to this script (e.g., manual editing, other addons).
-- Example: OpenSesame_AllowedOpenItems = { [12345] = true, [67890] = true }
OpenSesame.AllowedItems = OpenSesame_AllowedOpenItems or {}

-- Constants
local BAG_FULL_DELAY = 10 -- Delay before showing "Bag Full" messages again (seconds)
local OPEN_ITEM_DELAY = 0.1 -- Delay between opening items (seconds)
local WORLD_LOAD_DELAY = 10 -- Delay before processing items after login (seconds)
local BAG_UPDATE_DEBOUNCE = 0.2 -- Delay processing after BAG_UPDATE to handle bursts (seconds)
local MIN_FREE_SLOTS = 4 -- Minimum free bag slots required to operate

-- State Variables
OpenSesame.lastBagFullTime = 0 -- Timestamp of the last ERR_INV_FULL message shown
OpenSesame.isProcessing = false -- Flag to prevent concurrent processing runs
OpenSesame.isEnabled = true -- Master toggle for the addon's functionality
OpenSesame.isPaused = false -- Paused state, usually due to insufficient bag space
OpenSesame.bagUpdateTimer = nil -- Timer handle for debouncing BAG_UPDATE

-- Minimap Icons
local ICONS = {
    enabled = "Interface\\Icons\\inv_jewelcrafting_gem_01", -- Green gem
    disabled = "Interface\\Icons\\inv_jewelcrafting_gem_04", -- Grey gem
    paused = "Interface\\Icons\\inv_jewelcrafting_gem_03" -- Yellow gem
}

-- Libraries
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

-- Forward Declarations (for functions used before definition)
local ProcessItems
local UpdateMinimapIcon

-- ===== Helper Functions =====

-- Print standardized messages
local function PrintMessage(...)
    print(("|cff4FC3F7%s|r: %s"):format(ADDON_NAME, (...)))
end

-- Calculate total free slots in regular bags (Backpack + 4 main bags)
local function GetBagSpace()
    local freeSlots = 0
    for bag = 0, NUM_BAG_SLOTS do -- NUM_BAG_SLOTS is usually 4
        local slots, bagType = C_Container.GetContainerNumFreeSlots(bag)
        -- BagType 0 represents regular inventory bags
        if bagType == 0 then
            freeSlots = freeSlots + (slots or 0) -- Ensure slots is a number
        end
    end
    return freeSlots
end

-- Check if any potentially interfering UI windows are open
-- Note: This list might need updating if Blizzard changes frame names or adds new blocking UIs.
local function IsAnyWindowOpen()
    -- Check common interaction frames
    if
        (AuctionFrame and AuctionFrame:IsVisible()) or (BankFrame and BankFrame:IsVisible()) or
            (CraftFrame and CraftFrame:IsVisible()) or
            (GossipFrame and GossipFrame:IsVisible()) or
            (LootFrame and LootFrame:IsVisible()) or
            (MailFrame and MailFrame:IsVisible()) or
            (MerchantFrame and MerchantFrame:IsVisible()) or
            (TradeFrame and TradeFrame:IsVisible()) or
            (TradeSkillFrame and TradeSkillFrame:IsVisible())
     then
        return true
    end
    -- Check common full-screen bag addons (examples)
    if
        (IsAddOnLoaded("Bagnon") and BagnonFrame and BagnonFrame:IsVisible()) or
            (IsAddOnLoaded("AdiBags") and AdiBagsContainer1 and AdiBagsContainer1:IsVisible())
     then
        return true
    end
    return false
end

-- Check if the player is currently casting or channeling a spell
local function IsPlayerCasting()
    return UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil
end

-- ===== Minimap Button & Logic =====

-- Function to update the minimap icon based on addon state
function UpdateMinimapIcon()
    if not minimapButton then
        return
    end -- Safety check

    local iconKey = "disabled" -- Default to disabled
    if OpenSesame.isPaused then
        iconKey = "paused"
    elseif OpenSesame.isEnabled then
        iconKey = "enabled"
    end
    minimapButton.icon = ICONS[iconKey]
end

local minimapButton =
    LDB:NewDataObject(
    ADDON_NAME,
    {
        type = "launcher",
        text = ADDON_NAME,
        icon = ICONS.enabled, -- Initial state assuming enabled
        OnClick = function(_, button)
            if button == "LeftButton" then
                OpenSesame.isEnabled = not OpenSesame.isEnabled
                -- Reset pause state when toggling enable/disable
                if not OpenSesame.isEnabled then
                    OpenSesame.isPaused = false
                end
                UpdateMinimapIcon()

                PrintMessage("Auto-Open %s", (OpenSesame.isEnabled and "|cff00FF00On|r" or "|cffFF0000Off|r"))

                -- If just enabled, try to process items immediately
                if OpenSesame.isEnabled and not OpenSesame.isPaused then
                    ProcessItems()
                end
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine(("|cff4FC3F7%s|r"):format(ADDON_NAME), 1, 1, 1)
            tooltip:AddLine(" ", 0, 0, 0, 0) -- Spacer line
            local status
            if OpenSesame.isPaused then
                status = "|cffFFFF00Paused|r" -- Yellow
            elseif OpenSesame.isEnabled then
                status = "|cff00FF00On|r" -- Green
            else
                status = "|cffFF0000Off|r" -- Red
            end
            tooltip:AddDoubleLine("Auto-Open Status :", status, 1, 1, 1, 1, 1, 1)
            tooltip:AddLine(" ", 0, 0, 0, 0) -- Spacer line
            tooltip:AddLine("Click to toggle Auto-Open On/Off.", 0.8, 0.8, 0.8)
            if OpenSesame.isPaused then
                tooltip:AddLine(("Paused: Requires at least %d free bag slots."):format(MIN_FREE_SLOTS), 1, 0.8, 0)
            end
            local count = 0
            for _ in pairs(OpenSesame.AllowedItems) do
                count = count + 1
            end
            tooltip:AddLine(("%d Item(s) in Allow List"):format(count), 0.6, 0.6, 0.6)
        end
    }
)

-- Register the LDB object with LibDBIcon to create the minimap icon
LDBIcon:Register(ADDON_NAME, minimapButton, OpenSesame_MinimapOptions or {}) -- Allow saved position

-- ===== Core Processing Logic =====

function ProcessItems()
    -- Abort checks: Conditions under which we should *not* attempt to open items.
    if
        not OpenSesame.isEnabled or -- Addon manually disabled
            OpenSesame.isProcessing or -- Already running a processing cycle
            UnitAffectingCombat("player") or -- In combat
            IsPlayerCasting() or -- Currently casting/channeling
            IsAnyWindowOpen()
     then -- Interaction window open
        OpenSesame.isProcessing = false -- Ensure flag is reset if we abort early
        return
    end

    -- Set processing flag to prevent concurrent runs from different events
    OpenSesame.isProcessing = true

    local freeSlots = GetBagSpace()

    -- Handle Pausing/Unpausing based on free slots
    if freeSlots < MIN_FREE_SLOTS then
        if not OpenSesame.isPaused then -- Only print/update if state changes
            OpenSesame.isPaused = true
            UpdateMinimapIcon()
            PrintMessage("|cffFFFF00Paused|r - Requires at least %d free bag slots.", MIN_FREE_SLOTS)
        end
        OpenSesame.isProcessing = false -- Reset flag before returning
        return
    elseif OpenSesame.isPaused then -- Check if we were paused but now have space
        OpenSesame.isPaused = false
        UpdateMinimapIcon()
        PrintMessage("|cff00FF00Resuming|r Auto-Open!")
    -- Continue processing immediately after unpausing
    end

    -- Iterate through bags and slots to find the *first* allowed item
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            -- Check if item exists, has an ID, and is in our allowed list
            if itemInfo and itemInfo.itemID and OpenSesame.AllowedItems[itemInfo.itemID] then
                -- Found an item, use it
                C_Container.UseContainerItem(bag, slot)

                -- Schedule the *next* attempt slightly later using a timer.
                -- This prevents trying to open items too rapidly and allows the server/client to catch up.
                C_Timer.After(
                    OPEN_ITEM_DELAY,
                    function()
                        OpenSesame.isProcessing = false -- Allow the next cycle
                        ProcessItems() -- Trigger the next check/item opening
                    end
                )
                return -- Exit loops immediately after using one item and scheduling the next check
            end
        end
    end

    -- If we looped through everything and found no items to open, reset the flag.
    OpenSesame.isProcessing = false
end

-- ===== Event Handling =====

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("BAG_UPDATE") -- When bag contents change
eventFrame:RegisterEvent("LOOT_OPENED") -- When a loot window closes (good time to check)
eventFrame:RegisterEvent("LOOT_READY") -- When loot becomes available (can fire early)
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") -- Fires when leaving combat
eventFrame:RegisterEvent("UI_ERROR_MESSAGE") -- To catch "Inventory is full", etc.

eventFrame:SetScript(
    "OnEvent",
    function(_, event, ...)
        -- Always check if the addon is globally enabled first
        if not OpenSesame.isEnabled then
            return
        end

        if event == "PLAYER_ENTERING_WORLD" then
            -- Wait a bit after login for everything to load before the first check
            C_Timer.After(
                WORLD_LOAD_DELAY,
                function()
                    OpenSesame.isProcessing = false -- Ensure processing flag is clear on login/reload
                    OpenSesame.lastBagFullTime = 0 -- Reset bag full timer on login/reload
                    UpdateMinimapIcon() -- Update icon state based on loaded settings/bag space
                    ProcessItems() -- Perform initial check
                end
            )
        elseif event == "BAG_UPDATE" then
            -- Debounce: Wait a short moment after the last BAG_UPDATE before processing.
            -- This bundles rapid updates (e.g., multi-loot) into a single check.
            if OpenSesame.bagUpdateTimer then
                C_Timer.Cancel(OpenSesame.bagUpdateTimer)
            end
            OpenSesame.bagUpdateTimer =
                C_Timer.After(
                BAG_UPDATE_DEBOUNCE,
                function()
                    OpenSesame.bagUpdateTimer = nil -- Clear the timer handle
                    ProcessItems()
                end
            )
        elseif event == "LOOT_OPENED" or event == "PLAYER_REGEN_ENABLED" then
            -- LOOT_READY can fire too early sometimes. LOOT_OPENED (when window closes)
            -- and PLAYER_REGEN_ENABLED (leaving combat) are generally reliable times
            -- to check if new items should be opened.
            -- We debounce BAG_UPDATE, so direct calls here are reasonable backup triggers.
            ProcessItems()
        elseif event == "LOOT_READY" then
            -- Optional: Could also trigger ProcessItems here, but BAG_UPDATE often covers it.
            -- Decided to rely more on BAG_UPDATE (debounced) and LOOT_OPENED/PLAYER_REGEN_ENABLED
            -- ProcessItems() -- Uncomment if you find items aren't opening reliably enough
        elseif event == "UI_ERROR_MESSAGE" then
            local errorType = select(1, ...) -- Use errorType (enum usually) first
            local errorText = select(2, ...) -- Fallback to text if needed

            -- Check for "Inventory is full" (using Blizzard's constants/globals is preferred)
            if errorType == LE_GAME_ERR_INV_FULL or errorText == ERR_INV_FULL then
                local currentTime = GetTime()
                -- Throttle the "Inventory Full" message
                if currentTime - OpenSesame.lastBagFullTime > BAG_FULL_DELAY then
                    PrintMessage("|cffFF0000Inventory is full!|r")
                    OpenSesame.lastBagFullTime = currentTime
                -- No automatic pausing here, ProcessItems handles pausing based on actual slot count
                end
            end
        -- Can add checks for other relevant errors here if needed
        end
    end
)

-- Initial setup calls after the script loads
C_Timer.After(1, UpdateMinimapIcon) -- Update icon shortly after load, ensuring LDB/Icon libs are ready.
PrintMessage("Loaded. Auto-Open is %s.", (OpenSesame.isEnabled and "|cff00FF00On|r" or "|cffFF0000Off|r"))
