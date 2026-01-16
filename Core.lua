local ADDON_NAME, OS = ...
local CHAT_NAME = "Open Sesame"

local version = (C_AddOns and C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")) or "Dev"
if version:find("@") then
    version = "Dev"
end
OS.Version = version

-- CONSTANTS & COLORS
local C_TITLE = "FFD100" -- Gold
local C_INFO = "00BBFF" -- Blue
local C_BODY = "CCCCCC" -- Silver
local C_TEXT = "FFFFFF" -- White
local C_ON = "33CC33" -- Green
local C_OFF = "CC3333" -- Red
local C_SEP = "AAAAAA" -- Gray
local C_MUTED = "808080" -- Dark Gray

local COLOR_PREFIX = "|cff"

OS.COLORS = {
    TITLE = COLOR_PREFIX .. C_TITLE,
    NAME = COLOR_PREFIX .. C_INFO,
    DESC = COLOR_PREFIX .. C_BODY,
    TEXT = COLOR_PREFIX .. C_TEXT,
    SUCCESS = COLOR_PREFIX .. C_ON,
    DISABLED = COLOR_PREFIX .. C_OFF,
    SEPARATOR = COLOR_PREFIX .. C_SEP,
    MUTED = COLOR_PREFIX .. C_MUTED
}

OS.BRAND_PREFIX = string.format("%s%s|r %s//|r ", OS.COLORS.NAME, CHAT_NAME, OS.COLORS.SEPARATOR)

local MIN_FREE_SLOTS = 4
local WORLD_LOAD_DELAY = 8
local SCAN_DEBOUNCE = 0.25
local OPEN_TICK_INTERVAL = 0.5
local BAG_FULL_COOLDOWN = 10
local PICK_LOCK_SPELL_ID = 1804
local SHADOWMELD_SPELL_ID = 20580

local CreateFrame, C_Timer, C_Container = CreateFrame, C_Timer, C_Container
local UnitAffectingCombat, GetTime = UnitAffectingCombat, GetTime
local tonumber, wipe = tonumber, wipe
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

local GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
local GetContainerNumFreeSlots = (C_Container and C_Container.GetContainerNumFreeSlots) or GetContainerNumFreeSlots
local UseContainerItem = (C_Container and C_Container.UseContainerItem) or UseContainerItem
local GetContainerItemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink
local GetContainerItemID = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID
local UnitBuff = (C_UnitAuras and C_UnitAuras.GetBuffDataByIndex) or UnitBuff
local GetCVarBool = (C_CVar and C_CVar.GetCVarBool) or function(cvar) return GetCVar(cvar) == "1" end
local SetCVar = (C_CVar and C_CVar.SetCVar) or SetCVar

OS.isEnabled = true
OS.isPaused = false
OS.isSpeedyLoot = true

local state = {
    scanTimerAt = 0,
    scanPending = false,
    openTimerLive = false,
    lastBagFullAt = 0,
    lastFreeSlots = 0,
    quietUntil = 0,
    lastStatusMsg = nil,
    lastStatusAt = 0
}
OS.state = state

local function Print(msg, ...)
    local text = (...) and string.format(msg, ...) or msg
    local output = OS.BRAND_PREFIX .. OS.COLORS.TEXT .. text .. "|r"
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(output)
    else
        print(output)
    end
end

local function IsQuiet()
    return GetTime() < state.quietUntil
end

local function SetQuiet(seconds)
    local untilTS = GetTime() + (seconds or 0)
    if untilTS > state.quietUntil then
        state.quietUntil = untilTS
    end
end

local function StatusPrint(msg, ...)
    if IsQuiet() then return end
    local text = (...) and string.format(msg, ...) or msg
    local now = GetTime()
    if text == state.lastStatusMsg and (now - state.lastStatusAt) < 5 then return end
    state.lastStatusMsg, state.lastStatusAt = text, now
    Print(text)
end
OS.StatusPrint = StatusPrint

local function EnsureAutoLoot()
    if not GetCVarBool("autoLootDefault") then
        SetCVar("autoLootDefault", "1")
        Print("Auto Loot is required for Open Sesame to function properly. Auto Loot has been enabled.")
    end
end
OS.EnsureAutoLoot = EnsureAutoLoot

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
OS.GetFreeSlots = GetFreeSlots

local scanTooltip = CreateFrame("GameTooltip", "OS_ScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function IsItemLocked(bag, slot)
    scanTooltip:ClearLines()
    scanTooltip:SetBagItem(bag, slot)
    for i = 1, scanTooltip:NumLines() do
        local line = _G["OS_ScanTooltipTextLeft" .. i]
        local text = line and line:GetText()
        if text and text == LOCKED then
            return true
        end
    end
    return false
end

local function IsPlayerStealthed()
    if _G.IsStealthed and _G.IsStealthed() then return true end
    for i = 1, 40 do
        local _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if not spellID then break end
        if spellID == SHADOWMELD_SPELL_ID then return true end
    end
    return false
end

local function IsInteractionActive()
    if C_PlayerInteractionManager and C_PlayerInteractionManager.GetInteractionType then
        local t = C_PlayerInteractionManager.GetInteractionType()
        if t and (t ~= 0) then return true end
    end
    return (MerchantFrame and MerchantFrame:IsShown()) or 
           (MailFrame and MailFrame:IsShown()) or
           (TradeFrame and TradeFrame:IsShown()) or
           (BankFrame and BankFrame:IsShown()) or
           (GossipFrame and GossipFrame:IsShown()) or
           (QuestFrame and QuestFrame:IsShown()) or
           (StaticPopup1 and StaticPopup1:IsShown())
end

local function IsSafeToOpen()
    if not OS.isEnabled or OS.isPaused then return false end
    if UnitAffectingCombat("player") then return false end
    if IsInteractionActive() then return false end
    if IsPlayerStealthed() then return false end
    if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
        return false
    end
    state.lastFreeSlots = GetFreeSlots()
    return state.lastFreeSlots >= MIN_FREE_SLOTS
end

local function ShouldPause(free)
    if OS.isPaused then
        return free < (MIN_FREE_SLOTS + 1)
    else
        return free < MIN_FREE_SLOTS
    end
end

-- QUEUE SYSTEM
local q, qHead, qTail = {}, 1, 0

local function QPush(bag, slot, id)
    qTail = qTail + 3
    q[qTail - 2], q[qTail - 1], q[qTail] = bag, slot, id
end

local function QPop()
    if qHead > qTail then return nil end
    local b, s, i = q[qHead], q[qHead + 1], q[qHead + 2]
    qHead = qHead + 3
    if qHead > qTail then
        wipe(q)
        qHead, qTail = 1, 0
    end
    return b, s, i
end

local function SafeFastItemID(bag, slot)
    if not bag or not slot then return nil end
    local id = GetContainerItemID(bag, slot)
    if id then return id end
    local link = GetContainerItemLink(bag, slot)
    if not link then return nil end
    return tonumber(link:match("item:(%d+)"))
end

local function BuildQueue()
    wipe(q)
    qHead, qTail = 1, 0
    for bag = 0, 4 do
        local slots = GetContainerNumSlots(bag)
        for slot = 1, slots or 0 do
            local id = SafeFastItemID(bag, slot)
            if id then
                local allowed = OS.AllowedItems[id]
                if allowed == true then
                    QPush(bag, slot, id)
                elseif allowed == false then
                    if not IsItemLocked(bag, slot) then
                        QPush(bag, slot, id)
                    end
                end
            end
        end
    end
end

local function OpenTick()
    state.openTimerLive = false
    if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
        state.openTimerLive = true
        C_Timer.After(OPEN_TICK_INTERVAL, OpenTick)
        return
    end
    if not IsSafeToOpen() then return end

    local bag, slot, cachedId = QPop()
    if not bag then return end
    
    local currentId = SafeFastItemID(bag, slot)
    if currentId and currentId == cachedId then
        PlaySound(565975, "Master")
        UseContainerItem(bag, slot)

        C_Timer.After(0.25, function()
            local still = SafeFastItemID(bag, slot)
            if still == cachedId then
                local allowed = OS.AllowedItems[still]
                if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
                    QPush(bag, slot, still)
                end
            end
            if IsSafeToOpen() and not state.openTimerLive and qHead <= qTail then
                state.openTimerLive = true
                C_Timer.After(OPEN_TICK_INTERVAL, OpenTick)
            end
        end)
    end
    if qHead <= qTail then
        state.openTimerLive = true
        C_Timer.After(OPEN_TICK_INTERVAL, OpenTick)
    end
end

local function ScheduleScan(force)
    local function run()
        state.scanPending = false
        state.lastFreeSlots = GetFreeSlots()
        if OS.isEnabled then
            local shouldPause = ShouldPause(state.lastFreeSlots)
            if shouldPause ~= OS.isPaused then
                OS.isPaused = shouldPause
                if shouldPause then
                    state.openTimerLive = false
                    StatusPrint("Paused until you have at least %d empty bag slots.", MIN_FREE_SLOTS)
                else
                    StatusPrint("Resumed.")
                end
                if OS.UpdateMinimapIcon then OS.UpdateMinimapIcon() end
            end
        end
        BuildQueue()
        if IsSafeToOpen() and not state.openTimerLive and qHead <= qTail then
            state.openTimerLive = true
            C_Timer.After(OPEN_TICK_INTERVAL, OpenTick)
        end
    end

    if force then
        run()
        return
    end
    
    local wantAt = GetTime() + SCAN_DEBOUNCE
    if state.scanPending and wantAt >= state.scanTimerAt then return end
    state.scanPending, state.scanTimerAt = true, wantAt
    C_Timer.After(SCAN_DEBOUNCE, function()
        if GetTime() < state.scanTimerAt then return end
        run()
    end)
end
OS.ScheduleScan = ScheduleScan

-- EVENT HANDLERS
local EventHandlers = {}

function EventHandlers:PLAYER_LOGIN()
    OpenSesameDB = OpenSesameDB or {}
    OpenSesameDB.minimap = OpenSesameDB.minimap or {}
    OS.DB = OpenSesameDB
    if OS.DB.autoOpen == nil then OS.DB.autoOpen = true end
    if OS.DB.speedyLoot == nil then OS.DB.speedyLoot = true end
    
    OS.isEnabled = OS.DB.autoOpen
    OS.isSpeedyLoot = OS.DB.speedyLoot

    if OS.InitMinimap then OS.InitMinimap() end
    OS.UpdateMinimapIcon()
end

function EventHandlers:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    if isInitialLogin or isReloadingUi then
        C_Timer.After(WORLD_LOAD_DELAY, function()
            state.lastFreeSlots = GetFreeSlots()
            if OS.isEnabled then
                OS.isPaused = ShouldPause(state.lastFreeSlots)
                ScheduleScan(true)
                EnsureAutoLoot()
            end
            OS.UpdateMinimapIcon()
        end)
    else
        SetQuiet(2)
    end
end

function EventHandlers:PLAYER_REGEN_ENABLED()
    if OS.isEnabled then ScheduleScan(true) end
end

function EventHandlers:UPDATE_STEALTH()
    if not IsPlayerStealthed() and OS.isEnabled then
        ScheduleScan(true)
    end
end

function EventHandlers:UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellID)
    if unit == "player" and spellID == PICK_LOCK_SPELL_ID then
        C_Timer.After(0.5, function() ScheduleScan(true) end)
    end
end

function EventHandlers:UI_ERROR_MESSAGE(errTypeOrID, msg)
    local isBagFull = (msg and msg:find(ERR_INV_FULL or "Inventory is full"))
    if not isBagFull and type(errTypeOrID) == "number" then
        isBagFull = (errTypeOrID == (LE_GAME_ERR_INV_FULL or 0)) or
            (Enum and Enum.UIERRORS and errTypeOrID == Enum.UIERRORS.ERR_INV_FULL)
    end
    if isBagFull then
        local now = GetTime()
        if (now - state.lastBagFullAt) > BAG_FULL_COOLDOWN then
            state.lastBagFullAt = now
            OS.isPaused = true
            state.openTimerLive = false
            OS.UpdateMinimapIcon()
            StatusPrint("Inventory is full!")
        end
    end
end

local function OnScanReq() ScheduleScan() end
local function OnForceScan() ScheduleScan(true) end
local function OnLoadStart() SetQuiet(10) end
local function OnLoadEnd() SetQuiet(3) end

EventHandlers.BAG_UPDATE_DELAYED = OnScanReq
EventHandlers.BAG_NEW_ITEMS_UPDATED = OnScanReq
EventHandlers.CHAT_MSG_LOOT = OnScanReq
EventHandlers.BANKFRAME_CLOSED = OnForceScan
EventHandlers.GOSSIP_CLOSED = OnForceScan
EventHandlers.MAIL_CLOSED = OnForceScan
EventHandlers.MERCHANT_CLOSED = OnForceScan
EventHandlers.QUEST_FINISHED = OnForceScan
EventHandlers.TRADE_CLOSED = OnForceScan
EventHandlers.PLAYER_INTERACTION_MANAGER_FRAME_HIDE = OnForceScan
EventHandlers.LOADING_SCREEN_ENABLED = OnLoadStart
EventHandlers.LOADING_SCREEN_DISABLED = OnLoadEnd

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
    if EventHandlers[event] then EventHandlers[event](self, ...) end
end)

for event in pairs(EventHandlers) do
    f:RegisterEvent(event)
end