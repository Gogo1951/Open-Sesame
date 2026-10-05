local _, ns = ...

local GetClientHeader = ns.GetDiagnosticClientHeader

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

--[[
    Existence and shape checks only: read-only, no side effects, no protected
    calls. One row per API the add-on actually calls - Features/Utilities.lua,
    Features/Core.lua, Features/Auto-Opening.lua, Features/Speedy-Loot.lua,
    Features/Lockbox-Tooltips.lua, Options/Options-Utilities.lua and
    Options/Options.lua - plus the handful of client values they read. Every API
    reached through an availability guard carries a row here, so a FAIL names
    the guard that is about to take the fallback path rather than leaving it
    silent. Validate Data adds a row for each reader it uses.
]]
ns.DIAGNOSTIC_API_CHECKS = {
	-- { label, testFunction }
	{
		"C_AddOns.GetAddOnMetadata",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnMetadata) == "function"
		end,
	},
	{
		"C_AddOns.GetAddOnInfo",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnInfo) == "function"
		end,
	},
	{
		"C_AddOns.GetNumAddOns",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetNumAddOns) == "function"
		end,
	},
	{
		"C_AddOns.IsAddOnLoaded",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.IsAddOnLoaded) == "function"
		end,
	},
	{
		"C_Container.GetContainerNumSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumSlots) == "function"
		end,
	},
	{
		"C_Container.GetContainerNumFreeSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumFreeSlots) == "function"
		end,
	},
	{
		"C_Container.GetContainerItemID",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerItemID) == "function"
		end,
	},
	{
		"C_Container.GetContainerItemLink",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerItemLink) == "function"
		end,
	},
	{
		"C_Container.UseContainerItem",
		function()
			return type(C_Container) == "table" and type(C_Container.UseContainerItem) == "function"
		end,
	},
	{
		"C_Spell.GetSpellName",
		function()
			return type(C_Spell) == "table" and type(C_Spell.GetSpellName) == "function"
		end,
	},
	{
		"GetNumSkillLines",
		function()
			return type(GetNumSkillLines) == "function"
		end,
	},
	{
		"GetSkillLineInfo",
		function()
			return type(GetSkillLineInfo) == "function"
		end,
	},
	--[[
        The Lockpicking skill line's localized name is the only handle
        Features/Lockbox-Tooltips.lua has for finding the player's rank. A FAIL
        here means the requirement line goes neutral instead of green or red.
    ]]
	{
		"C_TradeSkillUI.GetTradeSkillDisplayName (skill line 633)",
		function()
			return type(C_TradeSkillUI) == "table"
				and type(C_TradeSkillUI.GetTradeSkillDisplayName) == "function"
				and type(C_TradeSkillUI.GetTradeSkillDisplayName(ns.SKILL_LINE_IDS.LOCKPICKING)) == "string"
		end,
	},
	{
		"C_Item.GetItemInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemInfo) == "function"
		end,
	},
	{
		"C_Item.GetItemInfoInstant",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemInfoInstant) == "function"
		end,
	},
	{
		"C_Item.GetItemInfoInstant icon (5th return)",
		function()
			return type(select(5, C_Item.GetItemInfoInstant(ns.ITEM_IDS.ICON_PROBE))) == "number"
		end,
	},
	-- Read by Validate Data and the Open Sesame Context probe.
	{
		"C_Item.DoesItemExistByID",
		function()
			return type(C_Item) == "table" and type(C_Item.DoesItemExistByID) == "function"
		end,
	},
	{
		"C_Item.RequestLoadItemDataByID",
		function()
			return type(C_Item) == "table" and type(C_Item.RequestLoadItemDataByID) == "function"
		end,
	},
	{
		"C_Spell.GetSpellInfo",
		function()
			return type(C_Spell) == "table" and type(C_Spell.GetSpellInfo) == "function"
		end,
	},
	{
		"C_Spell.GetSpellSubtext",
		function()
			return type(C_Spell) == "table" and type(C_Spell.GetSpellSubtext) == "function"
		end,
	},
	{
		"IsPlayerSpell",
		function()
			return type(IsPlayerSpell) == "function"
		end,
	},
	{
		"IsSpellKnown",
		function()
			return type(IsSpellKnown) == "function"
		end,
	},
	--[[
        Client strings the add-on reads rather than translates. ITEM_MIN_SKILL
        becomes the pattern that decides whether the client already states a
        lockbox's requirement, and the text before %s in the two LOOT_ITEM formats
        becomes the prefixes that identify the player's own loot. For these a FAIL means the feature
        goes quiet rather than errors: an unmatched pattern simply never matches.
        LOCKED below is the exception and says so.
    ]]
	{
		"ITEM_MIN_SKILL (global string)",
		function()
			return type(ITEM_MIN_SKILL) == "string"
		end,
	},
	-- A FAIL silences the loot sound: it cannot identify the player's own loot without these.
	{
		"LOOT_ITEM_SELF / LOOT_ITEM_PUSHED_SELF (global strings with %s)",
		function()
			return type(LOOT_ITEM_SELF) == "string"
				and type(LOOT_ITEM_PUSHED_SELF) == "string"
				and LOOT_ITEM_SELF:find("%s", 1, true) ~= nil
				and LOOT_ITEM_PUSHED_SELF:find("%s", 1, true) ~= nil
		end,
	},
	-- The one row whose FAIL is not silence: with no LOCKED, every box reads as unlocked and the queue tries to open boxes it cannot.
	{
		"LOCKED (global string)",
		function()
			return type(LOCKED) == "string"
		end,
	},
	{
		"GetNumLootItems",
		function()
			return type(GetNumLootItems) == "function"
		end,
	},
	{
		"GetLootSourceInfo",
		function()
			return type(GetLootSourceInfo) == "function"
		end,
	},
	{
		"GetLootSlotType",
		function()
			return type(GetLootSlotType) == "function"
		end,
	},
	{
		"securecallfunction",
		function()
			return type(securecallfunction) == "function"
		end,
	},
	{
		"GetLootSlotInfo",
		function()
			return type(GetLootSlotInfo) == "function"
		end,
	},
	{
		"GetLootSlotLink",
		function()
			return type(GetLootSlotLink) == "function"
		end,
	},
	{
		"GetLootThreshold",
		function()
			return type(GetLootThreshold) == "function"
		end,
	},
	{
		"LootSlot",
		function()
			return type(LootSlot) == "function"
		end,
	},
	{
		"IsModifiedClick",
		function()
			return type(IsModifiedClick) == "function"
		end,
	},
	{
		"C_PartyInfo.GetLootMethod",
		function()
			return type(C_PartyInfo) == "table" and type(C_PartyInfo.GetLootMethod) == "function"
		end,
	},
	{
		"C_CVar.GetCVar",
		function()
			return type(C_CVar) == "table" and type(C_CVar.GetCVar) == "function"
		end,
	},
	{
		"C_CVar.GetCVarBool",
		function()
			return type(C_CVar) == "table" and type(C_CVar.GetCVarBool) == "function"
		end,
	},
	{
		"C_CVar.SetCVar",
		function()
			return type(C_CVar) == "table" and type(C_CVar.SetCVar) == "function"
		end,
	},
	{
		"UnitCastingInfo",
		function()
			return type(UnitCastingInfo) == "function"
		end,
	},
	{
		"UnitChannelInfo",
		function()
			return type(UnitChannelInfo) == "function"
		end,
	},
	{
		"IsStealthed",
		function()
			return type(IsStealthed) == "function"
		end,
	},
	{
		"C_UnitAuras.GetBuffDataByIndex",
		function()
			return type(C_UnitAuras) == "table" and type(C_UnitAuras.GetBuffDataByIndex) == "function"
		end,
	},
	{
		"C_Secrets.ShouldAurasBeSecret",
		function()
			return type(C_Secrets) == "table" and type(C_Secrets.ShouldAurasBeSecret) == "function"
		end,
	},
	{
		"C_Secrets.ShouldUnitSpellCastingBeSecret",
		function()
			return type(C_Secrets) == "table" and type(C_Secrets.ShouldUnitSpellCastingBeSecret) == "function"
		end,
	},
	{
		"C_EventUtils.IsEventValid",
		function()
			return type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
		end,
	},
	{
		"C_Timer.After",
		function()
			return type(C_Timer) == "table" and type(C_Timer.After) == "function"
		end,
	},
	--[[
        One of three availability guards, alongside the skill-line API and the
        loot-slot item value; this one sits in ns:OpenOptionsPanel. A FAIL means
        the options panel falls through to AceConfigDialog:Open and opens as a
        floating window instead of docking into the Settings tree.
    ]]
	{
		"Settings.OpenToCategory",
		function()
			return type(Settings) == "table" and type(Settings.OpenToCategory) == "function"
		end,
	},
	--[[
        Both halves of the loot-slot pair Features/Utilities.lua picks between,
        then the value it settled on. One half FAILs on every client; the pair
        shows which branch this one took.
    ]]
	{
		"Enum.LootSlotType.Item",
		function()
			return type(Enum) == "table" and type(Enum.LootSlotType) == "table" and Enum.LootSlotType.Item ~= nil
		end,
	},
	{
		"LOOT_SLOT_ITEM",
		function()
			return LOOT_SLOT_ITEM ~= nil
		end,
	},
	{
		"Loot slot item type (resolved)",
		function()
			return type(ns.LOOT_SLOT_TYPE_ITEM) == "number"
		end,
	},
	{
		"LE_GAME_ERR_INV_FULL",
		function()
			return LE_GAME_ERR_INV_FULL ~= nil
		end,
	},
	--[[
        Both drive the Notifications panel's quality dropdown at file scope. The
        colour table is probed for its `hex` field rather than mere existence: a shape
        change is what would actually break the panel, and an existence check
        would pass straight through it.
    ]]
	{
		"ITEM_QUALITY_COLORS",
		function()
			return type(ITEM_QUALITY_COLORS) == "table"
				and type(ITEM_QUALITY_COLORS[4]) == "table"
				and type(ITEM_QUALITY_COLORS[4].hex) == "string"
		end,
	},
	{
		"ITEM_QUALITY0_DESC .. ITEM_QUALITY4_DESC (global strings)",
		function()
			return type(ITEM_QUALITY0_DESC) == "string"
				and type(ITEM_QUALITY1_DESC) == "string"
				and type(ITEM_QUALITY2_DESC) == "string"
				and type(ITEM_QUALITY3_DESC) == "string"
				and type(ITEM_QUALITY4_DESC) == "string"
		end,
	},
}

