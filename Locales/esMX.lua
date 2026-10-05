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
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "Notificaciones"
L["TAB_LOCKBOXES"] = "Cajas cerradas"
L["TAB_IGNORE_LIST"] = "Lista de ignorados"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Se ha activado el saqueo automático. Open Sesame lo necesita para funcionar."
L["CHAT_OPTIONS_IN_COMBAT"] = "Por precaución, la Interfaz de Opciones no puede abrirse durante el combate."
L["CHAT_LOADED"] =
	"Versión %s. La configuración (incluida la opción de desactivar este mensaje) está en Opciones > AddOns > Open Sesame. ¿Te gusta el add-on? ¡Cuéntaselo a un amigo! (="
L["CHAT_END_OF_SUPPORT"] =
	"Fin del soporte: este add-on ahora forma parte de GogoLoot y esta es su última versión. Instala GogoLoot para seguir recibiendo actualizaciones y luego podrás desinstalar Open Sesame."

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] =
	"La apertura automática está en pausa hasta que tengas al menos %d espacios libres en la bolsa."
L["RESUMED"] = "La apertura automática se ha reanudado."
L["INVENTORY_FULL"] = "¡El inventario está lleno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s se abrirá automáticamente en cuanto esté desbloqueado."
L["ITEM_IGNORED"] = "%s está en tu lista de ignorados, así que la apertura automática no lo tocará."
L["ITEM_OPEN_MANUALLY"] =
	"%s está en tu lista de ignorados, así que el saqueo rápido lo dejó en la ventana de botín."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Apertura automática"
L["AUTO_OPENING_DESCRIPTION"] =
	"Abre automáticamente almejas y contenedores desbloqueados cuando tienes al menos %d espacios libres en la bolsa."
L["SPEEDY_LOOT"] = "Saqueo rápido"
L["SPEEDY_LOOT_DESCRIPTION"] = "Oculta la ventana de botín para saquear casi al instante."
L["NOTIFICATIONS_DESCRIPTION"] =
	"El saqueo rápido oculta la ventana de botín, así que estos sonidos te dicen lo que acabas de recoger."
L["LOCKBOXES_DESCRIPTION"] =
	"Los contenedores cerrados necesitan la habilidad Abrir cerraduras de un pícaro para poder abrirse. Estas opciones muestran lo que requiere cada caja y te avisan cuando hay una esperando."
L["LOOT_SOUNDS"] = "Sonido de botín"
L["LOOT_SOUNDS_DESCRIPTION"] = "Reproduce un sonido cuando saqueas un objeto de la calidad que elijas o superior."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Clic izquierdo"
L["KEYBIND_RIGHT_CLICK"] = "Clic derecho"
L["KEYBIND_MIDDLE_CLICK"] = "Clic central"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Mayús + Clic central"
L["ACTION_TOGGLE"] = "Alternar"
L["TOOLTIP_OPTIONS_TITLE"] = "Opciones de Open Sesame"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "Requiere Abrir cerraduras"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "Tu Abrir cerraduras"
L["TOOLTIP_LOCKED_ITEMS"] = "Objetos cerrados"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"Abre automáticamente almejas, contenedores y cajas cerradas ya desbloqueadas de tus bolsas, sin hacer clic. El saqueo rápido oculta la ventana de botín para agilizar el saqueo automático. Un saqueo veloz y eficiente."
L["OPTIONS_ENABLE_WELCOME"] = "Activar mensaje de bienvenida"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Muestra la versión y una breve bienvenida en el chat cada vez que inicias sesión."
L["OPTIONS_ENABLE_MINIMAP"] = "Activar botón del minimapa"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Muestra el botón de Open Sesame en el minimapa."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la Interfaz de Opciones de este add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Activar apertura automática"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Activa o desactiva la apertura automática de almejas y contenedores desbloqueados."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Dónde"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Elige si los contenedores se abren en cualquier lugar o solo fuera de instancias."
L["OPTIONS_ANYWHERE"] = "En cualquier lugar"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Fuera de instancias"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Grupo"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"Elige si los contenedores se abren mientras estás en grupo o solo cuando juegas en solitario."
L["OPTIONS_SOLO_OR_GROUPED"] = "Solo o en grupo"
L["OPTIONS_SOLO_ONLY"] = "Únicamente en solitario"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Activar saqueo rápido"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"Saquea todo a la vez y oculta la ventana de botín, que solo se queda abierta para los objetos que no caben o que están en tu lista de ignorados."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Activar descripciones de cajas cerradas"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] =
	"Agrega a la descripción de cada caja cerrada la habilidad de Abrir cerraduras que necesita."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"Elige si las descripciones de cajas cerradas aparecen solo para pícaros o para todos los personajes."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Activar notificaciones de cajas cerradas"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"Te avisa en el chat cuando saqueas una caja cerrada que se abrirá en cuanto esté desbloqueada."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"Elige si las notificaciones de cajas cerradas aparecen solo para pícaros o para todos los personajes."
L["OPTIONS_SHOW_FOR"] = "Mostrar para"
L["OPTIONS_FOR_ROGUES"] = "Para pícaros"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Para todos los personajes"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Activar sonido de botín"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"Reproduce un aviso sonoro cuando saqueas de un cadáver o un cofre un objeto de la Calidad mínima o superior."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "La calidad de objeto más baja que reproduce el sonido de botín."
L["OPTIONS_TEST_LOOT_SOUND"] = "Reproduce el sonido de botín."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Activar sonido de Robar bolsillos"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"Reproduce un sonido de bolsa cuando Robar bolsillos consigue algo de verdad."
L["OPTIONS_MINIMUM_QUALITY"] = "Calidad mínima"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Los objetos de esta lista se dejan intactos: el saqueo rápido los deja en la ventana de botín y la apertura automática nunca los abre. La lista es común a todos tus personajes."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Activar notificaciones de la lista de ignorados"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Te avisa en el chat cuando Open Sesame deja un objeto intacto porque está en tu lista de ignorados."
L["OPTIONS_IGNORE_LIST_ADD"] = "Agregar objeto"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Arrastra un objeto aquí o pega un enlace de objeto o un ID de objeto."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Quita este objeto de la lista de ignorados."
L["OPTIONS_ITEM_LOADING"] = "Cargando objeto %d..."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Restaurar valores predeterminados"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Sustituye tu lista de ignorados por la predeterminada y quita los objetos que hayas agregado."
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"¿Restaurar la lista de ignorados predeterminada? Se quitarán los objetos que hayas agregado."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Lo suelta un jefe de banda. Un contenedor sin abrir todavía se puede comerciar o vender, a menudo por más de lo que contiene."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"Puede contener un objeto de misión único. Abrirlo puede fallar con un error si ya tienes uno."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"Puede contener una receta que se liga al recoger. Un contenedor sin abrir todavía se puede comerciar o vender."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"Puede contener un arma o una pieza de armadura que se liga al recoger. Un contenedor sin abrir todavía se puede comerciar o vender."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"Puede contener un objeto de evento que se liga al recoger. Un contenedor sin abrir todavía se puede comerciar o vender."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"Puede contener un objeto que se liga al recoger. Un contenedor sin abrir todavía se puede comerciar o vender."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versión %s"
