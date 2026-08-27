local _, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Registration only. Called from EventHandlers:PLAYER_LOGIN once ns.db exists,
    because the Profiles builder needs the AceDB database — calling it at file
    load would hit a nil ns.db. Child order is General (root) -> Notifications ->
    Lockboxes -> Ignore List -> Profiles second-to-last -> Diagnostic Tools last;
    each panel's parent argument
    (L["ADDON_TITLE"]) nests it under Open Sesame. The Profiles display name comes
    already localized from AceDBOptions-3.0.
]]
function ns:RegisterOptionsPanels()
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	--[[
        AddToBlizOptions returns (frame, categoryID). The ID is what
        Settings.OpenToCategory expects; relying on the localized name matching
        the ID is fragile (the library only aliases ID to name on older
        clients), so capture the real reference here.
    ]]
	ns.GeneralPanel, ns.GeneralCategoryID =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])

	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Notifications, ns.BuildNotificationsOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Notifications, L["TAB_NOTIFICATIONS"], L["ADDON_TITLE"])

	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Lockboxes, ns.BuildLockboxesOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Lockboxes, L["TAB_LOCKBOXES"], L["ADDON_TITLE"])

	--[[
        The Ignore List's rows change as the player edits them, so it registers
        the BUILDER rather than a built table: AceConfigRegistry calls a function
        table afresh on every fetch, which is what makes NotifyChange redraw new
        and removed rows. A static table would only ever redraw the rows that
        existed at login.
    ]]
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.IgnoreList, ns.BuildIgnoreListOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.IgnoreList, L["TAB_IGNORE_LIST"], L["ADDON_TITLE"])

	-- Profiles registered second-to-last, directly above Diagnostic Tools.
	local profilesOptions = ns.BuildProfilesOptions()
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, L["ADDON_TITLE"])

	-- Diagnostic Tools registered last so it sits at the bottom of the settings tree.
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, ns.DiagnosticsStrings.TAB, L["ADDON_TITLE"])
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

--[[
    Shared entry point: the slash command and the minimap button's Shift +
    Middle-Click both open here. The combat gate lives only here — Blizzard's
    Settings panel is protected in combat, and without it the player gets an
    ADDON_ACTION_BLOCKED error naming the add-on. Routing uses the category ID
    captured at registration; passing the title instead returns nil on any client
    with the Settings API and drops the panel into a floating window.
]]
function ns:OpenOptionsPanel()
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_OPTIONS_IN_COMBAT"])
		return
	end
	if Settings and Settings.OpenToCategory and ns.GeneralCategoryID then
		Settings.OpenToCategory(ns.GeneralCategoryID)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

SLASH_OPENSESAME1 = "/os"
SlashCmdList.OPENSESAME = function()
	ns:OpenOptionsPanel()
end
