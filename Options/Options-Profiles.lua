local _, ns = ...

--------------------------------------------------------------------------------
-- Profiles Panel
--------------------------------------------------------------------------------

--[[
    The stock AceDBOptions-3.0 profiles table, returned as-is: profile picker,
    Copy From, Delete a Profile, and Reset Profile, already translated in every
    locale. Nothing is added or removed. Registered second-to-last, directly
    above Diagnostic Tools (see Options/Options.lua).
]]
function ns.BuildProfilesOptions()
	return LibStub("AceDBOptions-3.0"):GetOptionsTable(ns.db)
end
