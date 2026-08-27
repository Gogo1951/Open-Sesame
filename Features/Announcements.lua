local _, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

--[[
    All player-facing output lives here per the style guide. BRAND_PREFIX depends
    on ns.GetColor (Features/Utilities.lua) and ns.L (Data/Data.lua); both load
    before this file, so building it at file-load time is safe.
]]
ns.BRAND_PREFIX = string.format("%s%s|r %s//|r ", GetColor("INFO"), L["ADDON_TITLE"], GetColor("SEPARATOR"))

function ns:PrintMessage(msg, ...)
	local text = select("#", ...) > 0 and string.format(msg, ...) or msg
	local output = ns.BRAND_PREFIX .. GetColor("TEXT") .. text .. "|r"
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(output)
	else
		print(output)
	end
end

--------------------------------------------------------------------------------
-- Status Channel
--------------------------------------------------------------------------------

--[[
    Quiet window: suppresses transient status spam during load and rapid state
    changes. IsQuiet is internal; ns:SetQuiet is driven by Core's load/pause
    logic; ns:StatusPrint is the deduped status channel layered on PrintMessage.
]]
local function IsQuiet()
	return GetTime() < ns.state.quietUntil
end

function ns:SetQuiet(seconds)
	local untilTimestamp = GetTime() + (seconds or 0)
	if untilTimestamp > ns.state.quietUntil then
		ns.state.quietUntil = untilTimestamp
	end
end

--[[
    Announce one item at most once per ns.ITEM_ANNOUNCE_COOLDOWN. Both ignore-list
    notices share the stamp deliberately: a player who was just told Speedy Loot
    left an item behind does not also need to be told it will not be opened.
]]
function ns:AnnounceItemOnce(formatKey, itemId, link)
	local now = GetTime()
	if (now - (ns.state.recentAnnouncements[itemId] or 0)) <= ns.ITEM_ANNOUNCE_COOLDOWN then
		return
	end
	ns.state.recentAnnouncements[itemId] = now
	ns:PrintMessage(string.format(ns.L[formatKey], link))
end

function ns:StatusPrint(msg, ...)
	if IsQuiet() then
		return
	end
	local text = select("#", ...) > 0 and string.format(msg, ...) or msg
	local now = GetTime()
	if text == ns.state.lastStatusMsg and (now - ns.state.lastStatusAt) < ns.STATUS_REPEAT_COOLDOWN then
		return
	end
	ns.state.lastStatusMsg, ns.state.lastStatusAt = text, now
	ns:PrintMessage(text)
end
