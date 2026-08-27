local _, ns = ...

--------------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. Open Sesame uses the Simple saved-variables model — one
    shared profile for every character — so everything lives under `profile`,
    the mini-map subtable included, and `global` is unused. Core.lua hands this
    table to AceDB:New, which applies defaults via metatables — no hand-merge.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		autoOpen = true,
		-- "ALWAYS" | "OUTSIDE_INSTANCES"
		autoOpenWhere = "ALWAYS",
		-- "ALWAYS" | "SOLO_ONLY"
		autoOpenGroup = "ALWAYS",
		speedyLoot = true,
		lockboxTooltips = true,
		-- "ROGUES" | "ALL"
		lockboxTooltipsScope = "ROGUES",
		lootSounds = true,
		lootSoundThreshold = 2,
		-- Rogues only in practice; nothing else can cast Pick Pocket.
		pickPocketSound = true,
		lootToasts = true,
		--[[
            Whether this profile has been shown the drag handle and put it away.
            Per profile, not account-wide, on purpose: a new or reset profile is
            one that has not been introduced to the feature, and should be.
        ]]
		lootToastsIntroSeen = false,
		--[[
            Poor: everything the player loots gets a row. The toast stack stands
            in for the loot window Speedy Loot hides, and a window shows you what
            you picked up whatever colour it was. The loot SOUND keeps its
            Uncommon threshold above, because a sound is an interruption and a row
            is a record - one wants to be rare, the other wants to be complete.

            At this setting the always-shown kinds below have nothing left to do;
            they are there for the player who raises the threshold, and that is
            the moment they earn their place.
        ]]
		lootToastThreshold = 0,
		--[[
            All eight ignore the threshold above, and all eight ship on: each is a
            kind whose worth has nothing to do with its colour, so a threshold set
            high enough to quiet the noise would hide exactly the pickups a player
            wants to see. Bind on Pickup is the broad one - it catches the keeps
            the named kinds miss. Listed here in the order the options panel shows
            them, which is the player's order, not the order they are tested in.
        ]]
		lootToastBindOnPickup = true,
		lootToastQuestItems = true,
		lootToastRecipes = true,
		lootToastMounts = true,
		lootToastPets = true,
		lootToastKeys = true,
		lootToastBags = true,
		lootToastContainers = true,
		-- Not a threshold bypass: coin has no quality to be measured against.
		lootToastMoney = true,
		lootToastDuration = 5,
		lootToastMaxVisible = 8,
		-- "UP" | "DOWN"
		lootToastGrowth = "UP",
		-- "LEFT" | "RIGHT"
		lootToastAlign = "LEFT",
		lootToastFont = "DEFAULT",
		lootToastFontSize = 16,
		-- One of ns.LOOT_TOAST_FONT_FLAGS.
		lootToastFontFlags = "OUTLINE",
		showWelcome = true,
		lockboxNotifications = true,
		-- "ROGUES" | "ALL"
		lockboxNotificationsScope = "ROGUES",
		ignoreListNotifications = true,
		minimap = {},
	},
	--[[
        The Ignore List is deliberately account-wide: the containers a player
        hoards are a decision about the items, not about the character, so it
        must not move or reset with a profile.
    ]]
	global = {
		ignoreList = {},
		lootToastPosition = {},
	},
}

--------------------------------------------------------------------------------
-- Default Ignore List
--------------------------------------------------------------------------------

--[[
    The list the player's Ignore List is seeded from on first login and rebuilt
    from by Restore Defaults. The live list is ns.db.global.ignoreList; nothing
    reads this table directly. Shipping new entries here does not change an
    existing player's saved list, so note additions in the release notes.
]]

