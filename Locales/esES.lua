local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "esES")
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
	"Versión %s. Los ajustes (incluida la opción de desactivar este mensaje) están en Opciones > AddOns > Open Sesame. ¿Te gusta el add-on? ¡Cuéntaselo a un amigo! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] =
	"La apertura automática está en pausa hasta que tengas al menos %d espacios libres en la bolsa."
L["RESUMED"] = "La apertura automática se ha reanudado."
L["INVENTORY_FULL"] = "¡El inventario está lleno!"
L["ITEM_WILL_AUTO_OPEN"] = "%s se abrirá automáticamente en cuanto esté desbloqueado."
L["ITEM_IGNORED"] = "%s está en tu lista de ignorados, así que la apertura automática no lo tocará."
L["ITEM_OPEN_MANUALLY"] = "%s se ha dejado en la ventana de botín para que lo recojas tú."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Apertura automática"
L["AUTO_OPENING_DESCRIPTION"] =
	"Abre automáticamente almejas y contenedores desbloqueados cuando tienes al menos %d espacios libres en la bolsa."
L["SPEEDY_LOOT"] = "Saqueo rápido"
L["SPEEDY_LOOT_DESCRIPTION"] = "Oculta la ventana de botín para saquear casi al instante."
L["NOTIFICATIONS_DESCRIPTION"] =
	"El saqueo rápido oculta la ventana de botín, así que estos sonidos y avisos te dicen lo que acabas de recoger."
L["LOCKBOXES_DESCRIPTION"] =
	"Los contenedores cerrados necesitan la habilidad Abrir cerraduras de un pícaro para poder abrirse. Estas opciones muestran lo que requiere cada caja y te avisan cuando hay una esperando."
L["LOOT_SOUNDS"] = "Sonido de botín"
L["LOOT_SOUNDS_DESCRIPTION"] = "Reproduce un sonido cuando saqueas un objeto de la calidad que elijas o superior."
L["LOOT_TOASTS"] = "Avisos de botín"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Muestra un aviso breve en pantalla de los objetos que saqueas, ya que el saqueo rápido oculta la ventana de botín. Con los avisos activados, puedes desactivar los mensajes de botín en los ajustes del chat y dejar el chat libre para conversar y para los mensajes que importan."

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
	"Abre automáticamente almejas, contenedores y cajas cerradas ya desbloqueadas de tus bolsas, sin hacer clic. El saqueo rápido oculta la ventana de botín para agilizar el saqueo automático, y los avisos de botín muestran cada objeto recogido para que no apartes la vista del combate. Un saqueo veloz y eficiente."
L["OPTIONS_ENABLE_WELCOME"] = "Activar mensaje de bienvenida"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Muestra la versión y una breve bienvenida en el chat cada vez que inicias sesión."
L["OPTIONS_ENABLE_MINIMAP"] = "Activar botón del minimapa"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Muestra el botón de Open Sesame en el minimapa."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la Interfaz de Opciones de este add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Activar apertura automática"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Activa o desactiva la apertura automática de almejas y contenedores desbloqueados."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Dónde"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Elige si los contenedores se abren en cualquier lugar o esperan a que salgas de mazmorras y bandas."
L["OPTIONS_ANYWHERE"] = "En cualquier lugar"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Fuera de estancias"
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
	"Añade a la descripción de cada caja cerrada la habilidad de Abrir cerraduras que necesita."
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
L["OPTIONS_TEST_LOOT_SOUND"] = "Reproducir el sonido de botín."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Activar sonido de Robar bolsillos"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"Reproduce un sonido de bolsa cuando Robar bolsillos consigue algo de verdad."
L["OPTIONS_MINIMUM_QUALITY"] = "Calidad mínima"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Activar avisos de botín"
L["OPTIONS_ENABLE_LOOT_TOASTS_DESCRIPTION"] =
	"Muestra un aviso breve en pantalla de los objetos y las monedas que saqueas."
