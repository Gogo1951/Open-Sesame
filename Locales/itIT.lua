local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "itIT")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"]         = "Open Sesame"
L["STATUS_ENABLED"]      = "Attivato"
L["STATUS_DISABLED"]     = "Disattivato"
L["STATUS_PAUSED"]       = "In pausa"
L["STATUS_ON"]           = "On"
L["STATUS_OFF"]          = "Off"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"]   = "Il Razziamento Automatico è necessario affinché Open Sesame funzioni correttamente. Il Razziamento Automatico è stato attivato."
L["PAUSED_BAG_SLOTS"]    = "In pausa finché non avrai almeno %d spazi liberi nelle borse."
L["RESUMED"]             = "Ripreso."
L["INVENTORY_FULL"]      = "L'inventario è pieno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s verrà aperto automaticamente una volta sbloccato."
L["ITEM_OPEN_MANUALLY"]  = "%s deve essere aperto manualmente. Potrebbe contenere un oggetto unico, vincolato alla raccolta o temporaneo, oppure è stato rilasciato da un boss di incursione."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Apertura automatica"
L["AUTO_OPENING_DESC"]   = "Apre automaticamente molluschi e contenitori sbloccati quando hai più di 4 spazi liberi nelle borse."
L["SPEEDY_LOOT"]         = "Razziamento rapido"
L["SPEEDY_LOOT_DESC"]    = "Nasconde la finestra del bottino per un razziamento quasi istantaneo."
L["LOOT_SOUNDS"]         = "Suoni del bottino"
L["LOOT_SOUNDS_DESC"]    = "Riproduce un suono speciale quando raccogli un oggetto di qualità Non Comune o superiore."

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

L["OPTIONS_INTRO"]       = "Apre automaticamente molluschi e contenitori sbloccati nel tuo inventario. Include Razziamento rapido per una raccolta più veloce."
L["OPTIONS_FEEDBACK"]    = "Feedback & Supporto"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"