local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "frFR")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"]         = "Open Sesame"
L["STATUS_ENABLED"]      = "Activé"
L["STATUS_DISABLED"]     = "Désactivé"
L["STATUS_PAUSED"]       = "En pause"
L["STATUS_ON"]           = "On"
L["STATUS_OFF"]          = "Off"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"]   = "La Fouille automatique est requise pour qu'Open Sesame fonctionne correctement. La Fouille automatique a été activée."
L["PAUSED_BAG_SLOTS"]    = "En pause jusqu'à ce que vous ayez au moins %d emplacements de sac libres."
L["RESUMED"]             = "Reprise."
L["INVENTORY_FULL"]      = "L'inventaire est plein !"
L["ITEM_WILL_AUTO_OPEN"] = "%s sera automatiquement ouvert une fois déverrouillé."
L["ITEM_OPEN_MANUALLY"]  = "%s doit être ouvert manuellement. Il peut contenir un objet unique, lié quand ramassé ou temporaire, ou a été lâché par un boss de raid."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Ouverture automatique"
L["AUTO_OPENING_DESC"]   = "Ouvre automatiquement les palourdes et les conteneurs déverrouillés quand vous avez plus de 4 emplacements de sac libres."
L["SPEEDY_LOOT"]         = "Butin rapide"
L["SPEEDY_LOOT_DESC"]    = "Masque la fenêtre de butin pour un ramassage quasi instantané."
L["LOOT_SOUNDS"]         = "Sons de butin"
L["LOOT_SOUNDS_DESC"]    = "Joue un son distinct quand vous ramassez un objet de qualité Inhabituelle ou supérieure."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"]  = "Clic gauche"
L["KEYBIND_RIGHT_CLICK"] = "Clic droit"
L["KEYBIND_MIDDLE_CLICK"] = "Clic molette"
L["ACTION_TOGGLE"]       = "Basculer"
L["TOOLTIP_HINT"]        = "Plus d'options dans Options > AddOns > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"]       = "Ouvre automatiquement les palourdes et les conteneurs déverrouillés dans votre inventaire. Inclut Butin rapide pour un ramassage plus rapide."
L["OPTIONS_FEEDBACK"]    = "Commentaires & Support"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"