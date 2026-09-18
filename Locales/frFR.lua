local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "frFR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Activé"
L["STATUS_DISABLED"] = "Désactivé"
L["STATUS_PAUSED"] = "En pause"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "Notifications"
L["TAB_LOCKBOXES"] = "Coffres verrouillés"
L["TAB_IGNORE_LIST"] = "Liste d'exclusion"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Le butin automatique a été activé. Open Sesame en a besoin pour fonctionner."
L["CHAT_OPTIONS_IN_COMBAT"] = "Par précaution, l'Interface d'Options ne peut pas être ouverte en combat."
L["CHAT_LOADED"] =
	"Version %s. Les réglages (dont l'option pour désactiver ce message) se trouvent dans Options > AddOns > Open Sesame. L'add-on vous plaît ? Parlez-en à un ami ! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] =
	"L'ouverture automatique est en pause tant que vous n'avez pas au moins %d emplacements de sac libres."
L["RESUMED"] = "L'ouverture automatique a repris."
L["INVENTORY_FULL"] = "L'inventaire est plein !"
L["ITEM_WILL_AUTO_OPEN"] = "%s s'ouvrira automatiquement dès qu'il sera déverrouillé."
L["ITEM_IGNORED"] = "%s est dans votre liste d'exclusion, l'ouverture automatique le laissera donc tranquille."
L["ITEM_OPEN_MANUALLY"] = "%s a été laissé dans la fenêtre de butin pour que vous le ramassiez vous-même."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Ouverture automatique"
L["AUTO_OPENING_DESCRIPTION"] =
	"Ouvre automatiquement les palourdes et les conteneurs déverrouillés quand vous avez au moins %d emplacements de sac libres."
L["SPEEDY_LOOT"] = "Butin rapide"
L["SPEEDY_LOOT_DESCRIPTION"] = "Masque la fenêtre de butin pour un ramassage quasi instantané."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Le butin rapide masque la fenêtre de butin, ces sons et notifications vous indiquent donc ce que vous venez de ramasser."
L["LOCKBOXES_DESCRIPTION"] =
	"Les conteneurs verrouillés nécessitent la compétence Crochetage d'un voleur avant de s'ouvrir. Ces options indiquent ce que chaque coffre exige et vous préviennent quand l'un d'eux attend."
L["LOOT_SOUNDS"] = "Son de butin"
L["LOOT_SOUNDS_DESCRIPTION"] =
	"Joue un son quand vous ramassez un objet d'une qualité égale ou supérieure à celle que vous choisissez."
L["LOOT_TOASTS"] = "Notifications de butin"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Affiche un bref message à l'écran pour les objets que vous ramassez, puisque le butin rapide masque la fenêtre de butin. Avec les notifications activées, vous pouvez désactiver les messages de butin dans les réglages du chat et garder le chat libre pour les conversations et les messages qui comptent."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clic gauche"
L["KEYBIND_RIGHT_CLICK"] = "Clic droit"
L["KEYBIND_MIDDLE_CLICK"] = "Clic milieu"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Maj + Clic milieu"
L["ACTION_TOGGLE"] = "Basculer"
L["TOOLTIP_OPTIONS_TITLE"] = "Options d'Open Sesame"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "Crochetage requis"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "Votre Crochetage"
L["TOOLTIP_LOCKED_ITEMS"] = "Objets verrouillés"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"Ouvre automatiquement les palourdes, les conteneurs et les coffres déverrouillés de vos sacs, sans aucun clic. Le butin rapide masque la fenêtre de butin pour accélérer le ramassage automatique, et les notifications de butin affichent chaque objet ramassé pour que vos yeux restent sur le combat. Un ramassage rapide et efficace."
L["OPTIONS_ENABLE_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Affiche la version et un court message de bienvenue dans le chat à chaque connexion."
L["OPTIONS_ENABLE_MINIMAP"] = "Activer le bouton de la mini-carte"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Affiche le bouton d'Open Sesame sur la mini-carte."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre l'Interface d'Options de cet add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Activer l'ouverture automatique"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Active ou désactive l'ouverture automatique des palourdes et des conteneurs déverrouillés."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Où"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Choisissez si les conteneurs s'ouvrent partout, ou attendent que vous quittiez les donjons et les raids."
L["OPTIONS_ANYWHERE"] = "Partout"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Hors des instances"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Groupe"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"Choisissez si les conteneurs s'ouvrent quand vous êtes en groupe, ou seulement quand vous jouez seul."
L["OPTIONS_SOLO_OR_GROUPED"] = "Seul ou en groupe"
L["OPTIONS_SOLO_ONLY"] = "Seul uniquement"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Activer le butin rapide"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"Ramasse tout d'un coup et masque la fenêtre de butin, qui ne reste ouverte que pour les objets qui ne rentrent pas ou qui sont dans votre liste d'exclusion."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Activer les infobulles de coffres"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] =
	"Ajoute à l'infobulle de chaque coffre la compétence en Crochetage qu'il exige."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"Choisissez si les infobulles de coffres s'affichent seulement pour les voleurs ou pour tous les personnages."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Activer les notifications de coffres"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"Vous prévient dans le chat quand vous ramassez un coffre qui s'ouvrira dès qu'il sera déverrouillé."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"Choisissez si les notifications de coffres s'affichent seulement pour les voleurs ou pour tous les personnages."
