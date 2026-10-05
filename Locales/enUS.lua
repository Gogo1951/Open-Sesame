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
L["CHAT_END_OF_SUPPORT"] =
	"End of Support: this add-on is now part of GogoLoot, and this is its final release. Install GogoLoot to keep getting updates, and then you can remove Open Sesame."

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "Auto-Opening is paused until you have at least %d empty bag slots."
L["RESUMED"] = "Auto-Opening has resumed."
L["ITEM_WILL_AUTO_OPEN"] = "%s will open automatically once it is unlocked."
L["ITEM_IGNORED"] = "%s is on your Ignore List, so Auto-Opening will leave it alone."
L["ITEM_OPEN_MANUALLY"] = "%s is on your Ignore List, so Speedy Loot left it in the loot window."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Auto-Opening"
L["AUTO_OPENING_DESCRIPTION"] =
	"Automatically opens clams and unlocked containers when you have at least %d empty bag slots."
L["SPEEDY_LOOT"] = "Speedy Loot"
L["SPEEDY_LOOT_DESCRIPTION"] = "Hides the loot window for near-instant looting."
L["NOTIFICATIONS_DESCRIPTION"] = "Speedy Loot hides the loot window, so these sounds tell you what you just picked up."
L["LOCKBOXES_DESCRIPTION"] =
	"Locked containers need a Rogue's Lockpicking skill before they will open. These options show what each lockbox requires, and tell you when one is waiting."
L["LOOT_SOUNDS"] = "Loot Sound"
L["LOOT_SOUNDS_DESCRIPTION"] = "Plays a sound when you loot an item at or above the quality you choose."

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
	"Automatically open clams, containers, and unlocked lockboxes in your bags, no clicking required. Speedy Loot hides the loot window for faster auto loot. Fast, efficient looting."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "Prints the version and a short welcome in chat each time you log in."
L["OPTIONS_ENABLE_MINIMAP"] = "Enable Mini-map Button"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] = "Shows the Open Sesame button on the mini-map."

-- Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/os"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Auto-Opening
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Enable Auto-Opening"
L["OPTIONS_ENABLE_AUTO_OPENING_DESCRIPTION"] = "Turns automatic opening of clams and unlocked containers on or off."
L["OPTIONS_AUTO_OPENING_WHERE"] = "Where"
L["OPTIONS_AUTO_OPENING_WHERE_DESCRIPTION"] = "Choose whether containers open anywhere, or only outside instances."
L["OPTIONS_ANYWHERE"] = "Anywhere"
L["OPTIONS_OUTSIDE_INSTANCES"] = "Outside Instances"
L["OPTIONS_AUTO_OPENING_GROUP"] = "Group"
L["OPTIONS_AUTO_OPENING_GROUP_DESCRIPTION"] =
	"Choose whether containers open while you are in a group, or only while you play solo."
L["OPTIONS_SOLO_OR_GROUPED"] = "Solo or Grouped"
L["OPTIONS_SOLO_ONLY"] = "Solo Only"

-- Speedy Loot
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Enable Speedy Loot"
L["OPTIONS_ENABLE_SPEEDY_LOOT_DESCRIPTION"] =
	"Loots everything at once and hides the loot window, which stays open only for items that do not fit or are on your Ignore List."

-- Lockboxes
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS"] = "Enable Lockbox Tooltips"
L["OPTIONS_ENABLE_LOCKBOX_TOOLTIPS_DESCRIPTION"] = "Adds each lockbox's required Lockpicking skill to its tooltip."
L["OPTIONS_LOCKBOX_TOOLTIPS_SCOPE_DESCRIPTION"] =
	"Choose whether lockbox tooltips appear only for Rogues or for all characters."
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Enable Lockbox Notifications"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS_DESCRIPTION"] =
	"Tells you in chat when you loot a lockbox that will open once it is unlocked."
L["OPTIONS_LOCKBOX_NOTIFICATIONS_SCOPE_DESCRIPTION"] =
	"Choose whether lockbox notifications appear only for Rogues or for all characters."
L["OPTIONS_SHOW_FOR"] = "Show for"
L["OPTIONS_FOR_ROGUES"] = "For Rogues"
L["OPTIONS_FOR_ALL_CHARACTERS"] = "For All Characters"

-- Loot Sound
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Enable Loot Sound"
L["OPTIONS_ENABLE_LOOT_SOUNDS_DESCRIPTION"] =
	"Plays a chime when you loot an item at or above the Minimum Quality from a corpse or chest."
L["OPTIONS_LOOT_SOUND_QUALITY_DESCRIPTION"] = "The lowest item quality that plays the loot sound."
L["OPTIONS_TEST_LOOT_SOUND"] = "Plays the loot sound."
L["OPTIONS_ENABLE_PICK_POCKET_SOUND"] = "Enable Pick Pocket Sound"
L["OPTIONS_ENABLE_PICK_POCKET_SOUND_DESCRIPTION"] = "Plays a bag sound when Pick Pocket actually takes something."
L["OPTIONS_MINIMUM_QUALITY"] = "Minimum Quality"

-- Ignore List
L["OPTIONS_IGNORE_LIST_DESCRIPTION"] =
	"Items on this list are left alone: Speedy Loot leaves them in the loot window, and Auto-Opening never opens them. The list is shared by all of your characters."
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS"] = "Enable Ignore List Notifications"
L["OPTIONS_ENABLE_IGNORE_LIST_NOTIFICATIONS_DESCRIPTION"] =
	"Tells you in chat when Open Sesame leaves an item alone because it is on your Ignore List."
L["OPTIONS_IGNORE_LIST_ADD"] = "Add Item"
L["OPTIONS_IGNORE_LIST_ADD_HINT"] = "Drag an item here, or paste an item link or item ID."
L["OPTIONS_IGNORE_LIST_REMOVE"] = "Removes this item from the Ignore List."
L["OPTIONS_ITEM_LOADING"] = "Loading item %d..."
L["OPTIONS_IGNORE_LIST_RESTORE"] = "Restore Defaults"
L["OPTIONS_IGNORE_LIST_RESTORE_DESCRIPTION"] =
	"Replaces your Ignore List with the default one, removing any items you added."
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
L["OPTIONS_VERSION"] = "Version %s"
