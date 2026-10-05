local _, ns = ...

--------------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. Open Sesame uses the Simple saved-variables model — one
    shared profile for every character — so every setting lives under `profile`,
    the mini-map subtable included. `global` holds the one thing that must not
    move with a profile: `ignoreList` (see below).
    Core.lua hands this table to AceDB:New, which applies the defaults itself —
    no hand-merge.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		autoOpen = true,
		-- "ALWAYS" | "OUTSIDE_INSTANCES"
		autoOpenWhere = "ALWAYS",
		-- "ALWAYS" | "SOLO_ONLY"
		autoOpenGroup = "ALWAYS",
		speedyLoot = true,
		lockboxTooltips = true,
		-- "ROGUES" | "ALL"
		lockboxTooltipsScope = "ROGUES",
		lootSounds = true,
		lootSoundThreshold = 2,
		-- Rogues only in practice; nothing else can cast Pick Pocket.
		pickPocketSound = true,
		showWelcome = true,
		lockboxNotifications = true,
		-- "ROGUES" | "ALL"
		lockboxNotificationsScope = "ROGUES",
		ignoreListNotifications = true,
		minimap = {},
	},
	--[[
        The Ignore List is deliberately account-wide: the containers a player
        hoards are a decision about the items, not about the character, so it
        must not move or reset with a profile.
    ]]
	global = {
		ignoreList = {},
	},
}
