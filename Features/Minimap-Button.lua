local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")
local GetColor = ns.GetColor

local brokerObj

--------------------------------------------------------------------------------
-- Icon State
--------------------------------------------------------------------------------

function ns.UpdateMinimapIcon()
    if not brokerObj then
        return
    end

    local state = not ns.isEnabled and "off" or (ns.isPaused and "paused" or "on")
    brokerObj.icon = ns.ICONS[state] or ns.ICONS.off
    brokerObj.text = string.format(
        "%s : %s",
        L["ADDON_TITLE"],
        ns.isEnabled and (ns.isPaused and L["STATUS_PAUSED"] or L["STATUS_ENABLED"]) or L["STATUS_DISABLED"]
    )

    if ns.DB and ns.DB.minimap then
        LDBIcon:Refresh(ADDON_NAME, ns.DB.minimap)
    end
end

--[[
    showMinimap (Data/Default-Settings.lua) is the source of truth, so a settings
    reset restores the button to on. The LibDBIcon subtable's `hide` field is kept
    in sync (inverted) so the button library obeys it; PLAYER_LOGIN re-derives hide
    from showMinimap at load. The minimap subtable itself is never wiped, so the
    button's saved position survives a reset.
]]
function ns.SetMinimapShown(shown)
    ns.DB.showMinimap = shown
    ns.DB.minimap.hide = not shown
    if shown then
        LDBIcon:Show(ADDON_NAME)
    else
        LDBIcon:Hide(ADDON_NAME)
    end
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

local function GetStatusText(isEnabled, isPaused)
    if not isEnabled then
        return GetColor("OFF") .. L["STATUS_DISABLED"] .. "|r"
    end
    if isPaused then
        return GetColor("SEPARATOR") .. L["STATUS_PAUSED"] .. "|r"
    end
    return GetColor("ON") .. L["STATUS_ENABLED"] .. "|r"
end

--------------------------------------------------------------------------------
-- Click Handlers
--------------------------------------------------------------------------------

local function ToggleAutoOpen()
    ns.DB.autoOpen = not ns.DB.autoOpen
    ns.isEnabled = ns.DB.autoOpen
    if ns.isEnabled then
        ns.EnsureAutoLoot()
    end
    ns.ScheduleScan(true)
    ns.UpdateMinimapIcon()
end

local function ToggleSpeedyLoot()
    ns.DB.speedyLoot = not ns.DB.speedyLoot
    ns.isSpeedyLoot = ns.DB.speedyLoot
    if ns.isSpeedyLoot then
        ns.EnsureAutoLoot()
    end
    ns.UpdateMinimapIcon()
end

local function ToggleLootSounds()
    ns.DB.lootSounds = not ns.DB.lootSounds
end

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

local function ShowTooltip(anchor)
    local tooltip = GameTooltip
    tooltip:SetOwner(anchor, "ANCHOR_NONE")
    tooltip:SetPoint("TOPRIGHT", anchor, "BOTTOMLEFT")
    tooltip:ClearLines()

    tooltip:AddDoubleLine(GetColor("TITLE") .. L["ADDON_TITLE"] .. "|r", GetColor("MUTED") .. ns.Version .. "|r")
    tooltip:AddLine(" ")
    tooltip:AddLine(" ")

    -- Auto-Opening
    tooltip:AddDoubleLine(GetColor("TITLE") .. L["AUTO_OPENING"] .. "|r", GetStatusText(ns.isEnabled, ns.isPaused))
    tooltip:AddLine(GetColor("BODY") .. string.format(L["AUTO_OPENING_DESC"], ns.MIN_FREE_SLOTS) .. "|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(GetColor("INFO") .. L["KEYBIND_LEFT_CLICK"] .. "|r", GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r")
    tooltip:AddLine(" ")

    -- Speedy Loot
    tooltip:AddDoubleLine(GetColor("TITLE") .. L["SPEEDY_LOOT"] .. "|r", GetStatusText(ns.isSpeedyLoot, false))
    tooltip:AddLine(GetColor("BODY") .. L["SPEEDY_LOOT_DESC"] .. "|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(GetColor("INFO") .. L["KEYBIND_RIGHT_CLICK"] .. "|r", GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r")
    tooltip:AddLine(" ")

    -- Loot Sounds
    tooltip:AddDoubleLine(GetColor("TITLE") .. L["LOOT_SOUNDS"] .. "|r", GetStatusText(ns.DB.lootSounds, false))
    tooltip:AddLine(GetColor("BODY") .. L["LOOT_SOUNDS_DESC"] .. "|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(GetColor("INFO") .. L["KEYBIND_MIDDLE_CLICK"] .. "|r", GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r")
    tooltip:AddLine(" ")

    -- Hint
    tooltip:AddLine(GetColor("BODY") .. L["TOOLTIP_HINT"] .. "|r", nil, nil, nil, true)
    tooltip:Show()
end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

function ns.InitMinimap()
    brokerObj = LDB:NewDataObject(ADDON_NAME, {
        type = "launcher",
        label = L["ADDON_TITLE"],
        icon = ns.ICONS["on"],
        OnClick = function(self, button)
            if button == "LeftButton" then
                ToggleAutoOpen()
            elseif button == "RightButton" then
                ToggleSpeedyLoot()
            elseif button == "MiddleButton" then
                ToggleLootSounds()
            end

            if GameTooltip:GetOwner() == self then
                ShowTooltip(self)
            end
        end,
        OnEnter = function(self)
            ShowTooltip(self)
        end,
        OnLeave = function(self)
            GameTooltip:Hide()
        end,
    })

    LDBIcon:Register(ADDON_NAME, brokerObj, ns.DB.minimap)
end
