local _, ns = ...

-- { [key] = spellId }
ns.SPELLS = {
	PICK_LOCK = 1804,
	PICK_POCKET = 921,
	SHADOWMELD = 20580,
}

--[[
How We Got the Data

Last Validated
	Never. Copied from GogoLoot's Data/Camelot/, last validated there 2026-10-04, WoW Forever 1.60.1.70205.

Notes
	- The spells Open Sesame listens for or reads, hand-picked, each under the key the code uses.
	- PICK_LOCK is the Rogue's Pick Lock. A successful cast makes Auto-Opening look through the bags again, so a box opens as soon as it is unlocked (Features/Core.lua, Features/Auto-Opening.lua).
	- PICK_POCKET is the Rogue's Pick Pocket. A successful cast arms the pick-pocket sound for the loot window that follows (Features/Loot-Sounds.lua).
	- SHADOWMELD is the Night Elf racial. Auto-Opening waits while its aura is up, as it does in stealth (Features/Auto-Opening.lua).
	- Copied from GogoLoot's Data/Camelot/Spells-Camelot.lua.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	None.
]]
