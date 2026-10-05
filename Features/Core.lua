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
    Loot-message prefixes: the text before %s in the client's own loot format
    strings ("You receive loot: %s."). Only the prefix is matched, because what
    follows the link differs by locale (zhCN ends in "。"). Guarded in case the
    globals are absent at load; CHAT_MSG_LOOT references these cached upvalues.
]]
local lootSelfPrefix = LOOT_ITEM_SELF and LOOT_ITEM_SELF:match("^(.-)%%s")
local lootPushedPrefix = LOOT_ITEM_PUSHED_SELF and LOOT_ITEM_PUSHED_SELF:match("^(.-)%%s")

--[[
    The prefix must open the line, not merely appear in it: in koKR another
    player's line ("%s님이 아이템을 획득했습니다: %s") contains the player's own
    prefix whole. An empty prefix would match every line, so it never counts.
]]
local function StartsWithPrefix(msg, prefix)
	return prefix ~= nil and prefix ~= "" and msg:sub(1, #prefix) == prefix
end

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
	-- Whether a corpse or chest's loot window is open, and when the last one closed.
	worldLootOpen = false,
	worldLootClosedAt = 0,
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

	-- MIGRATION (remove after 2026-11-04): the mini-map subtable moved to the profile under the Simple model.
	if type(ns.db.global.minimap) == "table" then
		ns.db.global.minimap = nil
	end

	-- MIGRATION (remove after 2026-11-04): Loot Toasts was removed; clear its keys from every profile and its global anchor.
	for _, profile in pairs(ns.db.profiles) do
		for key in pairs(profile) do
			if key:find("^lootToast") then
				profile[key] = nil
			end
		end
	end
	ns.db.global.lootToastPosition = nil

	ns:SeedIgnoreList()

	ns.isEnabled = ns.db.profile.autoOpen
	ns.isSpeedyLoot = ns.db.profile.speedyLoot

	ns:RegisterOptionsPanels()

	ns.db.RegisterCallback(ns, "OnProfileChanged", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileReset", ApplyProfile)
	ns.db.RegisterCallback(ns, "OnProfileCopied", ApplyProfile)

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
	ns:PrintEndOfSupport()
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
	-- On WoW Forever this payload is secret while the player's casts are restricted.
	if C_Secrets.ShouldUnitSpellCastingBeSecret("player") then
		return
	end
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
	-- Each step runs on its own, so an error in a sound can't stop Speedy Loot.
	securecallfunction(ns.StampWorldLoot)
	securecallfunction(ns.PlayPickPocketSound)
	ns.HandleSpeedyLoot()
end

function EventHandlers:LOOT_OPENED()
	ns.StampWorldLoot()
	ns.PlayPickPocketSound()
	ns.OnOpenAnswered()
end

--[[
    Clear Speedy Loot's window-suppression verdict when the loot session ends, so
    a throttled LOOT_READY on the next corpse can't reuse this corpse's "fully
    looted" state to hide a window that still has items in it. Registered
    automatically like every handler here (see the EventHandlers loop below).
    An open loot window also holds Auto-Opening (opening a container would
    replace a corpse's window and strand what Speedy Loot left in it), so its
    close rescans like any other interaction window's.
]]
function EventHandlers:LOOT_CLOSED()
	if ns.ResetSpeedyLootWindow then
		ns.ResetSpeedyLootWindow()
	end
	ns.CloseWorldLoot()
	OnInteractionClosed()
end

EventHandlers.BAG_UPDATE_DELAYED = OnScanRequest
EventHandlers.BAG_NEW_ITEMS_UPDATED = OnScanRequest

-- Whether the player was in a group at the last roster update; nil before the first.
local wasGrouped = nil

-- The Group hold-off reads only whether the player is grouped, so a roster update rescans only when that changes.
function EventHandlers:GROUP_ROSTER_UPDATE()
	local isGrouped = IsInGroup()
	if isGrouped ~= wasGrouped then
		wasGrouped = isGrouped
		OnScanRequest()
	end
end

function EventHandlers:PLAYER_LEVEL_UP()
	ns.OnLevelUp()
end

--[[
    The Ignore List panel draws item links, and C_Item.GetItemInfo returns nil
    until the client has the item cached. Options-Utilities sets
    ns.OnItemInfoReceived while any row is still uncached and clears it once
    nothing is outstanding; routing it through the dispatcher rather than a
    private frame keeps the single registration rule and puts the event in
    ns.EVENT_NAMES for the diagnostics probe.
]]
function EventHandlers:GET_ITEM_INFO_RECEIVED(itemId, success)
	if ns.OnItemInfoReceived then
		ns.OnItemInfoReceived(itemId, success)
	end
end

--[[
    Only the player's own loot reaches their bags, so only it rescans; a raid's
    loot lines would otherwise walk the bags on every member's pickup.
    BAG_UPDATE_DELAYED covers anything this misses.
]]
function EventHandlers:CHAT_MSG_LOOT(msg)
	if not msg or not (StartsWithPrefix(msg, lootSelfPrefix) or StartsWithPrefix(msg, lootPushedPrefix)) then
		return
	end

	-- Either colour form: |cffRRGGBB, or the Retail engine's |cnIQn: quality escape.
	local link = msg:match("(|c[^|]+|Hitem:.-|h%[.-%]|h|r)")
	if not link then
		OnScanRequest()
		return
	end

	-- Each step runs on its own, so an error in the notice can't silence the sound or skip the rescan.
	securecallfunction(ns.AnnounceLootedContainer, tonumber(link:match("item:(%d+)")), link)
	securecallfunction(ns.PlayLootSound, link)

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
    Exported for Diagnostics/Code-Reports.lua so the event probe can never drift
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
