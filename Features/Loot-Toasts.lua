local _, ns = ...

local LSM = LibStub("LibSharedMedia-3.0")

--------------------------------------------------------------------------------
-- Loot Toasts
--------------------------------------------------------------------------------

--[[
    Speedy Loot hides the loot window, so the only record of what was picked up
    is the chat log. These are a small on-screen readout of the same thing:
    icon, coloured link, quantity.

    The stack reads like a chat log. A new entry appears at the anchor and
    everything already on screen shifts one row away from it - upward by
    default, downward when lootToastGrowth is "DOWN" - so the oldest row is
    always the one at the far end, fading out of it. That keeps the reading
    order stable and means the row the player just triggered is always in the
    same place on screen.

    On by default, since it is what makes hiding the loot window a net gain rather
    than a loss of information - and because it ships on, a profile that has never
    dismissed the drag handle is shown it at login, so the feature introduces
    itself rather than turning up unannounced as loot drawn somewhere the player
    did not choose.

    Core's CHAT_MSG_LOOT calls ns.ShowLootToast after its own work, only for the
    player's own loot, so the prefix match is already done by then, and its
    CHAT_MSG_MONEY calls ns.ShowMoneyToast for the one kind of loot that has no
    item behind it at all.
]]

local TOAST_HANDLE_WIDTH = 400 -- The drag handle only; rows size themselves
local TOAST_HEIGHT = 24 -- Minimum row height; large fonts raise it, see RowHeight
local TOAST_SPACING = 8 -- Gap between rows, so entries read as separate lines
local TOAST_TEXT_PADDING = 6 -- Breathing room above and below the text itself

--[[
    The handle carries its caption as three blank-line-separated rows - the name
    and the two gestures - over a button in the bottom corner, so it stands as a
    panel rather than a strip of text the bottom toast row sits on top of.

    BOTH NUMBERS ARE FIXED, never font-derived: the handle marks where rows start,
    so a size that drifted with the font would walk the whole stack. The height
    holds the caption's five rendered lines (three rows and the two blanks between
    them) from the top, the button in the bottom corner, and the padding at both
    ends -- plus air between the two, which is what the height is really for. The
    caption hangs from the top and the button sits on the bottom, so every pixel
    added here lands in the gap between them; too little and the button crowds the
    last line of text.

    The caption keeps to its own column at one end, and rows hang off the other
    end (see ns.db.profile.lootToastAlign), so the two never share horizontal
    space. The width is set by the longest row rather than by the panel: wide
    enough that the title never wraps.
]]
local TOAST_HANDLE_HEIGHT = 130
local TOAST_HANDLE_LABEL_WIDTH = 260
local TOAST_HANDLE_BUTTON_WIDTH = 150
local TOAST_HANDLE_BUTTON_HEIGHT = 22
local TOAST_HANDLE_PADDING = 10

--[[
    Everything in a row is measured from the font size, so the layout holds its
    proportions instead of only looking right at the default.

    The icon ratio came from the pairing that looked correct - a font size beside
    an icon half again its height - and holds at any size because it is a ratio.
    A fixed icon size was the bug: raise the font and the same icon shrinks
    against it and reads as an afterthought. 1.5 is also about right
    typographically: a font "size" is the em box and capitals fill roughly 0.7 of
    it, so the icon sits just above the text's visual line height and stays the
    thing the eye lands on first.
]]
local ICON_TO_FONT_RATIO = 1.5
local ICON_TEXT_GAP_RATIO = 1 / 3 -- Same origin: a gap a third of the font size

--[[
    How wide a row is allowed to get: room for roughly 64 characters at any size,
    since a glyph averages about half the em box. That clears the longest thing
    Classic can name - a random-suffix weapon like "Decapitating Sword of the
    Monkey" - with headroom for a quantity suffix.

    It has to scale with the font rather than being a fixed number of pixels:
    doubling the font halves how many characters fit in a given width, so a width
    generous at the low end of the size range truncates names at the high end.

    This is a ceiling, not the row's working width. Measure sizes the text box to
    the string itself and only clamps to this when a name overruns it, at which
    point wrapping is off (a row is a fixed height, so a second line would spill
    over its neighbour) and the name truncates instead. The frame draws nothing
    itself, so the width costs nothing visually.
]]
local TEXT_WIDTH_RATIO = 32

