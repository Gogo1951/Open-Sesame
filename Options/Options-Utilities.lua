local ADDON_NAME, ns = ...

local GetColor = ns.GetColor
local AceGUI = LibStub("AceGUI-3.0")

--------------------------------------------------------------------------------
-- Options Helpers
--------------------------------------------------------------------------------

function ns.OptionsHeader(text, order, hidden)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = hidden }
end

function ns.OptionsDesc(text, order)
	return { type = "description", name = text, fontSize = "medium", order = order }
end

function ns.OptionsSpacer(order)
	return { type = "description", name = " ", order = order }
end

function ns.OptionsRowLabel(text, order, width)
	return {
		type = "description",
		name = text,
		fontSize = "medium",
		width = width or ns.OPTIONS_LABEL_WIDTH,
		order = order,
	}
end

--------------------------------------------------------------------------------
-- Sub-Option Rows
--------------------------------------------------------------------------------

--[[
    A sub-option only means anything while the toggle above it is on, and is
    marked two ways at once so the dependency reads whether the player is
    scanning shape or colour: an indented checkbox and a silver caption.

    The indent has to be a real widget - AceConfig pins a checkbox at the left
    edge of its own widget, so padding the caption with spaces moves only the
    text. One unnamed inline group per sub-option: a fill widget always takes a
    line to itself, so the group pins exactly one row. `hidden` belongs on the
    group, never on the members, or the indent is left behind on its own line
    when the section collapses.

    Three panels build sub-rows, so the shape lives here rather than being copied
    into each of them, where the copies would drift apart.
]]
function ns.OptionsSubLabel(text)
	return GetColor("HELP") .. text .. "|r"
end

function ns.OptionsSubRow(order, hidden, controls)
	local args = {
		subIndent = {
			type = "description",
			name = " ",
			width = ns.OPTIONS_SUB_INDENT_WIDTH,
			order = 1,
		},
	}
	for index, control in ipairs(controls) do
		control.order = index + 1
		args["subControl" .. index] = control
	end
	return { type = "group", name = "", inline = true, order = order, hidden = hidden, args = args }
end

--[[
    A caption beside a control, as one sub-row. The shape both quality dropdowns,
    both lockbox scopes and the auto-open rules all use.
]]
--[[
    labelWidth is for a panel whose captions are longer than the shared default
    holds; it pairs with a narrower control so the row still totals the same.
]]
function ns.OptionsSubSelectRow(order, hidden, caption, control, labelWidth)
	control.name = ""
	control.width = control.width or ns.OPTIONS_SUB_CONTROL_WIDTH
	return ns.OptionsSubRow(order, hidden, {
		ns.OptionsRowLabel(ns.OptionsSubLabel(caption), nil, labelWidth or ns.OPTIONS_SUB_LABEL_WIDTH),
		control,
	})
end

--------------------------------------------------------------------------------
-- Item Link Widget
--------------------------------------------------------------------------------

--[[
    A read-only AceGUI widget drawing one item's icon and coloured link, with the
    game's own tooltip on hover. AceConfig has no item-link control, so item-list
    rows reach it through dialogControl = ns.ITEM_LINK_WIDGET_TYPE.

    Registered under the add-on's own prefixed type name so it can never collide
    with another add-on's widget of the same idea.
]]
ns.ITEM_LINK_WIDGET_TYPE = ADDON_NAME .. "_ItemLink"

local ITEM_LINK_WIDGET_VERSION = 1
local ITEM_LINK_ICON_SIZE = 16

--[[
    The row's own tooltip, plus the reason the row exists. AceConfigDialog's
    InjectInfo hangs the whole option table off the widget's user data, so the
    note travels as the option's `desc` with no extra plumbing — and because this
    widget swallows AceConfigDialog's OnEnter, the note has to be drawn here or it
    would never appear at all.
]]
local function ItemLinkOnEnter(frame)
	local widget = frame.obj
	if not widget.itemLink then
		return
	end
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink(widget.itemLink)
	local option = widget:GetUserDataTable().option
	local note = option and option.desc
	if note then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(GetColor("TITLE") .. ns.L["ADDON_TITLE"] .. "|r")
		GameTooltip:AddLine(GetColor("HELP") .. note .. "|r", nil, nil, nil, true)
	end
	GameTooltip:Show()
