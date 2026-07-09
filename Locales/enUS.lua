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
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["AUTO_LOOT_ENABLED"] = "Auto Loot is required for Open Sesame to function properly. Auto Loot has been enabled."
L["CHAT_LOADED"] = "Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Open Sesame. Enjoying the add-on? Tell a friend about it! (="

-- Auto-Opening
L["PAUSED_BAG_SLOTS"] = "Auto-Opening is Paused until you have at least %d empty bag slots."
L["RESUMED"] = "Auto-Opening has Resumed."
L["INVENTORY_FULL"] = "Inventory is full!"
L["ITEM_WILL_AUTO_OPEN"] = "%s will be automatically opened once it's unlocked."
L["ITEM_OPEN_MANUALLY"] = "%s needs to be opened manually. It may contain a Unique, Bind on Pickup, or Temporary item; or it was dropped by a raid boss."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"] = "Auto-Opening"
L["AUTO_OPENING_DESC"] = "Automatically opens clams and unlocked containers when you have at least %d empty bag slots."
L["SPEEDY_LOOT"] = "Speedy Loot"
L["SPEEDY_LOOT_DESC"] = "Hides the loot window for near-instant looting."
L["LOOT_SOUNDS"] = "Loot Sounds"
L["LOOT_SOUNDS_DESC"] = "Plays a distinct sound when you loot an Uncommon or higher quality item."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"] = "Left-Click"
L["KEYBIND_RIGHT_CLICK"] = "Right-Click"
L["KEYBIND_MIDDLE_CLICK"] = "Middle-Click"
L["KEYBIND_SHIFT_MIDDLE_CLICK"] = "Shift + Middle-Click"
L["ACTION_TOGGLE"] = "Toggle"
L["TOOLTIP_OPTIONS_TITLE"] = "Open Sesame Options"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] = "Open Sesame automatically opens clams, lockboxes, and unlocked containers in your bags. Built-in Speedy Loot hides the loot window for near-instant looting. Less time clicking, more time playing."
L["TAB_PROFILES"] = "Profiles"
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_MINIMAP"] = "Enable Mini-map Button"
L["OPTIONS_ENABLE_LOCKBOX_NOTIFICATIONS"] = "Enable Lockbox Notifications"
L["OPTIONS_ENABLE_AUTO_OPENING"] = "Enable Auto-Opening"
L["OPTIONS_ENABLE_SPEEDY_LOOT"] = "Enable Speedy Loot"
L["OPTIONS_ENABLE_LOOT_SOUNDS"] = "Enable Loot Sounds"
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_CMD_OS"] = "/os"
L["OPTIONS_CMD_OS_DESCRIPTION"] = "Opens the Open Sesame options interface."
L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
