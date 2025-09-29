local ADDON_NAME = "Open Sesame"
local OpenSesame = OpenSesame or {}
OpenSesame.AllowedItems = OpenSesame_AllowedOpenItems or {}

local MIN_FREE_SLOTS = 4
local WORLD_LOAD_DELAY = 6
local SCAN_DEBOUNCE = 0.40
local OPEN_TICK_INTERVAL = 0.25
local BAG_FULL_COOLDOWN = s10

local CreateFrame, C_Timer = CreateFrame, C_Timer
local After = C_Timer.After
local UnitAffectingCombat, GetTime = UnitAffectingCombat, GetTime
local strmatch, tonumber, type = string.match, tonumber, type
local wipe = wipe or table.wipe

local GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
local GetContainerNumFreeSlots = (C_Container and C_Container.GetContainerNumFreeSlots) or GetContainerNumFreeSlots
local UseContainerItem = (C_Container and C_Container.UseContainerItem) or UseContainerItem
local GetContainerItemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink
local GetContainerItemID = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID

OpenSesame.isEnabled = (OpenSesame.isEnabled ~= false)
OpenSesame.isPaused = OpenSesame.isPaused or false

local scanTimerAt = 0
local openTimerLive = false
local lastBagFullAt = 0
local lastFreeSlots = nil

local q = {}
local qHead, qTail = 1, 0
local function QCount()
    return (qTail - qHead + 1) / 3
end
local function QPush(bag, slot, id)
    qTail = qTail + 3
    q[qTail - 2], q[qTail - 1], q[qTail] = bag, slot, id
end
local function QPop()
    if qHead > qTail then
        return nil
    end
    local b, s, i = q[qHead], q[qHead + 1], q[qHead + 2]
    qHead = qHead + 3
    if qHead > qTail then
        wipe(q)
        qHead, qTail = 1, 0
    end
    return b, s, i
end

local PREFIX = ("|cff00ff88%s|r // "):format(ADDON_NAME)
local function Print(msg, a, b, c, d)
    if not DEFAULT_CHAT_FRAME then
        return
    end
    if a ~= nil then
        DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. string.format(msg, a, b, c, d))
    else
        DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. msg)
    end
end

local function GetFreeSlots()
    local free = 0
    for bag = 0, 4 do
        local f, family = GetContainerNumFreeSlots(bag)
        if (family == nil or family == 0) and f then
            free = free + f
        end
    end
    return free
end

local function SafeFastItemID(bag, slot)
    if not bag or not slot or bag < 0 or bag > 4 then
        return nil
    end
    if GetContainerItemID then
        return GetContainerItemID(bag, slot)
    end
    local link = GetContainerItemLink(bag, slot)
    if not link then
        return nil
    end
    local id = strmatch(link, "item:(%d+)")
    return id and tonumber(id) or nil
end

local function IsAnyTradeLikeUIShown()
    return (MerchantFrame and MerchantFrame:IsShown()) or (MailFrame and MailFrame:IsShown()) or
        (TradeFrame and TradeFrame:IsShown()) or
        (BankFrame and BankFrame:IsShown())
end

local function IsSafeToOpen()
    if not OpenSesame.isEnabled or OpenSesame.isPaused then
        return false
    end
    if UnitAffectingCombat("player") then
        return false
    end
    if IsAnyTradeLikeUIShown() then
        return false
    end
    lastFreeSlots = lastFreeSlots or GetFreeSlots()
    if lastFreeSlots <= MIN_FREE_SLOTS then
        return false
    end
    return true
end

local function BuildQueue()
    wipe(q)
    qHead, qTail = 1, 0
    for bag = 0, 4 do
        local slots = GetContainerNumSlots(bag)
        if slots and slots > 0 then
            for slot = 1, slots do
                local id = SafeFastItemID(bag, slot)
                if id and OpenSesame.AllowedItems[id] then
                    QPush(bag, slot, id)
                end
            end
        end
    end
end

local function OpenTick()
    openTimerLive = false
    if not IsSafeToOpen() then
        return
    end

    local bag, slot, cachedId = QPop()
    if not bag then
        return
    end

    local currentId = SafeFastItemID(bag, slot)
    if currentId and currentId == cachedId and OpenSesame.AllowedItems[currentId] then
        UseContainerItem(bag, slot)
    end

    if QCount() > 0 then
        openTimerLive = true
        After(OPEN_TICK_INTERVAL, OpenTick)
    end
end

local function StopOpenTimer()
    openTimerLive = false
end
local function StartOpenTimer()
    if openTimerLive or QCount() == 0 then
        return
    end
    openTimerLive = true
    After(OPEN_TICK_INTERVAL, OpenTick)
end

