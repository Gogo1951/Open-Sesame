local _, ns = ...

--------------------------------------------------------------------------------
-- Openable Items
--------------------------------------------------------------------------------

--[[
    Which containers Open Sesame may open. Split out of Data.lua because this is
    a large generated table rather than the hand-set constants that file holds,
    and it is regenerated from a different source.

    Keyed by item ID and sorted by item NAME within each expansion block, which
    is the order the query below emits.
]]

--[[
    REGENERATING THIS TABLE TAKES TWO SOURCES. The query below reproduces roughly
    three quarters of it; the rest exists only because of the second source, so
    never replace this table with query output alone.

    SOURCE 1 - CMaNGOS (Wrath) world DB - answers WHICH KIND a container is. An
    item is openable when it has loot rows of its own in item_loot_template, and
    lockid separates the two kinds: 0 means it opens on sight, anything else means
    it must be unlocked first. That is exactly the true/false stored here.

    SELECT CONCAT('\t[', it.entry, '] = ', IF(it.lockid = 0, 'true', 'false'), ', -- ', it.name) AS lua_row
    FROM item_template it
    WHERE EXISTS (SELECT 1 FROM item_loot_template ilt WHERE ilt.entry = it.entry)
    ORDER BY it.name;

    SOURCE 2 - WOWHEAD's per-client openable-item listings, one per flavour
    (Classic Era including Season of Discovery, Burning Crusade, Wrath), exported
    as id + name. These answer two things the world DB cannot:

      * WHICH CLIENTS HAVE IT, which is the entire basis of the expansion blocks.
        An id present on Era sits in block 01, one first appearing in TBC in block
        02, one only in Wrath in block 03. Do not go back to guessing this from id
        ranges: six-digit modern Classic re-adds break any range rule.
      * THE ITEMS A WRATH DB HAS NEVER HEARD OF - modern Classic re-adds and every
        Season of Discovery container. Roughly 128 rows here came from Wowhead
        alone and would vanish if this table were rebuilt from SQL only.

    The world DB is also missing things Wowhead has for a different reason: clams
    and the Lotteryboxes deliver loot through a spell rather than
    item_loot_template, so the query never returns them.

    MERGE RULES, applied when the two sources are combined:

      * Placeholder rows are dropped: names beginning "Test ", "[DNT]", "[PH]" or
        "QATest" are GM and debug items no player ever sees.
      * A re-added id inherits the true/false of the existing row with the same
        name. The Anniversary client renumbers items without changing what they
        are, so the name is the reliable key.
      * Failing that, a name carrying "Lockbox", "Junkbox" or "Locked Chest" is
        taken as needing an unlock. Only two rows rest on that guess today:
        Dark Iron Lockbox (208838) and Scarlet Junkbox (239248).

    Data/Default-Settings.lua's ns.DEFAULT_IGNORE_ITEMS is generated from the same
    two sources and carries its own regeneration notes.
]]

-- { [itemId] = canOpenImmediately (true) or requiresUnlock (false) }

