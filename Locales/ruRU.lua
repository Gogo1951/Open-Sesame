local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "ruRU")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Включено"
L["STATUS_DISABLED"] = "Отключено"
L["STATUS_PAUSED"] = "Приостановлено"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "Уведомления"
L["TAB_LOCKBOXES"] = "Запертые ящики"
L["TAB_IGNORE_LIST"] = "Список исключений"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] =
	"Автоматический сбор добычи включен. Open Sesame не работает без него."
L["CHAT_OPTIONS_IN_COMBAT"] =
	"В целях безопасности интерфейс настроек нельзя открыть в бою."
L["CHAT_LOADED"] =
	"Версия %s. Настройки (включая отключение этого сообщения) находятся в разделе Настройки > Дополнения > Open Sesame. Нравится дополнение? Расскажите о нем другу! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] =
	"Автооткрытие приостановлено, пока не освободится хотя бы %d ячеек в сумках."
L["RESUMED"] = "Автооткрытие возобновлено."
L["INVENTORY_FULL"] = "Сумки заполнены!"
L["ITEM_WILL_AUTO_OPEN"] =
	"%s откроется автоматически, как только будет взломан."
L["ITEM_IGNORED"] =
	"%s находится в списке исключений, поэтому автооткрытие его не тронуло."
L["ITEM_OPEN_MANUALLY"] =
	"%s оставлен в окне добычи, чтобы вы открыли его сами."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Автооткрытие"
L["AUTO_OPENING_DESCRIPTION"] =
	"Автоматически открывает моллюсков и незапертые контейнеры, когда в сумках свободно хотя бы %d ячеек."
L["SPEEDY_LOOT"] = "Быстрый сбор"
L["SPEEDY_LOOT_DESCRIPTION"] =
	"Скрывает окно добычи, чтобы собирать почти мгновенно."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Быстрый сбор скрывает окно добычи, поэтому именно так Open Sesame сообщает, что вы только что подобрали."
L["LOCKBOXES_DESCRIPTION"] =
	"Запертые контейнеры требуют навыка взлома замков разбойника, прежде чем откроются. Эти настройки показывают, что нужно каждому ящику, и сообщают, когда один из них ждет."
L["LOOT_SOUNDS"] = "Звук добычи"
L["LOOT_SOUNDS_DESCRIPTION"] =
	"Воспроизводит звук в зависимости от выбранной вами настройки качества."
L["LOOT_TOASTS"] = "Уведомления о добыче"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Показывает короткое уведомление на экране для подобранных предметов, ведь быстрый сбор скрывает окно добычи. Когда добыча не идет в чат, окно остается свободным для разговоров и важных сообщений."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Левый клик"
L["KEYBIND_RIGHT_CLICK"] = "Правый клик"
L["KEYBIND_MIDDLE_CLICK"] = "Средний клик"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + Средний клик"
L["ACTION_TOGGLE"] = "Переключить"
L["TOOLTIP_OPTIONS_TITLE"] = "Настройки Open Sesame"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "Требуется взлом замков"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "Ваш взлом замков"
L["TOOLTIP_LOCKED_ITEMS"] = "Запертые предметы"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"Автоматически открывает моллюсков, запертые ящики и незапертые контейнеры в ваших сумках, без единого клика. Встроенный быстрый сбор скрывает окно добычи для почти мгновенного автоматического сбора. Меньше кликов, больше игры."
L["OPTIONS_ENABLE_WELCOME"] = "Показывать приветственное сообщение"
L["OPTIONS_ENABLE_MINIMAP"] = "Показывать кнопку на мини-карте"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Включить автооткрытие"
L["OPTIONS_AUTO_OPENING_WHERE"] = "Где"
L["OPTIONS_ANYWHERE"] = "Везде"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Вне подземелий"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Группа"
L["OPTIONS_SOLO_OR_GROUPED"] = "Один или в группе"
L["OPTIONS_SOLO_ONLY"] = "Только в одиночку"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Включить быстрый сбор"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Включить подсказки для запертых ящиков"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Включить уведомления о запертых ящиках"
L["OPTIONS_SHOW_FOR"] = "Показывать для"
L["OPTIONS_FOR_ROGUES"] = "Для разбойников"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Для всех персонажей"

-- Notifications
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Включить звук добычи"
L["OPTIONS_TEST_LOOT_SOUND"] = "Воспроизвести звук добычи."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Включить звук карманной кражи"
L["OPTIONS_MINIMUM_QUALITY"] = "Минимальное качество"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Включить уведомления о добыче"
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "Всегда показывать персональные предметы"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "Всегда показывать предметы заданий"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "Всегда показывать рецепты"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "Всегда показывать средства передвижения"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "Всегда показывать питомцев"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "Всегда показывать ключи"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "Всегда показывать сумки"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "Всегда показывать контейнеры"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "Всегда показывать деньги"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Максимум строк на экране"
L["OPTIONS_UNLIMITED"] = "Без ограничений"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Секунд на экране"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Направление роста"
L["OPTIONS_GROW_UP"] = "Вверх"
L["OPTIONS_GROW_DOWN"] = "Вниз"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Выравнивание строк"
L["OPTIONS_ALIGN_LEFT"] = "Слева"
L["OPTIONS_ALIGN_RIGHT"] = "Справа"
L["OPTIONS_LOOT_TOAST_FONT"] = "Шрифт"
L["OPTIONS_FONT_DEFAULT"] = "По умолчанию"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Размер шрифта"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Контур шрифта"
L["OPTIONS_FONT_OUTLINE_NONE"] = "Нет"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Контур"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Толстый контур"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Монохромный"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Монохромный контур"
L["OPTIONS_TOASTS_UNLOCK"] = "Разблокировать позицию"
L["OPTIONS_TOASTS_LOCK"] = "Заблокировать позицию"
L["OPTIONS_TOASTS_RESET"] = "Сбросить позицию"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Нажмите и перетащите, чтобы разместить"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Правый клик, чтобы заблокировать"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Отключить уведомления о добыче"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Пример предмета"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] =
	"Открывает интерфейс настроек этого дополнения."

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Предметы из этого списка остаются нетронутыми: быстрый сбор оставляет их в окне добычи, а автооткрытие никогда их не открывает. Список общий для всех ваших персонажей."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] =
	"Включить уведомления списка исключений"
L["OPTIONS_IGNORE_LIST_ADD"] = "Добавить предмет"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] =
	"Перетащите предмет сюда или вставьте ссылку на предмет либо его ID."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Убрать этот предмет из списка исключений."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Восстановить по умолчанию"
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"Восстановить список исключений по умолчанию? Добавленные вами предметы будут удалены."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Выпадает с рейдового босса. Неоткрытый контейнер можно передать или продать, часто дороже его содержимого."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"Может содержать уникальный предмет задания. Если он у вас уже есть, открытие завершится ошибкой."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"Может содержать персональный рецепт. Неоткрытый контейнер можно передать или продать."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"Может содержать персональное оружие или часть брони. Неоткрытый контейнер можно передать или продать."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"Может содержать персональный праздничный предмет. Неоткрытый контейнер можно передать или продать."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"Может содержать персональный предмет. Неоткрытый контейнер можно передать или продать."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Отзывы и поддержка"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
