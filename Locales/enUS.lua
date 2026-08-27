local L = LibStub("AceLocale-3.0"):NewLocale("Open-Sesame", "enUS", true)
if not L then
	return
end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Open Sesame"
L["STATUS_ENABLED"] = "Enabled"
L["STATUS_DISABLED"] = "Disabled"
L["STATUS_PAUSED"] = "Paused"

--------------------------------------------------------------------------------
-- Panel Tabs
--------------------------------------------------------------------------------

L["TAB_NOTIFICATIONS"] = "Notifications"
L["TAB_LOCKBOXES"] = "Lockboxes"
L["TAB_IGNORE_LIST"] = "Ignore List"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Auto Loot has been enabled. Open Sesame requires it to function."
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."
L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Open Sesame. Enjoying the add-on? Tell a friend about it! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "Auto-Opening is Paused until you have at least %d empty bag slots."
L["RESUMED"] = "Auto-Opening has Resumed."
L["INVENTORY_FULL"] = "Inventory is full!"
L["ITEM_WILL_AUTO_OPEN"] = "%s will be automatically opened once it's unlocked."
L["ITEM_IGNORED"] = "%s is on your Ignore List, so Auto-Opening left it alone."
L["ITEM_OPEN_MANUALLY"] = "%s was left in the loot window for you to open yourself."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Auto-Opening"
L["AUTO_OPENING_DESCRIPTION"] =
	"Automatically opens clams and unlocked containers when you have at least %d empty bag slots."
L["SPEEDY_LOOT"] = "Speedy Loot"
L["SPEEDY_LOOT_DESCRIPTION"] = "Hides the loot window for near-instant looting."
L["NOTIFICATIONS_DESCRIPTION"] =
	"Speedy Loot hides the loot window, so these are how Open Sesame tells you what you just picked up."
L["LOCKBOXES_DESCRIPTION"] =
	"Locked containers need a Rogue's Lockpicking skill before they will open. These options show what each lockbox requires, and tell you when one is waiting."
L["LOOT_SOUNDS"] = "Loot Sound"
L["LOOT_SOUNDS_DESCRIPTION"] = "Plays a sound based on the quality settings of your choice."
L["LOOT_TOASTS"] = "Loot Toasts"
L["LOOT_TOASTS_DESCRIPTION"] =
	"Shows a brief on-screen notice for items you loot, since Speedy Loot hides the loot window. Moving loot out of chat frees the window up for conversation and the messages that matter."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Left-Click"
L["KEYBIND_RIGHT_CLICK"] = "Right-Click"
L["KEYBIND_MIDDLE_CLICK"] = "Middle-Click"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + Middle-Click"
L["ACTION_TOGGLE"] = "Toggle"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame Options"
L["TOOLTIP_REQUIRES_LOCKPICKING_LABEL"] = "Requires Lockpicking"
L["TOOLTIP_YOUR_LOCKPICKING_LABEL"] = "Your Lockpicking"
L["TOOLTIP_LOCKED_ITEMS"] = "Locked Items"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- General Panel
L["OPTIONS_DESCRIPTION"] =
	"Automatically open clams and unlocked containers in your bags, no clicking required. Built-in Speedy Loot hides the loot window for near-instant auto looting, and Loot Toasts show every pickup so your eyes stay on the fight. Fast, efficient looting."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_MINIMAP"] = "Enable Mini-map Button"

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Enable Auto-Opening"
L["OPTIONS_AUTO_OPENING_WHERE"] = "Where"
L["OPTIONS_ANYWHERE"] = "Anywhere"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Outside Instances"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Group"
L["OPTIONS_SOLO_OR_GROUPED"] = "Solo or Grouped"
L["OPTIONS_SOLO_ONLY"] = "Solo Only"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Enable Speedy Loot"

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Enable Lockbox Tooltips"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Enable Lockbox Notifications"
L["OPTIONS_SHOW_FOR"] = "Show for"
L["OPTIONS_FOR_ROGUES"] = "For Rogues"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "For All Characters"

-- Notifications
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Enable Loot Sound"
L["OPTIONS_TEST_LOOT_SOUND"] = "Play the loot sound."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Enable Pick Pocket Sound"
L["OPTIONS_MINIMUM_QUALITY"] = "Minimum Quality"

