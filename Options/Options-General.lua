local ADDON_NAME, ns = ...

local L = ns.L
local GetColor = ns.GetColor
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

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
                    return ns.DB.showWelcome
                end,
                set = function(_, value)
                    ns.DB.showWelcome = value
                end
            },
            toggleMinimap = {
                type = "toggle",
                name = L["OPTIONS_ENABLE_MINIMAP"],
                order = 7,
                width = "full",
                get = function()
                    return ns.DB.showMinimap
                end,
                set = function(_, value)
                    ns.SetMinimapShown(value)
                end
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
                    return ns.DB.autoOpen
                end,
                set = function(_, value)
                    ns.DB.autoOpen = value
                    ns.isEnabled = value
                    if value then
                        ns.EnsureAutoLoot()
                    end
                    ns.ScheduleScan(true)
                    ns.UpdateMinimapIcon()
                end
            },
            toggleLockboxNotifications = {
                type = "toggle",
                name = L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"],
                order = 26,
                width = "full",
                hidden = function()
                    return not ns.DB.autoOpen
                end,
                get = function()
                    return ns.DB.lockboxNotifications
                end,
                set = function(_, value)
                    ns.DB.lockboxNotifications = value
                end
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
                    return ns.DB.speedyLoot
                end,
                set = function(_, value)
                    ns.DB.speedyLoot = value
                    ns.isSpeedyLoot = value
                    if value then
                        ns.EnsureAutoLoot()
                    end
                    ns.UpdateMinimapIcon()
                end
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
                width = "full",
                get = function()
                    return ns.DB.lootSounds
                end,
                set = function(_, value)
                    ns.DB.lootSounds = value
                end
            },
            -- Reset

            spaceReset0 = ns.OptionsSpacer(80),
            headerReset = ns.OptionsHeader(L["OPTIONS_RESET"], 81),
            spaceReset1 = ns.OptionsSpacer(82),
            descReset = ns.OptionsDesc(L["OPTIONS_RESET_DESC"], 83),
            spaceReset2 = ns.OptionsSpacer(84),
            buttonReset = {
                type = "execute",
                name = L["OPTIONS_RESET_BUTTON"],
                order = 85,
                width = "full",
                confirm = true,
                confirmText = L["OPTIONS_RESET_CONFIRM"],
                func = function()
                    ns.ResetSettings()
                    AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
                end
            },
            -- Feedback & Support

            spaceCommunity0 = ns.OptionsSpacer(90),
            headerCommunity = ns.OptionsHeader(L["OPTIONS_FEEDBACK"], 91),
            spaceCommunity1 = ns.OptionsSpacer(92),
            curseforgeLabel = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_CURSEFORGE"] .. "|r", 93),
            curseforgeURL = {
                type = "input",
                name = "",
                order = 94,
                width = "double",
                get = function()
                    return ns.CURSEFORGE_URL
                end,
                set = function()
                end
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
                set = function()
                end
            },
            spaceCommunity3 = ns.OptionsSpacer(98),
            discordLabel = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_DISCORD"] .. "|r", 99),
            discordURL = {
                type = "input",
                name = "",
                order = 100,
                width = "double",
                get = function()
                    return ns.DISCORD_URL
                end,
                set = function()
                end
            },
            -- Version
            spaceVersion0 = {
                type = "description",
                name = " ",
                width = "full",
                order = 998
            },
            versionLine = {
                type = "description",
                name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
                fontSize = "medium",
                order = 999
            }
        }
    }
end
