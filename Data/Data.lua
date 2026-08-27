local ADDON_NAME, ns = ...

ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

ns.CURSEFORGE_URL = "https://www.curseforge.com/wow/addons/open-sesame"
ns.GITHUB_URL = "https://github.com/Gogo1951/Open-Sesame"
ns.DISCORD_URL = "https://discord.gg/eh8hKq992Q"
ns.WAGO_URL = "https://addons.wago.io/addons/open-sesame"

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

--[[
    AceConfig registry names, derived from ADDON_NAME. Stable identifiers
    referenced by NotifyChange; never built inline, never localized.
]]
ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	Notifications = ADDON_NAME .. "_Notifications",
	Lockboxes = ADDON_NAME .. "_Lockboxes",
	IgnoreList = ADDON_NAME .. "_IgnoreList",
	Profiles = ADDON_NAME .. "_Profiles",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Expansion
--------------------------------------------------------------------------------

--[[
    Which expansion this client is. Item data is tagged with the expansion that
    introduced it, so anything newer than the running client can be filtered out
    before the add-on ever asks the client about it: those ids resolve to nothing
    here, and a row built from one would sit as a bare number forever.
]]
ns.VANILLA = 1
ns.TBC = 2
ns.WRATH = 3

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	ns.currentExpansion = ns.VANILLA
elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
	ns.currentExpansion = ns.TBC
else
	ns.currentExpansion = ns.WRATH
end

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

ns.MIN_FREE_SLOTS = 4
ns.WORLD_LOAD_DELAY = 8
ns.SCAN_DEBOUNCE = 0.5
ns.OPEN_TICK_INTERVAL = 0.25
ns.OPEN_RECHECK_DELAY = 0.25 -- Delay before re-checking a slot after opening
ns.PICK_LOCK_RESCAN_DELAY = 0.5 -- Delay after Pick Lock before rescanning bags
ns.STATUS_FLUSH_DELAY = 0.25 -- Delay after closing an interaction window before flushing a held status message
ns.BAG_FULL_COOLDOWN = 10
ns.ITEM_ANNOUNCE_COOLDOWN = 5 -- Seconds before the same item may be announced again
ns.STATUS_REPEAT_COOLDOWN = 5 -- Seconds before an identical status message may print again

--[[
    The client's own red "pass" icon, reused as a blocked marker on the Ignore
    List's tooltip line so the row reads as refused at a glance. Texture escapes
    are the one kind of picture sanctioned in game text.
]]
ns.ICON_IGNORED = "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14|t"
ns.LOOT_SOUND_FILE = "Interface\\AddOns\\Open-Sesame\\Includes\\Sounds\\item-pick-up.ogg" -- Rare-loot chime; play with PlaySoundFile
ns.BAG_FULL_SOUND_FALLBACK = 846 -- SoundKitID; play with PlaySound
ns.LOOT_DELAY = 0.25
ns.LOOT_SOUND_WINDOW = 1 -- Seconds after a corpse/chest loot during which CHAT_MSG_LOOT may play the rare-loot sound
ns.LOOT_TOAST_FADE_DURATION = 0.5 -- Seconds the fade itself takes, once ns.LOOT_TOAST_DURATIONS' dwell has elapsed

-- Seconds a toast stays up. Offered as a dropdown, so the steps widen as they grow.
ns.LOOT_TOAST_DURATIONS = { 1, 2, 3, 5, 8, 13, 21 }

--[[
    Most rows on screen at once. Same widening steps as the durations above, so
    the two dropdowns read as a pair. The list is joined by an Unlimited choice
    stored as 0 - a sentinel, not a count, and the one value the cap code has to
    special-case, since a literal cap of zero would retire every row on sight.
]]
ns.LOOT_TOAST_COUNTS = { 1, 2, 3, 5, 8, 13, 21 }
ns.LOOT_TOAST_UNLIMITED = 0

-- The face list itself comes from LibSharedMedia; only the bounds are ours.
ns.LOOT_TOAST_FONT_SIZE_MIN = 8
ns.LOOT_TOAST_FONT_SIZE_MAX = 24

