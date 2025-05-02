-- Open Sesame Add-on
local ADDON_NAME = "Open Sesame"
local OpenSesame = {}

-- Load saved allowed items list
OpenSesame.AllowedItems = OpenSesame_AllowedOpenItems or {}

-- Constants
local BAG_FULL_DELAY = 10 -- Throttle delay for "Bag Full" messages
local OPEN_ITEM_DELAY = 0.2 -- Delay between opening items
local WORLD_LOAD_DELAY = 10 -- Delay after login before first check
local BAG_UPDATE_DEBOUNCE = 0.2 -- Delay after BAG_UPDATE before processing
local MIN_FREE_SLOTS = 4 -- Required free bag slots to operate

-- State Variables
OpenSesame.lastBagFullTime = 0
OpenSesame.isProcessing = false -- Prevent concurrent ProcessItems runs
OpenSesame.isEnabled = true -- Master toggle
OpenSesame.isPaused = false -- Paused due to low bag space
OpenSesame.bagUpdateTimer = nil -- Timer handle for BAG_UPDATE debounce

-- Minimap Icons
local ICONS = {
    enabled = "Interface\\Icons\\inv_jewelcrafting_gem_01",
    disabled = "Interface\\Icons\\inv_jewelcrafting_gem_04",
    paused = "Interface\\Icons\\inv_jewelcrafting_gem_03"
}

-- Libraries
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

-- Forward Declarations
local ProcessItems
local UpdateMinimapIcon  -- Forward declare so LDB object can reference it

-- ===== Helper Functions =====

-- Print standardized messages
local function PrintMessage(formatStr, ...)
    local message = string.format(formatStr, ...)
    print(("|cff4FC3F7%s |r: %s"):format(ADDON_NAME, message))
end

-- Calculate total free slots in regular bags
local function GetBagSpace()
    local freeSlots = 0
    for bag = 0, NUM_BAG_SLOTS do
        local slots, bagType = C_Container.GetContainerNumFreeSlots(bag)
        -- bagType 0 = Generic bag slots
        if bagType == 0 then
            freeSlots = freeSlots + (slots or 0)
        end
    end
    return freeSlots
end

-- Check if interfering UI windows are open
local function IsAnyWindowOpen()
    -- Blizzard standard frames
    if
        (AuctionFrame and AuctionFrame:IsVisible()) or (BankFrame and BankFrame:IsVisible()) or
            (CraftFrame and CraftFrame:IsVisible()) or
            (GossipFrame and GossipFrame:IsVisible()) or
            (MailFrame and MailFrame:IsVisible()) or
            (MerchantFrame and MerchantFrame:IsVisible()) or
            (TradeFrame and TradeFrame:IsVisible()) or
            (TradeSkillFrame and TradeSkillFrame:IsVisible()) or
            (LootFrame and LootFrame:IsVisible())
     then -- Check for loot frame explicitly
        return true
    end
    -- Check common full-screen bag addons (add others if needed)
    if
        (IsAddOnLoaded("Bagnon") and BagnonFrame and BagnonFrame:IsVisible()) or
            (IsAddOnLoaded("AdiBags") and AdiBagsContainer1 and AdiBagsContainer1:IsVisible())
     then -- AdiBags check might need adjustment based on its frame names
        return true
    end
    return false
end

-- Check if casting or channeling
local function IsPlayerCasting()
    return UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil
end

-- ===== Minimap Button & Logic =====

-- Create LDB object for the minimap button
local minimapButton =
    LDB:NewDataObject(
    ADDON_NAME,
    {
        type = "launcher",
        icon = ICONS.enabled, -- Initial icon (will be updated soon)
        text = "Loading", -- Initial text (will be updated soon)
        OnClick = function(_, button)
            if button == "LeftButton" then
                OpenSesame.isEnabled = not OpenSesame.isEnabled
                local newStateText  -- Text for the print message

                if not OpenSesame.isEnabled then
                    OpenSesame.isPaused = false -- Reset pause state if manually disabled
                    newStateText = "|cffFF0000Disabled|r."
                else
                    -- Check if it should immediately be paused due to low bag space
                    local freeSlots = GetBagSpace()
                    if freeSlots < MIN_FREE_SLOTS then
                        OpenSesame.isPaused = true
                        newStateText = "|cffFFFF00Paused|r." -- Show paused immediately if needed
                    else
                        OpenSesame.isPaused = false
                        newStateText = "|cff00FF00Enabled|r."
                    end
                end

                UpdateMinimapIcon() -- Update LDB properties AND trigger refresh

                PrintMessage("Auto-Open %s", newStateText) -- Print status message

                -- Try processing immediately if enabled and not paused
                if OpenSesame.isEnabled and not OpenSesame.isPaused then
                    ProcessItems()
                end
            end
        end,
        OnTooltipShow = function(tooltip)
            -- Tooltip content is generated fresh each time it's shown,
            -- using the current state variables.
            tooltip:AddLine(("|cff4FC3F7%s|r"):format(ADDON_NAME), 1, 1, 1)
            tooltip:AddLine(" ", 0, 0, 0, 0) -- Spacer

            local status
            if OpenSesame.isPaused then
                status = "|cffFFFF00Paused|r"
            elseif OpenSesame.isEnabled then
                status = "|cff00FF00Enabled|r"
            else
                status = "|cffFF0000Disabled|r"
            end
            tooltip:AddDoubleLine("Auto-Open Status:", status, 1, 1, 1, 1, 1, 1)

            if OpenSesame.isPaused then
                tooltip:AddLine(" ", 0.8, 0.8, 0.8) -- Spacer Line
                tooltip:AddLine(("Requires %d free bag slots."):format(MIN_FREE_SLOTS), 1, 1, 0)
            end

            tooltip:AddLine(" ", 0.8, 0.8, 0.8) -- Spacer Line
            tooltip:AddLine("Left-Click to toggle Auto-Open.", 0.5, 0.5, 0.5)
        end
    }
)