--[[
    How many sample rows the unlock preview stands in when the cap is set to
    Unlimited - there is no count to mirror then, so it shows the shipped
    default instead.
]]
local SAMPLE_COUNT_UNLIMITED = 8

local anchor
local pool = {}
local active = {}
local samples = {}

--------------------------------------------------------------------------------
-- Appearance
--------------------------------------------------------------------------------

--[[
    Fonts come from LibSharedMedia, the registry ElvUI, Details, WeakAuras and
    the rest publish into. Open Sesame ships it, so the dropdown is never empty:
    on its own the library still registers the faces the WoW client itself
    carries, and on a client running anything else that uses it the player gets
    that whole shared library here instead.

    LSM also masks its list by locale, so a koKR client is only ever offered
    faces that can draw Korean.
]]

--[[
    DEFAULT is our own sentinel, not a registered face: it resolves to whatever
    GameFontNormal is currently using, which is the only correct answer on a
    locale whose client ships its own font. Anything the library no longer knows
    falls back to that same face rather than to nothing.
]]
local function FontPath(value, defaultPath)
	if not value or value == "DEFAULT" then
		return defaultPath
	end
	return LSM:IsValid("font", value) and LSM:Fetch("font", value) or defaultPath
end

--[[
    Rebuilt on every call rather than cached, so a face registered by an add-on
    that loaded after this one still turns up the next time the dropdown opens.
]]
function ns.GetLootToastFontChoices()
	local values = { DEFAULT = ns.L["OPTIONS_FONT_DEFAULT"] }
	local sorting = { "DEFAULT" }
	for _, name in ipairs(LSM:List("font")) do
		values[name] = name
		sorting[#sorting + 1] = name
	end
	return values, sorting
end

--[[
    THE FLAG STRING CARRIES THE WEIGHT, because the client offers no bold. SetFont
    takes a face, a size and a flag string, and that string is the only control
    over how heavy the glyphs land: there is no weight axis and no bold cut of
    Friz Quadrata to swap to. So a thicker outline is what reads as heavier
    against a bright world background.

    Four of the five stored values are the flag string the client wants verbatim;
    "NONE" is ours and resolves to the empty string SetFont expects.
]]
local function ResolveFlags()
	local flags = ns.db and ns.db.profile.lootToastFontFlags
	if not flags or flags == "NONE" then
		return ""
	end
	return flags
end

--[[
    Resolved once per restack and passed down, not re-read per row: every row in a
    pass uses the same face, and FontPath goes through LibSharedMedia's registry.

    Deliberately NOT cached across restacks - a face can be registered by an
    add-on that loads after this one, and re-resolving each pass is what lets a
    font change reach rows already on screen.
]]
local function ResolveFont()
	local fallbackPath = GameFontNormal:GetFont()
	local size = (ns.db and ns.db.profile.lootToastFontSize) or ns.LOOT_TOAST_FONT_SIZE_MIN
	return FontPath(ns.db and ns.db.profile.lootToastFont, fallbackPath), size, ResolveFlags(), fallbackPath
end

--[[
    The flags are the client's own, so the outline is drawn by the font system
    rather than faked with a shadow. It reads against a bright world background,
    which is the whole reason a toast needs one. The flags ride both SetFont
    calls, so a face that fails to load keeps its weight on the fallback.
]]
local function ApplyFont(fontString, path, size, flags, fallbackPath)
	if fontString:SetFont(path, size, flags) == false then
		fontString:SetFont(fallbackPath, size, flags)
	end
end

local function FontSize()
	return (ns.db and ns.db.profile.lootToastFontSize) or ns.LOOT_TOAST_FONT_SIZE_MIN
end

local function IconSize()
	return math.floor(FontSize() * ICON_TO_FONT_RATIO + 0.5)
end

local function IconGap()
	return math.max(2, math.floor(FontSize() * ICON_TEXT_GAP_RATIO))
end

--[[
    The Unlimited choice is stored as 0, which must never reach the cap
    arithmetic as a number: `#active >= 0` is always true, so it would retire
    every row the instant it was drawn. It resolves to infinity instead, which
    makes the same comparison simply never fire.
]]
local function MaxVisible()
	local limit = ns.db and ns.db.profile.lootToastMaxVisible
	if not limit or limit <= ns.LOOT_TOAST_UNLIMITED then
		return math.huge
	end
	return limit
end

local function RowWidth()
	return IconSize() + IconGap() + math.floor(FontSize() * TEXT_WIDTH_RATIO)
end

--[[
    Which end of the anchor a row hangs off, and which side of the row its icon
    takes. The handle's caption always goes to the opposite end, so the preview
    text and the rows can never collide.
]]
local function AlignsRight()
	return ns.db ~= nil and ns.db.profile.lootToastAlign == "RIGHT"
end

--[[
    The row clears the icon, which the ratio above keeps taller than the text. At
    the default size this lands exactly on TOAST_HEIGHT, so the usual case looks
    unchanged; a larger font grows the row rather than spilling over the one above.
]]
local function RowHeight()
	return math.max(TOAST_HEIGHT, IconSize() + TOAST_TEXT_PADDING)
end

--[[
    One owner for every font-dependent measurement AND for the row's internal
    layout, run from Restack, so a change to the font, size, or alignment reaches
    toasts already on screen instead of only the next one drawn.

    Left-aligned, the icon leads and the name runs right from it; right-aligned,
    the icon trails and the name runs back toward it, justified so the text ends
    against the icon rather than trailing off into empty frame.
]]
local function Measure(toast, path, size, flags, fallbackPath)
	local icon = IconSize()
	local gap = IconGap()
	toast:SetSize(RowWidth(), RowHeight())
	toast.icon:SetSize(icon, icon)
	toast.icon:ClearAllPoints()
	toast.text:ClearAllPoints()

	-- Font first: SetFont resets a font string's justification, so justifying
	-- before it silently loses the setting on whichever rows it touches.
	ApplyFont(toast.text, path, size, flags, fallbackPath)

	--[[
        THE TRAP: a text box spanning the whole row makes the name's position
        depend on justifyH, so one row holding a stale justification stranded its
        name at the far end of the row - hundreds of pixels from its own icon.

        The box is sized to the string instead (SetWidth(0) auto-sizes) and
        pinned directly to the icon, so the glyphs sit against the icon by
        geometry rather than by justification. Only a name too long for the row
        takes a fixed width, and it fills that box, so justification cannot move
        it far either way.
    ]]
	toast.text:SetWidth(0)
	if AlignsRight() then
		toast.icon:SetPoint("RIGHT")
		toast.text:SetPoint("RIGHT", toast.icon, "LEFT", -gap, 0)
		toast.text:SetJustifyH("RIGHT")
	else
		toast.icon:SetPoint("LEFT")
		toast.text:SetPoint("LEFT", toast.icon, "RIGHT", gap, 0)
		toast.text:SetJustifyH("LEFT")
	end

	local maxTextWidth = RowWidth() - icon - gap
	if toast.text:GetStringWidth() > maxTextWidth then
		toast.text:SetWidth(maxTextWidth)
	end
end

--------------------------------------------------------------------------------
-- Anchor
--------------------------------------------------------------------------------

--[[
    The anchor is the fixed point toasts stack from. Its saved point lives in
    ns.db.global.lootToastPosition — presentation state, account-wide alongside
    the Ignore List, because where a player wants this on their screen is not a
    per-character decision.
]]
local function GetAnchor()
	if anchor then
		return anchor
	end
	anchor = CreateFrame("Button", "OpenSesameLootToastAnchor", UIParent)
	-- Fixed: the handle marks where rows start, so its own size must not drift
	-- with the font, or changing the font size would walk the whole stack sideways.
	anchor:SetSize(TOAST_HANDLE_WIDTH, TOAST_HANDLE_HEIGHT)
	anchor:SetMovable(true)
	anchor:SetClampedToScreen(true)
	anchor:Hide()

	anchor.background = anchor:CreateTexture(nil, "BACKGROUND")
	anchor.background:SetAllPoints()
	anchor.background:SetColorTexture(0, 0, 0, 0.5)

	--[[
        A width of its own, so the caption keeps to its column and a long
        translated title wraps inside the handle instead of running under the
        rows at the far end. Anchored from the TOP rather than centred, because a
        button hangs off its bottom edge and the two have to stack predictably.
    ]]
	anchor.label = anchor:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	anchor.label:SetWidth(TOAST_HANDLE_LABEL_WIDTH)
	anchor.label:SetJustifyV("TOP")

	--[[
        The way out, offered where the feature is: a player meeting toasts for the
        first time should not have to find an options panel to decline them. The
        options checkbox says the same thing and stays the place to turn them back
        on, which is what the line above this button is for.
    ]]
	anchor.disable = CreateFrame("Button", nil, anchor, "UIPanelButtonTemplate")
	anchor.disable:SetSize(TOAST_HANDLE_BUTTON_WIDTH, TOAST_HANDLE_BUTTON_HEIGHT)
	anchor.disable:SetText(ns.L["OPTIONS_TOASTS_DISABLE_BUTTON"])
	anchor.disable:SetScript("OnClick", function()
		ns.DismissLootToastIntro()
		ns.SetLootToastsEnabled(false)
	end)

	anchor:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	anchor:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		ns.SaveLootToastPosition()
	end)

	--[[
        Locking from the handle itself, so a player who dragged it somewhere odd
        does not have to find the options panel again to put it away. Left drag
        moves, right click locks, and the handle says so.
    ]]
	anchor:RegisterForClicks("RightButtonUp")
	anchor:SetScript("OnClick", function()
		ns.DismissLootToastIntro()
		ns.SetLootToastsUnlocked(false)
	end)
	return anchor
