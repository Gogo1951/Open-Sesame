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
	"%s находится в списке исключений, поэтому автооткрытие его не тронет."
L["ITEM_OPEN_MANUALLY"] =
	"%s оставлен в окне добычи, чтобы вы забрали его сами."

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
	"Быстрый сбор скрывает окно добычи, поэтому эти звуки и уведомления сообщают, что вы только что подобрали."
L["LOCKBOXES_DESCRIPTION"] =
	"Запертые контейнеры требуют навыка взлома замков разбойника, прежде чем откроются. Эти настройки показывают, что нужно каждому ящику, и сообщают, когда один из них ждет."
L["LOOT_SOUNDS"] = "Звук добычи"
L["LOOT_SOUNDS_DESCRIPTION"] =
	"Воспроизводит звук, когда вы забираете предмет выбранного вами качества или выше."
L["LOOT_TOASTS"] = "Уведомления о добыче"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Показывает короткое уведомление на экране для подобранных предметов, ведь быстрый сбор скрывает окно добычи. Когда уведомления включены, можно отключить сообщения о добыче в настройках чата и оставить чат для разговоров и важных сообщений."

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
	"Автоматически открывает моллюсков, контейнеры и взломанные запертые ящики в ваших сумках, без единого клика. Быстрый сбор скрывает окно добычи, ускоряя автоматический сбор, а уведомления о добыче показывают каждую находку, чтобы вы не отрывали глаз от боя. Быстрый и эффективный сбор добычи."
L["OPTIONS_ENABLE_WELCOME"] = "Показывать приветственное сообщение"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Выводит в чат версию и короткое приветствие при каждом входе в игру."
L["OPTIONS_ENABLE_MINIMAP"] = "Показывать кнопку на мини-карте"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Показывает кнопку Open Sesame на мини-карте."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] =
	"Открывает интерфейс настроек этого дополнения."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Включить автооткрытие"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"Включает или отключает автоматическое открытие моллюсков и незапертых контейнеров."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Где"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"Выберите, открываются ли контейнеры везде или ждут, пока вы не покинете подземелья и рейды."
L["OPTIONS_ANYWHERE"] = "Везде"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Вне подземелий"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Группа"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"Выберите, открываются ли контейнеры, когда вы в группе, или только когда играете в одиночку."
L["OPTIONS_SOLO_OR_GROUPED"] = "Один или в группе"
L["OPTIONS_SOLO_ONLY"] = "Только в одиночку"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Включить быстрый сбор"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"Забирает всю добычу сразу и скрывает окно добычи, которое остается открытым только для предметов, которые не помещаются или находятся в списке исключений."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Включить подсказки для запертых ящиков"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] =
	"Добавляет в подсказку каждого запертого ящика нужный уровень навыка взлома замков."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"Выберите, показываются ли подсказки для запертых ящиков только разбойникам или всем персонажам."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Включить уведомления о запертых ящиках"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"Сообщает в чате, когда вы получаете запертый ящик, который откроется, как только будет взломан."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"Выберите, показываются ли уведомления о запертых ящиках только разбойникам или всем персонажам."
L["OPTIONS_SHOW_FOR"] = "Показывать для"
L["OPTIONS_FOR_ROGUES"] = "Для разбойников"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "Для всех персонажей"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Включить звук добычи"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"Проигрывает сигнал, когда вы забираете с трупа или из сундука предмет с минимальным качеством или выше."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] =
	"Самое низкое качество предмета, для которого проигрывается звук добычи."
L["OPTIONS_TEST_LOOT_SOUND"] = "Воспроизвести звук добычи."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Включить звук Обшаривания карманов"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"Проигрывает звук сумки, когда Обшаривание карманов действительно что-то приносит."
L["OPTIONS_MINIMUM_QUALITY"] = "Минимальное качество"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Включить уведомления о добыче"
L["OPTIONS_ENABLE_LOOT_TOASTS_DESCRIPTION"] =
	"Показывает короткое уведомление на экране о подобранных предметах и монетах."
