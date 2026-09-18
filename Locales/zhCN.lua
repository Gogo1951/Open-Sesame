local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "zhCN")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "已启用"
L["STATUS_DISABLED"] = "已禁用"
L["STATUS_PAUSED"] = "已暂停"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "通知"
L["TAB_LOCKBOXES"] = "锁箱"
L["TAB_IGNORE_LIST"] = "忽略列表"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "自动拾取已启用。Open Sesame 需要它才能工作。"
L["CHAT_OPTIONS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开选项界面。"
L["CHAT_LOADED"] =
	"版本 %s。设置（包括关闭此消息的选项）位于 选项 > 插件 > Open Sesame。喜欢这个插件吗？告诉朋友吧！(="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "自动开启已暂停，直到你有至少 %d 个空闲背包格。"
L["RESUMED"] = "自动开启已恢复。"
L["INVENTORY_FULL"] = "背包已满！"
L["ITEM_WILL_AUTO_OPEN"] = "%s 解锁后将自动开启。"
L["ITEM_IGNORED"] = "%s 在你的忽略列表中，自动开启不会碰它。"
L["ITEM_OPEN_MANUALLY"] = "%s 已留在拾取窗口中，供你自行拾取。"

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "自动开启"
L["AUTO_OPENING_DESCRIPTION"] = "当你有至少 %d 个空闲背包格时，自动开启蚌壳和未上锁的容器。"
L["SPEEDY_LOOT"] = "快速拾取"
L["SPEEDY_LOOT_DESCRIPTION"] = "隐藏拾取窗口，让拾取几乎瞬间完成。"
L["NOTIFICATIONS_DESCRIPTION"] =
	"快速拾取会隐藏拾取窗口，因此这些音效和提示会告诉你刚刚捡到了什么。"
L["LOCKBOXES_DESCRIPTION"] =
	"上锁的容器需要潜行者的开锁技能才能打开。这些选项会显示每个锁箱的需求，并在有锁箱等待时提醒你。"
L["LOOT_SOUNDS"] = "拾取音效"
L["LOOT_SOUNDS_DESCRIPTION"] = "拾取达到你所选品质或更高品质的物品时播放音效。"
L["LOOT_TOASTS"] = "拾取提示"
L["LOOT_TOASTS_DESCRIPTION"] =
	"由于快速拾取隐藏了拾取窗口，这会为你拾取的物品在屏幕上显示简短提示。开启提示后，你可以在聊天设置中关闭拾取消息，让聊天框留给对话和真正重要的消息。"

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "左键点击"
L["KEYBIND_RIGHT_CLICK"] = "右键点击"
L["KEYBIND_MIDDLE_CLICK"] = "中键点击"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + 中键点击"
L["ACTION_TOGGLE"] = "切换"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame 选项"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "需要开锁"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "你的开锁"
L["TOOLTIP_LOCKED_ITEMS"] = "上锁的物品"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"自动开启背包中的蚌壳、容器和已解锁的锁箱，无需点击。快速拾取会隐藏拾取窗口，让自动拾取更快，拾取提示会显示你拾取的每一件物品，让你的目光始终留在战斗上。快速、高效的拾取。"
L["OPTIONS_ENABLE_WELCOME"] = "启用欢迎消息"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "每次登录时在聊天框中显示版本号和简短的欢迎语。"
L["OPTIONS_ENABLE_MINIMAP"] = "启用小地图按钮"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "在小地图上显示 Open Sesame 按钮。"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开此插件的选项界面。"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "启用自动开启"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] = "开启或关闭蚌壳和未上锁容器的自动开启。"
L["OPTIONS_AUTO_OPENING_WHERE"] = "地点"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"选择容器在任何地点都开启，还是等你离开地下城和团队副本后再开启。"
L["OPTIONS_ANYWHERE"] = "任何地点"
L["OPTIONS_OUTSIDE_INSTANCES"] = "副本之外"
L["OPTIONS_AUTO_OPENING_GROUP"] = "队伍"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"选择在队伍中时也开启容器，还是仅在单人游戏时开启。"
L["OPTIONS_SOLO_OR_GROUPED"] = "单人或组队"
L["OPTIONS_SOLO_ONLY"] = "仅单人"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "启用快速拾取"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"一次拾取所有物品并隐藏拾取窗口，只有放不下或在忽略列表中的物品才会让窗口保持打开。"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "启用锁箱提示信息"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] = "在每个锁箱的鼠标提示中加入它所需的开锁技能。"
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"选择锁箱提示信息仅对潜行者显示，还是对所有角色显示。"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "启用锁箱通知"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"当你拾取一个解锁后就会开启的锁箱时，在聊天框中提醒你。"
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"选择锁箱通知仅对潜行者显示，还是对所有角色显示。"
L["OPTIONS_SHOW_FOR"] = "显示对象"
L["OPTIONS_FOR_ROGUES"] = "仅潜行者"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "所有角色"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "启用拾取音效"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"从尸体或宝箱中拾取达到最低品质或更高品质的物品时播放提示音。"
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "播放拾取音效的最低物品品质。"
L["OPTIONS_TEST_LOOT_SOUND"] = "播放拾取音效。"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "启用偷窃音效"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] = "偷窃真正偷到东西时播放背包音效。"
L["OPTIONS_MINIMUM_QUALITY"] = "最低品质"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "启用拾取提示"
L["OPTIONS_ENABLE_LOOT_TOASTS_DESCRIPTION"] = "为你拾取的物品和金钱在屏幕上显示简短提示。"
L["OPTIONS_LOOT_TOAST_QUALITY_DESCRIPTION"] =
	"显示提示的最低物品品质，除非下方的某个始终显示选项涵盖了该物品。"
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "始终显示拾取后绑定的物品"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "始终显示任务物品"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "始终显示配方"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "始终显示坐骑"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "始终显示宠物"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "始终显示钥匙"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "始终显示背包"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "始终显示容器"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "始终显示金钱"
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP_DESCRIPTION"] = "显示所有拾取后绑定的物品，无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS_DESCRIPTION"] =
	"显示任务物品和可开始任务的物品，无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_RECIPES_DESCRIPTION"] = "显示配方、图样、设计图和公式，无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_MOUNTS_DESCRIPTION"] = "显示坐骑，无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_PETS_DESCRIPTION"] = "显示宠物，无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_KEYS_DESCRIPTION"] = "显示钥匙，无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_BAGS_DESCRIPTION"] = "显示背包、箭袋和弹药袋，无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS_DESCRIPTION"] =
	"显示 Open Sesame 能开启的容器（包括锁箱），无论其品质如何。"
