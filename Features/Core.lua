local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L

--------------------------------------------------------------------------------
-- API References
--------------------------------------------------------------------------------

local CreateFrame, C_Timer, UnitAffectingCombat, GetTime = CreateFrame, C_Timer, UnitAffectingCombat, GetTime
local tonumber, wipe, UnitRace, UnitSex = tonumber, wipe, UnitRace, UnitSex
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

local function GetPlayerBuffSpellID(index)
    if C_UnitAuras and C_UnitAuras.GetBuffDataByIndex then
        local data = C_UnitAuras.GetBuffDataByIndex("player", index)
        return data and data.spellId
    end
    -- Classic ERA: spellId at position 10. TBC: rank at position 2 shifts spellId to position 11.
    -- Read both; use the one that is a number (the other will be nil or boolean).
    local _, _, _, _, _, _, _, _, _, pos10, pos11 = _G.UnitBuff("player", index)
    if type(pos10) == "number" then return pos10 end
    if type(pos11) == "number" then return pos11 end
    return nil
end
local GetCVarBool = (C_CVar and C_CVar.GetCVarBool) or function(cvar)
        return GetCVar(cvar) == "1"
    end
local SetCVar = (C_CVar and C_CVar.SetCVar) or _G.SetCVar

--[[
    Loot-message prefixes, derived once from the global loot format strings
    (e.g. "You receive loot: %s."). Guarded in case the globals are absent at
    load; CHAT_MSG_LOOT references these cached upvalues.
]]
local lootSelfPrefix = LOOT_ITEM_SELF and LOOT_ITEM_SELF:gsub("%%s", ""):gsub("%.$", "")
local lootPushedPrefix = LOOT_ITEM_PUSHED_SELF and LOOT_ITEM_PUSHED_SELF:gsub("%%s", ""):gsub("%.$", "")

--------------------------------------------------------------------------------
-- Flags
--------------------------------------------------------------------------------

ns.isEnabled = true
ns.isPaused = false
ns.isSpeedyLoot = true

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

ns.state = {
    announcedPaused = false,
    lastBagFullAt = 0,
    lastFreeSlots = 0,
    lastLootAt = 0,
    lastLootWindowAt = 0,
    lastStatusAt = 0,
    lastStatusMsg = nil,
    openTimerLive = false,
    quietUntil = 0,
    recentAnnouncements = {},
    scanPending = false,
    scanTimerAt = 0
}

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

function ns.EnsureAutoLoot()
    if not GetCVarBool("autoLootDefault") then
        SetCVar("autoLootDefault", "1")
        ns.PrintMessage(L["AUTO_LOOT_ENABLED"])
    end
end

local function PrintWelcome()
    if not ns.DB.showWelcome then
        return
    end
    ns.PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

local function PlayBagFullSound()
    local _, raceEn = UnitRace("player")
    local gender = UnitSex("player")
    if raceEn and ns.RACE_SOUNDS[raceEn] and ns.RACE_SOUNDS[raceEn][gender] then
        PlaySound(ns.RACE_SOUNDS[raceEn][gender], "Master")
    else
        PlaySound(ns.BAG_FULL_SOUND_FALLBACK, "Master")
    end
end

