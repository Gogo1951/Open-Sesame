local _, ns = ...

--------------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. Every user setting lives under `profile`; `global` holds
    only the minimap position, which is account-wide and profile-independent so
    switching or resetting profiles never moves the button. Core.lua hands this
    table to AceDB:New, which applies defaults via metatables — no hand-merge.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		autoOpen = true,
		speedyLoot = true,
		lootSounds = false,
		showWelcome = true,
		showMinimap = true,
		lockboxNotifications = true,
	},
	global = {
		minimap = {},
	},
}
