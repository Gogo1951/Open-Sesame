local _, ns = ...

--------------------------------------------------------------------------------
-- Diagnostic Tools
--------------------------------------------------------------------------------

--[[
    Environment probing and state capture for bug reports, not unit tests. WoW's
    sandboxed Lua has no assertion runner, so everything here is read-only and
    side-effect free. The one exception is the explicit Taint Log button, which
    sets the taintLog CVar. Reports build only on a button press, never on load
    or panel open.
]]

local L = ns.L

--------------------------------------------------------------------------------
-- Runtime State
--------------------------------------------------------------------------------

--[[
    Runtime-only state. NOT a SavedVariable. File-scope init is correct here —
    the "initialize on PLAYER_LOGIN" rule applies only to SavedVariables, which
    don't exist until the client loads them. This is a plain namespace table.
]]
ns.diagnostics = ns.diagnostics or { enabled = false, logging = false, log = nil }

--------------------------------------------------------------------------------
-- Strings
--------------------------------------------------------------------------------

--[[
    Diagnostics strings are intentionally NOT localized. They are
    developer-facing troubleshooting text; translating them is wasted effort for
    zero player value. Every diagnostics string lives here as plain English, in
    the diagnostics files only — never in Locales/. The one exception is the
    add-on's own display name, read from ns.L["ADDON_TITLE"], which is the
    add-on's identity, not a diagnostics string.
]]
ns.DiagnosticsStrings = {
	TAB = "Diagnostic Tools",
	WARNING = "These tools help diagnose problems and are meant for developers. They won't change how the add-on works, but their output includes technical details about your client and installed add-ons. Leave this off unless you're troubleshooting with someone.",
	ENABLE = "Enable Diagnostic Tools",
	EVENT_LOG_TITLE = "Event Log",
	EVENT_LOG_START = "Start Event Log",
	EVENT_LOG_STOP = "Stop Event Log",
	EVENT_LOG_SHOW = "Show Captured Events",
	EVENT_LOG_HINT = "Captures events the add-on registered for, with arguments, in order fired. May include loot chat text — review before sharing.",
	EVENTS_TITLE = "Event Registration",
	EVENTS_BUTTON = "Test Event Registration",
	API_TITLE = "API Endpoints",
	API_BUTTON = "Test WoW API Endpoints",
	LOOT_TITLE = "Loot Method",
	LOOT_BUTTON = "Test Loot Method API",
	CVARS_TITLE = "Relevant CVars",
	CVARS_BUTTON = "Read Relevant CVars",
	DISPLAY_TITLE = "Display Context",
	DISPLAY_BUTTON = "Read Display Context",
	ADDONS_TITLE = "Other Add-ons",
	ADDONS_BUTTON = "List Installed Add-ons",
	SAVED_TITLE = "Saved Variables",
	SAVED_BUTTON = "Dump Saved Variables",
	LIBS_TITLE = "Library Versions",
	LIBS_BUTTON = "List Library Versions",
	TAINT_TITLE = "Taint Log",
	TAINT_STATE = "Taint logging is currently set to level %d (0 = off, 2 = verbose).",
	TAINT_ON = "Turn On Taint Log",
	TAINT_OFF = "Turn Off Taint Log",
	TAINT_HINT = "Writes to Logs\\taint.log. The setting persists until turned off; reload your UI to capture taint from login onward.",
	TOOLS_TITLE = "External Tools",
	TOOLS_ERRORS = "Lua errors: install BugSack and !BugGrabber, or enable %s to surface them.",
	TOOLS_ETRACE = "Live event tracing: use %s.",
}

--------------------------------------------------------------------------------
-- Enable Gate
--------------------------------------------------------------------------------

function ns:SetDiagnosticsEnabled(value)
	ns.diagnostics.enabled = value and true or false
	if not ns.diagnostics.enabled then
		ns:StopEventLog()
	end
end

--------------------------------------------------------------------------------
-- Report Header
--------------------------------------------------------------------------------

local function GetClientHeader()
	local version, build, _, tocVersion = GetBuildInfo()
	return string.format(
		"%s %s // Client %s // Build %s // TOC %s // Locale %s // Project %s",
		L["ADDON_TITLE"],
		ns.Version,
		version,
		build,
		tocVersion,
		GetLocale(),
		tostring(WOW_PROJECT_ID)
	)
