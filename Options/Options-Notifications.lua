local _, ns = ...

local L = ns.L

--------------------------------------------------------------------------------
-- Notifications Panel
--------------------------------------------------------------------------------

--[[
    The two ways the add-on tells the player what they just looted: a sound, and
    an on-screen toast. Speedy Loot hides the loot window, so between them these
    are the only record outside the chat log.
]]

-- The speaker preview's cell, sized to its icon rather than to a caption.
local LOOT_SOUND_PREVIEW_WIDTH = 0.2

--[[
    This panel carries the add-on's longest sub-row captions ("Maximum Items to
    Display"), which wrap to two lines at the shared sub-row label width. The
    label takes the extra width and the control gives back exactly as much, so
    the rows still total what every other sub-row totals and no other panel
    changes. The dropdowns hold short values (a quality name, a bare number, a
    direction), so the width comes off them for free.
]]
local SUB_LABEL_WIDTH = 1.4
local SUB_CONTROL_WIDTH = 0.9

--[[
    The bypass checkboxes: sized to their captions, well clear of the wrap
    boundary. Set by the longest of the six, "Always Show Bind on Pick-up Items",
    and capped by the grid - a sub-row leads with a blank indent cell, so this
    plus ns.OPTIONS_SUB_INDENT_WIDTH has to stay inside ns.OPTIONS_ROW_WIDTH.
]]
local BYPASS_TOGGLE_WIDTH = 2.4

local function SubSelectRow(order, hidden, caption, control)
	control.width = control.width or SUB_CONTROL_WIDTH
	return ns.OptionsSubSelectRow(order, hidden, caption, control, SUB_LABEL_WIDTH)
end

-- The toast move/reset row: a blank label cell plus two equal buttons.
local TOAST_BUTTON_WIDTH = 0.8
local TOAST_LABEL_WIDTH = ns.OPTIONS_ROW_WIDTH - (TOAST_BUTTON_WIDTH * 2)

local function LootSoundsOff()
	return not ns.db.profile.lootSounds
end

local function LootToastsOff()
	return not ns.db.profile.lootToasts
end

--[[
    Every threshold-bypass row is the same shape - an indented checkbox reading one
    boolean off the profile - so they are built from one helper. Hand-written
    copies would be one chance per row for one to drift away from the rest. The
    money row rides the same shape without being a threshold bypass.
]]
local function BypassRow(order, hidden, caption, key)
	return ns.OptionsSubRow(order, hidden, {
		{
			type = "toggle",
			name = ns.OptionsSubLabel(caption),
			width = BYPASS_TOGGLE_WIDTH,
			get = function()
				return ns.db.profile[key]
			end,
			set = function(_, value)
				ns.db.profile[key] = value
			end,
		},
	})
end

