local _, ns = ...

--------------------------------------------------------------------------------
-- Openable Items: Wrath
--------------------------------------------------------------------------------

--[[
    The ns.AllowedItems rows only a Wrath client has. The table and its regeneration
    notes live in Data/Openable-Items.lua; this file only adds to it.

    Pulled from the CMaNGOS (Wrath) world DB with the query below, then kept to
    the ids Wowhead's Wrath openable-item listing carries and the Classic Era
    listing does not (listing URL not recorded):

    SELECT CONCAT('\t[', it.entry, '] = ', IF(it.lockid = 0, 'true', 'false'), ', -- ', it.name) AS lua_row
    FROM item_template it
    WHERE EXISTS (SELECT 1 FROM item_loot_template ilt WHERE ilt.entry = it.entry)
    ORDER BY it.name;
]]

-- { [itemId] = canOpenImmediately (true) or requiresUnlock (false) }

ns.AllowedItems[44663] = true -- Abandoned Adventurer's Satchel
ns.AllowedItems[46110] = true -- Alchemist's Cache
ns.AllowedItems[44161] = true -- Arcane Tarot
ns.AllowedItems[39903] = true -- Argent Crusade Gratuity
ns.AllowedItems[39904] = true -- Argent Crusade Gratuity
ns.AllowedItems[49294] = true -- Ashen Sack of Gems
ns.AllowedItems[46007] = true -- Bag of Fishing Treasures
ns.AllowedItems[52274] = true -- Bag of Shaman Stuff
ns.AllowedItems[52344] = true -- Bag of Shaman Stuff
ns.AllowedItems[34119] = true -- Black Conrad's Treasure
ns.AllowedItems[45328] = true -- Bloated Slippery Eel
ns.AllowedItems[40308] = true -- Bonework Soul Jar
ns.AllowedItems[46809] = true -- Bountiful Cookbook
ns.AllowedItems[46810] = true -- Bountiful Cookbook
ns.AllowedItems[208157] = true -- Bounty Satchel
ns.AllowedItems[202269] = true -- Bounty Satchel
ns.AllowedItems[44951] = true -- Box of Bombs
ns.AllowedItems[49909] = true -- Box of Chocolates
ns.AllowedItems[35745] = true -- Box of Treasure
ns.AllowedItems[49926] = true -- Brazie's Black Book of Secrets
ns.AllowedItems[45072] = true -- Brightly Colored Egg
ns.AllowedItems[44700] = true -- Brooding Darkwater Clam
ns.AllowedItems[52676] = true -- Cache of the Ley-Guardian
ns.AllowedItems[45724] = true -- Champion's Purse
ns.AllowedItems[39883] = true -- Cracked Egg
ns.AllowedItems[34871] = true -- Crafty's Sack
ns.AllowedItems[50161] = true -- Dinner Suit Box
ns.AllowedItems[39014] = false -- Floral Foundations
ns.AllowedItems[43622] = false -- Froststeel Lockbox
ns.AllowedItems[262788] = true -- Grand Gift
ns.AllowedItems[54537] = true -- Heart-Shaped Box
ns.AllowedItems[44751] = true -- Hyldnir Spoils
ns.AllowedItems[44943] = true -- Icy Prism
ns.AllowedItems[54535] = true -- Keg-Shaped Treasure Chest
ns.AllowedItems[54218] = true -- Landro's Gift Box
ns.AllowedItems[50301] = true -- Landro's Pet Box
ns.AllowedItems[45878] = true -- Large Sack of Ulduar Spoils
ns.AllowedItems[43346] = true -- Large Satchel of Spoils
ns.AllowedItems[54516] = true -- Loot-Filled Pumpkin
ns.AllowedItems[50160] = true -- Lovely Dress Box
ns.AllowedItems[35792] = true -- Mage Hunter Personal Effects
ns.AllowedItems[41426] = true -- Magically Wrapped Gift
ns.AllowedItems[37168] = true -- Mysterious Tarot
ns.AllowedItems[199210] = true -- Northrend Adventuring Supplies
ns.AllowedItems[200238] = true -- Northrend Adventuring Supplies
ns.AllowedItems[200239] = true -- Northrend Adventuring Supplies
ns.AllowedItems[200240] = true -- Northrend Adventuring Supplies
ns.AllowedItems[46812] = true -- Northrend Mystery Gem Pouch
ns.AllowedItems[39418] = true -- Ornately Jeweled Box
ns.AllowedItems[43556] = true -- Patroller's Pack
ns.AllowedItems[44475] = true -- Reinforced Crate
ns.AllowedItems[43575] = false -- Reinforced Junkbox
ns.AllowedItems[44718] = true -- Ripe Disgusting Jar
ns.AllowedItems[52006] = true -- Sack of Frosty Treasures
ns.AllowedItems[38539] = true -- Sack of Gold
ns.AllowedItems[45875] = true -- Sack of Ulduar Spoils
ns.AllowedItems[54536] = true -- Satchel of Chilled Goods
ns.AllowedItems[51999] = true -- Satchel of Helpful Goods
ns.AllowedItems[52000] = true -- Satchel of Helpful Goods
ns.AllowedItems[52001] = true -- Satchel of Helpful Goods
ns.AllowedItems[52003] = true -- Satchel of Helpful Goods
ns.AllowedItems[52002] = true -- Satchel of Helpful Goods
ns.AllowedItems[52005] = true -- Satchel of Helpful Goods
ns.AllowedItems[52004] = true -- Satchel of Helpful Goods
ns.AllowedItems[43347] = true -- Satchel of Spoils
ns.AllowedItems[44163] = true -- Shadowy Tarot
ns.AllowedItems[44113] = true -- Small Spice Bag
ns.AllowedItems[41888] = true -- Small Velvet Bag
ns.AllowedItems[49631] = true -- Standard Apothecary Serving Kit
ns.AllowedItems[42953] = false -- Strange Envelope
ns.AllowedItems[44142] = true -- Strange Tarot
ns.AllowedItems[54467] = true -- Tabard Lost & Found
ns.AllowedItems[45986] = false -- Tiny Titanium Lockbox
ns.AllowedItems[43624] = false -- Titanium Lockbox
ns.AllowedItems[51316] = true -- Unsealed Chest
ns.AllowedItems[43504] = true -- Winter Veil Gift
ns.AllowedItems[46740] = true -- Winter Veil Gift
