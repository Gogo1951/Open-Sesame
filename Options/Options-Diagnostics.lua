local _, ns = ...

local D = ns.DiagnosticsStrings
local GetColor = ns.GetColor
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Diagnostic Tools Panel
--------------------------------------------------------------------------------

--[[
    A single runtime toggle gates the whole panel. When off, only the warning
    text and the enable toggle are visible; everything below is hidden. Every
    gated section hides on that one condition, so the panel defines local
    SectionHeader / ReportOutput builders that bake it in alongside the shared
    Hidden and Refresh locals, rather than repeating the predicate per widget.
]]

local function DiagnosticsOn()
	return ns.diagnostics and ns.diagnostics.enabled == true
end

local function Hidden()
	return not DiagnosticsOn()
end

local function Refresh()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.Diagnostics)
end

local function SectionHeader(text, order)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = Hidden }
end

local function ReportOutput(field, order)
	return {
		type = "input",
		name = "",
		multiline = 12,
		width = "full",
		order = order,
		hidden = Hidden,
		get = function()
			return ns.diagnostics[field] or ""
		end,
		set = function() end,
	}
end

--[[
    One section per entry in ns.DIAGNOSTIC_DATA_SOURCES, so a new data file
    reaches the panel by adding its manifest row and nothing here. Each section
    has its own run button and output box; the run publishes its own progress,
    so the button does not Refresh. The hint prints once, below the last.
]]
local function AddValidateDataSections(args, startOrder)
	local order = startOrder
	for index, entry in ipairs(ns.DIAGNOSTIC_DATA_SOURCES) do
		args["headerValidate" .. index] = SectionHeader(string.format(D.VALIDATE_TITLE, entry.file), order)
		args["buttonValidate" .. index] = {
			type = "execute",
			name = string.format(D.VALIDATE_BUTTON, entry.file),
			desc = string.format(D.VALIDATE_BUTTON_DESC, entry.file),
			width = "double",
			order = order + 1,
			hidden = Hidden,
			func = function()
				ns:StartDataValidation(index)
			end,
		}
		args["outputValidate" .. index] = ReportOutput(ns.DataValidationField(index), order + 2)
		order = order + 3
	end
	args.descValidateHint = {
		type = "description",
		name = GetColor("HELP") .. D.VALIDATE_HINT .. "|r",
		fontSize = "medium",
		order = order,
		hidden = Hidden,
	}
end

