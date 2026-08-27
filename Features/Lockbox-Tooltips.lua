local _, ns = ...

local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Lockbox Tooltips
--------------------------------------------------------------------------------

--[[
    Adds the required Lockpicking skill to a locked container's tooltip, and on a
    rogue colours it by whether their skill is high enough. Answers the question
    the bag raises on its own: why is this box still sitting there, and what do I
    need to open it.

    Read-only. Nothing here casts, sends chat, or writes state.
]]

--------------------------------------------------------------------------------
-- Player Lockpicking Skill
--------------------------------------------------------------------------------

--[[
    Finding the player's lockpicking rank needs the skill line's LOCALIZED name,
    and Classic Era does not publish a LOCKPICKING global -- the Diagnostic Tools
    API Endpoints report shows it FAIL there while every namespaced API passes.

    The name comes from the client's own spell database instead. Spell 1809 is the
    skill spell behind skill line 633, and its name IS the skill line's name in
    whatever language the client is running, so one lookup answers in every locale.
    Nothing about the player is involved, so it answers for an untrained rogue and
    on the first hover of the session.

    THE TRAP: the tooltip is not a source for this name. Matching an
    ITEM_MIN_SKILL pattern against the tooltip's own "Requires Lockpicking (225)"
    line is circular, because Era never prints that line on a lockbox: the name is
    never learned, the rank is always nil, and the requirement line stays neutral
    white instead of green or red. The name has to come from somewhere the client
    has already spoken, which is the spell database above.
]]
local lockpickingSkillName

local function GetLockpickingSkillName()
	if not lockpickingSkillName then
		lockpickingSkillName = ns.GetSpellName(ns.SPELLS.LOCKPICKING)
	end
	return lockpickingSkillName
end

--[[
    The client may still print its own requirement line on some builds, and
    repeating it would be noise, so the pattern behind ITEM_MIN_SKILL decides which
    of the two shapes below to add. Matching the format string rather than looking
    for the skill's name keeps it precise: other add-ons print lines that name
    Lockpicking without stating a requirement -- ATT's "World Drop > Lockpicking"
    breadcrumb is one -- and a name match would read those as the client's line.
]]
local function BuildRequirementPattern(format)
	if not format then
		return nil
	end
	--[[
        Escape the magic characters first, deliberately leaving % alone so the
        format's own %s and %d survive to become captures on the next two lines.
        Matching a literal %s needs the pattern "%%s", not "%%%%s".
    ]]
	local pattern = format:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
	pattern = pattern:gsub("%%s", "(.+)")
	pattern = pattern:gsub("%%d", "(%%d+)")
	return pattern
end

local requirementPattern = BuildRequirementPattern(ITEM_MIN_SKILL)

local function ClientStatesRequirement(tooltip)
	local tooltipName = tooltip:GetName()
	if not tooltipName or not requirementPattern then
		return false
	end
	for index = 1, tooltip:NumLines() do
		local line = _G[tooltipName .. "TextLeft" .. index]
		local text = line and line:GetText()
		if text and text:match(requirementPattern) then
			return true
		end
	end
	return false
end

--[[
    The skill lines are the only place the player's CURRENT rank lives; the spell
    says nothing about rank. Returns nil when the rank cannot be read -- a
    non-rogue, an untrained rogue, or a client whose spell database did not answer
    for the skill spell -- and every caller treats nil as "unknown" and falls back
    to neutral colouring rather than erroring.
]]
local function GetPlayerLockpickingSkill()
	local wantedName = GetLockpickingSkillName()
	if not wantedName then
		return nil
	end
	for index = 1, GetNumSkillLines() do
		local skillName, isHeader, _, skillRank = GetSkillLineInfo(index)
		if not isHeader and skillName == wantedName then
			return skillRank
		end
	end
	return nil
end
ns.GetPlayerLockpickingSkill = GetPlayerLockpickingSkill

--------------------------------------------------------------------------------
-- Tooltip Line
--------------------------------------------------------------------------------

--[[
    A tooltip can be re-processed without being cleared, so every line this file
    adds has to be checked for before it is added again. Matched as a substring
    because our own lines carry a colour escape the raw text does not.
]]
local function TooltipHasText(tooltip, needle)
	local tooltipName = tooltip:GetName()
	if not tooltipName then
		return false
	end
	for index = 1, tooltip:NumLines() do
		local line = _G[tooltipName .. "TextLeft" .. index]
		local text = line and line:GetText()
		if text and text:find(needle, 1, true) then
			return true
		end
	end
	return false
