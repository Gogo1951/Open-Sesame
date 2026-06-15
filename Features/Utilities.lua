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

ns.GetContainerNumSlots = C_Container.GetContainerNumSlots
ns.UseContainerItem = C_Container.UseContainerItem
ns.GetContainerItemLink = C_Container.GetContainerItemLink
ns.GetContainerItemID = C_Container.GetContainerItemID
ns.GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

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
