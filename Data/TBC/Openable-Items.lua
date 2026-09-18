local _, ns = ...

--------------------------------------------------------------------------------
-- Openable Items: TBC
--------------------------------------------------------------------------------

--[[
    The ns.AllowedItems rows only TBC Anniversary has. The table and its regeneration
    notes live in Data/Openable-Items.lua; this file only adds to it.

    Pulled from the CMaNGOS (Wrath) world DB with the query below, then kept to
    the ids Wowhead's Burning Crusade openable-item listing carries and the Classic Era
    listing does not (listing URL not recorded):

    SELECT CONCAT('\t[', it.entry, '] = ', IF(it.lockid = 0, 'true', 'false'), ', -- ', it.name) AS lua_row
    FROM item_template it
    WHERE EXISTS (SELECT 1 FROM item_loot_template ilt WHERE ilt.entry = it.entry)
    ORDER BY it.name;
]]

-- { [itemId] = canOpenImmediately (true) or requiresUnlock (false) }

ns.AllowedItems[34583] = true -- Aldor Supplies Package
ns.AllowedItems[34587] = true -- Aldor Supplies Package
ns.AllowedItems[34592] = true -- Aldor Supplies Package
ns.AllowedItems[34595] = true -- Aldor Supplies Package
ns.AllowedItems[28499] = true -- Arakkoa Hunter's Supplies
ns.AllowedItems[31955] = true -- Arelion's Knapsack
ns.AllowedItems[35348] = true -- Bag of Fishing Treasures
ns.AllowedItems[34863] = true -- Bag of Fishing Treasures
ns.AllowedItems[25423] = true -- Bag of Premium Gems
ns.AllowedItems[33844] = true -- Barrel of Fish
ns.AllowedItems[34846] = true -- Black Sack of Gems
ns.AllowedItems[191060] = true -- Black Sack of Gems
ns.AllowedItems[35313] = true -- Bloated Barbed Gill Trout
ns.AllowedItems[35286] = true -- Bloated Giant Sunfish
ns.AllowedItems[28135] = true -- Bomb Crate
ns.AllowedItems[34503] = true -- Box of Adamantite Shells
ns.AllowedItems[191061] = true -- Brilliant Glass
ns.AllowedItems[35945] = true -- Brilliant Glass
ns.AllowedItems[25422] = true -- Bulging Sack of Gems
ns.AllowedItems[23921] = true -- Bulging Sack of Silver
ns.AllowedItems[30320] = true -- Bundle of Nether Spikes
ns.AllowedItems[34548] = true -- Cache of the Shattered Sun
ns.AllowedItems[33857] = true -- Crate of Meat
ns.AllowedItems[34077] = true -- Crudely Wrapped Gift
ns.AllowedItems[27513] = true -- Curious Crate
ns.AllowedItems[30650] = true -- Dertrok's Wand Case
ns.AllowedItems[187714] = true -- Enlistment Bonus
ns.AllowedItems[187799] = true -- Enlistment Bonus
ns.AllowedItems[24336] = true -- Fireproof Satchel
ns.AllowedItems[25424] = true -- Gem-Stuffed Envelope
ns.AllowedItems[37586] = true -- Handful of Candy
ns.AllowedItems[27481] = true -- Heavy Supply Crate
ns.AllowedItems[33928] = true -- Hollowed Bone Decanter
ns.AllowedItems[27511] = true -- Inscribed Scrollcase
ns.AllowedItems[24476] = true -- Jaggal Clam
ns.AllowedItems[31952] = false -- Khorium Lockbox
ns.AllowedItems[32777] = true -- Kronk's Grab Bag
ns.AllowedItems[32626] = true -- Large Copper Metamorphosis Geode
ns.AllowedItems[32629] = true -- Large Gold Metamorphosis Geode
ns.AllowedItems[32624] = true -- Large Iron Metamorphosis Geode
ns.AllowedItems[32628] = true -- Large Silver Metamorphosis Geode
ns.AllowedItems[32462] = true -- Morthis' Materials
ns.AllowedItems[27446] = true -- Mr. Pinchy's Gift
ns.AllowedItems[23895] = true -- Netted Goods
ns.AllowedItems[23846] = true -- Nolkai's Box
ns.AllowedItems[31408] = true -- Offering of the Sha'tar
ns.AllowedItems[32835] = true -- Ogri'la Care Package
ns.AllowedItems[31800] = true -- Outcast's Cache
ns.AllowedItems[24402] = true -- Package of Identified Plants
ns.AllowedItems[35512] = true -- Pocket Full of Snow
ns.AllowedItems[37605] = true -- Pouch of Pennies
ns.AllowedItems[31522] = true -- Primal Mooncloth Supplies
ns.AllowedItems[32064] = true -- Protectorate Treasure Cache
ns.AllowedItems[33045] = true -- Renn's Supplies
ns.AllowedItems[34584] = true -- Scryer Supplies Package
ns.AllowedItems[34585] = true -- Scryer Supplies Package
ns.AllowedItems[34593] = true -- Scryer Supplies Package
ns.AllowedItems[34594] = true -- Scryer Supplies Package
ns.AllowedItems[33926] = true -- Sealed Scroll Case
ns.AllowedItems[35232] = true -- Shattered Sun Supplies
ns.AllowedItems[32724] = true -- Sludge-covered Object
ns.AllowedItems[32627] = true -- Small Copper Metamorphosis Geode
ns.AllowedItems[32630] = true -- Small Gold Metamorphosis Geode
ns.AllowedItems[32625] = true -- Small Iron Metamorphosis Geode
ns.AllowedItems[32631] = true -- Small Silver Metamorphosis Geode
ns.AllowedItems[29569] = false -- Strong Junkbox
ns.AllowedItems[32561] = true -- Tier 5 Arrow Box
ns.AllowedItems[273162] = true -- Unexpected Gift
ns.AllowedItems[25419] = true -- Unmarked Bag of Gems
ns.AllowedItems[30260] = true -- Voren'thal's Package
ns.AllowedItems[34426] = true -- Winter Veil Gift
