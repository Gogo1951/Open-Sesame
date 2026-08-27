-- .luacheckrc
std = "lua51"
max_line_length = false -- StyLua owns formatting
ignore = { "212/self", "611", "612", "613", "614", "621" } -- implicit self (house ns: methods) + whitespace — StyLua owns the latter
exclude_files = { "Includes/" } -- vendored, never linted
read_globals = {
	-- Libraries
	"LibStub",

	-- Namespaces
	"C_AddOns",
	"C_CVar",
	"C_Container",
	"C_EventUtils",
	"C_PartyInfo",
	"C_Timer",
	"C_UnitAuras",
	"Settings",

	-- Client info, timing, and add-on metadata
	"GetBuildInfo",
	"GetLocale",
	"GetTime",
	"WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
	"WOW_PROJECT_CLASSIC",
	"WOW_PROJECT_ID",

	-- Frames and UI
	"AuctionFrame",
	"BankFrame",
	"CreateFrame",
	"DEFAULT_CHAT_FRAME",
	"GameFontNormal",
	"GameTooltip",
	"GetPhysicalScreenSize",
	"GossipFrame",
	"GuildBankFrame",
	"LootFrame",
	"MailFrame",
	"MerchantFrame",
	"QuestFrame",
	"StaticPopup1",
	"TradeFrame",
	"UIParent",
	"WorldFrame",

	-- Spells
	"GetSpellInfo",

	-- Items
	"GetItemIcon",
	"GetItemInfo",
	"GetItemInfoInstant",

	-- Loot
	"GetLootSlotLink",
	"GetLootSlotType",
	"GetLootSourceInfo",
	"GetLootThreshold",
	"GetNumLootItems",
	"LootSlot",
	"LOOT_SLOT_ITEM",

	-- Player state
	"GetNumSkillLines",
	"GetSkillLineInfo",
	"InCombatLockdown",
	"IsInGroup",
	"IsInInstance",
	"IsModifiedClick",
	"IsShiftKeyDown",
	"IsStealthed",
	"UnitAffectingCombat",
	"UnitCastingInfo",
	"UnitChannelInfo",
	"UnitClass",
	"UnitRace",
	"UnitSex",

	-- Sound
	"PlaySound",
	"PlaySoundFile",

	-- Tooltips
	"hooksecurefunc",

	-- Localized client strings and enums
	"ITEM_QUALITY0_DESC",
	"ITEM_QUALITY1_DESC",
	"ITEM_QUALITY2_DESC",
	"ITEM_QUALITY3_DESC",
	"ITEM_QUALITY4_DESC",
	"ITEM_MIN_SKILL",
	"ITEM_STARTS_QUEST",
	"GOLD_AMOUNT",
	"SILVER_AMOUNT",
	"COPPER_AMOUNT",
	"GOLD_AMOUNT_SYMBOL",
	"SILVER_AMOUNT_SYMBOL",
	"COPPER_AMOUNT_SYMBOL",
	"ITEM_QUALITY_COLORS",
	"LE_GAME_ERR_INV_FULL",
	"LOCKED",
	"LOOT_ITEM_PUSHED_SELF",
	"LOOT_ITEM_SELF",

	-- Lua 5.1 globals the client provides
	"wipe",
}
globals = {
	-- The add-on's own sanctioned globals: its SavedVariables table and its
	-- slash registration. Nothing else.
	"OpenSesameDB",
	"SLASH_OPENSESAME1",
	"SlashCmdList",
}