local scanTooltip = CreateFrame("GameTooltip", "OS_ScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function IsItemLocked(bag, slot)
    scanTooltip:ClearLines()
    scanTooltip:SetBagItem(bag, slot)
    for lineIndex = 1, scanTooltip:NumLines() do
        local line = _G["OS_ScanTooltipTextLeft" .. lineIndex]
        local text = line and line:GetText()
        if text and text == LOCKED then
            return true
        end
    end
    return false
end

local function IsPlayerStealthed()
    if _G.IsStealthed and _G.IsStealthed() then
        return true
    end
    for buffIndex = 1, 40 do
        local spellID = GetPlayerBuffSpellID(buffIndex)
        if not spellID then
            break
        end
        if spellID == ns.SPELLS.SHADOWMELD then
            return true
        end
    end
    return false
end

local function IsInteractionActive()
    return (MerchantFrame and MerchantFrame:IsShown()) or (MailFrame and MailFrame:IsShown()) or
        (TradeFrame and TradeFrame:IsShown()) or
        (BankFrame and BankFrame:IsShown()) or
        (GuildBankFrame and GuildBankFrame:IsShown()) or
        (AuctionFrame and AuctionFrame:IsShown()) or
        (GossipFrame and GossipFrame:IsShown()) or
        (QuestFrame and QuestFrame:IsShown()) or
        (StaticPopup1 and StaticPopup1:IsShown())
end

local function IsSafeToOpen()
    if not ns.isEnabled or ns.isPaused then
        return false
    end
    if UnitAffectingCombat("player") or IsInteractionActive() or IsPlayerStealthed() then
        return false
    end
    if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
        return false
    end

    if GameTooltip:IsShown() then
        local hasItem, itemLink = GameTooltip:GetItem()
        if hasItem or itemLink then
            return false
        end
    end

    ns.state.lastFreeSlots = ns.GetFreeSlots()
    return ns.state.lastFreeSlots >= ns.MIN_FREE_SLOTS
end

local function ShouldPause(free)
    return ns.isPaused and free < (ns.MIN_FREE_SLOTS + 1) or free < ns.MIN_FREE_SLOTS
end

--[[
    Pause/resume status prints are held while a merchant, mail, auction, bank,
    gossip, or quest window is open (IsInteractionActive) — otherwise "Resumed"
    is lost in the player's vendoring. ns.state.announcedPaused tracks what the
    player was last told; OnInteractionClosed flushes a held message once the
    window closes.
]]
local function AnnounceStatus()
    if IsInteractionActive() or ns.isPaused == ns.state.announcedPaused then
        return
    end
    if ns.isPaused then
        ns.StatusPrint(L["PAUSED_BAG_SLOTS"], ns.MIN_FREE_SLOTS)
    else
        ns.StatusPrint(L["RESUMED"])
    end
    ns.state.announcedPaused = ns.isPaused
end

--------------------------------------------------------------------------------
-- Queue System
--------------------------------------------------------------------------------

local queue, queueHead, queueTail = {}, 1, 0

local function QueuePush(bag, slot, itemId)
    queueTail = queueTail + 3
    queue[queueTail - 2], queue[queueTail - 1], queue[queueTail] = bag, slot, itemId
end

local function QueuePop()
    if queueHead > queueTail then
        return nil
    end
    local bag, slot, itemId = queue[queueHead], queue[queueHead + 1], queue[queueHead + 2]
    queueHead = queueHead + 3
    if queueHead > queueTail then
        wipe(queue)
        queueHead, queueTail = 1, 0
    end
    return bag, slot, itemId
end

local function SafeFastItemID(bag, slot)
    local itemId = ns.GetContainerItemID(bag, slot)
    if itemId then
        return itemId
    end
    local link = ns.GetContainerItemLink(bag, slot)
    return link and tonumber(link:match("item:(%d+)"))
end

local function BuildQueue()
    wipe(queue)
    queueHead, queueTail = 1, 0
    for bag = 0, 4 do
        local slots = ns.GetContainerNumSlots(bag)
        for slot = 1, slots or 0 do
            local itemId = SafeFastItemID(bag, slot)
            if itemId then
                local allowed = ns.AllowedItems[itemId]
                if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
                    QueuePush(bag, slot, itemId)
                end
            end
        end
    end
end

local function OpenTick()
    ns.state.openTimerLive = false
    if (UnitCastingInfo and UnitCastingInfo("player")) or (UnitChannelInfo and UnitChannelInfo("player")) then
        ns.state.openTimerLive = true
        C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
        return
    end
    if not IsSafeToOpen() then
        return
    end

    local bag, slot, cachedId = QueuePop()
    if not bag then
        return
    end

    if SafeFastItemID(bag, slot) == cachedId then
        ns.UseContainerItem(bag, slot)
        C_Timer.After(
            ns.OPEN_RECHECK_DELAY,
            function()
                local still = SafeFastItemID(bag, slot)
                if still == cachedId then
                    local allowed = ns.AllowedItems[still]
                    if allowed == true or (allowed == false and not IsItemLocked(bag, slot)) then
                        QueuePush(bag, slot, still)
                    end
                end
                if IsSafeToOpen() and not ns.state.openTimerLive and queueHead <= queueTail then
                    ns.state.openTimerLive = true
                    C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
                end
            end
        )
    end
    if queueHead <= queueTail then
        ns.state.openTimerLive = true
        C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
    end
end

local function ScheduleScan(force)
    local function run()
        ns.state.scanPending = false
        ns.state.lastFreeSlots = ns.GetFreeSlots()
        if ns.isEnabled then
            local shouldPause = ShouldPause(ns.state.lastFreeSlots)
            if shouldPause ~= ns.isPaused then
                ns.isPaused = shouldPause
                if shouldPause then
                    ns.state.openTimerLive = false
                end
                if ns.UpdateMinimapIcon then
                    ns.UpdateMinimapIcon()
                end
            end
            AnnounceStatus()
        end
        -- Nothing below runs while disabled: skip the bag walk and tick start.
        if not ns.isEnabled then
            return
        end
        BuildQueue()
        if IsSafeToOpen() and not ns.state.openTimerLive and queueHead <= queueTail then
            ns.state.openTimerLive = true
            C_Timer.After(ns.OPEN_TICK_INTERVAL, OpenTick)
        end
    end

    if force then
        run()
        return
    end
    local wantAt = GetTime() + ns.SCAN_DEBOUNCE
    if ns.state.scanPending and wantAt >= ns.state.scanTimerAt then
        return
    end
    ns.state.scanPending, ns.state.scanTimerAt = true, wantAt
    C_Timer.After(
        ns.SCAN_DEBOUNCE,
        function()
            if GetTime() >= ns.state.scanTimerAt then
                run()
            end
        end
    )
end
ns.ScheduleScan = ScheduleScan

--------------------------------------------------------------------------------
-- PLAYER_LOGIN, PLAYER_ENTERING_WORLD
--------------------------------------------------------------------------------

local EventHandlers = {}

function EventHandlers:PLAYER_LOGIN()
    OpenSesameDB = OpenSesameDB or {}
    OpenSesameDB.minimap = OpenSesameDB.minimap or {}
    ns.DB = OpenSesameDB
    for key, value in pairs(ns.DEFAULT_CONFIGURATION) do
        if ns.DB[key] == nil then
            ns.DB[key] = value
        end
    end

    ns.isEnabled = ns.DB.autoOpen
    ns.isSpeedyLoot = ns.DB.speedyLoot

    -- Re-derive the LibDBIcon hide flag from showMinimap so a settings reset restores the button to on.
    ns.DB.minimap.hide = not ns.DB.showMinimap

    if ns.InitMinimap then
        ns.InitMinimap()
    end
    ns.UpdateMinimapIcon()
    PrintWelcome()
end

function EventHandlers:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    if isInitialLogin or isReloadingUi then
        C_Timer.After(
            ns.WORLD_LOAD_DELAY,
            function()
                ns.state.lastFreeSlots = ns.GetFreeSlots()
                if ns.isEnabled then
                    ns.isPaused = ShouldPause(ns.state.lastFreeSlots)
                    ns.state.announcedPaused = ns.isPaused
                    ns.ScheduleScan(true)
                end
                if ns.isEnabled or ns.isSpeedyLoot then
                    ns.EnsureAutoLoot()
                end
                ns.UpdateMinimapIcon()
            end
        )
    else
        ns.SetQuiet(2)
    end
end

--------------------------------------------------------------------------------
-- Reset
--------------------------------------------------------------------------------

--[[
    Restore every saved setting to its Default-Settings value (a full overwrite,
    not the additive login merge). The minimap subtable is preserved so the
    button's saved position survives; only its hide flag is re-derived from the
    restored showMinimap. Runtime flags and side effects are re-applied so the
    reset takes hold immediately without a reload.
]]
function ns.ResetSettings()
    for key, value in pairs(ns.DEFAULT_CONFIGURATION) do
        ns.DB[key] = value
    end

    ns.isEnabled = ns.DB.autoOpen
    ns.isSpeedyLoot = ns.DB.speedyLoot

    if ns.SetMinimapShown then
        ns.SetMinimapShown(ns.DB.showMinimap)
    end
    if ns.isEnabled then
        ns.EnsureAutoLoot()
    end
    ns.ScheduleScan(true)
    ns.UpdateMinimapIcon()
end

--------------------------------------------------------------------------------
-- Combat, Stealth, Spellcast
--------------------------------------------------------------------------------

function EventHandlers:PLAYER_REGEN_ENABLED()
    if ns.isEnabled then
        ScheduleScan(true)
    end
end

function EventHandlers:UPDATE_STEALTH()
    if not IsPlayerStealthed() and ns.isEnabled then
        ScheduleScan(true)
    end
end

function EventHandlers:UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellID)
    if unit == "player" and spellID == ns.SPELLS.PICK_LOCK then
        C_Timer.After(
            ns.PICK_LOCK_RESCAN_DELAY,
            function()
                ns.ScheduleScan(true)
            end
        )
    end
