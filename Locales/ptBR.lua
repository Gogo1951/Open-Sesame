local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "ptBR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Ativado"
L["STATUS_DISABLED"] = "Desativado"
L["STATUS_PAUSED"] = "Pausado"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "Notificações"
L["TAB_LOCKBOXES"] = "Cofres trancados"
L["TAB_IGNORE_LIST"] = "Lista de ignorados"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "O saque automático foi ativado. O Open Sesame precisa dele para funcionar."
L["CHAT_OPTIONS_IN_COMBAT"] = "Por precaução, a Interface de Opções não pode ser aberta durante o combate."
L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) estão em Opções > AddOns > Open Sesame. Gostou do add-on? Conte para um amigo! (="
L["CHAT_END_OF_SUPPORT"] =
	"Fim do suporte: este add-on agora faz parte do GogoLoot e esta é a sua última versão. Instale o GogoLoot para continuar recebendo atualizações e depois você pode desinstalar o Open Sesame."

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "A abertura automática está pausada até você ter pelo menos %d espaços livres nas bolsas."
L["RESUMED"] = "A abertura automática foi retomada."
L["INVENTORY_FULL"] = "O inventário está cheio!"
L["ITEM_WILL_AUTO_OPEN"] = "%s vai se abrir automaticamente assim que for destrancado."
L["ITEM_IGNORED"] = "%s está na sua lista de ignorados, então a abertura automática não vai mexer nele."
L["ITEM_OPEN_MANUALLY"] = "%s está na sua lista de ignorados, então o saque rápido o deixou na janela de saque."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Abertura automática"
L["AUTO_OPENING_DESCRIPTION"] =
	"Abre automaticamente mariscos e recipientes destrancados quando você tem pelo menos %d espaços livres nas bolsas."
L["SPEEDY_LOOT"] = "Saque rápido"
L["SPEEDY_LOOT_DESCRIPTION"] = "Oculta a janela de saque para coletar quase instantaneamente."
L["NOTIFICATIONS_DESCRIPTION"] =
	"O saque rápido oculta a janela de saque, então estes sons contam o que você acabou de pegar."
L["LOCKBOXES_DESCRIPTION"] =
	"Recipientes trancados precisam da perícia Arrombamento de um ladino para abrir. Estas opções mostram o que cada cofre exige e avisam quando há um esperando."
L["LOOT_SOUNDS"] = "Som de saque"
L["LOOT_SOUNDS_DESCRIPTION"] = "Toca um som quando você saqueia um item da qualidade que escolher ou superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clique esquerdo"
L["KEYBIND_RIGHT_CLICK"] = "Clique direito"
L["KEYBIND_MIDDLE_CLICK"] = "Clique do meio"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + Clique do meio"
L["ACTION_TOGGLE"] = "Alternar"
L["TOOLTIP_OPTIONS_TITLE"] = "Opções do Open Sesame"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "Requer Arrombamento"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "Seu Arrombamento"
L["TOOLTIP_LOCKED_ITEMS"] = "Itens trancados"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"Abre automaticamente mariscos, recipientes e cofres destrancados nas suas bolsas, sem precisar clicar. O saque rápido oculta a janela de saque para agilizar o saque automático. Coleta rápida e eficiente."
L["OPTIONS_ENABLE_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Mostra a versão e uma breve mensagem de boas-vindas no chat sempre que você entra no jogo."
L["OPTIONS_ENABLE_MINIMAP"] = "Ativar botão do minimapa"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Mostra o botão do Open Sesame no minimapa."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a Interface de Opções deste add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Ativar abertura automática"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Liga ou desliga a abertura automática de mariscos e recipientes destrancados."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Onde"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Escolha se os recipientes abrem em qualquer lugar ou só fora de instâncias."
L["OPTIONS_ANYWHERE"] = "Em qualquer lugar"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Fora de instâncias"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Grupo"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"Escolha se os recipientes abrem enquanto você está em grupo ou só quando joga sozinho."
L["OPTIONS_SOLO_OR_GROUPED"] = "Sozinho ou em grupo"
L["OPTIONS_SOLO_ONLY"] = "Somente sozinho"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Ativar saque rápido"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"Saqueia tudo de uma vez e oculta a janela de saque, que só fica aberta para itens que não cabem ou que estão na sua lista de ignorados."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Ativar dicas de cofres"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] =
	"Adiciona à dica de cada cofre a perícia em Arrombamento que ele exige."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"Escolha se as dicas de cofres aparecem só para ladinos ou para todos os personagens."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Ativar notificações de cofres"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"Avisa no chat quando você saqueia um cofre que vai abrir assim que for destrancado."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"Escolha se as notificações de cofres aparecem só para ladinos ou para todos os personagens."
L["OPTIONS_SHOW_FOR"] = "Mostrar para"
L["OPTIONS_FOR_ROGUES"] = "Para ladinos"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Para todos os personagens"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Ativar som de saque"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"Toca um sinal sonoro quando você saqueia de um cadáver ou baú um item com a Qualidade mínima ou superior."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "A qualidade de item mais baixa que toca o som de saque."
L["OPTIONS_TEST_LOOT_SOUND"] = "Toca o som de saque."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Ativar som de Furtar"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] = "Toca um som de bolsa quando Furtar realmente consegue algo."
L["OPTIONS_MINIMUM_QUALITY"] = "Qualidade mínima"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Os itens desta lista são deixados em paz: o saque rápido os deixa na janela de saque e a abertura automática nunca os abre. A lista é compartilhada por todos os seus personagens."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Ativar notificações da lista de ignorados"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Avisa no chat quando o Open Sesame deixa um item em paz porque ele está na sua lista de ignorados."
L["OPTIONS_IGNORE_LIST_ADD"] = "Adicionar item"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Arraste um item para cá, ou cole um link de item ou um ID de item."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Remove este item da lista de ignorados."
L["OPTIONS_ITEM_LOADING"] = "Carregando item %d..."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Restaurar padrões"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Substitui sua lista de ignorados pela padrão, removendo os itens que você adicionou."
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"Restaurar a lista de ignorados padrão? Os itens que você adicionou serão removidos."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Largado por um chefe de raide. Um recipiente fechado ainda pode ser negociado ou vendido, muitas vezes por mais do que o conteúdo."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"Pode conter um item de missão único. Abrir pode falhar com um erro se você já tiver um."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"Pode conter uma receita ligada ao coletar. Um recipiente fechado ainda pode ser negociado ou vendido."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"Pode conter uma arma ou peça de armadura ligada ao coletar. Um recipiente fechado ainda pode ser negociado ou vendido."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"Pode conter um item de evento ligado ao coletar. Um recipiente fechado ainda pode ser negociado ou vendido."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"Pode conter um item ligado ao coletar. Um recipiente fechado ainda pode ser negociado ou vendido."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versão %s"