ns.AllowedItems = {

	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[10456] = true, -- A Bulging Coin Purse
	[15902] = true, -- A Crazy Grab Bag
	[11883] = true, -- A Dingy Fanny Pack
	[5335] = true, -- A Sack of Coins
	[6755] = true, -- A Small Container of Gems
	[11107] = true, -- A Small Pack
	[205364] = true, -- Acolyte's Knapsack
	[208223] = true, -- Acolyte's Knapsack
	[21509] = true, -- Ahn'Qiraj War Effort Supplies
	[21510] = true, -- Ahn'Qiraj War Effort Supplies
	[21511] = true, -- Ahn'Qiraj War Effort Supplies
	[21512] = true, -- Ahn'Qiraj War Effort Supplies
	[21513] = true, -- Ahn'Qiraj War Effort Supplies
	[22152] = true, -- Anthion's Pouch
	[20231] = true, -- Arathor Advanced Care Package
	[20233] = true, -- Arathor Basic Care Package
	[20236] = true, -- Arathor Standard Care Package
	[227360] = true, -- Astral Boots Legs and Shoulders Set
	[227338] = true, -- Astral Gloves and Belt Set
	[227384] = true, -- Astral Helm and Chestpiece Set
	[11955] = true, -- Bag of Empty Ooze Containers
	[20603] = true, -- Bag of Spoils
	[6356] = true, -- Battered Chest
	[16882] = false, -- Battered Junkbox
	[227374] = true, -- Battle's Boots Legs and Shoulders Set
	[227349] = true, -- Battle's Gloves and Belt Set
	[227396] = true, -- Battle's Helm and Chestpiece Set
	[7973] = true, -- Big-mouth Clam
	[6646] = true, -- Bloated Albacore
	[6647] = true, -- Bloated Catfish
	[21163] = true, -- Bloated Firefin
	[6644] = true, -- Bloated Mackerel
	[21243] = true, -- Bloated Mightfish
	[6645] = true, -- Bloated Mud Snapper
	[21162] = true, -- Bloated Oily Blackmouth
	[13881] = true, -- Bloated Redgill
	[21164] = true, -- Bloated Rockscale Cod
	[13891] = true, -- Bloated Salmon
	[6643] = true, -- Bloated Smallfish
	[8366] = true, -- Bloated Trout
	[17962] = true, -- Blue Sack of Gems
	[21812] = true, -- Box of Chocolates
	[10695] = true, -- Box of Empty Vials
	[213641] = true, -- Box of Gnomeregan Salvage
	[9541] = true, -- Box of Goodies
	[9539] = true, -- Box of Rations
	[9540] = true, -- Box of Spells
	[6827] = true, -- Box of Supplies
	[220914] = true, -- Broken Geode Hammer
	[8502] = true, -- Bronze Lotterybox
	[22746] = true, -- Buccaneer's Uniform
	[16783] = true, -- Bundle of Reports
	[216618] = true, -- Captain Aransas' Reward
	[21191] = true, -- Carefully Wrapped Present
	[11887] = true, -- Cenarion Circle Cache
	[20602] = true, -- Chest of Spoils
	[21741] = true, -- Cluster Rocket Recipes
	[21528] = true, -- Colossal Bag of Loot
	[20808] = true, -- Combat Assignment
	[227379] = true, -- Corrupted Boots Legs and Shoulders Set
	[227354] = true, -- Corrupted Gloves and Belt Set
	[227401] = true, -- Corrupted Helm and Chestpiece Set
	[5738] = true, -- Covert Ops Pack
	[208848] = true, -- Cracked Skull-Shaped Geode
	[9265] = true, -- Cuergo's Hidden Treasure
	[23022] = true, -- Curmudgeon's Payoff
	[236414] = true, -- Damaged Undermine Supply Crate
	[226405] = true, -- Damaged Undermine Supply Crate
	[208838] = false, -- Dark Iron Lockbox
	[19422] = true, -- Darkmoon Faire Fortune
	[227371] = true, -- Dawn Boots Legs and Shoulders Set
	[227346] = true, -- Dawn Gloves and Belt Set
	[227393] = true, -- Dawn Helm and Chestpiece Set
	[191656] = true, -- Death's Essence
	[20469] = true, -- Decoded True Believer Clippings
	[20228] = true, -- Defiler's Advanced Care Package
	[20229] = true, -- Defiler's Basic Care Package
	[20230] = true, -- Defiler's Standard Care Package
	[12849] = true, -- Demon Kissed Sack
	[6351] = true, -- Dented Crate
	[209031] = true, -- Discreet Envelope
	[227370] = true, -- Divine Will Boots Legs and Shoulders Set
	[227345] = true, -- Divine Will Gloves and Belt Set
	[227392] = true, -- Divine Will Helm and Chestpiece Set
	[238681] = true, -- Dusty Bag
	[8647] = true, -- Egg Crate
	[10752] = true, -- Emerald Encrusted Chest
	[221471] = true, -- Emerald Wardens Chest
	[213565] = true, -- Entomology Starter Kit
	[11617] = true, -- Eridan's Supplies
	[227376] = true, -- Eruption's Boots Legs and Shoulders Set
	[227351] = true, -- Eruption's Gloves and Belt Set
	[227398] = true, -- Eruption's Helm and Chestpiece Set
	[5760] = false, -- Eternium Lockbox
	[11024] = true, -- Evergreen Herb Casing
	[215465] = true, -- Exploded Strongbox
	[11937] = true, -- Fat Sack of Coins
	[10834] = true, -- Felhound Tracker Kit
	[227359] = true, -- Feline Boots Legs and Shoulders Set
	[227337] = true, -- Feline Gloves and Belt Set
	[227383] = true, -- Feline Helm and Chestpiece Set
	[21363] = true, -- Festive Gift
	[189421] = true, -- Fire Resist Leather Gear
	[189419] = true, -- Fire Resist Plate Gear
	[189420] = true, -- Fire Resist Plate Gear
	[21131] = true, -- Followup Combat Assignment
	[20805] = true, -- Followup Logistics Assignment
	[21386] = true, -- Followup Logistics Assignment
	[21133] = true, -- Followup Tactical Assignment
	[8484] = true, -- Gadgetzan Water Co. Care Package
	[21310] = true, -- Gaily Wrapped Present
	[21270] = true, -- Gently Shaken Gift
	[21271] = true, -- Gently Shaken Gift
	[21979] = true, -- Gift of Adoration: Darnassus
	[21980] = true, -- Gift of Adoration: Ironforge
	[22164] = true, -- Gift of Adoration: Orgrimmar
	[21981] = true, -- Gift of Adoration: Stormwind
	[22165] = true, -- Gift of Adoration: Thunder Bluff
	[22166] = true, -- Gift of Adoration: Undercity
	[22167] = true, -- Gift of Friendship: Darnassus
	[22168] = true, -- Gift of Friendship: Ironforge
	[22169] = true, -- Gift of Friendship: Orgrimmar
	[22170] = true, -- Gift of Friendship: Stormwind
	[22171] = true, -- Gift of Friendship: Thunder Bluff
	[22172] = true, -- Gift of Friendship: Undercity
	[8049] = true, -- Gnarlpine Necklace
	[11423] = true, -- Gnome Engineer's Renewal Gift
	[5857] = true, -- Gnome Prize Box
	[11422] = true, -- Goblin Engineer's Renewal Gift
	[5858] = true, -- Goblin Prize Box
	[17964] = true, -- Gray Sack of Gems
	[19296] = true, -- Greater Darkmoon Prize
	[17963] = true, -- Green Sack of Gems
	[227361] = true, -- Guardian's Boots Legs and Shoulders Set
	[227339] = true, -- Guardian's Gloves and Belt Set
	[227385] = true, -- Guardian's Helm and Chestpiece Set
	[10773] = true, -- Hakkari Urn
	[4633] = false, -- Heavy Bronze Lockbox
	[8503] = true, -- Heavy Bronze Lotterybox
	[13874] = true, -- Heavy Crate
	[8505] = true, -- Heavy Iron Lotterybox
	[16885] = false, -- Heavy Junkbox
	[8507] = true, -- Heavy Mithril Lotterybox
	[208766] = true, -- Helping Hand
	[227931] = true, -- Hidden Bundle
	[22648] = true, -- Hive'Ashi Dossier
	[22649] = true, -- Hive'Regal Dossier
	[22650] = true, -- Hive'Zora Dossier
	[10569] = true, -- Hoard of the Black Dragonflight
	[210330] = true, -- Hot Tip
	[20367] = true, -- Hunting Gear
	[227381] = true, -- Immoveable Boots Legs and Shoulders Set
	[227356] = true, -- Immoveable Gloves and Belt Set
	[227403] = true, -- Immoveable Helm and Chestpiece Set
	[227377] = true, -- Impact's Boots Legs and Shoulders Set
	[227352] = true, -- Impact's Gloves and Belt Set
	[227399] = true, -- Impact's Helm and Chestpiece Set
	[9529] = true, -- Internal Warrior Equipment Kit L25
	[9532] = true, -- Internal Warrior Equipment Kit L30
	[21150] = true, -- Iron Bound Trunk
	[4634] = false, -- Iron Lockbox
	[8504] = true, -- Iron Lotterybox
	[13875] = false, -- Ironbound Locked Chest
	[212553] = true, -- Jewel-Encrusted Box
	[221371] = true, -- Kidnapper's Coin Purse
	[10479] = true, -- Kovic's Trading Satchel
	[10595] = true, -- Kum'isha's Junk
	[12122] = true, -- Kum'isha's Junk
	[19035] = true, -- Lard's Special Picnic Basket
	[21743] = true, -- Large Cluster Rocket Recipes
	[21742] = true, -- Large Rocket Recipes
	[215451] = true, -- Large Strongbox
	[19297] = true, -- Lesser Darkmoon Prize
	[21132] = true, -- Logistics Assignment
	[21266] = true, -- Logistics Assignment
	[18804] = true, -- Lord Grayson's Satchel
	[21746] = true, -- Lucky Red Envelope
	[21640] = true, -- Lunar Festival Fireworks Pack
	[215452] = true, -- Medium Strongbox
	[227365] = true, -- Mender's Boots Legs and Shoulders Set
	[227340] = true, -- Mender's Gloves and Belt Set
	[227387] = true, -- Mender's Helm and Chestpiece Set
	[227368] = true, -- Merciful Boots Legs and Shoulders Set
	[227343] = true, -- Merciful Gloves and Belt Set
	[227390] = true, -- Merciful Helm and Chestpiece Set
	[6307] = true, -- Message in a Bottle
	[19298] = true, -- Minor Darkmoon Prize
	[219773] = true, -- Mission Brief: Ashenvale
	[219526] = true, -- Mission Brief: Duskwood
	[219775] = true, -- Mission Brief: Feralas
	[219774] = true, -- Mission Brief: Hinterlands
	[21228] = true, -- Mithril Bound Trunk
	[5758] = false, -- Mithril Lockbox
	[8506] = true, -- Mithril Lotterybox
	[189427] = true, -- More Raid Consumables
	[22320] = true, -- Mux's Quality Goods
	[19425] = true, -- Mysterious Lockbox
	[21042] = true, -- Narain's Special Kit
	[15876] = true, -- Nathanos' Chest
	[9537] = true, -- Neatly Wrapped Box
	[20768] = true, -- Oozing Bag
	[4632] = false, -- Ornate Bronze Lockbox
	[228615] = true, -- Otherworldly Treasure
	[220446] = true, -- Otherworldly Treasure
	[224836] = true, -- Otherworldly Treasure
	[224848] = true, -- Otherworldly Treasure
	[224850] = true, -- Otherworldly Treasure
	[224851] = true, -- Otherworldly Treasure
	[224849] = true, -- Otherworldly Treasure
	[223148] = true, -- Otherworldly Treasure
	[223149] = true, -- Otherworldly Treasure
	[223150] = true, -- Otherworldly Treasure
	[223151] = true, -- Otherworldly Treasure
	[19153] = true, -- Outrider Advanced Care Package
	[19154] = true, -- Outrider Basic Care Package
	[19155] = true, -- Outrider Standard Care Package
	[11912] = true, -- Package of Empty Ooze Containers
	[9276] = true, -- Pirate's Footlocker
	[22155] = true, -- Pledge of Adoration: Darnassus
	[22154] = true, -- Pledge of Adoration: Ironforge
	[22156] = true, -- Pledge of Adoration: Orgrimmar
	[21975] = true, -- Pledge of Adoration: Stormwind
	[22158] = true, -- Pledge of Adoration: Thunder Bluff
	[22157] = true, -- Pledge of Adoration: Undercity
	[22159] = true, -- Pledge of Friendship: Darnassus
	[22160] = true, -- Pledge of Friendship: Ironforge
	[22161] = true, -- Pledge of Friendship: Orgrimmar
	[22178] = true, -- Pledge of Friendship: Stormwind
	[22162] = true, -- Pledge of Friendship: Thunder Bluff
	[22163] = true, -- Pledge of Friendship: Undercity
	[227367] = true, -- Prowler's Boots Legs and Shoulders Set
	[227342] = true, -- Prowler's Gloves and Belt Set
	[227389] = true, -- Prowler's Helm and Chestpiece Set
	[227366] = true, -- Pursuer's Boots Legs and Shoulders Set
	[227341] = true, -- Pursuer's Gloves and Belt Set
	[227388] = true, -- Pursuer's Helm and Chestpiece Set
	[227937] = true, -- Puzzle Box
	[13247] = true, -- Quartermaster Zigris' Footlocker
	[227369] = true, -- Radiant Boots Legs and Shoulders Set
	[227344] = true, -- Radiant Gloves and Belt Set
	[227391] = true, -- Radiant Helm and Chestpiece Set
	[189426] = true, -- Raid Consumables
	[17969] = true, -- Red Sack of Gems
	[13918] = false, -- Reinforced Locked Chest
	[4638] = false, -- Reinforced Steel Lockbox
	[227375] = true, -- Relief's Boots Legs and Shoulders Set
	[227350] = true, -- Relief's Gloves and Belt Set
	[227397] = true, -- Relief's Helm and Chestpiece Set
	[227378] = true, -- Resolve's Boots Legs and Shoulders Set
	[227353] = true, -- Resolve's Gloves and Belt Set
	[227400] = true, -- Resolve's Helm and Chestpiece Set
	[6715] = true, -- Ruined Jumper Cables
	[18636] = true, -- Ruined Jumper Cables XL
	[11938] = true, -- Sack of Gems
	[20601] = true, -- Sack of Spoils
	[211799] = true, -- Sack of Stolen Goods
	[235144] = true, -- Satchel of Blood-Caked Copper Coins
	[235145] = true, -- Satchel of Blood-Caked Silver Coins
	[216971] = true, -- Satchel of Copper Blood Coins
	[221367] = true, -- Satchel of Copper Massacre Coins
	[228326] = true, -- Satchel of Copper Slaughter Coins
	[216972] = true, -- Satchel of Silver Blood Coins
	[221368] = true, -- Satchel of Silver Massacre Coins
	[228327] = true, -- Satchel of Silver Slaughter Coins
	[21156] = true, -- Scarab Bag
	[239248] = false, -- Scarlet Junkbox
	[7190] = true, -- Scorched Rocket Boots
	[20767] = true, -- Scum Covered Bag
	[22568] = true, -- Sealed Craftsman's Writ
	[6357] = true, -- Sealed Crate
	[19152] = true, -- Sentinel Advanced Care Package
	[19150] = true, -- Sentinel Basic Care Package
	[19151] = true, -- Sentinel Standard Care Package
	[221491] = true, -- Shadowtooth Bag
	[20766] = true, -- Slimy Bag
	[5523] = true, -- Small Barnacled Clam
	[15699] = true, -- Small Brown-wrapped Package
	[6353] = true, -- Small Chest
	[6354] = false, -- Small Locked Chest
	[21740] = true, -- Small Rocket Recipes
	[11966] = true, -- Small Sack of Coins
	[215453] = true, -- Small Strongbox
	[21216] = true, -- Smokywood Pastures Extra-Special Gift
	[17727] = true, -- Smokywood Pastures Gift Pack
	[17685] = true, -- Smokywood Pastures Sampler
	[17726] = true, -- Smokywood Pastures Special Gift
	[21315] = true, -- Smokywood Satchel
	[15874] = true, -- Soft-shelled Clam
	[9363] = true, -- Sparklematic-Wrapped Box
	[4637] = false, -- Steel Lockbox
	[11442] = true, -- Stormwind Deputy Kit
	[4636] = false, -- Strong Iron Lockbox
	[16884] = false, -- Sturdy Junkbox
	[6355] = false, -- Sturdy Locked Chest
	[23224] = true, -- Summer Gift Package
	[237263] = true, -- Supply Bag
	[217014] = true, -- Supply Bag
	[20809] = true, -- Tactical Assignment
	[7209] = false, -- Tazan's Satchel
	[7870] = true, -- Thaumaturgy Vessel Lockbox
	[12033] = false, -- Thaurissan Family Jewels
	[5524] = true, -- Thick-shelled Clam
	[7868] = false, -- Thieven' Kit
	[5759] = false, -- Thorium Lockbox
	[227373] = true, -- Thrill's Boots Legs and Shoulders Set
	[227348] = true, -- Thrill's Gloves and Belt Set
	[227395] = true, -- Thrill's Helm and Chestpiece Set
	[213443] = true, -- Ticking Present
	[21327] = true, -- Ticking Present
	[20708] = true, -- Tightly Sealed Trunk
	[215454] = true, -- Tiny Strongbox
	[11568] = true, -- Torwa's Pouch
	[20393] = true, -- Treat Bag
	[227372] = true, -- Twilight Boots Legs and Shoulders Set
	[227347] = true, -- Twilight Gloves and Belt Set
	[227394] = true, -- Twilight Helm and Chestpiece Set
	[227382] = true, -- Unstoppable Boots Legs and Shoulders Set
	[227357] = true, -- Unstoppable Gloves and Belt Set
	[227404] = true, -- Unstoppable Helm and Chestpiece Set
	[12339] = true, -- Vaelan's Gift
	[231644] = true, -- Warden's Enchanting Bag
	[231642] = true, -- Warden's Herb Bag
	[237386] = true, -- Wartorn Undermine Supply Crate
	[6352] = true, -- Waterlogged Crate
	[21113] = true, -- Watertight Trunk
	[227380] = true, -- Wicked Boots Legs and Shoulders Set
	[227355] = true, -- Wicked Gloves and Belt Set
	[227402] = true, -- Wicked Helm and Chestpiece Set
	[16883] = false, -- Worn Junkbox
	[17965] = true, -- Yellow Sack of Gems
	[22137] = true, -- Ysida's Satchel
	[22233] = true, -- Zigris' Footlocker
	[216646] = true, -- Ziri's Mystery Crate

	--------------------------------------------------------------------------------
	-- 02. World of Warcraft : The Burning Crusade
	--------------------------------------------------------------------------------

	[34583] = true, -- Aldor Supplies Package
	[34587] = true, -- Aldor Supplies Package
	[34592] = true, -- Aldor Supplies Package
	[34595] = true, -- Aldor Supplies Package
	[28499] = true, -- Arakkoa Hunter's Supplies
	[31955] = true, -- Arelion's Knapsack
	[35348] = true, -- Bag of Fishing Treasures
	[34863] = true, -- Bag of Fishing Treasures
	[25423] = true, -- Bag of Premium Gems
	[33844] = true, -- Barrel of Fish
	[34846] = true, -- Black Sack of Gems
	[191060] = true, -- Black Sack of Gems
	[35313] = true, -- Bloated Barbed Gill Trout
	[35286] = true, -- Bloated Giant Sunfish
	[28135] = true, -- Bomb Crate
	[34503] = true, -- Box of Adamantite Shells
	[191061] = true, -- Brilliant Glass
	[35945] = true, -- Brilliant Glass
	[25422] = true, -- Bulging Sack of Gems
	[23921] = true, -- Bulging Sack of Silver
	[30320] = true, -- Bundle of Nether Spikes
	[34548] = true, -- Cache of the Shattered Sun
	[33857] = true, -- Crate of Meat
	[34077] = true, -- Crudely Wrapped Gift
	[27513] = true, -- Curious Crate
	[30650] = true, -- Dertrok's Wand Case
	[187714] = true, -- Enlistment Bonus
	[187799] = true, -- Enlistment Bonus
	[24336] = true, -- Fireproof Satchel
	[25424] = true, -- Gem-Stuffed Envelope
	[37586] = true, -- Handful of Candy
	[27481] = true, -- Heavy Supply Crate
	[33928] = true, -- Hollowed Bone Decanter
	[27511] = true, -- Inscribed Scrollcase
	[24476] = true, -- Jaggal Clam
	[31952] = false, -- Khorium Lockbox
	[32777] = true, -- Kronk's Grab Bag
	[32626] = true, -- Large Copper Metamorphosis Geode
	[32629] = true, -- Large Gold Metamorphosis Geode
	[32624] = true, -- Large Iron Metamorphosis Geode
	[32628] = true, -- Large Silver Metamorphosis Geode
	[32462] = true, -- Morthis' Materials
	[27446] = true, -- Mr. Pinchy's Gift
	[23895] = true, -- Netted Goods
	[23846] = true, -- Nolkai's Box
	[31408] = true, -- Offering of the Sha'tar
	[32835] = true, -- Ogri'la Care Package
	[31800] = true, -- Outcast's Cache
	[24402] = true, -- Package of Identified Plants
	[35512] = true, -- Pocket Full of Snow
	[37605] = true, -- Pouch of Pennies
	[31522] = true, -- Primal Mooncloth Supplies
	[32064] = true, -- Protectorate Treasure Cache
	[33045] = true, -- Renn's Supplies
	[34584] = true, -- Scryer Supplies Package
	[34585] = true, -- Scryer Supplies Package
	[34593] = true, -- Scryer Supplies Package
	[34594] = true, -- Scryer Supplies Package
	[33926] = true, -- Sealed Scroll Case
	[35232] = true, -- Shattered Sun Supplies
	[32724] = true, -- Sludge-covered Object
	[32627] = true, -- Small Copper Metamorphosis Geode
	[32630] = true, -- Small Gold Metamorphosis Geode
	[32625] = true, -- Small Iron Metamorphosis Geode
	[32631] = true, -- Small Silver Metamorphosis Geode
	[29569] = false, -- Strong Junkbox
	[32561] = true, -- Tier 5 Arrow Box
	[273162] = true, -- Unexpected Gift
	[25419] = true, -- Unmarked Bag of Gems
	[30260] = true, -- Voren'thal's Package
	[34426] = true, -- Winter Veil Gift

	--------------------------------------------------------------------------------
	-- 03. World of Warcraft : Wrath of the Lich King
	--------------------------------------------------------------------------------

	[44663] = true, -- Abandoned Adventurer's Satchel
	[46110] = true, -- Alchemist's Cache
	[44161] = true, -- Arcane Tarot
	[39903] = true, -- Argent Crusade Gratuity
	[39904] = true, -- Argent Crusade Gratuity
	[49294] = true, -- Ashen Sack of Gems
	[46007] = true, -- Bag of Fishing Treasures
	[52274] = true, -- Bag of Shaman Stuff
	[52344] = true, -- Bag of Shaman Stuff
	[34119] = true, -- Black Conrad's Treasure
	[45328] = true, -- Bloated Slippery Eel
	[40308] = true, -- Bonework Soul Jar
	[46809] = true, -- Bountiful Cookbook
	[46810] = true, -- Bountiful Cookbook
	[208157] = true, -- Bounty Satchel
	[202269] = true, -- Bounty Satchel
	[44951] = true, -- Box of Bombs
	[49909] = true, -- Box of Chocolates
	[35745] = true, -- Box of Treasure
	[49926] = true, -- Brazie's Black Book of Secrets
	[45072] = true, -- Brightly Colored Egg
	[44700] = true, -- Brooding Darkwater Clam
	[52676] = true, -- Cache of the Ley-Guardian
	[45724] = true, -- Champion's Purse
	[39883] = true, -- Cracked Egg
	[34871] = true, -- Crafty's Sack
	[50161] = true, -- Dinner Suit Box
	[39014] = false, -- Floral Foundations
	[43622] = false, -- Froststeel Lockbox
	[262788] = true, -- Grand Gift
	[54537] = true, -- Heart-Shaped Box
	[44751] = true, -- Hyldnir Spoils
	[44943] = true, -- Icy Prism
	[54535] = true, -- Keg-Shaped Treasure Chest
	[54218] = true, -- Landro's Gift Box
	[50301] = true, -- Landro's Pet Box
	[45878] = true, -- Large Sack of Ulduar Spoils
	[43346] = true, -- Large Satchel of Spoils
	[54516] = true, -- Loot-Filled Pumpkin
	[50160] = true, -- Lovely Dress Box
	[35792] = true, -- Mage Hunter Personal Effects
	[41426] = true, -- Magically Wrapped Gift
	[37168] = true, -- Mysterious Tarot
	[199210] = true, -- Northrend Adventuring Supplies
	[200238] = true, -- Northrend Adventuring Supplies
	[200239] = true, -- Northrend Adventuring Supplies
	[200240] = true, -- Northrend Adventuring Supplies
	[46812] = true, -- Northrend Mystery Gem Pouch
	[39418] = true, -- Ornately Jeweled Box
	[43556] = true, -- Patroller's Pack
	[44475] = true, -- Reinforced Crate
	[43575] = false, -- Reinforced Junkbox
	[44718] = true, -- Ripe Disgusting Jar
	[52006] = true, -- Sack of Frosty Treasures
	[38539] = true, -- Sack of Gold
	[45875] = true, -- Sack of Ulduar Spoils
	[54536] = true, -- Satchel of Chilled Goods
	[51999] = true, -- Satchel of Helpful Goods
	[52000] = true, -- Satchel of Helpful Goods
	[52001] = true, -- Satchel of Helpful Goods
	[52003] = true, -- Satchel of Helpful Goods
	[52002] = true, -- Satchel of Helpful Goods
	[52005] = true, -- Satchel of Helpful Goods
	[52004] = true, -- Satchel of Helpful Goods
	[43347] = true, -- Satchel of Spoils
	[44163] = true, -- Shadowy Tarot
	[44113] = true, -- Small Spice Bag
	[41888] = true, -- Small Velvet Bag
	[49631] = true, -- Standard Apothecary Serving Kit
	[42953] = false, -- Strange Envelope
	[44142] = true, -- Strange Tarot
	[54467] = true, -- Tabard Lost & Found
	[45986] = false, -- Tiny Titanium Lockbox
	[43624] = false, -- Titanium Lockbox
	[51316] = true, -- Unsealed Chest
	[43504] = true, -- Winter Veil Gift
	[46740] = true, -- Winter Veil Gift
}
