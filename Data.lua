local addonName, namespace = ...
namespace.L = LibStub("AceLocale-3.0"):GetLocale("ComeAndGetIt")

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
    local version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version")
        or GetAddOnMetadata(addonName, "Version")
    if not version or version:find("@") then
        return "Dev"
    end
    return version
end

namespace.Version = GetVersion()

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

-- Blizzard UI error ID for "Item is locked" — fired when a player interacts
-- with a lockbox they cannot open.  Professions (herb/mine) don't use a fixed
-- ID; they return a localized message string instead, so those are matched by
-- substring in Core.
namespace.ERROR_ID_LOCKED_CHEST = 268

namespace.ANNOUNCE_COOLDOWN = 5

--------------------------------------------------------------------------------
-- URLs
--------------------------------------------------------------------------------

namespace.URL_CURSEFORGE = "https://www.curseforge.com/wow/addons/come-get-it"
namespace.URL_GITHUB = "https://github.com/Gogo1951/Come-and-Get-It"
namespace.URL_DISCORD = "https://discord.gg/eh8hKq992Q"

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

local C_TITLE = "FFD100"
local C_INFO = "00BBFF"
local C_BODY = "CCCCCC"
local C_TEXT = "FFFFFF"
local C_SUCCESS = "33CC33"
local C_DISABLED = "CC3333"
local C_SEP = "AAAAAA"
local C_MUTED = "808080"

local COLOR_PREFIX = "|cff"

local COLORS = {
    TITLE = COLOR_PREFIX .. C_TITLE,
    INFO = COLOR_PREFIX .. C_INFO,
    BODY = COLOR_PREFIX .. C_BODY,
    TEXT = COLOR_PREFIX .. C_TEXT,
    SUCCESS = COLOR_PREFIX .. C_SUCCESS,
    DISABLED = COLOR_PREFIX .. C_DISABLED,
    SEP = COLOR_PREFIX .. C_SEP,
    MUTED = COLOR_PREFIX .. C_MUTED
}

function namespace.GetColor(key)
    return COLORS[key] or ""
end