end

--------------------------------------------------------------------------------
-- Event Log
--------------------------------------------------------------------------------

local EVENT_LOG_SIZE = 500
local EVENT_LOG_MAX_ARGS = 8

--[[
    Per-argument byte cap. It has to clear a full loot line: a single item link
    (|cff...|Hitem:...|h[Name]|h|r) plus the "You receive loot:" prefix runs well
    past 80 bytes, and a cap under that slices the link mid-name and collapses the
    entry to a sliver like "[Sc". 255 holds the line while still bounding a
    runaway argument.
]]
local EVENT_LOG_MAX_ARG_LENGTH = 255

--[[
    Events ns:LogEvent drops entirely before recording — deliberately empty, and
    the drop-entirely mechanism is currently unused. Nothing Open Sesame
    registers is pure noise: the addon listens on the coalesced
    BAG_UPDATE_DELAYED rather than raw BAG_UPDATE, and every registered event is
    potential signal in a bug report. UI_ERROR_MESSAGE is the one firehose here,
    but it is only *sometimes* noise — the inventory-full firing is exactly what
    the log needs — so it goes through the per-id filter below instead of being
    excluded. Generic offenders (COMBAT_LOG_EVENT_UNFILTERED, UNIT_AURA, ...) do
    not belong here unless registered: the log never sees an event the addon
    didn't register.
]]
ns.DIAGNOSTIC_EVENT_EXCLUDE = {}

--[[
    Events that carry a message id, and the argument position it arrives in.
    ns:SuppressUncorrelatedMessage classifies these per firing rather than
    dropping the event wholesale.
]]
ns.MESSAGE_ID_FILTERED_EVENTS = {
	UI_ERROR_MESSAGE = 1,
}

--[[
    Per-firing filter for the events above. UI_ERROR_MESSAGE fires on every red
    combat error ("Ability is not ready yet."), which against a bounded buffer
    silently evicts the entries the log exists to carry. The allowlist is what
    the addon actually correlates — the inventory-full id, classified through
    Core's ns.IsBagFullErrorID so this can never drift from the live handler.
    Everything else folds into a per-id counter (first-seen text plus a count)
    rendered as one block at the end of the report. A firing carrying no numeric
    id in the filtered position is unclassifiable, and unclassifiable is signal:
    it logs verbatim.

    Returns true when the firing was counted and must not reach the buffer.
]]
function ns:SuppressUncorrelatedMessage(event, ...)
	local idPosition = ns.MESSAGE_ID_FILTERED_EVENTS[event]
	if not idPosition then
		return false
	end
	local messageID = select(idPosition, ...)
	if type(messageID) ~= "number" then
		return false
	end
	if ns.IsBagFullErrorID(messageID) then
		return false
	end
	local suppressed = ns.diagnostics.suppressed
	if not suppressed then
		return true
	end
	local entry = suppressed[messageID]
	if entry then
		entry.count = entry.count + 1
		return true
	end
	local text = ""
	if select("#", ...) > idPosition then
		local raw = string.sub(tostring((select(idPosition + 1, ...))), 1, EVENT_LOG_MAX_ARG_LENGTH)
		text = (raw:gsub("|", "||"))
	end
	suppressed[messageID] = { event = event, text = text, count = 1 }
	return true
end

function ns:StartEventLog()
	ns.diagnostics.log = {}
	ns.diagnostics.suppressed = {}
	ns.diagnostics.logging = true
end

function ns:StopEventLog()
	ns.diagnostics.logging = false
	ns.diagnostics.log = nil
	ns.diagnostics.suppressed = nil
end