--[[
    The client's own SetFont flag strings, in the order the dropdown offers them:
    the weight ladder first, then the two monochrome variants. "NONE" is our
    sentinel for the empty flag string, which SetFont wants instead of a name.
]]
ns.LOOT_TOAST_FONT_FLAGS = { "NONE", "OUTLINE", "THICKOUTLINE", "MONOCHROME", "MONOCHROMEOUTLINE" }

--[[
    One potion icon per item quality, colour-matched to the quality it stands
    for, so a sample toast reads as that quality at a glance. Used only by the
    unlock preview in Features/Loot-Toasts.lua; real toasts always draw the
    looted item's own icon.
]]

-- { [quality] = iconPath }
ns.LOOT_TOAST_SAMPLE_ICONS = {
	[0] = "Interface\\Icons\\inv_potion_132", -- Poor (gray)
	[1] = "Interface\\Icons\\inv_potion_133", -- Common (white)
	[2] = "Interface\\Icons\\inv_potion_138", -- Uncommon (green)
	[3] = "Interface\\Icons\\inv_potion_137", -- Rare (blue)
	[4] = "Interface\\Icons\\inv_potion_134", -- Epic (purple)
	[5] = "Interface\\Icons\\inv_potion_135", -- Legendary (orange)
}

--------------------------------------------------------------------------------
-- Options Layout
--------------------------------------------------------------------------------

ns.OPTIONS_ROW_WIDTH = 2.6
ns.OPTIONS_LABEL_WIDTH = 1.3
ns.OPTIONS_CONTROL_WIDTH = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_LABEL_WIDTH
ns.OPTIONS_REMOVE_ICON_WIDTH = 0.25 -- the item lists' remove column, sized to its icon
ns.OPTIONS_SUB_INDENT_WIDTH = 0.115 -- the blank cell a sub-option row leads with
ns.OPTIONS_SUB_LABEL_WIDTH = 1 -- a sub-row caption, sized to the caption not the grid
ns.OPTIONS_SUB_CONTROL_WIDTH = 1.3 -- its control, with slack so the row never wraps

--------------------------------------------------------------------------------
-- Item Quality
--------------------------------------------------------------------------------

--[[
    Maps an item link's lowercase color hex to its WoW item-quality number, used
    by the loot-sound gate to compare against the player's threshold. Heirloom
    (e6cc80) shares Legendary's 5 so it always plays at any threshold. Codes not
    listed here (e.g. quest yellow) are treated as unmapped and play no sound.
]]
ns.QUALITY_COLORS = {
	["9d9d9d"] = 0, -- Poor
	["ffffff"] = 1, -- Common
	["1eff00"] = 2, -- Uncommon
	["0070dd"] = 3, -- Rare
	["a335ee"] = 4, -- Epic
	["ff8000"] = 5, -- Legendary
	["e6cc80"] = 5, -- Heirloom / Artifact
}

--[[
    LOCKPICKING is the skill spell behind skill line 633, not something a player
    casts. It is here because its NAME is the localized name of the Lockpicking
    skill line, which is the only handle Features/Lockbox-Tooltips.lua has for
    finding the player's rank in GetSkillLineInfo -- see the note there.
]]
ns.SPELLS = {
	PICK_LOCK = 1804,
	LOCKPICKING = 1809,
	PICK_POCKET = 921,
	SHADOWMELD = 20580,
}

--[[
    PickupBag, the client's own bag-grab sound, for a Pick Pocket that actually
    took something: https://www.wowhead.com/classic/sound=1183/pickupbag

    Seconds a loot window may follow that cast and still be counted as its haul.
    Pick Pocket's window opens immediately, so this only has to be long enough to
    span the cast-to-loot gap, not to bridge anything the player did next.
]]
ns.PICK_POCKET_SOUND = 1183 -- SoundKitID; play with PlaySound
ns.PICK_POCKET_LOOT_WINDOW = 1

