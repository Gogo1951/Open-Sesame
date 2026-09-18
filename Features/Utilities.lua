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
    Does a tooltip carry this exact line? Split out from the two scanners below so
    the reading and the scanning are separable.

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
    "Does this item begin a quest", which the client will say in a tooltip and
    nowhere else: no API on any target client flags it, and the item's CLASS
    does not give it away either, since quest starters are ordinary weapons,
    armour and trinkets as often as they are class 12. Read by hyperlink because
    the caller has an item, not a bag slot -- this is asked of loot, which may
    never reach the bags at all.

    The scan is the most expensive question Loot Toasts asks, so it is also the
    last one asked: everything cheaper has already failed by the time it runs, and
    it only runs for loot the quality threshold would otherwise have hidden.
]]
function ns.ItemStartsQuest(itemId)
	if not itemId then
		return false
	end
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetHyperlink("item:" .. itemId)
	local startsQuest = TooltipHasLine(scanTooltip, ITEM_STARTS_QUEST)
	scanTooltip:Hide()
	return startsQuest
end

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

--[[
    The coin colours get the same treatment from their own table. They are kept
    apart from the palette above because they are not the add-on's to choose: gold,
    silver and copper look the way the client makes them look everywhere else.
]]
local MONEY_COLORS = {}
for key, hex in pairs(ns.MONEY_PALETTE) do
	MONEY_COLORS[key] = COLOR_PREFIX .. hex
end

--------------------------------------------------------------------------------
-- Utility Functions
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
    becomes the requirement line's skill and number, GOLD_AMOUNT becomes the coin
    count in a loot message.

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
-- Money
--------------------------------------------------------------------------------

local goldPattern = ns.BuildFormatPattern(GOLD_AMOUNT)
local silverPattern = ns.BuildFormatPattern(SILVER_AMOUNT)
local copperPattern = ns.BuildFormatPattern(COPPER_AMOUNT)

--[[
    Reads a coin total out of a loot message ("You loot 1 Gold 24 Silver 7
    Copper"). The client hands over the sentence, not the number, so the number
    has to come back out of it -- and matching against the client's OWN
    GOLD_AMOUNT / SILVER_AMOUNT / COPPER_AMOUNT formats is what makes that work in
    every locale rather than only in English. A unit the message does not mention
    simply does not match, which is the same as none of it.
]]
function ns.ParseMoney(message)
	if not message then
		return 0
	end
	local gold = goldPattern and tonumber(message:match(goldPattern)) or 0
	local silver = silverPattern and tonumber(message:match(silverPattern)) or 0
	local copper = copperPattern and tonumber(message:match(copperPattern)) or 0
	return (gold * ns.COPPER_PER_GOLD) + (silver * ns.COPPER_PER_SILVER) + copper
end

--[[
    One coin: the amount in body white, then its unit in that coin's own colour.
    Splitting the colour at the letter is what makes a stack of these readable --
    the numbers line up as one column of white, and the eye picks the unit off the
    colour without reading the letter at all.

    The symbol is the client's own, so this reads right in a locale that does not
    call them gold, silver and copper.
]]
local function Coin(amount, digits, symbol, colorKey)
	return COLORS.BODY .. string.format(digits, amount) .. "|r" .. MONEY_COLORS[colorKey] .. symbol .. "|r"
end

--[[
    "123g 02s 27c" - the largest unit the amount reaches, then every unit below it
    padded to two digits, and nothing above it. Padding only the lower units is
    what lines the numbers up when several toasts stack, while a leading "0g" on
    small change would be noise.
]]
function ns.FormatMoney(copper)
	copper = copper or 0
	local gold = math.floor(copper / ns.COPPER_PER_GOLD)
	local silver = math.floor((copper % ns.COPPER_PER_GOLD) / ns.COPPER_PER_SILVER)
	local remainder = copper % ns.COPPER_PER_SILVER
	if gold > 0 then
		return Coin(gold, "%d", GOLD_AMOUNT_SYMBOL, "GOLD")
			.. " "
			.. Coin(silver, "%02d", SILVER_AMOUNT_SYMBOL, "SILVER")
			.. " "
			.. Coin(remainder, "%02d", COPPER_AMOUNT_SYMBOL, "COPPER")
	end
	if silver > 0 then
		return Coin(silver, "%d", SILVER_AMOUNT_SYMBOL, "SILVER")
			.. " "
			.. Coin(remainder, "%02d", COPPER_AMOUNT_SYMBOL, "COPPER")
	end
	return Coin(remainder, "%d", COPPER_AMOUNT_SYMBOL, "COPPER")
end

--[[
    The coin pile matches what the amount actually is, so the icon carries the
    magnitude before the digits are read: a gold pile for anything reaching gold,
    silver for anything reaching silver, coppers for the rest.
]]
function ns.MoneyIcon(copper)
	if (copper or 0) >= ns.COPPER_PER_GOLD then
		return ns.MONEY_ICON_GOLD
	end
	if (copper or 0) >= ns.COPPER_PER_SILVER then
		return ns.MONEY_ICON_SILVER
	end
	return ns.MONEY_ICON_COPPER
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

--[[
    An item link's colour is the only quality signal available without a
    C_Item.GetItemInfo round trip, and ns.QUALITY_COLORS maps it. Returns nil for a
    colour the table does not carry (quest yellow, say) - callers decide whether
    unknown means show or stay quiet.
]]
function ns.GetLinkQuality(link)
	local colorSequence = link and link:match("|c(%x+)|H")
	if not colorSequence or #colorSequence ~= 8 then
		return nil
	end
	return ns.QUALITY_COLORS[string.lower(string.sub(colorSequence, 3, 8))]
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