--[[
    REGENERATING THIS TABLE TAKES TWO SOURCES AND A HAND EDIT. Running the query
    below on its own does NOT reproduce what ships here - see the three notes at
    the end before replacing anything.

    Source 1, CMaNGOS (Wrath) world DB, decides WHICH containers and WHY. Two
    rules put a container on the list:

      * It drops from a raid boss (creature_template.rank = 3). Those are sold
        unopened in GDKP runs, so opening one destroys the reason to keep it.
        This branch deliberately ignores the container's own bonding: the DB has
        Blue Sack of Gems as Bind on Pickup while its four siblings are
        tradeable, which is a data quirk rather than a real difference.
      * It is a tradeable container holding a non-quest Bind on Pickup item.
        Opening it binds that item to you, destroying something sellable.

    Each clause earns its place:
      loot.bonding = 1            the loot binds on pickup
      loot.class <> 12            quest items are not a reason to hold off
      loot.startquest = 0         nor are quest starters
      c.bonding NOT IN (1, 4)     a container that is itself soulbound or a quest
                                  item could never be traded, so opening it costs
                                  nothing. Bind on Equip and Bind on Use stay in:
                                  a container is never equipped, and for Bind on
                                  Use, opening IS the use that binds it
      c.lockid = 0                never a lockbox, those are what the add-on opens
      c.name NOT LIKE 'Test %'    GM/debug items that never reach a player

    Unique is NOT a criterion. An early version used maxcount > 0 and produced
    144 rows instead of 35, because nearly every quest item and one-off trinket
    is Unique. Do not add it back.

    Source 2, WOWHEAD's per-client openable listings, decides the EXPANSION TAG
    and supplies ids the world DB has never heard of. See Data/Openable-Items.lua
    for the fuller account; the same three listings feed both tables.

    SQL comments here are /* block */ form on purpose: a -- comment runs to end of
    line, so any client that folds the statement onto one line would swallow the
    rest of the query and leave the parenthesis unclosed.

    WITH RECURSIVE
    loot_contents (container, ref_entry, item_entry) AS (
        SELECT ilt.entry,
               IF(ilt.mincountOrRef < 0, -ilt.mincountOrRef, NULL),
               IF(ilt.mincountOrRef > 0, ilt.item, NULL)
        FROM item_loot_template ilt
        UNION ALL
        SELECT lc.container,
               IF(rlt.mincountOrRef < 0, -rlt.mincountOrRef, NULL),
               IF(rlt.mincountOrRef > 0, rlt.item, NULL)
        FROM loot_contents lc
        JOIN reference_loot_template rlt ON rlt.entry = lc.ref_entry
        WHERE lc.ref_entry IS NOT NULL
    ),
    raid_drop (item_entry) AS (
        SELECT DISTINCT clt.item
        FROM creature_loot_template clt
        JOIN creature_template ct ON ct.entry = clt.entry
        WHERE ct.rank = 3 AND clt.mincountOrRef > 0
        UNION
        SELECT DISTINCT rlt.item
        FROM creature_loot_template clt
        JOIN creature_template ct ON ct.entry = clt.entry
        JOIN reference_loot_template rlt ON rlt.entry = -clt.mincountOrRef
        WHERE ct.rank = 3 AND clt.mincountOrRef < 0 AND rlt.mincountOrRef > 0
    )
    SELECT CONCAT('\t[', t.entry, '] = { EXPANSION, "', t.reason, '" }, -- ', t.name) AS lua_row
    FROM (
        SELECT c.entry, c.name,
               CASE
                   WHEN EXISTS (SELECT 1 FROM raid_drop rd WHERE rd.item_entry = c.entry) THEN 'RAID'
                   WHEN MAX(loot.HolidayId <> 0) = 1 THEN 'HOLIDAY'
                   WHEN MAX(loot.class = 9) = 1 THEN 'RECIPE'
                   WHEN MAX(loot.class IN (2, 4)) = 1 THEN 'GEAR'
                   ELSE 'ITEM'
               END AS reason
        FROM loot_contents lc
        JOIN item_template c    ON c.entry = lc.container
        JOIN item_template loot ON loot.entry = lc.item_entry
        WHERE c.lockid = 0
          AND c.name NOT LIKE 'Test %'
          AND (
              EXISTS (SELECT 1 FROM raid_drop rd WHERE rd.item_entry = c.entry)
              OR (loot.bonding = 1 AND loot.class <> 12 AND loot.startquest = 0
                  AND c.bonding NOT IN (1, 4))
          )
        GROUP BY c.entry, c.name
    ) t
    ORDER BY t.name;

    THREE THINGS THE QUERY DOES NOT PRODUCE, all of which ship here:

      1. The EXPANSION tag. It emits the literal EXPANSION as a placeholder; the
         real value comes from Wowhead availability (see Openable-Items.lua).
      2. Re-added ids under a name the query already returns - 191060 Black Sack
         of Gems is the current example. Wowhead carries them, the Wrath DB does
         not. They inherit the reason of the row sharing their name.
      3. The two rows marked "hand-added" in their comment: Gnarlpine Necklace
         and Pirate's Footlocker. Both hold only quest loot and neither is a raid
         drop, so no rule reaches them; they are on the list by maintainer
         decision and carry the QUEST reason.
]]

-- { [itemId] = { expansionThatAddedIt, reasonKey } } -- Container (the BoP loot)

