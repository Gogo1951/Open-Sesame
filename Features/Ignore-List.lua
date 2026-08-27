local _, ns = ...

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

--[[
    The player's list of containers Open Sesame leaves alone entirely: Speedy
    Loot leaves them in the loot window with a notice, and Auto-Opening never
    queues them even when ns.AllowedItems allows the item.

    The list is account-wide (ns.db.global.ignoreList) because which containers a
    player hoards is a decision about the items, not about the character. It is
    seeded from ns.DEFAULT_IGNORE_ITEMS when missing or empty, per the style
    guide's default-list rule. An empty list is indistinguishable from a fresh
    install, so a player who removes every row keeps it empty for the rest of the
    session and finds it reseeded at the next login. Removing rows individually
    is what sticks; the rule protects against reintroducing entries a player
    removed while others remain.

    The saved list stores `true` per entry and nothing else. The note lives in
    ns.DEFAULT_IGNORE_ITEMS and is looked up at read time rather than copied in at
    seed time, so a list saved before the notes existed still shows them, and
    better copy reaches every player without a migration.
]]

local L = ns.L
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--[[
    A row's reason resolves to one of these six rather than carrying its own
    sentence: the note is player-facing, so free text per row would be one string
    per row for every locale to translate, sitting outside Locales/ entirely.
    Five cover the real spread, and ITEM is the fallback for anything new.

    The item names stay out of them on purpose. The client already draws its own
    localized tooltip directly above this line, so naming the loot again would
    mean shipping English item names into every locale.
]]
local REASON_TEXT = {
	RAID = L["OPTIONS_IGNORE_REASON_RAID"],
	QUEST = L["OPTIONS_IGNORE_REASON_QUEST"],
	RECIPE = L["OPTIONS_IGNORE_REASON_RECIPE"],
	GEAR = L["OPTIONS_IGNORE_REASON_GEAR"],
	HOLIDAY = L["OPTIONS_IGNORE_REASON_HOLIDAY"],
	ITEM = L["OPTIONS_IGNORE_REASON_ITEM"],
}

local function NotifyChange()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.IgnoreList)
end

function ns:GetIgnoreList()
	if not ns.db.global.ignoreList then
		ns.db.global.ignoreList = {}
	end
	return ns.db.global.ignoreList
end

function ns:IsIgnored(itemId)
	return itemId ~= nil and ns:GetIgnoreList()[itemId] ~= nil
end

-- The shipped reason for a default entry; nil for anything the player added.
function ns:GetIgnoreNote(itemId)
	local entry = itemId and ns.DEFAULT_IGNORE_ITEMS[itemId]
	if not entry then
		return nil
	end
	return ns.ICON_IGNORED .. " " .. (REASON_TEXT[entry[2]] or REASON_TEXT.ITEM)
end

function ns:AddIgnoredItem(itemId)
	if not itemId then
		return
	end
	ns:GetIgnoreList()[itemId] = true
	ns.ScheduleScan(true)
	NotifyChange()
end

function ns:RemoveIgnoredItem(itemId)
	if not itemId then
		return
	end
	ns:GetIgnoreList()[itemId] = nil
	ns.ScheduleScan(true)
	NotifyChange()
end

--[[
    Seeding and Restore Defaults share one rule: only rows this client can
    actually resolve. An id from a later expansion never answers GetItemInfo
    here, so it would sit in the panel as a bare number forever and keep the
    refresh watcher armed waiting for news that never comes.
]]
local function SeedFrom(list)
	for itemId, entry in pairs(ns.DEFAULT_IGNORE_ITEMS) do
		if entry[1] <= ns.currentExpansion then
			list[itemId] = true
		end
	end
end

function ns:RestoreDefaultIgnoreList()
	local list = ns:GetIgnoreList()
	wipe(list)
	SeedFrom(list)
	ns.ScheduleScan(true)
	NotifyChange()
end

--[[
    Called from Core's PLAYER_LOGIN right after AceDB:New. Rebuilds only when the
    saved list is missing or empty, so shipping new default entries never
    reintroduces items an existing player removed.
]]
function ns:SeedIgnoreList()
	local list = ns:GetIgnoreList()
	if next(list) then
		return
	end
	SeedFrom(list)
end
