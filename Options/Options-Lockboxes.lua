local _, ns = ...

local L = ns.L

--------------------------------------------------------------------------------
-- Lockboxes Panel
--------------------------------------------------------------------------------

--[[
    Everything the add-on does about locked containers: what a lockbox needs, and
    when it says so.

    Both features carry a scope beside their toggle rather than only an on/off,
    because a non-Rogue cannot pick a lock and has little use for either. The
    predicates behind the scopes live in Features/Utilities.lua, shared with Core
    and Speedy-Loot.
]]

local function TooltipsOff()
	return not ns.db.profile.lockboxTooltips
end

local function NotificationsOff()
	return not ns.db.profile.lockboxNotifications
end

local function ScopeControl(get, set)
	return {
		type = "select",
		values = {
			ROGUES = L["OPTIONS_FOR_ROGUES"],
			ALL = L["OPTIONS_FOR_ALL_CHARACTERS"],
		},
		sorting = { "ROGUES", "ALL" },
		get = get,
		set = set,
	}
end

function ns.BuildLockboxesOptions()
	return {
		name = L["TAB_LOCKBOXES"],
		type = "group",
		args = {
			descLockboxes = ns.OptionsDesc(L["LOCKBOXES_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),

			toggleLockboxTooltips = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"],
				order = 10,
				width = "full",
				get = function()
					return ns.db.profile.lockboxTooltips
				end,
				set = function(_, value)
					ns.db.profile.lockboxTooltips = value
				end,
			},
			subTooltipsScope = ns.OptionsSubSelectRow(
				11,
				TooltipsOff,
				L["OPTIONS_SHOW_FOR"],
				ScopeControl(function()
					return ns.db.profile.lockboxTooltipsScope
				end, function(_, value)
					ns.db.profile.lockboxTooltipsScope = value
				end)
			),

			spaceNotifications = ns.OptionsSpacer(20),
			toggleLockboxNotifications = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"],
				order = 21,
				width = "full",
				get = function()
					return ns.db.profile.lockboxNotifications
				end,
				set = function(_, value)
					ns.db.profile.lockboxNotifications = value
				end,
			},
			subNotificationsScope = ns.OptionsSubSelectRow(
				22,
				NotificationsOff,
				L["OPTIONS_SHOW_FOR"],
				ScopeControl(function()
					return ns.db.profile.lockboxNotificationsScope
				end, function(_, value)
					ns.db.profile.lockboxNotificationsScope = value
				end)
			),
		},
	}
end
