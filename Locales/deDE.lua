local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "deDE")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"]         = "Open Sesame"
L["STATUS_ENABLED"]      = "Aktiviert"
L["STATUS_DISABLED"]     = "Deaktiviert"
L["STATUS_PAUSED"]       = "Pausiert"
L["STATUS_ON"]           = "An"
L["STATUS_OFF"]          = "Aus"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"]   = "Automatisches Plündern ist erforderlich, damit Open Sesame richtig funktioniert. Automatisches Plündern wurde aktiviert."
L["PAUSED_BAG_SLOTS"]    = "Pausiert, bis mindestens %d Taschenplätze frei sind."
L["RESUMED"]             = "Fortgesetzt."
L["INVENTORY_FULL"]      = "Inventar ist voll!"
L["ITEM_WILL_AUTO_OPEN"] = "%s wird automatisch geöffnet, sobald es entsperrt ist."
L["ITEM_OPEN_MANUALLY"]  = "%s muss manuell geöffnet werden. Es kann einen einzigartigen, beim Aufheben gebundenen oder temporären Gegenstand enthalten oder wurde von einem Schlachtzugsboss fallengelassen."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Automatisches Öffnen"
L["AUTO_OPENING_DESC"]   = "Öffnet automatisch Muscheln und entsperrte Behälter, wenn mehr als 4 Taschenplätze frei sind."
L["SPEEDY_LOOT"]         = "Schnelle Beute"
L["SPEEDY_LOOT_DESC"]    = "Blendet das Beutefenster aus, um Beute nahezu sofort aufzusammeln."
L["LOOT_SOUNDS"]         = "Beutegeräusche"
L["LOOT_SOUNDS_DESC"]    = "Spielt einen besonderen Ton ab, wenn ein Gegenstand ungewöhnlicher oder höherer Qualität erbeutet wird."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"]  = "Linksklick"
L["KEYBIND_RIGHT_CLICK"] = "Rechtsklick"
L["KEYBIND_MIDDLE_CLICK"] = "Mittelklick"
L["ACTION_TOGGLE"]       = "Umschalten"
L["TOOLTIP_HINT"]        = "Weitere Einstellungen unter Optionen > AddOns > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"]       = "Öffnet automatisch Muscheln und entsperrte Behälter im Inventar. Mit Schnelle Beute für schnelleres Aufsammeln."
L["OPTIONS_FEEDBACK"]    = "Feedback & Support"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"