local _, namespace = ...
local L = namespace.L
local GetColor = namespace.GetColor

--------------------------------------------------------------------------------
-- Standard Helpers
--------------------------------------------------------------------------------

local function Header(text, order)
    return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order }
end

local function Desc(text, order)
    return { type = "description", name = text, fontSize = "medium", order = order }
end

local function Spacer(order)
    return { type = "description", name = " ", order = order }
end

--------------------------------------------------------------------------------
-- Options Table
--------------------------------------------------------------------------------

local options = {
    type = "group",
    name = "Come & Get It",
    args = {
        spacerIntro0 = Spacer(1),
        headerIntro = Header("Come & Get It", 2),
        descIntro = Desc(L["OPTIONS_DESCRIPTION"], 3),
        spacerIntro1 = Spacer(4),

        welcomeToggle = {
            type = "toggle",
            name = L["OPTIONS_WELCOME_NAME"],
            desc = L["OPTIONS_WELCOME_DESC"],
            width = "full",
            order = 5,
            get = function() return ComeAndGetItDB and ComeAndGetItDB.showWelcome end,
            set = function(_, v)
                ComeAndGetItDB = ComeAndGetItDB or {}
                ComeAndGetItDB.showWelcome = v
            end
        },
        spacerWelcome1 = Spacer(6),

        spacerFeedback0 = Spacer(10),
        headerFeedback = Header(L["FEEDBACK_HEADER"], 11),
        spacerFeedback1 = Spacer(12),

        feedbackCurseForge = {
            type = "input",
            name = L["FEEDBACK_CURSEFORGE"],
            order = 13,
            width = "double",
            get = function() return namespace.URL_CURSEFORGE end,
            set = function() end
        },
        feedbackGitHub = {
            type = "input",
            name = L["FEEDBACK_GITHUB"],
            order = 14,
            width = "double",
            get = function() return namespace.URL_GITHUB end,
            set = function() end
        },
        feedbackDiscord = {
            type = "input",
            name = L["FEEDBACK_DISCORD"],
            order = 15,
            width = "double",
            get = function() return namespace.URL_DISCORD end,
            set = function() end
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
            name = GetColor("MUTED") .. "Version " .. namespace.Version .. "|r",
            fontSize = "medium",
            order = 999
        }
    }
}

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("ComeAndGetIt", options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ComeAndGetIt", "Come & Get It")
