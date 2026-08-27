local _, ns = ...

--------------------------------------------------------------------------------
-- C_Container API
--------------------------------------------------------------------------------

--[[
    Both target clients (Classic Era 1.15.x, TBC Anniversary 2.5.x) ship the
    C_Container namespace and have already removed the identically-named legacy
    globals, so there is nothing to select between: these are cached function
    references, unguarded. Diagnostics' API Endpoints report probes each one, so
    a future client that drops a member shows up as a FAIL row rather than as a
    silently dead fallback.
]]
ns.GetContainerNumSlots = C_Container.GetContainerNumSlots
ns.UseContainerItem = C_Container.UseContainerItem
ns.GetContainerItemLink = C_Container.GetContainerItemLink
ns.GetContainerItemID = C_Container.GetContainerItemID
ns.GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

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
    GetSpellInfo has two documented shapes - the classic multiple returns with
    the name first, and a single info table on newer builds. Read both rather
    than betting on one, and return nil when the client's spell database has
    nothing to say, which every caller already treats as unknown.

    Lockbox-Tooltips is the caller: the localized name of the Lockpicking skill
    is the name of the skill spell, and that is the only way to find the player's
    rank in a client that publishes no LOCKPICKING global.
]]
function ns.GetSpellName(spellID)
	local info = GetSpellInfo(spellID)
	if type(info) == "table" then
		return info.name
	end
	return info
end

--------------------------------------------------------------------------------
-- Lockbox Feature Scope
--------------------------------------------------------------------------------

--[[
    Both lockbox features carry a scope alongside their toggle: "ROGUES" shows
    them only to a Rogue, "ALL" to everyone. A non-Rogue cannot pick a lock, so
    Rogues-only is the default for both.

    The predicates live here rather than in either feature file because three
    files ask the question: Core and Speedy-Loot for the notifications,
    Lockbox-Tooltips for the tooltip line.
]]
function ns.IsPlayerRogue()
	return select(2, UnitClass("player")) == "ROGUE"
end

local function ScopeAllows(scope)
	return scope ~= "ROGUES" or ns.IsPlayerRogue()
end

function ns.LockboxTooltipsEnabled()
	return ns.db ~= nil and ns.db.profile.lockboxTooltips and ScopeAllows(ns.db.profile.lockboxTooltipsScope)
end

function ns.LockboxNotificationsEnabled()
	return ns.db ~= nil and ns.db.profile.lockboxNotifications and ScopeAllows(ns.db.profile.lockboxNotificationsScope)
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
    GetItemInfo round trip, and ns.QUALITY_COLORS maps it. Returns nil for a
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
