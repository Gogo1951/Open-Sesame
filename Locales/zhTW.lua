local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "zhTW")
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "盜賊"
L["HERBALISTS"] = "草藥學家"
L["MINERS"] = "礦工"

L["ACTION_OPEN"] = "打開"
L["ACTION_PICK"] = "採集"
L["ACTION_MINE"] = "採礦"

L["PREFIX_LOCKED"] = "上鎖的"
L["PREFIX_HERB"] = "一些"
L["PREFIX_MINE"] = "一個"

L["MATCH_HERB"] = "草藥學"
L["MATCH_MINE"] = "採礦"

L["DEFAULT_TREASURE"] = "寶箱"
L["DEFAULT_HERB"] = "草藥"
L["DEFAULT_MINE"] = "礦脈"

L["MSG_FORMAT"] = "{rt7} Come & Get It // 嘿 %s，我發現了%s%s，但我無法%s！座標：%s, %s 於 %s"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "版本 %s。設定（包含停用此訊息的選項）可以在 選項 > 插件 > Come & Get It 下找到。喜歡這個插件嗎？告訴你的朋友吧！(="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "發現了你無法採集的草藥、無法開採的礦脈，或者是一個上鎖的寶箱，而附近卻沒有盜賊？右鍵點擊它，Come & Get It 會產生一條訊息，你可以用來分享或廣播座標。成為英雄從未如此簡單。"

L["OPTIONS_WELCOME_NAME"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_DESC"] = "登入時在聊天視窗印出歡迎訊息。"

L["FEEDBACK_HEADER"] = "回饋與支援"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"