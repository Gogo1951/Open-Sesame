local _, ns = ...

local L = ns.L

--------------------------------------------------------------------------------
-- Notifications Panel
--------------------------------------------------------------------------------

--[[
    How the add-on tells the player what they just looted: a sound. Speedy Loot
    hides the loot window, so this and the chat log are the only record.
]]

-- The speaker preview's cell, sized to its icon rather than to a caption.
local LOOT_SOUND_PREVIEW_WIDTH = 0.2

local function LootSoundsOff()
	return not ns.db.profile.lootSounds
end

--[[
    The quality dropdown reads the client-localized ITEM_QUALITYn_DESC globals,
    wrapped in the game's own quality colours so each tier reads
    grey/white/green/blue/purple like the items themselves. It starts at Uncommon:
    a sound is an interruption and wants to be rare.
]]
local QUALITY_DESC = {
	[0] = ITEM_QUALITY0_DESC,
	[1] = ITEM_QUALITY1_DESC,
	[2] = ITEM_QUALITY2_DESC,
	[3] = ITEM_QUALITY3_DESC,
	[4] = ITEM_QUALITY4_DESC,
}

local function QualityChoices(lowest)
	local values, sorting = {}, {}
	for quality = lowest, 4 do
		values[quality] = ITEM_QUALITY_COLORS[quality].hex .. QUALITY_DESC[quality] .. "|r"
		sorting[#sorting + 1] = quality
	end
	return values, sorting
end

local SOUND_QUALITY_VALUES, SOUND_QUALITY_SORTING = QualityChoices(2)

function ns.BuildNotificationsOptions()
	return {
		name = L["TAB_NOTIFICATIONS"],
		type = "group",
		args = {
			descNotifications = ns.OptionsDesc(L["NOTIFICATIONS_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),

			-- Loot Sound
			headerLootSounds = ns.OptionsHeader(L["LOOT_SOUNDS"], 10),
			spaceLootSounds0 = ns.OptionsSpacer(11),
			descLootSounds = ns.OptionsDesc(L["LOOT_SOUNDS_DESCRIPTION"], 12),
			spaceLootSounds1 = ns.OptionsSpacer(13),
			toggleLootSounds = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_LOOT_SOUNDS"],
				desc = L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"],
				order = 14,
				width = "full",
				get = function()
					return ns.db.profile.lootSounds
				end,
				set = function(_, value)
					ns.db.profile.lootSounds = value
				end,
			},
			--[[
                The threshold row carries the preview speaker as a third cell, so
                it is built directly rather than through OptionsSubSelectRow.
            ]]
			subSoundQuality = ns.OptionsSubRow(15, LootSoundsOff, {
				ns.OptionsRowLabel(ns.OptionsSubLabel(L["OPTIONS_MINIMUM_QUALITY"]), nil, ns.OPTIONS_SUB_LABEL_WIDTH),
				{
					type = "select",
					name = "",
					desc = L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"],
					width = ns.OPTIONS_SUB_CONTROL_WIDTH - LOOT_SOUND_PREVIEW_WIDTH,
					values = SOUND_QUALITY_VALUES,
					sorting = SOUND_QUALITY_SORTING,
					get = function()
						return ns.db.profile.lootSoundThreshold
					end,
					set = function(_, value)
						ns.db.profile.lootSoundThreshold = value
					end,
				},
				{
					type = "execute",
					name = "",
					desc = L["OPTIONS_TEST_LOOT_SOUND"],
					width = LOOT_SOUND_PREVIEW_WIDTH,
					image = "Interface\\COMMON\\VoiceChat-Speaker",
					imageWidth = 24,
					imageHeight = 24,
					func = function()
						PlaySoundFile(ns.LOOT_SOUND_FILE, "Master")
					end,
				},
			}),
			--[[
                Its own toggle rather than a sub-option of the loot sound, because
                it answers a different question. The loot sound reports what came
                out of a corpse and is filtered by quality; this one reports that a
                Pick Pocket landed at all, which is mostly coin - no quality, and
                nothing in a loot window the player can still see.
            ]]
			spaceLootSounds2 = ns.OptionsSpacer(16),
			togglePickPocketSound = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_PICK_POCKET_SOUND"],
				desc = L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"],
				order = 17,
				width = "full",
				get = function()
					return ns.db.profile.pickPocketSound
				end,
				set = function(_, value)
					ns.db.profile.pickPocketSound = value
				end,
			},
		},
	}
end
