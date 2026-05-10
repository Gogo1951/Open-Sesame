local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "frFR")
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Voleurs"
L["HERBALISTS"] = "Herboristes"
L["MINERS"] = "Mineurs"

L["ACTION_OPEN"] = "ouvrir"
L["ACTION_PICK"] = "cueillir"
L["ACTION_MINE"] = "miner"

L["PREFIX_LOCKED"] = "un"
L["PREFIX_HERB"] = "quelques"
L["PREFIX_MINE"] = "un"

L["MATCH_HERB"] = "Herboristerie"
L["MATCH_MINE"] = "Minage"

L["DEFAULT_TREASURE"] = "Coffre verrouillé"
L["DEFAULT_HERB"] = "Herbe"
L["DEFAULT_MINE"] = "Filon de minerai"

L["MSG_FORMAT"] = "{rt7} Come & Get It // Hé %s, j'ai trouvé %s %s que je ne peux pas %s à %s, %s dans %s !"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent sous Options > AddOns > Come & Get It. Vous aimez l'addon ? Parlez-en à un ami ! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Vous avez trouvé une herbe que vous ne pouvez pas cueillir, un filon de minerai que vous ne pouvez pas miner ou un coffre au trésor verrouillé sans aucun voleur en vue ? Faites un clic droit dessus, et Come & Get It créera un message que vous pourrez utiliser pour partager ou diffuser les coordonnées. Être un héros n'a jamais été aussi facile."

L["OPTIONS_WELCOME_NAME"] = "Activer le message de bienvenue"
L["OPTIONS_WELCOME_DESC"] = "Affiche le message de bienvenue dans le chat lors de la connexion."

L["FEEDBACK_HEADER"] = "Commentaires et Assistance"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"