ns.DEFAULT_IGNORE_ITEMS = {

	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[17962] = { ns.VANILLA, "RAID" }, -- Blue Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[11937] = { ns.VANILLA, "GEAR" }, -- Fat Sack of Coins (Fire Opal Necklace)
	[21979] = { ns.VANILLA, "HOLIDAY" }, -- Gift of Adoration: Darnassus (Love is in the Air gifts)
	[21980] = { ns.VANILLA, "HOLIDAY" }, -- Gift of Adoration: Ironforge (Love is in the Air gifts)
	[22164] = { ns.VANILLA, "HOLIDAY" }, -- Gift of Adoration: Orgrimmar (Love is in the Air gifts)
	[21981] = { ns.VANILLA, "HOLIDAY" }, -- Gift of Adoration: Stormwind (Love is in the Air gifts)
	[22165] = { ns.VANILLA, "HOLIDAY" }, -- Gift of Adoration: Thunder Bluff (Love is in the Air gifts)
	[22166] = { ns.VANILLA, "HOLIDAY" }, -- Gift of Adoration: Undercity (Love is in the Air gifts)
	[8049] = { ns.VANILLA, "QUEST" }, -- Gnarlpine Necklace (hand-added: Tallonkai's Jewel)
	[17964] = { ns.VANILLA, "RAID" }, -- Gray Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[17963] = { ns.VANILLA, "RAID" }, -- Green Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[13874] = { ns.VANILLA, "RAID" }, -- Heavy Crate (Gahz'ranka)
	[21150] = { ns.VANILLA, "RECIPE" }, -- Iron Bound Trunk (Weather-Beaten Journal)
	[21228] = { ns.VANILLA, "RECIPE" }, -- Mithril Bound Trunk (Weather-Beaten Journal)
	[9276] = { ns.VANILLA, "QUEST" }, -- Pirate's Footlocker (hand-added: Ship Schedule, map fragments)
	[22155] = { ns.VANILLA, "HOLIDAY" }, -- Pledge of Adoration: Darnassus (Love is in the Air gifts)
	[22154] = { ns.VANILLA, "HOLIDAY" }, -- Pledge of Adoration: Ironforge (Love is in the Air gifts)
	[22156] = { ns.VANILLA, "HOLIDAY" }, -- Pledge of Adoration: Orgrimmar (Love is in the Air gifts)
	[21975] = { ns.VANILLA, "HOLIDAY" }, -- Pledge of Adoration: Stormwind (Love is in the Air gifts)
	[22158] = { ns.VANILLA, "HOLIDAY" }, -- Pledge of Adoration: Thunder Bluff (Love is in the Air gifts)
	[22157] = { ns.VANILLA, "HOLIDAY" }, -- Pledge of Adoration: Undercity (Love is in the Air gifts)
	[17969] = { ns.VANILLA, "RAID" }, -- Red Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)
	[20767] = { ns.VANILLA, "RECIPE" }, -- Scum Covered Bag (Plans: Wicked Mithril Blade)
	[20708] = { ns.VANILLA, "RECIPE" }, -- Tightly Sealed Trunk (Weather-Beaten Journal)
	[6352] = { ns.VANILLA, "GEAR" }, -- Waterlogged Crate (Hammer of the Vesper)
	[21113] = { ns.VANILLA, "RECIPE" }, -- Watertight Trunk (Weather-Beaten Journal)
	[17965] = { ns.VANILLA, "RAID" }, -- Yellow Sack of Gems (Azuregos, Kazzak, the dragons, Nefarian)

	--------------------------------------------------------------------------------
	-- 02. World of Warcraft : The Burning Crusade
	--------------------------------------------------------------------------------

	[34846] = { ns.TBC, "RAID" }, -- Black Sack of Gems (Magtheridon)
	[191060] = { ns.TBC, "RAID" }, -- Black Sack of Gems (Magtheridon, same name)
	[34548] = { ns.TBC, "RECIPE" }, -- Cache of the Shattered Sun (11 Designs, Patterns and Plans)
	[27513] = { ns.TBC, "RECIPE" }, -- Curious Crate (Weather-Beaten Journal)
	[27481] = { ns.TBC, "RECIPE" }, -- Heavy Supply Crate (Weather-Beaten Journal)

	--------------------------------------------------------------------------------
	-- 03. World of Warcraft : Wrath of the Lich King
	--------------------------------------------------------------------------------

	[49294] = { ns.WRATH, "RAID" }, -- Ashen Sack of Gems (Onyxia)
	[43346] = { ns.WRATH, "RAID" }, -- Large Satchel of Spoils (Sartharion)
	[43347] = { ns.WRATH, "RAID" }, -- Satchel of Spoils (Sartharion)
}