function ns.BuildDiagnosticsOptions()
	local group = {
		type = "group",
		name = D.TAB,
		args = {
			descWarning = ns.OptionsDesc(D.WARNING, 1),
			spaceEnable = ns.OptionsSpacer(2),
			toggleEnable = {
				type = "toggle",
				name = D.ENABLE,
				desc = D.ENABLE_DESC,
				width = "full",
				order = 3,
				get = function()
					return DiagnosticsOn()
				end,
				set = function(_, value)
					ns:SetDiagnosticsEnabled(value)
					Refresh()
				end,
			},

			-- Event Log
			headerEventLog = SectionHeader(D.EVENT_LOG_TITLE, 5),
			buttonStartLog = {
				type = "execute",
				name = D.EVENT_LOG_START,
				desc = D.EVENT_LOG_START_DESC,
				order = 6,
				hidden = Hidden,
				func = function()
					ns:StartEventLog()
					Refresh()
				end,
			},
			buttonStopLog = {
				type = "execute",
				name = D.EVENT_LOG_STOP,
				desc = D.EVENT_LOG_STOP_DESC,
				order = 7,
				hidden = Hidden,
				func = function()
					ns:StopEventLog()
					Refresh()
				end,
			},
			buttonShowLog = {
				type = "execute",
				name = D.EVENT_LOG_SHOW,
				desc = D.EVENT_LOG_SHOW_DESC,
				order = 8,
				hidden = Hidden,
				func = function()
					ns.diagnostics.eventLogReport = ns:BuildEventLogReport()
					Refresh()
				end,
			},
			outputEventLog = ReportOutput("eventLogReport", 9),
			descEventLogHint = {
				type = "description",
				name = GetColor("HELP") .. D.EVENT_LOG_HINT .. "|r",
				fontSize = "medium",
				order = 10,
				hidden = Hidden,
			},

			-- Event Registration
			headerEvents = SectionHeader(D.EVENTS_TITLE, 13),
			buttonEvents = {
				type = "execute",
				name = D.EVENTS_BUTTON,
				desc = D.EVENTS_BUTTON_DESC,
				order = 14,
				hidden = Hidden,
				func = function()
					ns.diagnostics.eventsReport = ns:RunEventChecks()
					Refresh()
				end,
			},
			outputEvents = ReportOutput("eventsReport", 15),

			-- API Endpoints
			headerApi = SectionHeader(D.API_TITLE, 20),
			buttonApi = {
				type = "execute",
				name = D.API_BUTTON,
				desc = D.API_BUTTON_DESC,
				order = 21,
				hidden = Hidden,
				func = function()
					ns.diagnostics.apiReport = ns:RunApiChecks()
					Refresh()
				end,
			},
			outputApi = ReportOutput("apiReport", 22),

			-- Loot Method
			headerLoot = SectionHeader(D.LOOT_TITLE, 25),
			buttonLoot = {
				type = "execute",
				name = D.LOOT_BUTTON,
				desc = D.LOOT_BUTTON_DESC,
				order = 26,
				hidden = Hidden,
				func = function()
					ns.diagnostics.lootReport = ns:BuildLootMethodReport()
					Refresh()
				end,
			},
			outputLoot = ReportOutput("lootReport", 27),

			-- Other Add-ons
			headerAddons = SectionHeader(D.ADDONS_TITLE, 30),
			buttonAddons = {
				type = "execute",
				name = D.ADDONS_BUTTON,
				desc = D.ADDONS_BUTTON_DESC,
				order = 31,
				hidden = Hidden,
				func = function()
					ns.diagnostics.addOnReport = ns:BuildAddOnReport()
					Refresh()
				end,
			},
			outputAddons = ReportOutput("addOnReport", 32),

			-- Relevant CVars
			headerCVars = SectionHeader(D.CVARS_TITLE, 33),
			buttonCVars = {
				type = "execute",
				name = D.CVARS_BUTTON,
				desc = D.CVARS_BUTTON_DESC,
				order = 34,
				hidden = Hidden,
				func = function()
					ns.diagnostics.cvarReport = ns:BuildCVarReport()
					Refresh()
				end,
			},
			outputCVars = ReportOutput("cvarReport", 35),

			-- Display Context
			headerDisplay = SectionHeader(D.DISPLAY_TITLE, 36),
			buttonDisplay = {
				type = "execute",
				name = D.DISPLAY_BUTTON,
				desc = D.DISPLAY_BUTTON_DESC,
				order = 37,
				hidden = Hidden,
				func = function()
					ns.diagnostics.displayReport = ns:BuildDisplayReport()
					Refresh()
				end,
			},
			outputDisplay = ReportOutput("displayReport", 38),

			-- Saved Variables
			headerSaved = SectionHeader(D.SAVED_TITLE, 40),
			buttonSaved = {
				type = "execute",
				name = D.SAVED_BUTTON,
				desc = D.SAVED_BUTTON_DESC,
				order = 41,
				hidden = Hidden,
				func = function()
					ns.diagnostics.savedReport = ns:BuildSavedVariablesReport()
					Refresh()
				end,
			},
			outputSaved = ReportOutput("savedReport", 42),

			-- Player & Spells
			headerPlayer = SectionHeader(D.PLAYER_TITLE, 43),
			buttonPlayer = {
				type = "execute",
				name = D.PLAYER_BUTTON,
				desc = D.PLAYER_BUTTON_DESC,
				order = 44,
				hidden = Hidden,
				func = function()
					ns.diagnostics.playerReport = ns:BuildPlayerReport()
					Refresh()
				end,
			},
			outputPlayer = ReportOutput("playerReport", 45),

			-- Locked Boxes
			headerLocked = SectionHeader(D.LOCKED_TITLE, 46),
			buttonLocked = {
				type = "execute",
				name = D.LOCKED_BUTTON,
				desc = D.LOCKED_BUTTON_DESC,
				order = 47,
				hidden = Hidden,
				func = function()
					ns.diagnostics.lockedReport = ns:BuildLockedBoxesReport()
					Refresh()
				end,
			},
			outputLocked = ReportOutput("lockedReport", 48),
			descLockedHint = {
				type = "description",
				name = GetColor("HELP") .. D.LOCKED_HINT .. "|r",
				fontSize = "medium",
				order = 49,
				hidden = Hidden,
			},

			-- Library Versions
			headerLibs = SectionHeader(D.LIBS_TITLE, 50),
			buttonLibs = {
				type = "execute",
				name = D.LIBS_BUTTON,
				desc = D.LIBS_BUTTON_DESC,
				order = 51,
				hidden = Hidden,
				func = function()
					ns.diagnostics.libraryReport = ns:BuildLibraryReport()
					Refresh()
				end,
			},
			outputLibs = ReportOutput("libraryReport", 52),

			-- Taint Log
			headerTaint = SectionHeader(D.TAINT_TITLE, 80),
			descTaintState = {
				type = "description",
				name = function()
					return GetColor("BODY") .. string.format(D.TAINT_STATE, ns:GetTaintLogState()) .. "|r"
				end,
				fontSize = "medium",
				order = 81,
				hidden = Hidden,
			},
			buttonTaintOn = {
				type = "execute",
				name = D.TAINT_ON,
				desc = D.TAINT_ON_DESC,
				order = 82,
				hidden = Hidden,
				func = function()
					ns:SetTaintLog(true)
					Refresh()
				end,
			},
			buttonTaintOff = {
				type = "execute",
				name = D.TAINT_OFF,
				desc = D.TAINT_OFF_DESC,
				order = 83,
				hidden = Hidden,
				func = function()
					ns:SetTaintLog(false)
					Refresh()
				end,
			},
			descTaintHint = {
				type = "description",
				name = GetColor("HELP") .. D.TAINT_HINT .. "|r",
				fontSize = "medium",
				order = 84,
				hidden = Hidden,
			},

			-- External Tools (point at mature tools rather than reimplement them)
			headerTools = SectionHeader(D.TOOLS_TITLE, 90),
			descToolsErrors = {
				type = "description",
				name = GetColor("BODY") .. string.format(
					D.TOOLS_ERRORS,
					GetColor("INFO") .. "/console scriptErrors 1|r" .. GetColor("BODY")
				) .. "|r",
				fontSize = "medium",
				order = 91,
				hidden = Hidden,
			},
			descToolsEtrace = {
				type = "description",
				name = GetColor("BODY")
					.. string.format(D.TOOLS_ETRACE, GetColor("INFO") .. "/etrace|r" .. GetColor("BODY"))
					.. "|r",
				fontSize = "medium",
				order = 92,
				hidden = Hidden,
			},
		},
	}
	AddValidateDataSections(group.args, 53)
	return group
end
