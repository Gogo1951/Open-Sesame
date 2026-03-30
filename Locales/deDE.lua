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

L["AUTO_LOOT_ENABLED"]   = "Automatisches Aufsammeln wird von Open Sesame vorausgesetzt. Es wurde aktiviert."
L["PAUSED_BAG_SLOTS"]    = "Pausiert, bis mindestens %d Taschenplaetze frei sind."
L["RESUMED"]             = "Fortgesetzt."
L["INVENTORY_FULL"]      = "Inventar ist voll!"
L["ITEM_WILL_AUTO_OPEN"] = "%s wird automatisch geoeffnet, sobald es entsperrt ist."
L["ITEM_OPEN_MANUALLY"]  = "%s muss manuell geoeffnet werden. Es kann einen einzigartigen, beim Aufheben gebundenen oder temporaeren Gegenstand enthalten oder wurde von einem Raidboss fallen gelassen."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Automatisches Oeffnen"
L["AUTO_OPENING_DESC"]   = "Oeffnet automatisch Muscheln und entsperrte Behaelter, wenn mehr als 4 Taschenplaetze frei sind."
L["SPEEDY_LOOT"]         = "Schnelle Beute"
L["SPEEDY_LOOT_DESC"]    = "Blendet das Beutefenster aus, um Beute nahezu sofort aufzusammeln."
L["LOOT_SOUNDS"]         = "Beutegeraeusche"
L["LOOT_SOUNDS_DESC"]    = "Spielt einen besonderen Ton ab, wenn ein Gegenstand ungewoehnlicher oder hoeherer Qualitaet erbeutet wird."

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

L["OPTIONS_INTRO"]       = "Oeffnet automatisch Muscheln und entsperrte Behaelter im Inventar. Mit Schnelle Beute fuer schnelleres Aufsammeln."
L["OPTIONS_FEEDBACK"]    = "Feedback und Support"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"