--[[
    Both quality dropdowns read the client-localized ITEM_QUALITYn_DESC globals,
    wrapped in the game's own quality colours so each tier reads
    grey/white/green/blue/purple like the items themselves. Built once so the two
    cannot drift. Their defaults deliberately differ: the sound starts at Uncommon
    because it is an interruption and wants to be rare, while toasts start at Poor
    because the stack stands in for the loot window and wants to be complete. That
    is also why the toast dropdown offers Poor and Common at all and the sound's
    does not.
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
local TOAST_QUALITY_VALUES, TOAST_QUALITY_SORTING = QualityChoices(0)

-- Bare numbers, so no locale needs a singular/plural form for "second".
local DURATION_VALUES = {}
for _, seconds in ipairs(ns.LOOT_TOAST_DURATIONS) do
	DURATION_VALUES[seconds] = tostring(seconds)
end

--[[
    Same bare numbers, with Unlimited last. It sorts after 21 rather than before
    1 because it belongs at the "more" end of the scale, which is where a player
    reading the list downward will look for it.
]]
local COUNT_VALUES = { [ns.LOOT_TOAST_UNLIMITED] = L["OPTIONS_UNLIMITED"] }
local COUNT_SORTING = {}
for _, count in ipairs(ns.LOOT_TOAST_COUNTS) do
	COUNT_VALUES[count] = tostring(count)
	COUNT_SORTING[#COUNT_SORTING + 1] = count
end
COUNT_SORTING[#COUNT_SORTING + 1] = ns.LOOT_TOAST_UNLIMITED

-- The client's own SetFont flag strings, captioned. Sorted by ns.LOOT_TOAST_FONT_FLAGS.
local FONT_FLAG_LABELS = {
	NONE = L["OPTIONS_FONT_OUTLINE_NONE"],
	OUTLINE = L["OPTIONS_FONT_OUTLINE_OUTLINE"],
	THICKOUTLINE = L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"],
	MONOCHROME = L["OPTIONS_FONT_OUTLINE_MONOCHROME"],
	MONOCHROMEOUTLINE = L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"],
}

local FONT_FLAG_VALUES = {}
for _, flag in ipairs(ns.LOOT_TOAST_FONT_FLAGS) do
	FONT_FLAG_VALUES[flag] = FONT_FLAG_LABELS[flag]
end

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
				ns.OptionsRowLabel(ns.OptionsSubLabel(L["OPTIONS_MINIMUM_QUALITY"]), nil, SUB_LABEL_WIDTH),
				{
					type = "select",
					name = "",
					width = SUB_CONTROL_WIDTH - LOOT_SOUND_PREVIEW_WIDTH,
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
                Pick Pocket landed at all, which is mostly coin - no quality, no
                toast, and nothing in a loot window the player can still see.
            ]]
			spaceLootSounds2 = ns.OptionsSpacer(16),
			togglePickPocketSound = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_PICK_POCKET_SOUND"],
				order = 17,
				width = "full",
				get = function()
					return ns.db.profile.pickPocketSound
				end,
				set = function(_, value)
					ns.db.profile.pickPocketSound = value
				end,
			},

			-- Loot Toasts
			spaceLootToasts0 = ns.OptionsSpacer(20),
			headerLootToasts = ns.OptionsHeader(L["LOOT_TOASTS"], 21),
			spaceLootToasts1 = ns.OptionsSpacer(22),
			descLootToasts = ns.OptionsDesc(L["LOOT_TOASTS_DESCRIPTION"], 23),
			spaceLootToasts2 = ns.OptionsSpacer(24),
			toggleLootToasts = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_LOOT_TOASTS"],
				order = 25,
				width = "full",
				get = function()
					return ns.db.profile.lootToasts
				end,
				set = function(_, value)
					ns.SetLootToastsEnabled(value)
				end,
			},
			subToastQuality = SubSelectRow(26, LootToastsOff, L["OPTIONS_MINIMUM_QUALITY"], {
				type = "select",
				values = TOAST_QUALITY_VALUES,
				sorting = TOAST_QUALITY_SORTING,
				get = function()
					return ns.db.profile.lootToastThreshold
				end,
				set = function(_, value)
					ns.db.profile.lootToastThreshold = value
					ns.RefreshLootToastSamples()
				end,
			}),
			--[[
                Eight escape hatches from the threshold above, each an ordinary
                sub-option of the feature toggle, followed by the money row, which
                takes the same shape without being a threshold bypass: coin has no
                quality to be measured against. Sized to their captions with room
                to spare, per the guide's rule that a sub-row control on the wrap
                boundary strands its own indent.

                Ordered for the player reading down the list, not by anything the
                code cares about. Bind on Pickup leads because it is the one rule
                that answers "is this a keep?" on its own, and a player who leaves
                it on may not need to think about the rest. The named kinds follow
                in the order they matter to most characters, and the two storage
                rows sit together at the end - Bags for what the player will carry
                loot in, Containers for what Open Sesame is about to open, which is
                the only row here that is about the add-on rather than the item.

                Features/Loot-Toasts.lua evaluates them in a different order, by
                what each costs to answer. The two orders are unrelated on purpose.
            ]]
			subToastBindOnPickup = BypassRow(
				27,
				LootToastsOff,
				L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"],
				"lootToastBindOnPickup"
			),
			subToastQuestItems = BypassRow(
				28,
				LootToastsOff,
				L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"],
				"lootToastQuestItems"
			),
			subToastRecipes = BypassRow(29, LootToastsOff, L["OPTIONS_ALWAYS_SHOW_RECIPES"], "lootToastRecipes"),
			subToastMounts = BypassRow(30, LootToastsOff, L["OPTIONS_ALWAYS_SHOW_MOUNTS"], "lootToastMounts"),
			subToastPets = BypassRow(31, LootToastsOff, L["OPTIONS_ALWAYS_SHOW_PETS"], "lootToastPets"),
			subToastKeys = BypassRow(32, LootToastsOff, L["OPTIONS_ALWAYS_SHOW_KEYS"], "lootToastKeys"),
			subToastBags = BypassRow(33, LootToastsOff, L["OPTIONS_ALWAYS_SHOW_BAGS"], "lootToastBags"),
			subToastContainers = BypassRow(
				34,
				LootToastsOff,
				L["OPTIONS_ALWAYS_SHOW_CONTAINERS"],
				"lootToastContainers"
			),
			subToastMoney = BypassRow(35, LootToastsOff, L["OPTIONS_ALWAYS_SHOW_MONEY"], "lootToastMoney"),
			subToastMaxItems = SubSelectRow(36, LootToastsOff, L["OPTIONS_LOOT_TOAST_MAX_ITEMS"], {
				type = "select",
				values = COUNT_VALUES,
				sorting = COUNT_SORTING,
				get = function()
					return ns.db.profile.lootToastMaxVisible
				end,
				set = function(_, value)
					ns.db.profile.lootToastMaxVisible = value
					ns.ApplyLootToastLimit()
				end,
			}),
			subToastDuration = SubSelectRow(37, LootToastsOff, L["OPTIONS_LOOT_TOAST_DURATION"], {
				type = "select",
				values = DURATION_VALUES,
				sorting = ns.LOOT_TOAST_DURATIONS,
				get = function()
					return ns.db.profile.lootToastDuration
				end,
				set = function(_, value)
					ns.db.profile.lootToastDuration = value
					ns.RefreshLootToastSamples()
				end,
			}),
			subToastFont = SubSelectRow(40, LootToastsOff, L["OPTIONS_LOOT_TOAST_FONT"], {
				type = "select",
				--[[
                    Functions, not tables: the list depends on whether anything
                    on this client has loaded LibSharedMedia, which is not known
                    when this panel is built and can change between openings.
                ]]
				values = function()
					return (ns.GetLootToastFontChoices())
				end,
				sorting = function()
					local _, sorting = ns.GetLootToastFontChoices()
					return sorting
				end,
				get = function()
					return ns.db.profile.lootToastFont
				end,
				set = function(_, value)
					ns.db.profile.lootToastFont = value
					ns.RefreshLootToastSamples()
				end,
			}),
			subToastFontSize = SubSelectRow(43, LootToastsOff, L["OPTIONS_LOOT_TOAST_FONT_SIZE"], {
				type = "range",
				min = ns.LOOT_TOAST_FONT_SIZE_MIN,
				max = ns.LOOT_TOAST_FONT_SIZE_MAX,
				step = 1,
				get = function()
					return ns.db.profile.lootToastFontSize
				end,
				set = function(_, value)
					ns.db.profile.lootToastFontSize = value
					ns.RefreshLootToastSamples()
				end,
			}),
			subToastGrowth = SubSelectRow(38, LootToastsOff, L["OPTIONS_LOOT_TOAST_GROWTH"], {
				type = "select",
				values = {
					UP = L["OPTIONS_GROW_UP"],
					DOWN = L["OPTIONS_GROW_DOWN"],
				},
				sorting = { "UP", "DOWN" },
				get = function()
					return ns.db.profile.lootToastGrowth
				end,
				set = function(_, value)
					ns.db.profile.lootToastGrowth = value
					ns.RefreshLootToastSamples()
				end,
			}),
			subToastAlign = SubSelectRow(39, LootToastsOff, L["OPTIONS_LOOT_TOAST_ALIGN"], {
				type = "select",
				values = {
					LEFT = L["OPTIONS_ALIGN_LEFT"],
					RIGHT = L["OPTIONS_ALIGN_RIGHT"],
				},
				sorting = { "LEFT", "RIGHT" },
				get = function()
					return ns.db.profile.lootToastAlign
				end,
				set = function(_, value)
					ns.db.profile.lootToastAlign = value
					ns.RefreshLootToastSamples()
				end,
			}),
			subToastFontOutline = SubSelectRow(41, LootToastsOff, L["OPTIONS_LOOT_TOAST_OUTLINE"], {
				type = "select",
				values = FONT_FLAG_VALUES,
				sorting = ns.LOOT_TOAST_FONT_FLAGS,
				get = function()
					return ns.db.profile.lootToastFontFlags
				end,
				set = function(_, value)
					ns.db.profile.lootToastFontFlags = value
					ns.RefreshLootToastSamples()
				end,
			}),
			--[[
                The position row hides with the sub-rows above rather than
                greying out. Two dead buttons under a section whose other
                controls have vanished reads as the whole feature being
                unfinished, which is the opposite of what off should look like.
            ]]
			spaceToastPosition = {
				type = "description",
				name = " ",
				order = 44,
				hidden = LootToastsOff,
			},
			labelToastPosition = {
				type = "description",
				name = "",
				fontSize = "medium",
				width = TOAST_LABEL_WIDTH,
				order = 45,
				hidden = LootToastsOff,
			},
			toggleToastLock = {
				type = "execute",
				name = function()
					return ns.AreLootToastsUnlocked() and L["OPTIONS_TOASTS_LOCK"] or L["OPTIONS_TOASTS_UNLOCK"]
				end,
				order = 46,
				width = TOAST_BUTTON_WIDTH,
				hidden = LootToastsOff,
				func = function()
					--[[
                        Locking from here counts as having met the handle, the
                        same as right-clicking it, so the introduction does not
                        come back at the next login.
                    ]]
					if ns.AreLootToastsUnlocked() then
						ns.DismissLootToastIntro()
					end
					ns.SetLootToastsUnlocked(not ns.AreLootToastsUnlocked())
				end,
			},
			resetToastPosition = {
				type = "execute",
				name = L["OPTIONS_TOASTS_RESET"],
				order = 47,
				width = TOAST_BUTTON_WIDTH,
				hidden = LootToastsOff,
				func = function()
					ns.ResetLootToastPosition()
				end,
			},
		},
	}
end
