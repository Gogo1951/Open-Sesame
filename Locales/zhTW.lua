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
L["ITEM_IGNORED"] = "%s 在你的忽略清單中，自動開啟不會碰它。"
L["ITEM_OPEN_MANUALLY"] = "%s 已留在拾取視窗中，供你自行拾取。"

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "自動開啟"
L["AUTO_OPENING_DESCRIPTION"] = "當你有至少 %d 個空背包格時，自動開啟蚌殼和未上鎖的容器。"
L["SPEEDY_LOOT"] = "快速拾取"
L["SPEEDY_LOOT_DESCRIPTION"] = "隱藏拾取視窗，讓拾取幾乎瞬間完成。"
L["NOTIFICATIONS_DESCRIPTION"] =
	"快速拾取會隱藏拾取視窗，因此這些音效和提示會告訴你剛剛撿到了什麼。"
L["LOCKBOXES_DESCRIPTION"] =
	"上鎖的容器需要盜賊的開鎖技能才能打開。這些選項會顯示每個鎖箱的需求，並在有鎖箱等待時提醒你。"
L["LOOT_SOUNDS"] = "拾取音效"
L["LOOT_SOUNDS_DESCRIPTION"] = "拾取達到你所選品質或更高品質的物品時播放音效。"
L["LOOT_TOASTS"] = "拾取提示"
L["LOOT_TOASTS_DESCRIPTION"] =
	"由於快速拾取隱藏了拾取視窗，這會為你拾取的物品在螢幕上顯示簡短提示。開啟提示後，你可以在聊天設定中關閉拾取訊息，讓聊天視窗留給對話和真正重要的訊息。"

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
	"自動開啟背包中的蚌殼、容器和已解鎖的鎖箱，無需點擊。快速拾取會隱藏拾取視窗，讓自動拾取更快，拾取提示會顯示你拾取的每一件物品，讓你的目光始終留在戰鬥上。快速、高效的拾取。"
L["OPTIONS_ENABLE_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "每次登入時在聊天視窗中顯示版本和簡短的歡迎語。"
L["OPTIONS_ENABLE_MINIMAP"] = "啟用小地圖按鈕"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "在小地圖上顯示 Open Sesame 按鈕。"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的選項介面。"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "啟用自動開啟"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] = "開啟或關閉蚌殼和未上鎖容器的自動開啟。"
L["OPTIONS_AUTO_OPENING_WHERE"] = "地點"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"選擇容器在任何地點都開啟，還是等你離開地城和團隊副本後再開啟。"
L["OPTIONS_ANYWHERE"] = "任何地點"
L["OPTIONS_OUTSIDE_INSTANCES"] = "副本之外"
L["OPTIONS_AUTO_OPENING_GROUP"] = "隊伍"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"選擇在隊伍中時也開啟容器，還是僅在單人遊戲時開啟。"
L["OPTIONS_SOLO_OR_GROUPED"] = "單人或組隊"
L["OPTIONS_SOLO_ONLY"] = "僅單人"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "啟用快速拾取"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"一次拾取所有物品並隱藏拾取視窗，只有放不下或在忽略清單中的物品才會讓視窗保持開啟。"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "啟用鎖箱提示資訊"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] = "在每個鎖箱的滑鼠提示中加入它所需的開鎖技能。"
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"選擇鎖箱提示資訊僅對盜賊顯示，還是對所有角色顯示。"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "啟用鎖箱通知"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"當你拾取一個解鎖後就會開啟的鎖箱時，在聊天視窗中提醒你。"
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"選擇鎖箱通知僅對盜賊顯示，還是對所有角色顯示。"
L["OPTIONS_SHOW_FOR"] = "顯示對象"
L["OPTIONS_FOR_ROGUES"] = "僅盜賊"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "所有角色"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "啟用拾取音效"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"從屍體或寶箱中拾取達到最低品質或更高品質的物品時播放提示音。"
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "播放拾取音效的最低物品品質。"
L["OPTIONS_TEST_LOOT_SOUND"] = "播放拾取音效。"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "啟用偷竊音效"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] = "偷竊真正偷到東西時播放背包音效。"
L["OPTIONS_MINIMUM_QUALITY"] = "最低品質"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "啟用拾取提示"
L["OPTIONS_ENABLE_LOOT_TOASTS_DESCRIPTION"] = "為你拾取的物品和金錢在螢幕上顯示簡短提示。"
L["OPTIONS_LOOT_TOAST_QUALITY_DESCRIPTION"] =
	"顯示提示的最低物品品質，除非下方的某個一律顯示選項涵蓋了該物品。"
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
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP_DESCRIPTION"] = "顯示所有拾取後綁定的物品，無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS_DESCRIPTION"] =
	"顯示任務物品和可開始任務的物品，無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_RECIPES_DESCRIPTION"] = "顯示配方、圖樣、設計圖和公式，無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_MOUNTS_DESCRIPTION"] = "顯示坐騎，無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_PETS_DESCRIPTION"] = "顯示寵物，無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_KEYS_DESCRIPTION"] = "顯示鑰匙，無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_BAGS_DESCRIPTION"] = "顯示背包、箭袋和彈藥袋，無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS_DESCRIPTION"] =
	"顯示 Open Sesame 能開啟的容器（包括鎖箱），無論其品質為何。"