end

-- The read-only half of GetAnchor, for callers that must not create the frame.
-- Returns nil until something has actually raised the handle.
function ns.GetLootToastAnchorFrame()
	return anchor
end

--[[
    Pin the handle's caption to the end the rows do NOT use and justify it into
    that end, then put the button in the corner below it, on the same end and at
    the same inset - so its edge lines up with the text's rather than floating.
    Both are anchored to the panel rather than to each other: the caption hangs
    from the top, the button sits on the bottom, and the air between them is
    whatever the height leaves over.

    Re-run on every appearance change, since the alignment setting can flip which
    end all of this belongs to.
]]
local function ApplyHandleLayout()
	local frame = GetAnchor()
	frame.label:ClearAllPoints()
	frame.disable:ClearAllPoints()
	if AlignsRight() then
		frame.label:SetPoint("TOPLEFT", frame, "TOPLEFT", TOAST_HANDLE_PADDING, -TOAST_HANDLE_PADDING)
		frame.label:SetJustifyH("LEFT")
		frame.disable:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", TOAST_HANDLE_PADDING, TOAST_HANDLE_PADDING)
	else
		frame.label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -TOAST_HANDLE_PADDING, -TOAST_HANDLE_PADDING)
		frame.label:SetJustifyH("RIGHT")
		frame.disable:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -TOAST_HANDLE_PADDING, TOAST_HANDLE_PADDING)
	end