end

local function ItemLinkOnLeave()
	GameTooltip:Hide()
end

local function CreateItemLinkWidget()
	local frame = CreateFrame("Button", nil, UIParent)
	frame:SetHeight(20)
	frame:SetScript("OnEnter", ItemLinkOnEnter)
	frame:SetScript("OnLeave", ItemLinkOnLeave)

	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
	icon:SetSize(ITEM_LINK_ICON_SIZE, ITEM_LINK_ICON_SIZE)

	local label = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	label:SetPoint("LEFT", icon, "RIGHT", 4, 0)
	label:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	label:SetJustifyH("LEFT")

	local widget = {
		type = ns.ITEM_LINK_WIDGET_TYPE,
		frame = frame,
		icon = icon,
		label = label,
		OnAcquire = function(self)
			self:SetWidth(200)
			self:SetText()
		end,
		OnRelease = function(self)
			self.itemLink = nil
		end,
		--[[
            AceConfig hands an input widget its value through SetText. The value
            is the item link itself, so the widget parses the id back out of it
            for the icon rather than being told twice.
        ]]
		SetText = function(self, text)
			self.itemLink = text
			if not text or text == "" then
				self.icon:SetTexture(nil)
				self.label:SetText("")
				return
			end
			local itemId = tonumber(text:match("item:(%d+)"))
			self.icon:SetTexture(itemId and GetItemIcon(itemId) or nil)
			self.label:SetText(text)
		end,
		-- Read-only display: AceConfigDialog drives an input control through these.
		SetLabel = function() end,
		SetDisabled = function() end,
		SetCallback = function() end,
		DisableButton = function() end,
		SetMaxLetters = function() end,
	}
	frame.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(ns.ITEM_LINK_WIDGET_TYPE, CreateItemLinkWidget, ITEM_LINK_WIDGET_VERSION)

--------------------------------------------------------------------------------
-- Item Cache Warming
--------------------------------------------------------------------------------

--[[
    GetItemInfo returns nil until the client has the item, so a freshly-logged-in
    player would see bare ids where item links belong. Rows report outstanding ids
    here; Core's GET_ITEM_INFO_RECEIVED handler calls back through
    ns.OnItemInfoReceived, the list redraws as answers arrive, and the callback is
    cleared once nothing is outstanding so the dispatcher stops doing work.
]]
local outstandingItems = {}
local outstandingRegistry

local function ClearItemInfoWatcher()
	ns.OnItemInfoReceived = nil
	outstandingRegistry = nil
end

local function OnItemInfoReceived(itemId)
	if not outstandingItems[itemId] then
		return
	end
	outstandingItems[itemId] = nil
	local registryName = outstandingRegistry
	if not next(outstandingItems) then
		ClearItemInfoWatcher()
	end
	if registryName then
		LibStub("AceConfigRegistry-3.0"):NotifyChange(registryName)
	end
end

function ns.WatchUncachedItem(itemId, registryName)
	outstandingItems[itemId] = true
	outstandingRegistry = registryName
	ns.OnItemInfoReceived = OnItemInfoReceived
end

--------------------------------------------------------------------------------
-- Item Lists
--------------------------------------------------------------------------------

