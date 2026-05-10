local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "ptBR")
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Ladinos"
L["HERBALISTS"] = "Herboristas"
L["MINERS"] = "Mineiros"

L["ACTION_OPEN"] = "abrir"
L["ACTION_PICK"] = "coletar"
L["ACTION_MINE"] = "minerar"

L["PREFIX_LOCKED"] = "um"
L["PREFIX_HERB"] = "alguma"
L["PREFIX_MINE"] = "um"

L["MATCH_HERB"] = "Herborismo"
L["MATCH_MINE"] = "Mineração"

L["DEFAULT_TREASURE"] = "Baú Trancado"
L["DEFAULT_HERB"] = "Erva"
L["DEFAULT_MINE"] = "Veio de Minério"

L["MSG_FORMAT"] = "{rt7} Come & Get It // Ei %s, encontrei %s %s que não consigo %s em %s, %s em %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Come & Get It. Gostando do addon? Conte para um amigo! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Encontrou uma erva que você não pode coletar, um veio de minério que você não pode minerar ou um baú de tesouro trancado sem nenhum Ladino à vista? Clique com o botão direito nele e o Come & Get It criará uma mensagem que você pode usar para compartilhar ou transmitir as coordenadas. Ser um herói nunca foi tão fácil."

L["OPTIONS_WELCOME_NAME"] = "Ativar Mensagem de Boas-vindas"
L["OPTIONS_WELCOME_DESC"] = "Mostra a mensagem de boas-vindas no chat ao entrar no jogo."

L["FEEDBACK_HEADER"] = "Feedback e Suporte"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"