end

function ns.ApplyLootToastPosition()
	local frame = GetAnchor()
	local saved = ns.db and ns.db.global.lootToastPosition
	frame:ClearAllPoints()
	if saved and saved.point then
		frame:SetPoint(saved.point, UIParent, saved.relativePoint, saved.x, saved.y)
	else
		-- Default: above centre, clear of the action bars and the chat frame.
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
	end
end

function ns.SaveLootToastPosition()
	local frame = GetAnchor()
	local point, _, relativePoint, x, y = frame:GetPoint()
	ns.db.global.lootToastPosition = { point = point, relativePoint = relativePoint, x = x, y = y }
end

function ns.ResetLootToastPosition()
	ns.db.global.lootToastPosition = {}
	ns.ApplyLootToastPosition()
end

--[[
    Unlocking shows the anchor as a draggable handle so the player can see what
    they are moving; locking hides it again. Purely visual, no secure frames.
]]
function ns.SetLootToastsUnlocked(unlocked)
	local frame = GetAnchor()
	if unlocked then
		--[[
            The name, then the two gestures the handle answers to, in the order a
            player meets them: drag it where they want it, then put it away. The
            way out of the feature entirely is the button below, not a third line
            of text - saying it twice was one line too many.

            Blank lines between: three sentences stacked tight read as a
            paragraph, spaced out they read as a list of things to try.

            Body white rather than helper silver. Silver is for text beside
            something brighter that carries the point; here these lines ARE the
            point, and they are read over open world at whatever the ground
            happens to be.
        ]]
		local body = ns.GetColor("BODY")
		local function BodyLine(key)
			return "\n\n" .. body .. ns.L[key] .. "|r"
		end
		frame.label:SetText(
			ns.GetColor("TITLE")
				.. ns.L["ADDON_TITLE"]
				.. " "
				.. ns.L["LOOT_TOASTS"]
				.. "|r"
				.. BodyLine("OPTIONS_TOASTS_CLICK_DRAG")
				.. BodyLine("OPTIONS_TOASTS_RIGHT_CLICK_LOCK")
		)
		frame:RegisterForDrag("LeftButton")
		frame:EnableMouse(true)
		frame:Show()
	else
		frame:RegisterForDrag()
		frame:EnableMouse(false)
		frame:Hide()
	end
	ns.lootToastsUnlocked = unlocked and true or false
	ns.RefreshLootToastSamples()
