local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "deDE")
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Schurken"
L["HERBALISTS"] = "Kräuterkundige"
L["MINERS"] = "Bergbauer"

L["ACTION_OPEN"] = "öffnen"
L["ACTION_PICK"] = "pflücken"
L["ACTION_MINE"] = "abbauen"

L["PREFIX_LOCKED"] = "eine verschlossene"
L["PREFIX_HERB"] = "ein"
L["PREFIX_MINE"] = "ein"

L["MATCH_HERB"] = "Kräuterkunde"
L["MATCH_MINE"] = "Bergbau"

L["DEFAULT_TREASURE"] = "Schatztruhe"
L["DEFAULT_HERB"] = "Kraut"
L["DEFAULT_MINE"] = "Erzvorkommen"

L["MSG_FORMAT"] = "{rt7} Come & Get It // Hey %s, ich habe %s %s gefunden! Ich kann es nicht %s. (%s, %s in %s)"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden sich unter Optionen > AddOns > Come & Get It. Gefällt dir das Addon? Erzähl einem Freund davon! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Hast du ein Kraut gefunden, das du nicht pflücken kannst, eine Erzader, die du nicht abbauen kannst, oder eine verschlossene Schatztruhe und kein Schurke ist in Sicht? Klicke mit der rechten Maustaste darauf, und Come & Get It erstellt eine Nachricht, mit der du die Koordinaten teilen oder senden kannst. Ein Held zu sein war noch nie so einfach."

L["OPTIONS_WELCOME_NAME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_WELCOME_DESC"] = "Gibt die Willkommensnachricht im Chat aus, wenn du dich einloggst."

L["FEEDBACK_HEADER"] = "Feedback und Support"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"