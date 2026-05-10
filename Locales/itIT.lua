local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "itIT")
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Ladri"
L["HERBALISTS"] = "Erbalisti"
L["MINERS"] = "Minatori"

L["ACTION_OPEN"] = "aprire"
L["ACTION_PICK"] = "raccogliere"
L["ACTION_MINE"] = "estrarre"

L["PREFIX_LOCKED"] = "un"
L["PREFIX_HERB"] = "un po' di"
L["PREFIX_MINE"] = "un"

L["MATCH_HERB"] = "Erbalismo"
L["MATCH_MINE"] = "Estrazione"

L["DEFAULT_TREASURE"] = "Forziere Chiuso"
L["DEFAULT_HERB"] = "Erba"
L["DEFAULT_MINE"] = "Filone di Minerali"

L["MSG_FORMAT"] = "{rt7} Come & Get It // Ehi %s, ho trovato %s %s che non posso %s alle %s, %s in %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOn > Come & Get It. Ti piace l'addon? Parlane con un amico! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Hai trovato un'erba che non puoi raccogliere, un filone di minerali che non puoi estrarre o un forziere chiuso senza nessun Ladro in vista? Fai clic col tasto destro su di esso e Come & Get It creerà un messaggio che puoi usare per condividere o trasmettere le coordinate. Essere un eroe non è mai stato così facile."

L["OPTIONS_WELCOME_NAME"] = "Abilita Messaggio di Benvenuto"
L["OPTIONS_WELCOME_DESC"] = "Stampa il messaggio di benvenuto nella chat al momento dell'accesso."

L["FEEDBACK_HEADER"] = "Feedback e Supporto"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"