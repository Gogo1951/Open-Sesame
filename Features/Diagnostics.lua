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
    TOOLS_ETRACE = "Live event tracing: use %s."
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
        L["ADDON_TITLE"], ns.Version, version, build, tocVersion,
        GetLocale(), tostring(WOW_PROJECT_ID)
    )
end

--------------------------------------------------------------------------------
-- Event Log
--------------------------------------------------------------------------------

local EVENT_LOG_SIZE = 500
local EVENT_LOG_MAX_ARGS = 8

--[[
    Per-argument byte cap. 64 was too small for loot lines: a single item link
    (|cff...|Hitem:...|h[Name]|h|r) plus the "You receive loot:" prefix runs past
    80 bytes, so the link was getting cut mid-name and the entry collapsed to a
    sliver like "[Sc". 255 holds a full loot line with its link while still
    bounding a runaway argument.
]]
local EVENT_LOG_MAX_ARG_LENGTH = 255

--[[
    Events ns:LogEvent drops before recording — deliberately empty. The
    dispatcher only ever hands LogEvent the events Open Sesame registers (Core's
    EventHandlers), and none of those is a sustained firehose worth dropping: the
    addon listens on the coalesced BAG_UPDATE_DELAYED rather than raw BAG_UPDATE,
    and every registered event is potential signal in a bug report — including
    the all-unit UNIT_SPELLCAST_SUCCEEDED, whose rare player Pick Lock cast
    drives the lockbox rescan. The lookup in LogEvent stays so a genuine
    no-signal firehose can be excluded here if one is ever registered. Generic
    offenders (COMBAT_LOG_EVENT_UNFILTERED, UNIT_AURA, ...) do not belong here
    unless registered — the log never sees an event the addon didn't register.
]]
ns.DIAGNOSTIC_EVENT_EXCLUDE = {}

function ns:StartEventLog()
    ns.diagnostics.log = {}
    ns.diagnostics.logging = true
end

