----------------------------------------------------------------------
-- 1. HEADER & NAMESPACE
----------------------------------------------------------------------
local ADDON_NAME, OS = ...
local CHAT_NAME = "Open Sesame"

local version = (C_AddOns and C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")) or "Dev"
if version:find("@") then
    version = "Dev"
end
OS.Version = version

----------------------------------------------------------------------
-- 2. CONSTANTS & BRANDING
----------------------------------------------------------------------
local HEX_BLUE = "00BBFF"
local HEX_GOLD = "FFD100"
local HEX_SEPARATOR = "AAAAAA"
local HEX_TEXT = "FFFFFF"
local HEX_DESC = "CCCCCC"
local HEX_SUCCESS = "33CC33"
local HEX_DISABLED = "CC3333"
local COLOR_PREFIX = "|cff"

OS.COLORS = {
    NAME = COLOR_PREFIX .. HEX_BLUE,
    TITLE = COLOR_PREFIX .. HEX_GOLD,
    SEPARATOR = COLOR_PREFIX .. HEX_SEPARATOR,
    TEXT = COLOR_PREFIX .. HEX_TEXT,
    DESC = COLOR_PREFIX .. HEX_DESC,
    SUCCESS = COLOR_PREFIX .. HEX_SUCCESS,
    DISABLED = COLOR_PREFIX .. HEX_DISABLED
}

OS.BRAND_PREFIX = string.format("%s%s|r %s//|r ", OS.COLORS.NAME, CHAT_NAME, OS.COLORS.SEPARATOR)

local MIN_FREE_SLOTS = 4
local WORLD_LOAD_DELAY = 6
local SCAN_DEBOUNCE = 0.25
local OPEN_TICK_INTERVAL = 0.5
local BAG_FULL_COOLDOWN = 10
local PICK_LOCK_SPELL_ID = 1804
local SHADOWMELD_SPELL_ID = 20580
local LOOT_DELAY = 0.3

----------------------------------------------------------------------
-- 3. INITIALIZATION & VARIABLES
----------------------------------------------------------------------
local CreateFrame, C_Timer, C_Container = CreateFrame, C_Timer, C_Container
local UnitAffectingCombat, GetTime = UnitAffectingCombat, GetTime
local tonumber, type, wipe = tonumber, type, wipe
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

local GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
local GetContainerNumFreeSlots = (C_Container and C_Container.GetContainerNumFreeSlots) or GetContainerNumFreeSlots
local UseContainerItem = (C_Container and C_Container.UseContainerItem) or UseContainerItem
local GetContainerItemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink
local GetContainerItemID = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID
local UnitBuff = (C_UnitAuras and C_UnitAuras.GetBuffDataByIndex) or UnitBuff
local GetCVarBool = (C_CVar and C_CVar.GetCVarBool) or function(cvar)
    return GetCVar(cvar) == "1"
end

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
    lastStatusAt = 0,
    fullScanNeeded = false,
    dirtyBags = {},
    lootEpoch = 0
}

----------------------------------------------------------------------
-- 4. UTILITY FUNCTIONS
----------------------------------------------------------------------
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
    if IsQuiet() then
        return
    end
    local text = (...) and string.format(msg, ...) or msg
    local now = GetTime()
    if text == state.lastStatusMsg and (now - state.lastStatusAt) < 5 then
        return
    end
    state.lastStatusMsg, state.lastStatusAt = text, now
    Print(text)
end

local function IsAutoLootOn()
    return GetCVarBool("autoLootDefault")
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

----------------------------------------------------------------------
-- 5. TOOLTIP SCANNING
----------------------------------------------------------------------
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

----------------------------------------------------------------------
-- 6. SAFETY CHECKS
----------------------------------------------------------------------
local function IsPlayerStealthed()
    if _G.IsStealthed and _G.IsStealthed() then
        return true
    end
    for i = 1, 40 do
        local _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if not spellID then
            break
        end
        if spellID == SHADOWMELD_SPELL_ID then
            return true
        end
    end
    return false
end

