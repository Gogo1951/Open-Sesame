local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "deDE")
if not L then return end

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
L["AUTO_LOOT_ENABLED"] = "Automatisches Plündern ist erforderlich, damit Open Sesame richtig funktioniert. Automatisches Plündern wurde aktiviert."
L["CHAT_LOADED"] = "Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden Sie unter Optionen > AddOns > Open Sesame. Gefällt dir das Addon? Erzähl einem Freund davon! (="
L["MESSAGE_RESET"] = "Alle Einstellungen wurden auf die Standardwerte zurückgesetzt."

-- Auto-Open
L["PAUSED_BAG_SLOTS"] = "Das automatische Öffnen ist pausiert, bis mindestens %d Taschenplätze frei sind."
L["RESUMED"] = "Das automatische Öffnen wurde fortgesetzt."
L["INVENTORY_FULL"] = "Inventar ist voll!"
L["ITEM_WILL_AUTO_OPEN"] = "%s wird automatisch geöffnet, sobald es entsperrt ist."
L["ITEM_OPEN_MANUALLY"] = "%s muss manuell geöffnet werden. Es kann einen einzigartigen, beim Aufheben gebundenen oder temporären Gegenstand enthalten oder wurde von einem Schlachtzugsboss fallengelassen."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Automatisches Öffnen"
L["AUTO_OPENING_DESC"] = "Öffnet automatisch Muscheln und entsperrte Behälter, wenn mindestens %d Taschenplätze frei sind."
L["SPEEDY_LOOT"] = "Schnelle Beute"
L["SPEEDY_LOOT_DESC"] = "Blendet das Beutefenster aus, um Beute nahezu sofort aufzusammeln."
L["LOOT_SOUNDS"] = "Beutegeräusche"
L["LOOT_SOUNDS_DESC"] = "Spielt einen besonderen Ton ab, wenn ein Gegenstand ungewöhnlicher oder höherer Qualität erbeutet wird."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Linksklick"
L["KEYBIND_RIGHT_CLICK"] = "Rechtsklick"
L["KEYBIND_MIDDLE_CLICK"] = "Mittelklick"
L["ACTION_TOGGLE"] = "Umschalten"
L["TOOLTIP_HINT"] = "Weitere Einstellungen finden Sie unter Optionen > AddOns > Open Sesame."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "Öffnet automatisch Muscheln und entsperrte Behälter im Inventar. Mit Schnelle Beute für schnelleres Aufsammeln."
L["OPTIONS_ENABLE_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_ENABLE_MINIMAP"] = "Minikarten-Schaltfläche aktivieren"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Schließfach-Benachrichtigungen aktivieren"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Automatisches Öffnen aktivieren"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Schnelle Beute aktivieren"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Beutegeräusche aktivieren"
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Öffnet die Open Sesame Optionen."
L["OPTIONS_RESET"] = "Zurücksetzen"
L["OPTIONS_RESET_DESC"] = "Stellt jede Einstellung von Open Sesame auf den Standardwert zurück."
L["OPTIONS_RESET_BUTTON"] = "Alle Open Sesame Optionen zurücksetzen"
L["OPTIONS_RESET_CONFIRM"] = "Alle Open Sesame Einstellungen auf die Standardwerte zurücksetzen?"
L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
