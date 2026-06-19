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
            -- Auto-Opening

            spaceAutoOpen0 = ns.OptionsSpacer(10),
            headerAutoOpen = ns.OptionsHeader(L["AUTO_OPENING"], 11),
            descAutoOpen = ns.OptionsDesc(string.format(L["AUTO_OPENING_DESC"], ns.MIN_FREE_SLOTS), 12),
            spaceAutoOpen1 = ns.OptionsSpacer(13),
            toggleAutoOpen = {
                type = "toggle",
                name = L["AUTO_OPENING"],
                order = 14,
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
            -- Speedy Loot

            spaceSpeedyLoot0 = ns.OptionsSpacer(20),
            headerSpeedyLoot = ns.OptionsHeader(L["SPEEDY_LOOT"], 21),
            descSpeedyLoot = ns.OptionsDesc(L["SPEEDY_LOOT_DESC"], 22),
            spaceSpeedyLoot1 = ns.OptionsSpacer(23),
            toggleSpeedyLoot = {
                type = "toggle",
                name = L["SPEEDY_LOOT"],
                order = 24,
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

            spaceLootSounds0 = ns.OptionsSpacer(30),
            headerLootSounds = ns.OptionsHeader(L["LOOT_SOUNDS"], 31),
            descLootSounds = ns.OptionsDesc(L["LOOT_SOUNDS_DESC"], 32),
            spaceLootSounds1 = ns.OptionsSpacer(33),
            toggleLootSounds = {
                type = "toggle",
                name = L["LOOT_SOUNDS"],
                order = 34,
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
            descReset = ns.OptionsDesc(L["OPTIONS_RESET_DESC"], 82),
            spaceReset1 = ns.OptionsSpacer(83),
            buttonReset = {
                type = "execute",
                name = L["OPTIONS_RESET_BUTTON"],
                order = 84,
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
