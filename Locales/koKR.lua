local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "koKR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "활성화됨"
L["STATUS_DISABLED"] = "비활성화됨"
L["STATUS_PAUSED"] = "일시 중지됨"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "알림"
L["TAB_LOCKBOXES"] = "잠긴 상자"
L["TAB_IGNORE_LIST"] = "제외 목록"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "자동 획득이 활성화되었습니다. Open Sesame가 작동하려면 필요합니다."
L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 화면을 열 수 없습니다."
L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지를 끄는 옵션 포함)은 옵션 > 애드온 > Open Sesame에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "가방 빈 칸이 %d칸 이상 생길 때까지 자동 열기가 일시 중지됩니다."
L["RESUMED"] = "자동 열기가 재개되었습니다."
L["INVENTORY_FULL"] = "가방이 가득 찼습니다!"
L["ITEM_WILL_AUTO_OPEN"] = "%s은(는) 잠금이 풀리는 즉시 자동으로 열립니다."
L["ITEM_IGNORED"] = "%s은(는) 제외 목록에 있어 자동 열기가 건드리지 않았습니다."
L["ITEM_OPEN_MANUALLY"] = "%s은(는) 직접 열 수 있도록 획득 창에 남겨두었습니다."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "자동 열기"
L["AUTO_OPENING_DESCRIPTION"] =
	"가방 빈 칸이 %d칸 이상일 때 조개와 잠기지 않은 상자를 자동으로 엽니다."
L["SPEEDY_LOOT"] = "빠른 획득"
L["SPEEDY_LOOT_DESCRIPTION"] = "획득 창을 숨겨 거의 즉시 아이템을 획득합니다."
L["NOTIFICATIONS_DESCRIPTION"] =
	"빠른 획득이 획득 창을 숨기므로, Open Sesame는 이 방법으로 방금 무엇을 주웠는지 알려줍니다."
L["LOCKBOXES_DESCRIPTION"] =
	"잠긴 상자는 도적의 자물쇠 따기 숙련이 있어야 열 수 있습니다. 이 설정은 각 상자에 필요한 수치를 보여주고, 기다리는 상자가 있으면 알려줍니다."
L["LOOT_SOUNDS"] = "획득 소리"
L["LOOT_SOUNDS_DESCRIPTION"] = "원하는 품질 설정에 따라 소리를 재생합니다."
L["LOOT_TOASTS"] = "획득 알림"
L["LOOT_TOASTS_DESCRIPTION"] =
	"빠른 획득이 획득 창을 숨기므로, 주운 아이템을 화면에 짧게 표시합니다. 획득 내역을 대화창 밖으로 옮기면 대화와 중요한 메시지를 위한 공간이 생깁니다."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "좌클릭"
L["KEYBIND_RIGHT_CLICK"] = "우클릭"
L["KEYBIND_MIDDLE_CLICK"] = "휠클릭"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + 휠클릭"
L["ACTION_TOGGLE"] = "전환"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame 설정"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "필요 자물쇠 따기"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "내 자물쇠 따기"
L["TOOLTIP_LOCKED_ITEMS"] = "잠긴 아이템"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"가방 속 조개, 잠긴 상자, 잠기지 않은 상자를 클릭 없이 자동으로 엽니다. 내장된 빠른 획득이 획득 창을 숨겨 거의 즉시 자동으로 아이템을 챙깁니다. 클릭은 줄이고, 플레이는 늘리세요."
L["OPTIONS_ENABLE_WELCOME"] = "시작 메시지 사용"
L["OPTIONS_ENABLE_MINIMAP"] = "미니맵 버튼 사용"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "자동 열기 사용"
L["OPTIONS_AUTO_OPENING_WHERE"] = "장소"
L["OPTIONS_ANYWHERE"] = "모든 장소"
L["OPTIONS_OUTSIDE_INSTANCES"] = "인스턴스 밖에서만"
L["OPTIONS_AUTO_OPENING_GROUP"] = "파티"
L["OPTIONS_SOLO_OR_GROUPED"] = "솔로 또는 파티"
L["OPTIONS_SOLO_ONLY"] = "솔로일 때만"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "빠른 획득 사용"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "잠긴 상자 툴팁 사용"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "잠긴 상자 알림 사용"
L["OPTIONS_SHOW_FOR"] = "표시 대상"
L["OPTIONS_FOR_ROGUES"] = "도적만"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "모든 캐릭터"

