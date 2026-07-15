local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "esMX")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Activado"
L["STATUS_DISABLED"] = "Desactivado"
L["STATUS_PAUSED"] = "En pausa"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "El Despojo automático ha sido activado. Open Sesame lo necesita para funcionar."
L["CHAT_LOADED"] =
	"Versión %s. La configuración (incluida la opción para desactivar este mensaje) se puede encontrar en Opciones > AddOns > Open Sesame. ¿Te gusta el addon? ¡Cuéntaselo a un amigo! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "La apertura automática está en pausa hasta tener al menos %d espacios libres en las bolsas."
L["RESUMED"] = "La apertura automática se ha reanudado."
L["INVENTORY_FULL"] = "¡El inventario está lleno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s se abrirá automáticamente cuando se desbloquee."
L["ITEM_OPEN_MANUALLY"] =
	"%s debe abrirse manualmente. Puede contener un objeto único, ligado al recoger o temporal, o fue obtenido de un jefe de banda."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Apertura automática"
L["AUTO_OPENING_DESC"] =
	"Abre automáticamente almejas y contenedores desbloqueados cuando tienes al menos %d espacios libres en las bolsas."
L["SPEEDY_LOOT"] = "Despojo rápido"
L["SPEEDY_LOOT_DESC"] = "Oculta la ventana de botín para un despojo casi instantáneo."
L["LOOT_SOUNDS"] = "Sonido de botín"
L["LOOT_SOUNDS_DESC"] = "Reproduce un sonido especial al obtener un objeto de calidad Poco común o superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clic izquierdo"
L["KEYBIND_RIGHT_CLICK"] = "Clic derecho"
L["KEYBIND_MIDDLE_CLICK"] = "Clic central"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + Clic central"
L["ACTION_TOGGLE"] = "Alternar"
L["TOOLTIP_OPTIONS_TITLE"] = "Opciones de Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"Open Sesame abre automáticamente almejas, cajas con cerradura y contenedores desbloqueados en tus bolsas. El Despojo rápido integrado oculta la ventana de botín para un despojo casi instantáneo. Menos clics, más tiempo de juego."
L["OPTIONS_ENABLE_WELCOME"] = "Activar mensaje de bienvenida"
L["OPTIONS_ENABLE_MINIMAP"] = "Activar botón del minimapa"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Activar notificaciones de cajas con cerradura"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Activar apertura automática"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Activar despojo rápido"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Activar sonido de botín"
L["OPTIONS_LOOT_SOUND_THRESHOLD"] = "Calidad mínima para el sonido de botín"
L["OPTIONS_TEST_LOOT_SOUND"] = "Reproducir el sonido de botín."
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Abre la interfaz de opciones de Open Sesame."
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
