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
    load would hit a nil ns.db. Child order is General (root) -> Profiles
    second-to-last -> Diagnostic Tools last; each panel's parent argument
    (L["ADDON_TITLE"]) nests it under Open Sesame. The Profiles display name comes
    already localized from AceDBOptions-3.0.
]]
function ns:RegisterOptionsPanels()
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	-- AddToBlizOptions returns (frame, categoryID). The ID is what Settings.OpenToCategory
	-- expects; relying on the localized name matching the ID is fragile (the library only
	-- aliases ID to name on older clients), so capture the real reference here.
	ns.GeneralPanel, ns.GeneralCategoryID =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])

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

local function OpenOptions()
	if Settings and Settings.OpenToCategory and ns.GeneralCategoryID then
		Settings.OpenToCategory(ns.GeneralCategoryID)
		return
	end
	if InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(L["ADDON_TITLE"])
		InterfaceOptionsFrame_OpenToCategory(L["ADDON_TITLE"])
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

-- Shared entry point: the slash command and the minimap button's Shift+Middle-Click both open here.
function ns:OpenOptionsPanel()
	OpenOptions()
end

SLASH_OPENSESAME1 = "/os"
SlashCmdList.OPENSESAME = OpenOptions