L["OPTIONS_ALWAYS_SHOW_MONEY_DESCRIPTION"] = "為你拾取的金錢顯示提示。"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "最多顯示筆數"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS_DESCRIPTION"] =
	"螢幕上同時顯示的最多提示數量；最舊的提示會消失以騰出位置。"
L["OPTIONS_UNLIMITED"] = "不限"
L["OPTIONS_LOOT_TOAST_DURATION"] = "螢幕顯示秒數"
L["OPTIONS_LOOT_TOAST_DURATION_DESCRIPTION"] = "每則提示在淡出前停留的秒數。"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "增長方向"
L["OPTIONS_LOOT_TOAST_GROWTH_DESCRIPTION"] = "較舊的提示是向上還是向下移動，遠離最新的一則。"
L["OPTIONS_GROW_UP"] = "向上"
L["OPTIONS_GROW_DOWN"] = "向下"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "項目對齊"
L["OPTIONS_LOOT_TOAST_ALIGN_DESCRIPTION"] = "提示在拖曳把手的哪一側對齊。"
L["OPTIONS_ALIGN_LEFT"] = "左"
L["OPTIONS_ALIGN_RIGHT"] = "右"
L["OPTIONS_LOOT_TOAST_FONT"] = "字型"
L["OPTIONS_LOOT_TOAST_FONT_DESCRIPTION"] = "提示所使用的字型。"
L["OPTIONS_FONT_DEFAULT"] = "預設"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "字型大小"
L["OPTIONS_LOOT_TOAST_FONT_SIZE_DESCRIPTION"] = "提示文字的大小；圖示會隨之放大或縮小。"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "字型外框"
L["OPTIONS_LOOT_TOAST_OUTLINE_DESCRIPTION"] =
	"提示文字周圍的外框，讓它在明亮的場景中依然清晰易讀。"
L["OPTIONS_FONT_OUTLINE_NONE"] = "無"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "外框"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "粗外框"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "單色"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "單色外框"
L["OPTIONS_TOASTS_UNLOCK"] = "解鎖位置"
L["OPTIONS_TOASTS_LOCK"] = "鎖定位置"
L["OPTIONS_TOASTS_RESET"] = "重設位置"
L["OPTIONS_TOASTS_LOCK_DESCRIPTION"] = "顯示或隱藏用來把提示拖曳到新位置的把手。"
L["OPTIONS_TOASTS_RESET_DESCRIPTION"] = "把提示移回螢幕中央上方的預設位置。"
L["OPTIONS_TOASTS_HANDLE_TITLE"] = "Open Sesame 拾取提示"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "點擊 + 拖曳以調整位置"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "右鍵點擊以鎖定"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "停用拾取提示"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "範例物品"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"此清單中的物品不會被處理：快速拾取會把它們留在拾取視窗中，自動開啟也永遠不會打開它們。該清單由你的所有角色共用。"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "啟用忽略清單通知"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"當 Open Sesame 因物品在你的忽略清單中而不處理它時，在聊天視窗中提醒你。"
L["OPTIONS_IGNORE_LIST_ADD"] = "新增物品"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "把物品拖到這裡，或貼上物品連結或物品 ID。"
L["OPTIONS_IGNORE_LIST_REMOVE"] = "從忽略清單中移除此物品。"
L["OPTIONS_IGNORE_LIST_RESTORE"] = "恢復預設"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"用預設清單取代你的忽略清單，並移除你新增的所有物品。"
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
