local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "esES")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"]         = "Open Sesame"
L["STATUS_ENABLED"]      = "Activado"
L["STATUS_DISABLED"]     = "Desactivado"
L["STATUS_PAUSED"]       = "En pausa"
L["STATUS_ON"]           = "On"
L["STATUS_OFF"]          = "Off"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"]   = "Despojo automático es necesario para que Open Sesame funcione correctamente. Despojo automático ha sido activado."
L["PAUSED_BAG_SLOTS"]    = "En pausa hasta tener al menos %d espacios libres en las bolsas."
L["RESUMED"]             = "Reanudado."
L["INVENTORY_FULL"]      = "¡El inventario está lleno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s se abrirá automáticamente cuando se desbloquee."
L["ITEM_OPEN_MANUALLY"]  = "%s debe abrirse manualmente. Puede contener un objeto único, ligado al recoger o temporal, o fue obtenido de un jefe de banda."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Apertura automática"
L["AUTO_OPENING_DESC"]   = "Abre automáticamente almejas y contenedores desbloqueados cuando tienes más de 4 espacios libres en las bolsas."
L["SPEEDY_LOOT"]         = "Despojo rápido"
L["SPEEDY_LOOT_DESC"]    = "Oculta la ventana de botín para un despojo casi instantáneo."
L["LOOT_SOUNDS"]         = "Sonidos de botín"
L["LOOT_SOUNDS_DESC"]    = "Reproduce un sonido especial al obtener un objeto de calidad Poco común o superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"]  = "Clic izquierdo"
L["KEYBIND_RIGHT_CLICK"] = "Clic derecho"
L["KEYBIND_MIDDLE_CLICK"] = "Clic central"
L["ACTION_TOGGLE"]       = "Alternar"
L["TOOLTIP_HINT"]        = "Más opciones en Opciones > AddOns > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"]       = "Abre automáticamente almejas y contenedores desbloqueados en tu inventario. Incluye Despojo rápido para obtener botín más rápidamente."
L["OPTIONS_FEEDBACK"]    = "Comentarios & Soporte"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"

--------------------------------------------------------------------------------
-- esMX (Latin American Spanish) shares all strings with esES
--------------------------------------------------------------------------------

local L2 = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "esMX")
if not L2 then return end
for k, v in pairs(L) do L2[k] = v end