L["OPTIONS_ALWAYS_SHOW_MONEY_DESCRIPTION"] = "为你拾取的金钱显示提示。"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "最多显示条数"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS_DESCRIPTION"] =
	"屏幕上同时显示的最多提示数量；最旧的提示会消失以腾出位置。"
L["OPTIONS_UNLIMITED"] = "不限"
L["OPTIONS_LOOT_TOAST_DURATION"] = "屏幕显示秒数"
L["OPTIONS_LOOT_TOAST_DURATION_DESCRIPTION"] = "每条提示在淡出前停留的秒数。"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "增长方向"
L["OPTIONS_LOOT_TOAST_GROWTH_DESCRIPTION"] = "较旧的提示是向上还是向下移动，远离最新的一条。"
L["OPTIONS_GROW_UP"] = "向上"
L["OPTIONS_GROW_DOWN"] = "向下"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "条目对齐"
L["OPTIONS_LOOT_TOAST_ALIGN_DESCRIPTION"] = "提示在拖动手柄的哪一侧对齐。"
L["OPTIONS_ALIGN_LEFT"] = "左"
L["OPTIONS_ALIGN_RIGHT"] = "右"
L["OPTIONS_LOOT_TOAST_FONT"] = "字体"
L["OPTIONS_LOOT_TOAST_FONT_DESCRIPTION"] = "提示所使用的字体。"
L["OPTIONS_FONT_DEFAULT"] = "默认"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "字体大小"
L["OPTIONS_LOOT_TOAST_FONT_SIZE_DESCRIPTION"] = "提示文字的大小；图标会随之放大或缩小。"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "字体描边"
L["OPTIONS_LOOT_TOAST_OUTLINE_DESCRIPTION"] =
	"提示文字周围的描边，让它在明亮的场景中依然清晰可读。"
L["OPTIONS_FONT_OUTLINE_NONE"] = "无"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "描边"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "粗描边"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "单色"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "单色描边"
L["OPTIONS_TOASTS_UNLOCK"] = "解锁位置"
L["OPTIONS_TOASTS_LOCK"] = "锁定位置"
L["OPTIONS_TOASTS_RESET"] = "重置位置"
L["OPTIONS_TOASTS_LOCK_DESCRIPTION"] = "显示或隐藏用于把提示拖到新位置的手柄。"
L["OPTIONS_TOASTS_RESET_DESCRIPTION"] = "把提示移回屏幕中央上方的默认位置。"
L["OPTIONS_TOASTS_HANDLE_TITLE"] = "Open Sesame 拾取提示"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "点击 + 拖动以调整位置"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "右键点击以锁定"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "禁用拾取提示"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "示例物品"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"此列表中的物品不会被处理：快速拾取会把它们留在拾取窗口中，自动开启也永远不会打开它们。该列表由你的所有角色共享。"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "启用忽略列表通知"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"当 Open Sesame 因物品在你的忽略列表中而不处理它时，在聊天框中提醒你。"
L["OPTIONS_IGNORE_LIST_ADD"] = "添加物品"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "把物品拖到这里，或粘贴物品链接或物品 ID。"
L["OPTIONS_IGNORE_LIST_REMOVE"] = "从忽略列表中移除此物品。"
L["OPTIONS_IGNORE_LIST_RESTORE"] = "恢复默认"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"用默认列表替换你的忽略列表，并移除你添加的所有物品。"
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] = "要恢复默认忽略列表吗？你添加的物品将被移除。"
L["OPTIONS_IGNORE_REASON_RAID"] =
	"由团队首领掉落。未开启的容器仍可交易或出售，通常比里面的东西更值钱。"
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"可能包含唯一的任务物品。如果你已经有一个，开启时可能会报错。"
L["OPTIONS_IGNORE_REASON_RECIPE"] = "可能包含拾取后绑定的配方。未开启的容器仍可交易或出售。"
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"可能包含拾取后绑定的武器或护甲。未开启的容器仍可交易或出售。"
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"可能包含拾取后绑定的节日物品。未开启的容器仍可交易或出售。"
L["OPTIONS_IGNORE_REASON_ITEM"] = "可能包含拾取后绑定的物品。未开启的容器仍可交易或出售。"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "反馈与支持"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