end

--[[
    The bag and slot are not parameters: everything this needs about the item is
    either its id or already written into the tooltip being handed over.
]]
local function AddLockboxLine(tooltip, itemId)
	if not ns.LockboxTooltipsEnabled() then
		return
	end
	local requiredSkill = itemId and ns.LOCKBOX_SKILL_LEVELS[itemId]
	if not requiredSkill then
		return
	end
	--[[
        The branded header doubles as the "already added" mark: a tooltip can be
        re-processed without being cleared, and one check on the header covers
        every line the block adds below it.
    ]]
	if TooltipHasText(tooltip, L["ADDON_TITLE"]) then
		return
	end

	local clientStatesIt = ClientStatesRequirement(tooltip)
	local skill = ns.IsPlayerRogue() and GetPlayerLockpickingSkill() or nil

	--[[
        Two shapes, never both. When the client already states the requirement
        (Classic Era does), repeating it is noise, so the add-on contributes the
        one thing the client will not: the player's own rank, coloured by whether
        it clears the box. When the client says nothing, the requirement itself is
        the useful line.
    ]]
	local label, value, color
	if clientStatesIt then
		if not skill then
			return
		end
		label, value = L["TOOLTIP_YOUR_LOCKPICKING_LABEL"], skill
		color = skill >= requiredSkill and GetColor("ON") or GetColor("OFF")
	else
		label, value = L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"], requiredSkill
		color = GetColor("BODY")
		if skill then
			color = skill >= requiredSkill and GetColor("ON") or GetColor("OFF")
		end
	end

	--[[
        Own block, set off from the client's own lines: a blank separator, the
        add-on's name, then the label and its number as a double line so the
        number sits in the tooltip's right column.
    ]]
	tooltip:AddLine(" ")
	tooltip:AddLine(GetColor("TITLE") .. L["ADDON_TITLE"] .. "|r")
	tooltip:AddDoubleLine(color .. label .. "|r", color .. value .. "|r")

	tooltip:Show()
end

--------------------------------------------------------------------------------
-- Hook
--------------------------------------------------------------------------------

--[[
    THE BLOCK GOES LAST BY BEING LATE IN THE FRAME, NEVER BY BEING LATE TO IT.

    Our own place in a tooltip is decided by two things, and only one of them is
    worth touching:

      - WHEN in the build we add. A SetBagItem post-hook is already about as late
        as a synchronous add can be: the client's lines are set, OnTooltipSetItem
        has fired, and every add-on watching that script -- ATT and TSM among them
        -- has had its say. That is why the block reads as the last thing on the
        tooltip today.
      - WHERE we sit among other SetBagItem post-hooks, which run in the order
        they were registered. Registering at PLAYER_LOGIN instead of at file scope
        puts us behind every add-on that hooked while loading, for free.

    A THIRD OPTION IS DELIBERATELY REJECTED. Deferring the add to the next frame
    with C_Timer.After(0) does put the block under everything -- and it FLICKERS
    BADLY, because a hovered bag button re-runs SetBagItem every frame. The
    tooltip is rebuilt without our block, gets it a frame later, loses it again on
    the next rebuild, and strobes for as long as the cursor rests on the item. Do
    not reintroduce it, in any form that adds lines outside the build itself.

    So this is best-effort by design: an add-on that hooks later, or rebuilds the
    tooltip on its own schedule, can still land below us. A row out of place beats
    a tooltip that strobes.
]]
--[[
    SetBagItem is the hook, unguarded: a widget method present on every client,
    firing for the bag and bank slots the feature is about.

    TooltipDataProcessor.AddTooltipPostCall would be the obvious modern choice and
    is the wrong one here. It does not exist on either target client, and it hands
    over an item id with no bag or slot, so the still-locked check cannot run on
    that path at all.
]]
local function InstallTooltipHook()
	hooksecurefunc(GameTooltip, "SetBagItem", function(tooltip, bag, slot)
		AddLockboxLine(tooltip, ns.GetContainerItemID(bag, slot))
	end)
end

--[[
    Called from Core's PLAYER_LOGIN, which fires once every add-on has loaded.
    Routed through the dispatcher like everything else rather than a private frame.
]]
ns.InstallTooltipHook = InstallTooltipHook
