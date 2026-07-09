local _, ns = ...

--------------------------------------------------------------------------------
-- Profiles Panel
--------------------------------------------------------------------------------

--[[
    The stock AceDBOptions-3.0 profiles table, returned as-is — profile picker,
    Copy From, Delete a Profile, and Reset Profile, already localized in every
    locale. Never extend or re-label it.
]]
function ns.BuildProfilesOptions()
	return LibStub("AceDBOptions-3.0"):GetOptionsTable(ns.db)
end
