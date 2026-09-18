local _, ns = ...

--------------------------------------------------------------------------------
-- Default Ignore List: Wrath
--------------------------------------------------------------------------------

--[[
    The ns.DEFAULT_IGNORE_ITEMS rows only a Wrath client has. The table, its
    regeneration notes and the CMaNGOS (Wrath) world DB query that picks the
    containers live in Data/Default-Settings.lua; this file only adds to it.
    Which rows land here was decided by Wowhead's per-client openable listings,
    as that file explains.

    -- TODO: Add SQL Query
]]

-- { [itemId] = reasonKey } -- Container (the BoP loot)

ns.DEFAULT_IGNORE_ITEMS[49294] = "RAID" -- Ashen Sack of Gems (Onyxia)
ns.DEFAULT_IGNORE_ITEMS[43346] = "RAID" -- Large Satchel of Spoils (Sartharion)
ns.DEFAULT_IGNORE_ITEMS[43347] = "RAID" -- Satchel of Spoils (Sartharion)