--[[
    The item kinds Loot Toasts can show regardless of the quality threshold. All
    but the last are read from GetItemInfoInstant, which answers from the client's
    own database with no cold-cache nil, so the kind is recognised the first time
    the item is looted. Class and subclass numbers are stable across every client
    we target.

    ITEM_BIND_ON_PICKUP is the odd one out: bindType comes from the full
    GetItemInfo, which CAN answer nil on a cold cache. See the note in
    Features/Loot-Toasts.lua for why that is acceptable there, and the
    "GetItemInfo bindType" row in the Diagnostics API report, which proves the
    return position on each client rather than trusting it.
]]
--[[
    Class 1 is the client's "Container", which is a BAG - the thing loot goes in,
    not the lockbox Open Sesame opens. The add-on's own openable containers are
    ns.AllowedItems and are matched by id, never by class.

    Quivers and ammo pouches are their OWN class rather than bags, which is a
    distinction the client's item database makes and a hunter does not: both are
    the bag you were hoping would drop. The Bags toggle covers the pair.
]]
ns.ITEM_CLASS_BAG = 1
ns.ITEM_CLASS_QUIVER = 11
ns.ITEM_CLASS_RECIPE = 9
ns.ITEM_CLASS_QUEST = 12
ns.ITEM_CLASS_KEY = 13
ns.ITEM_CLASS_MISCELLANEOUS = 15
ns.ITEM_SUBCLASS_COMPANION_PET = 2 -- of Miscellaneous
ns.ITEM_SUBCLASS_MOUNT = 5 -- of Miscellaneous
ns.ITEM_BIND_ON_PICKUP = 1 -- GetItemInfo's bindType, 14th return
ns.ITEM_BIND_PROBE_ID = 6948 -- Hearthstone: Bind on Pickup, and in every bag

--------------------------------------------------------------------------------
-- Money
--------------------------------------------------------------------------------

--[[
    Coin piles for the money toast, one per magnitude, so the icon says roughly how
    much before the digits are read. Written as texture paths rather than the file
    ids the same art is also known by, matching every other icon in the add-on.
]]
ns.MONEY_ICON_GOLD = "Interface\\Icons\\INV_Misc_Coin_02" -- 133785
ns.MONEY_ICON_SILVER = "Interface\\Icons\\INV_Misc_Coin_04" -- 133787
ns.MONEY_ICON_COPPER = "Interface\\Icons\\INV_Misc_Coin_06" -- 133789

ns.COPPER_PER_SILVER = 100
ns.COPPER_PER_GOLD = 10000

--[[
    One colour per coin, for the g/s/c suffixes while the numbers stay body white.
    These are the CLIENT'S conventions rather than the add-on's, which is why they
    sit apart from ns.PALETTE: gold, silver and copper look the way they look in
    every money display in the game, and a player reads the unit off the colour
    before they read the letter.
]]
ns.MONEY_PALETTE = {
	GOLD = "FFD700",
	SILVER = "C7C7CF",
	COPPER = "EDA55F",
}

-- { [raceKey] = { [genderId] = soundId } }
ns.RACE_SOUNDS = {
	["Human"] = { [2] = 1897, [3] = 2021 },
	["Orc"] = { [2] = 2308, [3] = 2363 },
	["Dwarf"] = { [2] = 1609, [3] = 1673 },
	["NightElf"] = { [2] = 2140, [3] = 2251 },
	["Scourge"] = { [2] = 2076, [3] = 2196 },
	["Tauren"] = { [2] = 2440, [3] = 2441 },
	["Gnome"] = { [2] = 1730, [3] = 1787 },
	["Troll"] = { [2] = 1842, [3] = 1952 },
	["BloodElf"] = { [2] = 9589, [3] = 9590 },
	["Draenei"] = { [2] = 9504, [3] = 9505 },
}

--------------------------------------------------------------------------------
-- Lockbox Skill Levels
--------------------------------------------------------------------------------

