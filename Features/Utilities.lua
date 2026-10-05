local _, ns = ...

local L = ns.L

--------------------------------------------------------------------------------
-- C_Container API
--------------------------------------------------------------------------------

--[[
    All three target clients (Classic Era, TBC Anniversary, WoW Forever) ship
    the C_Container namespace and have already removed the identically-named
    legacy globals, so there is nothing to select between: these are cached
    function references, unguarded. Diagnostics' API Endpoints report probes each one, so
    a future client that drops a member shows up as a FAIL row rather than as a
    silently dead fallback.
]]
ns.GetContainerNumSlots = C_Container.GetContainerNumSlots
ns.UseContainerItem = C_Container.UseContainerItem
ns.GetContainerItemLink = C_Container.GetContainerItemLink
ns.GetContainerItemID = C_Container.GetContainerItemID
ns.GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

--------------------------------------------------------------------------------
-- Auto Loot
--------------------------------------------------------------------------------

local GetCVarBool, SetCVar = C_CVar.GetCVarBool, C_CVar.SetCVar

function ns.EnsureAutoLoot()
	if not GetCVarBool("autoLootDefault") then
		SetCVar("autoLootDefault", "1")
		ns:PrintMessage(L["AUTO_LOOT_ENABLED"])
	end
end

--------------------------------------------------------------------------------
-- Bag-Full Error
--------------------------------------------------------------------------------

--[[
    All three target clients carry the inventory-full message id as the
    LE_GAME_ERR_INV_FULL global, which the API Endpoints report proves on each.
    Since that global is a number, comparing a non-number errorID against it is
    already false, so no type guard is needed. This is the only inventory-full test in the add-on —
    the handler and Diagnostics' event-log filter both classify UI_ERROR_MESSAGE
    through it, so a firing can never pause the add-on while the log files it
    away as uncorrelated noise. Never add a message-text match beside it: the
    two would disagree exactly when a bug report needs the log line.
]]
function ns.IsBagFullErrorID(errorID)
	return errorID == LE_GAME_ERR_INV_FULL
end

--------------------------------------------------------------------------------
-- Scan Tooltip
--------------------------------------------------------------------------------

