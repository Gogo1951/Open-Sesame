local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "zhCN")
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "潜行者"
L["HERBALISTS"] = "草药师"
L["MINERS"] = "矿工"

L["ACTION_OPEN"] = "打开"
L["ACTION_PICK"] = "采集"
L["ACTION_MINE"] = "开采"

L["PREFIX_LOCKED"] = "上锁的"
L["PREFIX_HERB"] = "一些"
L["PREFIX_MINE"] = "一个"

L["MATCH_HERB"] = "草药学"
L["MATCH_MINE"] = "采矿"

L["DEFAULT_TREASURE"] = "宝箱"
L["DEFAULT_HERB"] = "草药"
L["DEFAULT_MINE"] = "矿脉"

L["MSG_FORMAT"] = "{rt7} Come & Get It // 嘿 %s，我发现了%s%s，但我无法%s！坐标：%s, %s 于 %s"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Come & Get It 下找到。喜欢这个插件吗？告诉你的朋友吧！(="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "发现了你无法采集的草药、无法开采的矿脉，或者是一个上锁的宝箱，而附近却没有潜行者？右键点击它，Come & Get It 会生成一条消息，你可以用来分享或广播坐标。成为英雄从未如此简单。"

L["OPTIONS_WELCOME_NAME"] = "启用欢迎消息"
L["OPTIONS_WELCOME_DESC"] = "登录时在聊天窗口打印欢迎消息。"

L["FEEDBACK_HEADER"] = "反馈与支持"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"