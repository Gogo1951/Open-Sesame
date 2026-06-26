local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions)
AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])

-- Diagnostic Tools registered last so it sits at the bottom of the settings tree.
AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions)
AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, ns.DiagnosticsStrings.TAB, L["ADDON_TITLE"])

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

local function OpenOptions()
    if Settings and Settings.GetCategory then
        local category = Settings.GetCategory(L["ADDON_TITLE"])
        if category then
            Settings.OpenToCategory(category.ID)
            return
        end
    end
    if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(L["ADDON_TITLE"])
        InterfaceOptionsFrame_OpenToCategory(L["ADDON_TITLE"])
        return
    end
    AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

SLASH_OPENSESAME1 = "/os"
SlashCmdList.OPENSESAME = OpenOptions