--[[
    The shared player-managed item-list builder. A panel supplies its labels, the
    source table, and the onAdd / onRemove / onRestore callbacks; the shape of the
    list is owned here so every add-on's lists look and behave the same.

    Rows are sorted by item NAME, not id — an id-ordered list reads as random.
    Uncached rows sort under their raw id until the client answers, then the
    refresh watcher above redraws them in place.

    An optional config.noteFor(itemId) supplies a per-row explanation, carried as
    the option's `desc` and drawn into the row's tooltip by the item-link widget.

    Ids this client cannot resolve are dropped before a row is ever built. A saved
    list can hold ids from a later expansion (the list is account-wide and the
    defaults have since been expansion-filtered); GetItemInfoInstant answers
    synchronously from the client's own database, so it separates "not cached yet"
    from "does not exist here" without waiting on an event that will never fire.
]]
local REMOVE_ICON = "Interface/Buttons/UI-GroupLoot-Pass-Up"
local REMOVE_ICON_SIZE = 16

local function ParseItemId(input)
	if not input then
		return nil
	end
	local fromLink = input:match("item:(%d+)")
	if fromLink then
		return tonumber(fromLink)
	end
	return tonumber(input:match("^%s*(%d+)%s*$"))
end

function ns:BuildItemListOptions(config)
	local args = {}
	-- The panel owns everything below config.startOrder, so it can put its own
	-- copy and controls above the list without renumbering the shared shape.
	local order = (config.startOrder or 1) - 1
	local function nextOrder()
		order = order + 1
		return order
	end

	if config.onRestore then
		args.restore = {
			type = "execute",
			name = config.restoreLabel,
			desc = config.restoreLabel,
			order = nextOrder(),
			width = "double",
			confirm = true,
			confirmText = config.restoreConfirm,
			func = config.onRestore,
		}
		args.restoreSpacer = ns.OptionsSpacer(nextOrder())
	end

	args.addLabel = ns.OptionsRowLabel(config.addLabel, nextOrder())
	args.addInput = {
		type = "input",
		name = "",
		desc = config.addHint,
		order = nextOrder(),
		width = ns.OPTIONS_CONTROL_WIDTH,
		get = function()
			return ""
		end,
		set = function(_, value)
			local itemId = ParseItemId(value)
			if itemId then
				config.onAdd(itemId)
			end
		end,
	}
	args.addSpacer = ns.OptionsSpacer(nextOrder())

	local rows = {}
	for itemId in pairs(config.source) do
		if GetItemInfoInstant(itemId) then
			local name, link = GetItemInfo(itemId)
			if not name then
				ns.WatchUncachedItem(itemId, config.registryName)
			end
			rows[#rows + 1] = { itemId = itemId, name = name, link = link }
		end
	end
	table.sort(rows, function(a, b)
		if (a.name ~= nil) ~= (b.name ~= nil) then
			return a.name ~= nil
		end
		if a.name and b.name and a.name ~= b.name then
			return a.name < b.name
		end
		return a.itemId < b.itemId
	end)

	for _, row in ipairs(rows) do
		local itemId = row.itemId
		args["item" .. itemId] = {
			type = "group",
			name = "",
			inline = true,
			order = nextOrder(),
			args = {
				link = {
					type = "input",
					name = "",
					desc = config.noteFor and config.noteFor(itemId) or nil,
					dialogControl = ns.ITEM_LINK_WIDGET_TYPE,
					order = 1,
					width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_REMOVE_ICON_WIDTH,
					get = function()
						return row.link or tostring(itemId)
					end,
					set = function() end,
				},
				--[[
                    Remove is an icon, not a labelled button: the stock Button
                    insets its font string 15px per edge, which clips a caption to
                    a sliver in a column this narrow. One click, no confirm —
                    Restore Defaults is the destructive action that confirms.
                ]]
				remove = {
					type = "execute",
					name = "",
					desc = config.removeLabel,
					order = 2,
					width = ns.OPTIONS_REMOVE_ICON_WIDTH,
					image = REMOVE_ICON,
					imageWidth = REMOVE_ICON_SIZE,
					imageHeight = REMOVE_ICON_SIZE,
					func = function()
						config.onRemove(itemId)
					end,
				},
			},
		}
	end

	return args
end
