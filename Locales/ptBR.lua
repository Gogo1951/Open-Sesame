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

L["AUTO_LOOT_ENABLED"]   = "Open Sesame requer o saque automatico. Ele foi ativado."
L["PAUSED_BAG_SLOTS"]    = "Pausado ate que voce tenha pelo menos %d espacos livres na bolsa."
L["RESUMED"]             = "Retomado."
L["INVENTORY_FULL"]      = "O inventario esta cheio!"
L["ITEM_WILL_AUTO_OPEN"] = "%s sera aberto automaticamente quando for desbloqueado."
L["ITEM_OPEN_MANUALLY"]  = "%s precisa ser aberto manualmente. Pode conter um item unico, vinculado ao coletar ou temporario, ou foi obtido de um chefe de raide."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Abertura automatica"
L["AUTO_OPENING_DESC"]   = "Abre automaticamente mariscos e recipientes desbloqueados quando voce tem mais de 4 espacos livres na bolsa."
L["SPEEDY_LOOT"]         = "Saque rapido"
L["SPEEDY_LOOT_DESC"]    = "Oculta a janela de saque para coletar itens quase instantaneamente."
L["LOOT_SOUNDS"]         = "Sons de saque"
L["LOOT_SOUNDS_DESC"]    = "Toca um som especial quando voce coleta um item de qualidade Incomum ou superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"]  = "Clique esquerdo"
L["KEYBIND_RIGHT_CLICK"] = "Clique direito"
L["KEYBIND_MIDDLE_CLICK"] = "Clique do meio"
L["ACTION_TOGGLE"]       = "Alternar"
L["TOOLTIP_HINT"]        = "Mais opcoes em Opcoes > AddOns > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"]       = "Abre automaticamente mariscos e recipientes desbloqueados no seu inventario. Inclui Saque rapido para coletar itens mais rapidamente."
L["OPTIONS_FEEDBACK"]    = "Feedback e suporte"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"
