local ADDON_NAME, OS = ...

-------------------------------------------------------------------------------
-- CONSTANTS & LOCALIZATIONS
-------------------------------------------------------------------------------

-- API Caching for Performance
local CreateFrame, C_Timer, UnitAffectingCombat, GetTime = CreateFrame, C_Timer, UnitAffectingCombat, GetTime
local tonumber, wipe, UnitRace, UnitSex = tonumber, wipe, UnitRace, UnitSex
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

local UnitBuff = (C_UnitAuras and C_UnitAuras.GetBuffDataByIndex) or _G.UnitBuff
local GetCVarBool = (C_CVar and C_CVar.GetCVarBool) or function(cvar) return GetCVar(cvar) == "1" end
local SetCVar = (C_CVar and C_CVar.SetCVar) or _G.SetCVar

-- Default Flags
OS.isEnabled = true
OS.isPaused = false
OS.isSpeedyLoot = true

-------------------------------------------------------------------------------
-- HELPER FUNCTIONS
-------------------------------------------------------------------------------

local function IsQuiet() return GetTime() < OS.state.quietUntil end

local function SetQuiet(seconds)
    local untilTS = GetTime() + (seconds or 0)
    if untilTS > OS.state.quietUntil then OS.state.quietUntil = untilTS end
end

local function StatusPrint(msg, ...)
    if IsQuiet() then return end
    local text = (...) and string.format(msg, ...) or msg
    local now = GetTime()
    if text == OS.state.lastStatusMsg and (now - OS.state.lastStatusAt) < 5 then return end
    OS.state.lastStatusMsg, OS.state.lastStatusAt = text, now
    OS.Print(text)
end
OS.StatusPrint = StatusPrint

local function EnsureAutoLoot()
    if not GetCVarBool("autoLootDefault") then
        SetCVar("autoLootDefault", "1")
        OS.Print("Auto Loot is required for Open Sesame to function properly. Auto Loot has been enabled.")
    end
end

local function PlayBagFullSound()
    local _, raceEn = UnitRace("player")
    local gender = UnitSex("player") 
    if raceEn and OS.RACE_SOUNDS[raceEn] and OS.RACE_SOUNDS[raceEn][gender] then
        PlaySound(OS.RACE_SOUNDS[raceEn][gender], "Master")
    else
        PlaySound(846, "Master")
    end
end