-- Notifications
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "획득 소리 사용"
L["OPTIONS_TEST_LOOT_SOUND"] = "획득 소리를 재생합니다."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "소매치기 소리 사용"
L["OPTIONS_MINIMUM_QUALITY"] = "최소 품질"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "획득 알림 사용"
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "획득 시 귀속 아이템 항상 표시"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "퀘스트 아이템 항상 표시"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "제조법 항상 표시"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "탈것 항상 표시"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "애완동물 항상 표시"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "열쇠 항상 표시"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "가방 항상 표시"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "상자 항상 표시"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "골드 항상 표시"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "최대 표시 개수"
L["OPTIONS_UNLIMITED"] = "무제한"
L["OPTIONS_LOOT_TOAST_DURATION"] = "화면 표시 시간(초)"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "확장 방향"
L["OPTIONS_GROW_UP"] = "위로"
L["OPTIONS_GROW_DOWN"] = "아래로"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "항목 정렬"
L["OPTIONS_ALIGN_LEFT"] = "왼쪽"
L["OPTIONS_ALIGN_RIGHT"] = "오른쪽"
L["OPTIONS_LOOT_TOAST_FONT"] = "글꼴"
L["OPTIONS_FONT_DEFAULT"] = "기본값"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "글꼴 크기"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "글꼴 외곽선"
L["OPTIONS_FONT_OUTLINE_NONE"] = "없음"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "외곽선"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "굵은 외곽선"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "단색"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "단색 외곽선"
L["OPTIONS_TOASTS_UNLOCK"] = "위치 잠금 해제"
L["OPTIONS_TOASTS_LOCK"] = "위치 잠금"
L["OPTIONS_TOASTS_RESET"] = "위치 초기화"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "클릭 + 드래그로 위치 지정"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "우클릭하여 잠금"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "획득 알림 끄기"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "예시 아이템"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 화면을 엽니다."

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"이 목록의 아이템은 건드리지 않습니다. 빠른 획득은 획득 창에 남겨두고, 자동 열기는 절대 열지 않습니다. 목록은 모든 캐릭터가 공유합니다."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "제외 목록 알림 사용"
L["OPTIONS_IGNORE_LIST_ADD"] = "아이템 추가"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] =
	"아이템을 여기로 끌어오거나, 아이템 링크 또는 아이템 ID를 붙여넣으세요."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "이 아이템을 제외 목록에서 제거합니다."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "기본값 복원"
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] =
	"기본 제외 목록을 복원할까요? 직접 추가한 아이템은 제거됩니다."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"공격대 우두머리가 떨어뜨립니다. 열지 않은 상자는 여전히 거래하거나 판매할 수 있으며, 내용물보다 비싼 경우가 많습니다."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"고유 퀘스트 아이템이 들어 있을 수 있습니다. 이미 갖고 있다면 열 때 오류가 날 수 있습니다."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"획득 시 귀속되는 제조법이 들어 있을 수 있습니다. 열지 않은 상자는 여전히 거래하거나 판매할 수 있습니다."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"획득 시 귀속되는 무기나 방어구가 들어 있을 수 있습니다. 열지 않은 상자는 여전히 거래하거나 판매할 수 있습니다."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"획득 시 귀속되는 축제 아이템이 들어 있을 수 있습니다. 열지 않은 상자는 여전히 거래하거나 판매할 수 있습니다."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"획득 시 귀속되는 아이템이 들어 있을 수 있습니다. 열지 않은 상자는 여전히 거래하거나 판매할 수 있습니다."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
