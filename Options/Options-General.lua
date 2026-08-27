local _, ns = ...

local L = ns.L
local GetColor = ns.GetColor

--[[
    The four link rows split ns.OPTIONS_ROW_WIDTH unevenly: their labels are one
    short word, while the box beside them holds a full URL the player is meant to
    select and copy. The label takes 0.6 so the box lands on exactly 2.0, the
    guide's double width for a read-only URL input, without the row outgrowing
    every other row on the panel. Same split Magic Eraser uses.
]]
local LINK_LABEL_WIDTH = 0.6
local LINK_URL_WIDTH = ns.OPTIONS_ROW_WIDTH - LINK_LABEL_WIDTH

local function IsAutoOpenDisabled()
	return not ns.db.profile.autoOpen
end

--------------------------------------------------------------------------------
-- Options Table
--------------------------------------------------------------------------------

function ns.BuildGeneralOptions()
	return {
		name = L["ADDON_TITLE"],
		type = "group",
		args = {
			descIntro = ns.OptionsDesc(L["OPTIONS_DESCRIPTION"], 1),
			-- Welcome Message

			spaceWelcome0 = ns.OptionsSpacer(5),
			toggleWelcome = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_WELCOME"],
				order = 6,
				width = "full",
				get = function()
					return ns.db.profile.showWelcome
				end,
				set = function(_, value)
					ns.db.profile.showWelcome = value
				end,
			},
			toggleMinimap = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_MINIMAP"],
				order = 7,
				width = "full",
				get = function()
					return ns.db and not ns.db.profile.minimap.hide
				end,
				set = function(_, value)
					ns:SetMinimapShown(value)
				end,
			},
			-- /Commands

			spaceCommands0 = ns.OptionsSpacer(10),
			headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 11),
			spaceCommands1 = ns.OptionsSpacer(12),
			descCommands = ns.OptionsDesc(
				GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
				13
			),
			-- Auto-Opening

			spaceAutoOpen0 = ns.OptionsSpacer(20),
			headerAutoOpen = ns.OptionsHeader(L["AUTO_OPENING"], 21),
			spaceAutoOpen1 = ns.OptionsSpacer(22),
			descAutoOpen = ns.OptionsDesc(string.format(L["AUTO_OPENING_DESCRIPTION"], ns.MIN_FREE_SLOTS), 23),
			spaceAutoOpen2 = ns.OptionsSpacer(24),
			toggleAutoOpen = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_AUTO_OPENING"],
				order = 25,
				width = "full",
				get = function()
					return ns.db.profile.autoOpen
				end,
				set = function(_, value)
					ns.db.profile.autoOpen = value
					ns.isEnabled = value
					if value then
						ns.EnsureAutoLoot()
					end
					ns.ScheduleScan(true)
					ns:UpdateMinimapIcon()
				end,
			},
			subAutoOpenWhere = ns.OptionsSubSelectRow(26, IsAutoOpenDisabled, L["OPTIONS_AUTO_OPENING_WHERE"], {
				type = "select",
				values = {
					ALWAYS = L["OPTIONS_ANYWHERE"],
					OUTSIDE_INSTANCES = L["OPTIONS_OUTSIDE_INSTANCES"],
				},
				sorting = { "ALWAYS", "OUTSIDE_INSTANCES" },
				get = function()
					return ns.db.profile.autoOpenWhere
				end,
				set = function(_, value)
					ns.db.profile.autoOpenWhere = value
					ns.ScheduleScan(true)
				end,
			}),
			subAutoOpenGroup = ns.OptionsSubSelectRow(27, IsAutoOpenDisabled, L["OPTIONS_AUTO_OPENING_GROUP"], {
				type = "select",
				values = {
					ALWAYS = L["OPTIONS_SOLO_OR_GROUPED"],
					SOLO_ONLY = L["OPTIONS_SOLO_ONLY"],
				},
				sorting = { "ALWAYS", "SOLO_ONLY" },
				get = function()
					return ns.db.profile.autoOpenGroup
				end,
				set = function(_, value)
					ns.db.profile.autoOpenGroup = value
					ns.ScheduleScan(true)
				end,
			}),
			-- Speedy Loot

			spaceSpeedyLoot0 = ns.OptionsSpacer(30),
			headerSpeedyLoot = ns.OptionsHeader(L["SPEEDY_LOOT"], 31),
			spaceSpeedyLoot1 = ns.OptionsSpacer(32),
			descSpeedyLoot = ns.OptionsDesc(L["SPEEDY_LOOT_DESCRIPTION"], 33),
			spaceSpeedyLoot2 = ns.OptionsSpacer(34),
			toggleSpeedyLoot = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_SPEEDY_LOOT"],
				order = 35,
				width = "full",
				get = function()
					return ns.db.profile.speedyLoot
				end,
				set = function(_, value)
					ns.db.profile.speedyLoot = value
					ns.isSpeedyLoot = value
					if value then
						ns.EnsureAutoLoot()
					end
					ns:UpdateMinimapIcon()
				end,
			},
			-- Feedback & Support

			spaceCommunity0 = ns.OptionsSpacer(90),
			headerCommunity = ns.OptionsHeader(L["OPTIONS_FEEDBACK"], 91),
			spaceCommunity1 = ns.OptionsSpacer(92),
			discordLabel = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_DISCORD"] .. "|r", 93, LINK_LABEL_WIDTH),
			discordURL = {
				type = "input",
				name = "",
				order = 94,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.DISCORD_URL
				end,
				set = function() end,
			},
			spaceCommunity2 = ns.OptionsSpacer(95),
			githubLabel = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_GITHUB"] .. "|r", 96, LINK_LABEL_WIDTH),
			githubURL = {
				type = "input",
				name = "",
				order = 97,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.GITHUB_URL
				end,
				set = function() end,
			},
			spaceCommunity3 = ns.OptionsSpacer(98),
			curseforgeLabel = ns.OptionsRowLabel(
				GetColor("TITLE") .. L["OPTIONS_CURSEFORGE"] .. "|r",
				99,
				LINK_LABEL_WIDTH
			),
			curseforgeURL = {
				type = "input",
				name = "",
				order = 100,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.CURSEFORGE_URL
				end,
				set = function() end,
			},
			spaceCommunity4 = ns.OptionsSpacer(101),
			wagoLabel = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_WAGO"] .. "|r", 102, LINK_LABEL_WIDTH),
			wagoURL = {
				type = "input",
				name = "",
				order = 103,
				width = LINK_URL_WIDTH,
				get = function()
					return ns.WAGO_URL
				end,
				set = function() end,
			},
			-- Version
			spaceVersion0 = {
				type = "description",
				name = " ",
				width = "full",
				order = 998,
			},
			versionLine = {
				type = "description",
				name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
				fontSize = "medium",
				order = 999,
			},
		},
	}
end
