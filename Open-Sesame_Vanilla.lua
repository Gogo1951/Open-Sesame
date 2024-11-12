local AllowedOpenItems = {
--   Allow Open Sesame! to open these items.

--  Classic Era

--  Openable
--  https://www.wowhead.com/classic/items?filter=11:10:161:82;1:2:1:4;0:0:0:11400#0+1+20

    [10456] = true,     -- A Bulging Coin Purse
    [15902] = true,     -- A Crazy Grab Bag
    [11883] = true,     -- A Dingy Fanny Pack
    [5335] = true,      -- A Sack of Coins
    [6755] = true,      -- A Small Container of Gems
    [11107] = true,     -- A Small Pack
    [21513] = true,     -- Ahn'Qiraj War Effort Supplies
    [21512] = true,     -- Ahn'Qiraj War Effort Supplies
    [21509] = true,     -- Ahn'Qiraj War Effort Supplies
    [21511] = true,     -- Ahn'Qiraj War Effort Supplies
    [21510] = true,     -- Ahn'Qiraj War Effort Supplies
    [22152] = true,     -- Anthion's Pouch
    [20231] = true,     -- Arathor Advanced Care Package
    [20233] = true,     -- Arathor Basic Care Package
    [20236] = true,     -- Arathor Standard Care Package
    [11955] = true,     -- Bag of Empty Ooze Containers
    [20603] = true,     -- Bag of Spoils
    [6356] = true,      -- Battered Chest
    [7973] = true,      -- Big-mouth Clam
    [6646] = true,      -- Bloated Albacore
    [6647] = true,      -- Bloated Catfish
    [21163] = true,     -- Bloated Firefin
    [6644] = true,      -- Bloated Mackerel
    [21243] = true,     -- Bloated Mightfish
    [6645] = true,      -- Bloated Mud Snapper
    [21162] = true,     -- Bloated Oily Blackmouth
    [13881] = true,     -- Bloated Redgill
    [21164] = true,     -- Bloated Rockscale Cod
    [13891] = true,     -- Bloated Salmon
    [6643] = true,      -- Bloated Smallfish
    [8366] = true,      -- Bloated Trout
    [17962] = true,     -- Blue Sack of Gems
    [21812] = true,     -- Box of Chocolates
    [10695] = true,     -- Box of Empty Vials
    [9541] = true,      -- Box of Goodies
    [9539] = true,      -- Box of Rations
    [9540] = true,      -- Box of Spells
    [6827] = true,      -- Box of Supplies
    [8502] = true,      -- Bronze Lotterybox
    [22746] = true,     -- Buccaneer's Uniform
    [16783] = true,     -- Bundle of Reports
    [21191] = true,     -- Carefully Wrapped Present
    [11887] = true,     -- Cenarion Circle Cache
    [20602] = true,     -- Chest of Spoils
    [21741] = true,     -- Cluster Rocket Recipes
    [21528] = true,     -- Colossal Bag of Loot
    [20808] = true,     -- Combat Assignment
    [5738] = true,      -- Covert Ops Pack
    [9265] = true,      -- Cuergo's Hidden Treasure
    [23022] = true,     -- Curmudgeon's Payoff
    [19422] = true,     -- Darkmoon Faire Fortune
    [20469] = true,     -- Decoded True Believer Clippings
    [20228] = true,     -- Defiler's Advanced Care Package
    [20229] = true,     -- Defiler's Basic Care Package
    [20230] = true,     -- Defiler's Standard Care Package
    [12849] = true,     -- Demon Kissed Sack
    [6351] = true,      -- Dented Crate
    [8647] = true,      -- Egg Crate
    [10752] = true,     -- Emerald Encrusted Chest
    [11617] = true,     -- Eridan's Supplies
    [11024] = true,     -- Evergreen Herb Casing
    [11937] = true,     -- Fat Sack of Coins
    [10834] = true,     -- Felhound Tracker Kit
    [21363] = true,     -- Festive Gift
    [21131] = true,     -- Followup Combat Assignment
    [20805] = true,     -- Followup Logistics Assignment
    [21386] = true,     -- Followup Logistics Assignment
    [21133] = true,     -- Followup Tactical Assignment
    [8484] = true,      -- Gadgetzan Water Co. Care Package
    [21310] = true,     -- Gaily Wrapped Present
    [21271] = true,     -- Gently Shaken Gift
    [21270] = true,     -- Gently Shaken Gift
    [21979] = true,     -- Gift of Adoration: Darnassus
    [21980] = true,     -- Gift of Adoration: Ironforge
    [22164] = true,     -- Gift of Adoration: Orgrimmar
    [21981] = true,     -- Gift of Adoration: Stormwind
    [22165] = true,     -- Gift of Adoration: Thunder Bluff
    [22166] = true,     -- Gift of Adoration: Undercity
    [22167] = true,     -- Gift of Friendship: Darnassus
    [22168] = true,     -- Gift of Friendship: Ironforge
    [22169] = true,     -- Gift of Friendship: Orgrimmar
    [22170] = true,     -- Gift of Friendship: Stormwind
    [22171] = true,     -- Gift of Friendship: Thunder Bluff
    [22172] = true,     -- Gift of Friendship: Undercity
    [8049] = true,      -- Gnarlpine Necklace
    [11423] = true,     -- Gnome Engineer's Renewal Gift
    [5857] = true,      -- Gnome Prize Box
    [11422] = true,     -- Goblin Engineer's Renewal Gift
    [5858] = true,      -- Goblin Prize Box
    [17964] = true,     -- Gray Sack of Gems
    [19296] = true,     -- Greater Darkmoon Prize
    [17963] = true,     -- Green Sack of Gems
    [10773] = true,     -- Hakkari Urn
    [8503] = true,      -- Heavy Bronze Lotterybox
    [13874] = true,     -- Heavy Crate
    [8505] = true,      -- Heavy Iron Lotterybox
    [8507] = true,      -- Heavy Mithril Lotterybox
    [22648] = true,     -- Hive'Ashi Dossier
    [22649] = true,     -- Hive'Regal Dossier
    [22650] = true,     -- Hive'Zora Dossier
    [10569] = true,     -- Hoard of the Black Dragonflight
    [20367] = true,     -- Hunting Gear
    [21150] = true,     -- Iron Bound Trunk
    [8504] = true,      -- Iron Lotterybox
    [10479] = true,     -- Kovic's Trading Satchel
    [12122] = true,     -- Kum'isha's Junk
    [10595] = true,     -- Kum'isha's Junk
    [19035] = true,     -- Lard's Special Picnic Basket
    [21743] = true,     -- Large Cluster Rocket Recipes
    [21742] = true,     -- Large Rocket Recipes
    [19297] = true,     -- Lesser Darkmoon Prize
    [21132] = true,     -- Logistics Assignment
    [21266] = true,     -- Logistics Assignment
    [18804] = true,     -- Lord Grayson's Satchel
    [21746] = true,     -- Lucky Red Envelope
    [21640] = true,     -- Lunar Festival Fireworks Pack
    [6307] = true,      -- Message in a Bottle
    [19298] = true,     -- Minor Darkmoon Prize
    [21228] = true,     -- Mithril Bound Trunk
    [8506] = true,      -- Mithril Lotterybox
    [22320] = true,     -- Mux's Quality Goods
    [19425] = true,     -- Mysterious Lockbox
    [21042] = true,     -- Narain's Special Kit
    [15876] = true,     -- Nathanos' Chest
    [9537] = true,      -- Neatly Wrapped Box
--  [20768] = true,     -- Oozing Bag (Can Contain BoP)
    [19153] = true,     -- Outrider Advanced Care Package
    [19154] = true,     -- Outrider Basic Care Package
    [19155] = true,     -- Outrider Standard Care Package
    [11912] = true,     -- Package of Empty Ooze Containers
--  [9276] = true,      -- Pirate's Footlocker (Can Contain BoP)
    [22155] = true,     -- Pledge of Adoration: Darnassus
    [22154] = true,     -- Pledge of Adoration: Ironforge
    [22156] = true,     -- Pledge of Adoration: Orgrimmar
    [21975] = true,     -- Pledge of Adoration: Stormwind
    [22158] = true,     -- Pledge of Adoration: Thunder Bluff
    [22157] = true,     -- Pledge of Adoration: Undercity
    [22159] = true,     -- Pledge of Friendship: Darnassus
    [22160] = true,     -- Pledge of Friendship: Ironforge
    [22161] = true,     -- Pledge of Friendship: Orgrimmar
    [22178] = true,     -- Pledge of Friendship: Stormwind
    [22162] = true,     -- Pledge of Friendship: Thunder Bluff
    [22163] = true,     -- Pledge of Friendship: Undercity
    [13247] = true,     -- Quartermaster Zigris' Footlocker
    [17969] = true,     -- Red Sack of Gems
    [6715] = true,      -- Ruined Jumper Cables
    [18636] = true,     -- Ruined Jumper Cables XL
    [11938] = true,     -- Sack of Gems
    [20601] = true,     -- Sack of Spoils
    [21156] = true,     -- Scarab Bag
    [7190] = true,      -- Scorched Rocket Boots
    [20767] = true,     -- Scum Covered Bag
    [22568] = true,     -- Sealed Craftsman's Writ
    [6357] = true,      -- Sealed Crate
    [19152] = true,     -- Sentinel Advanced Care Package
    [19150] = true,     -- Sentinel Basic Care Package
    [19151] = true,     -- Sentinel Standard Care Package
    [20766] = true,     -- Slimy Bag
    [5523] = true,      -- Small Barnacled Clam
    [15699] = true,     -- Small Brown-wrapped Package
    [6353] = true,      -- Small Chest
    [21740] = true,     -- Small Rocket Recipes
    [11966] = true,     -- Small Sack of Coins
    [21216] = true,     -- Smokywood Pastures Extra-Special Gift
    [17727] = true,     -- Smokywood Pastures Gift Pack
    [17685] = true,     -- Smokywood Pastures Sampler
    [17726] = true,     -- Smokywood Pastures Special Gift
    [21315] = true,     -- Smokywood Satchel
    [15874] = true,     -- Soft-shelled Clam
    [9363] = true,      -- Sparklematic-Wrapped Box
    [11442] = true,     -- Stormwind Deputy Kit
    [23224] = true,     -- Summer Gift Package
    [20809] = true,     -- Tactical Assignment
    [7870] = true,      -- Thaumaturgy Vessel Lockbox
    [5524] = true,      -- Thick-shelled Clam
    [21327] = true,     -- Ticking Present
    [20708] = true,     -- Tightly Sealed Trunk
    [11568] = true,     -- Torwa's Pouch
    [20393] = true,     -- Treat Bag
    [12339] = true,     -- Vaelan's Gift
    [6352] = true,      -- Waterlogged Crate
    [21113] = true,     -- Watertight Trunk
    [17965] = true,     -- Yellow Sack of Gems
    [22137] = true,     -- Ysida's Satchel
    [22233] = true,     -- Zigris' Footlocker

--  Openable But Locked
--  https://www.wowhead.com/classic/items?filter=11:10:161:82;1:1:1:4;0:0:0:11400#0+1+20

--  [16882] = true,     -- Battered Junkbox
--  [5760] = true,      -- Eternium Lockbox
--  [4633] = true,      -- Heavy Bronze Lockbox
--  [16885] = true,     -- Heavy Junkbox
--  [4634] = true,      -- Iron Lockbox
--  [13875] = true,     -- Ironbound Locked Chest
--  [5758] = true,      -- Mithril Lockbox
--  [4632] = true,      -- Ornate Bronze Lockbox
--  [13918] = true,     -- Reinforced Locked Chest
--  [4638] = true,      -- Reinforced Steel Lockbox
--  [6354] = true,      -- Small Locked Chest
--  [4637] = true,      -- Steel Lockbox
--  [4636] = true,      -- Strong Iron Lockbox
--  [16884] = true,     -- Sturdy Junkbox
--  [6355] = true,      -- Sturdy Locked Chest
--  [7209] = true,      -- Tazan's Satchel
--  [12033] = true,     -- Thaurissan Family Jewels
--  [7868] = true,      -- Thieven' Kit
--  [5759] = true,      -- Thorium Lockbox
--  [16883] = true,     -- Worn Junkbox

--  Season of Mastery, Season of Discovery & Classic Hardcore

--  Openable & Unlocked
--  https://www.wowhead.com/classic/items?filter=11:10:161:82;1:2:1:2;0:0:0:11401#0+1+20

    [205364] = true,    -- Acolyte's Knapsack
    [208223] = true,    -- Acolyte's Knapsack
    [227360] = true,    -- Astral Boots, Legs, and Shoulders Set
    [227338] = true,    -- Astral Gloves and Belt Set
    [227384] = true,    -- Astral Helm and Chestpiece Set
    [227374] = true,    -- Battle's Boots, Legs, and Shoulders Set
    [227349] = true,    -- Battle's Gloves and Belt Set
    [227396] = true,    -- Battle's Helm and Chestpiece Set
    [213641] = true,    -- Box of Gnomeregan Salvage
    [220914] = true,    -- Broken Geode Hammer
    [216618] = true,    -- Captain Aransas' Reward
    [227379] = true,    -- Corrupted Boots, Legs, and Shoulders Set
    [227354] = true,    -- Corrupted Gloves and Belt Set
    [227401] = true,    -- Corrupted Helm and Chestpiece Set
    [208848] = true,    -- Cracked Skull-Shaped Geode
    [226405] = true,    -- Damaged Undermine Supply Crate
    [227371] = true,    -- Dawn Boots, Legs, and Shoulders Set
    [227346] = true,    -- Dawn Gloves and Belt Set
    [227393] = true,    -- Dawn Helm and Chestpiece Set
    [191656] = true,    -- Death's Essence
    [209031] = true,    -- Discreet Envelope
    [227370] = true,    -- Divine Will Boots, Legs, and Shoulders Set
    [227345] = true,    -- Divine Will Gloves and Belt Set
    [227392] = true,    -- Divine Will Helm and Chestpiece Set
    [221471] = true,    -- Emerald Wardens Chest
    [213565] = true,    -- Entomology Starter Kit
    [227376] = true,    -- Eruption's Boots, Legs, and Shoulders Set
    [227351] = true,    -- Eruption's Gloves and Belt Set
    [227398] = true,    -- Eruption's Helm and Chestpiece Set
    [215465] = true,    -- Exploded Strongbox
    [227359] = true,    -- Feline Boots, Legs, and Shoulders Set
    [227337] = true,    -- Feline Gloves and Belt Set
    [227383] = true,    -- Feline Helm and Chestpiece Set
    [189421] = true,    -- Fire Resist Leather Gear
    [189420] = true,    -- Fire Resist Plate Gear
    [189419] = true,    -- Fire Resist Plate Gear
    [227361] = true,    -- Guardian's Boots, Legs, and Shoulders Set
    [227339] = true,    -- Guardian's Gloves and Belt Set
    [227385] = true,    -- Guardian's Helm and Chestpiece Set
    [208766] = true,    -- Helping Hand
    [227931] = true,    -- Hidden Bundle
    [210330] = true,    -- Hot Tip
    [227381] = true,    -- Immoveable Boots, Legs, and Shoulders Set
    [227356] = true,    -- Immoveable Gloves and Belt Set
    [227403] = true,    -- Immoveable Helm and Chestpiece Set
    [227377] = true,    -- Impact's Boots, Legs, and Shoulders Set
    [227352] = true,    -- Impact's Gloves and Belt Set
    [227399] = true,    -- Impact's Helm and Chestpiece Set
    [212553] = true,    -- Jewel-Encrusted Box
    [221371] = true,    -- Kidnapper's Coin Purse
    [227365] = true,    -- Mender's Boots, Legs, and Shoulders Set
    [227340] = true,    -- Mender's Gloves and Belt Set
    [227387] = true,    -- Mender's Helm and Chestpiece Set
    [227368] = true,    -- Merciful Boots, Legs, and Shoulders Set
    [227343] = true,    -- Merciful Gloves and Belt Set
    [227390] = true,    -- Merciful Helm and Chestpiece Set
    [219773] = true,    -- Mission Brief: Ashenvale
    [219526] = true,    -- Mission Brief: Duskwood
    [219775] = true,    -- Mission Brief: Feralas
    [219774] = true,    -- Mission Brief: Hinterlands
    [189427] = true,    -- More Raid Consumables
    [223150] = true,    -- Otherworldly Treasure
    [224851] = true,    -- Otherworldly Treasure
    [220446] = true,    -- Otherworldly Treasure
    [223151] = true,    -- Otherworldly Treasure
    [228615] = true,    -- Otherworldly Treasure
    [224848] = true,    -- Otherworldly Treasure
    [224850] = true,    -- Otherworldly Treasure
    [224849] = true,    -- Otherworldly Treasure
    [223148] = true,    -- Otherworldly Treasure
    [224836] = true,    -- Otherworldly Treasure
    [223149] = true,    -- Otherworldly Treasure
    [227367] = true,    -- Prowler's Boots, Legs, and Shoulders Set
    [227342] = true,    -- Prowler's Gloves and Belt Set
    [227389] = true,    -- Prowler's Helm and Chestpiece Set
    [227366] = true,    -- Pursuer's Boots, Legs, and Shoulders Set
    [227341] = true,    -- Pursuer's Gloves and Belt Set
    [227388] = true,    -- Pursuer's Helm and Chestpiece Set
    [227369] = true,    -- Radiant Boots, Legs, and Shoulders Set
    [227344] = true,    -- Radiant Gloves and Belt Set
    [227391] = true,    -- Radiant Helm and Chestpiece Set
    [189426] = true,    -- Raid Consumables
    [227375] = true,    -- Relief's Boots, Legs, and Shoulders Set
    [227350] = true,    -- Relief's Gloves and Belt Set
    [227397] = true,    -- Relief's Helm and Chestpiece Set
    [227378] = true,    -- Resolve's Boots, Legs, and Shoulders Set
    [227353] = true,    -- Resolve's Gloves and Belt Set
    [227400] = true,    -- Resolve's Helm and Chestpiece Set
    [211799] = true,    -- Sack of Stolen Goods
    [216971] = true,    -- Satchel of Copper Blood Coins
    [221367] = true,    -- Satchel of Copper Massacre Coins
    [228326] = true,    -- Satchel of Copper Slaughter Coins
    [216972] = true,    -- Satchel of Silver Blood Coins
    [221368] = true,    -- Satchel of Silver Massacre Coins
    [228327] = true,    -- Satchel of Silver Slaughter Coins
    [221491] = true,    -- Shadowtooth Bag
    [217014] = true,    -- Supply Bag
    [227373] = true,    -- Thrill's Boots, Legs, and Shoulders Set
    [227348] = true,    -- Thrill's Gloves and Belt Set
    [227395] = true,    -- Thrill's Helm and Chestpiece Set
    [213443] = true,    -- Ticking Present
    [227372] = true,    -- Twilight Boots, Legs, and Shoulders Set
    [227347] = true,    -- Twilight Gloves and Belt Set
    [227394] = true,    -- Twilight Helm and Chestpiece Set
    [227382] = true,    -- Unstoppable Boots, Legs, and Shoulders Set
    [227357] = true,    -- Unstoppable Gloves and Belt Set
    [227404] = true,    -- Unstoppable Helm and Chestpiece Set
    [231644] = true,    -- Warden's Enchanting Bag
    [231642] = true,    -- Warden's Herb Bag
    [227380] = true,    -- Wicked Boots, Legs, and Shoulders Set
    [227355] = true,    -- Wicked Gloves and Belt Set
    [227402] = true,    -- Wicked Helm and Chestpiece Set
    [216646] = true,    -- Ziri's Mystery Crate

--  Openable But Locked
--  https://www.wowhead.com/classic/items?filter=11:10:161:82;1:1:1:2;0:0:0:11401#0-1+20

--  [208838] = true,    -- Dark Iron Lockbox
--  [215451] = true,    -- Large Strongbox
--  [215452] = true,    -- Medium Strongbox
--  [227937] = true,    -- Puzzle Box
--  [215453] = true,    -- Small Strongbox
--  [215454] = true,    -- Tiny Strongbox
}