L["OPTIONS_LOOT_TOAST_QUALITY_DESCRIPTION"] =
	"Самое низкое качество предмета, для которого показывается уведомление, если только его не охватывает одна из опций Всегда показывать ниже."
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
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP_DESCRIPTION"] =
	"Показывает каждый персональный предмет, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS_DESCRIPTION"] =
	"Показывает предметы для заданий и предметы, начинающие задание, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_RECIPES_DESCRIPTION"] =
	"Показывает рецепты, выкройки, чертежи и формулы, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_MOUNTS_DESCRIPTION"] =
	"Показывает средства передвижения, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_PETS_DESCRIPTION"] =
	"Показывает питомцев, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_KEYS_DESCRIPTION"] =
	"Показывает ключи, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_BAGS_DESCRIPTION"] =
	"Показывает сумки, колчаны и подсумки, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_CONTAINERS_DESCRIPTION"] =
	"Показывает контейнеры, которые может открыть Open Sesame, включая запертые ящики, независимо от качества."
L["OPTIONS_ALWAYS_SHOW_MONEY_DESCRIPTION"] =
	"Показывает уведомление о подобранных монетах."
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Максимум строк на экране"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS_DESCRIPTION"] =
	"Сколько уведомлений может быть на экране одновременно; самое старое исчезает, освобождая место."
L["OPTIONS_UNLIMITED"] = "Без ограничений"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Секунд на экране"
L["OPTIONS_LOOT_TOAST_DURATION_DESCRIPTION"] =
	"Сколько секунд каждое уведомление остается на экране, прежде чем исчезнуть."
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Направление роста"
L["OPTIONS_LOOT_TOAST_GROWTH_DESCRIPTION"] =
	"Сдвигаются ли старые уведомления вверх или вниз, прочь от самого нового."
L["OPTIONS_GROW_UP"] = "Вверх"
L["OPTIONS_GROW_DOWN"] = "Вниз"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Выравнивание строк"
L["OPTIONS_LOOT_TOAST_ALIGN_DESCRIPTION"] =
	"По какой стороне рамки перемещения выравниваются уведомления."
L["OPTIONS_ALIGN_LEFT"] = "Слева"
L["OPTIONS_ALIGN_RIGHT"] = "Справа"
L["OPTIONS_LOOT_TOAST_FONT"] = "Шрифт"
L["OPTIONS_LOOT_TOAST_FONT_DESCRIPTION"] = "Шрифт, которым написаны уведомления."
L["OPTIONS_FONT_DEFAULT"] = "По умолчанию"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Размер шрифта"
L["OPTIONS_LOOT_TOAST_FONT_SIZE_DESCRIPTION"] =
	"Размер текста уведомлений; значки увеличиваются и уменьшаются вместе с ним."
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Контур шрифта"
L["OPTIONS_LOOT_TOAST_OUTLINE_DESCRIPTION"] =
	"Контур вокруг текста уведомлений, благодаря которому он читается на ярком фоне."
L["OPTIONS_FONT_OUTLINE_NONE"] = "Нет"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Контур"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Толстый контур"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Монохромный"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Монохромный контур"
L["OPTIONS_TOASTS_UNLOCK"] = "Разблокировать позицию"
L["OPTIONS_TOASTS_LOCK"] = "Заблокировать позицию"
L["OPTIONS_TOASTS_RESET"] = "Сбросить позицию"
L["OPTIONS_TOASTS_LOCK_DESCRIPTION"] =
	"Показывает или скрывает рамку, за которую уведомления перетаскиваются на новое место."
L["OPTIONS_TOASTS_RESET_DESCRIPTION"] =
	"Возвращает уведомления на исходное место над центром экрана."
L["OPTIONS_TOASTS_HANDLE_TITLE"] = "Уведомления о добыче Open Sesame"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Нажмите и перетащите, чтобы разместить"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Правый клик, чтобы заблокировать"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Отключить уведомления о добыче"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Пример предмета"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Предметы из этого списка остаются нетронутыми: быстрый сбор оставляет их в окне добычи, а автооткрытие никогда их не открывает. Список общий для всех ваших персонажей."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] =
	"Включить уведомления списка исключений"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Сообщает в чате, когда Open Sesame не трогает предмет, потому что он в вашем списке исключений."
L["OPTIONS_IGNORE_LIST_ADD"] = "Добавить предмет"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] =
	"Перетащите предмет сюда или вставьте ссылку на предмет либо его ID."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Убрать этот предмет из списка исключений."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Восстановить по умолчанию"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Заменяет ваш список исключений списком по умолчанию и удаляет добавленные вами предметы."
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"Восстановить список исключений по умолчанию? Добавленные вами предметы будут удалены."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Выпадает с рейдового босса. Неоткрытый контейнер можно передать или продать, часто дороже его содержимого."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"Может содержать уникальный предмет задания. Если он у вас уже есть, открытие может завершиться ошибкой."
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
