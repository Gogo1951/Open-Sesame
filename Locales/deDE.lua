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
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "Benachrichtigungen"
L["TAB_LOCKBOXES"] = "Schließfächer"
L["TAB_IGNORE_LIST"] = "Ignorierliste"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Automatisches Plündern wurde aktiviert. Open Sesame benötigt es, um zu funktionieren."
L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen kann die Optionen-Oberfläche im Kampf nicht geöffnet werden."
L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) findest du unter Optionen > AddOns > Open Sesame. Gefällt dir das Add-on? Erzähl einem Freund davon! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "Das automatische Öffnen ist pausiert, bis mindestens %d Taschenplätze frei sind."
L["RESUMED"] = "Das automatische Öffnen wurde fortgesetzt."
L["INVENTORY_FULL"] = "Inventar ist voll!"
L["ITEM_WILL_AUTO_OPEN"] = "%s wird automatisch geöffnet, sobald es entsperrt ist."
L["ITEM_IGNORED"] = "%s steht auf deiner Ignorierliste, daher hat das automatische Öffnen es in Ruhe gelassen."
L["ITEM_OPEN_MANUALLY"] = "%s wurde im Beutefenster gelassen, damit du es selbst öffnen kannst."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Automatisches Öffnen"
L["AUTO_OPENING_DESCRIPTION"] =
	"Öffnet automatisch Muscheln und entsperrte Behälter, wenn mindestens %d Taschenplätze frei sind."
L["SPEEDY_LOOT"] = "Schnelle Beute"
L["SPEEDY_LOOT_DESCRIPTION"] = "Blendet das Beutefenster aus, um Beute nahezu sofort aufzusammeln."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Die Schnelle Beute blendet das Beutefenster aus, daher teilt dir Open Sesame hierüber mit, was du gerade aufgesammelt hast."
L["LOCKBOXES_DESCRIPTION"] =
	"Verschlossene Behälter benötigen die Fertigkeit Schlossknacken eines Schurken, bevor sie sich öffnen lassen. Diese Optionen zeigen, was jedes Schließfach erfordert, und melden dir, wenn eines wartet."
L["LOOT_SOUNDS"] = "Beutegeräusch"
L["LOOT_SOUNDS_DESCRIPTION"] = "Spielt einen Ton ab, abhängig von der Qualitätsstufe deiner Wahl."
L["LOOT_TOASTS"] = "Beutehinweise"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Zeigt einen kurzen Hinweis auf dem Bildschirm für Gegenstände, die du aufsammelst, da die Schnelle Beute das Beutefenster ausblendet. Beute aus dem Chat zu verlagern hält das Fenster frei für Gespräche und die Nachrichten, auf die es ankommt."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Linksklick"
L["KEYBIND_RIGHT_CLICK"] = "Rechtsklick"
L["KEYBIND_MIDDLE_CLICK"] = "Mittelklick"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + Mittelklick"
L["ACTION_TOGGLE"] = "Umschalten"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame Optionen"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "Benötigt Schlossknacken"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "Dein Schlossknacken"
L["TOOLTIP_LOCKED_ITEMS"] = "Verschlossene Gegenstände"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"Öffnet automatisch Muscheln, Schließfächer und entsperrte Behälter in deinen Taschen, ganz ohne Klicken. Die integrierte Schnelle Beute blendet das Beutefenster für nahezu sofortiges automatisches Aufsammeln aus. Weniger Klicken, mehr Spielen."
L["OPTIONS_ENABLE_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_ENABLE_MINIMAP"] = "Minikarten-Schaltfläche aktivieren"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Automatisches Öffnen aktivieren"
L["OPTIONS_AUTO_OPENING_WHERE"] = "Wo"
L["OPTIONS_ANYWHERE"] = "Überall"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Außerhalb von Instanzen"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Gruppe"
L["OPTIONS_SOLO_OR_GROUPED"] = "Allein oder in Gruppe"
L["OPTIONS_SOLO_ONLY"] = "Nur allein"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Schnelle Beute aktivieren"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Schließfach-Tooltips aktivieren"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Schließfach-Benachrichtigungen aktivieren"
L["OPTIONS_SHOW_FOR"] = "Anzeigen für"
L["OPTIONS_FOR_ROGUES"] = "Für Schurken"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Für alle Charaktere"