L["OPTIONS_LOOT_TOAST_QUALITY_DESCRIPTION"] =
	"La calidad de objeto más baja que recibe un aviso, salvo que una opción de Mostrar siempre de abajo cubra el objeto."
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "Mostrar siempre objetos que se ligan al recoger"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "Mostrar siempre objetos de misión"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "Mostrar siempre recetas"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "Mostrar siempre monturas"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "Mostrar siempre mascotas"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "Mostrar siempre llaves"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "Mostrar siempre bolsas"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "Mostrar siempre contenedores"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "Mostrar siempre dinero"
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP_DESCRIPTION"] =
	"Muestra todos los objetos que se ligan al recoger, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS_DESCRIPTION"] =
	"Muestra objetos de misión y objetos que inician una misión, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_RECIPES_DESCRIPTION"] = "Muestra recetas, patrones, planos y fórmulas, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_MOUNTS_DESCRIPTION"] = "Muestra monturas, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_PETS_DESCRIPTION"] = "Muestra mascotas de compañía, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_KEYS_DESCRIPTION"] = "Muestra llaves, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_BAGS_DESCRIPTION"] = "Muestra bolsas, carcajs y bolsas de munición, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_CONTAINERS_DESCRIPTION"] =
	"Muestra los contenedores que Open Sesame puede abrir, incluidas las cajas cerradas, sea cual sea su calidad."
L["OPTIONS_ALWAYS_SHOW_MONEY_DESCRIPTION"] = "Muestra un aviso por las monedas que saqueas."
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Máximo de objetos a mostrar"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS_DESCRIPTION"] =
	"El máximo de avisos en pantalla a la vez; el más antiguo desaparece para hacer sitio."
L["OPTIONS_UNLIMITED"] = "Ilimitado"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Segundos en pantalla"
L["OPTIONS_LOOT_TOAST_DURATION_DESCRIPTION"] = "Cuántos segundos permanece cada aviso antes de desvanecerse."
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Dirección de crecimiento"
L["OPTIONS_LOOT_TOAST_GROWTH_DESCRIPTION"] =
	"Si los avisos más antiguos se desplazan hacia arriba o hacia abajo, alejándose del más reciente."
L["OPTIONS_GROW_UP"] = "Hacia arriba"
L["OPTIONS_GROW_DOWN"] = "Hacia abajo"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Alinear objetos"
L["OPTIONS_LOOT_TOAST_ALIGN_DESCRIPTION"] = "A qué lado del tirador se alinean los avisos."
L["OPTIONS_ALIGN_LEFT"] = "Izquierda"
L["OPTIONS_ALIGN_RIGHT"] = "Derecha"
L["OPTIONS_LOOT_TOAST_FONT"] = "Fuente"
L["OPTIONS_LOOT_TOAST_FONT_DESCRIPTION"] = "La fuente con la que se escriben los avisos."
L["OPTIONS_FONT_DEFAULT"] = "Predeterminada"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Tamaño de fuente"
L["OPTIONS_LOOT_TOAST_FONT_SIZE_DESCRIPTION"] =
	"El tamaño del texto de los avisos; los iconos crecen y se encogen con él."
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Contorno de fuente"
L["OPTIONS_LOOT_TOAST_OUTLINE_DESCRIPTION"] =
	"El contorno alrededor del texto de los avisos, que lo mantiene legible sobre fondos claros."
L["OPTIONS_FONT_OUTLINE_NONE"] = "Ninguno"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Contorno"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Contorno grueso"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Monocromo"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Contorno monocromo"
L["OPTIONS_TOASTS_UNLOCK"] = "Desbloquear posición"
L["OPTIONS_TOASTS_LOCK"] = "Bloquear posición"
L["OPTIONS_TOASTS_RESET"] = "Restablecer posición"
L["OPTIONS_TOASTS_LOCK_DESCRIPTION"] = "Muestra u oculta el tirador para arrastrar los avisos a otro lugar."
L["OPTIONS_TOASTS_RESET_DESCRIPTION"] =
	"Devuelve los avisos a su posición predeterminada, encima del centro de la pantalla."
L["OPTIONS_TOASTS_HANDLE_TITLE"] = "Avisos de botín de Open Sesame"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Clic + Arrastrar para colocar"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Clic derecho para bloquear"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Desactivar avisos de botín"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Objeto de ejemplo"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Los objetos de esta lista se dejan intactos: el saqueo rápido los deja en la ventana de botín y la apertura automática nunca los abre. La lista es común a todos tus personajes."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Activar notificaciones de la lista de ignorados"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Te avisa en el chat cuando Open Sesame deja un objeto intacto porque está en tu lista de ignorados."
L["OPTIONS_IGNORE_LIST_ADD"] = "Añadir objeto"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Arrastra un objeto aquí o pega un enlace de objeto o un ID de objeto."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Quitar este objeto de la lista de ignorados."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Restaurar valores predeterminados"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Sustituye tu lista de ignorados por la predeterminada y quita los objetos que hayas añadido."
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"¿Restaurar la lista de ignorados predeterminada? Se quitarán los objetos que hayas añadido."
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
