local ADDON_NAME, OS = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("OpenSesame")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function GetColor(key)
    return OS.COLORS[key] or ""
end

local function Header(text, order)
    return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order }
end

local function Desc(text, order)
    return { type = "description", name = text, fontSize = "medium", order = order }
end

local function Spacer(order)
    return { type = "description", name = " ", order = order }
end

local function SubHeader(text, order)
    return { type = "description", name = "\n" .. GetColor("TITLE") .. text .. "|r", fontSize = "medium", order = order }
end

--------------------------------------------------------------------------------
-- Options Table
--------------------------------------------------------------------------------

local options = {
    name = L["ADDON_TITLE"],
    type = "group",
    args = {

        descIntro = Desc(L["OPTIONS_INTRO"], 1),

        -- Auto-Opening

        spaceAutoOpen0 = Spacer(10),
        headerAutoOpen = Header(L["AUTO_OPENING"], 11),
        descAutoOpen = Desc(L["AUTO_OPENING_DESC"], 12),
        spaceAutoOpen1 = Spacer(13),
        toggleAutoOpen = {
            type  = "toggle",
            name  = L["AUTO_OPENING"],
            order = 14,
            width = "full",
            get   = function() return OS.DB.autoOpen end,
            set   = function(_, value)
                OS.DB.autoOpen = value
                OS.isEnabled = value
                OS.ScheduleScan(true)
                OS.UpdateMinimapIcon()
            end,
        },

        -- Speedy Loot

        spaceSpeedyLoot0 = Spacer(20),
        headerSpeedyLoot = Header(L["SPEEDY_LOOT"], 21),
        descSpeedyLoot = Desc(L["SPEEDY_LOOT_DESC"], 22),
        spaceSpeedyLoot1 = Spacer(23),
        toggleSpeedyLoot = {
            type  = "toggle",
            name  = L["SPEEDY_LOOT"],
            order = 24,
            width = "full",
            get   = function() return OS.DB.speedyLoot end,
            set   = function(_, value)
                OS.DB.speedyLoot = value
                OS.isSpeedyLoot = value
                OS.UpdateMinimapIcon()
            end,
        },

        -- Loot Sounds

        spaceLootSounds0 = Spacer(30),
        headerLootSounds = Header(L["LOOT_SOUNDS"], 31),
        descLootSounds = Desc(L["LOOT_SOUNDS_DESC"], 32),
        spaceLootSounds1 = Spacer(33),
        toggleLootSounds = {
            type  = "toggle",
            name  = L["LOOT_SOUNDS"],
            order = 34,
            width = "full",
            get   = function() return OS.DB.lootSounds end,
            set   = function(_, value)
                OS.DB.lootSounds = value
            end,
        },

        -- Feedback & Support

        spaceCommunity0 = Spacer(90),
        headerCommunity = Header(L["OPTIONS_FEEDBACK"], 91),
        spaceCommunity1 = Spacer(92),

        curseforgeLabel = Desc(GetColor("TITLE") .. L["OPTIONS_CURSEFORGE"] .. "|r", 93),
        curseforgeURL = {
            type  = "input",
            name  = "",
            order = 94,
            width = "double",
            get   = function() return OS.CURSEFORGE_URL end,
            set   = function() end,
        },
        spaceCommunity2 = Spacer(95),

        githubLabel = Desc(GetColor("TITLE") .. L["OPTIONS_GITHUB"] .. "|r", 96),
        githubURL = {
            type  = "input",
            name  = "",
            order = 97,
            width = "double",
            get   = function() return OS.GITHUB_URL end,
            set   = function() end,
        },
        spaceCommunity3 = Spacer(98),

        discordLabel = Desc(GetColor("TITLE") .. L["OPTIONS_DISCORD"] .. "|r", 99),
        discordURL = {
            type  = "input",
            name  = "",
            order = 100,
            width = "double",
            get   = function() return OS.DISCORD_URL end,
            set   = function() end,
        },
    },
}

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(ADDON_NAME, options)
local mainPanel = AceConfigDialog:AddToBlizOptions(ADDON_NAME, L["ADDON_TITLE"])

--------------------------------------------------------------------------------
-- Open Options
--------------------------------------------------------------------------------

function OS.OpenOptions()
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(mainPanel.name or L["ADDON_TITLE"])
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(mainPanel)
        InterfaceOptionsFrame_OpenToCategory(mainPanel)
    end
end