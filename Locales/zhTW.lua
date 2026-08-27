local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "zhTW")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "已啟用"
L["STATUS_DISABLED"] = "已停用"
L["STATUS_PAUSED"] = "已暫停"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "通知"
L["TAB_LOCKBOXES"] = "鎖箱"
L["TAB_IGNORE_LIST"] = "忽略清單"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "自動拾取已啟用。Open Sesame 需要它才能運作。"
L["CHAT_OPTIONS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟選項介面。"
L["CHAT_LOADED"] =
	"版本 %s。設定（包括關閉此訊息的選項）位於 選項 > 插件 > Open Sesame。喜歡這個插件嗎？告訴朋友吧！(="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "自動開啟已暫停，直到你有至少 %d 個空背包格。"
L["RESUMED"] = "自動開啟已恢復。"
L["INVENTORY_FULL"] = "背包已滿！"
L["ITEM_WILL_AUTO_OPEN"] = "%s 解鎖後將自動開啟。"
L["ITEM_IGNORED"] = "%s 在你的忽略清單中，自動開啟沒有碰它。"
L["ITEM_OPEN_MANUALLY"] = "%s 已留在拾取視窗中，供你自行開啟。"

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "自動開啟"
L["AUTO_OPENING_DESCRIPTION"] = "當你有至少 %d 個空背包格時，自動開啟蚌殼和未上鎖的容器。"
L["SPEEDY_LOOT"] = "快速拾取"
L["SPEEDY_LOOT_DESCRIPTION"] = "隱藏拾取視窗，讓拾取幾乎瞬間完成。"
L["NOTIFICATIONS_DESCRIPTION"] =
	"快速拾取會隱藏拾取視窗，因此 Open Sesame 透過這些方式告訴你剛剛撿到了什麼。"
L["LOCKBOXES_DESCRIPTION"] =
	"上鎖的容器需要盜賊的開鎖技能才能打開。這些選項會顯示每個鎖箱的需求，並在有鎖箱等待時提醒你。"
L["LOOT_SOUNDS"] = "拾取音效"
L["LOOT_SOUNDS_DESCRIPTION"] = "根據你選擇的品質設定播放音效。"
L["LOOT_TOASTS"] = "拾取提示"
L["LOOT_TOASTS_DESCRIPTION"] =
	"由於快速拾取隱藏了拾取視窗，這會為你拾取的物品在螢幕上顯示簡短提示。把拾取記錄移出聊天視窗，可以讓視窗留給對話和真正重要的訊息。"

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "左鍵點擊"
L["KEYBIND_RIGHT_CLICK"] = "右鍵點擊"
L["KEYBIND_MIDDLE_CLICK"] = "中鍵點擊"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + 中鍵點擊"
L["ACTION_TOGGLE"] = "切換"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame 選項"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "需要開鎖"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "你的開鎖"
L["TOOLTIP_LOCKED_ITEMS"] = "上鎖的物品"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"自動開啟背包中的蚌殼、鎖箱和未上鎖的容器，無需點擊。內建的快速拾取會隱藏拾取視窗，讓自動拾取幾乎瞬間完成。少點滑鼠，多玩遊戲。"
L["OPTIONS_ENABLE_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_ENABLE_MINIMAP"] = "啟用小地圖按鈕"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "啟用自動開啟"
L["OPTIONS_AUTO_OPENING_WHERE"] = "地點"
L["OPTIONS_ANYWHERE"] = "任何地點"
L["OPTIONS_OUTSIDE_INSTANCES"] = "副本之外"
L["OPTIONS_AUTO_OPENING_GROUP"] = "隊伍"
L["OPTIONS_SOLO_OR_GROUPED"] = "單人或組隊"
L["OPTIONS_SOLO_ONLY"] = "僅單人"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "啟用快速拾取"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "啟用鎖箱提示資訊"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "啟用鎖箱通知"
L["OPTIONS_SHOW_FOR"] = "顯示對象"
L["OPTIONS_FOR_ROGUES"] = "僅盜賊"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "所有角色"

-- Notifications
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "啟用拾取音效"
L["OPTIONS_TEST_LOOT_SOUND"] = "播放拾取音效。"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "啟用偷竊音效"
L["OPTIONS_MINIMUM_QUALITY"] = "最低品質"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "啟用拾取提示"
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "一律顯示拾取後綁定的物品"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "一律顯示任務物品"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "一律顯示配方"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "一律顯示坐騎"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "一律顯示寵物"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "一律顯示鑰匙"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "一律顯示背包"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "一律顯示容器"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "一律顯示金錢"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "最多顯示筆數"
L["OPTIONS_UNLIMITED"] = "不限"
L["OPTIONS_LOOT_TOAST_DURATION"] = "螢幕顯示秒數"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "增長方向"
L["OPTIONS_GROW_UP"] = "向上"
L["OPTIONS_GROW_DOWN"] = "向下"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "項目對齊"
L["OPTIONS_ALIGN_LEFT"] = "左"
L["OPTIONS_ALIGN_RIGHT"] = "右"
L["OPTIONS_LOOT_TOAST_FONT"] = "字型"
L["OPTIONS_FONT_DEFAULT"] = "預設"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "字型大小"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "字型外框"
L["OPTIONS_FONT_OUTLINE_NONE"] = "無"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "外框"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "粗外框"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "單色"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "單色外框"
L["OPTIONS_TOASTS_UNLOCK"] = "解鎖位置"
L["OPTIONS_TOASTS_LOCK"] = "鎖定位置"
L["OPTIONS_TOASTS_RESET"] = "重設位置"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "點擊 + 拖曳以調整位置"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "右鍵點擊以鎖定"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "停用拾取提示"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "範例物品"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的選項介面。"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"此清單中的物品不會被處理：快速拾取會把它們留在拾取視窗中，自動開啟也永遠不會打開它們。該清單由你的所有角色共用。"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "啟用忽略清單通知"
L["OPTIONS_IGNORE_LIST_ADD"] = "新增物品"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "把物品拖到這裡，或貼上物品連結或物品 ID。"
L["OPTIONS_IGNORE_LIST_REMOVE"] = "從忽略清單中移除此物品。"
L["OPTIONS_IGNORE_LIST_RESTORE"] = "恢復預設"
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] = "要恢復預設忽略清單嗎？你新增的物品將被移除。"
L["OPTIONS_IGNORE_REASON_RAID"] =
	"由團隊首領掉落。未開啟的容器仍可交易或出售，通常比裡面的東西更值錢。"
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"可能包含唯一的任務物品。如果你已經有一個，開啟時可能會出錯。"
L["OPTIONS_IGNORE_REASON_RECIPE"] = "可能包含拾取後綁定的配方。未開啟的容器仍可交易或出售。"
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"可能包含拾取後綁定的武器或護甲。未開啟的容器仍可交易或出售。"
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"可能包含拾取後綁定的節日物品。未開啟的容器仍可交易或出售。"
L["OPTIONS_IGNORE_REASON_ITEM"] = "可能包含拾取後綁定的物品。未開啟的容器仍可交易或出售。"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "意見回饋與支援"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