-- Create a frame to register events
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD") -- Trigger when player logs in or enters the world
frame:SetScript("OnEvent", OnEvent)

-- Function to check if any specified windows or conditions are active
local function WindowOpen()
    -- Check for windows like Trade, Merchant, Bank, etc.
    return TradeFrame and TradeFrame:IsVisible() or MerchantFrame and MerchantFrame:IsVisible() or
        BankFrame and BankFrame:IsVisible() or
        (ContainerFrame1 and ContainerFrame1:IsVisible()) or -- Backpack
        (ContainerFrame2 and ContainerFrame2:IsVisible()) or -- First bag
        (ContainerFrame3 and ContainerFrame3:IsVisible()) or -- Second bag
        (ContainerFrame4 and ContainerFrame4:IsVisible()) or -- Third bag
        (ContainerFrame5 and ContainerFrame5:IsVisible()) or -- Fourth bag
        (GossipFrame and GossipFrame:IsVisible()) or
        (AuctionFrame and AuctionFrame:IsVisible()) or
        (ReagentBankFrame and ReagentBankFrame:IsVisible()) or
        (CraftFrame and CraftFrame:IsVisible()) or
        (TradeSkillFrame and TradeSkillFrame:IsVisible()) or
        LootFrame and LootFrame:IsVisible() or
        MailFrame and MailFrame:IsVisible()
        -- or (CharacterFrame and CharacterFrame:IsVisible()) -- Character Sheet, for testing purposes
