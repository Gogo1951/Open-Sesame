local OpenSesame = CreateFrame('Frame')

OpenSesame:SetScript('OnEvent', function(self, event, ...) self[event](event, ...) end)

-- print("|cff00FF00OpenSesame Loaded Version: Wrath Classic WoW")

local atBank, atMail, atMerchant, inCombat, isLooting

local AllowedItemsList = {
   
  [10456]  =  true,  -- A Bulging Coin Purse 
  [15902]  =  true,  -- A Crazy Grab Bag 
  [11883]  =  true,  -- A Dingy Fanny Pack 
  [5335]  =  true,  -- A Sack of Coins 
  [6755]  =  true,  -- A Small Container of Gems 
  [11107]  =  true,  -- A Small Pack 
  [44663]  =  true,  -- Abandoned Adventurer's Satchel 
  [21509]  =  true,  -- Ahn'Qiraj War Effort Supplies 
  [21510]  =  true,  -- Ahn'Qiraj War Effort Supplies 
  [21511]  =  true,  -- Ahn'Qiraj War Effort Supplies 
  [21512]  =  true,  -- Ahn'Qiraj War Effort Supplies 
  [21513]  =  true,  -- Ahn'Qiraj War Effort Supplies 
  -- [46110]  =  true,  -- Alchemist's Cache (Drops from Raid Boss)
  [34583]  =  true,  -- Aldor Supplies Package 
  [34587]  =  true,  -- Aldor Supplies Package 
  [34592]  =  true,  -- Aldor Supplies Package 
  [34595]  =  true,  -- Aldor Supplies Package 
  [22152]  =  true,  -- Anthion's Pouch 
  [28499]  =  true,  -- Arakkoa Hunter's Supplies 
  [20231]  =  true,  -- Arathor Advanced Care Package 
  [20233]  =  true,  -- Arathor Basic Care Package 
  [20236]  =  true,  -- Arathor Standard Care Package 
  [44161]  =  true,  -- Arcane Tarot 
  [31955]  =  true,  -- Arelion's Knapsack 
  [39903]  =  true,  -- Argent Crusade Gratuity 
  [39904]  =  true,  -- Argent Crusade Gratuity 
  [49294]  =  true,  -- Ashen Sack of Gems 
  [11955]  =  true,  -- Bag of Empty Ooze Containers 
  [34863]  =  true,  -- Bag of Fishing Treasures 
  [35348]  =  true,  -- Bag of Fishing Treasures 
  [46007]  =  true,  -- Bag of Fishing Treasures 
  [25423]  =  true,  -- Bag of Premium Gems 
  [52274]  =  true,  -- Bag of Shaman Stuff 
  [52344]  =  true,  -- Bag of Shaman Stuff 
  [20603]  =  true,  -- Bag of Spoils 
  [33844]  =  true,  -- Barrel of Fish 
  [6356]  =  true,  -- Battered Chest 
  [16882]  =  true,  -- Battered Junkbox 
  -- [7973]  =  true,  -- Big-mouth Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [34119]  =  true,  -- Black Conrad's Treasure 
  -- [34846]  =  true,  -- Black Sack of Gems (Drops from Raid Boss)
  -- [191060]  =  true,  -- Black Sack of Gems (Drops from Raid Boss)
  [6646]  =  true,  -- Bloated Albacore 
  [35313]  =  true,  -- Bloated Barbed Gill Trout 
  [6647]  =  true,  -- Bloated Catfish 
  [21163]  =  true,  -- Bloated Firefin 
  [35286]  =  true,  -- Bloated Giant Sunfish 
  [6644]  =  true,  -- Bloated Mackerel 
  [21243]  =  true,  -- Bloated Mightfish 
  [6645]  =  true,  -- Bloated Mud Snapper 
  [21162]  =  true,  -- Bloated Oily Blackmouth 
  [13881]  =  true,  -- Bloated Redgill 
  [21164]  =  true,  -- Bloated Rockscale Cod 
  [13891]  =  true,  -- Bloated Salmon 
  [45328]  =  true,  -- Bloated Slippery Eel 
  [6643]  =  true,  -- Bloated Smallfish 
  [8366]  =  true,  -- Bloated Trout 
  [17962]  =  true,  -- Blue Sack of Gems 
  [28135]  =  true,  -- Bomb Crate 
  [40308]  =  true,  -- Bonework Soul Jar 
  [46809]  =  true,  -- Bountiful Cookbook 
  [46810]  =  true,  -- Bountiful Cookbook 
  [202269]  =  true,  -- Bounty Satchel 
  [34503]  =  true,  -- Box of Adamantite Shells 
  [44951]  =  true,  -- Box of Bombs 
  [21812]  =  true,  -- Box of Chocolates 
  [49909]  =  true,  -- Box of Chocolates 
  [10695]  =  true,  -- Box of Empty Vials 
  [9541]  =  true,  -- Box of Goodies 
  [9539]  =  true,  -- Box of Rations 
  [9540]  =  true,  -- Box of Spells 
  [6827]  =  true,  -- Box of Supplies 
  [35745]  =  true,  -- Box of Treasure 
  [49926]  =  true,  -- Brazie's Black Book of Secrets 
  [45072]  =  true,  -- Brightly Colored Egg 
  [35945]  =  true,  -- Brilliant Glass 
  [191061]  =  true,  -- Brilliant Glass 
  [8502]  =  true,  -- Bronze Lotterybox 
  -- [44700]  =  true,  -- Brooding Darkwater Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [22746]  =  true,  -- Buccaneer's Uniform 
  [25422]  =  true,  -- Bulging Sack of Gems 
  [23921]  =  true,  -- Bulging Sack of Silver 
  [30320]  =  true,  -- Bundle of Nether Spikes 
  [16783]  =  true,  -- Bundle of Reports 
  [52676]  =  true,  -- Cache of the Ley-Guardian 
  [34548]  =  true,  -- Cache of the Shattered Sun 
  [21191]  =  true,  -- Carefully Wrapped Present 
  [11887]  =  true,  -- Cenarion Circle Cache 
  [45724]  =  true,  -- Champion's Purse 
  [20602]  =  true,  -- Chest of Spoils 
  [21741]  =  true,  -- Cluster Rocket Recipes 
  [21528]  =  true,  -- Colossal Bag of Loot 
  [20808]  =  true,  -- Combat Assignment 
  [5738]  =  true,  -- Covert Ops Pack 
  [39883]  =  true,  -- Cracked Egg 
  [34871]  =  true,  -- Crafty's Sack 
  [33857]  =  true,  -- Crate of Meat 
  [34077]  =  true,  -- Crudely Wrapped Gift 
  [9265]  =  true,  -- Cuergo's Hidden Treasure 
  [27513]  =  true,  -- Curious Crate 
  [23022]  =  true,  -- Curmudgeon's Payoff 
  [19422]  =  true,  -- Darkmoon Faire Fortune 
  -- [36781]  =  true,  -- Darkwater Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [20469]  =  true,  -- Decoded True Believer Clippings 
  [20228]  =  true,  -- Defiler's Advanced Care Package 
  [20229]  =  true,  -- Defiler's Basic Care Package 
  [20230]  =  true,  -- Defiler's Standard Care Package 
  [12849]  =  true,  -- Demon Kissed Sack 
  [6351]  =  true,  -- Dented Crate 
  [30650]  =  true,  -- Dertrok's Wand Case 
  [50161]  =  true,  -- Dinner Suit Box 
  [8647]  =  true,  -- Egg Crate 
  [10752]  =  true,  -- Emerald Encrusted Chest 
  [187714]  =  true,  -- Enlistment Bonus 
  [187799]  =  true,  -- Enlistment Bonus 
  [11617]  =  true,  -- Eridan's Supplies 
  [5760]  =  true,  -- Eternium Lockbox 
  [11024]  =  true,  -- Evergreen Herb Casing 
  [11937]  =  true,  -- Fat Sack of Coins 
  [10834]  =  true,  -- Felhound Tracker Kit 
  [21363]  =  true,  -- Festive Gift 
  [24336]  =  true,  -- Fireproof Satchel 
  [39014]  =  true,  -- Floral Foundations 
  [21131]  =  true,  -- Followup Combat Assignment 
  [20805]  =  true,  -- Followup Logistics Assignment 
  [21386]  =  true,  -- Followup Logistics Assignment 
  [21133]  =  true,  -- Followup Tactical Assignment 
  [43622]  =  true,  -- Froststeel Lockbox 
  [8484]  =  true,  -- Gadgetzan Water Co. Care Package 
  [21310]  =  true,  -- Gaily Wrapped Present 
  [25424]  =  true,  -- Gem-Stuffed Envelope 
  [21270]  =  true,  -- Gently Shaken Gift 
  [21271]  =  true,  -- Gently Shaken Gift 
  -- [45909]  =  true,  -- Giant Darkwater Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [21979]  =  true,  -- Gift of Adoration: Darnassus 
  [21980]  =  true,  -- Gift of Adoration: Ironforge 
  [22164]  =  true,  -- Gift of Adoration: Orgrimmar 
  [21981]  =  true,  -- Gift of Adoration: Stormwind 
  [22165]  =  true,  -- Gift of Adoration: Thunder Bluff 
  [22166]  =  true,  -- Gift of Adoration: Undercity 
  [22167]  =  true,  -- Gift of Friendship: Darnassus 
  [22168]  =  true,  -- Gift of Friendship: Ironforge 
  [22169]  =  true,  -- Gift of Friendship: Orgrimmar 
  [22170]  =  true,  -- Gift of Friendship: Stormwind 
  [22171]  =  true,  -- Gift of Friendship: Thunder Bluff 
  [22172]  =  true,  -- Gift of Friendship: Undercity 
  [8049]  =  true,  -- Gnarlpine Necklace 
  [11423]  =  true,  -- Gnome Engineer's Renewal Gift 
  [5857]  =  true,  -- Gnome Prize Box 
  [11422]  =  true,  -- Goblin Engineer's Renewal Gift 
  [5858]  =  true,  -- Goblin Prize Box 
  [17964]  =  true,  -- Gray Sack of Gems 
  [19296]  =  true,  -- Greater Darkmoon Prize 
  [17963]  =  true,  -- Green Sack of Gems 
  [10773]  =  true,  -- Hakkari Urn 
  [37586]  =  true,  -- Handful of Candy 
  [54537]  =  true,  -- Heart-Shaped Box 
  [4633]  =  true,  -- Heavy Bronze Lockbox 
  [8503]  =  true,  -- Heavy Bronze Lotterybox 
  [13874]  =  true,  -- Heavy Crate 
  [8505]  =  true,  -- Heavy Iron Lotterybox 
  [16885]  =  true,  -- Heavy Junkbox 
  [8507]  =  true,  -- Heavy Mithril Lotterybox 
  [27481]  =  true,  -- Heavy Supply Crate 
  [22648]  =  true,  -- Hive'Ashi Dossier 
  [22649]  =  true,  -- Hive'Regal Dossier 
  [22650]  =  true,  -- Hive'Zora Dossier 
  [10569]  =  true,  -- Hoard of the Black Dragonflight 
  [33928]  =  true,  -- Hollowed Bone Decanter 
  [20367]  =  true,  -- Hunting Gear 
  [44751]  =  true,  -- Hyldnir Spoils 
  [44943]  =  true,  -- Icy Prism 
  [27511]  =  true,  -- Inscribed Scrollcase 
  [9529]  =  true,  -- Internal Warrior Equipment Kit L25 
  [9532]  =  true,  -- Internal Warrior Equipment Kit L30 
  [21150]  =  true,  -- Iron Bound Trunk 
  [4634]  =  true,  -- Iron Lockbox 
  [8504]  =  true,  -- Iron Lotterybox 
  [13875]  =  true,  -- Ironbound Locked Chest 
  -- [24476]  =  true,  -- Jaggal Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [54535]  =  true,  -- Keg-Shaped Treasure Chest 
  [31952]  =  true,  -- Khorium Lockbox 
  [10479]  =  true,  -- Kovic's Trading Satchel 
  [32777]  =  true,  -- Kronk's Grab Bag 
  [10595]  =  true,  -- Kum'isha's Junk 
  [12122]  =  true,  -- Kum'isha's Junk 
  [50301]  =  true,  -- Landro's Pet Box 
  [19035]  =  true,  -- Lard's Special Picnic Basket 
  [21743]  =  true,  -- Large Cluster Rocket Recipes 
  [32626]  =  true,  -- Large Copper Metamorphosis Geode 
  [32629]  =  true,  -- Large Gold Metamorphosis Geode 
  [32624]  =  true,  -- Large Iron Metamorphosis Geode 
  [21742]  =  true,  -- Large Rocket Recipes 
  -- [45878]  =  true,  -- Large Sack of Ulduar Spoils (Drops from Raid Boss)
  -- [43346]  =  true,  -- Large Satchel of Spoils (Drops from Raid Boss)
  [32628]  =  true,  -- Large Silver Metamorphosis Geode 
  [19297]  =  true,  -- Lesser Darkmoon Prize 
  [21132]  =  true,  -- Logistics Assignment 
  [21266]  =  true,  -- Logistics Assignment 
  [54516]  =  true,  -- Loot-Filled Pumpkin 
  [18804]  =  true,  -- Lord Grayson's Satchel 
  [50160]  =  true,  -- Lovely Dress Box 
  [21746]  =  true,  -- Lucky Red Envelope 
  [21640]  =  true,  -- Lunar Festival Fireworks Pack 
  [35792]  =  true,  -- Mage Hunter Personal Effects 
  [41426]  =  true,  -- Magically Wrapped Gift 
  [6307]  =  true,  -- Message in a Bottle 
  [19298]  =  true,  -- Minor Darkmoon Prize 
  [21228]  =  true,  -- Mithril Bound Trunk 
  [5758]  =  true,  -- Mithril Lockbox 
  [8506]  =  true,  -- Mithril Lotterybox 
  [32462]  =  true,  -- Morthis' Materials 
  [27446]  =  true,  -- Mr. Pinchy's Gift 
  [22320]  =  true,  -- Mux's Quality Goods 
  [19425]  =  true,  -- Mysterious Lockbox 
  [37168]  =  true,  -- Mysterious Tarot 
  [21042]  =  true,  -- Narain's Special Kit 
  [15876]  =  true,  -- Nathanos' Chest 
  [9537]  =  true,  -- Neatly Wrapped Box 
  [23895]  =  true,  -- Netted Goods 
  [23846]  =  true,  -- Nolkai's Box 
  [199210]  =  true,  -- Northrend Adventuring Supplies 
  [200238]  =  true,  -- Northrend Adventuring Supplies 
  [200239]  =  true,  -- Northrend Adventuring Supplies 
  [200240]  =  true,  -- Northrend Adventuring Supplies 
  [46812]  =  true,  -- Northrend Mystery Gem Pouch 
  [31408]  =  true,  -- Offering of the Sha'tar 
  [32835]  =  true,  -- Ogri'la Care Package 
  [20768]  =  true,  -- Oozing Bag 
  [4632]  =  true,  -- Ornate Bronze Lockbox 
  [39418]  =  true,  -- Ornately Jeweled Box 
  [31800]  =  true,  -- Outcast's Cache 
  [19153]  =  true,  -- Outrider Advanced Care Package 
  [19154]  =  true,  -- Outrider Basic Care Package 
  [19155]  =  true,  -- Outrider Standard Care Package 
  [11912]  =  true,  -- Package of Empty Ooze Containers 
  [24402]  =  true,  -- Package of Identified Plants 
  [43556]  =  true,  -- Patroller's Pack 
  -- [9276]  =  true,  -- Pirate's Footlocker (Can Contain BoP)
  [22155]  =  true,  -- Pledge of Adoration: Darnassus 
  [22154]  =  true,  -- Pledge of Adoration: Ironforge 
  [22156]  =  true,  -- Pledge of Adoration: Orgrimmar 
  [21975]  =  true,  -- Pledge of Adoration: Stormwind 
  [22158]  =  true,  -- Pledge of Adoration: Thunder Bluff 
  [22157]  =  true,  -- Pledge of Adoration: Undercity 
  [22159]  =  true,  -- Pledge of Friendship: Darnassus 
  [22160]  =  true,  -- Pledge of Friendship: Ironforge 
  [22161]  =  true,  -- Pledge of Friendship: Orgrimmar 
  [22178]  =  true,  -- Pledge of Friendship: Stormwind 
  [22162]  =  true,  -- Pledge of Friendship: Thunder Bluff 
  [22163]  =  true,  -- Pledge of Friendship: Undercity 
  [35512]  =  true,  -- Pocket Full of Snow 
  [37605]  =  true,  -- Pouch of Pennies 
  [31522]  =  true,  -- Primal Mooncloth Supplies 
  [32064]  =  true,  -- Protectorate Treasure Cache 
  [13247]  =  true,  -- Quartermaster Zigris' Footlocker 
  [17969]  =  true,  -- Red Sack of Gems 
  [44475]  =  true,  -- Reinforced Crate 
  [43575]  =  true,  -- Reinforced Junkbox 
  [13918]  =  true,  -- Reinforced Locked Chest 
  [4638]  =  true,  -- Reinforced Steel Lockbox 
  [33045]  =  true,  -- Renn's Supplies 
  [44718]  =  true,  -- Ripe Disgusting Jar 
  [6715]  =  true,  -- Ruined Jumper Cables 
  [18636]  =  true,  -- Ruined Jumper Cables XL 
  [52006]  =  true,  -- Sack of Frosty Treasures 
  [11938]  =  true,  -- Sack of Gems 
  [38539]  =  true,  -- Sack of Gold 
  [20601]  =  true,  -- Sack of Spoils 
  -- [45875]  =  true,  -- Sack of Ulduar Spoils (Drops from Raid Boss)
  [54536]  =  true,  -- Satchel of Chilled Goods 
  [51999]  =  true,  -- Satchel of Helpful Goods 
  [52000]  =  true,  -- Satchel of Helpful Goods 
  [52001]  =  true,  -- Satchel of Helpful Goods 
  [52002]  =  true,  -- Satchel of Helpful Goods 
  [52003]  =  true,  -- Satchel of Helpful Goods 
  [52004]  =  true,  -- Satchel of Helpful Goods 
  [52005]  =  true,  -- Satchel of Helpful Goods 
  -- [43347]  =  true,  -- Satchel of Spoils (Drops from Raid Boss)
  [21156]  =  true,  -- Scarab Bag 
  [7190]  =  true,  -- Scorched Rocket Boots 
  [34584]  =  true,  -- Scryer Supplies Package 
  [34585]  =  true,  -- Scryer Supplies Package 
  [34593]  =  true,  -- Scryer Supplies Package 
  [34594]  =  true,  -- Scryer Supplies Package 
  [20767]  =  true,  -- Scum Covered Bag 
  [22568]  =  true,  -- Sealed Craftsman's Writ 
  [6357]  =  true,  -- Sealed Crate 
  [33926]  =  true,  -- Sealed Scroll Case 
  [19152]  =  true,  -- Sentinel Advanced Care Package 
  [19150]  =  true,  -- Sentinel Basic Care Package 
  [19151]  =  true,  -- Sentinel Standard Care Package 
  [44163]  =  true,  -- Shadowy Tarot 
  [35232]  =  true,  -- Shattered Sun Supplies 
  [20766]  =  true,  -- Slimy Bag 
  [32724]  =  true,  -- Sludge-covered Object 
  -- [5523]  =  true,  -- Small Barnacled Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [15699]  =  true,  -- Small Brown-wrapped Package 
  [6353]  =  true,  -- Small Chest 
  [32627]  =  true,  -- Small Copper Metamorphosis Geode 
  [32630]  =  true,  -- Small Gold Metamorphosis Geode 
  [32625]  =  true,  -- Small Iron Metamorphosis Geode 
  [6354]  =  true,  -- Small Locked Chest 
  [21740]  =  true,  -- Small Rocket Recipes 
  [11966]  =  true,  -- Small Sack of Coins 
  [32631]  =  true,  -- Small Silver Metamorphosis Geode 
  [44113]  =  true,  -- Small Spice Bag 
  [41888]  =  true,  -- Small Velvet Bag 
  [21216]  =  true,  -- Smokywood Pastures Extra-Special Gift 
  [17727]  =  true,  -- Smokywood Pastures Gift Pack 
  [17685]  =  true,  -- Smokywood Pastures Sampler 
  [17726]  =  true,  -- Smokywood Pastures Special Gift 
  [21315]  =  true,  -- Smokywood Satchel 
  -- [15874]  =  true,  -- Soft-shelled Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [9363]  =  true,  -- Sparklematic-Wrapped Box 
  [49631]  =  true,  -- Standard Apothecary Serving Kit 
  [4637]  =  true,  -- Steel Lockbox 
  [42953]  =  true,  -- Strange Envelope 
  [44142]  =  true,  -- Strange Tarot 
  [4636]  =  true,  -- Strong Iron Lockbox 
  [29569]  =  true,  -- Strong Junkbox 
  [16884]  =  true,  -- Sturdy Junkbox 
  [6355]  =  true,  -- Sturdy Locked Chest 
  [23224]  =  true,  -- Summer Gift Package 
  [54467]  =  true,  -- Tabard Lost & Found 
  [20809]  =  true,  -- Tactical Assignment 
  [7209]  =  true,  -- Tazan's Satchel 
  [7870]  =  true,  -- Thaumaturgy Vessel Lockbox 
  [12033]  =  true,  -- Thaurissan Family Jewels 
  -- [5524]  =  true,  -- Thick-shelled Clam (Clams are likely Blocked by Blizzard API Due to "Clam Weaving" Hack)
  [7868]  =  true,  -- Thieven' Kit 
  [5759]  =  true,  -- Thorium Lockbox 
  [21327]  =  true,  -- Ticking Present 
  [32561]  =  true,  -- Tier 5 Arrow Box 
  [20708]  =  true,  -- Tightly Sealed Trunk 
  [45986]  =  true,  -- Tiny Titanium Lockbox 
  [43624]  =  true,  -- Titanium Lockbox 
  [11568]  =  true,  -- Torwa's Pouch 
  [20393]  =  true,  -- Treat Bag 
  [25419]  =  true,  -- Unmarked Bag of Gems 
  [51316]  =  true,  -- Unsealed Chest 
  [12339]  =  true,  -- Vaelan's Gift 
  [30260]  =  true,  -- Voren'thal's Package 
  [6352]  =  true,  -- Waterlogged Crate 
  [21113]  =  true,  -- Watertight Trunk 
  [34426]  =  true,  -- Winter Veil Gift 
  [43504]  =  true,  -- Winter Veil Gift 
  [46740]  =  true,  -- Winter Veil Gift 
  [16883]  =  true,  -- Worn Junkbox 
  [17965]  =  true,  -- Yellow Sack of Gems 
  [22137]  =  true,  -- Ysida's Satchel 
  -- [22233]  =  true,  -- Zigris' Footlocker (Seems like bad data; a dupe of #13247)

}