L["OPTIONS_SHOW_FOR"] = "Afficher pour"
L["OPTIONS_FOR_ROGUES"] = "Pour les voleurs"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Pour tous les personnages"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Activer le son de butin"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"Joue un carillon quand vous ramassez sur un cadavre ou dans un coffre un objet d'une qualité égale ou supérieure à la Qualité minimale."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "La qualité d'objet la plus basse qui déclenche le son de butin."
L["OPTIONS_TEST_LOOT_SOUND"] = "Jouer le son de butin."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Activer le son de Vol à la tire"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"Joue un bruit de sac quand Vol à la tire rapporte réellement quelque chose."
L["OPTIONS_MINIMUM_QUALITY"] = "Qualité minimale"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Activer les notifications de butin"
L["OPTIONS_ENABLE_LOOT_TOASTS_DESCRIPTION"] =
	"Affiche une brève notification à l'écran pour les objets et l'argent que vous ramassez."
L["OPTIONS_LOOT_TOAST_QUALITY_DESCRIPTION"] =
	"La qualité d'objet la plus basse qui reçoit une notification, sauf si une option Toujours afficher ci-dessous couvre l'objet."
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "Toujours afficher les objets liés quand ramassés"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "Toujours afficher les objets de quête"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "Toujours afficher les recettes"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "Toujours afficher les montures"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "Toujours afficher les mascottes"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "Toujours afficher les clés"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "Toujours afficher les sacs"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "Toujours afficher les conteneurs"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "Toujours afficher l'argent"
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP_DESCRIPTION"] =
	"Affiche tous les objets liés quand ramassés, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS_DESCRIPTION"] =
	"Affiche les objets de quête et les objets qui débutent une quête, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_RECIPES_DESCRIPTION"] =
	"Affiche les recettes, patrons, plans et formules, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_MOUNTS_DESCRIPTION"] = "Affiche les montures, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_PETS_DESCRIPTION"] = "Affiche les mascottes, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_KEYS_DESCRIPTION"] = "Affiche les clés, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_BAGS_DESCRIPTION"] = "Affiche les sacs, carquois et gibernes, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_CONTAINERS_DESCRIPTION"] =
	"Affiche les conteneurs qu'Open Sesame peut ouvrir, coffres verrouillés compris, quelle que soit leur qualité."
L["OPTIONS_ALWAYS_SHOW_MONEY_DESCRIPTION"] = "Affiche une notification pour l'argent que vous ramassez."
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Nombre maximum d'objets affichés"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS_DESCRIPTION"] =
	"Le nombre maximum de notifications à l'écran en même temps ; la plus ancienne s'efface pour faire de la place."