--[[
    Required Lockpicking skill per locked container, for the tooltip line in
    Features/Lockbox-Tooltips.lua. Covers the ns.AllowedItems entries whose value
    is false, minus four with no number to give:

      Thieven' Kit (7868)        Flagged Locked, publishes no skill number.
      Floral Foundations (39014) Requires Inscription (50), not Lockpicking.
      Dark Iron Lockbox (208838) Unknown.
      Scarlet Junkbox (239248)   Unknown.

    The two Unknowns are Season of Discovery rows that reach ns.AllowedItems
    through the name-guess merge rule rather than from a source that carries a
    skill number. A missing row means no tooltip line for that box, which is the
    deliberate trade: none of the four gets a line rather than being given a
    guessed one.

    Values here are numbers and the tooltip formats them with %d, so a placeholder
    string in this table would error on hover. An unknown box is absent from the
    table, never present with a stand-in value.

    The skill number is NOT in the world DB: item_template.lockid points into
    Lock.dbc, which is client data, so these values were read off each item's own
    warcraft.wiki.gg page. The four 225s in the classic tier are real, each
    confirmed on its own page.

    -- TODO: Add SQL Query

    This lists the items that need a value, so the table can be checked for gaps
    after regenerating ns.AllowedItems:

    SELECT it.entry, it.name, it.lockid
    FROM item_template it
    WHERE it.lockid > 0
      AND EXISTS (SELECT 1 FROM item_loot_template ilt WHERE ilt.entry = it.entry)
    ORDER BY it.name;
]]

-- { [itemId] = requiredLockpickingSkill }

ns.LOCKBOX_SKILL_LEVELS = {

	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[16882] = 1, -- Battered Junkbox
	[5760] = 225, -- Eternium Lockbox
	[4633] = 25, -- Heavy Bronze Lockbox
	[16885] = 250, -- Heavy Junkbox
	[4634] = 70, -- Iron Lockbox
	[13875] = 175, -- Ironbound Locked Chest
	[5758] = 225, -- Mithril Lockbox
	[4632] = 1, -- Ornate Bronze Lockbox
	[13918] = 250, -- Reinforced Locked Chest
	[4638] = 225, -- Reinforced Steel Lockbox
	[6354] = 1, -- Small Locked Chest
	[4637] = 175, -- Steel Lockbox
	[4636] = 125, -- Strong Iron Lockbox
	[16884] = 175, -- Sturdy Junkbox
	[6355] = 70, -- Sturdy Locked Chest
	[7209] = 1, -- Tazan's Satchel
	[12033] = 275, -- Thaurissan Family Jewels
	[5759] = 225, -- Thorium Lockbox
	[16883] = 70, -- Worn Junkbox

	--------------------------------------------------------------------------------
	-- 02. World of Warcraft : The Burning Crusade
	--------------------------------------------------------------------------------

	[31952] = 325, -- Khorium Lockbox
	[29569] = 300, -- Strong Junkbox

	--------------------------------------------------------------------------------
	-- 03. World of Warcraft : Wrath of the Lich King
	--------------------------------------------------------------------------------

	[43622] = 375, -- Froststeel Lockbox
	[43575] = 350, -- Reinforced Junkbox
	[42953] = 400, -- Strange Envelope
	[45986] = 400, -- Tiny Titanium Lockbox
	[43624] = 400, -- Titanium Lockbox
}

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    Raw hex palette only. The derived COLORS table (with the |cff escape
    prefix) and the ns.GetColor accessor live in Features/Utilities.lua, because
    data files hold no logic.
]]

ns.PALETTE = {
	TITLE = "FFD100", -- Gold: Titles, Headers, Section Names, Field Titles
	INFO = "00BBFF", -- Blue: Interactions, Toggles, Links, Keybinds, Slash Commands
	BODY = "FFFFFF", -- White: Descriptions, Options Body Text
	HELP = "CCCCCC", -- Silver: Pro Tips, Helper Text
	TEXT = "FFFFFF", -- White: Messages, Values, Spell Names
	ON = "33CC33", -- Green: On
	OFF = "CC3333", -- Red: Off
	SEPARATOR = "AAAAAA", -- Gray: Separators, Dividers
	MUTED = "808080", -- Dark Gray: Meta-data, Version Numbers
}

--------------------------------------------------------------------------------
-- Icons
--------------------------------------------------------------------------------

ns.ICONS = {
	on = "Interface\\Icons\\inv_misc_bag_09_green",
	paused = "Interface\\Icons\\inv_misc_bag_09_black",
	off = "Interface\\Icons\\inv_misc_bag_09_red",
}
