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

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "A abertura automática está pausada até você ter pelo menos %d espaços livres nas bolsas."
L["RESUMED"] = "A abertura automática foi retomada."
L["INVENTORY_FULL"] = "O inventário está cheio!"
L["ITEM_WILL_AUTO_OPEN"] = "%s vai se abrir automaticamente assim que for destrancado."
L["ITEM_IGNORED"] = "%s está na sua lista de ignorados, então a abertura automática não vai mexer nele."
L["ITEM_OPEN_MANUALLY"] = "%s foi deixado na janela de saque para que você mesmo o saqueie."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Abertura automática"
L["AUTO_OPENING_DESCRIPTION"] =
	"Abre automaticamente mariscos e recipientes destrancados quando você tem pelo menos %d espaços livres nas bolsas."
L["SPEEDY_LOOT"] = "Saque rápido"
L["SPEEDY_LOOT_DESCRIPTION"] = "Oculta a janela de saque para coletar quase instantaneamente."
L["NOTIFICATIONS_DESCRIPTION"] =
	"O saque rápido oculta a janela de saque, então estes sons e avisos contam o que você acabou de pegar."
L["LOCKBOXES_DESCRIPTION"] =
	"Recipientes trancados precisam da perícia Arrombamento de um ladino para abrir. Estas opções mostram o que cada cofre exige e avisam quando há um esperando."
L["LOOT_SOUNDS"] = "Som de saque"
L["LOOT_SOUNDS_DESCRIPTION"] = "Toca um som quando você saqueia um item da qualidade que escolher ou superior."
L["LOOT_TOASTS"] = "Avisos de saque"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Mostra um aviso rápido na tela para os itens que você saqueia, já que o saque rápido oculta a janela de saque. Com os avisos ativados, você pode desativar as mensagens de saque nas configurações do chat e deixar o chat livre para conversas e para as mensagens que importam."

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
	"Abre automaticamente mariscos, recipientes e cofres destrancados nas suas bolsas, sem precisar clicar. O saque rápido oculta a janela de saque para agilizar o saque automático, e os avisos de saque mostram cada item coletado para que seus olhos fiquem na luta. Coleta rápida e eficiente."
L["OPTIONS_ENABLE_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Mostra a versão e uma breve mensagem de boas-vindas no chat sempre que você entra no jogo."
L["OPTIONS_ENABLE_MINIMAP"] = "Ativar botão do minimapa"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Mostra o botão do Open Sesame no minimapa."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a Interface de Opções deste add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Ativar abertura automática"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Liga ou desliga a abertura automática de mariscos e recipientes destrancados."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Onde"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Escolha se os recipientes abrem em qualquer lugar ou esperam você sair de masmorras e raides."
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
L["OPTIONS_TEST_LOOT_SOUND"] = "Tocar o som de saque."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Ativar som de Furtar"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] = "Toca um som de bolsa quando Furtar realmente consegue algo."
L["OPTIONS_MINIMUM_QUALITY"] = "Qualidade mínima"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Ativar avisos de saque"
L["OPTIONS_ENABLE_LOOT_TOASTS_DESCRIPTION"] =
	"Mostra um aviso rápido na tela para os itens e as moedas que você saqueia."
L["OPTIONS_LOOT_TOAST_QUALITY_DESCRIPTION"] =
	"A qualidade de item mais baixa que recebe um aviso, a menos que uma opção Sempre mostrar abaixo cubra o item."
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "Sempre mostrar itens ligados ao coletar"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "Sempre mostrar itens de missão"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "Sempre mostrar receitas"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "Sempre mostrar montarias"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "Sempre mostrar mascotes"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "Sempre mostrar chaves"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "Sempre mostrar bolsas"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "Sempre mostrar recipientes"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "Sempre mostrar dinheiro"
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP_DESCRIPTION"] = "Mostra todo item ligado ao coletar, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS_DESCRIPTION"] =
	"Mostra itens de missão e itens que iniciam uma missão, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_RECIPES_DESCRIPTION"] =
	"Mostra receitas, moldes, projetos e fórmulas, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_MOUNTS_DESCRIPTION"] = "Mostra montarias, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_PETS_DESCRIPTION"] = "Mostra mascotes, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_KEYS_DESCRIPTION"] = "Mostra chaves, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_BAGS_DESCRIPTION"] =
	"Mostra bolsas, aljavas e algibeiras de munição, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_CONTAINERS_DESCRIPTION"] =
	"Mostra recipientes que o Open Sesame pode abrir, incluindo cofres trancados, seja qual for a qualidade."
