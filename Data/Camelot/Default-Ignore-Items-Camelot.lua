local _, ns = ...

-- { [itemId] = reasonKey }
ns.DEFAULT_IGNORE_ITEMS = {
	[17962] = "RAID", -- Blue Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[11937] = "GEAR", -- Fat Sack of Coins (Fire Opal Necklace)
	[21979] = "HOLIDAY", -- Gift of Adoration: Darnassus (Love is in the Air gifts)
	[21980] = "HOLIDAY", -- Gift of Adoration: Ironforge (Love is in the Air gifts)
	[22164] = "HOLIDAY", -- Gift of Adoration: Orgrimmar (Love is in the Air gifts)
	[21981] = "HOLIDAY", -- Gift of Adoration: Stormwind (Love is in the Air gifts)
	[22165] = "HOLIDAY", -- Gift of Adoration: Thunder Bluff (Love is in the Air gifts)
	[22166] = "HOLIDAY", -- Gift of Adoration: Undercity (Love is in the Air gifts)
	[8049] = "QUEST", -- Gnarlpine Necklace (hand-added: Tallonkai's Jewel)
	[17964] = "RAID", -- Gray Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[17963] = "RAID", -- Green Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[13874] = "RAID", -- Heavy Crate (Gahz'ranka)
	[21150] = "RECIPE", -- Iron Bound Trunk (Weather-Beaten Journal)
	[21228] = "RECIPE", -- Mithril Bound Trunk (Weather-Beaten Journal)
	[9276] = "QUEST", -- Pirate's Footlocker (hand-added: Ship Schedule, map fragments)
	[22155] = "HOLIDAY", -- Pledge of Adoration: Darnassus (Love is in the Air gifts)
	[22154] = "HOLIDAY", -- Pledge of Adoration: Ironforge (Love is in the Air gifts)
	[22156] = "HOLIDAY", -- Pledge of Adoration: Orgrimmar (Love is in the Air gifts)
	[21975] = "HOLIDAY", -- Pledge of Adoration: Stormwind (Love is in the Air gifts)
	[22158] = "HOLIDAY", -- Pledge of Adoration: Thunder Bluff (Love is in the Air gifts)
	[22157] = "HOLIDAY", -- Pledge of Adoration: Undercity (Love is in the Air gifts)
	[17969] = "RAID", -- Red Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[20767] = "RECIPE", -- Scum Covered Bag (Plans: Wicked Mithril Blade)
	[20708] = "RECIPE", -- Tightly Sealed Trunk (Weather-Beaten Journal)
	[6352] = "GEAR", -- Waterlogged Crate (Hammer of the Vesper)
	[21113] = "RECIPE", -- Watertight Trunk (Weather-Beaten Journal)
	[17965] = "RAID", -- Yellow Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
}

--[[
How We Got the Data

Last Validated
	Never.

Notes
	- The containers a fresh Ignore List starts with, and Restore Defaults rebuilds it from (Features/Ignore-List.lua): ones whose loot is worth more left in the box, so Open Sesame never opens them on its own. The value is the reason key the row's tooltip note reads, one of RAID, QUEST, RECIPE, GEAR, HOLIDAY or ITEM.
	- Hand-picked by the maintainer: raid and world boss gem sacks (RAID), containers holding a unique quest item (QUEST; Gnarlpine Necklace and Pirate's Footlocker are hand-added), Bind on Pickup recipes, gear and holiday items in tradeable containers (RECIPE, GEAR, HOLIDAY).
	- Each row is kept only in the folders whose ns.ALLOWED_ITEMS carries the item as true, so the list never seeds an item this client lacks.
	- The table is only a seed: shipping a new row never changes an existing player's list, so note additions in the release notes.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	None.
]]
