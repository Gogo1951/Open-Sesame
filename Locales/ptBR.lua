local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "ptBR")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"]         = "Open Sesame"
L["STATUS_ENABLED"]      = "Ativado"
L["STATUS_DISABLED"]     = "Desativado"
L["STATUS_PAUSED"]       = "Pausado"
L["STATUS_ON"]           = "On"
L["STATUS_OFF"]          = "Off"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"]   = "O Saque Automático é necessário para que o Open Sesame funcione corretamente. O Saque Automático foi ativado."
L["PAUSED_BAG_SLOTS"]    = "Pausado até que você tenha pelo menos %d espaços livres na bolsa."
L["RESUMED"]             = "Retomado."
L["INVENTORY_FULL"]      = "O inventário está cheio!"
L["ITEM_WILL_AUTO_OPEN"] = "%s será aberto automaticamente quando for desbloqueado."
L["ITEM_OPEN_MANUALLY"]  = "%s precisa ser aberto manualmente. Pode conter um item Único, Vinculado ao Coletar ou Temporário, ou foi deixado por um chefe de raide."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Abertura automática"
L["AUTO_OPENING_DESC"]   = "Abre automaticamente mariscos e recipientes desbloqueados quando você tem mais de 4 espaços livres na bolsa."
L["SPEEDY_LOOT"]         = "Saque rápido"
L["SPEEDY_LOOT_DESC"]    = "Oculta a janela de saque para coletar itens quase instantaneamente."
L["LOOT_SOUNDS"]         = "Sons de saque"
L["LOOT_SOUNDS_DESC"]    = "Toca um som especial quando você coleta um item de qualidade Incomum ou superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"]  = "Clique esquerdo"
L["KEYBIND_RIGHT_CLICK"] = "Clique direito"
L["KEYBIND_MIDDLE_CLICK"] = "Clique do meio"
L["ACTION_TOGGLE"]       = "Alternar"
L["TOOLTIP_HINT"]        = "Mais opções em Opções > AddOns > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"]       = "Abre automaticamente mariscos e recipientes desbloqueados no seu inventário. Inclui Saque rápido para coletar itens mais rapidamente."
L["OPTIONS_FEEDBACK"]    = "Feedback & Suporte"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"