end

-- Function to check if there are fewer than 4 free bag spaces in generic bags
local function BagSpaceCheck()
    local freeSlots = 0
    -- Iterate over bags 0 to 4 (bag slots)
    for bag = 0, 4 do
        -- Get the number of free slots and the item family of the bag
        local numFreeSlots, bagFamily = C_Container.GetContainerNumFreeSlots(bag)
        -- Only count slots from generic bags (bagFamily == 0 means it's a generic bag)
        if bagFamily == 0 then
            freeSlots = freeSlots + numFreeSlots
        end
    end
    return freeSlots >= 4
end

-- Track whether the function is paused to prevent message spam
local isPaused = false

-- Create a frame to handle events
local eventFrame = CreateFrame("Frame")

-- Coroutine for handling delays
local function Delay(seconds)
    local start = GetTime()
    while GetTime() - start < seconds do
        coroutine.yield()
    end
end

-- Function to process items in the bag
local function ProcessItems()
    -- Check if any specified window or condition is active
    if WindowOpen() then
        -- Uncomment for more verbose messages.
        -- print("Open Sesame paused due to open window or active condition.")
        return
    end

    -- Pause the script if fewer than 4 free bag spaces
    if not BagSpaceCheck() then
        if not isPaused then
            print(
                "|cff4FC3F7Open Sesame|r : Paused until you have at least 4 free bag spaces available."
            )
            isPaused = true
        end
        return
    end

    -- Unpause if conditions allow processing
    isPaused = false

    -- Check auto-loot setting
    if not GetCVarBool("autoLootDefault") then
        return
    end

    -- Coroutine for processing items
    local co =
        coroutine.create(
        function()
            -- Process allowed items in the bag
            local itemsFound = false
            for bag = 0, 4 do
                local numSlots = C_Container.GetContainerNumSlots(bag)
                for slot = 1, numSlots do
                    local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
                    if containerInfo and containerInfo.itemID then
                        local itemID = containerInfo.itemID
                        if AllowedOpenItems[itemID] then
                            C_Container.UseContainerItem(bag, slot)
                            itemsFound = true
                            -- Delay for 0.5 seconds
                            Delay(0.5)
                        end
                    end
                end
            end

            if not itemsFound then
                -- If no items were found to process, unregister the event to prevent unnecessary calls
                eventFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
            end
        end
    )

    -- Run the coroutine
    coroutine.resume(co)
end

-- Event handler function
eventFrame:SetScript(
    "OnEvent",
    function(self, event)
        if event == "BAG_UPDATE" then
            if UnitAffectingCombat("player") then
                -- Register to process items when combat ends
                self:RegisterEvent("PLAYER_REGEN_ENABLED")
                return
            else
                ProcessItems()
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            -- Combat has ended, process items once
            ProcessItems()
            -- Unregister the event until needed again
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end
    end
)

-- Register events
eventFrame:RegisterEvent("BAG_UPDATE")
