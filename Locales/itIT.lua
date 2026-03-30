local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "itIT")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"]         = "Open Sesame"
L["STATUS_ENABLED"]      = "Attivo"
L["STATUS_DISABLED"]     = "Disattivato"
L["STATUS_PAUSED"]       = "In pausa"
L["STATUS_ON"]           = "On"
L["STATUS_OFF"]          = "Off"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"]   = "Open Sesame richiede il saccheggio automatico. E' stato attivato."
L["PAUSED_BAG_SLOTS"]    = "In pausa finche non avrai almeno %d spazi liberi nelle borse."
L["RESUMED"]             = "Ripreso."
L["INVENTORY_FULL"]      = "L'inventario e' pieno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s verra aperto automaticamente una volta sbloccato."
L["ITEM_OPEN_MANUALLY"]  = "%s deve essere aperto manualmente. Potrebbe contenere un oggetto unico, legato al raccoglimento o temporaneo, oppure e' stato ottenuto da un boss di raid."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Apertura automatica"
L["AUTO_OPENING_DESC"]   = "Apre automaticamente molluschi e contenitori sbloccati quando hai piu di 4 spazi liberi nelle borse."
L["SPEEDY_LOOT"]         = "Saccheggio rapido"
L["SPEEDY_LOOT_DESC"]    = "Nasconde la finestra del bottino per un saccheggio quasi istantaneo."
L["LOOT_SOUNDS"]         = "Suoni del bottino"
L["LOOT_SOUNDS_DESC"]    = "Riproduce un suono speciale quando saccheggi un oggetto di qualita Non comune o superiore."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"]  = "Clic sinistro"
L["KEYBIND_RIGHT_CLICK"] = "Clic destro"
L["KEYBIND_MIDDLE_CLICK"] = "Clic centrale"
L["ACTION_TOGGLE"]       = "Attiva/Disattiva"
L["TOOLTIP_HINT"]        = "Altre impostazioni in Opzioni > AddOn > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"]       = "Apre automaticamente molluschi e contenitori sbloccati nel tuo inventario. Include Saccheggio rapido per un saccheggio piu veloce."
L["OPTIONS_FEEDBACK"]    = "Feedback e supporto"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"
