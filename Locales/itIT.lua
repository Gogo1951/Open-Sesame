local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "itIT")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Attivato"
L["STATUS_DISABLED"] = "Disattivato"
L["STATUS_PAUSED"] = "In pausa"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Il Razziamento Automatico è necessario affinché Open Sesame funzioni correttamente. Il Razziamento Automatico è stato attivato."
L["CHAT_LOADED"] = "Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOn > Open Sesame. Ti piace l'addon? Parlane con un amico! (="
L["MESSAGE_RESET"] = "Tutte le impostazioni sono state ripristinate ai valori predefiniti."

-- Auto-Open
L["PAUSED_BAG_SLOTS"] = "L'apertura automatica è in pausa finché non avrai almeno %d spazi liberi nelle borse."
L["RESUMED"] = "L'apertura automatica è ripresa."
L["INVENTORY_FULL"] = "L'inventario è pieno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s verrà aperto automaticamente una volta sbloccato."
L["ITEM_OPEN_MANUALLY"] = "%s deve essere aperto manualmente. Potrebbe contenere un oggetto unico, vincolato alla raccolta o temporaneo, oppure è stato rilasciato da un boss di incursione."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Apertura automatica"
L["AUTO_OPENING_DESC"] = "Apre automaticamente molluschi e contenitori sbloccati quando hai almeno %d spazi liberi nelle borse."
L["SPEEDY_LOOT"] = "Razziamento rapido"
L["SPEEDY_LOOT_DESC"] = "Nasconde la finestra del bottino per un razziamento quasi istantaneo."
L["LOOT_SOUNDS"] = "Suoni del bottino"
L["LOOT_SOUNDS_DESC"] = "Riproduce un suono speciale quando raccogli un oggetto di qualità Non Comune o superiore."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clic sinistro"
L["KEYBIND_RIGHT_CLICK"] = "Clic destro"
L["KEYBIND_MIDDLE_CLICK"] = "Clic centrale"
L["ACTION_TOGGLE"] = "Attiva/Disattiva"
L["TOOLTIP_HINT"] = "Impostazioni aggiuntive si trovano in Opzioni > AddOn > Open Sesame."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "Apre automaticamente molluschi e contenitori sbloccati nel tuo inventario. Offre Razziamento rapido per una raccolta più veloce."
L["OPTIONS_ENABLE_WELCOME"] = "Abilita il messaggio di benvenuto"
L["OPTIONS_ENABLE_MINIMAP"] = "Abilita pulsante minimappa"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Abilita le notifiche delle cassette di sicurezza"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Abilita apertura automatica"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Abilita razziamento rapido"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Abilita suoni del bottino"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di Open Sesame."
L["OPTIONS_RESET"] = "Reimposta"
L["OPTIONS_RESET_DESC"] = "Riporta ogni impostazione di Open Sesame al suo valore predefinito."
L["OPTIONS_RESET_BUTTON"] = "Reimposta tutte le opzioni di Open Sesame"
L["OPTIONS_RESET_CONFIRM"] = "Reimpostare tutte le impostazioni di Open Sesame ai valori predefiniti?"
L["OPTIONS_FEEDBACK"] = "Feedback & Supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