end

--------------------------------------------------------------------------------
-- UI_ERROR_MESSAGE
--------------------------------------------------------------------------------

function EventHandlers:UI_ERROR_MESSAGE(errTypeOrID, msg)
    local isBagFull = (msg and msg:find(ERR_INV_FULL or "Inventory is full", 1, true))
    if not isBagFull and type(errTypeOrID) == "number" then
        isBagFull =
            (errTypeOrID == (LE_GAME_ERR_INV_FULL or 0)) or
            (Enum and Enum.UIERRORS and errTypeOrID == Enum.UIERRORS.ERR_INV_FULL)
    end
    if isBagFull then
        local now = GetTime()
        if (now - ns.state.lastBagFullAt) > ns.BAG_FULL_COOLDOWN then
            ns.state.lastBagFullAt = now
            ns.isPaused = true
            ns.state.announcedPaused = true
            ns.state.openTimerLive = false
            ns.UpdateMinimapIcon()
            ns.StatusPrint(L["INVENTORY_FULL"])
            PlayBagFullSound()
        end
    end
end

--------------------------------------------------------------------------------
-- Bag, Loot, Interaction Events
--------------------------------------------------------------------------------

local function OnScanRequest()
    ScheduleScan()
end
local function OnInteractionClosed()
    ScheduleScan(true)
    C_Timer.After(ns.STATUS_FLUSH_DELAY, AnnounceStatus)
