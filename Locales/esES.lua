local strings = {}

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

strings["ADDON_TITLE"] = "Open Sesame"
strings["STATUS_ENABLED"] = "Activado"
strings["STATUS_DISABLED"] = "Desactivado"
strings["STATUS_PAUSED"] = "En pausa"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

strings["AUTO_LOOT_ENABLED"] = "Despojo automático es necesario para que Open Sesame funcione correctamente. Despojo automático ha sido activado."
strings["PAUSED_BAG_SLOTS"] = "En pausa hasta tener al menos %d espacios libres en las bolsas."
strings["RESUMED"] = "Reanudado."
strings["INVENTORY_FULL"] = "¡El inventario está lleno!"
strings["ITEM_WILL_AUTO_OPEN"] = "%s se abrirá automáticamente cuando se desbloquee."
strings["ITEM_OPEN_MANUALLY"] = "%s debe abrirse manualmente. Puede contener un objeto único, ligado al recoger o temporal, o fue obtenido de un jefe de banda."
strings["CHAT_LOADED"] = "Versión @project-version@. La configuración (incluida la opción para desactivar este mensaje) se puede encontrar en Opciones > AddOns > Open Sesame. ¿Te gusta el addon? ¡Cuéntaselo a un amigo! (="

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

strings["AUTO_OPENING"] = "Apertura automática"
strings["AUTO_OPENING_DESC"] = "Abre automáticamente almejas y contenedores desbloqueados cuando tienes más de 4 espacios libres en las bolsas."
strings["SPEEDY_LOOT"] = "Despojo rápido"
strings["SPEEDY_LOOT_DESC"] = "Oculta la ventana de botín para un despojo casi instantáneo."
strings["LOOT_SOUNDS"] = "Sonidos de botín"
strings["LOOT_SOUNDS_DESC"] = "Reproduce un sonido especial al obtener un objeto de calidad Poco común o superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

strings["KEYBIND_LEFT_CLICK"] = "Clic izquierdo"
strings["KEYBIND_RIGHT_CLICK"] = "Clic derecho"
strings["KEYBIND_MIDDLE_CLICK"] = "Clic central"
strings["ACTION_TOGGLE"] = "Alternar"
strings["TOOLTIP_HINT"] = "Más opciones en Opciones > AddOns > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

strings["OPTIONS_INTRO"] = "Abre automáticamente almejas y contenedores desbloqueados en tu inventario. Incluye Despojo rápido para obtener botín más rápidamente."
strings["OPTIONS_ENABLE_WELCOME"] = "Activar mensaje de bienvenida"
strings["OPTIONS_FEEDBACK"] = "Comentarios & Soporte"
strings["OPTIONS_CURSEFORGE"] = "CurseForge"
strings["OPTIONS_GITHUB"] = "GitHub"
strings["OPTIONS_DISCORD"] = "Discord"

--------------------------------------------------------------------------------
-- Registration (esES + esMX share the same table)
--------------------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "esES")
if L then
    for k, v in pairs(strings) do L[k] = v end
end

local L2 = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "esMX")
if L2 then
    for k, v in pairs(strings) do L2[k] = v end
end