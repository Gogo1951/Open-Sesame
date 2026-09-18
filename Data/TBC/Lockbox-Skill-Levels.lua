local _, ns = ...

--------------------------------------------------------------------------------
-- Lockbox Skill Levels: TBC
--------------------------------------------------------------------------------

--[[
    The ns.LOCKBOX_SKILL_LEVELS rows only TBC Anniversary has. The table, and the
    notes on where its values come from, live in Data/Lockbox-Skill-Levels.lua;
    this file only adds to it. Values were read off each item's own
    warcraft.wiki.gg page.

    -- TODO: Add SQL Query
]]

-- { [itemId] = requiredLockpickingSkill }

ns.LOCKBOX_SKILL_LEVELS[31952] = 325 -- Khorium Lockbox
ns.LOCKBOX_SKILL_LEVELS[29569] = 300 -- Strong Junkbox
