local AutoOpenItems = CreateFrame('Frame')

AutoOpenItems:SetScript('OnEvent', function(self, event, ...) self[event](...) end)

local atBank, atMail, atMerchant, inCombat, isLooting

local AllowedItemsList = {
   
   
   -- TODO Compare Lists from WoWHead to List from WoW DB
   
   -- https://wotlkdb.com/?items&filter=cr=11:10:161;crs=1:2:1;crv=0:0:0 234 Items
   -- 234 Total Items
   
   -- vs.
   
   -- https://www.wowhead.com/wotlk/items?filter=11:10:166:161;1:2:1:1;0:0:0:0 182 Items
   -- https://www.wowhead.com/wotlk/items?filter=11:10:166:161;1:2:2:1;0:0:0:0 67 Items
   -- https://www.wowhead.com/wotlk/items?filter=11:10:166:161;1:2:3:1;0:0:0:0 68 Items
   -- 317 Total Items
   
   -- WoWHead has MORE items, but list from WotLKDB.com needs to be validated.
   
   -- Classic 
   -- https://www.wowhead.com/wotlk/items?filter=11:10:166:161;1:2:1:1;0:0:0:0

   [10456]   =  true,  -- A Bulging Coin Purse
   [15902]   =  true,  -- A Crazy Grab Bag
   [11883]   =  true,  -- A Dingy Fanny Pack
   [5335]    =  true,  -- A Sack of Coins
   [6755]    =  true,  -- A Small Container of Gems
   [11107]   =  true,  -- A Small Pack
   [21509]   =  true,  -- Ahn'Qiraj War Effort Supplies
   [21510]   =  true,  -- Ahn'Qiraj War Effort Supplies
   [21511]   =  true,  -- Ahn'Qiraj War Effort Supplies
   [21512]   =  true,  -- Ahn'Qiraj War Effort Supplies
   [21513]   =  true,  -- Ahn'Qiraj War Effort Supplies
   [22152]   =  true,  -- Anthion's Pouch
   [20231]   =  true,  -- Arathor Advanced Care Package
   [20233]   =  true,  -- Arathor Basic Care Package
   [20236]   =  true,  -- Arathor Standard Care Package
   [11955]   =  true,  -- Bag of Empty Ooze Containers
   [20603]   =  true,  -- Bag of Spoils
   [6356]    =  true,  -- Battered Chest
   [6646]    =  true,  -- Bloated Albacore
   [6647]    =  true,  -- Bloated Catfish
   [21163]   =  true,  -- Bloated Firefin
   [6644]    =  true,  -- Bloated Mackerel
   [21243]   =  true,  -- Bloated Mightfish
   [6645]    =  true,  -- Bloated Mud Snapper
   [21162]   =  true,  -- Bloated Oily Blackmouth
   [13881]   =  true,  -- Bloated Redgill
   [21164]   =  true,  -- Bloated Rockscale Cod
   [13891]   =  true,  -- Bloated Salmon
   [6643]    =  true,  -- Bloated Smallfish
   [8366]    =  true,  -- Bloated Trout
   [17962]   =  true,  -- Blue Sack of Gems
   [21812]   =  true,  -- Box of Chocolates
   [10695]   =  true,  -- Box of Empty Vials
   [9541]    =  true,  -- Box of Goodies
   [9539]    =  true,  -- Box of Rations
   [9540]    =  true,  -- Box of Spells
   [6827]    =  true,  -- Box of Supplies
   [8502]    =  true,  -- Bronze Lotterybox
   [22746]   =  true,  -- Buccaneer's Uniform
   [16783]   =  true,  -- Bundle of Reports
   [21191]   =  true,  -- Carefully Wrapped Present
   [11887]   =  true,  -- Cenarion Circle Cache
   [20602]   =  true,  -- Chest of Spoils
   [21741]   =  true,  -- Cluster Rocket Recipes
   [21528]   =  true,  -- Colossal Bag of Loot
   [20808]   =  true,  -- Combat Assignment
   [5738]    =  true,  -- Covert Ops Pack
   [9265]    =  true,  -- Cuergo's Hidden Treasure
   [23022]   =  true,  -- Curmudgeon's Payoff
   [19422]   =  true,  -- Darkmoon Faire Fortune
   [20469]   =  true,  -- Decoded True Believer Clippings
   [20228]   =  true,  -- Defiler's Advanced Care Package
   [20229]   =  true,  -- Defiler's Basic Care Package
   [20230]   =  true,  -- Defiler's Standard Care Package
   [12849]   =  true,  -- Demon Kissed Sack
   [6351]    =  true,  -- Dented Crate
   [8647]    =  true,  -- Egg Crate
   [10752]   =  true,  -- Emerald Encrusted Chest
   [11617]   =  true,  -- Eridan's Supplies
   [11024]   =  true,  -- Evergreen Herb Casing
   [11937]   =  true,  -- Fat Sack of Coins
   [10834]   =  true,  -- Felhound Tracker Kit
   [21363]   =  true,  -- Festive Gift
   [21131]   =  true,  -- Followup Combat Assignment
   [20805]   =  true,  -- Followup Logistics Assignment
   [21386]   =  true,  -- Followup Logistics Assignment
   [21133]   =  true,  -- Followup Tactical Assignment
   [8484]    =  true,  -- Gadgetzan Water Co. Care Package
   [21310]   =  true,  -- Gaily Wrapped Present
   [21270]   =  true,  -- Gently Shaken Gift
   [21271]   =  true,  -- Gently Shaken Gift
   [21979]   =  true,  -- Gift of Adoration: Darnassus
   [21980]   =  true,  -- Gift of Adoration: Ironforge
   [22164]   =  true,  -- Gift of Adoration: Orgrimmar
   [21981]   =  true,  -- Gift of Adoration: Stormwind
   [22165]   =  true,  -- Gift of Adoration: Thunder Bluff
   [22166]   =  true,  -- Gift of Adoration: Undercity
   [22167]   =  true,  -- Gift of Friendship: Darnassus
   [22168]   =  true,  -- Gift of Friendship: Ironforge
   [22169]   =  true,  -- Gift of Friendship: Orgrimmar
   [22170]   =  true,  -- Gift of Friendship: Stormwind
   [22171]   =  true,  -- Gift of Friendship: Thunder Bluff
   [22172]   =  true,  -- Gift of Friendship: Undercity
   [8049]    =  true,  -- Gnarlpine Necklace
   [11423]   =  true,  -- Gnome Engineer's Renewal Gift
   [5857]    =  true,  -- Gnome Prize Box
   [11422]   =  true,  -- Goblin Engineer's Renewal Gift
   [5858]    =  true,  -- Goblin Prize Box
   [17964]   =  true,  -- Gray Sack of Gems
   [19296]   =  true,  -- Greater Darkmoon Prize
   [17963]   =  true,  -- Green Sack of Gems
   [10773]   =  true,  -- Hakkari Urn
   [8503]    =  true,  -- Heavy Bronze Lotterybox
   [13874]   =  true,  -- Heavy Crate
   [8505]    =  true,  -- Heavy Iron Lotterybox
   [8507]    =  true,  -- Heavy Mithril Lotterybox
   [22648]   =  true,  -- Hive'Ashi Dossier
   [22649]   =  true,  -- Hive'Regal Dossier
   [22650]   =  true,  -- Hive'Zora Dossier
   [10569]   =  true,  -- Hoard of the Black Dragonflight
   [20367]   =  true,  -- Hunting Gear
   [9529]    =  true,  -- Internal Warrior Equipment Kit L25
   [9532]    =  true,  -- Internal Warrior Equipment Kit L30
   [21150]   =  true,  -- Iron Bound Trunk
   [8504]    =  true,  -- Iron Lotterybox
   [10479]   =  true,  -- Kovic's Trading Satchel
   [12122]   =  true,  -- Kum'isha's Junk
   [10595]   =  true,  -- Kum'isha's Junk
   [19035]   =  true,  -- Lard's Special Picnic Basket
   [21743]   =  true,  -- Large Cluster Rocket Recipes
   [21742]   =  true,  -- Large Rocket Recipes
   [19297]   =  true,  -- Lesser Darkmoon Prize
   [21266]   =  true,  -- Logistics Assignment
   [21132]   =  true,  -- Logistics Assignment
   [18804]   =  true,  -- Lord Grayson's Satchel
   [21746]   =  true,  -- Lucky Red Envelope
   [21640]   =  true,  -- Lunar Festival Fireworks Pack
   [6307]    =  true,  -- Message in a Bottle
   [19298]   =  true,  -- Minor Darkmoon Prize
   [21228]   =  true,  -- Mithril Bound Trunk
   [8506]    =  true,  -- Mithril Lotterybox
   [22320]   =  true,  -- Mux's Quality Goods
   [19425]   =  true,  -- Mysterious Lockbox
   [21042]   =  true,  -- Narain's Special Kit
   [15876]   =  true,  -- Nathanos' Chest
   [9537]    =  true,  -- Neatly Wrapped Box
   [20768]   =  true,  -- Oozing Bag
   [19153]   =  true,  -- Outrider Advanced Care Package
   [19154]   =  true,  -- Outrider Basic Care Package
   [19155]   =  true,  -- Outrider Standard Care Package
   [11912]   =  true,  -- Package of Empty Ooze Containers
   -- [9276]    =  true,  -- Pirate's Footlocker (Can Contain BoP)
   [22155]   =  true,  -- Pledge of Adoration: Darnassus
   [22154]   =  true,  -- Pledge of Adoration: Ironforge
   [22156]   =  true,  -- Pledge of Adoration: Orgrimmar
   [21975]   =  true,  -- Pledge of Adoration: Stormwind
   [22158]   =  true,  -- Pledge of Adoration: Thunder Bluff
   [22157]   =  true,  -- Pledge of Adoration: Undercity
   [22159]   =  true,  -- Pledge of Friendship: Darnassus
   [22160]   =  true,  -- Pledge of Friendship: Ironforge
   [22161]   =  true,  -- Pledge of Friendship: Orgrimmar
   [22178]   =  true,  -- Pledge of Friendship: Stormwind
   [22162]   =  true,  -- Pledge of Friendship: Thunder Bluff
   [22163]   =  true,  -- Pledge of Friendship: Undercity
   [13247]   =  true,  -- Quartermaster Zigris' Footlocker
   [17969]   =  true,  -- Red Sack of Gems
   [6715]    =  true,  -- Ruined Jumper Cables
   [18636]   =  true,  -- Ruined Jumper Cables XL
   [11938]   =  true,  -- Sack of Gems
   [20601]   =  true,  -- Sack of Spoils
   [21156]   =  true,  -- Scarab Bag
   [7190]    =  true,  -- Scorched Rocket Boots
   [20767]   =  true,  -- Scum Covered Bag
   [22568]   =  true,  -- Sealed Craftsman's Writ
   [6357]    =  true,  -- Sealed Crate
   [19152]   =  true,  -- Sentinel Advanced Care Package
   [19150]   =  true,  -- Sentinel Basic Care Package
   [19151]   =  true,  -- Sentinel Standard Care Package
   [20766]   =  true,  -- Slimy Bag
   [15699]   =  true,  -- Small Brown-wrapped Package
   [6353]    =  true,  -- Small Chest
   [21740]   =  true,  -- Small Rocket Recipes
   [11966]   =  true,  -- Small Sack of Coins
   [21216]   =  true,  -- Smokywood Pastures Extra-Special Gift
   [17727]   =  true,  -- Smokywood Pastures Gift Pack
   [17685]   =  true,  -- Smokywood Pastures Sampler
   [17726]   =  true,  -- Smokywood Pastures Special Gift
   [21315]   =  true,  -- Smokywood Satchel
   [9363]    =  true,  -- Sparklematic-Wrapped Box
   [23224]   =  true,  -- Summer Gift Package
   [20809]   =  true,  -- Tactical Assignment
   [7870]    =  true,  -- Thaumaturgy Vessel Lockbox
   [21327]   =  true,  -- Ticking Present
   [20708]   =  true,  -- Tightly Sealed Trunk
   [11568]   =  true,  -- Torwa's Pouch
   [20393]   =  true,  -- Treat Bag
   [12339]   =  true,  -- Vaelan's Gift
   [6352]    =  true,  -- Waterlogged Crate
   [21113]   =  true,  -- Watertight Trunk
   [17965]   =  true,  -- Yellow Sack of Gems
   [22137]   =  true,  -- Ysida's Satchel
   -- [22233]   =  true,  -- Zigris' Footlocker (Seems like bad data; a dupe of #13247)

   -- The Burning Crusade
   -- https://www.wowhead.com/wotlk/items?filter=11:10:166:161;1:2:2:1;0:0:0:0

   [34587]   =  true,  -- Aldor Supplies Package
   [34583]   =  true,  -- Aldor Supplies Package
   [34592]   =  true,  -- Aldor Supplies Package
   [34595]   =  true,  -- Aldor Supplies Package
   [28499]   =  true,  -- Arakkoa Hunter's Supplies
   [31955]   =  true,  -- Arelion's Knapsack
   [34863]   =  true,  -- Bag of Fishing Treasures
   [35348]   =  true,  -- Bag of Fishing Treasures
   [25423]   =  true,  -- Bag of Premium Gems
   [33844]   =  true,  -- Barrel of Fish
   -- [34846]   =  true,  -- Black Sack of Gems (Drops from Raid Boss)
   -- [191060]  =  true,  -- Black Sack of Gems (Drops from Raid Boss)
   [35313]   =  true,  -- Bloated Barbed Gill Trout
   [35286]   =  true,  -- Bloated Giant Sunfish
   [28135]   =  true,  -- Bomb Crate
   [34503]   =  true,  -- Box of Adamantite Shells
   [35945]   =  true,  -- Brilliant Glass
   [191061]  =  true,  -- Brilliant Glass
   [25422]   =  true,  -- Bulging Sack of Gems
   [23921]   =  true,  -- Bulging Sack of Silver
   [30320]   =  true,  -- Bundle of Nether Spikes
   [34548]   =  true,  -- Cache of the Shattered Sun
   [33857]   =  true,  -- Crate of Meat
   [34077]   =  true,  -- Crudely Wrapped Gift
   [27513]   =  true,  -- Curious Crate
   [30650]   =  true,  -- Dertrok's Wand Case
   [187714]  =  true,  -- Enlistment Bonus
   [187799]  =  true,  -- Enlistment Bonus
   [24336]   =  true,  -- Fireproof Satchel
   [25424]   =  true,  -- Gem-Stuffed Envelope
   [37586]   =  true,  -- Handful of Candy
   [27481]   =  true,  -- Heavy Supply Crate
   [33928]   =  true,  -- Hollowed Bone Decanter
   [27511]   =  true,  -- Inscribed Scrollcase
   [32777]   =  true,  -- Kronk's Grab Bag
   [32626]   =  true,  -- Large Copper Metamorphosis Geode
   [32629]   =  true,  -- Large Gold Metamorphosis Geode
   [32624]   =  true,  -- Large Iron Metamorphosis Geode
   [32628]   =  true,  -- Large Silver Metamorphosis Geode
   [32462]   =  true,  -- Morthis' Materials
   [27446]   =  true,  -- Mr. Pinchy's Gift
   [23895]   =  true,  -- Netted Goods
   [23846]   =  true,  -- Nolkai's Box
   [31408]   =  true,  -- Offering of the Sha'tar
   [32835]   =  true,  -- Ogri'la Care Package
   [31800]   =  true,  -- Outcast's Cache
   [24402]   =  true,  -- Package of Identified Plants
   [35512]   =  true,  -- Pocket Full of Snow
   [37605]   =  true,  -- Pouch of Pennies
   [31522]   =  true,  -- Primal Mooncloth Supplies
   [32064]   =  true,  -- Protectorate Treasure Cache
   [33045]   =  true,  -- Renn's Supplies
   [34593]   =  true,  -- Scryer Supplies Package
   [34584]   =  true,  -- Scryer Supplies Package
   [34585]   =  true,  -- Scryer Supplies Package
   [34594]   =  true,  -- Scryer Supplies Package
   [33926]   =  true,  -- Sealed Scroll Case
   [35232]   =  true,  -- Shattered Sun Supplies
   [32724]   =  true,  -- Sludge-covered Object
   [32627]   =  true,  -- Small Copper Metamorphosis Geode
   [32630]   =  true,  -- Small Gold Metamorphosis Geode
   [32625]   =  true,  -- Small Iron Metamorphosis Geode
   [32631]   =  true,  -- Small Silver Metamorphosis Geode
   [32561]   =  true,  -- Tier 5 Arrow Box
   [25419]   =  true,  -- Unmarked Bag of Gems
   [30260]   =  true,  -- Voren'thal's Package
   [34426]   =  true,  -- Winter Veil Gift

   -- Wrath of the Lich King
   -- https://www.wowhead.com/wotlk/items?filter=11:10:166:161;1:2:3:1;0:0:0:0

   [44663]   =  true,  -- Abandoned Adventurer's Satchel
   -- [46110]   =  true,  -- Alchemist's Cache (Drops from Raid Boss)
   [44161]   =  true,  -- Arcane Tarot
   [39903]   =  true,  -- Argent Crusade Gratuity
   [39904]   =  true,  -- Argent Crusade Gratuity
   [49294]   =  true,  -- Ashen Sack of Gems
   [46007]   =  true,  -- Bag of Fishing Treasures
   [52274]   =  true,  -- Bag of Shaman Stuff
   [52344]   =  true,  -- Bag of Shaman Stuff
   [34119]   =  true,  -- Black Conrad's Treasure
   [45328]   =  true,  -- Bloated Slippery Eel
   [40308]   =  true,  -- Bonework Soul Jar
   [46809]   =  true,  -- Bountiful Cookbook
   [46810]   =  true,  -- Bountiful Cookbook
   [202269]  =  true,  -- Bounty Satchel
   [44951]   =  true,  -- Box of Bombs
   [49909]   =  true,  -- Box of Chocolates
   [35745]   =  true,  -- Box of Treasure
   [49926]   =  true,  -- Brazie's Black Book of Secrets
   [45072]   =  true,  -- Brightly Colored Egg
   [44700]   =  true,  -- Brooding Darkwater Clam
   [52676]   =  true,  -- Cache of the Ley-Guardian
   [45724]   =  true,  -- Champion's Purse
   [39883]   =  true,  -- Cracked Egg
   [34871]   =  true,  -- Crafty's Sack
   [50161]   =  true,  -- Dinner Suit Box
   [54537]   =  true,  -- Heart-Shaped Box
   [44751]   =  true,  -- Hyldnir Spoils
   [44943]   =  true,  -- Icy Prism
   [54535]   =  true,  -- Keg-Shaped Treasure Chest
   [50301]   =  true,  -- Landro's Pet Box
   -- [45878]   =  true,  -- Large Sack of Ulduar Spoils (Drops from Raid Boss)
   -- [43346]   =  true,  -- Large Satchel of Spoils (Drops from Raid Boss)
   [54516]   =  true,  -- Loot-Filled Pumpkin
   [50160]   =  true,  -- Lovely Dress Box
   [35792]   =  true,  -- Mage Hunter Personal Effects
   [41426]   =  true,  -- Magically Wrapped Gift
   [37168]   =  true,  -- Mysterious Tarot
   [199210]  =  true,  -- Northrend Adventuring Supplies
   [200239]  =  true,  -- Northrend Adventuring Supplies
   [200238]  =  true,  -- Northrend Adventuring Supplies
   [200240]  =  true,  -- Northrend Adventuring Supplies
   [46812]   =  true,  -- Northrend Mystery Gem Pouch
   [39418]   =  true,  -- Ornately Jeweled Box
   [43556]   =  true,  -- Patroller's Pack
   [44475]   =  true,  -- Reinforced Crate
   [44718]   =  true,  -- Ripe Disgusting Jar
   [52006]   =  true,  -- Sack of Frosty Treasures
   [38539]   =  true,  -- Sack of Gold
   -- [45875]   =  true,  -- Sack of Ulduar Spoils (Drops from Raid Boss)
   [54536]   =  true,  -- Satchel of Chilled Goods
   [51999]   =  true,  -- Satchel of Helpful Goods
   [52000]   =  true,  -- Satchel of Helpful Goods
   [52005]   =  true,  -- Satchel of Helpful Goods
   [52004]   =  true,  -- Satchel of Helpful Goods
   [52003]   =  true,  -- Satchel of Helpful Goods
   [52001]   =  true,  -- Satchel of Helpful Goods
   [52002]   =  true,  -- Satchel of Helpful Goods
   -- [43347]   =  true,  -- Satchel of Spoils (Drops from Raid Boss)
   [44163]   =  true,  -- Shadowy Tarot
   [44113]   =  true,  -- Small Spice Bag
   [41888]   =  true,  -- Small Velvet Bag
   [49631]   =  true,  -- Standard Apothecary Serving Kit
   [44142]   =  true,  -- Strange Tarot
   [54467]   =  true,  -- Tabard Lost & Found
   [51316]   =  true,  -- Unsealed Chest
   [43504]   =  true,  -- Winter Veil Gift
   [46740]   =  true,  -- Winter Veil Gift

   -- Clams! (Clams don't work with the Wrath API, but they are still included in case we can find a fix.)

   [15874]   =  true,  -- Soft-shelled Clam
   [5523]    =  true,  -- Small Barnacled Clam
   [5524]    =  true,  -- Thick-shelled Clam
   [7973]    =  true,  -- Big-mouth Clam
   [24476]   =  true,  -- Jaggal Clam
   [44700]   =  true,  -- Brooding Darkwater Clam
   [36781]   =  true,  -- Darkwater Clam

}

function AutoOpenItems:Register(event, func)
   self:RegisterEvent(event)
   self[event] = function(...)
   func(...)
end
end

-- https://wowpedia.fandom.com/wiki/BANKFRAME_OPENED
-- Fired when the bank frame is opened.
AutoOpenItems:Register('BANKFRAME_OPENED', function()
atBank = true
end)

-- https://wowpedia.fandom.com/wiki/BANKFRAME_CLOSED
-- Fired twice when the bank window is closed.
AutoOpenItems:Register('BANKFRAME_CLOSED', function()
atBank = false
end)

-- https://wowpedia.fandom.com/wiki/GUILDBANKFRAME_OPENED
-- Fired when the guild-bank frame is opened. 
AutoOpenItems:Register('GUILDBANKFRAME_OPENED', function()
atBank = true
end)

-- https://wowpedia.fandom.com/wiki/GUILDBAKFRAME_CLOSED
-- Fired when the guild-bank frame is closed. 
AutoOpenItems:Register('GUILDBANKFRAME_CLOSED', function()
atBank = false
end)

-- https://wowpedia.fandom.com/wiki/MAIL_SHOW
-- Fired when the mailbox is first opened. 
AutoOpenItems:Register('MAIL_SHOW', function()
atMail = true
end)

-- https://wowpedia.fandom.com/wiki/MAIL_CLOSED
-- Fired when the mailbox window is closed. 
AutoOpenItems:Register('MAIL_CLOSED', function()
atMail = false
end)

-- https://wowpedia.fandom.com/wiki/MERCHANT_SHOW
-- Fired when the merchant frame is shown. 
AutoOpenItems:Register('MERCHANT_SHOW', function()
atMerchant = true
end)

-- https://wowpedia.fandom.com/wiki/MERCHANT_CLOSED
-- Fired when a merchant frame closes. (Called twice). 
AutoOpenItems:Register('MERCHANT_CLOSED', function()
atMerchant = false
end)

-- https://wowpedia.fandom.com/wiki/LOOT_OPENED
-- Fires when a corpse is looted, after LOOT_READY. 
AutoOpenItems:Register('LOOT_OPENED', function()
isLooting = true
end)

-- https://wowpedia.fandom.com/wiki/LOOT_CLOSED
-- Fired when a player ceases looting a corpse. Note that this will fire before the last CHAT_MSG_LOOT event for that loot. 
AutoOpenItems:Register('LOOT_CLOSED', function()
isLooting = false
end)

-- https://wowpedia.fandom.com/wiki/PLAYER_REGEN_DISABLED
-- Fired whenever you enter combat, as normal regen rates are disabled during combat. This means that either you are in the hate list of a NPC or that you've been taking part in a pvp action (either as attacker or victim). 
AutoOpenItems:Register('PLAYER_REGEN_DISABLED', function()
inCombat = true
end)

-- https://wowpedia.fandom.com/wiki/PLAYER_REGEN_ENABLED
-- Fired after ending combat, as regen rates return to normal. Useful for determining when a player has left combat. This occurs when you are not on the hate list of any NPC, or a few seconds after the latest pvp attack that you were involved with. 
AutoOpenItems:Register('PLAYER_REGEN_ENABLED', function()
inCombat = false
end)

function OpenThings()
if (atBank or atMail or atMerchant or inCombat or isLooting) then return end
for bag = 0, 4 do
   for slot = 0, C_Container.GetContainerNumSlots(bag) do
      local id = C_Container.GetContainerItemID(bag, slot)
      if id and AllowedItemsList[id] then
         -- DEFAULT_CHAT_FRAME:AddMessage("|cff00FF80Auto Open Items : Opening " .. GetContainerItemLink(bag, slot))
         C_Container.UseContainerItem(bag, slot)
         return
      end
   end
end
end

AutoOpenItems:Register('BAG_UPDATE_DELAYED', OpenThings)
AutoOpenItems:Register('BANKFRAME_CLOSED', OpenThings)
AutoOpenItems:Register('GUILDBANKFRAME_CLOSED', OpenThings)
AutoOpenItems:Register('MAIL_CLOSED', OpenThings)
AutoOpenItems:Register('MERCHANT_CLOSED', OpenThings)
AutoOpenItems:Register('PLAYER_REGEN_ENABLED', OpenThings)