function ns:StopEventLog()
    ns.diagnostics.logging = false
    ns.diagnostics.log = nil
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
    if ns.DIAGNOSTIC_EVENT_EXCLUDE[event] then return end
    local parts = {}
    for index = 1, select("#", ...) do
        if index > EVENT_LOG_MAX_ARGS then break end
        local raw = string.sub(tostring((select(index, ...))), 1, EVENT_LOG_MAX_ARG_LENGTH)
        parts[index] = (raw:gsub("|", "||"))
    end
    local log = ns.diagnostics.log
    log[#log + 1] = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
    if #log > EVENT_LOG_SIZE then
        table.remove(log, 1)
    end
end

function ns:BuildEventLogReport()
    local lines = {GetClientHeader(), ""}
    local log = ns.diagnostics.log
    if not log or #log == 0 then
        lines[#lines + 1] = "(no events captured)"
    else
        for _, entry in ipairs(log) do
            lines[#lines + 1] = entry
        end
    end
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
    local lines = {GetClientHeader(), ""}
    local hasIsEventValid = type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
    local probe = GetProbeFrame()
    local failures = 0
    for _, event in ipairs(ns.EVENT_NAMES or {}) do
        local valid = "n/a"
        if hasIsEventValid then
            valid = C_EventUtils.IsEventValid(event) and "valid" or "INVALID"
        end
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
    calls. Kept aligned with the API guards in Features/Utilities.lua,
    Features/Core.lua, and Features/Speedy-Loot.lua. Modern and legacy fallbacks
    are listed separately so the report shows exactly what each client provides.
]]
ns.DIAGNOSTIC_API_CHECKS = {
    -- { label, testFunction }
    {"C_AddOns.GetAddOnMetadata", function() return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnMetadata) == "function" end},
    {"GetAddOnMetadata (legacy)", function() return type(GetAddOnMetadata) == "function" end},
    {"C_Container.GetContainerNumSlots", function() return type(C_Container) == "table" and type(C_Container.GetContainerNumSlots) == "function" end},
    {"GetContainerNumSlots (legacy)", function() return type(GetContainerNumSlots) == "function" end},
    {"C_Container.GetContainerNumFreeSlots", function() return type(C_Container) == "table" and type(C_Container.GetContainerNumFreeSlots) == "function" end},
    {"GetContainerNumFreeSlots (legacy)", function() return type(GetContainerNumFreeSlots) == "function" end},
    {"C_Container.GetContainerItemID", function() return type(C_Container) == "table" and type(C_Container.GetContainerItemID) == "function" end},
    {"GetContainerItemID (legacy)", function() return type(GetContainerItemID) == "function" end},
    {"C_Container.GetContainerItemLink", function() return type(C_Container) == "table" and type(C_Container.GetContainerItemLink) == "function" end},
    {"GetContainerItemLink (legacy)", function() return type(GetContainerItemLink) == "function" end},
    {"C_Container.UseContainerItem", function() return type(C_Container) == "table" and type(C_Container.UseContainerItem) == "function" end},
    {"UseContainerItem (legacy)", function() return type(UseContainerItem) == "function" end},
    {"GetNumLootItems", function() return type(GetNumLootItems) == "function" end},
    {"GetLootSlotType", function() return type(GetLootSlotType) == "function" end},
    {"GetLootSlotLink", function() return type(GetLootSlotLink) == "function" end},
    {"GetLootThreshold", function() return type(GetLootThreshold) == "function" end},
    {"LootSlot", function() return type(LootSlot) == "function" end},
    {"IsModifiedClick", function() return type(IsModifiedClick) == "function" end},
    {"C_PartyInfo.GetLootMethod", function() return type(C_PartyInfo) == "table" and type(C_PartyInfo.GetLootMethod) == "function" end},
    {"C_CVar.GetCVarBool", function() return type(C_CVar) == "table" and type(C_CVar.GetCVarBool) == "function" end},
    {"C_CVar.SetCVar", function() return type(C_CVar) == "table" and type(C_CVar.SetCVar) == "function" end},
    {"GetCVar (legacy)", function() return type(GetCVar) == "function" end},
    {"UnitCastingInfo", function() return type(UnitCastingInfo) == "function" end},
    {"UnitChannelInfo", function() return type(UnitChannelInfo) == "function" end},
    {"IsStealthed", function() return type(IsStealthed) == "function" end},
    {"C_UnitAuras.GetBuffDataByIndex", function() return type(C_UnitAuras) == "table" and type(C_UnitAuras.GetBuffDataByIndex) == "function" end},
    {"UnitBuff (legacy)", function() return type(UnitBuff) == "function" end},
    {"C_EventUtils.IsEventValid", function() return type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function" end},
    {"C_Timer.After", function() return type(C_Timer) == "table" and type(C_Timer.After) == "function" end},
    {"Enum.UIERRORS.ERR_INV_FULL", function() return type(Enum) == "table" and type(Enum.UIERRORS) == "table" and Enum.UIERRORS.ERR_INV_FULL ~= nil end},
    {"LE_GAME_ERR_INV_FULL", function() return LE_GAME_ERR_INV_FULL ~= nil end}
}

function ns:RunApiChecks()
    local lines = {GetClientHeader(), ""}
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
    Live read of the loot-method APIs the master-looter guard in Speedy-Loot.lua
    depends on. An existence check can't prove C_PartyInfo.GetLootMethod returns
    the (method, partyMasterID, ...) shape the guard destructures, so this prints
    the actual return values and how Speedy Loot would interpret them. All calls
    are read-only.
]]

local function PackReturns(...)
    return select("#", ...), {...}
end

