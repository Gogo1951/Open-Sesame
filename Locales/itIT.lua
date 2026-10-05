local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "itIT")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Attivato"
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
L["CHAT_END_OF_SUPPORT"] =
	"Fine del supporto: questo add-on ora fa parte di GogoLoot e questa è la sua ultima versione. Installa GogoLoot per continuare a ricevere gli aggiornamenti, poi potrai disinstallare Open Sesame."

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "L'apertura automatica è in pausa finché non hai almeno %d spazi liberi nelle borse."
L["RESUMED"] = "L'apertura automatica è ripresa."
L["INVENTORY_FULL"] = "L'inventario è pieno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s si aprirà automaticamente non appena sarà sbloccato."
L["ITEM_IGNORED"] = "%s è nella tua lista ignorati, quindi l'apertura automatica non lo toccherà."
L["ITEM_OPEN_MANUALLY"] =
	"%s è nella tua lista ignorati, quindi il bottino rapido l'ha lasciato nella finestra del bottino."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Apertura automatica"
L["AUTO_OPENING_DESCRIPTION"] =
	"Apre automaticamente vongole e contenitori sbloccati quando hai almeno %d spazi liberi nelle borse."
L["SPEEDY_LOOT"] = "Bottino rapido"
L["SPEEDY_LOOT_DESCRIPTION"] = "Nasconde la finestra del bottino per raccogliere quasi istantaneamente."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Il bottino rapido nasconde la finestra del bottino, quindi questi suoni ti dicono cosa hai appena raccolto."
L["LOCKBOXES_DESCRIPTION"] =
	"I contenitori chiusi richiedono l'abilità Scassinare di un ladro prima di potersi aprire. Queste opzioni mostrano cosa richiede ogni scrigno e ti avvisano quando ce n'è uno in attesa."
L["LOOT_SOUNDS"] = "Suono del bottino"
L["LOOT_SOUNDS_DESCRIPTION"] =
	"Riproduce un suono quando raccogli un oggetto di qualità pari o superiore a quella che scegli."

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
	"Apre automaticamente vongole, contenitori e scrigni sbloccati nelle tue borse, senza alcun clic. Il bottino rapido nasconde la finestra del bottino per una raccolta automatica più veloce. Una raccolta rapida ed efficiente."
L["OPTIONS_ENABLE_WELCOME"] = "Attiva messaggio di benvenuto"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "Mostra la versione e un breve benvenuto in chat ogni volta che accedi."
L["OPTIONS_ENABLE_MINIMAP"] = "Attiva pulsante della mini-mappa"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Mostra il pulsante di Open Sesame sulla mini-mappa."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'Interfaccia Opzioni di questo add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Attiva apertura automatica"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Attiva o disattiva l'apertura automatica di vongole e contenitori sbloccati."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Dove"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] = "Scegli se i contenitori si aprono ovunque, o solo fuori dalle istanze."
L["OPTIONS_ANYWHERE"] = "Ovunque"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Fuori dalle istanze"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Gruppo"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"Scegli se i contenitori si aprono mentre sei in gruppo, o solo mentre giochi da solo."
L["OPTIONS_SOLO_OR_GROUPED"] = "Da solo o in gruppo"
L["OPTIONS_SOLO_ONLY"] = "Soltanto da solo"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Attiva bottino rapido"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"Raccoglie tutto in una volta e nasconde la finestra del bottino, che resta aperta solo per gli oggetti che non entrano nelle borse o che sono nella tua lista ignorati."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Attiva descrizioni degli scrigni"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] =
	"Aggiunge alla descrizione di ogni scrigno il livello di Scassinare che richiede."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"Scegli se le descrizioni degli scrigni appaiono solo per i ladri o per tutti i personaggi."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Attiva notifiche degli scrigni"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"Ti avvisa in chat quando raccogli uno scrigno che si aprirà non appena sarà sbloccato."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"Scegli se le notifiche degli scrigni appaiono solo per i ladri o per tutti i personaggi."
L["OPTIONS_SHOW_FOR"] = "Mostra per"
L["OPTIONS_FOR_ROGUES"] = "Per i ladri"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Per tutti i personaggi"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Attiva suono del bottino"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"Riproduce un rintocco quando raccogli da un cadavere o da un forziere un oggetto di qualità pari o superiore alla Qualità minima."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "La qualità di oggetto più bassa che riproduce il suono del bottino."
L["OPTIONS_TEST_LOOT_SOUND"] = "Riproduce il suono del bottino."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Attiva suono di Borseggiare"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"Riproduce un suono di borsa quando Borseggiare prende davvero qualcosa."
L["OPTIONS_MINIMUM_QUALITY"] = "Qualità minima"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Gli oggetti in questa lista vengono lasciati stare: il bottino rapido li lascia nella finestra del bottino e l'apertura automatica non li apre mai. La lista è condivisa da tutti i tuoi personaggi."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Attiva notifiche della lista ignorati"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Ti avvisa in chat quando Open Sesame lascia stare un oggetto perché è nella tua lista ignorati."
L["OPTIONS_IGNORE_LIST_ADD"] = "Aggiungi oggetto"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Trascina qui un oggetto, oppure incolla un collegamento o un ID oggetto."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Rimuove questo oggetto dalla lista ignorati."
L["OPTIONS_ITEM_LOADING"] = "Caricamento oggetto %d..."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Ripristina predefiniti"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Sostituisce la tua lista ignorati con quella predefinita, rimuovendo gli oggetti che hai aggiunto."
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
L["OPTIONS_VERSION"] = "Versione %s"