end
local function OnLoadStart()
    ns.SetQuiet(10)
end
local function OnLoadEnd()
    ns.SetQuiet(3)
end

function EventHandlers:LOOT_READY()
    ns.state.lastLootWindowAt = GetTime()
end

function EventHandlers:LOOT_OPENED()
    ns.state.lastLootWindowAt = GetTime()
end

EventHandlers.BAG_UPDATE_DELAYED = OnScanRequest
EventHandlers.BAG_NEW_ITEMS_UPDATED = OnScanRequest

function EventHandlers:CHAT_MSG_LOOT(msg)
    if not msg then
        OnScanRequest()
        return
    end

    if not ((lootSelfPrefix and msg:find(lootSelfPrefix, 1, true)) or (lootPushedPrefix and msg:find(lootPushedPrefix, 1, true))) then
        OnScanRequest()
        return
    end

    local link = msg:match("(|c%x+|Hitem:.-|h%[.-%]|h|r)")
    if not link then
        OnScanRequest()
        return
    end

    local itemId = tonumber(link:match("item:(%d+)"))

    if itemId and ns.AllowedItems and ns.AllowedItems[itemId] == false then
        ns.PrintMessage(string.format(L["ITEM_WILL_AUTO_OPEN"], link))
    end

    if ns.DB.lootSounds then
        local lootWindowOpen = (LootFrame and LootFrame:IsShown())
        local lootWindowRecentlyOpen = (GetTime() - ns.state.lastLootWindowAt) < 2

        if lootWindowOpen or lootWindowRecentlyOpen then
            local colorSequence = link:match("|c(%x+)|H")
            if colorSequence and #colorSequence == 8 then
                local hex = string.lower(string.sub(colorSequence, 3, 8))
                if hex ~= "9d9d9d" and hex ~= "ffffff" then
                    PlaySound(ns.LOOT_SOUND_ID, "Master")
                end
            end
        end
    end

    OnScanRequest()
end

EventHandlers.BANKFRAME_CLOSED = OnInteractionClosed
EventHandlers.GOSSIP_CLOSED = OnInteractionClosed
EventHandlers.MAIL_CLOSED = OnInteractionClosed
EventHandlers.MERCHANT_CLOSED = OnInteractionClosed
EventHandlers.QUEST_FINISHED = OnInteractionClosed
EventHandlers.TRADE_CLOSED = OnInteractionClosed
EventHandlers.PLAYER_INTERACTION_MANAGER_FRAME_HIDE = OnInteractionClosed
EventHandlers.LOADING_SCREEN_ENABLED = OnLoadStart
EventHandlers.LOADING_SCREEN_DISABLED = OnLoadEnd

--------------------------------------------------------------------------------
-- Event Frame
--------------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if ns.diagnostics and ns.diagnostics.logging then ns:LogEvent(event, ...) end
        if EventHandlers[event] then
            EventHandlers[event](self, ...)
        end
    end
)

--[[
    Exported for Features/Diagnostics.lua so the event probe can never drift
    from the events the addon actually registers.
]]
ns.EVENT_NAMES = {}
for event in pairs(EventHandlers) do
    ns.EVENT_NAMES[#ns.EVENT_NAMES + 1] = event
end
table.sort(ns.EVENT_NAMES)

--[[
    Register only events valid on the running client. Harmless on current
    builds (every event is valid on 11508/20505); guards future builds where
    an event name may not exist, so one bad name can't abort the whole loop.
]]
local IsEventValid = C_EventUtils and C_EventUtils.IsEventValid
for event in pairs(EventHandlers) do
    if IsEventValid then
        if IsEventValid(event) then
            eventFrame:RegisterEvent(event)
        end
    else
        pcall(eventFrame.RegisterEvent, eventFrame, event)
    end
end