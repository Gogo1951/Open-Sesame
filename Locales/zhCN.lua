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
L["CHAT_END_OF_SUPPORT"] =
	"停止支持：本插件现已成为 GogoLoot 的一部分，这是它的最后一个版本。安装 GogoLoot 即可继续获得更新，之后你就可以移除 Open Sesame 了。"

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "自动开启已暂停，直到你有至少 %d 个空闲背包格。"
L["RESUMED"] = "自动开启已恢复。"
L["INVENTORY_FULL"] = "背包已满！"
L["ITEM_WILL_AUTO_OPEN"] = "%s 解锁后将自动开启。"
L["ITEM_IGNORED"] = "%s 在你的忽略列表中，自动开启不会碰它。"
L["ITEM_OPEN_MANUALLY"] = "%s 在你的忽略列表中，快速拾取已将它留在拾取窗口中。"

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "自动开启"
L["AUTO_OPENING_DESCRIPTION"] = "当你有至少 %d 个空闲背包格时，自动开启蚌壳和未上锁的容器。"
L["SPEEDY_LOOT"] = "快速拾取"
L["SPEEDY_LOOT_DESCRIPTION"] = "隐藏拾取窗口，让拾取几乎瞬间完成。"
L["NOTIFICATIONS_DESCRIPTION"] =
	"快速拾取会隐藏拾取窗口，因此这些音效会告诉你刚刚捡到了什么。"
L["LOCKBOXES_DESCRIPTION"] =
	"上锁的容器需要潜行者的开锁技能才能打开。这些选项会显示每个锁箱的需求，并在有锁箱等待时提醒你。"
L["LOOT_SOUNDS"] = "拾取音效"
L["LOOT_SOUNDS_DESCRIPTION"] = "拾取达到你所选品质或更高品质的物品时播放音效。"

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
	"自动开启背包中的蚌壳、容器和已解锁的锁箱，无需点击。快速拾取会隐藏拾取窗口，让自动拾取更快。快速、高效的拾取。"
L["OPTIONS_ENABLE_WELCOME"] = "启用欢迎消息"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "每次登录时在聊天框中显示版本号和简短的欢迎语。"
L["OPTIONS_ENABLE_MINIMAP"] = "启用小地图按钮"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "在小地图上显示 Open Sesame 按钮。"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/命令"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开此插件的选项界面。"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "启用自动开启"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] = "开启或关闭蚌壳和未上锁容器的自动开启。"
L["OPTIONS_AUTO_OPENING_WHERE"] = "地点"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] = "选择容器在任何地点都开启，还是仅在副本之外开启。"
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

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"此列表中的物品不会被处理：快速拾取会把它们留在拾取窗口中，自动开启也永远不会打开它们。该列表由你的所有角色共享。"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "启用忽略列表通知"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"当 Open Sesame 因物品在你的忽略列表中而不处理它时，在聊天框中提醒你。"
L["OPTIONS_IGNORE_LIST_ADD"] = "添加物品"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "把物品拖到这里，或粘贴物品链接或物品 ID。"
L["OPTIONS_IGNORE_LIST_REMOVE"] = "从忽略列表中移除此物品。"
L["OPTIONS_ITEM_LOADING"] = "正在加载物品 %d..."
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
L["OPTIONS_VERSION"] = "版本 %s"