-- *** EVENT HANDLERS ***

-- https://wowpedia.fandom.com/wiki/PLAYER_INTERACTION_MANAGER_FRAME_SHOW
-- Fires when the PLAYER_INTERACTION_MANAGER_FRAME UI opens. (no summary on page)
function OpenSesame:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(paneType)
   if paneType ==  Enum.PlayerInteractionType.Merchant then 
      atMerchant = true
   end
   if paneType ==  Enum.PlayerInteractionType.Banker then 
      atBank = true
   end
	if paneType ==  Enum.PlayerInteractionType.GuildBanker then 
      atBank = true
   end
   if paneType ==  Enum.PlayerInteractionType.MailInfo then 
      atMail = true
   end
end

-- https://wowpedia.fandom.com/wiki/PLAYER_INTERACTION_MANAGER_FRAME_HIDE
-- Fires when the PLAYER_INTERACTION_MANAGER_FRAME UI closes. (no summary on page)
function OpenSesame:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(paneType)
   if paneType ==  Enum.PlayerInteractionType.Merchant then 
      atMerchant = false
      AutomaticOpener()
   end
   if paneType ==  Enum.PlayerInteractionType.Banker then 
      atBank = false
      AutomaticOpener()
   end
	if paneType ==  Enum.PlayerInteractionType.GuildBanker then 
      atBank = false
      AutomaticOpener()
   end
	if paneType ==  Enum.PlayerInteractionType.MailInfo then 
      atMail = false
      AutomaticOpener()
   end