local scanTooltip = CreateFrame("GameTooltip", "OS_ScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function IsItemLocked(bag, slot)
    scanTooltip:ClearLines()
    scanTooltip:SetBagItem(bag, slot)
    for i = 1, scanTooltip:NumLines() do
        local line = _G["OS_ScanTooltipTextLeft" .. i]
        local text = line and line:GetText()
        if text and text == LOCKED then return true end
    end
    return false
end

local function IsPlayerStealthed()
    if _G.IsStealthed and _G.IsStealthed() then return true end
    for i = 1, 40 do
        local _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if not spellID then break end
        if spellID == OS.SPELLS.SHADOWMELD then return true end -- Corrected
    end
    return false
end

local function IsInteractionActive()
    if C_PlayerInteractionManager and C_PlayerInteractionManager.GetInteractionType then
        local t = C_PlayerInteractionManager.GetInteractionType()
        if t and (t ~= 0) then return true end
    end
    return (MerchantFrame and MerchantFrame:IsShown()) or (MailFrame and MailFrame:IsShown()) or
        (TradeFrame and TradeFrame:IsShown()) or (BankFrame and BankFrame:IsShown()) or
        (GossipFrame and GossipFrame:IsShown()) or (QuestFrame and QuestFrame:IsShown()) or
        (StaticPopup1 and StaticPopup1:IsShown())
end

local function IsSafeToOpen()
    if not OS.isEnabled or OS.isPaused then return false end
    if UnitAffectingCombat("player") or IsInteractionActive() or IsPlayerStealthed() then return false end
    if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then return false end
    OS.state.lastFreeSlots = OS.GetFreeSlots()
    return OS.state.lastFreeSlots >= OS.MIN_FREE_SLOTS
end

local function ShouldPause(free)
    return OS.isPaused and free < (OS.MIN_FREE_SLOTS + 1) or free < OS.MIN_FREE_SLOTS
end

-------------------------------------------------------------------------------
-- QUEUE SYSTEM
-------------------------------------------------------------------------------
local q, qHead, qTail = {}, 1, 0

local function QPush(bag, slot, id)
    qTail = qTail + 3
    q[qTail - 2], q[qTail - 1], q[qTail] = bag, slot, id
end

local function QPop()
    if qHead > qTail then return nil end
    local b, s, i = q[qHead], q[qHead + 1], q[qHead + 2]
    qHead = qHead + 3
    if qHead > qTail then wipe(q) qHead, qTail = 1, 0 end
    return b, s, i
end

local function SafeFastItemID(bag, slot)
    local id = OS.GetContainerItemID(bag, slot)
    if id then return id end
    local link = OS.GetContainerItemLink(bag, slot)
    return link and tonumber(link:match("item:(%d+)"))
end

local function BuildQueue()
    wipe(q)
    qHead, qTail = 1, 0
    for bag = 0, 4 do
        local slots = OS.GetContainerNumSlots(bag)
        for slot = 1, slots or 0 do
            local id = SafeFastItemID(bag, slot)
            if id then
                local allowed = OS.AllowedItems[id]
                if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
                    QPush(bag, slot, id)
                end
            end
        end
    end
end

local function OpenTick()
    OS.state.openTimerLive = false
    if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
        OS.state.openTimerLive = true
        C_Timer.After(OS.OPEN_TICK_INTERVAL, OpenTick)
        return
    end
    if not IsSafeToOpen() then return end

    local bag, slot, cachedId = QPop()
    if not bag then return end

    if SafeFastItemID(bag, slot) == cachedId then
        PlaySound(565975, "Master")
        OS.UseContainerItem(bag, slot)
        C_Timer.After(0.25, function()
            local still = SafeFastItemID(bag, slot)
            if still == cachedId then
                local allowed = OS.AllowedItems[still]
                if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
                    QPush(bag, slot, still)
                end
            end
            if IsSafeToOpen() and not OS.state.openTimerLive and qHead <= qTail then
                OS.state.openTimerLive = true
                C_Timer.After(OS.OPEN_TICK_INTERVAL, OpenTick)
            end
        end)
    end
    if qHead <= qTail then
        OS.state.openTimerLive = true
        C_Timer.After(OS.OPEN_TICK_INTERVAL, OpenTick)
    end
end

local function ScheduleScan(force)
    local function run()
        OS.state.scanPending = false
        OS.state.lastFreeSlots = OS.GetFreeSlots()
        if OS.isEnabled then
            local shouldPause = ShouldPause(OS.state.lastFreeSlots)
            if shouldPause ~= OS.isPaused then
                OS.isPaused = shouldPause
                if shouldPause then
                    OS.state.openTimerLive = false
                    StatusPrint("Paused until you have at least %d empty bag slots.", OS.MIN_FREE_SLOTS)
                else
                    StatusPrint("Resumed.")
                end
                if OS.UpdateMinimapIcon then OS.UpdateMinimapIcon() end
            end
        end
        BuildQueue()
        if IsSafeToOpen() and not OS.state.openTimerLive and qHead <= qTail then
            OS.state.openTimerLive = true
            C_Timer.After(OS.OPEN_TICK_INTERVAL, OpenTick)
        end
    end

    if force then run() return end
    local wantAt = GetTime() + OS.SCAN_DEBOUNCE
    if OS.state.scanPending and wantAt >= OS.state.scanTimerAt then return end
    OS.state.scanPending, OS.state.scanTimerAt = true, wantAt
    C_Timer.After(OS.SCAN_DEBOUNCE, function()
        if GetTime() >= OS.state.scanTimerAt then run() end
    end)
end
OS.ScheduleScan = ScheduleScan

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------
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
    if OS.DB.lootSounds == nil then
        OS.DB.lootSounds = false  -- Changed default to false
    end

    OS.isEnabled = OS.DB.autoOpen
    OS.isSpeedyLoot = OS.DB.speedyLoot

    if OS.InitMinimap then
        OS.InitMinimap()
    end
    OS.UpdateMinimapIcon()
end

function EventHandlers:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    if isInitialLogin or isReloadingUi then
        C_Timer.After(
            OS.WORLD_LOAD_DELAY,
            function()
                OS.state.lastFreeSlots = OS.GetFreeSlots()
                if OS.isEnabled then
                    OS.isPaused = (OS.isPaused and OS.state.lastFreeSlots < (OS.MIN_FREE_SLOTS + 1)) or (OS.state.lastFreeSlots < OS.MIN_FREE_SLOTS)
                    OS.ScheduleScan(true)
                    EnsureAutoLoot()
                end
                OS.UpdateMinimapIcon()
            end
        )
    else
        SetQuiet(2)
    end
end

function EventHandlers:PLAYER_REGEN_ENABLED()
    if OS.isEnabled then
        ScheduleScan(true)
    end
end

function EventHandlers:UPDATE_STEALTH()
    if not IsPlayerStealthed() and OS.isEnabled then
        ScheduleScan(true)
    end
end

function EventHandlers:UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellID)
    if unit == "player" and spellID == OS.SPELLS.PICK_LOCK then
        C_Timer.After(0.5, function() OS.ScheduleScan(true) end)
    end