local function IsInteractionActive()
    if C_PlayerInteractionManager and C_PlayerInteractionManager.GetInteractionType then
        local t = C_PlayerInteractionManager.GetInteractionType()
        if t and (t ~= 0) then
            return true
        end
    end
    if (MerchantFrame and MerchantFrame:IsShown()) or 
        (MailFrame and MailFrame:IsShown()) or 
        (TradeFrame and TradeFrame:IsShown()) or 
        (BankFrame and BankFrame:IsShown()) or 
        (GossipFrame and GossipFrame:IsShown()) or 
        (QuestFrame and QuestFrame:IsShown()) or 
        (StaticPopup1 and StaticPopup1:IsShown()) then
        return true
    end
    return false
end

local function IsSafeToOpen()
    if not OS.isEnabled or OS.isPaused then
        return false
    end
    if UnitAffectingCombat("player") then
        return false
    end
    if IsInteractionActive() then
        return false
    end
    if IsPlayerStealthed() then
        return false
    end
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

----------------------------------------------------------------------
-- 7. QUEUE SYSTEM
----------------------------------------------------------------------
local q, qHead, qTail = {}, 1, 0

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
        wipe(q);
        qHead, qTail = 1, 0
    end
    return b, s, i
end

local function SafeFastItemID(bag, slot)
    if not bag or not slot then
        return nil
    end
    local id = GetContainerItemID(bag, slot)
    if id then
        return id
    end
    local link = GetContainerItemLink(bag, slot)
    if not link then
        return nil
    end
    return tonumber(link:match("item:(%d+)"))
end

local function BuildQueue(targetBag)
    local useDirty = (not state.fullScanNeeded) and (next(state.dirtyBags) ~= nil) and (targetBag ~= "ALL")
    wipe(q);
    qHead, qTail = 1, 0
    if not useDirty then
        state.fullScanNeeded = false;
        wipe(state.dirtyBags)
    end
    local function ScanBag(bag)
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
    if useDirty then
        for bag in pairs(state.dirtyBags) do
            if bag >= 0 and bag <= 4 then
                ScanBag(bag)
            end
        end
        wipe(state.dirtyBags)
    else
        for bag = 0, 4 do
            ScanBag(bag)
        end
    end
end

----------------------------------------------------------------------
-- 8. EXECUTION LOOP
----------------------------------------------------------------------
local function OpenTick()
    state.openTimerLive = false
    if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
        state.openTimerLive = true
        C_Timer.After(OPEN_TICK_INTERVAL, OpenTick)
        return
    end
    if not IsSafeToOpen() then
        return
    end
    local bag, slot, cachedId = QPop()
    if not bag then
        return
    end
    local currentId = SafeFastItemID(bag, slot)
    if currentId and currentId == cachedId then
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
    local run = function()
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
                    state.fullScanNeeded = true
                end
                if OpenSesame_UpdateMinimapIcon then
                    OpenSesame_UpdateMinimapIcon()
                end
            end
        end
        BuildQueue(force and "ALL")
        if IsSafeToOpen() and not state.openTimerLive and qHead <= qTail then
            state.openTimerLive = true
            C_Timer.After(OPEN_TICK_INTERVAL, OpenTick)
        end
    end
    if force then
        run();
        return
    end
    local wantAt = GetTime() + SCAN_DEBOUNCE
    if state.scanPending and wantAt >= state.scanTimerAt then
        return
    end
    state.scanPending, state.scanTimerAt = true, wantAt
    C_Timer.After(SCAN_DEBOUNCE, function()
        if GetTime() < state.scanTimerAt then
            return
        end
        run()
    end)
end

----------------------------------------------------------------------
-- 9. MINIMAP ICON & LDB
----------------------------------------------------------------------
local LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

local ICONS = {
    on = "Interface\\Icons\\inv_misc_bag_09_green",
    paused = "Interface\\Icons\\inv_misc_bag_09_black",
    off = "Interface\\Icons\\inv_misc_bag_09_red"
}

local function GetStatusColor(bool, isPaused)
    if not bool then
        return OS.COLORS.DISABLED .. "Disabled|r"
    end
    if isPaused then
        return OS.COLORS.SEPARATOR .. "Paused|r"
    end
    return OS.COLORS.SUCCESS .. "Enabled|r"
end

