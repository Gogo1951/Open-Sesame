local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

--[[
    All player-facing output lives here per the style guide. BRAND_PREFIX depends
    on ns.COLORS (Features/Utilities.lua) and ns.L (Data/Data.lua); both load
    before this file, so building it at file-load time is safe.
]]
ns.BRAND_PREFIX = string.format("%s%s|r %s//|r ", ns.COLORS.INFO, L["ADDON_TITLE"], ns.COLORS.SEPARATOR)

function ns.PrintMessage(msg, ...)
    local text = select("#", ...) > 0 and string.format(msg, ...) or msg
    local output = ns.BRAND_PREFIX .. ns.COLORS.TEXT .. text .. "|r"
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
    changes. IsQuiet is internal; ns.SetQuiet is driven by Core's load/pause
    logic; ns.StatusPrint is the deduped status channel layered on PrintMessage.
]]
local function IsQuiet()
    return GetTime() < ns.state.quietUntil
end

function ns.SetQuiet(seconds)
    local untilTimestamp = GetTime() + (seconds or 0)
    if untilTimestamp > ns.state.quietUntil then
        ns.state.quietUntil = untilTimestamp
    end
end

function ns.StatusPrint(msg, ...)
    if IsQuiet() then
        return
    end
    local text = select("#", ...) > 0 and string.format(msg, ...) or msg
    local now = GetTime()
    if text == ns.state.lastStatusMsg and (now - ns.state.lastStatusAt) < 5 then
        return
    end
    ns.state.lastStatusMsg, ns.state.lastStatusAt = text, now
    ns.PrintMessage(text)
end
