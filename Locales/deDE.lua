local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "deDE")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Aktiviert"
L["STATUS_DISABLED"] = "Deaktiviert"
L["STATUS_PAUSED"] = "Pausiert"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Automatisches Plündern wurde aktiviert. Open Sesame benötigt es, um zu funktionieren."
L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden Sie unter Optionen > AddOns > Open Sesame. Gefällt dir das Addon? Erzähl einem Freund davon! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "Das automatische Öffnen ist pausiert, bis mindestens %d Taschenplätze frei sind."
L["RESUMED"] = "Das automatische Öffnen wurde fortgesetzt."
L["INVENTORY_FULL"] = "Inventar ist voll!"
L["ITEM_WILL_AUTO_OPEN"] = "%s wird automatisch geöffnet, sobald es entsperrt ist."
L["ITEM_OPEN_MANUALLY"] =
	"%s muss manuell geöffnet werden. Es kann einen einzigartigen, beim Aufheben gebundenen oder temporären Gegenstand enthalten oder wurde von einem Schlachtzugsboss fallengelassen."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Automatisches Öffnen"
L["AUTO_OPENING_DESC"] =
	"Öffnet automatisch Muscheln und entsperrte Behälter, wenn mindestens %d Taschenplätze frei sind."
L["SPEEDY_LOOT"] = "Schnelle Beute"
L["SPEEDY_LOOT_DESC"] = "Blendet das Beutefenster aus, um Beute nahezu sofort aufzusammeln."
L["LOOT_SOUNDS"] = "Beutegeräusch"
L["LOOT_SOUNDS_DESC"] =
	"Spielt einen besonderen Ton ab, wenn ein Gegenstand ungewöhnlicher oder höherer Qualität erbeutet wird."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Linksklick"
L["KEYBIND_RIGHT_CLICK"] = "Rechtsklick"
L["KEYBIND_MIDDLE_CLICK"] = "Mittelklick"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + Mittelklick"
L["ACTION_TOGGLE"] = "Umschalten"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame Optionen"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"Open Sesame öffnet automatisch Muscheln, Schließfächer und entsperrte Behälter in deinen Taschen. Die integrierte Schnelle Beute blendet das Beutefenster für nahezu sofortiges Aufsammeln aus. Weniger Klicken, mehr Spielen."
L["OPTIONS_ENABLE_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_ENABLE_MINIMAP"] = "Minikarten-Schaltfläche aktivieren"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Schließfach-Benachrichtigungen aktivieren"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Automatisches Öffnen aktivieren"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Schnelle Beute aktivieren"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Beutegeräusch aktivieren"
L["OPTIONS_LOOT_SOUND_THRESHOLD"] = "Mindestqualität für Beutegeräusch"
L["OPTIONS_TEST_LOOT_SOUND"] = "Beutegeräusch abspielen."
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Öffnet die Open Sesame Optionen."
L["OPTIONS_FEEDBACK"] = "Feedback & Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
