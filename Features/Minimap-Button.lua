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

-- Matches the tooltip's own line height, so an icon sits on the text baseline.
local TOOLTIP_ICON_SIZE = 16

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

	if ns.db and ns.db.profile.minimap then
		LDBIcon:Refresh(ADDON_NAME, ns.db.profile.minimap)
	end
end

--[[
    ns.db.profile.minimap holds both the button's saved position and its `hide`
    flag, and is passed directly to LibDBIcon, which reads `hide` to show or
    hide. It is profile state under the Simple model, so switching or resetting
    a profile changes it; UpdateMinimapIcon's Refresh above re-binds the live
    subtable on those callbacks, so the change applies without a reload.
]]
function ns:SetMinimapShown(shown)
	ns.db.profile.minimap.hide = not shown
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

	--[[
        Locked Items leads the tooltip, above the feature blocks, and appears only
        when boxes are actually waiting. It is the one part that changes with the
        bags rather than with a setting, so it is what the player opened the
        tooltip to check; the tooltip re-renders in place after a toggle click, so
        the list stays live.

        One line per distinct box, icon then name, with a stack count appended only
        when there is more than one - so no locale needs a plural form. The name
        comes from the item's own link, already localized and quality-coloured,
        with the link's brackets stripped since a tooltip line is not running text.
    ]]
	local lockedBoxes = ns.GetLockedBoxes()
	if #lockedBoxes > 0 then
		tooltip:AddLine(GetColor("TITLE") .. L["TOOLTIP_LOCKED_ITEMS"] .. "|r")
		for _, row in ipairs(lockedBoxes) do
			local icon = row.icon and ("|T" .. row.icon .. ":" .. TOOLTIP_ICON_SIZE .. "|t ") or ""
			local name = row.link and (row.link:gsub("|h%[(.-)%]|h", "|h%1|h"))
				or (GetColor("TEXT") .. row.itemId .. "|r")
			tooltip:AddLine(icon .. name .. (row.count > 1 and (" x" .. row.count) or ""))
		end
		tooltip:AddLine(" ")
	end

	-- Auto-Opening
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["AUTO_OPENING"] .. "|r", GetStatusText(ns.isEnabled, ns.isPaused))
	tooltip:AddLine(
		GetColor("BODY") .. string.format(L["AUTO_OPENING_DESCRIPTION"], ns.MIN_FREE_SLOTS) .. "|r",
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
	tooltip:AddLine(GetColor("BODY") .. L["SPEEDY_LOOT_DESCRIPTION"] .. "|r", nil, nil, nil, true)
	tooltip:AddDoubleLine(
		GetColor("INFO") .. L["KEYBIND_RIGHT_CLICK"] .. "|r",
		GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r"
	)
	tooltip:AddLine(" ")

	-- Loot Sounds
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["LOOT_SOUNDS"] .. "|r", GetStatusText(ns.db.profile.lootSounds, false))
	tooltip:AddLine(GetColor("BODY") .. L["LOOT_SOUNDS_DESCRIPTION"] .. "|r", nil, nil, nil, true)
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
		OnClick = function(buttonFrame, button)
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

			if GameTooltip:GetOwner() == buttonFrame then
				ShowTooltip(buttonFrame)
			end
		end,
		OnEnter = function(buttonFrame)
			ShowTooltip(buttonFrame)
		end,
		OnLeave = function()
			GameTooltip:Hide()
		end,
	})

	LDBIcon:Register(ADDON_NAME, brokerObj, ns.db.profile.minimap)
end