-- Notifications
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Beutegeräusch aktivieren"
L["OPTIONS_TEST_LOOT_SOUND"] = "Beutegeräusch abspielen."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Taschendiebstahl-Geräusch aktivieren"
L["OPTIONS_MINIMUM_QUALITY"] = "Mindestqualität"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Beutehinweise aktivieren"
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "Beim Aufheben gebundene Gegenstände immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "Questgegenstände immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "Rezepte immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "Reittiere immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "Haustiere immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "Schlüssel immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "Taschen immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "Behälter immer anzeigen"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "Gold immer anzeigen"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Maximal angezeigte Einträge"
L["OPTIONS_UNLIMITED"] = "Unbegrenzt"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Sekunden auf dem Bildschirm"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Wachstumsrichtung"
L["OPTIONS_GROW_UP"] = "Nach oben"
L["OPTIONS_GROW_DOWN"] = "Nach unten"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Einträge ausrichten"
L["OPTIONS_ALIGN_LEFT"] = "Links"
L["OPTIONS_ALIGN_RIGHT"] = "Rechts"
L["OPTIONS_LOOT_TOAST_FONT"] = "Schriftart"
L["OPTIONS_FONT_DEFAULT"] = "Standard"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Schriftgröße"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Schriftkontur"
L["OPTIONS_FONT_OUTLINE_NONE"] = "Keine"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Kontur"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Dicke Kontur"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Einfarbig"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Einfarbige Kontur"
L["OPTIONS_TOASTS_UNLOCK"] = "Position entsperren"
L["OPTIONS_TOASTS_LOCK"] = "Position sperren"
L["OPTIONS_TOASTS_RESET"] = "Position zurücksetzen"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Klicken + Ziehen zum Positionieren"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Rechtsklick zum Sperren"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Beutehinweise deaktivieren"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Beispielgegenstand"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet die Optionen-Oberfläche für dieses Add-on."

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Gegenstände auf dieser Liste werden in Ruhe gelassen: Die Schnelle Beute lässt sie im Beutefenster, und das automatische Öffnen öffnet sie nie. Die Liste gilt für alle deine Charaktere."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Benachrichtigungen zur Ignorierliste aktivieren"
L["OPTIONS_IGNORE_LIST_ADD"] = "Gegenstand hinzufügen"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] =
	"Ziehe einen Gegenstand hierher oder füge einen Gegenstandslink oder eine Gegenstands-ID ein."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Diesen Gegenstand von der Ignorierliste entfernen."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Standard wiederherstellen"
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"Die Standard-Ignorierliste wiederherstellen? Von dir hinzugefügte Einträge werden entfernt."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Beute eines Schlachtzugsbosses. Ein ungeöffneter Behälter kann weiterhin gehandelt oder verkauft werden, oft für mehr als sein Inhalt."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"Kann einen einzigartigen Questgegenstand enthalten. Das Öffnen kann mit einem Fehler fehlschlagen, wenn du bereits einen besitzt."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"Kann ein beim Aufheben gebundenes Rezept enthalten. Ein ungeöffneter Behälter kann weiterhin gehandelt oder verkauft werden."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"Kann eine beim Aufheben gebundene Waffe oder ein Rüstungsteil enthalten. Ein ungeöffneter Behälter kann weiterhin gehandelt oder verkauft werden."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"Kann einen beim Aufheben gebundenen Feiertagsgegenstand enthalten. Ein ungeöffneter Behälter kann weiterhin gehandelt oder verkauft werden."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"Kann einen beim Aufheben gebundenen Gegenstand enthalten. Ein ungeöffneter Behälter kann weiterhin gehandelt oder verkauft werden."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback & Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