end

function ns.AreLootToastsUnlocked()
	return ns.lootToastsUnlocked == true
end

--------------------------------------------------------------------------------
-- The Introduction
--------------------------------------------------------------------------------

--[[
    TOASTS SHIP ON, so the first a player would otherwise know about them is loot
    they did not ask to see drawn somewhere they did not choose. So a profile that
    has never dismissed the handle gets it raised at login: it says what the
    feature is, where it will draw, how to move it, how to put it away, and offers
    a button to decline the whole thing. It is the feature introducing itself.

    Dismissing is the player's, and it is remembered per profile - which is what
    makes a new or reset profile show it again, deliberately, since that profile
    has not been told either. Any of the three ways out counts as being told: the
    right-click the handle advertises, the Disable button on it, and the panel's
    own Lock button.
]]
function ns.DismissLootToastIntro()
	if ns.db then
		ns.db.profile.lootToastsIntroSeen = true
	end
end

function ns.ShowLootToastIntro()
	if not ns.db or ns.db.profile.lootToastsIntroSeen or not ns.db.profile.lootToasts then
		return
	end
	ns.SetLootToastsUnlocked(true)
end

--[[
    Re-apply the active profile's toast settings, called from Core's ApplyProfile
    on a profile switch, reset, or copy.

    A switch settles the handle to locked first in every case: hidden outright
    when the incoming profile has the feature off, and hidden rather than left up
    when it has it on, because unlocking is a runtime choice the profile does not
    carry. ns.SetLootToastsUnlocked(false) does both, and the
    RefreshLootToastSamples it calls re-runs Measure over every row still on
    screen, so the incoming profile's alignment, growth, font, and size reach
    toasts already drawn instead of waiting for a reload.

    THEN the incoming profile gets its own introduction, if it is owed one. A
    fresh profile - new, or reset back to defaults - has never dismissed the
    handle, so it meets the feature the same way a new player does.
]]
function ns.ApplyLootToastSettings()
	ns.SetLootToastsUnlocked(false)
	ns.ShowLootToastIntro()
end

--[[
    Toggling the feature owns the handle in both directions, and lives here
    rather than in the options table because it is what the feature does, not
    what the panel looks like.

    Switching it on raises the handle and its samples. The player has just turned
    on something that draws on their screen and has no other way to find out
    where it will draw or how big it will be - the alternative is looting
    something and hoping. Switching it off puts the handle away, or it would be
    left on screen with nothing behind it.

    The panel is told either way, because this is now reachable from OUTSIDE the
    panel - the handle's own Disable button - and a checkbox left ticked for a
    feature the player just turned off is worse than no checkbox at all.
]]
function ns.SetLootToastsEnabled(enabled)
	ns.db.profile.lootToasts = enabled and true or false
	ns.SetLootToastsUnlocked(ns.db.profile.lootToasts)
	LibStub("AceConfigRegistry-3.0"):NotifyChange(ns.OPTIONS_REGISTRY.Notifications)
end

--------------------------------------------------------------------------------
-- Toast Frames
--------------------------------------------------------------------------------