function ns:BuildLootMethodReport()
    local lines = {GetClientHeader(), ""}

    if type(C_PartyInfo) == "table" and type(C_PartyInfo.GetLootMethod) == "function" then
        local count, values = PackReturns(C_PartyInfo.GetLootMethod())
        lines[#lines + 1] = string.format("C_PartyInfo.GetLootMethod() -> %d value(s):", count)
        for index = 1, count do
            lines[#lines + 1] = string.format("  [%d] (%s) %s", index, type(values[index]), tostring(values[index]))
        end
        --[[
            Simulate what GetLootMethodCompat returns: enum 2 maps to "master" so
            the lootMethod == "master" guard in Speedy Loot fires correctly.
            Comparing values[1] directly to "master" would always report
            isMasterLooter=false even when the player is the master looter.
        ]]
        local methodEnum, masterLooterPartyID = values[1], values[2]
        local convertedMethod
        if (Enum and Enum.LootMethod and methodEnum == Enum.LootMethod.MasterLoot) or methodEnum == 2 then
            convertedMethod = "master"
        else
            convertedMethod = methodEnum
        end
        lines[#lines + 1] = string.format(
            "Speedy Loot reads lootMethod=%s, masterLooterPartyID=%s -> isMasterLooter=%s",
            tostring(convertedMethod), tostring(masterLooterPartyID),
            tostring(convertedMethod == "master" and masterLooterPartyID == 0)
        )
    else
        lines[#lines + 1] = "C_PartyInfo.GetLootMethod: not available"
    end

    lines[#lines + 1] = ""
    if type(GetLootMethod) == "function" then
        local count, values = PackReturns(GetLootMethod())
        lines[#lines + 1] = string.format("GetLootMethod() [legacy] -> %d value(s):", count)
        for index = 1, count do
            lines[#lines + 1] = string.format("  [%d] (%s) %s", index, type(values[index]), tostring(values[index]))
        end
    else
        lines[#lines + 1] = "GetLootMethod [legacy]: not available"
    end

    lines[#lines + 1] = ""
    if type(GetLootThreshold) == "function" then
        lines[#lines + 1] = string.format("GetLootThreshold() = %s (master-looter skip applies at this quality and above)", tostring(GetLootThreshold()))
    else
        lines[#lines + 1] = "GetLootThreshold: not available"
    end

    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Other Add-ons
--------------------------------------------------------------------------------

function ns:BuildAddOnReport()
    local lines = {GetClientHeader(), ""}
    local getInfo = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
    local getMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local count = (C_AddOns and C_AddOns.GetNumAddOns and C_AddOns.GetNumAddOns()) or GetNumAddOns()
    for index = 1, count do
        local name, _, _, loadable = getInfo(index)
        local version = getMeta(index, "Version") or "?"
        lines[#lines + 1] = string.format("%s v%s [%s]", name, version, loadable and "loadable" or "disabled")
    end
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

local function DumpTable(value, indent, depth, lines)
    if depth > 8 then
        lines[#lines + 1] = indent .. "<max depth>"
        return
    end
    local keys = {}
    for key in pairs(value) do
        keys[#keys + 1] = key
    end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, key in ipairs(keys) do
        local entry = value[key]
        if type(entry) == "table" then
            lines[#lines + 1] = indent .. tostring(key) .. " = {"
            DumpTable(entry, indent .. "    ", depth + 1, lines)
            lines[#lines + 1] = indent .. "}"
        else
            lines[#lines + 1] = indent .. tostring(key) .. " = " .. tostring(entry)
        end
    end
end

function ns:BuildSavedVariablesReport()
    local lines = {GetClientHeader(), "", "OpenSesameDB = {"}
    DumpTable(OpenSesameDB or {}, "    ", 1, lines)
    lines[#lines + 1] = "}"
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Library Versions
--------------------------------------------------------------------------------

function ns:BuildLibraryReport()
    local lines = {GetClientHeader(), ""}
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
    return tonumber(GetCVar("taintLog")) or 0
end

function ns:SetTaintLog(enabled)
    SetCVar("taintLog", enabled and 2 or 0)
end
