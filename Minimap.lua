local ADDON_NAME, OS = ...

local LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

local brokerObj

function OS.UpdateMinimapIcon()
    if not LDB or not LDBIcon or not brokerObj then
        return
    end

    local state = not OS.isEnabled and "off" or (OS.isPaused and "paused" or "on")
    brokerObj.icon = OS.ICONS[state] or OS.ICONS.off
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

local function ShowTooltip(anchor)
    local tooltip = GameTooltip
    tooltip:SetOwner(anchor, "ANCHOR_NONE")
    tooltip:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT")
    tooltip:ClearLines()
    
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Open Sesame|r", OS.COLORS.MUTED .. OS.Version .. "|r")
    tooltip:AddLine(" ")

    -- Auto-Opening
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Auto-Opening|r", GetStatusText(OS.isEnabled, OS.isPaused))
    tooltip:AddLine(OS.COLORS.DESC .. "Automatically opens clams and unlocked containers when you have more than 4 empty bag slots.|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.NAME .. "Left-Click|r", OS.COLORS.NAME .. "Toggle|r")
    tooltip:AddLine(" ")

    -- Speedy Loot
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Speedy Loot|r", GetStatusText(OS.isSpeedyLoot, false))
    tooltip:AddLine(OS.COLORS.DESC .. "Hides the loot window for near-instant looting.|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.NAME .. "Right-Click|r", OS.COLORS.NAME .. "Toggle|r")
    tooltip:AddLine(" ")

    -- Loot Sounds
    tooltip:AddDoubleLine(OS.COLORS.TITLE .. "Loot Sounds|r", GetStatusText(OS.DB.lootSounds, false))
    tooltip:AddLine(OS.COLORS.DESC .. "Plays a distinct sound when you loot an Uncommon or higher quality item.|r", nil, nil, nil, true)
    tooltip:AddDoubleLine(OS.COLORS.NAME .. "Middle-Click|r", OS.COLORS.NAME .. "Toggle|r")

    tooltip:Show()
end

function OS.InitMinimap()
    if not LDB then return end

    brokerObj = LDB:NewDataObject(ADDON_NAME, {
        type = "launcher",
        label = "Open Sesame",
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
        end
    })

    if LDBIcon then
        LDBIcon:Register(ADDON_NAME, brokerObj, OS.DB.minimap)
    end
end