local function ScheduleScan()
    local now = GetTime()
    local due = scanTimerAt
    local wantAt = now + SCAN_DEBOUNCE
    if due == 0 or wantAt < due then
        scanTimerAt = wantAt
        After(
            SCAN_DEBOUNCE,
            function()
                if GetTime() < scanTimerAt then
                    return
                end
                scanTimerAt = 0

                lastFreeSlots = GetFreeSlots()

                if OpenSesame.isEnabled then
                    local shouldPause = (lastFreeSlots <= MIN_FREE_SLOTS)
                    if shouldPause ~= OpenSesame.isPaused then
                        OpenSesame.isPaused = shouldPause
                        if shouldPause then
                            StopOpenTimer()
                            Print("Paused until you have at least %d empty bag slots.", MIN_FREE_SLOTS)
                        else
                            Print("Resumed.")
                        end
                        OpenSesame_UpdateMinimapIcon()
                    end
                end

                if not IsSafeToOpen() then
                    return
                end
                BuildQueue()
                StartOpenTimer()
            end
        )
    end
end

local LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)
OpenSesame_MinimapOptions = OpenSesame_MinimapOptions or {hide = false}

local ICONS = {
    on = "Interface\\Icons\\inv_misc_bag_09_green",
    paused = "Interface\\Icons\\inv_misc_bag_09_black",
    off = "Interface\\Icons\\inv_misc_bag_09_red"
}

local function StatusText()
    if OpenSesame.isPaused then
        return "Paused"
    end
    return "On"
end

local ldbObject
function OpenSesame_UpdateMinimapIcon()
    if not LDB or not LDBIcon or not ldbObject then
        return
    end
    local key = (not OpenSesame.isEnabled) and "off" or (OpenSesame.isPaused and "paused" or "on")
    ldbObject.icon = ICONS[key] or ICONS.off
    ldbObject.text = ADDON_NAME .. " : " .. StatusText()
    LDBIcon:Refresh(ADDON_NAME, OpenSesame_MinimapOptions)
end

local function ToggleEnabled(newState)
    if OpenSesame.isEnabled == newState then
        return
    end
    OpenSesame.isEnabled = newState

    if not newState then
        StopOpenTimer()
        OpenSesame.isPaused = false
        Print("Disabled.")
    else
        lastFreeSlots = GetFreeSlots()
        OpenSesame.isPaused = (lastFreeSlots <= MIN_FREE_SLOTS)
        if not OpenSesame.isPaused then
            ScheduleScan()
        end
        Print("Enabled.")
    end

    OpenSesame_UpdateMinimapIcon()
end

if LDB then
    ldbObject =
        LDB:NewDataObject(
        ADDON_NAME,
        {
            type = "launcher",
            label = ADDON_NAME,
            icon = ICONS[(not OpenSesame.isEnabled) and "off" or (OpenSesame.isPaused and "paused" or "on")],
            text = ADDON_NAME .. " : " .. StatusText(),
            OnClick = function(_, button)
                if button == "LeftButton" then
                    ToggleEnabled(not OpenSesame.isEnabled)
                end
            end,
            OnTooltipShow = function(tt)
                tt:AddLine(ADDON_NAME)
                tt:AddLine(" ")
                tt:AddLine("Left-click: Enable/Disable", 0.8, 0.8, 0.8)
                tt:AddLine(" ")
                tt:AddLine(
                    "Will automatically pause when you have " .. MIN_FREE_SLOTS .. " or fewer free bag slots",
                    0.8,
                    0.8,
                    0.8
                )
            end
        }
    )
    if LDBIcon then
        LDBIcon:Register(ADDON_NAME, ldbObject, OpenSesame_MinimapOptions)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("UI_ERROR_MESSAGE")

f:SetScript(
    "OnEvent",
    function(_, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            local isInitialLogin, isReloadingUi = ...
            if isInitialLogin or isReloadingUi then
                After(
                    WORLD_LOAD_DELAY,
                    function()
                        lastFreeSlots = GetFreeSlots()
                        if OpenSesame.isEnabled then
                            OpenSesame.isPaused = (lastFreeSlots <= MIN_FREE_SLOTS)
                            if not OpenSesame.isPaused then
                                ScheduleScan()
                            end
                            
                            Print("Enabled.")
                        end
                        OpenSesame_UpdateMinimapIcon()
                    end
                )
            end
        elseif event == "BAG_UPDATE" then
            ScheduleScan()
        elseif event == "PLAYER_REGEN_ENABLED" then
            if OpenSesame.isEnabled and not OpenSesame.isPaused then
                ScheduleScan()
            end
        elseif event == "UI_ERROR_MESSAGE" then
            local _, msg = ...
            if type(msg) == "string" and msg:find("Inventory is full") then
                local now = GetTime()
                if now - lastBagFullAt > BAG_FULL_COOLDOWN then
                    lastBagFullAt = now
                    OpenSesame.isPaused = true
                    StopOpenTimer()
                    OpenSesame_UpdateMinimapIcon()
                    Print("Inventory is full!")
                end
            end
        end
    end
)
