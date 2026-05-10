local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "koKR")
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "도적"
L["HERBALISTS"] = "약초채집가"
L["MINERS"] = "광부"

L["ACTION_OPEN"] = "열기"
L["ACTION_PICK"] = "채집"
L["ACTION_MINE"] = "채광"

L["PREFIX_LOCKED"] = "잠긴"
L["PREFIX_HERB"] = "약간의"
L["PREFIX_MINE"] = "하나의"

L["MATCH_HERB"] = "약초채집"
L["MATCH_MINE"] = "채광"

L["DEFAULT_TREASURE"] = "보물 상자"
L["DEFAULT_HERB"] = "약초"
L["DEFAULT_MINE"] = "광맥"

L["MSG_FORMAT"] = "{rt7} Come & Get It // 저기요 %s님, 제가 %s %s(을)를 발견했는데 %s 할 수 없네요! 위치: %s, %s (%s)"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "버전 %s. 설정(이 메시지를 비활성화하는 옵션 포함)은 설정 > 애드온 > Come & Get It 에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "채집할 수 없는 약초, 캘 수 없는 광맥, 또는 근처에 도적이 없는 잠긴 보물 상자를 발견하셨나요? 우클릭하면 Come & Get It이 좌표를 공유하거나 알릴 수 있는 메시지를 생성합니다. 영웅이 되는 것이 이렇게 쉬운 적은 없었습니다."

L["OPTIONS_WELCOME_NAME"] = "환영 메시지 활성화"
L["OPTIONS_WELCOME_DESC"] = "로그인 시 채팅창에 환영 메시지를 출력합니다."

L["FEEDBACK_HEADER"] = "피드백 및 지원"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"