local ldbObject
function OpenSesame_UpdateMinimapIcon()
    if not LDB or not LDBIcon or not ldbObject then
        return
    end
    local key = (not OS.isEnabled) and "off" or (OS.isPaused and "paused" or "on")
    ldbObject.icon = ICONS[key] or ICONS.off
    ldbObject.text = string.format("%s : %s", CHAT_NAME, OS.isEnabled and (OS.isPaused and "Paused" or "On") or "Off")
    if OS.DB and OS.DB.minimap then
        LDBIcon:Refresh(ADDON_NAME, OS.DB.minimap)
    end
end

local function ToggleAutoOpen()
    OS.isEnabled = not OS.isEnabled
    if OS.DB then
        OS.DB.autoOpen = OS.isEnabled
    end
    if not OS.isEnabled then
        state.openTimerLive = false;
        OS.isPaused = false
        Print("Auto-Opening Disabled.")
    else
        state.lastFreeSlots = GetFreeSlots()
        OS.isPaused = ShouldPause(state.lastFreeSlots)
        state.fullScanNeeded = true
        ScheduleScan(true)
        Print("Auto-Opening Enabled.")
    end
    OpenSesame_UpdateMinimapIcon()
end

local function ToggleSpeedyLoot()
    OS.isSpeedyLoot = not OS.isSpeedyLoot
    if OS.DB then
        OS.DB.speedyLoot = OS.isSpeedyLoot
    end
    Print("Speedy Looting %s.", OS.isSpeedyLoot and "Enabled" or "Disabled")
    OpenSesame_UpdateMinimapIcon()
end

