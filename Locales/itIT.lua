local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "itIT")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Attivo"
L["STATUS_DISABLED"] = "Disattivato"
L["STATUS_PAUSED"] = "In pausa"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "Notifiche"
L["TAB_LOCKBOXES"] = "Scrigni chiusi"
L["TAB_IGNORE_LIST"] = "Lista ignorati"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Il saccheggio automatico è stato attivato. Open Sesame ne ha bisogno per funzionare."
L["CHAT_OPTIONS_IN_COMBAT"] = "Per precauzione, l'Interfaccia Opzioni non può essere aperta durante il combattimento."
L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disattivare questo messaggio) si trovano in Opzioni > AddOns > Open Sesame. Ti piace l'add-on? Parlane a un amico! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "L'apertura automatica è in pausa finché non hai almeno %d spazi liberi nelle borse."
L["RESUMED"] = "L'apertura automatica è ripresa."
L["INVENTORY_FULL"] = "L'inventario è pieno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s verrà aperto automaticamente non appena sarà sbloccato."
L["ITEM_IGNORED"] = "%s è nella tua lista ignorati, quindi l'apertura automatica non lo ha toccato."
L["ITEM_OPEN_MANUALLY"] = "%s è stato lasciato nella finestra del bottino perché tu lo apra."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Apertura automatica"
L["AUTO_OPENING_DESCRIPTION"] =
	"Apre automaticamente vongole e contenitori sbloccati quando hai almeno %d spazi liberi nelle borse."
L["SPEEDY_LOOT"] = "Bottino rapido"
L["SPEEDY_LOOT_DESCRIPTION"] = "Nasconde la finestra del bottino per raccogliere quasi istantaneamente."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Il bottino rapido nasconde la finestra del bottino, quindi è così che Open Sesame ti dice cosa hai appena raccolto."
L["LOCKBOXES_DESCRIPTION"] =
	"I contenitori chiusi richiedono l'abilità Scassinare di un ladro prima di potersi aprire. Queste opzioni mostrano cosa richiede ogni scrigno e ti avvisano quando ce n'è uno in attesa."
L["LOOT_SOUNDS"] = "Suono del bottino"
L["LOOT_SOUNDS_DESCRIPTION"] = "Riproduce un suono in base alle impostazioni di qualità che scegli."
L["LOOT_TOASTS"] = "Avvisi del bottino"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Mostra un breve avviso a schermo per gli oggetti che raccogli, dato che il bottino rapido nasconde la finestra del bottino. Spostare il bottino fuori dalla chat lascia la finestra libera per le conversazioni e i messaggi che contano."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clic sinistro"
L["KEYBIND_RIGHT_CLICK"] = "Clic destro"
L["KEYBIND_MIDDLE_CLICK"] = "Clic centrale"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Maiusc + Clic centrale"
L["ACTION_TOGGLE"] = "Attiva o disattiva"
L["TOOLTIP_OPTIONS_TITLE"] = "Opzioni di Open Sesame"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "Richiede Scassinare"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "Il tuo Scassinare"
L["TOOLTIP_LOCKED_ITEMS"] = "Oggetti chiusi"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"Apre automaticamente vongole, scrigni chiusi e contenitori sbloccati nelle tue borse, senza alcun clic. Il Bottino rapido integrato nasconde la finestra del bottino per una raccolta automatica quasi istantanea. Meno clic, più gioco."
L["OPTIONS_ENABLE_WELCOME"] = "Attiva messaggio di benvenuto"
L["OPTIONS_ENABLE_MINIMAP"] = "Attiva pulsante della mini-mappa"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Attiva apertura automatica"
L["OPTIONS_AUTO_OPENING_WHERE"] = "Dove"
L["OPTIONS_ANYWHERE"] = "Ovunque"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Fuori dalle istanze"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Gruppo"
L["OPTIONS_SOLO_OR_GROUPED"] = "Da solo o in gruppo"
L["OPTIONS_SOLO_ONLY"] = "Solo da solo"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Attiva bottino rapido"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Attiva descrizioni degli scrigni"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Attiva notifiche degli scrigni"
L["OPTIONS_SHOW_FOR"] = "Mostra per"
L["OPTIONS_FOR_ROGUES"] = "Per i ladri"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Per tutti i personaggi"

-- Notifications
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Attiva suono del bottino"
L["OPTIONS_TEST_LOOT_SOUND"] = "Riproduci il suono del bottino."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Attiva suono di Borseggiare"
L["OPTIONS_MINIMUM_QUALITY"] = "Qualità minima"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Attiva avvisi del bottino"
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "Mostra sempre gli oggetti legati al raccoglimento"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "Mostra sempre gli oggetti delle missioni"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "Mostra sempre le ricette"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "Mostra sempre le cavalcature"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "Mostra sempre i famigli"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "Mostra sempre le chiavi"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "Mostra sempre le borse"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "Mostra sempre i contenitori"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "Mostra sempre il denaro"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Numero massimo di oggetti mostrati"
L["OPTIONS_UNLIMITED"] = "Illimitato"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Secondi a schermo"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Direzione di crescita"
L["OPTIONS_GROW_UP"] = "Verso l'alto"
L["OPTIONS_GROW_DOWN"] = "Verso il basso"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Allinea oggetti"
L["OPTIONS_ALIGN_LEFT"] = "Sinistra"
L["OPTIONS_ALIGN_RIGHT"] = "Destra"
L["OPTIONS_LOOT_TOAST_FONT"] = "Carattere"
L["OPTIONS_FONT_DEFAULT"] = "Predefinito"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Dimensione del carattere"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Contorno del carattere"
L["OPTIONS_FONT_OUTLINE_NONE"] = "Nessuno"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Contorno"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Contorno spesso"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Monocromatico"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Contorno monocromatico"
L["OPTIONS_TOASTS_UNLOCK"] = "Sblocca posizione"
L["OPTIONS_TOASTS_LOCK"] = "Blocca posizione"
L["OPTIONS_TOASTS_RESET"] = "Reimposta posizione"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Clic + Trascina per posizionare"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Clic destro per bloccare"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Disattiva avvisi del bottino"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Oggetto di esempio"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'Interfaccia Opzioni di questo add-on."

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Gli oggetti in questa lista vengono lasciati stare: il bottino rapido li lascia nella finestra del bottino e l'apertura automatica non li apre mai. La lista è condivisa da tutti i tuoi personaggi."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Attiva notifiche della lista ignorati"
L["OPTIONS_IGNORE_LIST_ADD"] = "Aggiungi oggetto"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Trascina qui un oggetto, oppure incolla un collegamento o un ID oggetto."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Rimuovi questo oggetto dalla lista ignorati."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Ripristina predefiniti"
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"Ripristinare la lista ignorati predefinita? Gli oggetti che hai aggiunto verranno rimossi."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Lasciato da un boss di incursione. Un contenitore non aperto può ancora essere scambiato o venduto, spesso per più di quanto contiene."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"Può contenere un oggetto di missione unico. Aprirlo può fallire con un errore se ne possiedi già uno."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"Può contenere una ricetta legata al raccoglimento. Un contenitore non aperto può ancora essere scambiato o venduto."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"Può contenere un'arma o un pezzo di armatura legato al raccoglimento. Un contenitore non aperto può ancora essere scambiato o venduto."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"Può contenere un oggetto festivo legato al raccoglimento. Un contenitore non aperto può ancora essere scambiato o venduto."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"Può contenere un oggetto legato al raccoglimento. Un contenitore non aperto può ancora essere scambiato o venduto."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
