local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------

local GetMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local version = GetMetadata and GetMetadata(ADDON_NAME, "Version") or "Dev"
if version:find("@") then
    version = "Dev"
end
ns.Version = version

--------------------------------------------------------------------------------
-- C_Container API
--------------------------------------------------------------------------------

--[[
    Pick each container call by availability: C_Container on modern builds, the
    identically-named legacy global where the namespace (or a member) is absent.
    The (C_Container and ...) guard is what makes the fallback reachable —
    indexing a nil C_Container would error before `or` reached the legacy global,
    which is the very client the fallback is for. These select a function
    reference rather than calling it, so the `or` is free of the truthy-
    fallthrough trap that bans `or` between call results.
]]
ns.GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
ns.UseContainerItem = (C_Container and C_Container.UseContainerItem) or UseContainerItem
ns.GetContainerItemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink
ns.GetContainerItemID = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID
ns.GetContainerNumFreeSlots = (C_Container and C_Container.GetContainerNumFreeSlots) or GetContainerNumFreeSlots

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    The raw hex palette lives in Data/Data.lua (ns.HEX). Per the style guide,
    data files hold no logic, so deriving the usable color-escape table from the
    palette happens here.
]]
local COLOR_PREFIX = "|cff"

ns.COLORS = {}
for key, hex in pairs(ns.HEX) do
    ns.COLORS[key] = COLOR_PREFIX .. hex
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

function ns.GetColor(key)
    return ns.COLORS[key] or ns.COLORS.TEXT
end

function ns.GetFreeSlots()
    local free = 0
    for bag = 0, 4 do
        local slotCount, family = ns.GetContainerNumFreeSlots(bag)
        if (family == nil or family == 0) and slotCount then
            free = free + slotCount
        end
    end
    return free
end