--------------------------------------------------------------------------------
-- Open Sesame Context
--------------------------------------------------------------------------------

--[[
    The state behind most "nothing happens" reports, in one read-only probe:
    who the player is and what Lockpicking rank the add-on reads, the loot
    method Speedy Loot's master-looter stand-down depends on, the Auto Loot CVar
    both features need, the add-on's own runtime flags, and every openable
    container in the bags with the verdict the opening queue would act on.
]]

-- The master-loot value Speedy Loot compares C_PartyInfo.GetLootMethod's number against.
local LOOT_METHOD_MASTER = 2

local function PackReturns(...)
	return select("#", ...), { ... }
end

-- One TSV cell: tabs and newlines would break the row, and a raw pipe would render a link.
local function CellText(value)
	if value == nil then
		return ""
	end
	local text = tostring(value):gsub("[\t\r\n]", " ")
	return (text:gsub("|", "||"))
end

local function AppendPlayer(lines)
	local className, classToken = UnitClass("player")
	lines[#lines + 1] = string.format(
		"Class: %s (%s) // Level: %s",
		tostring(className),
		tostring(classToken),
		tostring(UnitLevel("player"))
	)
	for _, key in ipairs({ "PICK_LOCK", "PICK_POCKET", "SHADOWMELD" }) do
		local spellId = ns.SPELLS[key]
		lines[#lines + 1] = string.format(
			"%s %s: name=%s IsPlayerSpell=%s",
			key,
			tostring(spellId),
			tostring(spellId and C_Spell.GetSpellName(spellId)),
			tostring(spellId and IsPlayerSpell(spellId))
		)
	end
	local rank = ns.GetPlayerLockpickingSkill()
	lines[#lines + 1] = "Lockpicking rank as the add-on reads it: "
		.. (rank and tostring(rank) or "unavailable on this client (or not trained)")
end

local function AppendLootMethod(lines)
	local count, values = PackReturns(C_PartyInfo.GetLootMethod())
	lines[#lines + 1] = string.format("C_PartyInfo.GetLootMethod() -> %d value(s):", count)
	for index = 1, count do
		lines[#lines + 1] = string.format("  [%d] (%s) %s", index, type(values[index]), tostring(values[index]))
	end
	local method, masterLooterPartyID = values[1], values[2]
	lines[#lines + 1] = string.format(
		"Speedy Loot reads lootMethod=%s, masterLooterPartyID=%s -> isMasterLooter=%s",
		tostring(method),
		tostring(masterLooterPartyID),
		tostring(method == LOOT_METHOD_MASTER and masterLooterPartyID == 0)
	)
	lines[#lines + 1] = string.format("GetLootThreshold() = %s", tostring(GetLootThreshold()))
end

local function AppendState(lines)
	lines[#lines + 1] = string.format(
		"autoLootDefault = %s (GetCVarBool: %s)",
		tostring(C_CVar.GetCVar("autoLootDefault")),
		tostring(C_CVar.GetCVarBool("autoLootDefault"))
	)
	lines[#lines + 1] = string.format(
		"Auto-Opening enabled: %s // paused: %s // Speedy Loot: %s // free bag slots: %s (pauses below %s)",
		tostring(ns.isEnabled),
		tostring(ns.isPaused),
		tostring(ns.isSpeedyLoot),
		tostring(ns.GetFreeSlots()),
		tostring(ns.MIN_FREE_SLOTS)
	)
end

--[[
    The tooltip line count is what separates a genuinely unlocked box from a
    scan tooltip that read nothing at all: both answer "not locked".
]]
local function AppendLockedBoxes(lines)
	lines[#lines + 1] = "BAG\tSLOT\tITEM_ID\tLINK\tOPENS_WITHOUT_UNLOCK\tIGNORED\tLOCKED\tTOOLTIP_LINES"
	local found = 0
	for bag = 0, 4 do
		for slot = 1, ns.GetContainerNumSlots(bag) or 0 do
			local itemId = ns.GetContainerItemID(bag, slot)
			local allowed = itemId and ns.ALLOWED_ITEMS[itemId]
			if allowed ~= nil then
				found = found + 1
				local locked, lineCount = ns.IsItemLocked(bag, slot)
				lines[#lines + 1] = table.concat({
					bag,
					slot,
					itemId,
					CellText(ns.GetContainerItemLink(bag, slot)),
					tostring(allowed),
					tostring(ns:IsIgnored(itemId)),
					tostring(locked),
					tostring(lineCount),
				}, "\t")
			end
		end
	end
	if found == 0 then
		lines[#lines + 1] = "(no openable containers in bags 0 to 4)"
	end
end

function ns:BuildOpenSesameContextReport()
	local lines = { GetClientHeader(), "" }
	AppendPlayer(lines)
	lines[#lines + 1] = ""
	AppendLootMethod(lines)
	lines[#lines + 1] = ""
	AppendState(lines)
	lines[#lines + 1] = ""
	AppendLockedBoxes(lines)
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Data Sources
--------------------------------------------------------------------------------

--[[
    One entry per file in the flavor folder this client loaded, labeled by the
    file's name without its folder suffix. Each source names a static table on
    ns, its kind ("item", "spell", or "other" for IDs no client API looks up,
    which are only counted), how to reach each row's id (rowId(key, value) over
    the table's pairs), and the row's own values as DATA_* columns. Adding a
    data file adds an entry here, and the panel and the validator pick it up
    with no second list.
]]
local function KeyIsId(key)
	return key
end

local function ValueIsId(_, value)
	return value
end

local function RowValue(_, value)
	return value
end

local function KeyValue(key)
	return key
end

ns.DIAGNOSTIC_DATA_SOURCES = {
	-- { label, sources = { { table, kind, rowId, dataColumns } } }
	{
		label = "Openable-Items",
		sources = {
			{
				table = "ALLOWED_ITEMS",
				kind = "item",
				rowId = KeyIsId,
				dataColumns = { { "DATA_OPENS_WITHOUT_UNLOCK", RowValue } },
			},
		},
	},
	{
		label = "Lockbox-Skill-Levels",
		sources = {
			{
				table = "LOCKBOX_SKILL_LEVELS",
				kind = "item",
				rowId = KeyIsId,
				dataColumns = { { "DATA_REQUIRED_SKILL", RowValue } },
			},
		},
	},
	{
		label = "Default-Ignore-Items",
		sources = {
			{
				table = "DEFAULT_IGNORE_ITEMS",
				kind = "item",
				rowId = KeyIsId,
				dataColumns = { { "DATA_REASON", RowValue } },
			},
		},
	},
	{
		label = "Spells",
		sources = {
			{ table = "SPELLS", kind = "spell", rowId = ValueIsId, dataColumns = { { "DATA_KEY", KeyValue } } },
		},
	},
	{
		label = "Game-IDs",
		sources = {
			{ table = "SKILL_LINE_IDS", kind = "other", rowId = ValueIsId, dataColumns = { { "DATA_KEY", KeyValue } } },
			{ table = "ITEM_IDS", kind = "item", rowId = ValueIsId, dataColumns = { { "DATA_KEY", KeyValue } } },
			{ table = "SOUND_KIT_IDS", kind = "other", rowId = ValueIsId, dataColumns = { { "DATA_KEY", KeyValue } } },
		},
	},
}
