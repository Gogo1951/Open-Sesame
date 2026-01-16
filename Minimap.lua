local ADDON_NAME, OS = ...

local LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

local ICONS = {
    on = "Interface\\Icons\\inv_misc_bag_09_green",
    paused = "Interface\\Icons\\inv_misc_bag_09_black",
    off = "Interface\\Icons\\inv_misc_bag_09_red"
}

local brokerObj

function OS.UpdateMinimapIcon()
    if not LDB or not LDBIcon or not brokerObj then return end
    
    local state = not OS.isEnabled and "off" or (OS.isPaused and "paused" or "on")
    brokerObj.icon = ICONS[state] or ICONS.off
    brokerObj.text = string.format("Open Sesame : %s", OS.isEnabled and (OS.isPaused and "Paused" or "On") or "Off")
    
    if OS.DB and OS.DB.minimap then
        LDBIcon:Refresh(ADDON_NAME, OS.DB.minimap)
    end
end

local function GetStatusText(isEnabled, isPaused)
    if not isEnabled then
        return OS.COLORS.DISABLED .. "Disabled|r"
    end
    if isPaused then
        return OS.COLORS.SEPARATOR .. "Paused|r"
    end
    return OS.COLORS.SUCCESS .. "Enabled|r"
end

local function ToggleAutoOpen()
    OS.isEnabled = not OS.isEnabled
    if OS.DB then OS.DB.autoOpen = OS.isEnabled end
    
    if not OS.isEnabled then
        OS.state.openTimerLive = false
        OS.isPaused = false
    else
        OS.state.fullScanNeeded = true
        OS.ScheduleScan(true)
        OS.EnsureAutoLoot()
    end
    OS.UpdateMinimapIcon()
end

local function ToggleSpeedyLoot()
    OS.isSpeedyLoot = not OS.isSpeedyLoot
    if OS.DB then OS.DB.speedyLoot = OS.isSpeedyLoot end
    
    if OS.isSpeedyLoot then
        OS.EnsureAutoLoot()
    end
    OS.UpdateMinimapIcon()
end

local function ShowTooltip(owner)
    local tooltip = GameTooltip
    tooltip:SetOwner(owner, "ANCHOR_BOTTOMLEFT")
    tooltip:ClearLines()
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Open Sesame|r", OS.COLORS.MUTED .. OS.Version .. "|r")
    tooltip:AddLine(" ")
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Auto-Opening|r", GetStatusText(OS.isEnabled, OS.isPaused))
    tooltip:AddLine(OS.COLORS.DESC .. "Automatically opens clams and unlocked containers.|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.NAME .. "Left-Click|r", OS.COLORS.NAME .. "Toggle|r")
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Speedy Loot|r", GetStatusText(OS.isSpeedyLoot, false))
    tooltip:AddLine(OS.COLORS.DESC .. "Hide the loot window altogether for faster auto-looting.|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.NAME .. "Right-Click|r", OS.COLORS.NAME .. "Toggle|r")
    tooltip:AddLine(" ")
    tooltip:AddLine(OS.COLORS.DESC .. "Will automatically pause when you have 4 or fewer empty bag slots.|r", 1, 1, 1, true)
    tooltip:Show()
end

function OS.InitMinimap()
    if not LDB then return end
    
    brokerObj = LDB:NewDataObject(ADDON_NAME, {
        type = "launcher",
        label = "Open Sesame",
        icon = ICONS["on"],
        OnClick = function(self, button)
            if button == "LeftButton" then
                ToggleAutoOpen()
            elseif button == "RightButton" then
                ToggleSpeedyLoot()
            end
            if self and GameTooltip:GetOwner() == self then
                ShowTooltip(self)
            end
        end,
        OnEnter = function(self)
            ShowTooltip(self)
        end,
        OnLeave = function(self)
            GameTooltip:Hide()
        end
    })
    
    if LDBIcon and OS.DB and OS.DB.minimap then
        LDBIcon:Register(ADDON_NAME, brokerObj, OS.DB.minimap)
    end
end