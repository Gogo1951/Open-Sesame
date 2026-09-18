local _, ns = ...

--------------------------------------------------------------------------------
-- Lockbox Skill Levels: Wrath
--------------------------------------------------------------------------------

--[[
    The ns.LOCKBOX_SKILL_LEVELS rows only a Wrath client has. The table, and the
    notes on where its values come from, live in Data/Lockbox-Skill-Levels.lua;
    this file only adds to it. Values were read off each item's own
    warcraft.wiki.gg page.

    -- TODO: Add SQL Query
]]

-- { [itemId] = requiredLockpickingSkill }

ns.LOCKBOX_SKILL_LEVELS[43622] = 375 -- Froststeel Lockbox
ns.LOCKBOX_SKILL_LEVELS[43575] = 350 -- Reinforced Junkbox
ns.LOCKBOX_SKILL_LEVELS[42953] = 400 -- Strange Envelope
ns.LOCKBOX_SKILL_LEVELS[45986] = 400 -- Tiny Titanium Lockbox
ns.LOCKBOX_SKILL_LEVELS[43624] = 400 -- Titanium Lockbox
