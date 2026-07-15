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
L["STATUS_PAUSED"] = "일시정지"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "자동 줍기가 활성화되었습니다. Open Sesame가 작동하려면 필요합니다."
L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지를 비활성화하는 옵션 포함)은 옵션 > 애드온 > Open Sesame에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] =
	"자동 열기가 가방에 최소 %d칸의 빈 공간이 생길 때까지 일시정지됩니다."
L["RESUMED"] = "자동 열기가 재개되었습니다."
L["INVENTORY_FULL"] = "가방이 가득 찼습니다!"
L["ITEM_WILL_AUTO_OPEN"] = "%s|1이;가; 잠금 해제되면 자동으로 열립니다."
L["ITEM_OPEN_MANUALLY"] =
	"%s|1은;는; 수동으로 열어야 합니다. 고유, 획득 시 귀속, 또는 임시 아이템을 포함하고 있거나 공격대 우두머리에게서 획득한 것일 수 있습니다."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "자동 열기"
L["AUTO_OPENING_DESC"] =
	"가방에 빈 공간이 최소 %d칸 이상일 때 조개와 잠금 해제된 상자를 자동으로 엽니다."
L["SPEEDY_LOOT"] = "빠른 전리품"
L["SPEEDY_LOOT_DESC"] = "전리품 창을 숨겨 거의 즉시 아이템을 획득합니다."
L["LOOT_SOUNDS"] = "전리품 소리"
L["LOOT_SOUNDS_DESC"] = "고급 이상 품질의 아이템을 획득할 때 특별한 소리를 재생합니다."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "좌클릭"
L["KEYBIND_RIGHT_CLICK"] = "우클릭"
L["KEYBIND_MIDDLE_CLICK"] = "가운데 클릭"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + 가운데 클릭"
L["ACTION_TOGGLE"] = "전환"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame 옵션"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"Open Sesame가 가방에 있는 조개, 자물쇠 상자, 잠금 해제된 상자를 자동으로 엽니다. 내장된 빠른 전리품 기능이 전리품 창을 숨겨 거의 즉시 획득할 수 있게 합니다. 클릭은 줄이고, 플레이는 늘리세요."
L["OPTIONS_ENABLE_WELCOME"] = "환영 메시지 활성화"
L["OPTIONS_ENABLE_MINIMAP"] = "미니맵 버튼 활성화"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "자물쇠 상자 알림 활성화"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "자동 열기 활성화"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "빠른 전리품 활성화"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "전리품 소리 활성화"
L["OPTIONS_LOOT_SOUND_THRESHOLD"] = "전리품 소리 최소 품질"
L["OPTIONS_TEST_LOOT_SOUND"] = "전리품 소리를 재생합니다."
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Open Sesame 옵션 창을 엽니다."
L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
