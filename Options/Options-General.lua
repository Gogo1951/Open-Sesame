local _, ns = ...

local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Options Table
--------------------------------------------------------------------------------

function ns.BuildGeneralOptions()
	return {
		name = L["ADDON_TITLE"],
		type = "group",
		args = {
			descIntro = ns.OptionsDesc(L["OPTIONS_INTRO"], 1),
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
					return ns.db and not ns.db.global.minimap.hide
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
				GetColor("INFO") .. L["OPTIONS_CMD_OS"] .. "|r" .. "  " .. L["OPTIONS_CMD_OS_DESCRIPTION"],
				13
			),
			-- Auto-Opening

			spaceAutoOpen0 = ns.OptionsSpacer(20),
			headerAutoOpen = ns.OptionsHeader(L["AUTO_OPENING"], 21),
			spaceAutoOpen1 = ns.OptionsSpacer(22),
			descAutoOpen = ns.OptionsDesc(string.format(L["AUTO_OPENING_DESC"], ns.MIN_FREE_SLOTS), 23),
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
			toggleLockboxNotifications = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"],
				order = 26,
				width = "full",
				hidden = function()
					return not ns.db.profile.autoOpen
				end,
				get = function()
					return ns.db.profile.lockboxNotifications
				end,
				set = function(_, value)
					ns.db.profile.lockboxNotifications = value
				end,
			},
			-- Speedy Loot

			spaceSpeedyLoot0 = ns.OptionsSpacer(30),
			headerSpeedyLoot = ns.OptionsHeader(L["SPEEDY_LOOT"], 31),
			spaceSpeedyLoot1 = ns.OptionsSpacer(32),
			descSpeedyLoot = ns.OptionsDesc(L["SPEEDY_LOOT_DESC"], 33),
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
			-- Loot Sounds

			spaceLootSounds0 = ns.OptionsSpacer(40),
			headerLootSounds = ns.OptionsHeader(L["LOOT_SOUNDS"], 41),
			spaceLootSounds1 = ns.OptionsSpacer(42),
			descLootSounds = ns.OptionsDesc(L["LOOT_SOUNDS_DESC"], 43),
			spaceLootSounds2 = ns.OptionsSpacer(44),
			toggleLootSounds = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_LOOT_SOUNDS"],
				order = 45,
				width = "normal",
				get = function()
					return ns.db.profile.lootSounds
				end,
				set = function(_, value)
					ns.db.profile.lootSounds = value
				end,
			},
			--[[
				    The quality dropdown and the preview speaker share the loot sound row
				    with the toggle: toggle (45), dropdown (47), speaker (48). Tier labels
				    use the client-localized ITEM_QUALITYn_DESC globals wrapped in the
				    game's own item-quality colors, so the dropdown reads green/blue/purple
				    like the items themselves — no locale keys needed for the tier names.
				    sorting forces numeric 2/3/4 order.
				]]
			selectLootSoundThreshold = {
				type = "select",
				name = L["OPTIONS_LOOT_SOUND_THRESHOLD"],
				order = 47,
				width = "normal",
				values = {
					[2] = ITEM_QUALITY_COLORS[2].hex .. ITEM_QUALITY2_DESC .. "|r",
					[3] = ITEM_QUALITY_COLORS[3].hex .. ITEM_QUALITY3_DESC .. "|r",
					[4] = ITEM_QUALITY_COLORS[4].hex .. ITEM_QUALITY4_DESC .. "|r",
				},
				sorting = { 2, 3, 4 },
				disabled = function()
					return not ns.db.profile.lootSounds
				end,
				get = function()
					return ns.db.profile.lootSoundThreshold
				end,
				set = function(_, value)
					ns.db.profile.lootSoundThreshold = value
				end,
			},
			--[[
				    Speaker icon just right of the dropdown that previews the actual loot
				    sound (ns.LOOT_SOUND_FILE, the same file Core plays on a rare drop) so
				    the player can hear it before enabling. The Icon widget centers its
				    image in the control, so a narrow width (0.2 grid units) keeps the
				    speaker tight against the dropdown instead of floating in a wide cell.
				    order 48 places it right after the dropdown (47). Always clickable — a
				    preview, independent of whether Loot Sound is on.
				]]
			playLootSound = {
				type = "execute",
				name = "",
				desc = L["OPTIONS_TEST_LOOT_SOUND"],
				order = 48,
				width = 0.2,
				image = "Interface\\COMMON\\VoiceChat-Speaker",
				imageWidth = 24,
				imageHeight = 24,
				func = function()
					PlaySoundFile(ns.LOOT_SOUND_FILE, "Master")
				end,
			},
			-- Feedback & Support

			spaceCommunity0 = ns.OptionsSpacer(90),
			headerCommunity = ns.OptionsHeader(L["OPTIONS_FEEDBACK"], 91),
			spaceCommunity1 = ns.OptionsSpacer(92),
			discordLabel = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_DISCORD"] .. "|r", 93),
			discordURL = {
				type = "input",
				name = "",
				order = 94,
				width = "double",
				get = function()
					return ns.DISCORD_URL
				end,
				set = function() end,
			},
			spaceCommunity2 = ns.OptionsSpacer(95),
			githubLabel = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_GITHUB"] .. "|r", 96),
			githubURL = {
				type = "input",
				name = "",
				order = 97,
				width = "double",
				get = function()
					return ns.GITHUB_URL
				end,
				set = function() end,
			},
			spaceCommunity3 = ns.OptionsSpacer(98),
			curseforgeLabel = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_CURSEFORGE"] .. "|r", 99),
			curseforgeURL = {
				type = "input",
				name = "",
				order = 100,
				width = "double",
				get = function()
					return ns.CURSEFORGE_URL
				end,
				set = function() end,
			},
			spaceCommunity4 = ns.OptionsSpacer(101),
			wagoLabel = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_WAGO"] .. "|r", 102),
			wagoURL = {
				type = "input",
				name = "",
				order = 103,
				width = "double",
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
