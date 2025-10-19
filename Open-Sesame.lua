local ADDON_NAME = "Open Sesame"
local OpenSesame = OpenSesame or {}
OpenSesame.AllowedItems = OpenSesame_AllowedOpenItems or {}

local MIN_FREE_SLOTS = 4
local WORLD_LOAD_DELAY = 6
local SCAN_DEBOUNCE = 0.40
local OPEN_TICK_INTERVAL = 0.25
local BAG_FULL_COOLDOWN = 10

local CreateFrame, C_Timer = CreateFrame, C_Timer
local After = C_Timer.After
local UnitAffectingCombat, GetTime = UnitAffectingCombat, GetTime
local strmatch, tonumber, type = string.match, tonumber, type
local wipe = wipe or (table and table.wipe) or function(t)
        for k in pairs(t) do
            t[k] = nil
        end
    end

local GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
local GetContainerNumFreeSlots = (C_Container and C_Container.GetContainerNumFreeSlots) or GetContainerNumFreeSlots
local UseContainerItem = (C_Container and C_Container.UseContainerItem) or UseContainerItem
local GetContainerItemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink
local GetContainerItemID = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID

OpenSesame.isEnabled = (OpenSesame.isEnabled ~= false)
OpenSesame.isPaused = OpenSesame.isPaused or false

local scanTimerAt = 0
local scanPending = false
local openTimerLive = false
local lastBagFullAt = 0
local lastFreeSlots = nil

local PREFIX = ("|cff00ff88%s|r // "):format(ADDON_NAME)
local function Print(msg, a, b, c, d)
    local out = (a ~= nil) and (PREFIX .. string.format(msg, a, b, c, d)) or (PREFIX .. msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(out)
    else
        print(out)
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

local function IsInteractionActive()
    if C_PlayerInteractionManager and C_PlayerInteractionManager.GetInteractionType then
        local t = C_PlayerInteractionManager.GetInteractionType()
        if t ~= nil then
            return true
        end
    end
    if
        (MerchantFrame and MerchantFrame:IsShown()) or (MailFrame and MailFrame:IsShown()) or
            (TradeFrame and TradeFrame:IsShown()) or
            (BankFrame and BankFrame:IsShown()) or
            (GossipFrame and GossipFrame:IsShown()) or
            (QuestFrame and QuestFrame:IsShown()) or
            (StaticPopup1 and StaticPopup1:IsShown())
     then
        return true
    end
    return false
end

local function ShouldPause(free)
    if OpenSesame.isPaused then
        return free < (MIN_FREE_SLOTS + 1)
    else
        return free < MIN_FREE_SLOTS
    end
end

local function IsSafeToOpen()
    if not OpenSesame.isEnabled or OpenSesame.isPaused then
        return false
    end
    if UnitAffectingCombat("player") then
        return false
    end
    if IsInteractionActive() then
        return false
    end
    lastFreeSlots = GetFreeSlots()
    return lastFreeSlots >= MIN_FREE_SLOTS
end

local q, qHead, qTail = {}, 1, 0
local function QHasItems()
    return qHead <= qTail
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

local function BuildQueueAll()
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

local dirtyBags, fullScanNeeded = {}, false
local function BuildQueueDirty()
    if fullScanNeeded or next(dirtyBags) == nil then
        fullScanNeeded = false
        return BuildQueueAll()
    end
    wipe(q)
    qHead, qTail = 1, 0
    for bag in pairs(dirtyBags) do
        if bag == -1 then
            wipe(dirtyBags)
            return BuildQueueAll()
        end
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
    wipe(dirtyBags)
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
    if currentId and OpenSesame.AllowedItems[currentId] then
        if currentId == cachedId then
            UseContainerItem(bag, slot)
        else
            QPush(bag, slot, currentId)
        end
    end
    if QHasItems() then
        openTimerLive = true
        After(OPEN_TICK_INTERVAL, OpenTick)
    end
end

local function StopOpenTimer()
    openTimerLive = false
end
local function StartOpenTimer()
    if openTimerLive or not QHasItems() then
        return
    end
    openTimerLive = true
    After(OPEN_TICK_INTERVAL, OpenTick)
end

local function ScheduleScan()
    local now = GetTime()
    local wantAt = now + SCAN_DEBOUNCE
    if scanPending and wantAt >= scanTimerAt then
        return
    end
    scanPending = true
    scanTimerAt = wantAt
    After(
        SCAN_DEBOUNCE,
        function()
            if GetTime() < scanTimerAt then
                return
            end
            scanPending = false
            scanTimerAt = 0
            lastFreeSlots = GetFreeSlots()
            if OpenSesame.isEnabled then
                local shouldPause = ShouldPause(lastFreeSlots)
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
            BuildQueueDirty()
            StartOpenTimer()
        end
    )
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
    return OpenSesame.isPaused and "Paused" or "On"
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
        OpenSesame.isPaused = ShouldPause(lastFreeSlots)
        if not OpenSesame.isPaused then
            fullScanNeeded = true
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
f:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
f:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
f:RegisterEvent("GOSSIP_CLOSED")
f:RegisterEvent("QUEST_FINISHED")
f:RegisterEvent("MERCHANT_CLOSED")
f:RegisterEvent("MAIL_CLOSED")
f:RegisterEvent("BANKFRAME_CLOSED")
f:RegisterEvent("TRADE_CLOSED")

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
                            OpenSesame.isPaused = ShouldPause(lastFreeSlots)
                            if not OpenSesame.isPaused then
                                fullScanNeeded = true
                                ScheduleScan()
                            end
                            Print("Enabled.")
                        end
                        OpenSesame_UpdateMinimapIcon()
                    end
                )
            end
        elseif event == "BAG_UPDATE" then
            local bagId = ...
            dirtyBags[bagId or -1] = true
            ScheduleScan()
        elseif event == "BAG_NEW_ITEMS_UPDATED" or event == "CHAT_MSG_LOOT" then
            fullScanNeeded = true
            ScheduleScan()
        elseif event == "PLAYER_REGEN_ENABLED" then
            if OpenSesame.isEnabled and not OpenSesame.isPaused then
                fullScanNeeded = true
                ScheduleScan()
            end
        elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
            -- no-op
        elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" then
            fullScanNeeded = true
            ScheduleScan()
        elseif
            event == "GOSSIP_CLOSED" or event == "QUEST_FINISHED" or event == "MERCHANT_CLOSED" or
                event == "MAIL_CLOSED" or
                event == "BANKFRAME_CLOSED" or
                event == "TRADE_CLOSED"
         then
            fullScanNeeded = true
            ScheduleScan()
        elseif event == "UI_ERROR_MESSAGE" then
            local errTypeOrID, msg = ...
            local isBagFull =
                (type(errTypeOrID) == "number" and
                ((type(LE_GAME_ERR_INV_FULL) == "number" and errTypeOrID == LE_GAME_ERR_INV_FULL) or
                    (Enum and Enum.UIERRORS and Enum.UIERRORS.ERR_INV_FULL and errTypeOrID == Enum.UIERRORS.ERR_INV_FULL))) or
                (type(msg) == "string" and msg:find((ERR_INV_FULL or "Inventory is full"), 1, true))
            if isBagFull then
                local now = GetTime()
                local cooldown = tonumber(BAG_FULL_COOLDOWN) or 10
                local dt = now - lastBagFullAt
                if dt < 0 or dt > cooldown then
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
