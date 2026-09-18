local _, ns = ...

--------------------------------------------------------------------------------
-- Default Ignore List: TBC
--------------------------------------------------------------------------------

--[[
    The ns.DEFAULT_IGNORE_ITEMS rows only TBC Anniversary has. The table, its
    regeneration notes and the CMaNGOS (Wrath) world DB query that picks the
    containers live in Data/Default-Settings.lua; this file only adds to it.
    Which rows land here was decided by Wowhead's per-client openable listings,
    as that file explains.

    -- TODO: Add SQL Query
]]

-- { [itemId] = reasonKey } -- Container (the BoP loot)

ns.DEFAULT_IGNORE_ITEMS[34846] = "RAID" -- Black Sack of Gems (Magtheridon)
ns.DEFAULT_IGNORE_ITEMS[191060] = "RAID" -- Black Sack of Gems (Magtheridon, same name)
ns.DEFAULT_IGNORE_ITEMS[34548] = "RECIPE" -- Cache of the Shattered Sun (11 Designs, Patterns and Plans)
ns.DEFAULT_IGNORE_ITEMS[27513] = "RECIPE" -- Curious Crate (Weather-Beaten Journal)
ns.DEFAULT_IGNORE_ITEMS[27481] = "RECIPE" -- Heavy Supply Crate (Weather-Beaten Journal)
