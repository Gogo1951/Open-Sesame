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
L["CHAT_END_OF_SUPPORT"] =
	"지원 종료: 이 애드온은 이제 GogoLoot의 일부가 되었으며, 이번이 마지막 버전입니다. 업데이트를 계속 받으려면 GogoLoot를 설치하세요. 그 후에는 Open Sesame를 삭제해도 됩니다."

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "가방 빈 칸이 %d칸 이상 생길 때까지 자동 열기가 일시 중지됩니다."
L["RESUMED"] = "자동 열기가 재개되었습니다."
L["INVENTORY_FULL"] = "가방이 가득 찼습니다!"
L["ITEM_WILL_AUTO_OPEN"] = "%s은(는) 잠금이 풀리는 즉시 자동으로 열립니다."
L["ITEM_IGNORED"] = "%s은(는) 제외 목록에 있어 자동 열기가 건드리지 않습니다."
L["ITEM_OPEN_MANUALLY"] = "%s은(는) 제외 목록에 있어 빠른 획득이 획득 창에 남겨두었습니다."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "자동 열기"
L["AUTO_OPENING_DESCRIPTION"] =
	"가방 빈 칸이 %d칸 이상일 때 조개와 잠기지 않은 상자를 자동으로 엽니다."
L["SPEEDY_LOOT"] = "빠른 획득"
L["SPEEDY_LOOT_DESCRIPTION"] = "획득 창을 숨겨 거의 즉시 아이템을 획득합니다."
L["NOTIFICATIONS_DESCRIPTION"] =
	"빠른 획득이 획득 창을 숨기므로, 이 소리로 방금 무엇을 주웠는지 알 수 있습니다."
L["LOCKBOXES_DESCRIPTION"] =
	"잠긴 상자는 도적의 자물쇠 따기 숙련이 있어야 열 수 있습니다. 이 설정은 각 상자에 필요한 수치를 보여주고, 기다리는 상자가 있으면 알려줍니다."
L["LOOT_SOUNDS"] = "획득 소리"
L["LOOT_SOUNDS_DESCRIPTION"] = "선택한 품질 이상의 아이템을 획득하면 소리를 재생합니다."

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
	"가방 속 조개, 상자, 자물쇠를 딴 잠긴 상자를 클릭 없이 자동으로 엽니다. 빠른 획득이 획득 창을 숨겨 자동 획득을 더 빠르게 합니다. 빠르고 효율적인 획득."
L["OPTIONS_ENABLE_WELCOME"] = "시작 메시지 사용"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"접속할 때마다 대화창에 버전과 짧은 환영 인사를 표시합니다."
L["OPTIONS_ENABLE_MINIMAP"] = "미니맵 버튼 사용"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "미니맵에 Open Sesame 버튼을 표시합니다."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 화면을 엽니다."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "자동 열기 사용"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] =
	"조개와 잠기지 않은 상자를 자동으로 여는 기능을 켜거나 끕니다."
L["OPTIONS_AUTO_OPENING_WHERE"] = "장소"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] =
	"상자를 모든 장소에서 열지, 인스턴스 밖에서만 열지 선택합니다."
L["OPTIONS_ANYWHERE"] = "모든 장소"
L["OPTIONS_OUTSIDE_INSTANCES"] = "인스턴스 밖에서만"
L["OPTIONS_AUTO_OPENING_GROUP"] = "파티"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"파티 중에도 상자를 열지, 혼자 플레이할 때만 열지 선택합니다."
L["OPTIONS_SOLO_OR_GROUPED"] = "솔로 또는 파티"
L["OPTIONS_SOLO_ONLY"] = "솔로일 때만"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "빠른 획득 사용"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"모든 전리품을 한 번에 획득하고 획득 창을 숨깁니다. 가방에 들어가지 않거나 제외 목록에 있는 아이템이 있을 때만 획득 창이 열려 있습니다."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "잠긴 상자 툴팁 사용"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] =
	"각 잠긴 상자의 툴팁에 필요한 자물쇠 따기 숙련도를 추가합니다."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"잠긴 상자 툴팁을 도적에게만 표시할지 모든 캐릭터에게 표시할지 선택합니다."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "잠긴 상자 알림 사용"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"잠금이 풀리면 열리게 될 잠긴 상자를 획득하면 대화창으로 알려줍니다."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"잠긴 상자 알림을 도적에게만 표시할지 모든 캐릭터에게 표시할지 선택합니다."
L["OPTIONS_SHOW_FOR"] = "표시 대상"
L["OPTIONS_FOR_ROGUES"] = "도적만"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "모든 캐릭터"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "획득 소리 사용"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"시체나 상자에서 최소 품질 이상의 아이템을 획득하면 알림음을 재생합니다."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "획득 소리를 재생하는 가장 낮은 아이템 품질입니다."
L["OPTIONS_TEST_LOOT_SOUND"] = "획득 소리를 재생합니다."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "소매치기 소리 사용"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] =
	"소매치기로 실제로 무언가를 훔쳤을 때 가방 소리를 재생합니다."
L["OPTIONS_MINIMUM_QUALITY"] = "최소 품질"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"이 목록의 아이템은 건드리지 않습니다. 빠른 획득은 획득 창에 남겨두고, 자동 열기는 절대 열지 않습니다. 목록은 모든 캐릭터가 공유합니다."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "제외 목록 알림 사용"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"아이템이 제외 목록에 있어 Open Sesame가 건드리지 않았을 때 대화창으로 알려줍니다."
L["OPTIONS_IGNORE_LIST_ADD"] = "아이템 추가"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] =
	"아이템을 여기로 끌어오거나, 아이템 링크 또는 아이템 ID를 붙여넣으세요."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "이 아이템을 제외 목록에서 제거합니다."
L["OPTIONS_ITEM_LOADING"] = "아이템 %d 불러오는 중..."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "기본값 복원"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"제외 목록을 기본 목록으로 바꾸고, 직접 추가한 아이템을 제거합니다."
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
L["OPTIONS_VERSION"] = "버전 %s"