local scanTooltip = CreateFrame("GameTooltip", "OpenSesameScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

--[[
    Does a tooltip carry this exact line? Split out from the scanner below so the
    reading and the scanning are separable.

    Matched against the WHOLE line, never as a substring: LOCKED is a short word,
    and other add-ons write lines that contain it without meaning it.
]]
local function TooltipHasLine(tooltip, needle)
	local tooltipName = tooltip:GetName()
	if not tooltipName or not needle then
		return false
	end
	for lineIndex = 1, tooltip:NumLines() do
		local line = _G[tooltipName .. "TextLeft" .. lineIndex]
		local text = line and line:GetText()
		if text and text == needle then
			return true
		end
	end
	return false
end

--[[
    The same question asked of a bag slot, for callers with no tooltip to read:
    the opening queue in Features/Auto-Opening.lua, the mini-map's Locked Items
    list, and Diagnostics' Locked Boxes probe. One scan tooltip, one
    implementation — a second copy would drift.

    THE OWNER IS SET ON EVERY CALL, not once at file scope, and that is
    load-bearing: hiding a tooltip drops its owner, and an unowned tooltip takes a
    SetBagItem without complaint and populates NOTHING. Every box then reads as
    unlocked: no Locked Items list on the mini-map and no tooltip line.

    Setting a tooltip also shows it, hence that Hide: this one is anchored nowhere
    in particular and has no business being on screen. Shown and hidden inside a
    single frame, it never renders.

    The second return is the tooltip's line count, for Diagnostics' Locked Boxes
    probe: zero lines means the tooltip read nothing, which also answers "not
    locked".
]]
function ns.IsItemLocked(bag, slot)
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetBagItem(bag, slot)
	local locked = TooltipHasLine(scanTooltip, LOCKED)
	local lineCount = scanTooltip:NumLines()
	scanTooltip:Hide()
	return locked, lineCount
end

--[[
    An item's or spell's tooltip as plain lines, for Validate Data, a right-hand
    column kept after " >> ". kind is "item" or "spell". C_TooltipInfo hands the
    lines over as data where the client ships both its GetItemByID and
    GetSpellByID getters (WoW Forever); elsewhere they are read off the scan
    tooltip. Color escapes are stripped so each line reads as its words. A read
    can throw on an odd id, so callers protect it.
]]
local TOOLTIP_DATA_GETTERS = C_TooltipInfo
	and C_TooltipInfo.GetItemByID
	and C_TooltipInfo.GetSpellByID
	and { item = C_TooltipInfo.GetItemByID, spell = C_TooltipInfo.GetSpellByID }

local function PlainText(text)
	if type(text) ~= "string" then
		return nil
	end
	return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|cn[^:]*:", ""):gsub("|r", ""))
end

local function JoinTooltipLine(left, right)
	left = PlainText(left) or ""
	right = PlainText(right)
	if right and right ~= "" then
		return left .. " >> " .. right
	end
	return left
end

local function ReadTooltipData(kind, identifier)
	local lines = {}
	local data = TOOLTIP_DATA_GETTERS[kind](identifier)
	for _, line in ipairs(data and data.lines or {}) do
		lines[#lines + 1] = JoinTooltipLine(line.leftText, line.rightText)
	end
	return lines
end

local function ReadScanTooltip(kind, identifier)
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetHyperlink(kind .. ":" .. identifier)
	local tooltipName = scanTooltip:GetName()
	local lines = {}
	for lineIndex = 1, scanTooltip:NumLines() do
		local left = _G[tooltipName .. "TextLeft" .. lineIndex]
		local right = _G[tooltipName .. "TextRight" .. lineIndex]
		lines[#lines + 1] = JoinTooltipLine(left and left:GetText(), right and right:IsShown() and right:GetText())
	end
	scanTooltip:Hide()
	return lines
end

ns.GetTooltipLines = TOOLTIP_DATA_GETTERS and ReadTooltipData or ReadScanTooltip

--[[
    An item's stat table, for Validate Data. WoW Forever ships C_Item.GetItemStats;
    Classic Era and TBC Anniversary have only the legacy global GetItemStats,
    which returns the same table.
]]
ns.GetItemStats = C_Item.GetItemStats or GetItemStats

--------------------------------------------------------------------------------
-- Loot Slot Type
--------------------------------------------------------------------------------

--[[
    GetLootSlotType's "regular item" value. WoW Forever runs the Retail engine,
    which dropped the LOOT_SLOT_ITEM global for Enum.LootSlotType.Item. Picked by
    which table exists, never by what it holds.
]]
if type(Enum) == "table" and type(Enum.LootSlotType) == "table" then
	ns.LOOT_SLOT_TYPE_ITEM = Enum.LootSlotType.Item
else
	ns.LOOT_SLOT_TYPE_ITEM = LOOT_SLOT_ITEM
end

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    The raw hex palette lives in Data/Data.lua (ns.PALETTE). Per the style guide,
    data files hold no logic, so deriving the usable color-escape table from the
    palette happens here.
]]
local COLOR_PREFIX = "|cff"

local COLORS = {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = COLOR_PREFIX .. hex
end

--------------------------------------------------------------------------------
-- Color and Icon Accessors
--------------------------------------------------------------------------------

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end

--[[
    An item's icon from C_Item.GetItemInfoInstant, which answers from the
    client's own database with no cold-cache nil, so the icon is there the first
    time an item is drawn.
]]
function ns.GetItemIconByID(itemId)
	if not itemId then
		return nil
	end
	local _, _, _, _, icon = C_Item.GetItemInfoInstant(itemId)
	return icon
end

--------------------------------------------------------------------------------
-- Skill Lines
--------------------------------------------------------------------------------

--[[
    A skill line's current rank, found by its localized name. WoW Forever has no
    skill-line API, so there this answers nil, which every caller already treats
    as unknown.
]]
local GetNumSkillLines, GetSkillLineInfo = GetNumSkillLines, GetSkillLineInfo

function ns.GetSkillLineRank(skillName)
	if not skillName or not GetNumSkillLines or not GetSkillLineInfo then
		return nil
	end
	for index = 1, GetNumSkillLines() do
		local lineName, isHeader, _, rank = GetSkillLineInfo(index)
		if not isHeader and lineName == skillName then
			return rank
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Lockbox Feature Scope
--------------------------------------------------------------------------------

--[[
    Both lockbox features carry a scope alongside their toggle: "ROGUES" shows
    them only to a Rogue, "ALL" to everyone. A non-Rogue cannot pick a lock, so
    Rogues-only is the default for both.

    The scope rule lives here so both features apply the same one:
    Auto-Opening for the looted-lockbox notice, Lockbox-Tooltips for the
    tooltip line. Each feature keeps its own on/off predicate beside the code
    that reads it.
]]
function ns.IsPlayerRogue()
	return select(2, UnitClass("player")) == "ROGUE"
end

function ns.LockboxScopeAllows(scope)
	return scope ~= "ROGUES" or ns.IsPlayerRogue()
end

--------------------------------------------------------------------------------
-- Client Format Strings
--------------------------------------------------------------------------------

--[[
    Turns one of the client's own format strings into a Lua pattern that captures
    what the client would have filled in. This is how the add-on reads the game's
    words in any locale without shipping a translation of them: ITEM_MIN_SKILL
    becomes the requirement line's skill and number.

    Escape the magic characters first, deliberately leaving % alone so the format's
    own %s and %d survive to become captures on the next two lines. Matching a
    literal %s needs the pattern "%%s", not "%%%%s".
]]
function ns.BuildFormatPattern(format)
	if not format then
		return nil
	end
	local pattern = format:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
	pattern = pattern:gsub("%%s", "(.+)")
	pattern = pattern:gsub("%%d", "(%%d+)")
	return pattern
end

--------------------------------------------------------------------------------
-- Item Quality and Bag Space
--------------------------------------------------------------------------------

--[[
    An item link's colour is the only quality signal available without a
    C_Item.GetItemInfo round trip. The Retail engine (WoW Forever) writes it as a
    |cnIQn: escape whose n is the quality itself; Classic clients write a hex
    colour, which ns.QUALITY_COLORS maps. Returns nil for a colour the table does
    not carry (quest yellow, say) - callers decide whether unknown means show or
    stay quiet.
]]
function ns.GetLinkQuality(link)
	if not link then
		return nil
	end
	local qualityEscape = link:match("|cnIQ(%d+):")
	if qualityEscape then
		return tonumber(qualityEscape)
	end
	local colorSequence = link:match("|c(%x+)|H")
	if not colorSequence or #colorSequence ~= 8 then
		return nil
	end
	return ns.QUALITY_COLORS[string.lower(string.sub(colorSequence, 3, 8))]
end

-- 1240 as "1,240", for Diagnostic Tools' progress and tallies.
function ns:FormatCommaNumber(number)
	return (tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

function ns.GetFreeSlots()
	local free = 0
	for bag = 0, 4 do
		local slotCount, family = ns.GetContainerNumFreeSlots(bag)
		if (family == nil or family == 0) and slotCount then
			free = free + slotCount
		end
	end
	return free
end
