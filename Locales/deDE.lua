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
L["TAB_LOCKBOXES"] = "Schließkassetten"
L["TAB_IGNORE_LIST"] = "Ignorierliste"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Automatisches Plündern wurde aktiviert. Open Sesame benötigt es, um zu funktionieren."
L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen kann die Optionen-Oberfläche im Kampf nicht geöffnet werden."
L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) findest du unter Optionen > AddOns > Open Sesame. Gefällt dir das Add-on? Erzähl einem Freund davon! (="
L["CHAT_END_OF_SUPPORT"] =
	"Ende des Supports: Dieses Add-on ist jetzt Teil von GogoLoot, und dies ist seine letzte Version. Installiere GogoLoot, um weiterhin Updates zu erhalten, und danach kannst du Open Sesame entfernen."

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "Das automatische Öffnen ist pausiert, bis mindestens %d Taschenplätze frei sind."
L["RESUMED"] = "Das automatische Öffnen wurde fortgesetzt."
L["INVENTORY_FULL"] = "Inventar ist voll!"
L["ITEM_WILL_AUTO_OPEN"] = "%s öffnet sich automatisch, sobald es entsperrt ist."
L["ITEM_IGNORED"] = "%s steht auf deiner Ignorierliste, daher lässt das automatische Öffnen es in Ruhe."
L["ITEM_OPEN_MANUALLY"] = "%s steht auf deiner Ignorierliste, daher hat die Schnelle Beute es im Beutefenster gelassen."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Automatisches Öffnen"
L["AUTO_OPENING_DESCRIPTION"] =
	"Öffnet automatisch Muscheln und entsperrte Behälter, wenn mindestens %d Taschenplätze frei sind."
L["SPEEDY_LOOT"] = "Schnelle Beute"
L["SPEEDY_LOOT_DESCRIPTION"] = "Blendet das Beutefenster aus, um Beute nahezu sofort aufzusammeln."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Die Schnelle Beute blendet das Beutefenster aus, daher verraten dir diese Geräusche, was du gerade aufgesammelt hast."
L["LOCKBOXES_DESCRIPTION"] =
	"Verschlossene Behälter benötigen die Fertigkeit Schlossknacken eines Schurken, bevor sie sich öffnen lassen. Diese Optionen zeigen, was jede Schließkassette erfordert, und melden dir, wenn eine wartet."
L["LOOT_SOUNDS"] = "Beutegeräusch"
L["LOOT_SOUNDS_DESCRIPTION"] =
	"Spielt einen Ton ab, wenn du einen Gegenstand der gewählten Qualität oder besser plünderst."

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
	"Öffnet automatisch Muscheln, Behälter und entsperrte Schließkassetten in deinen Taschen, ganz ohne Klicken. Die Schnelle Beute blendet das Beutefenster für schnelleres automatisches Plündern aus. Schnelles, effizientes Plündern."
L["OPTIONS_ENABLE_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Zeigt bei jedem Einloggen die Version und einen kurzen Willkommensgruß im Chat an."
L["OPTIONS_ENABLE_MINIMAP"] = "Minikarten-Schaltfläche aktivieren"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Zeigt die Schaltfläche von Open Sesame an der Minikarte an."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet die Optionen-Oberfläche für dieses Add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Automatisches Öffnen aktivieren"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Schaltet das automatische Öffnen von Muscheln und entsperrten Behältern ein oder aus."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Wo"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Lege fest, ob Behälter überall geöffnet werden oder nur außerhalb von Instanzen."
L["OPTIONS_ANYWHERE"] = "Überall"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Außerhalb von Instanzen"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Gruppe"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"Lege fest, ob Behälter auch in einer Gruppe geöffnet werden oder nur, wenn du allein spielst."
L["OPTIONS_SOLO_OR_GROUPED"] = "Allein oder in Gruppe"
L["OPTIONS_SOLO_ONLY"] = "Nur allein"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Schnelle Beute aktivieren"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"Plündert alles auf einmal und blendet das Beutefenster aus, das nur für Gegenstände offen bleibt, die nicht mehr in die Taschen passen oder auf deiner Ignorierliste stehen."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Schließkassetten-Tooltips aktivieren"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] =
	"Fügt dem Tooltip jeder Schließkassette die benötigte Schlossknacken-Fertigkeit hinzu."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"Lege fest, ob Schließkassetten-Tooltips nur für Schurken oder für alle Charaktere erscheinen."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Schließkassetten-Benachrichtigungen aktivieren"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"Meldet dir im Chat, wenn du eine Schließkassette erbeutest, die sich öffnet, sobald sie entsperrt ist."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"Lege fest, ob Schließkassetten-Benachrichtigungen nur für Schurken oder für alle Charaktere erscheinen."
L["OPTIONS_SHOW_FOR"] = "Anzeigen für"
L["OPTIONS_FOR_ROGUES"] = "Für Schurken"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Für alle Charaktere"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Beutegeräusch aktivieren"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"Spielt einen Klang ab, wenn du von einer Leiche oder aus einer Truhe einen Gegenstand mit mindestens der Mindestqualität plünderst."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] =
	"Die niedrigste Gegenstandsqualität, bei der das Beutegeräusch abgespielt wird."
L["OPTIONS_TEST_LOOT_SOUND"] = "Spielt das Beutegeräusch ab."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Taschendiebstahl-Geräusch aktivieren"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"Spielt ein Taschengeräusch ab, wenn Taschendiebstahl tatsächlich etwas erbeutet."
L["OPTIONS_MINIMUM_QUALITY"] = "Mindestqualität"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Gegenstände auf dieser Liste werden in Ruhe gelassen: Die Schnelle Beute lässt sie im Beutefenster, und das automatische Öffnen öffnet sie nie. Die Liste gilt für alle deine Charaktere."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Benachrichtigungen zur Ignorierliste aktivieren"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Meldet dir im Chat, wenn Open Sesame einen Gegenstand in Ruhe lässt, weil er auf deiner Ignorierliste steht."
L["OPTIONS_IGNORE_LIST_ADD"] = "Gegenstand hinzufügen"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] =
	"Ziehe einen Gegenstand hierher oder füge einen Gegenstandslink oder eine Gegenstands-ID ein."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Entfernt diesen Gegenstand von der Ignorierliste."
L["OPTIONS_ITEM_LOADING"] = "Gegenstand %d wird geladen..."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Standard wiederherstellen"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Ersetzt deine Ignorierliste durch die Standardliste und entfernt alle Gegenstände, die du hinzugefügt hast."
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"Die Standard-Ignorierliste wiederherstellen? Von dir hinzugefügte Gegenstände werden entfernt."
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
L["OPTIONS_VERSION"] = "Version %s"
