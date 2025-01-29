-- Namespace for Open Sesame Add-on
local OpenSesame = {}
OpenSesame.AllowedOpenItems = OpenSesame_AllowedOpenItems

-- Constants
local BAG_FULL_MESSAGE_THROTTLE = 10 -- Time in seconds between "Bag Full" messages
local LOOT_DELAY = 0.5 -- Delay in seconds between opening items

-- Variables
OpenSesame.lastBagFullMessageTime = 0
OpenSesame.isItemProcessing = false
OpenSesame.lastWindowState = true
OpenSesame.lastLootActionTime = 0

-- Race and Gender-specific Sounds
local RaceGenderSounds = {
    ["DwarfFemale"] = 1673,
    ["DwarfMale"] = 1609,
    ["GnomeFemale"] = 1787,
    ["GnomeMale"] = 1730,
    ["HumanFemale"] = 2021,
    ["HumanMale"] = 1897,
    ["NightElfFemale"] = 2251,
    ["NightElfMale"] = 2140,
    ["OrcFemale"] = 2363,
    ["OrcMale"] = 2308,
    ["TaurenFemale"] = 2441,
    ["TaurenMale"] = 2440,
    ["TrollFemale"] = 1952,
    ["TrollMale"] = 1842,
    ["UndeadFemale"] = 2196,
    ["UndeadMale"] = 2076
}

-- Utility Function: Check if any UI window is open
local function IsAnyWindowOpen()
    local framesToCheck = {
        AuctionFrame,
        BankFrame,
        -- CharacterFrame,
        ContainerFrame1,
        ContainerFrame2,
        ContainerFrame3,
        ContainerFrame4,
        ContainerFrame5,
        CraftFrame,
        GossipFrame,
        LootFrame,
        MailFrame,
        MerchantFrame,
        ReagentBankFrame,
        TradeFrame,
        TradeSkillFrame
    }

    for _, frame in ipairs(framesToCheck) do
        if frame and frame:IsVisible() then
            return true
        end
    end

    return false
end

-- Utility Function: Check available bag space
local function GetAvailableBagSlots()
    local freeSlots = 0
    for bag = 0, 4 do
        local numFreeSlots, bagFamily = C_Container.GetContainerNumFreeSlots(bag)
        if bagFamily == 0 then -- Only count generic bags
            freeSlots = freeSlots + numFreeSlots
        end
    end
    return freeSlots
end

-- Utility Function: Check if the player is casting a spell
local function IsPlayerCasting()
    return UnitCastingInfo("player") ~= nil
end

-- Play a race and gender-specific sound for a full inventory
local function PlayInventoryFullSound()
    local _, raceFile = UnitRace("player")
    local gender = UnitSex("player") -- 2 for male, 3 for female
    local genderString = gender == 3 and "Female" or "Male"
    local soundID = RaceGenderSounds[raceFile .. genderString]

    if soundID then
        PlaySound(soundID)
    else
        print("|cff4FC3F7Open Sesame|r : Inventory is full, but no sound available for your race/gender.")
    end
end

-- Process openable items in the bags
local function ProcessBagItems()
    if OpenSesame.isItemProcessing or UnitAffectingCombat("player") or IsPlayerCasting() then
        return
    end

    OpenSesame.isItemProcessing = true

    if IsAnyWindowOpen() then
        OpenSesame.isItemProcessing = false
        return
    end

    local freeSlots = GetAvailableBagSlots()
    if freeSlots < 4 then
        local currentTime = GetTime()
        if currentTime - OpenSesame.lastBagFullMessageTime > BAG_FULL_MESSAGE_THROTTLE then
            print("|cff4FC3F7Open Sesame|r : Paused until you have at least 4 free generic bag spaces.")
            OpenSesame.lastBagFullMessageTime = currentTime
        end
        OpenSesame.isItemProcessing = false
        return
    end

    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and OpenSesame.AllowedOpenItems[itemInfo.itemID] then
                C_Container.UseContainerItem(bag, slot)
                -- Schedule the next processing cycle after a delay
                C_Timer.After(LOOT_DELAY, ProcessBagItems)
                OpenSesame.isItemProcessing = false
                return
            end
        end
    end

    OpenSesame.isItemProcessing = false
end

-- Event Frame for Bag Updates and Loot Events
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("LOOT_OPENED")
eventFrame:RegisterEvent("UI_ERROR_MESSAGE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("LOOT_READY")

-- Event Handling Logic
eventFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if event == "BAG_UPDATE" or event == "LOOT_OPENED" then
            if not UnitAffectingCombat("player") and not IsPlayerCasting() then
                ProcessBagItems()
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            ProcessBagItems()
        elseif event == "UI_ERROR_MESSAGE" then
            local _, errorMessage = ...
            if errorMessage == ERR_INV_FULL then
                PlayInventoryFullSound()
            end
        elseif event == "LOOT_READY" then
            if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
                local currentTime = GetTime()
                if (currentTime - OpenSesame.lastLootActionTime) >= LOOT_DELAY then
                    for i = GetNumLootItems(), 1, -1 do
                        LootSlot(i)
                    end
                    OpenSesame.lastLootActionTime = currentTime
                end
            end
        end
    end
)

-- Monitor Window States to Trigger Item Processing
eventFrame:SetScript(
    "OnUpdate",
    function(self, elapsed)
        local currentWindowState = IsAnyWindowOpen()
        if OpenSesame.lastWindowState and not currentWindowState and not IsPlayerCasting() then
            ProcessBagItems()
        end
        OpenSesame.lastWindowState = currentWindowState
    end
)