--[[
    Called by Core's dispatcher for every event while logging is active.
    Snapshots arguments to strings immediately — never retain references, since
    some events carry frames or tables that would leak memory or go stale. Caps
    the arg count and string length so a single entry can't run away.

    Pipes are escaped (| -> ||) AFTER the length cut so each argument shows
    verbatim in the report editbox. WoW treats |c colour codes and |Hitem links
    as display escapes, so an unescaped loot line renders as a clickable item
    swatch — hiding the link data we want, and when the entry is cut mid-link it
    collapses to a stray "[Sc". Escaping last also means the cut can never leave
    a dangling pipe that would eat the following ", " separator.
]]
function ns:LogEvent(event, ...)
	if ns.DIAGNOSTIC_EVENT_EXCLUDE[event] then
		return
	end
	if ns:SuppressUncorrelatedMessage(event, ...) then
		return
	end
	local parts = {}
	for index = 1, select("#", ...) do
		if index > EVENT_LOG_MAX_ARGS then
			break
		end
		local raw = string.sub(tostring((select(index, ...))), 1, EVENT_LOG_MAX_ARG_LENGTH)
		parts[index] = (raw:gsub("|", "||"))
	end
	local log = ns.diagnostics.log
	log[#log + 1] = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
	if #log > EVENT_LOG_SIZE then
		table.remove(log, 1)
	end
end

--[[
    Renders the suppressed-traffic counters as one compact block, biggest
    offender first. This is also how a tester discovers a message id the addon
    should be correlating but isn't.
]]
local function AppendSuppressedSummary(lines)
	local suppressed = ns.diagnostics.suppressed
	if not suppressed then
		return
	end
	local rows = {}
	for messageID, entry in pairs(suppressed) do
		rows[#rows + 1] = { id = messageID, entry = entry }
	end
	if #rows == 0 then
		return
	end
	table.sort(rows, function(a, b)
		if a.entry.count ~= b.entry.count then
			return a.entry.count > b.entry.count
		end
		return a.id < b.id
	end)
	lines[#lines + 1] = ""
	lines[#lines + 1] = "Suppressed uncorrelated traffic:"
	for _, row in ipairs(rows) do
		lines[#lines + 1] = string.format("%s(%d, %s) x%d", row.entry.event, row.id, row.entry.text, row.entry.count)
	end
end

function ns:BuildEventLogReport()
	local lines = { GetClientHeader(), "" }
	local log = ns.diagnostics.log
	if not log or #log == 0 then
		lines[#lines + 1] = "(no events captured)"
	else
		for _, entry in ipairs(log) do
			lines[#lines + 1] = entry
		end
	end
	AppendSuppressedSummary(lines)
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Event Registration
--------------------------------------------------------------------------------

--[[
    For every event Open Sesame registers (ns.EVENT_NAMES, exported by Core.lua),
    report whether it is valid on this client (C_EventUtils.IsEventValid) and
    whether RegisterEvent succeeds. The probe frame registers then immediately
    unregisters each event with no handler attached, so nothing is ever
    processed. The list is sourced from Core so it can never drift from the
    events the addon actually uses.
]]

local probeFrame

local function GetProbeFrame()
	if not probeFrame then
		probeFrame = CreateFrame("Frame")
	end
	return probeFrame
end

function ns:RunEventChecks()
	local lines = { GetClientHeader(), "" }
	local probe = GetProbeFrame()
	local failures = 0
	for _, event in ipairs(ns.EVENT_NAMES or {}) do
		local valid = C_EventUtils.IsEventValid(event) and "valid" or "INVALID"
		local ok = pcall(probe.RegisterEvent, probe, event)
		if ok then
			probe:UnregisterEvent(event)
		else
			failures = failures + 1
		end
		lines[#lines + 1] = string.format("[%s] %s (IsEventValid: %s)", ok and "PASS" or "FAIL", event, valid)
	end
	lines[#lines + 1] = ""
	if failures == 0 then
		lines[#lines + 1] = "All events register on this client."
	else
		lines[#lines + 1] = string.format("%d event(s) failed to register.", failures)
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

--[[
    Existence and shape checks only: read-only, no side effects, no protected
    calls. One row per API the add-on actually calls - Features/Utilities.lua,
    Features/Core.lua, Features/Speedy-Loot.lua, Features/Lockbox-Tooltips.lua,
    Features/Loot-Toasts.lua, Options/Options.lua and this file - plus the
    handful of client values they read. Every API reached through an
    availability guard carries a row here, so a FAIL names the guard that is
    about to take the fallback path rather than leaving it silent.
]]
ns.DIAGNOSTIC_API_CHECKS = {
	-- { label, testFunction }
	{
		"C_AddOns.GetAddOnMetadata",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnMetadata) == "function"
		end,
	},
	{
		"C_AddOns.GetAddOnInfo",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnInfo) == "function"
		end,
	},
	{
		"C_AddOns.GetNumAddOns",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetNumAddOns) == "function"
		end,
	},
	{
		"C_Container.GetContainerNumSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumSlots) == "function"
		end,
	},
	{
		"C_Container.GetContainerNumFreeSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumFreeSlots) == "function"
		end,
	},
	{
		"C_Container.GetContainerItemID",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerItemID) == "function"
		end,
	},
	{
		"C_Container.GetContainerItemLink",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerItemLink) == "function"
		end,
	},
	{
		"C_Container.UseContainerItem",
		function()
			return type(C_Container) == "table" and type(C_Container.UseContainerItem) == "function"
		end,
	},
	{
		"GetSpellInfo",
		function()
			return type(GetSpellInfo) == "function"
		end,
	},
	{
		"GetNumSkillLines",
		function()
			return type(GetNumSkillLines) == "function"
		end,
	},
	{
		"GetSkillLineInfo",
		function()
			return type(GetSkillLineInfo) == "function"
		end,
	},
	--[[
        Not an API so much as a row of client data the add-on depends on: spell
        1809's name is the localized name of the Lockpicking skill line, and
        Features/Lockbox-Tooltips.lua has no other handle for finding the player's
        rank. A FAIL here means the requirement line goes neutral instead of green
        or red.
    ]]
	{
		"Lockpicking skill name (spell 1809)",
		function()
			return type(ns.GetSpellName(ns.SPELLS.LOCKPICKING)) == "string"
		end,
	},
	{
		"GetItemInfo",
		function()
			return type(GetItemInfo) == "function"
		end,
	},
	{
		"GetItemInfoInstant",
		function()
			return type(GetItemInfoInstant) == "function"
		end,
	},
	--[[
        A position, not an endpoint. Loot Toasts' Bind on Pickup bypass reads
        bindType as GetItemInfo's 14th return, which is the one thing in that
        feature no type check would catch if a client shifted it. Probed against
        the Hearthstone, which is Bind on Pickup and in every player's bag, so the
        row answers from a warm cache on any character.
    ]]
	{
		"GetItemInfo bindType (14th return)",
		function()
			return select(14, GetItemInfo(ns.ITEM_BIND_PROBE_ID)) == ns.ITEM_BIND_ON_PICKUP
		end,
	},
	--[[
        Client strings the add-on reads rather than translates. ITEM_STARTS_QUEST
        is matched against a tooltip line to spot a quest starter, ITEM_MIN_SKILL
        becomes the pattern that decides whether the client already states a
        lockbox's requirement, the two LOOT_ITEM formats become the prefixes that
        identify the player's own loot, and the three AMOUNT formats are turned
        into patterns to read a coin total out of a loot message. For all of these
        a FAIL means the feature goes quiet rather than errors: an unmatched
        pattern simply never matches. LOCKED below is the exception and says so.
    ]]
	{
		"ITEM_STARTS_QUEST (global string)",
		function()
			return type(ITEM_STARTS_QUEST) == "string"
		end,
	},
	{
		"ITEM_MIN_SKILL (global string)",
		function()
			return type(ITEM_MIN_SKILL) == "string"
		end,
	},
	-- A FAIL silences the loot sound and every loot toast: neither can identify the player's own loot without these.
	{
		"LOOT_ITEM_SELF / LOOT_ITEM_PUSHED_SELF (global strings)",
		function()
			return type(LOOT_ITEM_SELF) == "string" and type(LOOT_ITEM_PUSHED_SELF) == "string"
		end,
	},
	-- The one row whose FAIL is not silence: with no LOCKED, every box reads as unlocked and the queue tries to open boxes it cannot.
	{
		"LOCKED (global string)",
		function()
			return type(LOCKED) == "string"
		end,
	},
	{
		"GOLD_AMOUNT / SILVER_AMOUNT / COPPER_AMOUNT (global strings)",
		function()
			return type(GOLD_AMOUNT) == "string" and type(SILVER_AMOUNT) == "string" and type(COPPER_AMOUNT) == "string"
		end,
	},
	{
		"Coin total read back from a loot message",
		function()
			return ns.ParseMoney(string.format(GOLD_AMOUNT, 1) .. " " .. string.format(COPPER_AMOUNT, 7)) == 10007
		end,
	},
	{
		"GetItemIcon",
		function()
			return type(GetItemIcon) == "function"
		end,
	},
	{
		"GetNumLootItems",
		function()
			return type(GetNumLootItems) == "function"
		end,
	},
	{
		"GetLootSourceInfo",
		function()
			return type(GetLootSourceInfo) == "function"
		end,
	},
	{
		"GetLootSlotType",
		function()
			return type(GetLootSlotType) == "function"
		end,
	},
	{
		"GetLootSlotLink",
		function()
			return type(GetLootSlotLink) == "function"
		end,
	},
	{
		"GetLootThreshold",
		function()
			return type(GetLootThreshold) == "function"
		end,
	},
	{
		"LootSlot",
		function()
			return type(LootSlot) == "function"
		end,
	},
	{
		"IsModifiedClick",
		function()
			return type(IsModifiedClick) == "function"
		end,
	},
	{
		"C_PartyInfo.GetLootMethod",
		function()
			return type(C_PartyInfo) == "table" and type(C_PartyInfo.GetLootMethod) == "function"
		end,
	},
	{
		"C_CVar.GetCVar",
		function()
			return type(C_CVar) == "table" and type(C_CVar.GetCVar) == "function"
		end,
	},
	{
		"C_CVar.GetCVarBool",
		function()
			return type(C_CVar) == "table" and type(C_CVar.GetCVarBool) == "function"
		end,
	},
	{
		"C_CVar.SetCVar",
		function()
			return type(C_CVar) == "table" and type(C_CVar.SetCVar) == "function"
		end,
	},
	{
		"UnitCastingInfo",
		function()
			return type(UnitCastingInfo) == "function"
		end,
	},
	{
		"UnitChannelInfo",
		function()
			return type(UnitChannelInfo) == "function"
		end,
	},
	{
		"IsStealthed",
		function()
			return type(IsStealthed) == "function"
		end,
	},
	{
		"C_UnitAuras.GetBuffDataByIndex",
		function()
			return type(C_UnitAuras) == "table" and type(C_UnitAuras.GetBuffDataByIndex) == "function"
		end,
	},
	{
		"C_EventUtils.IsEventValid",
		function()
			return type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
		end,
	},
	{
		"C_Timer.After",
		function()
			return type(C_Timer) == "table" and type(C_Timer.After) == "function"
		end,
	},
	{
		"GetPhysicalScreenSize",
		function()
			return type(GetPhysicalScreenSize) == "function"
		end,
	},
	--[[
        The one availability guard the add-on keeps, in ns:OpenOptionsPanel. A
        FAIL means the options panel falls through to AceConfigDialog:Open and
        opens as a floating window instead of docking into the Settings tree.
    ]]
	{
		"Settings.OpenToCategory",
		function()
			return type(Settings) == "table" and type(Settings.OpenToCategory) == "function"
		end,
	},
	{
		"LOOT_SLOT_ITEM",
		function()
			return LOOT_SLOT_ITEM ~= nil
		end,
	},
	{
		"LE_GAME_ERR_INV_FULL",
		function()
			return LE_GAME_ERR_INV_FULL ~= nil
		end,
	},
	--[[
        Both drive the Notifications panel's quality dropdowns at file scope, and
        ITEM_QUALITY_COLORS also colours the loot-toast preview rows. The colour
        table is probed for its `hex` field rather than mere existence: a shape
        change is what would actually break the panel, and an existence check
        would pass straight through it.
    ]]
	{
		"ITEM_QUALITY_COLORS",
		function()
			return type(ITEM_QUALITY_COLORS) == "table"
				and type(ITEM_QUALITY_COLORS[4]) == "table"
				and type(ITEM_QUALITY_COLORS[4].hex) == "string"
		end,
	},
	{
		"ITEM_QUALITY0_DESC .. ITEM_QUALITY4_DESC (global strings)",
		function()
			return type(ITEM_QUALITY0_DESC) == "string"
				and type(ITEM_QUALITY1_DESC) == "string"
				and type(ITEM_QUALITY2_DESC) == "string"
				and type(ITEM_QUALITY3_DESC) == "string"
				and type(ITEM_QUALITY4_DESC) == "string"
		end,
	},
}

function ns:RunApiChecks()
	local lines = { GetClientHeader(), "" }
	for _, check in ipairs(ns.DIAGNOSTIC_API_CHECKS) do
		local ok, result = pcall(check[2])
		lines[#lines + 1] = ((ok and result) and "[PASS] " or "[FAIL] ") .. check[1]
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Loot Method
--------------------------------------------------------------------------------

--[[
    Live read of the loot-method API the master-looter stand-down in
    Speedy-Loot.lua depends on. The API Endpoints report already proves
    C_PartyInfo.GetLootMethod exists; what an existence check can't prove is that
    it returns the (method, masterLooterPartyID, ...) shape the stand-down reads,
    or that the method comes back as the enum NUMBER the literal 2 in
    Speedy-Loot.lua is written against. So this prints the raw return values with
    their types, then the verdict Speedy Loot draws from them. All calls are
    read-only.
]]

local LOOT_METHOD_MASTER = 2

local function PackReturns(...)
	return select("#", ...), { ... }
end

function ns:BuildLootMethodReport()
	local lines = { GetClientHeader(), "" }

	local count, values = PackReturns(C_PartyInfo.GetLootMethod())
	lines[#lines + 1] = string.format("C_PartyInfo.GetLootMethod() -> %d value(s):", count)
	for index = 1, count do
		lines[#lines + 1] = string.format("  [%d] (%s) %s", index, type(values[index]), tostring(values[index]))
	end

	local method, masterLooterPartyID = values[1], values[2]
	lines[#lines + 1] = string.format(
		"Speedy Loot reads lootMethod=%s, masterLooterPartyID=%s -> isMasterLooter=%s",
		tostring(method),
		tostring(masterLooterPartyID),
		tostring(method == LOOT_METHOD_MASTER and masterLooterPartyID == 0)
	)

	lines[#lines + 1] = ""
	lines[#lines + 1] = string.format(
		"GetLootThreshold() = %s (context only: the quality at and above which items go through the master-looter window, which is why the skip above takes everything)",
		tostring(GetLootThreshold())
	)

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Relevant CVars
--------------------------------------------------------------------------------

--[[
    autoLootDefault is the CVar the add-on enforces through ns.EnsureAutoLoot,
    and a player or another add-on turning it back off is the most common cause
    of "it stopped opening things": both Auto-Opening and Speedy Loot need it.
    Read twice, raw and as the boolean the add-on actually tests, because those
    can disagree. Read-only; the taintLog button is the only CVar write here.
]]
function ns:BuildCVarReport()
	local lines = { GetClientHeader(), "" }
	lines[#lines + 1] = string.format(
		"autoLootDefault = %s (GetCVarBool: %s)",
		tostring(C_CVar.GetCVar("autoLootDefault")),
		tostring(C_CVar.GetCVarBool("autoLootDefault"))
	)
	lines[#lines + 1] = string.format("taintLog = %s", tostring(C_CVar.GetCVar("taintLog")))
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Display Context
--------------------------------------------------------------------------------

--[[
    What a "my loot toasts are off the edge of the screen" report needs: the
    resolution and scale the saved anchor point was chosen against, and the
    point itself. The anchor frame is read through ns.GetLootToastAnchorFrame,
    which returns nil rather than creating it, so this report never brings a
    frame into existence as a side effect.
]]
function ns:BuildDisplayReport()
	local lines = { GetClientHeader(), "" }
	local screenWidth, screenHeight = GetPhysicalScreenSize()
	lines[#lines + 1] =
		string.format("GetPhysicalScreenSize() = %s x %s", tostring(screenWidth), tostring(screenHeight))
	lines[#lines + 1] = string.format("UIParent:GetScale() = %s", tostring(UIParent:GetScale()))
	lines[#lines + 1] = string.format("uiScale CVar = %s", tostring(C_CVar.GetCVar("uiScale")))

	lines[#lines + 1] = ""
	local saved = ns.db and ns.db.global and ns.db.global.lootToastPosition
	if saved and saved.point then
		lines[#lines + 1] = string.format(
			"Saved toast anchor: point=%s relativePoint=%s x=%s y=%s",
			tostring(saved.point),
			tostring(saved.relativePoint),
			tostring(saved.x),
			tostring(saved.y)
		)
	else
		lines[#lines + 1] = "Saved toast anchor: unset (the default position is in use)"
	end

	local anchorFrame = ns.GetLootToastAnchorFrame and ns.GetLootToastAnchorFrame()
	if anchorFrame then
		local point, _, relativePoint, x, y = anchorFrame:GetPoint()
		lines[#lines + 1] = string.format(
			"Live toast anchor: point=%s relativePoint=%s x=%s y=%s",
			tostring(point),
			tostring(relativePoint),
			tostring(x),
			tostring(y)
		)
	else
		lines[#lines + 1] = "Live toast anchor: not created this session"
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Other Add-ons
--------------------------------------------------------------------------------

function ns:BuildAddOnReport()
	local lines = { GetClientHeader(), "" }
	local count = C_AddOns.GetNumAddOns()
	for index = 1, count do
		local name, _, _, loadable = C_AddOns.GetAddOnInfo(index)
		local version = C_AddOns.GetAddOnMetadata(index, "Version") or "?"
		lines[#lines + 1] = string.format("%s v%s [%s]", name, version, loadable and "loadable" or "disabled")
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

--[[
    Big item lists are summarized by length rather than printed row by row: the
    Ignore List grows with every item the player adds, and a per-row dump would
    bury the settings a bug report is actually read for. Identified by table
    identity against the live list rather than by key name, so a rename cannot
    quietly turn the summary back into hundreds of rows.
]]
local function CountEntries(list)
	local count = 0
	for _ in pairs(list) do
		count = count + 1
	end
	return count
end

local function DumpTable(value, indent, depth, lines)
	if depth > 8 then
		lines[#lines + 1] = indent .. "<max depth>"
		return
	end
	local ignoreList = ns.db and ns.db.global and ns.db.global.ignoreList
	local keys = {}
	for key in pairs(value) do
		keys[#keys + 1] = key
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	for _, key in ipairs(keys) do
		local entry = value[key]
		if type(entry) == "table" then
			if ignoreList and entry == ignoreList then
				lines[#lines + 1] = indent .. tostring(key) .. " = <" .. CountEntries(entry) .. " items>"
			else
				lines[#lines + 1] = indent .. tostring(key) .. " = {"
				DumpTable(entry, indent .. "    ", depth + 1, lines)
				lines[#lines + 1] = indent .. "}"
			end
		else
			lines[#lines + 1] = indent .. tostring(key) .. " = " .. tostring(entry)
		end
	end
end

function ns:BuildSavedVariablesReport()
	local lines = { GetClientHeader(), "", "OpenSesameDB = {" }
	DumpTable(OpenSesameDB or {}, "    ", 1, lines)
	lines[#lines + 1] = "}"
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Library Versions
--------------------------------------------------------------------------------

function ns:BuildLibraryReport()
	local lines = { GetClientHeader(), "" }
	local names = {}
	for name in LibStub:IterateLibraries() do
		names[#names + 1] = name
	end
	table.sort(names)
	for _, name in ipairs(names) do
		lines[#lines + 1] = string.format("%s (minor %s)", name, tostring(LibStub.minors[name]))
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Taint Log
--------------------------------------------------------------------------------

--[[
    The taintLog CVar controls UI taint logging to Logs\taint.log. Level 2 logs
    both blocked actions and accesses to tainted globals; 0 is off. This is the
    only state the diagnostics panel ever writes.
]]

function ns:GetTaintLogState()
	return tonumber(C_CVar.GetCVar("taintLog")) or 0
end

function ns:SetTaintLog(enabled)
	C_CVar.SetCVar("taintLog", enabled and 2 or 0)
end
