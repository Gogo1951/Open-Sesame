local strings = {}

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

strings["ROGUES"] = "Pícaros"
strings["HERBALISTS"] = "Herboristas"
strings["MINERS"] = "Mineros"

strings["ACTION_OPEN"] = "abrir"
strings["ACTION_PICK"] = "recolectar"
strings["ACTION_MINE"] = "minar"

strings["PREFIX_LOCKED"] = "un"
strings["PREFIX_HERB"] = "algunas"
strings["PREFIX_MINE"] = "una"

strings["MATCH_HERB"] = "Herboristería"
strings["MATCH_MINE"] = "Minería"

strings["DEFAULT_TREASURE"] = "Cofre cerrado"
strings["DEFAULT_HERB"] = "Hierba"
strings["DEFAULT_MINE"] = "Veta de mineral"

strings["MSG_FORMAT"] = "{rt7} Come & Get It // ¡Oye %s, encontré %s %s que no puedo %s en %s, %s en %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

strings["CHAT_LOADED"] = "Versión %s. Los ajustes (incluida la opción para desactivar este mensaje) se encuentran en Opciones > AddOns > Come & Get It. ¿Te gusta el addon? ¡Cuéntaselo a un amigo! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

strings["OPTIONS_DESCRIPTION"] = "¿Encontraste una hierba que no puedes recolectar, una veta de mineral que no puedes minar o un cofre cerrado sin un Pícaro a la vista? Haz clic derecho y Come & Get It creará un mensaje que puedes usar para compartir o anunciar las coordenadas. Ser un héroe nunca fue tan fácil."

strings["OPTIONS_WELCOME_NAME"] = "Activar mensaje de bienvenida"
strings["OPTIONS_WELCOME_DESC"] = "Mostrar el mensaje de bienvenida en el chat al iniciar sesión."

strings["FEEDBACK_HEADER"] = "Comentarios y soporte"
strings["FEEDBACK_CURSEFORGE"] = "CurseForge"
strings["FEEDBACK_GITHUB"] = "GitHub"
strings["FEEDBACK_DISCORD"] = "Discord"

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esES")
if L then
    for k, v in pairs(strings) do L[k] = v end
end

local L2 = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esMX")
if L2 then
    for k, v in pairs(strings) do L2[k] = v end
end