end

function EventHandlers:UI_ERROR_MESSAGE(errTypeOrID, msg)
    local isBagFull = (msg and msg:find(ERR_INV_FULL or "Inventory is full"))
    if not isBagFull and type(errTypeOrID) == "number" then
        isBagFull = (errTypeOrID == (LE_GAME_ERR_INV_FULL or 0)) or (Enum and Enum.UIERRORS and errTypeOrID == Enum.UIERRORS.ERR_INV_FULL)
    end
    if isBagFull then
        local now = GetTime()
        if (now - OS.state.lastBagFullAt) > OS.BAG_FULL_COOLDOWN then -- Corrected reference
            OS.state.lastBagFullAt = now
            OS.isPaused = true
            OS.state.openTimerLive = false
            OS.UpdateMinimapIcon()
            StatusPrint("Inventory is full!")
            PlayBagFullSound()
        end
    end
end

local function OnScanReq()
    ScheduleScan()
end
local function OnForceScan()
    ScheduleScan(true)
end
local function OnLoadStart()
    SetQuiet(10)
end
local function OnLoadEnd()
    SetQuiet(3)
end

function EventHandlers:LOOT_READY()
    OS.state.lastLootWindowAt = GetTime()
end

function EventHandlers:LOOT_OPENED()
    OS.state.lastLootWindowAt = GetTime()
end

EventHandlers.BAG_UPDATE_DELAYED = OnScanReq
EventHandlers.BAG_NEW_ITEMS_UPDATED = OnScanReq

function EventHandlers:CHAT_MSG_LOOT(msg)
    if msg then
        local prefix = LOOT_ITEM_SELF and LOOT_ITEM_SELF:gsub("%%s", ""):gsub("%.$", "")
        local prefix2 = LOOT_ITEM_PUSHED_SELF and LOOT_ITEM_PUSHED_SELF:gsub("%%s", ""):gsub("%.$", "")

        if (prefix and msg:find(prefix, 1, true)) or (prefix2 and msg:find(prefix2, 1, true)) then
            local link = msg:match("(|c%x+|Hitem:.-|h%[.-%]|h|r)")
            if link then
                local id = tonumber(link:match("item:(%d+)"))

                -- Auto-Open Logic
                if id and OS.AllowedItems and OS.AllowedItems[id] == false then
                    OS.Print(link .. " will be automatically opened once it's unlocked.")
                end

                -- Loot Sounds Logic
                if OS.DB.lootSounds then
                    local lootWindowOpen = (LootFrame and LootFrame:IsShown())
                    local lootWindowRecentlyOpen = (GetTime() - (OS.state.lastLootWindowAt or 0)) < 2

                    if lootWindowOpen or lootWindowRecentlyOpen then
                        local colorSeq = link:match("|c(%x+)|H")
                        if colorSeq and #colorSeq == 8 then
                            local hex = string.lower(string.sub(colorSeq, 3, 8)) -- Get RGB

                            if hex ~= "9d9d9d" and hex ~= "ffffff" then
                                PlaySound(OS.LOOT_SOUND_ID, "Master")
                            end
                        end
                    end
                end
            end
        end
    end
    OnScanReq()
end

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
f:SetScript(
    "OnEvent",
    function(self, event, ...)
        if EventHandlers[event] then
            EventHandlers[event](self, ...)
        end
    end
)

for event in pairs(EventHandlers) do
    f:RegisterEvent(event)
end