local _, ns = ...

-- { [itemId] = requiredLockpickingSkill }
ns.LOCKBOX_SKILL_LEVELS = {
	[16882] = 1, -- Battered Junkbox
	[5760] = 225, -- Eternium Lockbox
	[43622] = 375, -- Froststeel Lockbox
	[4633] = 25, -- Heavy Bronze Lockbox
	[16885] = 250, -- Heavy Junkbox
	[4634] = 70, -- Iron Lockbox
	[13875] = 175, -- Ironbound Locked Chest
	[31952] = 325, -- Khorium Lockbox
	[5758] = 225, -- Mithril Lockbox
	[4632] = 1, -- Ornate Bronze Lockbox
	[43575] = 350, -- Reinforced Junkbox
	[13918] = 250, -- Reinforced Locked Chest
	[4638] = 225, -- Reinforced Steel Lockbox
	[6354] = 1, -- Small Locked Chest
	[4637] = 175, -- Steel Lockbox
	[42953] = 400, -- Strange Envelope
	[4636] = 125, -- Strong Iron Lockbox
	[29569] = 300, -- Strong Junkbox
	[16884] = 175, -- Sturdy Junkbox
	[6355] = 70, -- Sturdy Locked Chest
	[7209] = 1, -- Tazan's Satchel
	[12033] = 275, -- Thaurissan Family Jewels
	[5759] = 225, -- Thorium Lockbox
	[45986] = 400, -- Tiny Titanium Lockbox
	[43624] = 400, -- Titanium Lockbox
	[16883] = 70, -- Worn Junkbox
}

--[[
How We Got the Data

Last Validated
	Never. Copied from Data/TBC/.

Notes
	- The Lockpicking skill each locked container needs, for the line Lockbox Tooltips adds to its tooltip (Features/Lockbox-Tooltips.lua).
	- One row for every false row of ns.ALLOWED_ITEMS whose lock a Rogue can pick. A container whose lock asks for something else, a key or another profession, has no row and so no tooltip line.
	- Each number is the item's lock's Pick Lock entry: ItemSparse's LockID, then that Lock row's entry with Type 2 and Index 1, whose Skill is the number stored here. Copied by script from GogoLoot's Data/TBC/Lockbox-Skill-Levels-TBC.lua.
	- Values are numbers and the tooltip formats them as numbers, so a box with no number is absent from the table, never present with a stand-in value.
	- Data/TBC's rows, plus the Wrath rows Open Sesame's earlier Data/Wrath/Lockbox-Skill-Levels.lua carried, read off each item's warcraft.wiki.gg page.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	None.
]]
