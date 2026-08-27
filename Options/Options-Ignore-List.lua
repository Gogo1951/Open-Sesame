local _, ns = ...

local L = ns.L

--------------------------------------------------------------------------------
-- Ignore List Panel
--------------------------------------------------------------------------------

--[[
    Shape, order, and widths all come from ns:BuildItemListOptions in
    Options-Utilities.lua; this file supplies only the copy, the source table,
    and the callbacks. The list ships defaults, so it carries a Restore Defaults
    row.
]]

function ns.BuildIgnoreListOptions()
	local args = ns:BuildItemListOptions({
		registryName = ns.OPTIONS_REGISTRY.IgnoreList,
		startOrder = 10,
		source = ns:GetIgnoreList(),
		-- Why a shipped row is on the list; nil for anything the player added.
		noteFor = function(itemId)
			return ns:GetIgnoreNote(itemId)
		end,
		addLabel = L["OPTIONS_IGNORE_LIST_ADD"],
		addHint = L["OPTIONS_IGNORE_LIST_ADD_HINT"],
		removeLabel = L["OPTIONS_IGNORE_LIST_REMOVE"],
		restoreLabel = L["OPTIONS_IGNORE_LIST_RESTORE"],
		restoreConfirm = L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"],
		onAdd = function(itemId)
			ns:AddIgnoredItem(itemId)
		end,
		onRemove = function(itemId)
			ns:RemoveIgnoredItem(itemId)
		end,
		onRestore = function()
			ns:RestoreDefaultIgnoreList()
		end,
	})

	-- The list starts at 10, leaving 1-9 for the panel's own copy and controls.
	args.descIgnoreList = ns.OptionsDesc(L["OPTIONS_IGNORE_LIST_DESCRIPTION"], 1)
	args.spaceIgnoreList0 = ns.OptionsSpacer(2)
	args.toggleIgnoreListNotifications = {
		type = "toggle",
		name = L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"],
		order = 3,
		width = "full",
		get = function()
			return ns.db.profile.ignoreListNotifications
		end,
		set = function(_, value)
			ns.db.profile.ignoreListNotifications = value
		end,
	}
	args.spaceIgnoreList1 = ns.OptionsSpacer(4)

	return {
		type = "group",
		name = L["TAB_IGNORE_LIST"],
		args = args,
	}
end