end

-- https://wowpedia.fandom.com/wiki/LOOT_OPENED
-- Fires when a corpse is looted, after LOOT_READY. 
function OpenSesame:LOOT_OPENED()
   isLooting = true
end

-- https://wowpedia.fandom.com/wiki/LOOT_CLOSED
-- Fired when a player ceases looting a corpse.
-- Note that this will fire before the last CHAT_MSG_LOOT event for that loot. 
function OpenSesame:LOOT_CLOSED()
   isLooting = false
   AutomaticOpener()
end

-- https://wowpedia.fandom.com/wiki/PLAYER_REGEN_DISABLED
-- Fired whenever you enter combat, as normal regen rates
-- are disabled during combat. This means that either you
-- are in the hate list of a NPC or that you've been taking
-- part in a pvp action (either as attacker or victim). 
function OpenSesame:PLAYER_REGEN_DISABLED()
   inCombat = true
end

-- https://wowpedia.fandom.com/wiki/PLAYER_REGEN_ENABLED
-- Fired after ending combat, as regen rates return to normal.
-- Useful for determining when a player has left combat.
-- This occurs when you are not on the hate list of any NPC,
-- or a few seconds after the latest pvp attack that you were involved with. 
function OpenSesame:PLAYER_REGEN_ENABLED()
   inCombat = false
   AutomaticOpener()
