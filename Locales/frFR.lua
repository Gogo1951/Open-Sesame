local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "frFR")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Activé"
L["STATUS_DISABLED"] = "Désactivé"
L["STATUS_PAUSED"] = "En pause"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "La Fouille automatique est requise pour qu'Open Sesame fonctionne correctement. La Fouille automatique a été activée."
L["CHAT_LOADED"] = "Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > AddOns > Open Sesame. Vous aimez l'addon ? Parlez-en à un ami ! (="
L["MESSAGE_RESET"] = "Tous les paramètres ont été réinitialisés à leurs valeurs par défaut."

-- Auto-Open
L["PAUSED_BAG_SLOTS"] = "L'ouverture automatique est en pause jusqu'à ce que vous ayez au moins %d emplacements de sac libres."
L["RESUMED"] = "L'ouverture automatique a repris."
L["INVENTORY_FULL"] = "L'inventaire est plein !"
L["ITEM_WILL_AUTO_OPEN"] = "%s sera automatiquement ouvert une fois déverrouillé."
L["ITEM_OPEN_MANUALLY"] = "%s doit être ouvert manuellement. Il peut contenir un objet unique, lié quand ramassé ou temporaire, ou a été lâché par un boss de raid."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Ouverture automatique"
L["AUTO_OPENING_DESC"] = "Ouvre automatiquement les palourdes et les conteneurs déverrouillés quand vous avez au moins %d emplacements de sac libres."
L["SPEEDY_LOOT"] = "Butin rapide"
L["SPEEDY_LOOT_DESC"] = "Masque la fenêtre de butin pour un ramassage quasi instantané."
L["LOOT_SOUNDS"] = "Sons de butin"
L["LOOT_SOUNDS_DESC"] = "Joue un son distinct quand vous ramassez un objet de qualité Inhabituelle ou supérieure."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clic gauche"
L["KEYBIND_RIGHT_CLICK"] = "Clic droit"
L["KEYBIND_MIDDLE_CLICK"] = "Clic molette"
L["ACTION_TOGGLE"] = "Basculer"
L["TOOLTIP_HINT"] = "Des paramètres supplémentaires se trouvent dans Options > AddOns > Open Sesame."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "Ouvre automatiquement les palourdes, les coffres-forts et les conteneurs déverrouillés dans votre inventaire. Propose Butin rapide pour un ramassage plus rapide."
L["OPTIONS_ENABLE_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_ENABLE_MINIMAP"] = "Activer le bouton de la mini-carte"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Activer les notifications de coffres-forts"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Activer l'ouverture automatique"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Activer le butin rapide"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Activer les sons de butin"
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Ouvre l'interface des options d'Open Sesame."
L["OPTIONS_RESET"] = "Réinitialiser"
L["OPTIONS_RESET_DESC"] = "Restaure tous les paramètres d'Open Sesame à leurs valeurs par défaut."
L["OPTIONS_RESET_BUTTON"] = "Réinitialiser toutes les options d'Open Sesame"
L["OPTIONS_RESET_CONFIRM"] = "Réinitialiser tous les paramètres d'Open Sesame à leurs valeurs par défaut ?"
L["OPTIONS_FEEDBACK"] = "Commentaires & Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