L["OPTIONS_UNLIMITED"] = "Illimité"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Secondes à l'écran"
L["OPTIONS_LOOT_TOAST_DURATION_DESCRIPTION"] =
	"Combien de secondes chaque notification reste affichée avant de disparaître."
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Direction de croissance"
L["OPTIONS_LOOT_TOAST_GROWTH_DESCRIPTION"] =
	"Si les notifications plus anciennes montent ou descendent, en s'éloignant de la plus récente."
L["OPTIONS_GROW_UP"] = "Vers le haut"
L["OPTIONS_GROW_DOWN"] = "Vers le bas"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Aligner les objets"
L["OPTIONS_LOOT_TOAST_ALIGN_DESCRIPTION"] = "De quel côté de la poignée les notifications s'alignent."
L["OPTIONS_ALIGN_LEFT"] = "Gauche"
L["OPTIONS_ALIGN_RIGHT"] = "Droite"
L["OPTIONS_LOOT_TOAST_FONT"] = "Police"
L["OPTIONS_LOOT_TOAST_FONT_DESCRIPTION"] = "La police utilisée pour les notifications."
L["OPTIONS_FONT_DEFAULT"] = "Par défaut"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Taille de police"
L["OPTIONS_LOOT_TOAST_FONT_SIZE_DESCRIPTION"] =
	"La taille du texte des notifications ; les icônes grandissent et rétrécissent avec lui."
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Contour de police"
L["OPTIONS_LOOT_TOAST_OUTLINE_DESCRIPTION"] =
	"Le contour tracé autour du texte des notifications, qui le garde lisible sur les décors clairs."
L["OPTIONS_FONT_OUTLINE_NONE"] = "Aucun"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Contour"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Contour épais"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Monochrome"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Contour monochrome"
L["OPTIONS_TOASTS_UNLOCK"] = "Déverrouiller la position"
L["OPTIONS_TOASTS_LOCK"] = "Verrouiller la position"
L["OPTIONS_TOASTS_RESET"] = "Réinitialiser la position"
L["OPTIONS_TOASTS_LOCK_DESCRIPTION"] = "Affiche ou masque la poignée qui sert à déplacer les notifications."
L["OPTIONS_TOASTS_RESET_DESCRIPTION"] =
	"Replace les notifications à leur position par défaut, au-dessus du centre de l'écran."
L["OPTIONS_TOASTS_HANDLE_TITLE"] = "Notifications de butin d'Open Sesame"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Clic + Glisser pour positionner"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Clic droit pour verrouiller"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Désactiver les notifications de butin"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Objet d'exemple"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Les objets de cette liste sont laissés tranquilles : le butin rapide les laisse dans la fenêtre de butin et l'ouverture automatique ne les ouvre jamais. La liste est partagée par tous vos personnages."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Activer les notifications de la liste d'exclusion"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Vous prévient dans le chat quand Open Sesame laisse un objet tranquille parce qu'il est dans votre liste d'exclusion."
L["OPTIONS_IGNORE_LIST_ADD"] = "Ajouter un objet"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Glissez un objet ici, ou collez un lien d'objet ou un ID d'objet."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Retirer cet objet de la liste d'exclusion."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Restaurer les valeurs par défaut"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Remplace votre liste d'exclusion par celle par défaut, en retirant les objets que vous avez ajoutés."
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"Restaurer la liste d'exclusion par défaut ? Les objets que vous avez ajoutés seront retirés."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Butin d'un boss de raid. Un conteneur non ouvert peut encore être échangé ou vendu, souvent pour plus que son contenu."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"Peut contenir un objet de quête unique. L'ouvrir peut échouer avec une erreur si vous en avez déjà un."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"Peut contenir une recette liée quand ramassée. Un conteneur non ouvert peut encore être échangé ou vendu."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"Peut contenir une arme ou une pièce d'armure liée quand ramassée. Un conteneur non ouvert peut encore être échangé ou vendu."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"Peut contenir un objet de fête lié quand ramassé. Un conteneur non ouvert peut encore être échangé ou vendu."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"Peut contenir un objet lié quand ramassé. Un conteneur non ouvert peut encore être échangé ou vendu."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Retours et assistance"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
