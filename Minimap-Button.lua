local ADDON_NAME, OS = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("OpenSesame")
local LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

local brokerObj

--------------------------------------------------------------------------------
-- Icon State
--------------------------------------------------------------------------------

function OS.UpdateMinimapIcon()
    if not LDB or not LDBIcon or not brokerObj then
        return
    end

    local state = not OS.isEnabled and "off" or (OS.isPaused and "paused" or "on")
    brokerObj.icon = OS.ICONS[state] or OS.ICONS.off
    brokerObj.text = string.format(
        "%s : %s",
        L["ADDON_TITLE"],
        OS.isEnabled and (OS.isPaused and L["STATUS_PAUSED"] or L["STATUS_ON"]) or L["STATUS_OFF"]
    )

    if OS.DB and OS.DB.minimap then
        LDBIcon:Refresh(ADDON_NAME, OS.DB.minimap)
    end
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

local function GetStatusText(isEnabled, isPaused)
    if not isEnabled then
        return OS.COLORS.DISABLED .. L["STATUS_DISABLED"] .. "|r"
    end
    if isPaused then
        return OS.COLORS.SEP .. L["STATUS_PAUSED"] .. "|r"
    end
    return OS.COLORS.SUCCESS .. L["STATUS_ENABLED"] .. "|r"
end

--------------------------------------------------------------------------------
-- Click Handlers
--------------------------------------------------------------------------------

local function ToggleAutoOpen()
    OS.DB.autoOpen = not OS.DB.autoOpen
    OS.isEnabled = OS.DB.autoOpen
    OS.ScheduleScan(true)
    OS.UpdateMinimapIcon()
end

local function ToggleSpeedyLoot()
    OS.DB.speedyLoot = not OS.DB.speedyLoot
    OS.isSpeedyLoot = OS.DB.speedyLoot
    OS.UpdateMinimapIcon()
end

local function ToggleLootSounds()
    OS.DB.lootSounds = not OS.DB.lootSounds
end

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

local function ShowTooltip(anchor)
    local tooltip = GameTooltip
    tooltip:SetOwner(anchor, "ANCHOR_NONE")
    tooltip:SetPoint("TOPRIGHT", anchor, "BOTTOMLEFT")
    tooltip:ClearLines()

    tooltip:AddDoubleLine(OS.COLORS.TITLE .. L["ADDON_TITLE"] .. "|r", OS.COLORS.MUTED .. OS.Version .. "|r")
    tooltip:AddLine(" ")
    tooltip:AddLine(" ")

    -- Auto-Opening
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. L["AUTO_OPENING"] .. "|r", GetStatusText(OS.isEnabled, OS.isPaused))
    tooltip:AddLine(OS.COLORS.DESC .. L["AUTO_OPENING_DESC"] .. "|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.INFO .. L["KEYBIND_LEFT_CLICK"] .. "|r", OS.COLORS.INFO .. L["ACTION_TOGGLE"] .. "|r")
    tooltip:AddLine(" ")

    -- Speedy Loot
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. L["SPEEDY_LOOT"] .. "|r", GetStatusText(OS.isSpeedyLoot, false))
    tooltip:AddLine(OS.COLORS.DESC .. L["SPEEDY_LOOT_DESC"] .. "|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.INFO .. L["KEYBIND_RIGHT_CLICK"] .. "|r", OS.COLORS.INFO .. L["ACTION_TOGGLE"] .. "|r")
    tooltip:AddLine(" ")

    -- Loot Sounds
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. L["LOOT_SOUNDS"] .. "|r", GetStatusText(OS.DB.lootSounds, false))
    tooltip:AddLine(OS.COLORS.DESC .. L["LOOT_SOUNDS_DESC"] .. "|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.INFO .. L["KEYBIND_MIDDLE_CLICK"] .. "|r", OS.COLORS.INFO .. L["ACTION_TOGGLE"] .. "|r")
    tooltip:AddLine(" ")

    -- Hint
    tooltip:AddLine(OS.COLORS.DESC .. L["TOOLTIP_HINT"] .. "|r", nil, nil, nil, true)
    tooltip:Show()
end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

function OS.InitMinimap()
    if not LDB then
        return
    end

    brokerObj = LDB:NewDataObject(ADDON_NAME, {
        type = "launcher",
        label = L["ADDON_TITLE"],
        icon = OS.ICONS["on"],
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

    if LDBIcon then
        LDBIcon:Register(ADDON_NAME, brokerObj, OS.DB.minimap)
    end
end