local _, ns = ...

--------------------------------------------------------------------------------
-- Lockbox Skill Levels
--------------------------------------------------------------------------------

--[[
    Required Lockpicking skill per locked container, for the tooltip line in
    Features/Lockbox-Tooltips.lua. Covers the ns.AllowedItems entries whose value
    is false, minus four with no number to give:

      Thieven' Kit (7868)        Flagged Locked, publishes no skill number.
      Floral Foundations (39014) Requires Inscription (50), not Lockpicking.
      Dark Iron Lockbox (208838) Unknown.
      Scarlet Junkbox (239248)   Unknown.

    The two Unknowns are Season of Discovery rows that reach ns.AllowedItems
    through the name-guess merge rule rather than from a source that carries a
    skill number. A missing row means no tooltip line for that box, which is the
    deliberate trade: none of the four gets a line rather than being given a
    guessed one.

    Values here are numbers and the tooltip formats them with %d, so a placeholder
    string in this table would error on hover. An unknown box is absent from the
    table, never present with a stand-in value.

    The skill number is NOT in the world DB: item_template.lockid points into
    Lock.dbc, which is client data, so these values were read off each item's own
    warcraft.wiki.gg page. The four 225s here are real, each confirmed on its own
    page. Rows only a later client has live in Data/TBC/ and Data/Wrath/.

    -- TODO: Add SQL Query

    This lists the items that need a value, so the table can be checked for gaps
    after regenerating ns.AllowedItems:

    SELECT it.entry, it.name, it.lockid
    FROM item_template it
    WHERE it.lockid > 0
      AND EXISTS (SELECT 1 FROM item_loot_template ilt WHERE ilt.entry = it.entry)
    ORDER BY it.name;
]]

-- { [itemId] = requiredLockpickingSkill }

ns.LOCKBOX_SKILL_LEVELS = {
	[16882] = 1, -- Battered Junkbox
	[5760] = 225, -- Eternium Lockbox
	[4633] = 25, -- Heavy Bronze Lockbox
	[16885] = 250, -- Heavy Junkbox
	[4634] = 70, -- Iron Lockbox
	[13875] = 175, -- Ironbound Locked Chest
	[5758] = 225, -- Mithril Lockbox
	[4632] = 1, -- Ornate Bronze Lockbox
	[13918] = 250, -- Reinforced Locked Chest
	[4638] = 225, -- Reinforced Steel Lockbox
	[6354] = 1, -- Small Locked Chest
	[4637] = 175, -- Steel Lockbox
	[4636] = 125, -- Strong Iron Lockbox
	[16884] = 175, -- Sturdy Junkbox
	[6355] = 70, -- Sturdy Locked Chest
	[7209] = 1, -- Tazan's Satchel
	[12033] = 275, -- Thaurissan Family Jewels
	[5759] = 225, -- Thorium Lockbox
	[16883] = 70, -- Worn Junkbox
}
