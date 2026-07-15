local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Libraries
--------------------------------------------------------------------------------

local L = ns.L
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local GetColor = ns.GetColor

local brokerObj

--------------------------------------------------------------------------------
-- Icon State
--------------------------------------------------------------------------------

function ns:UpdateMinimapIcon()
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

	if ns.db and ns.db.global.minimap then
		LDBIcon:Refresh(ADDON_NAME, ns.db.global.minimap)
	end
end

--[[
    ns.db.global.minimap holds both the button's saved position and its `hide`
    flag. It is account-wide and profile-independent, so switching, resetting, or
    deleting a profile never affects the button's visibility or position. The
    subtable is passed directly to LibDBIcon, which reads `hide` to show or hide.
]]
function ns:SetMinimapShown(shown)
	ns.db.global.minimap.hide = not shown
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
	ns.db.profile.autoOpen = not ns.db.profile.autoOpen
	ns.isEnabled = ns.db.profile.autoOpen
	if ns.isEnabled then
		ns.EnsureAutoLoot()
	end
	ns.ScheduleScan(true)
	ns:UpdateMinimapIcon()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
end

local function ToggleSpeedyLoot()
	ns.db.profile.speedyLoot = not ns.db.profile.speedyLoot
	ns.isSpeedyLoot = ns.db.profile.speedyLoot
	if ns.isSpeedyLoot then
		ns.EnsureAutoLoot()
	end
	ns:UpdateMinimapIcon()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
end

local function ToggleLootSounds()
	ns.db.profile.lootSounds = not ns.db.profile.lootSounds
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
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
	tooltip:AddLine(
		GetColor("BODY") .. string.format(L["AUTO_OPENING_DESC"], ns.MIN_FREE_SLOTS) .. "|r",
		nil,
		nil,
		nil,
		true
	)
	tooltip:AddDoubleLine(
		GetColor("INFO") .. L["KEYBIND_LEFT_CLICK"] .. "|r",
		GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r"
	)
	tooltip:AddLine(" ")

	-- Speedy Loot
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["SPEEDY_LOOT"] .. "|r", GetStatusText(ns.isSpeedyLoot, false))
	tooltip:AddLine(GetColor("BODY") .. L["SPEEDY_LOOT_DESC"] .. "|r", nil, nil, nil, true)
	tooltip:AddDoubleLine(
		GetColor("INFO") .. L["KEYBIND_RIGHT_CLICK"] .. "|r",
		GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r"
	)
	tooltip:AddLine(" ")

	-- Loot Sounds
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["LOOT_SOUNDS"] .. "|r", GetStatusText(ns.db.profile.lootSounds, false))
	tooltip:AddLine(GetColor("BODY") .. L["LOOT_SOUNDS_DESC"] .. "|r", nil, nil, nil, true)
	tooltip:AddDoubleLine(
		GetColor("INFO") .. L["KEYBIND_MIDDLE_CLICK"] .. "|r",
		GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r"
	)
	tooltip:AddLine(" ")

	-- Options
	tooltip:AddLine(GetColor("TITLE") .. L["TOOLTIP_OPTIONS_TITLE"] .. "|r")
	tooltip:AddLine(GetColor("INFO") .. L["KEYBIND_SHIFT_MIDDLE_CLICK"] .. "|r")
	tooltip:Show()
end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

function ns:InitMinimap()
	brokerObj = LDB:NewDataObject(ADDON_NAME, {
		type = "launcher",
		label = L["ADDON_TITLE"],
		icon = ns.ICONS["on"],
		OnClick = function(self, button)
			-- Shift + Middle-Click always opens the options panel; checked first.
			if button == "MiddleButton" and IsShiftKeyDown() then
				ns:OpenOptionsPanel()
				return
			end

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

	LDBIcon:Register(ADDON_NAME, brokerObj, ns.db.global.minimap)
end