end

-- https://wowpedia.fandom.com/wiki/BAG_UPDATE_DELAYED
-- Fired after all applicable BAG_UPDATE events for a specific action have been fired.
function OpenSesame:BAG_UPDATE_DELAYED()
   AutomaticOpener()
end


function AutomaticOpener()
   if (atBank or atMail or atMerchant or inCombat or isLooting) then return end
   for bag = 0, 4 do
      for slot = 0, C_Container.GetContainerNumSlots(bag) do
         local id = C_Container.GetContainerItemID(bag, slot)
         if id and AllowedItemsList[id] then
            if C_Container.GetContainerItemInfo(bag, slot).isLocked then return end
            -- DEFAULT_CHAT_FRAME:AddMessage("|cff00FF80OpenSesame : Opening " .. C_Container.GetContainerItemLink(bag, slot))
            C_Container.UseContainerItem(bag, slot)
         return
         end
      end
   end
end

OpenSesame:RegisterEvent('PLAYER_REGEN_DISABLED')
OpenSesame:RegisterEvent('LOOT_OPENED')
OpenSesame:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
OpenSesame:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
OpenSesame:RegisterEvent('PLAYER_REGEN_ENABLED')
OpenSesame:RegisterEvent('LOOT_CLOSED')
OpenSesame:RegisterEvent('BAG_UPDATE_DELAYED')
