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
-- Saved Variables
--------------------------------------------------------------------------------

ns.SAVED_VARIABLES_NAME = "OpenSesameDB"

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
-- Constants
--------------------------------------------------------------------------------

ns.MIN_FREE_SLOTS = 4
ns.WORLD_LOAD_DELAY = 8
ns.SCAN_DEBOUNCE = 0.5
ns.OPEN_TICK_INTERVAL = 0.25
ns.OPEN_RECHECK_DELAY = 0.25 -- Delay before re-checking a slot after opening
ns.OPEN_ANSWER_TIMEOUT = 1 -- Seconds an open waits for its loot window before it counts as refused
ns.OPEN_REFUSAL_LIMIT = 3 -- Unanswered opens in a row before an item is left alone until the next level-up or login
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
ns.LOOT_SOUND_FILE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Sounds\\item-pick-up.ogg" -- Rare-loot chime; play with PlaySoundFile
ns.LOOT_DELAY = 0.25
ns.LOOT_SOUND_WINDOW = 1 -- Seconds after a corpse/chest loot during which CHAT_MSG_LOOT may play the rare-loot sound

-- The client's own symbol first, so a renumbering can't silently reclassify items; 1 on every flavor we target.
ns.BIND_ON_PICKUP = (Enum and Enum.ItemBind and Enum.ItemBind.OnAcquire) or 1

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
    Seconds a loot window may follow a Pick Pocket cast and still be counted as
    its haul. Pick Pocket's window opens immediately, so this only has to be long
    enough to span the cast-to-loot gap, not to bridge anything the player did
    next.
]]
ns.PICK_POCKET_LOOT_WINDOW = 1

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
