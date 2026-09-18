local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L

--------------------------------------------------------------------------------
-- API References
--------------------------------------------------------------------------------

local CreateFrame, C_Timer, tonumber = CreateFrame, C_Timer, tonumber

--[[
    Loot-message prefixes, derived once from the global loot format strings
    (e.g. "You receive loot: %s."). Guarded in case the globals are absent at
    load; CHAT_MSG_LOOT references these cached upvalues.
]]
local lootSelfPrefix = LOOT_ITEM_SELF and LOOT_ITEM_SELF:gsub("%%s", ""):gsub("%.$", "")
local lootPushedPrefix = LOOT_ITEM_PUSHED_SELF and LOOT_ITEM_PUSHED_SELF:gsub("%%s", ""):gsub("%.$", "")

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

--[[
    Add-on identity. Read from TOC metadata; the TOC Version field carries the
    packager's version token, replaced only at build time, so an unreplaced
    token (the @ is the signal) means a local dev copy and displays as "Dev".
]]
local version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version") or "Dev"
if version:find("@") then
	version = "Dev"
end
ns.Version = version

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
	lastWorldLootAt = 0,
	-- When Pick Pocket last landed; 0 once its sound has played or nothing came.
	pickPocketAt = 0,
	lastStatusAt = 0,
	lastStatusMsg = nil,
	openTimerLive = false,
	quietUntil = 0,
	recentAnnouncements = {},
	scanPending = false,
	scanTimerAt = 0,
}

--------------------------------------------------------------------------------
-- Welcome
--------------------------------------------------------------------------------

local function PrintWelcome()
	if not ns.db.profile.showWelcome then
		return
	end
	ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

--------------------------------------------------------------------------------
-- Profile Application
--------------------------------------------------------------------------------

--[[
    Push the active profile's settings onto the runtime flags and dependent UI.
    Registered on AceDB's profile-change/reset/copy callbacks so switching or
    resetting a profile from the stock Profiles panel takes effect live instead
    of waiting for a reload. Not called on initial login — PLAYER_LOGIN and
    PLAYER_ENTERING_WORLD own the first-time setup and ordering.
]]
local function ApplyProfile()
	ns.isEnabled = ns.db.profile.autoOpen
	ns.isSpeedyLoot = ns.db.profile.speedyLoot

	if ns.isEnabled or ns.isSpeedyLoot then
		ns.EnsureAutoLoot()
	end
	ns.ScheduleScan(true)
	ns:UpdateMinimapIcon()
	if ns.ApplyLootToastPosition then
		ns.ApplyLootToastPosition()
	end
	if ns.ApplyLootToastSettings then
		ns.ApplyLootToastSettings()
	end
	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
	for _, registryName in pairs(ns.OPTIONS_REGISTRY) do
		AceConfigRegistry:NotifyChange(registryName)
	end
end

--------------------------------------------------------------------------------
-- PLAYER_LOGIN, PLAYER_ENTERING_WORLD
--------------------------------------------------------------------------------

local EventHandlers = {}

function EventHandlers:PLAYER_LOGIN()
	ns.db = LibStub("AceDB-3.0"):New("OpenSesameDB", ns.DATABASE_DEFAULTS, true)

	-- Deprecated key: the mini-map subtable moved to the profile under the Simple model.
	if type(ns.db.global.minimap) == "table" then
		ns.db.global.minimap = nil
	end

	-- Deprecated keys: the outline and bold toggles became lootToastFontFlags.
	ns.db.profile.lootToastFontOutline = nil
	ns.db.profile.lootToastFontBold = nil

	ns:SeedIgnoreList()

	ns.isEnabled = ns.db.profile.autoOpen
	ns.isSpeedyLoot = ns.db.profile.speedyLoot

	ns:RegisterOptionsPanels()

	ns.db.RegisterCallback(ns, "OnProfileChanged", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileReset", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileCopied", ApplyProfile)

	if ns.ApplyLootToastPosition then
		ns.ApplyLootToastPosition()
	end
	--[[
        Toasts ship on, so a profile that has never dismissed the drag handle is
        shown it here: the feature introducing itself, once, rather than a player
        meeting it as loot drawn somewhere they did not choose. It stays up until
        they put it away.
    ]]
	if ns.ShowLootToastIntro then
		ns.ShowLootToastIntro()
	end
	if ns.InitMinimap then
		ns:InitMinimap()
	end
	--[[
        Deliberately hooked HERE rather than while Lockbox-Tooltips.lua loads.
        Tooltip post-hooks run in the order they were registered, and by
        PLAYER_LOGIN every add-on has loaded and hooked, so ours runs after
        theirs and our block reads last. See the note above the hook itself.
    ]]
	if ns.InstallTooltipHook then
		ns.InstallTooltipHook()
	end
	ns:UpdateMinimapIcon()
	PrintWelcome()
