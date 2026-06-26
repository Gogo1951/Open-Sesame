local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "zhTW")
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "已啟用"
L["STATUS_DISABLED"] = "已停用"
L["STATUS_PAUSED"] = "已暫停"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Open Sesame 需要啟用自動拾取才能正常運作。自動拾取已啟用。"
L["CHAT_LOADED"] = "版本 %s。設定（包括停用此訊息的選項）可以在 選項 > 插件 > Open Sesame 中找到。喜歡這個插件嗎？告訴你的朋友吧！(="
L["MESSAGE_RESET"] = "所有設定已重置為預設值。"

-- Auto-Open
L["PAUSED_BAG_SLOTS"] = "自動開啟已暫停，直到背包有至少 %d 個空位。"
L["RESUMED"] = "自動開啟已恢復。"
L["INVENTORY_FULL"] = "背包已滿！"
L["ITEM_WILL_AUTO_OPEN"] = "%s 將在解鎖後自動開啟。"
L["ITEM_OPEN_MANUALLY"] = "%s 需要手動開啟。它可能包含唯一、拾取綁定或暫時物品，或者是從團隊首領處獲得的。"

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "自動開啟"
L["AUTO_OPENING_DESC"] = "當背包有至少 %d 個空位時，自動開啟蛤蜊和已解鎖的容器。"
L["SPEEDY_LOOT"] = "快速拾取"
L["SPEEDY_LOOT_DESC"] = "隱藏拾取視窗以實現近乎即時的拾取。"
L["LOOT_SOUNDS"] = "拾取音效"
L["LOOT_SOUNDS_DESC"] = "拾取到優秀或更高品質的物品時播放特殊音效。"

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "左鍵點擊"
L["KEYBIND_RIGHT_CLICK"] = "右鍵點擊"
L["KEYBIND_MIDDLE_CLICK"] = "中鍵點擊"
L["ACTION_TOGGLE"] = "切換"
L["TOOLTIP_HINT"] = "其他設定可以在 選項 > 插件 > Open Sesame 中找到。"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "自動開啟背包中的蛤蜊、保險箱和已解鎖的容器。具備快速拾取功能，讓拾取更加迅速。"
L["OPTIONS_ENABLE_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_ENABLE_MINIMAP"] = "啟用小地圖按鈕"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "啟用保險箱通知"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "啟用自動開啟"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "啟用快速拾取"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "啟用拾取音效"
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "開啟 Open Sesame 選項介面。"
L["OPTIONS_RESET"] = "重置"
L["OPTIONS_RESET_DESC"] = "將所有 Open Sesame 設定還原為預設值。"
L["OPTIONS_RESET_BUTTON"] = "重置所有 Open Sesame 選項"
L["OPTIONS_RESET_CONFIRM"] = "是否將所有 Open Sesame 設定重置為預設值？"
L["OPTIONS_FEEDBACK"] = "回饋 & 支援"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
