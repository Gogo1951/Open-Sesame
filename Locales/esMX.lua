local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "esMX")
if not L then return end

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

L["AUTO_LOOT_ENABLED"] = "Despojo automático es necesario para que Open Sesame funcione correctamente. Despojo automático ha sido activado."
L["PAUSED_BAG_SLOTS"] = "La apertura automática está en pausa hasta tener al menos %d espacios libres en las bolsas."
L["RESUMED"] = "La apertura automática se ha reanudado."
L["INVENTORY_FULL"] = "¡El inventario está lleno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s se abrirá automáticamente cuando se desbloquee."
L["ITEM_OPEN_MANUALLY"] = "%s debe abrirse manualmente. Puede contener un objeto único, ligado al recoger o temporal, o fue obtenido de un jefe de banda."
L["CHAT_LOADED"] = "Versión %s. La configuración (incluida la opción para desactivar este mensaje) se puede encontrar en Opciones > AddOns > Open Sesame. ¿Te gusta el addon? ¡Cuéntaselo a un amigo! (="

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Apertura automática"
L["AUTO_OPENING_DESC"] = "Abre automáticamente almejas y contenedores desbloqueados cuando tienes al menos %d espacios libres en las bolsas."
L["SPEEDY_LOOT"] = "Despojo rápido"
L["SPEEDY_LOOT_DESC"] = "Oculta la ventana de botín para un despojo casi instantáneo."
L["LOOT_SOUNDS"] = "Sonidos de botín"
L["LOOT_SOUNDS_DESC"] = "Reproduce un sonido especial al obtener un objeto de calidad Poco común o superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clic izquierdo"
L["KEYBIND_RIGHT_CLICK"] = "Clic derecho"
L["KEYBIND_MIDDLE_CLICK"] = "Clic central"
L["ACTION_TOGGLE"] = "Alternar"
L["TOOLTIP_HINT"] = "La configuración adicional se puede encontrar en Opciones > AddOns > Open Sesame."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "Abre automáticamente almejas y contenedores desbloqueados en tu inventario. Cuenta con Despojo rápido para obtener botín más rápidamente."
L["OPTIONS_ENABLE_WELCOME"] = "Activar mensaje de bienvenida"
L["OPTIONS_ENABLE_MINIMAP"] = "Activar botón del minimapa"
L["OPTIONS_RESET"] = "Restablecer"
L["OPTIONS_RESET_DESC"] = "Restaura todos los ajustes de Open Sesame a sus valores predeterminados."
L["OPTIONS_RESET_BUTTON"] = "Restablecer todas las opciones de Open Sesame"
L["OPTIONS_RESET_CONFIRM"] = "¿Restablecer todos los ajustes de Open Sesame a sus valores predeterminados?"
L["OPTIONS_FEEDBACK"] = "Comentarios & Soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"