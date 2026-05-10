local strings = {}

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

strings["ROGUES"] = "Pícaros"
strings["HERBALISTS"] = "Herboristas"
strings["MINERS"] = "Mineros"

strings["ACTION_OPEN"] = "abrir"
strings["ACTION_PICK"] = "recolectar"
strings["ACTION_MINE"] = "minar"

strings["PREFIX_LOCKED"] = "un"
strings["PREFIX_HERB"] = "algunas"
strings["PREFIX_MINE"] = "una"

strings["MATCH_HERB"] = "Herboristería"
strings["MATCH_MINE"] = "Minería"

strings["DEFAULT_TREASURE"] = "Cofre cerrado"
strings["DEFAULT_HERB"] = "Hierba"
strings["DEFAULT_MINE"] = "Veta de mineral"

strings["MSG_FORMAT"] = "{rt7} Come & Get It // ¡Oye %s, encontré %s %s que no puedo %s en %s, %s en %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

strings["CHAT_LOADED"] = "Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Come & Get It. Enjoying the addon? Tell a friend about it! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

strings["OPTIONS_DESCRIPTION"] = "Found an herb you can’t pick, a mineral vein you can’t mine, or a locked treasure chest with no Rogue in sight? Right-click it, and Come & Get It creates a message you can use to share or broadcast the coordinates. Being a hero has never been so easy."

strings["OPTIONS_WELCOME_NAME"] = "Enable Welcome Message"
strings["OPTIONS_WELCOME_DESC"] = "Print the welcome message in chat when you log in."

strings["FEEDBACK_HEADER"] = "Feedback and Support"
strings["FEEDBACK_CURSEFORGE"] = "CurseForge"
strings["FEEDBACK_GITHUB"] = "GitHub"
strings["FEEDBACK_DISCORD"] = "Discord"

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esES")
if L then
    for k, v in pairs(strings) do L[k] = v end
end

local L2 = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esMX")
if L2 then
    for k, v in pairs(strings) do L2[k] = v end
end
