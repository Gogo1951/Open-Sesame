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
L["CHAT_END_OF_SUPPORT"] =
	"Fin du support : cet add-on fait désormais partie de GogoLoot et il s'agit de sa dernière version. Installez GogoLoot pour continuer à recevoir les mises à jour, puis vous pourrez désinstaller Open Sesame."

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] =
	"L'ouverture automatique est en pause tant que vous n'avez pas au moins %d emplacements de sac libres."
L["RESUMED"] = "L'ouverture automatique a repris."
L["INVENTORY_FULL"] = "L'inventaire est plein !"
L["ITEM_WILL_AUTO_OPEN"] = "%s s'ouvrira automatiquement dès qu'il sera déverrouillé."
L["ITEM_IGNORED"] = "%s est dans votre liste d'exclusion, l'ouverture automatique le laissera donc tranquille."
L["ITEM_OPEN_MANUALLY"] =
	"%s est dans votre liste d'exclusion, le butin rapide l'a donc laissé dans la fenêtre de butin."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Ouverture automatique"
L["AUTO_OPENING_DESCRIPTION"] =
	"Ouvre automatiquement les palourdes et les conteneurs déverrouillés quand vous avez au moins %d emplacements de sac libres."
L["SPEEDY_LOOT"] = "Butin rapide"
L["SPEEDY_LOOT_DESCRIPTION"] = "Masque la fenêtre de butin pour un ramassage quasi instantané."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Le butin rapide masque la fenêtre de butin, ces sons vous indiquent donc ce que vous venez de ramasser."
L["LOCKBOXES_DESCRIPTION"] =
	"Les conteneurs verrouillés nécessitent la compétence Crochetage d'un voleur avant de s'ouvrir. Ces options indiquent ce que chaque coffre exige et vous préviennent quand l'un d'eux attend."
L["LOOT_SOUNDS"] = "Son de butin"
L["LOOT_SOUNDS_DESCRIPTION"] =
	"Joue un son quand vous ramassez un objet d'une qualité égale ou supérieure à celle que vous choisissez."

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
	"Ouvre automatiquement les palourdes, les conteneurs et les coffres déverrouillés de vos sacs, sans aucun clic. Le butin rapide masque la fenêtre de butin pour accélérer le ramassage automatique. Un ramassage rapide et efficace."
L["OPTIONS_ENABLE_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Affiche la version et un court message de bienvenue dans le chat à chaque connexion."
L["OPTIONS_ENABLE_MINIMAP"] = "Activer le bouton de la mini-carte"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Affiche le bouton d'Open Sesame sur la mini-carte."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre l'Interface d'Options de cet add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Activer l'ouverture automatique"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Active ou désactive l'ouverture automatique des palourdes et des conteneurs déverrouillés."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Où"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Choisissez si les conteneurs s'ouvrent partout, ou seulement hors des instances."
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
L["OPTIONS_TEST_LOOT_SOUND"] = "Joue le son de butin."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Activer le son de Vol à la tire"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"Joue un bruit de sac quand Vol à la tire rapporte réellement quelque chose."
L["OPTIONS_MINIMUM_QUALITY"] = "Qualité minimale"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Les objets de cette liste sont laissés tranquilles : le butin rapide les laisse dans la fenêtre de butin et l'ouverture automatique ne les ouvre jamais. La liste est partagée par tous vos personnages."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Activer les notifications de la liste d'exclusion"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Vous prévient dans le chat quand Open Sesame laisse un objet tranquille parce qu'il est dans votre liste d'exclusion."
L["OPTIONS_IGNORE_LIST_ADD"] = "Ajouter un objet"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Glissez un objet ici, ou collez un lien d'objet ou un ID d'objet."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Retire cet objet de la liste d'exclusion."
L["OPTIONS_ITEM_LOADING"] = "Chargement de l'objet %d..."
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
L["OPTIONS_VERSION"] = "Version %s"