local function AcquireToast()
	local toast = table.remove(pool)
	if toast then
		toast.pooled = nil
		return toast
	end
	toast = CreateFrame("Frame", nil, UIParent)

	-- Both are positioned by Measure, which owns the row's layout per alignment.
	toast.icon = toast:CreateTexture(nil, "ARTWORK")

	toast.text = toast:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	-- One line, always. An over-long name ellipsizes rather than breaking the row.
	toast.text:SetWordWrap(false)

	toast.fade = toast:CreateAnimationGroup()
	toast.fadeOut = toast.fade:CreateAnimation("Alpha")
	toast.fadeOut:SetFromAlpha(1)
	toast.fadeOut:SetToAlpha(0)
	toast.fadeOut:SetDuration(ns.LOOT_TOAST_FADE_DURATION)
	toast.fade:SetScript("OnFinished", function(group)
		ns.ReleaseLootToast(group:GetParent())
	end)
	return toast
end

--[[
    The dwell is a setting, so it is stamped on the animation at play time rather
    than when the frame was built - a pooled toast outlives any one choice.
]]
local function PlayFade(toast)
	toast.fadeOut:SetStartDelay(ns.db.profile.lootToastDuration)
	toast.fade:Play()
end

--[[
    `active` runs oldest-first, and the offset is measured from the END of the
    list, so the newest entry sits at the anchor and age carries a row away from
    it. The growth setting picks the direction: "UP" hangs rows off the anchor's
    bottom edge and ages them upward, "DOWN" mirrors the geometry off the top
    edge and ages them downward. Either way the newest row lands exactly on the
    handle the player placed.

    The arithmetic is what makes the two movements right. Adding an entry raises
    `count`, so every row already on screen gains exactly one step - the stack
    grows away from the anchor. Retiring the oldest drops `count` and every
    survivor's index by one together, which cancels: nothing near the anchor
    twitches to fill the gap the departing row left at the far end.

    Rows hang off the anchor's LEFT edge, not its centre. Centred, a row's width
    would decide where its icon landed, so widening a row to fit longer names
    would drag the text sideways and a font change would walk the stack across
    the screen. Anchored left, width only sets where the text runs out.
]]
local function Restack()
	local count = #active
	local step = RowHeight() + TOAST_SPACING
	local growDown = ns.db and ns.db.profile.lootToastGrowth == "DOWN"
	--[[
        The two settings pick one corner of the anchor between them, and a row is
        pinned corner-to-corner with it: growth picks TOP or BOTTOM, alignment
        picks LEFT or RIGHT. Ageing then carries rows away from that corner along
        the growth axis only.
    ]]
	local corner = (growDown and "TOP" or "BOTTOM") .. (AlignsRight() and "RIGHT" or "LEFT")
	local path, size, flags, fallbackPath = ResolveFont()
	for index, toast in ipairs(active) do
		Measure(toast, path, size, flags, fallbackPath)
		toast:ClearAllPoints()
		local offset = (count - index) * step
		toast:SetPoint(corner, GetAnchor(), corner, 0, growDown and -offset or offset)
	end
end