local OnEnter
OnEnter = function(anchor)
    local tooltip = GameTooltip
    tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
    tooltip:ClearLines()
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. CHAT_NAME .. "|r", OS.COLORS.SEPARATOR .. OS.Version .. "|r")
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Auto-Opening|r", GetStatusColor(OS.isEnabled, OS.isPaused))
    tooltip:AddLine(OS.COLORS.DESC .. "Automatically opens clams and unlocked containers.|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.NAME .. "Left-Click|r", OS.COLORS.DESC .. "Toggle|r")
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Speedy Loot|r", GetStatusColor(OS.isSpeedyLoot, false))
    tooltip:AddLine(OS.COLORS.DESC .. "Hide the loot window altogether for faster auto-looting.|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.NAME .. "Right-Click|r", OS.COLORS.DESC .. "Toggle|r")
    tooltip:AddLine(" ")
    tooltip:AddLine(OS.COLORS.DESC .. "Will automatically pause when you have 4 or fewer empty bag slots.|r", 1, 1, 1, true)
    tooltip:Show()
end

if LDB then
    ldbObject = LDB:NewDataObject(ADDON_NAME, {
        type = "launcher",
        label = CHAT_NAME,
        icon = ICONS["on"],
        OnClick = function(frame, button)
            if button == "LeftButton" then
                ToggleAutoOpen()
            elseif button == "RightButton" then
                ToggleSpeedyLoot()
            end
            if frame and GameTooltip:GetOwner() == frame then
                OnEnter(frame)
            end
        end,
        OnEnter = function(self)
            OnEnter(self)
        end,
        OnLeave = function(frame)
            GameTooltip:Hide()
        end
    })
end

----------------------------------------------------------------------
-- 10. EVENTS
----------------------------------------------------------------------
local EventHandlers = {}

function EventHandlers:PLAYER_LOGIN()
    OpenSesameDB = OpenSesameDB or {}
    OpenSesameDB.minimap = OpenSesameDB.minimap or {}
    OS.DB = OpenSesameDB
    if OS.DB.autoOpen == nil then
        OS.DB.autoOpen = true
    end
    if OS.DB.speedyLoot == nil then
        OS.DB.speedyLoot = true
    end
    OS.isEnabled = OS.DB.autoOpen
    OS.isSpeedyLoot = OS.DB.speedyLoot
    if LDBIcon and ldbObject then
        LDBIcon:Register(ADDON_NAME, ldbObject, OS.DB.minimap)
    end
    OpenSesame_UpdateMinimapIcon()
end

function EventHandlers:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    if isInitialLogin or isReloadingUi then
        C_Timer.After(WORLD_LOAD_DELAY, function()
            state.lastFreeSlots = GetFreeSlots()
            if OS.isEnabled then
                OS.isPaused = ShouldPause(state.lastFreeSlots)
                state.fullScanNeeded = true
                ScheduleScan(true)
                if not IsAutoLootOn() then
                    Print("Enabled, but Open Sesame won't work properly unless Auto Loot is also turned on.")
                end
            end
            OpenSesame_UpdateMinimapIcon()
        end)
    else
        SetQuiet(2)
    end
end

----------------------------------------------------------------------
-- 11. SPEEDY LOOT LOGIC
----------------------------------------------------------------------
function EventHandlers:LOOT_READY()
    if not OS.isSpeedyLoot then
        return
    end
    local autoLoot = GetCVarBool("autoLootDefault")
    local modifier = IsModifiedClick("AUTOLOOTTOGGLE")
    local isAutoLooting = (autoLoot ~= modifier)
    if isAutoLooting then
        local now = GetTime()
        if (now - state.lootEpoch) >= LOOT_DELAY then
            if TSMDestroyBtn and TSMDestroyBtn:IsShown() and TSMDestroyBtn:GetButtonState() == "DISABLED" then
                state.lootEpoch = now
                return
            end
            local numLoot = GetNumLootItems()
            if numLoot > 0 then
                if LootFrame then
                    LootFrame:Hide()
                end
                for i = numLoot, 1, -1 do
                    LootSlot(i)
                end
                state.lootEpoch = now
            end
        end
    end
end

function EventHandlers:BAG_UPDATE(bagId)
    state.dirtyBags[bagId or -1] = true
    ScheduleScan()
end

function EventHandlers:BAG_NEW_ITEMS_UPDATED()
    state.fullScanNeeded = true;
    ScheduleScan()
end
function EventHandlers:CHAT_MSG_LOOT()
    state.fullScanNeeded = true;
    ScheduleScan()
end

function EventHandlers:PLAYER_REGEN_ENABLED()
    if OS.isEnabled then
        state.fullScanNeeded = true;
        ScheduleScan(true)
    end
end

function EventHandlers:UPDATE_STEALTH()
    if not IsPlayerStealthed() and OS.isEnabled then
        state.fullScanNeeded = true;
        ScheduleScan(true)
    end
end

local function OnFrameClosed()
    state.fullScanNeeded = true;
    ScheduleScan(true)
end
EventHandlers.BANKFRAME_CLOSED = OnFrameClosed
EventHandlers.GOSSIP_CLOSED = OnFrameClosed
EventHandlers.MAIL_CLOSED = OnFrameClosed
EventHandlers.MERCHANT_CLOSED = OnFrameClosed
EventHandlers.QUEST_FINISHED = OnFrameClosed
EventHandlers.TRADE_CLOSED = OnFrameClosed
EventHandlers.PLAYER_INTERACTION_MANAGER_FRAME_HIDE = OnFrameClosed

function EventHandlers:LOADING_SCREEN_ENABLED()
    SetQuiet(10)
end
function EventHandlers:LOADING_SCREEN_DISABLED()
    SetQuiet(3)
end

function EventHandlers:UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellID)
    if unit == "player" and spellID == PICK_LOCK_SPELL_ID then
        C_Timer.After(0.5, function()
            state.fullScanNeeded = true;
            ScheduleScan(true)
        end)
    end
end

function EventHandlers:UI_ERROR_MESSAGE(errTypeOrID, msg)
    local isBagFull = (msg and msg:find(ERR_INV_FULL or "Inventory is full"))
    if not isBagFull and type(errTypeOrID) == "number" then
        isBagFull = (errTypeOrID == (LE_GAME_ERR_INV_FULL or 0)) or (Enum and Enum.UIERRORS and errTypeOrID == Enum.UIERRORS.ERR_INV_FULL)
    end
    if isBagFull then
        local now = GetTime()
        if (now - state.lastBagFullAt) > BAG_FULL_COOLDOWN then
            state.lastBagFullAt = now
            OS.isPaused = true
            state.openTimerLive = false
            OpenSesame_UpdateMinimapIcon()
            StatusPrint("Inventory is full!")
        end
    end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
    if EventHandlers[event] then
        EventHandlers[event](self, ...)
    end
end)

for event in pairs(EventHandlers) do
    f:RegisterEvent(event)
end