end

function EventHandlers:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
	if isInitialLogin or isReloadingUi then
		C_Timer.After(ns.WORLD_LOAD_DELAY, ns.OnWorldLoaded)
	else
		ns:SetQuiet(2)
		-- Zoning out of an instance can lift the Where hold-off, so rescan.
		ns.ScheduleScan()
	end
end

--------------------------------------------------------------------------------
-- Combat, Stealth, Spellcast
--------------------------------------------------------------------------------

function EventHandlers:PLAYER_REGEN_ENABLED()
	ns.OnCombatEnded()
end

function EventHandlers:UPDATE_STEALTH()
	ns.OnStealthChanged()
end

function EventHandlers:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
	if unit ~= "player" then
		return
	end
	if spellID == ns.SPELLS.PICK_LOCK then
		ns.RescanAfterUnlock()
	elseif spellID == ns.SPELLS.PICK_POCKET then
		ns.ArmPickPocketSound()
	end
end

--------------------------------------------------------------------------------
-- UI_ERROR_MESSAGE
--------------------------------------------------------------------------------

function EventHandlers:UI_ERROR_MESSAGE(errTypeOrID)
	ns.OnBagFullError(errTypeOrID)
end

--------------------------------------------------------------------------------
-- Bag, Loot, Interaction Events
--------------------------------------------------------------------------------

local function OnScanRequest()
	ns.ScheduleScan()
end
local function OnInteractionClosed()
	ns.ScheduleScan(true)
	C_Timer.After(ns.STATUS_FLUSH_DELAY, ns.AnnounceStatus)
end
local function OnLoadStart()
	ns:SetQuiet(10)
end
local function OnLoadEnd()
	ns:SetQuiet(3)
end

--[[
    One registration owns LOOT_READY, and the order is load-bearing. Stamp
    world-loot state and play the Pick Pocket sound first, so both read the
    slots while they are still populated, then run Speedy Loot, which empties
    them via LootSlot. The first two live in Features/Loot-Sounds.lua.
]]
function EventHandlers:LOOT_READY()
	ns.StampWorldLoot()
	ns.PlayPickPocketSound()
	ns.HandleSpeedyLoot()
end

function EventHandlers:LOOT_OPENED()
	ns.StampWorldLoot()
	ns.PlayPickPocketSound()
end

--[[
    Clear Speedy Loot's window-suppression verdict when the loot session ends, so
    a throttled LOOT_READY on the next corpse can't reuse this corpse's "fully
    looted" state to hide a window that still has items in it. Registered
    automatically like every handler here (see the EventHandlers loop below).
]]
function EventHandlers:LOOT_CLOSED()
	if ns.ResetSpeedyLootWindow then
		ns.ResetSpeedyLootWindow()
	end
end

EventHandlers.BAG_UPDATE_DELAYED = OnScanRequest
EventHandlers.BAG_NEW_ITEMS_UPDATED = OnScanRequest
-- Joining or leaving a group can flip the Group hold-off either way.
EventHandlers.GROUP_ROSTER_UPDATE = OnScanRequest

--[[
    The Ignore List panel draws item links, and C_Item.GetItemInfo returns nil
    until the client has the item cached. Options-Utilities sets
    ns.OnItemInfoReceived while any row is still uncached and clears it once
    nothing is outstanding; routing it through the dispatcher rather than a
    private frame keeps the single registration rule and puts the event in
    ns.EVENT_NAMES for the diagnostics probe.
]]
function EventHandlers:GET_ITEM_INFO_RECEIVED(itemId)
	if ns.OnItemInfoReceived then
		ns.OnItemInfoReceived(itemId)
	end