--[[
    THE TRAP: callers loop until a list shrinks - ReleaseSamples on `samples`,
    ns.ApplyLootToastLimit and ns.ShowLootToast on `active` - so a release that
    removed nothing would spin forever and freeze the client. The list removals
    below therefore ALWAYS run, guarded by nothing, and every call makes progress.

    Only the pooling is idempotent: stopping the fade can fire its own OnFinished,
    which releases the same frame again, and pushing it into the pool twice would
    hand one frame out as two rows so a row silently goes missing.
]]
function ns.ReleaseLootToast(toast)
	for index, candidate in ipairs(samples) do
		if candidate == toast then
			table.remove(samples, index)
			break
		end
	end
	for index, candidate in ipairs(active) do
		if candidate == toast then
			table.remove(active, index)
			break
		end
	end
	if not toast.pooled then
		toast.pooled = true
		toast.fade:Stop()
		toast:Hide()
		toast:SetAlpha(1)
		pool[#pool + 1] = toast
	end
	Restack()
end

--------------------------------------------------------------------------------
-- Entry Point
--------------------------------------------------------------------------------

--[[
    Quantity arrives as an "x2" suffix on the loot message rather than in the
    link, so it is parsed off the message. A single item carries no suffix and
    renders as the plain name.
]]
local function ParseQuantity(message)
	if not message then
		return 1
	end
	return tonumber(message:match("x(%d+)%s*%.?%s*$")) or 1
end

--[[
    Seven kinds of item are worth seeing whatever the quality threshold says, each
    behind its own toggle, because for all seven the item's colour is a poor guide
    to whether the player cares: a quest item, the one pickup they may be actively
    watching for, is usually Common; so is a recipe worth more than the greens
    around it; a mount or a pet is a moment regardless of tier; and a bag is the
    pickup that decides whether the rest of the run fits. Bind on Pickup is the
    broad one, and it earns its keep on the items no list names.

    A container Open Sesame can open earns its place differently - the toast is the
    player's cue that the ADD-ON is about to act - which is why that one tests for
    presence in ns.AllowedItems rather than for the true value, so a still-locked
    box counts as much as an openable one.

    ORDER HERE IS BY COST, and deliberately not the order the options panel lists
    them in. The table lookup is free, the GetItemInfoInstant reads answer from the
    client's own database, and Bind on Pickup goes last because it is the only one
    needing the full GetItemInfo. That call can answer nil on a cold cache, which
    reads here as "not Bind on Pickup" and leaves the threshold to decide -
    acceptable, because the item was just looted, which is the one moment the
    client is certain to have it cached.
]]
local function AlwaysShown(itemId)
	if not itemId then
		return false
	end
	local profile = ns.db.profile
	if profile.lootToastContainers and ns.AllowedItems[itemId] ~= nil then
		return true
	end

	local _, _, _, _, _, classId, subclassId = GetItemInfoInstant(itemId)
	if profile.lootToastQuestItems and classId == ns.ITEM_CLASS_QUEST then
		return true
	end
	if profile.lootToastRecipes and classId == ns.ITEM_CLASS_RECIPE then
		return true
	end
	if profile.lootToastKeys and classId == ns.ITEM_CLASS_KEY then
		return true
	end
	if profile.lootToastBags and (classId == ns.ITEM_CLASS_BAG or classId == ns.ITEM_CLASS_QUIVER) then
		return true
	end
	if classId == ns.ITEM_CLASS_MISCELLANEOUS then
		if profile.lootToastMounts and subclassId == ns.ITEM_SUBCLASS_MOUNT then
			return true
		end
		if profile.lootToastPets and subclassId == ns.ITEM_SUBCLASS_COMPANION_PET then
			return true
		end
	end

	if profile.lootToastBindOnPickup and select(14, GetItemInfo(itemId)) == ns.ITEM_BIND_ON_PICKUP then
		return true
	end

	--[[
        Last, because it is the only question that costs a tooltip. A quest STARTER
        rides with quest items rather than under a toggle of its own: it is the
        same "do not walk away from this" case, and the class test above misses it
        entirely, since a starter is as often an ordinary trinket or blade as it is
        class 12.
    ]]
	return profile.lootToastQuestItems and ns.ItemStartsQuest(itemId)
end

--[[
    Everything a row does once its icon and text are decided, shared so an item and
    a coin pile reach the screen the same way.

    The cap is enforced by retiring the OLDEST toast rather than dropping the new
    one: a burst of loot should show what just arrived, not freeze on the first
    five entries.
]]
local function PushToast(icon, text)
	while #active >= MaxVisible() do
		ns.ReleaseLootToast(active[1])
	end
	local toast = AcquireToast()
	toast.icon:SetTexture(icon)
	toast.text:SetText(text)
	toast:SetAlpha(1)
	toast:Show()
	active[#active + 1] = toast
	Restack()
	PlayFade(toast)
end

function ns.ShowLootToast(link, message)
	if not link or not ns.db or not ns.db.profile.lootToasts then
		return
	end

	local itemId = tonumber(link:match("item:(%d+)"))

	--[[
        Below the player's chosen quality, stay quiet, unless the item is one of
        the always-shown kinds above. An unmapped colour reads as nil and is shown
        anyway: a toast is a display, and silently swallowing something the player
        did loot is the worse failure.
    ]]
	local quality = ns.GetLinkQuality(link)
	if quality and quality < ns.db.profile.lootToastThreshold and not AlwaysShown(itemId) then
		return
	end

	--[[
        The square brackets a link carries are chat punctuation - they mark where
        a link starts and ends in a wall of running text. A toast is one item on
        its own line, so they only add noise. The quality colour still says it is
        an item, and the escape sequence is left intact so the text stays a real
        link rather than a lookalike.
    ]]
	local quantity = ParseQuantity(message)
	local name = (link:gsub("|h%[(.-)%]|h", "|h%1|h"))
	PushToast(itemId and GetItemIcon(itemId) or nil, quantity > 1 and (name .. " x" .. quantity) or name)
end

--[[
    COIN IS THE ONLY LOOT WITH NO ITEM BEHIND IT: no link, no icon of its own, no
    quality, and so nothing the threshold or the always-shown kinds could ever have
    an opinion about. It gets a toast on its own terms, or with the loot window
    hidden it leaves no trace outside the chat log at all.

    Its own toggle for the same reason it needs a toast: every kill drops coin, so
    this is the row a player will see most often, and the one they are most likely
    to want gone.
]]
function ns.ShowMoneyToast(copper)
	if not copper or copper <= 0 or not ns.db or not ns.db.profile.lootToasts then
		return
	end
	if not ns.db.profile.lootToastMoney then
		return
	end
	--[[
        FormatMoney colours itself - white numbers, each suffix in its own coin's
        colour - so nothing is wrapped around it here. A colour applied over the
        top would flatten exactly the distinction the format exists to make.
    ]]
	PushToast(ns.MoneyIcon(copper), ns.FormatMoney(copper))
end

--------------------------------------------------------------------------------
-- Samples
--------------------------------------------------------------------------------

--[[
    While the handle is up, stand in one "Example Item" sample per row the cap
    allows, each in a random quality at or above the Minimum Quality, with a
    potion icon colour-matched to that quality (ns.LOOT_TOAST_SAMPLE_ICONS).
    The preview does three jobs at once: it shows where the stack will sit and
    how many rows it holds, what the chosen font and size look like, and which
    tiers the Minimum Quality setting is letting through.

    Samples are cleared and rebuilt on every appearance change, and the re-roll
    is deliberate: the reshuffled colours make the preview visibly answer each
    change instead of sitting static. Samples never fade; they are released
    outright when the handle goes away.
]]

local function ReleaseSamples()
	-- ReleaseLootToast takes the frame out of `samples` itself, so drain the tail.
	while #samples > 0 do
		ns.ReleaseLootToast(samples[#samples])
	end
end

--[[
    Called when the player changes the cap. Trimming here rather than waiting for
    the next loot means the setting they just picked is the one on screen while
    they are still looking at it.
]]
function ns.ApplyLootToastLimit()
	while #active > MaxVisible() do
		ns.ReleaseLootToast(active[1])
	end
	ns.RefreshLootToastSamples()
end

function ns.RefreshLootToastSamples()
	ReleaseSamples()
	ApplyHandleLayout()
	-- Restack still runs when the handle is locked, so a growth, alignment, font,
	-- or size change with real toasts on screen re-hangs and re-measures them too.
	if ns.db and ns.AreLootToastsUnlocked() then
		local rows = MaxVisible()
		if rows == math.huge then
			rows = SAMPLE_COUNT_UNLIMITED
		end
		local lowestQuality = ns.db.profile.lootToastThreshold
		for _ = 1, rows do
			-- 5 is Legendary, the top of ns.LOOT_TOAST_SAMPLE_ICONS.
			local quality = math.random(lowestQuality, 5)
			local toast = AcquireToast()
			toast.icon:SetTexture(ns.LOOT_TOAST_SAMPLE_ICONS[quality])
			toast.text:SetText(ITEM_QUALITY_COLORS[quality].hex .. ns.L["OPTIONS_TOASTS_EXAMPLE_ITEM"] .. "|r")
			toast:SetAlpha(1)
			toast:Show()
			active[#active + 1] = toast
			samples[#samples + 1] = toast
		end
	end
	Restack()
end
