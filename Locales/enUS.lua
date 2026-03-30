local L = LibStub("AceLocale-3.0"):NewLocale("OpenSesame", "enUS", true)
if not L then return end

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

L["ADDON_TITLE"]         = "Open Sesame"
L["STATUS_ENABLED"]      = "Enabled"
L["STATUS_DISABLED"]     = "Disabled"
L["STATUS_PAUSED"]       = "Paused"
L["STATUS_ON"]           = "On"
L["STATUS_OFF"]          = "Off"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["AUTO_LOOT_ENABLED"]   = "Auto Loot is required for Open Sesame to function properly. Auto Loot has been enabled."
L["PAUSED_BAG_SLOTS"]    = "Paused until you have at least %d empty bag slots."
L["RESUMED"]             = "Resumed."
L["INVENTORY_FULL"]      = "Inventory is full!"
L["ITEM_WILL_AUTO_OPEN"] = "%s will be automatically opened once it's unlocked."
L["ITEM_OPEN_MANUALLY"]  = "%s needs to be opened manually. It may contain a Unique, Bind on Pickup, or Temporary item; or it was dropped by a raid boss."

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

L["AUTO_OPENING"]        = "Auto-Opening"
L["AUTO_OPENING_DESC"]   = "Automatically opens clams and unlocked containers when you have more than 4 empty bag slots."
L["SPEEDY_LOOT"]         = "Speedy Loot"
L["SPEEDY_LOOT_DESC"]    = "Hides the loot window for near-instant looting."
L["LOOT_SOUNDS"]         = "Loot Sounds"
L["LOOT_SOUNDS_DESC"]    = "Plays a distinct sound when you loot an Uncommon or higher quality item."

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["KEYBIND_LEFT_CLICK"]  = "Left-Click"
L["KEYBIND_RIGHT_CLICK"] = "Right-Click"
L["KEYBIND_MIDDLE_CLICK"] = "Middle-Click"
L["ACTION_TOGGLE"]       = "Toggle"
L["TOOLTIP_HINT"]        = "Additional settings can be found under Options > AddOns > Open Sesame"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"]       = "Automatically opens clams and unlocked containers in your inventory. Features Speedy Loot for faster looting."
L["OPTIONS_FEEDBACK"]    = "Feedback & Support"
L["OPTIONS_CURSEFORGE"]  = "CurseForge"
L["OPTIONS_GITHUB"]      = "GitHub"
L["OPTIONS_DISCORD"]     = "Discord"