-- Update the minimap icon AND REFRESH based on addon state
-- THIS FUNCTION NOW HANDLES THE REFRESH CALL
function UpdateMinimapIcon()
    -- Ensure LDB object exists (it should, but safety check)
    if not minimapButton then
        return
    end

    local iconKey = "disabled"
    local statusText = "Disabled" -- Text for LDB display

    if OpenSesame.isPaused then
        iconKey = "paused"
        statusText = "Paused"
    elseif OpenSesame.isEnabled then
        iconKey = "enabled"
        statusText = "Enabled"
    end

    -- Update the LDB object's properties
    minimapButton.icon = ICONS[iconKey]
    minimapButton.text = statusText -- Update text based on state for LDB display

    -- *** CENTRALIZED REFRESH CALL ***
    -- Tell LibDBIcon to update the visual icon and tooltip content generator
    if LDBIcon then
        LDBIcon:Refresh(ADDON_NAME)
    end
end

-- Register with LibDBIcon to show the icon
LDBIcon:Register(ADDON_NAME, minimapButton, OpenSesame_MinimapOptions or {})

-- ===== Core Processing Logic (Auto-Opening Items IN BAGS) =====

function ProcessItems()
    -- Abort if disabled, already processing, in combat, casting, or conflicting window open
    if
        not OpenSesame.isEnabled or OpenSesame.isProcessing or UnitAffectingCombat("player") or IsPlayerCasting() or
            IsAnyWindowOpen()
     then
        OpenSesame.isProcessing = false -- Ensure flag is reset if we abort early
        return
    end

    OpenSesame.isProcessing = true
    local freeSlots = GetBagSpace()
    local stateChanged = false -- Track if the pause state changed

    -- Handle Pausing based on free slots
    if freeSlots < MIN_FREE_SLOTS then
        if not OpenSesame.isPaused then
            OpenSesame.isPaused = true
            stateChanged = true
            PrintMessage("Auto-Open |cffFFFF00Paused|r! You need at least %d free bag slots.", MIN_FREE_SLOTS)
        end
        -- If paused (either just now or previously), stop processing
        OpenSesame.isProcessing = false
        if stateChanged then
            UpdateMinimapIcon() -- Update icon if state just changed
        end
        return -- Exit because we are paused
    elseif OpenSesame.isPaused then
        -- We have enough slots now, and we were paused
        OpenSesame.isPaused = false
        stateChanged = true
        PrintMessage("Auto-Open |cff00FF00Resumed|r!")
    end

    -- Update the icon if the pause state changed
    if stateChanged then
        UpdateMinimapIcon()
    end

    -- If we are now unpaused (or were never paused), proceed to open items
    local itemUsed = false
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.itemID and OpenSesame.AllowedItems[itemInfo.itemID] then
                C_Container.UseContainerItem(bag, slot)
                itemUsed = true
                -- Schedule next check after a short delay
                C_Timer.After(
                    OPEN_ITEM_DELAY,
                    function()
                        OpenSesame.isProcessing = false
                        ProcessItems() -- Chain the next check
                    end
                )
                return -- Exit after finding and using one item, wait for the timer
            end
        end
    end

    -- Reset flag only if no item was found and used in this pass
    if not itemUsed then
        OpenSesame.isProcessing = false
    end
end

