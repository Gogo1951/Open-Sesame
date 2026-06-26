local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "ptBR")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Ativado"
L["STATUS_DISABLED"] = "Desativado"
L["STATUS_PAUSED"] = "Pausado"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "O Saque Automático é necessário para que o Open Sesame funcione corretamente. O Saque Automático foi ativado."
L["CHAT_LOADED"] = "Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Open Sesame. Gostando do addon? Conte para um amigo! (="
L["MESSAGE_RESET"] = "Todas as configurações foram redefinidas para os valores padrão."

-- Auto-Open
L["PAUSED_BAG_SLOTS"] = "A abertura automática está pausada até que você tenha pelo menos %d espaços livres na bolsa."
L["RESUMED"] = "A abertura automática foi retomada."
L["INVENTORY_FULL"] = "O inventário está cheio!"
L["ITEM_WILL_AUTO_OPEN"] = "%s será aberto automaticamente quando for desbloqueado."
L["ITEM_OPEN_MANUALLY"] = "%s precisa ser aberto manualmente. Pode conter um item Único, Vinculado ao Coletar ou Temporário, ou foi deixado por um chefe de raide."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Abertura automática"
L["AUTO_OPENING_DESC"] = "Abre automaticamente mariscos e recipientes desbloqueados quando você tem pelo menos %d espaços livres na bolsa."
L["SPEEDY_LOOT"] = "Saque rápido"
L["SPEEDY_LOOT_DESC"] = "Oculta a janela de saque para coletar itens quase instantaneamente."
L["LOOT_SOUNDS"] = "Sons de saque"
L["LOOT_SOUNDS_DESC"] = "Toca um som especial quando você coleta um item de qualidade Incomum ou superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clique esquerdo"
L["KEYBIND_RIGHT_CLICK"] = "Clique direito"
L["KEYBIND_MIDDLE_CLICK"] = "Clique do meio"
L["ACTION_TOGGLE"] = "Alternar"
L["TOOLTIP_HINT"] = "Configurações adicionais podem ser encontradas em Opções > AddOns > Open Sesame."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "Abre automaticamente mariscos e recipientes desbloqueados no seu inventário. Possui Saque rápido para coletar itens mais rapidamente."
L["OPTIONS_ENABLE_WELCOME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_ENABLE_MINIMAP"] = "Ativar botão do minimapa"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Ativar notificações de caixas trancadas"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Ativar abertura automática"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Ativar saque rápido"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Ativar sons de saque"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Abre a interface de opções do Open Sesame."
L["OPTIONS_RESET"] = "Redefinir"
L["OPTIONS_RESET_DESC"] = "Restaura todas as configurações do Open Sesame para o valor padrão."
L["OPTIONS_RESET_BUTTON"] = "Redefinir todas as opções do Open Sesame"
L["OPTIONS_RESET_CONFIRM"] = "Redefinir todas as configurações do Open Sesame para os valores padrão?"
L["OPTIONS_FEEDBACK"] = "Feedback & Suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