end

--[[
    Coin is the loot Speedy Loot hides most completely: it has no item, no quality
    and no link, so nothing else in this file has anything to say about it, and
    with the loot window gone the only record is the chat line this event carries.
    The amount comes back out of that sentence -- see ns.ParseMoney.
]]
function EventHandlers:CHAT_MSG_MONEY(msg)
	if ns.ShowMoneyToast then
		ns.ShowMoneyToast(ns.ParseMoney(msg))
	end
end

function EventHandlers:CHAT_MSG_LOOT(msg)
	if not msg then
		OnScanRequest()
		return
	end

	if
		not (
			(lootSelfPrefix and msg:find(lootSelfPrefix, 1, true))
			or (lootPushedPrefix and msg:find(lootPushedPrefix, 1, true))
		)
	then
		OnScanRequest()
		return
	end

	local link = msg:match("(|c%x+|Hitem:.-|h%[.-%]|h|r)")
	if not link then
		OnScanRequest()
		return
	end

	ns.AnnounceLootedContainer(tonumber(link:match("item:(%d+)")), link)
	ns.PlayLootSound(link)

	if ns.ShowLootToast then
		ns.ShowLootToast(link, msg)
	end

	OnScanRequest()
end

EventHandlers.BANKFRAME_CLOSED = OnInteractionClosed
EventHandlers.GOSSIP_CLOSED = OnInteractionClosed
EventHandlers.MAIL_CLOSED = OnInteractionClosed
EventHandlers.MERCHANT_CLOSED = OnInteractionClosed
EventHandlers.QUEST_FINISHED = OnInteractionClosed
EventHandlers.PLAYER_INTERACTION_MANAGER_FRAME_HIDE = OnInteractionClosed
EventHandlers.LOADING_SCREEN_ENABLED = OnLoadStart
EventHandlers.LOADING_SCREEN_DISABLED = OnLoadEnd

--[[
    Trade close needs more than the shared immediate rescan. When another rogue
    picks the locks on boxes sitting in the trade window there is no event on our
    side to hear it — UNIT_SPELLCAST_SUCCEEDED only fires for our own casts — and
    the freshly unlocked state often has not settled client-side by the time
    TRADE_CLOSED fires, so an immediate scan still reads the boxes as locked. Run
    the shared immediate scan, then a second forced scan after
    PICK_LOCK_RESCAN_DELAY (the same settle delay our own Pick Lock uses) so boxes
    another rogue unlocked open on their own instead of sitting in the bags until
    the next bag update.
]]
function EventHandlers:TRADE_CLOSED()
	OnInteractionClosed()
	ns.RescanAfterUnlock()
end

--------------------------------------------------------------------------------
-- Event Frame
--------------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	if ns.diagnostics and ns.diagnostics.logging then
		ns:LogEvent(event, ...)
	end
	if EventHandlers[event] then
		EventHandlers[event](self, ...)
	end
end)

--[[
    Exported for Features/Diagnostics.lua so the event probe can never drift
    from the events the add-on actually registers.
]]
ns.EVENT_NAMES = {}
for event in pairs(EventHandlers) do
	ns.EVENT_NAMES[#ns.EVENT_NAMES + 1] = event
end
table.sort(ns.EVENT_NAMES)

--[[
    Register only events valid on the running client. Every event in the list is
    valid on all three target clients today; the check guards future builds
    where an event name may not exist, so one bad name can't abort the whole
    loop.
]]
local IsEventValid = C_EventUtils.IsEventValid
for event in pairs(EventHandlers) do
	if IsEventValid(event) then
		--[[
            UNIT_SPELLCAST_SUCCEEDED fires for every unit; only the player's own
            Pick Lock and Pick Pocket matter here, so filter it to "player" at
            registration to avoid waking on every group member's cast. The
            handler keeps its unit == "player" guard as a belt-and-suspenders
            check.
        ]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			eventFrame:RegisterUnitEvent(event, "player")
		else
			eventFrame:RegisterEvent(event)
		end
	end
end