L["OPTIONS_ALWAYS_SHOW_MONEY_DESCRIPTION"] = "Mostra um aviso para as moedas que você saqueia."
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Máximo de itens exibidos"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS_DESCRIPTION"] =
	"O máximo de avisos na tela ao mesmo tempo; o mais antigo sai para dar lugar."
L["OPTIONS_UNLIMITED"] = "Ilimitado"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Segundos na tela"
L["OPTIONS_LOOT_TOAST_DURATION_DESCRIPTION"] = "Quantos segundos cada aviso fica na tela antes de sumir."
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Direção de crescimento"
L["OPTIONS_LOOT_TOAST_GROWTH_DESCRIPTION"] = "Se os avisos mais antigos sobem ou descem, afastando-se do mais recente."
L["OPTIONS_GROW_UP"] = "Para cima"
L["OPTIONS_GROW_DOWN"] = "Para baixo"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Alinhar itens"
L["OPTIONS_LOOT_TOAST_ALIGN_DESCRIPTION"] = "Em que lado da alça os avisos se alinham."
L["OPTIONS_ALIGN_LEFT"] = "Esquerda"
L["OPTIONS_ALIGN_RIGHT"] = "Direita"
L["OPTIONS_LOOT_TOAST_FONT"] = "Fonte"
L["OPTIONS_LOOT_TOAST_FONT_DESCRIPTION"] = "A fonte usada nos avisos."
L["OPTIONS_FONT_DEFAULT"] = "Padrão"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Tamanho da fonte"
L["OPTIONS_LOOT_TOAST_FONT_SIZE_DESCRIPTION"] = "O tamanho do texto dos avisos; os ícones crescem e diminuem junto."
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Contorno da fonte"
L["OPTIONS_LOOT_TOAST_OUTLINE_DESCRIPTION"] =
	"O contorno desenhado em volta do texto dos avisos, que o mantém legível sobre cenários claros."
L["OPTIONS_FONT_OUTLINE_NONE"] = "Nenhum"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Contorno"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Contorno grosso"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Monocromático"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Contorno monocromático"
L["OPTIONS_TOASTS_UNLOCK"] = "Desbloquear posição"
L["OPTIONS_TOASTS_LOCK"] = "Bloquear posição"
L["OPTIONS_TOASTS_RESET"] = "Redefinir posição"
L["OPTIONS_TOASTS_LOCK_DESCRIPTION"] = "Mostra ou oculta a alça para arrastar os avisos para outro lugar."
L["OPTIONS_TOASTS_RESET_DESCRIPTION"] = "Leva os avisos de volta à posição padrão, acima do centro da tela."
L["OPTIONS_TOASTS_HANDLE_TITLE"] = "Avisos de saque do Open Sesame"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Clique + Arraste para posicionar"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Clique direito para bloquear"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Desativar avisos de saque"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Item de exemplo"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Os itens desta lista são deixados em paz: o saque rápido os deixa na janela de saque e a abertura automática nunca os abre. A lista é compartilhada por todos os seus personagens."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Ativar notificações da lista de ignorados"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Avisa no chat quando o Open Sesame deixa um item em paz porque ele está na sua lista de ignorados."
L["OPTIONS_IGNORE_LIST_ADD"] = "Adicionar item"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Arraste um item para cá, ou cole um link de item ou um ID de item."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Remover este item da lista de ignorados."
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
