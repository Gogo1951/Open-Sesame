local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "enUS", true)
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Rogues"
L["HERBALISTS"] = "Herbalists"
L["MINERS"] = "Miners"

L["ACTION_OPEN"] = "open"
L["ACTION_PICK"] = "pick"
L["ACTION_MINE"] = "mine"

L["PREFIX_LOCKED"] = "a locked"
L["PREFIX_HERB"] = "some"
L["PREFIX_MINE"] = "a"

L["MATCH_HERB"] = "Herbalism"
L["MATCH_MINE"] = "Mining"

L["DEFAULT_TREASURE"] = "Treasure Chest"
L["DEFAULT_HERB"] = "Herb"
L["DEFAULT_MINE"] = "Mineral Vein"

L["MSG_FORMAT"] = "{rt7} Come & Get It // Hey %s, I came across %s %s that I can't %s at %s, %s in %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Come & Get It. Enjoying the addon? Tell a friend about it! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Found an herb you can't pick, a mineral vein you can't mine, or a locked treasure chest with no Rogue in sight? Right-click it, and Come & Get It creates a message you can use to share or broadcast the coordinates. Being a hero has never been so easy."

L["OPTIONS_WELCOME_NAME"] = "Enable Welcome Message"
L["OPTIONS_WELCOME_DESC"] = "Print the welcome message in chat when you log in."

L["FEEDBACK_HEADER"] = "Feedback and Support"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