-- ===== Event Handling =====

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("BAG_UPDATE")
-- LOOT_OPENED doesn't reliably fire after items are actually in bags. BAG_UPDATE is better.
-- eventFrame:RegisterEvent("LOOT_OPENED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") -- Fires when leaving combat
eventFrame:RegisterEvent("UI_ERROR_MESSAGE")
-- CVAR_UPDATE is usually for settings changes, not needed here currently
-- eventFrame:RegisterEvent("CVAR_UPDATE")

eventFrame:SetScript(
    "OnEvent",
    function(_, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            -- We only care about other events if the addon is potentially active
            -- Delay initial check after login/reload
            C_Timer.After(
                WORLD_LOAD_DELAY,
                function()
                    OpenSesame.isProcessing = false -- Reset processing state
                    OpenSesame.lastBagFullTime = 0 -- Reset bag full message timer

                    local freeSlots = GetBagSpace()
                    -- Set initial pause state based on whether addon is enabled AND slots are low
                    -- Important: Only pause if the addon is supposed to be enabled initially
                    OpenSesame.isPaused = (OpenSesame.isEnabled and freeSlots < MIN_FREE_SLOTS)

                    UpdateMinimapIcon() -- Update icon based on initial state AND refresh

                    -- Only process items if enabled AND not paused
                    if OpenSesame.isEnabled and not OpenSesame.isPaused then
                        ProcessItems()
                    end
                end
            )
        elseif OpenSesame.isEnabled then
            -- Check if the addon was disabled but paused, and bag space becomes available
            if event == "BAG_UPDATE" then
                -- Debounce bag updates to avoid excessive checks during rapid changes
                if OpenSesame.bagUpdateTimer then
                    C_Timer.Cancel(OpenSesame.bagUpdateTimer)
                end
                OpenSesame.bagUpdateTimer =
                    C_Timer.After(
                    BAG_UPDATE_DEBOUNCE,
                    function()
                        OpenSesame.bagUpdateTimer = nil
                        -- After debounce, check slots and potentially process items
                        -- ProcessItems() itself handles the pausing/unpausing logic and icon updates
                        ProcessItems()
                    end
                )
            elseif event == "PLAYER_REGEN_ENABLED" then
                -- Left combat, try processing items
                ProcessItems()
            elseif event == "UI_ERROR_MESSAGE" then
                local errorType = select(1, ...)
                local errorText = select(2, ...)
                -- Handle "Inventory is full" error - check both numeric ID and text for robustness
                if errorType == LE_GAME_ERR_INV_FULL or errorText == ERR_INV_FULL then
                    local currentTime = GetTime()
                    -- Only react to bag full if the addon is enabled (already checked above)
                    -- Throttle message printing
                    if currentTime - OpenSesame.lastBagFullTime > BAG_FULL_DELAY then
                        PrintMessage("|cffFF0000Inventory is full|r!")
                        OpenSesame.lastBagFullTime = currentTime
                    end
                    -- Ensure addon pauses if inventory is full and it wasn't already
                    if not OpenSesame.isPaused then
                        OpenSesame.isPaused = true
                        UpdateMinimapIcon() -- Update icon AND refresh
                    end
                    -- Stop any current processing attempt since bags are full
                    OpenSesame.isProcessing = false
                    if OpenSesame.bagUpdateTimer then -- Cancel pending bag update checks if we just got told bags are full
                        C_Timer.Cancel(OpenSesame.bagUpdateTimer)
                        OpenSesame.bagUpdateTimer = nil
                    end
                end
            end
        elseif not OpenSesame.isEnabled and OpenSesame.isPaused and event == "BAG_UPDATE" then
            if OpenSesame.bagUpdateTimer then
                C_Timer.Cancel(OpenSesame.bagUpdateTimer)
            end
            OpenSesame.bagUpdateTimer =
                C_Timer.After(
                BAG_UPDATE_DEBOUNCE,
                function()
                    OpenSesame.bagUpdateTimer = nil
                    local freeSlots = GetBagSpace()
                    -- If space frees up while disabled, unpause internally and update icon to 'disabled'
                    if freeSlots >= MIN_FREE_SLOTS then
                        OpenSesame.isPaused = false
                        UpdateMinimapIcon() -- Update icon to 'disabled' (since isEnabled is false)
                    end
                end
            )
        end
    end
)

-- Initial setup call (just to ensure icon displays something on first load before PLAYER_ENTERING_WORLD finishes)
C_Timer.After(
    0.1,
    function()
        -- Set a default icon state before PLAYER_ENTERING_WORLD finishes its delay
        -- Use current isEnabled state, assume not paused initially
        OpenSesame.isPaused = false -- Explicitly set false before first real check
        UpdateMinimapIcon() -- This will set icon based on isEnabled and call refresh
    end
)

PrintMessage(
    "Loaded. Auto-Open is initially %s.",
    OpenSesame.isEnabled and "|cff00FF00Enabled|r." or "|cffFF0000Disabled|r."
)
