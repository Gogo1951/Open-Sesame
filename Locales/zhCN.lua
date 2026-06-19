local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "zhCN")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "已启用"
L["STATUS_DISABLED"] = "已禁用"
L["STATUS_PAUSED"] = "已暂停"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"] = "Open Sesame 需要启用自动拾取才能正常工作。自动拾取已启用。"
L["PAUSED_BAG_SLOTS"] = "自动开启已暂停，直到背包有至少 %d 个空位。"
L["RESUMED"] = "自动开启已恢复。"
L["INVENTORY_FULL"] = "背包已满！"
L["ITEM_WILL_AUTO_OPEN"] = "%s 将在解锁后自动打开。"
L["ITEM_OPEN_MANUALLY"] = "%s 需要手动打开。它可能包含唯一、拾取绑定或临时物品，或者是从团队首领处获得的。"
L["CHAT_LOADED"] = "版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Open Sesame 中找到。喜欢这个插件吗？告诉你的朋友吧！(="

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "自动开启"
L["AUTO_OPENING_DESC"] = "当背包有至少 %d 个空位时，自动打开蛤蜊和已解锁的容器。"
L["SPEEDY_LOOT"] = "快速拾取"
L["SPEEDY_LOOT_DESC"] = "隐藏拾取窗口以实现近乎即时的拾取。"
L["LOOT_SOUNDS"] = "拾取音效"
L["LOOT_SOUNDS_DESC"] = "拾取到优秀或更高品质的物品时播放特殊音效。"

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "左键点击"
L["KEYBIND_RIGHT_CLICK"] = "右键点击"
L["KEYBIND_MIDDLE_CLICK"] = "中键点击"
L["ACTION_TOGGLE"] = "切换"
L["TOOLTIP_HINT"] = "其他设置可以在 选项 > 插件 > Open Sesame 中找到。"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "自动打开背包中的蛤蜊和已解锁的容器。具有快速拾取功能，让拾取更加迅速。"
L["OPTIONS_ENABLE_WELCOME"] = "启用欢迎消息"
L["OPTIONS_ENABLE_MINIMAP"] = "启用小地图按钮"
L["OPTIONS_RESET"] = "重置"
L["OPTIONS_RESET_DESC"] = "将所有 Open Sesame 设置还原为默认值。"
L["OPTIONS_RESET_BUTTON"] = "重置所有 Open Sesame 选项"
L["OPTIONS_RESET_CONFIRM"] = "是否将所有 Open Sesame 设置重置为默认值？"
L["OPTIONS_FEEDBACK"] = "反馈 & 支持"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"