-- Loot Toasts
L["OPTIONS_ENABLE_LOOT_TOASTS"] = "Enable Loot Toasts"
-- The threshold bypasses, then the money row, in the order the panel lists them.
L["OPTIONS_ALWAYS_SHOW_BIND_ON_PICKUP"] = "Always Show Bind on Pickup Items"
L["OPTIONS_ALWAYS_SHOW_QUEST_ITEMS"] = "Always Show Quest Items"
L["OPTIONS_ALWAYS_SHOW_RECIPES"] = "Always Show Recipes"
L["OPTIONS_ALWAYS_SHOW_MOUNTS"] = "Always Show Mounts"
L["OPTIONS_ALWAYS_SHOW_PETS"] = "Always Show Pets"
L["OPTIONS_ALWAYS_SHOW_KEYS"] = "Always Show Keys"
L["OPTIONS_ALWAYS_SHOW_BAGS"] = "Always Show Bags"
L["OPTIONS_ALWAYS_SHOW_CONTAINERS"] = "Always Show Containers"
L["OPTIONS_ALWAYS_SHOW_MONEY"] = "Always Show Money"
L["OPTIONS_LOOT_TOAST_MAX_ITEMS"] = "Maximum Items to Display"
L["OPTIONS_UNLIMITED"] = "Unlimited"
L["OPTIONS_LOOT_TOAST_DURATION"] = "Seconds on Screen"
L["OPTIONS_LOOT_TOAST_GROWTH"] = "Grow Direction"
L["OPTIONS_GROW_UP"] = "Grow Up"
L["OPTIONS_GROW_DOWN"] = "Grow Down"
L["OPTIONS_LOOT_TOAST_ALIGN"] = "Align Items"
L["OPTIONS_ALIGN_LEFT"] = "Left"
L["OPTIONS_ALIGN_RIGHT"] = "Right"
L["OPTIONS_LOOT_TOAST_FONT"] = "Font"
L["OPTIONS_FONT_DEFAULT"] = "Default"
L["OPTIONS_LOOT_TOAST_FONT_SIZE"] = "Font Size"
L["OPTIONS_LOOT_TOAST_OUTLINE"] = "Font Outline"
L["OPTIONS_FONT_OUTLINE_NONE"] = "None"
L["OPTIONS_FONT_OUTLINE_OUTLINE"] = "Outline"
L["OPTIONS_FONT_OUTLINE_THICK_OUTLINE"] = "Thick Outline"
L["OPTIONS_FONT_OUTLINE_MONOCHROME"] = "Monochrome"
L["OPTIONS_FONT_OUTLINE_MONOCHROME_OUTLINE"] = "Monochrome Outline"
L["OPTIONS_TOASTS_UNLOCK"] = "Unlock Position"
L["OPTIONS_TOASTS_LOCK"] = "Lock Position"
L["OPTIONS_TOASTS_RESET"] = "Reset Position"
L["OPTIONS_TOASTS_CLICK_DRAG"] = "Click + Drag to Position"
L["OPTIONS_TOASTS_RIGHT_CLICK_LOCK"] = "Right-Click to Lock"
L["OPTIONS_TOASTS_DISABLE_BUTTON"] = "Disable Loot Toasts"
L["OPTIONS_TOASTS_EXAMPLE_ITEM"] = "Example Item"

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Items on this list are left alone: Speedy Loot leaves them in the loot window, and Auto-Opening never opens them. The list is shared by all of your characters."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Enable Ignore List Notifications"
L["OPTIONS_IGNORE_LIST_ADD"] = "Add Item"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Drag an item here, or paste an item link or item ID."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Remove this item from the Ignore List."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Restore Defaults"
L["OPTIONS_IGNORE_LIST_RESTORE_CONFIRM"] = "Restore the default Ignore List? Items you added will be removed."
L["OPTIONS_IGNORE_REASON_RAID"] =
	"Dropped by a raid boss. An unopened container can still be traded or sold, often for more than what is inside."
L["OPTIONS_IGNORE_REASON_QUEST"] =
	"May contain a unique quest item. Opening it may fail with an error if you already have one."
L["OPTIONS_IGNORE_REASON_RECIPE"] =
	"May contain a Bind on Pickup recipe. An unopened container can still be traded or sold."
L["OPTIONS_IGNORE_REASON_GEAR"] =
	"May contain a Bind on Pickup weapon or piece of armor. An unopened container can still be traded or sold."
L["OPTIONS_IGNORE_REASON_HOLIDAY"] =
	"May contain a Bind on Pickup holiday item. An unopened container can still be traded or sold."
L["OPTIONS_IGNORE_REASON_ITEM"] =
	"May contain a Bind on Pickup item. An unopened container can still be traded or sold."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
