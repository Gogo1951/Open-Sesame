# Open Sesame // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Open Sesame. For end-user documentation, see [README.md](https://github.com/Gogo1951/Open-Sesame/blob/main/README.md).

## File Map

```text
Open-Sesame/
├── .github/
│   └── workflows/
│       └── package.yml                      CurseForge and Wago release, library vendoring
├── .gitattributes                           Line-ending normalization
├── .gitignore                               Dev-clutter ignore list
├── .luacheckrc                              Lint config
├── .pkgmeta                                 Externals and packager ignore list
├── Open-Sesame_Vanilla.toc                  Classic Era, Season of Discovery included
├── Open-Sesame_TBC.toc                      TBC Anniversary
├── Open-Sesame_Camelot.toc                  WoW Forever
├── Data/
│   ├── Flavor.lua                           Canonical flavor identity, copied byte for byte
│   ├── Data.lua                             Locale handle, constants, palette, icons, registry names, options widths
│   ├── Default-Settings.lua                 AceDB defaults (ns.DATABASE_DEFAULTS)
│   └── {Game}/                              One per flavor: Vanilla, Discovery, TBC, Camelot, Wrath, Mists, Mainline
│       ├── Openable-Items-{Game}.lua        Every container this client opens (ns.ALLOWED_ITEMS)
│       ├── Lockbox-Skill-Levels-{Game}.lua  Required Lockpicking per locked box (ns.LOCKBOX_SKILL_LEVELS)
│       ├── Default-Ignore-Items-{Game}.lua  Ignore List seed with a reason key per row (ns.DEFAULT_IGNORE_ITEMS)
│       ├── Spells-{Game}.lua                Pick Lock, Pick Pocket, Shadowmeld (ns.SPELLS)
│       └── Game-IDs-{Game}.lua              Skill-line, item and sound kit IDs
├── Diagnostics/                             House Diagnostic Tools; Manifests.lua is Open Sesame's own
├── Features/
│   ├── Core.lua                             Identity, runtime flags, AceDB setup and migrations, profile apply, event dispatcher
│   ├── Utilities.lua                        Container references, Auto Loot, scan tooltip, client-API picks, colour and scope helpers
│   ├── Announcements.lua                    PrintMessage, End of Support notice, status channel, quiet window, per-item throttle
│   ├── Ignore-List.lua                      Account-wide Ignore List: seed, query, mutate
│   ├── Auto-Opening.lua                     Safety gates, scan/queue/open pipeline, pause state, refused opens, locked-box list
│   ├── Speedy-Loot.lua                      Instant looting, loot-window suppression, master-looter stand-down
│   ├── Loot-Sounds.lua                      World-loot stamping, the loot sound, the Pick Pocket sound
│   ├── Lockbox-Tooltips.lua                 Lockpicking block on locked containers' tooltips
│   └── Minimap-Button.lua                   LibDataBroker launcher, tooltip, click handlers
├── Includes/
│   ├── Images/
│   │   └── Open-Sesame.tga                  Add-on icon
│   ├── Libraries/                           Vendored third-party code, never hand-edited
│   └── Sounds/
│       └── item-pick-up.ogg                 The loot sound
├── Locales/
│   ├── enUS.lua                             Source of truth
│   ├── deDE.lua
│   ├── esES.lua
│   ├── esMX.lua
│   ├── frFR.lua
│   ├── itIT.lua
│   ├── koKR.lua
│   ├── ptBR.lua
│   ├── ruRU.lua
│   ├── zhCN.lua
│   └── zhTW.lua
├── Options/
│   ├── Options-Utilities.lua                Widget helpers, sub-rows, item-link widget, item-cache watcher, item-list builder
│   ├── Options-General.lua                  Root panel
│   ├── Options-Notifications.lua            Loot Sound and the Pick Pocket sound
│   ├── Options-Lockboxes.lua                Lockbox Tooltips and lockbox notifications
│   ├── Options-Ignore-List.lua              Ignore List copy and callbacks
│   ├── Options-Profiles.lua                 Stock AceDBOptions-3.0 table, unmodified
│   └── Options.lua                          Panel registration, the options opener, /os
├── LICENSE                                  MIT
├── README.md                                Player-facing documentation
├── README-Notes.md                          The maintainer's settled rulings
├── README-Technical.md                      This file
└── README-Testing.md                        Manual test plan
```

No deprecated or dead files are present.

The three TOCs match line for line apart from `## Interface`, `## X-Flavor`, and the data folder each lists. The Vanilla TOC lists `Data/Vanilla/` then `Data/Discovery/`, and each file in that pair opens with its Season of Discovery guard, so exactly one folder's tables are built. The TBC TOC lists `Data/TBC/` and the Camelot TOC `Data/Camelot/`. `Data/Wrath/`, `Data/Mists/` and `Data/Mainline/` are listed by no TOC. `Diagnostics/Options-Diagnostics.lua` lives in the Diagnostics folder but loads in the TOC's Options block, just before `Options/Options.lua` registers it.

## Architecture

### Event Loop

A single hidden frame in [Core.lua](Features/Core.lua) owns every event. Its `OnEvent` script logs the firing when diagnostics logging is on, then dispatches to a handler keyed by event name in the `EventHandlers` table. Handlers are thin: each calls into the feature file that owns the behaviour, either as a method or as an alias onto a shared helper (`EventHandlers.BAG_UPDATE_DELAYED = OnScanRequest`). No feature file registers an event or owns an event frame.

Registration is driven from the `EventHandlers` table itself, so the frame can never listen for an event with no handler, or hold a handler nothing routes to:

- `ns.EVENT_NAMES` is built by iterating `EventHandlers`, sorted, so the Diagnostics Event Registration report probes the exact set the add-on uses.
- Registration walks the same keys and skips any name `C_EventUtils.IsEventValid` rejects, so an event absent on a future client build is skipped rather than aborting the loop. Every name in the table is valid on all three target clients today.
- `UNIT_SPELLCAST_SUCCEEDED` registers through `RegisterUnitEvent(event, "player")` so the frame does not wake on every group member's cast. The handler keeps its own `unit == "player"` guard as well.

The events fall into six groups:

- **Lifecycle.** `PLAYER_LOGIN` creates the database and does all first-time setup (see [Saved Variables](#saved-variables)). `PLAYER_ENTERING_WORLD` on a login or reload waits `ns.WORLD_LOAD_DELAY` (8s), then runs `ns.OnWorldLoaded`: it records the starting pause state as already announced, so a login with full bags prints nothing, forces a scan when Auto-Opening is on, and enforces Auto Loot when either feature is. Any other world entry raises a 2s quiet window and schedules a debounced scan, so zoning out of an instance resumes opening. `LOADING_SCREEN_ENABLED` and `LOADING_SCREEN_DISABLED` raise 10s and 3s quiet windows.
- **Bag churn.** `BAG_UPDATE_DELAYED` and `BAG_NEW_ITEMS_UPDATED` alias `OnScanRequest`, the debounced `ns.ScheduleScan()`. `GROUP_ROSTER_UPDATE` calls it only when the player's grouped state flips, since that is all the Group hold-off reads. `CHAT_MSG_LOOT` calls it only for the player's own loot: a raid's loot lines would otherwise walk the bags on every member's pickup.
- **Level-up.** `PLAYER_LEVEL_UP` clears the items Auto-Opening set aside as refused (see [Auto-Opening Queue](#auto-opening-queue)) and rescans, since a level can lift the requirement.
- **Interaction close.** `MERCHANT_CLOSED`, `MAIL_CLOSED`, `BANKFRAME_CLOSED`, `GOSSIP_CLOSED`, `QUEST_FINISHED`, `PLAYER_INTERACTION_MANAGER_FRAME_HIDE`, and `LOOT_CLOSED` (after Speedy Loot's reset and the world-loot close) share `OnInteractionClosed`, which forces an immediate scan and flushes any held status message after `ns.STATUS_FLUSH_DELAY`. `TRADE_CLOSED` runs that same helper plus a second delayed scan, for the reason given under [Auto-Opening Queue](#auto-opening-queue).
- **Loot.** `LOOT_READY`, `LOOT_OPENED`, and `LOOT_CLOSED` drive Loot Sounds and Speedy Loot, in an order that is load-bearing (see [Pick Pocket](#pick-pocket)). `LOOT_OPENED` also tells Auto-Opening its last open was answered. `CHAT_MSG_LOOT` keeps only the player's own loot, matched against prefixes derived once at load as the text before `%s` in `LOOT_ITEM_SELF` and `LOOT_ITEM_PUSHED_SELF` (only the prefix, since what follows the link differs by locale: zhCN ends in "。"), which must open the line. It then feeds the looted-container notices and the loot sound. Where one handler runs several features' steps (`LOOT_READY`, `CHAT_MSG_LOOT`), each step but the last goes through `securecallfunction`, so an error in one is still reported but cannot skip the rest.
- **State changes.** `PLAYER_REGEN_ENABLED` and `UPDATE_STEALTH` force a scan once opening is possible again. `UNIT_SPELLCAST_SUCCEEDED` routes Pick Lock to a delayed rescan and Pick Pocket to the Pick Pocket sound. `UI_ERROR_MESSAGE` drives the bag-full pause. `GET_ITEM_INFO_RECEIVED` feeds the options item-cache watcher, which is set only while a list row is waiting on the item cache.

### Combat Lockdown

**Open Sesame never casts anything and owns no secure frames.** It writes no macros and creates no protected buttons, so there is no dirty-flag replay pattern: the add-on opens containers and reports what it finds.

Two things behave differently in combat.

**The options opener refuses outright.** `ns:OpenOptionsPanel` in [Options.lua](Options/Options.lua) checks `InCombatLockdown()` first, prints `CHAT_OPTIONS_IN_COMBAT`, and returns. It never queues, retries, or waits for `PLAYER_REGEN_ENABLED`. The gate sits in the opener and nowhere else, so the `/os` handler and the mini-map button's Shift + Middle-Click share one copy of it. Blizzard's Settings panel is protected in combat, and without the gate the player gets an `ADDON_ACTION_BLOCKED` error naming the add-on.

**Opening defers instead.** Everything that opens a container funnels through `IsSafeToOpen()` in [Auto-Opening.lua](Features/Auto-Opening.lua), which refuses while any of these hold:

- Auto-Opening is off or paused.
- A Where or Group hold-off applies (below).
- The player is in combat (`UnitAffectingCombat`).
- A merchant, mail, trade, bank, guild bank, auction, gossip, quest, or loot frame is open (`IsInteractionActive`). Opening a container while a corpse's loot window is up would replace it, stranding anything Speedy Loot left there for the player. The auction check covers both `AuctionFrame` (Classic Era, TBC Anniversary) and `AuctionHouseFrame` (WoW Forever's Retail-engine UI), since using a bag item there would post it rather than open it.
- The player is stealthed: `IsStealthed`, or carrying the Shadowmeld aura (see [Common Pitfalls](#common-pitfalls)). Opening a container would break stealth.
- A cast or channel is in progress.
- Free general bag slots are below `ns.MIN_FREE_SLOTS`.

A static pop-up or a genuine item tooltip holds the tick too, but through `IsWaitingOnPlayer` rather than `IsSafeToOpen`: no event reports either one closing, so the tick re-arms and waits them out instead of stopping, which would leave the rest of the queue sitting in the bags until some unrelated bag event.

There is no queue replay: the open tick simply stops firing, and `PLAYER_REGEN_ENABLED` forces a fresh scan the moment combat ends. `UPDATE_STEALTH` does the same when the player leaves stealth out of combat. The combat test runs before the Shadowmeld aura walk and the cast reads, `OpenTick` ends its chain in combat, `RunScan` skips the queue rebuild, and `UPDATE_STEALTH` returns before its own aura walk, so the opening pipeline reads no auras or casts in combat. Each aura and cast read also asks `C_Secrets` first (`ShouldAurasBeSecret`, `ShouldUnitSpellCastingBeSecret("player")`), and an answer that would be secret reads as not safe to open; `UNIT_SPELLCAST_SUCCEEDED` returns early on the same cast predicate before comparing its spell ID. That keeps the add-on clear of Forever's secret values.

### Where and Group Hold-Offs

`IsSafeToOpen` also honours two player-set hold-offs, both defaulting to always open:

- **`autoOpenWhere`**, `"ALWAYS"` (shown as *Anywhere*) or `"OUTSIDE_INSTANCES"`; the latter refuses while `IsInInstance()` is true.
- **`autoOpenGroup`**, `"ALWAYS"` (shown as *Solo or Grouped*) or `"SOLO_ONLY"`; the latter refuses while `IsInGroup()` is true, party or raid.

Both stored values are `ALWAYS` while the visible copy differs, on purpose: each dropdown's options have to answer its own label, so *Where* offers places and *Group* offers group states. One shared "Always" string read as though the two rows duplicated each other.

The point is bag space: a player running dungeons wants slots free for drops, with the boxes opened later on their own time. Because both are read inside `IsSafeToOpen` rather than applied imperatively, nothing has to be re-applied on a profile switch. Changing either setting forces a scan, and two rescan paths cover leaving either state: `GROUP_ROSTER_UPDATE` covers joining and leaving a group, and the non-initial branch of `PLAYER_ENTERING_WORLD` covers zoning out of an instance, so opening resumes without waiting on a bag event.

### Scan → Queue → Open

The pipeline lives in [Auto-Opening.lua](Features/Auto-Opening.lua), fed by Core's dispatcher, and runs in three phases:

1. **Scan.** `ns.ScheduleScan(force)` absorbs bag churn. An unforced call schedules a scan `ns.SCAN_DEBOUNCE` (0.5s) out behind a pending flag and a target timestamp, and every further request before it runs is absorbed into it, so a burst of bag events costs one scan. Forced calls run immediately: profile apply, world load, combat end, leaving stealth, the pick-lock settle, interaction close, the Auto-Opening toggle and its Where and Group rules, and every Ignore List edit. Each run recomputes free slots; with Auto-Opening on it updates the pause state and announces any change; and, out of combat, it rebuilds the queue and starts the open tick. `RunScan` returns early before `PLAYER_LOGIN` has built the database. `RunScan` and its debounce callback are file-locals rather than closures built inside `ScheduleScan`, because every bag or loot event would otherwise allocate two throwaway functions before deciding whether a scan is needed at all.
2. **Queue.** `BuildQueue()` walks bags 0 to 4, resolves each slot's item ID through `SafeFastItemID`, and pushes the slot when `ShouldOpen` passes (see [Auto-Opening Queue](#auto-opening-queue)). The queue is a flat array of `(bag, slot, itemId)` triples with head and tail cursors, wiped and reset when drained.
3. **Open.** `OpenTick()` fires every `ns.OPEN_TICK_INTERVAL` (0.25s). It re-verifies safety, waits for the previous open's answer, pops one triple, confirms the slot still holds the cached ID, calls `ns.UseContainerItem`, then schedules a recheck after `ns.OPEN_RECHECK_DELAY` (0.25s) that requeues the slot if the same item is still there and still eligible. A single `openTimerLive` flag prevents overlapping tick chains. A cast or channel in progress reschedules the tick rather than dropping it, so the chain survives a mid-queue cast; combat ends the chain, and combat end restarts it through a fresh scan.

### Item Data Caching

The opening pipeline keys everything off numeric item IDs. `SafeFastItemID(bag, slot)` tries `ns.GetContainerItemID` first, which answers synchronously with no cold-cache nil, and only falls back to parsing the ID out of `ns.GetContainerItemLink`. Icons come from `C_Item.GetItemInfoInstant` through `ns.GetItemIconByID`, which answers from the client's own database and is never cold. Names in the mini-map tooltip come from the item's own link, already localized and quality-coloured.

`C_Item.GetItemInfo` is called in three places, and each handles its cold-call nil where it arises rather than through a shared cache:

- **`ShouldOpen`** reads the required level (return 5). A nil reads as no requirement, so the item is tried; if the game refuses it, the refusal count sets it aside (see [Auto-Opening Queue](#auto-opening-queue)).
- **Speedy Loot** reads the bind type (return 14) to keep the window up for a Bind on Pickup item. A nil reads as not Bind on Pickup, so this is best-effort.
- **The Ignore List panel** draws item links. A row the client has not cached yet registers through `ns.WatchUncachedItem`; see [Panel and the Shared Item-List Builder](#panel-and-the-shared-item-list-builder).

The `C_Container` functions are cached once as `ns` references in [Utilities.lua](Features/Utilities.lua), unguarded. The flavor-folder tables are static data, not runtime caches.

### Client Targets and API Surface

Open Sesame targets **Classic Era (1.15.x)** with Season of Discovery, **TBC Anniversary (2.5.x)**, and **WoW Forever (1.60.x)**, one TOC each. **The TOC names the flavor; code never works it out.** [Flavor.lua](Data/Flavor.lua), the house canonical file, reads the chosen TOC's `X-Flavor` into `ns.FLAVOR`, derives `ns.EXPANSION`, `ns.IS_DISCOVERY` and `ns.DATA_FOLDER`, and is the only place flavor identity is decided. `WOW_PROJECT_ID` is never read: Forever reports `WOW_PROJECT_MAINLINE`, the same as Retail.

Almost every client difference is data (which folder a TOC lists) or one of the availability picks below. The one flavor gate in feature code is the mini-map icon fit in [Minimap-Button.lua](Features/Minimap-Button.lua), which reads `ns.FLAVOR` for `Camelot` or `Mainline` (see [Mini-map Button](#mini-map-button)).

Forever is the Retail engine running Classic Era data, so it is the flavor most likely to lack a legacy global. Namespaced APIs are called directly, with no legacy fallback:

| Used | Removed or unusable on at least one target, do not call |
| --- | --- |
| `C_AddOns.GetAddOnMetadata` / `.GetAddOnInfo` / `.GetNumAddOns` / `.IsAddOnLoaded` | `GetAddOnMetadata`, `GetAddOnInfo`, `GetNumAddOns` |
| `C_Container.GetContainerNumSlots` / `.GetContainerNumFreeSlots` / `.GetContainerItemID` / `.GetContainerItemLink` / `.UseContainerItem` | `GetContainerNumSlots`, `GetContainerNumFreeSlots`, `GetContainerItemID`, `GetContainerItemLink`, `UseContainerItem` |
| `C_Item.GetItemInfo` / `.GetItemInfoInstant` (icons from its fifth return) | `GetItemInfo`, `GetItemInfoInstant`, `GetItemIcon`, all absent on Forever |
| `C_Spell.GetSpellName` | `GetSpellInfo`, absent on Forever |
| `C_TradeSkillUI.GetTradeSkillDisplayName` | The `LOCKPICKING` global string, which the clients do not publish |
| `C_PartyInfo.GetLootMethod`, which returns an enum **number** | `GetLootMethod`, which returned a string |
| `C_UnitAuras.GetBuffDataByIndex` | `UnitBuff`, still present, but its `spellId` return position differs between Era and TBC |
| `C_CVar.GetCVar` / `.GetCVarBool` / `.SetCVar` | `GetCVar` / `SetCVar`, still present but unused, so CVar access has one shape |
| `C_Secrets.ShouldAurasBeSecret` / `.ShouldUnitSpellCastingBeSecret`, `C_EventUtils.IsEventValid`, `C_Timer.After` | |
| `LE_GAME_ERR_INV_FULL` | `Enum.UIERRORS.ERR_INV_FULL`, absent on Era and TBC |

Five reads are picked by availability, resolved once and never by a truthy result:

- **`Settings.OpenToCategory`**, in `ns:OpenOptionsPanel`. Without it the opener falls through to `AceConfigDialog:Open`, and the panel opens as a floating window instead of docking.
- **`GetNumSkillLines` / `GetSkillLineInfo`**, in `ns.GetSkillLineRank`. Forever has no skill-line API, so there Lockbox Tooltips show the requirement without the player's rank.
- **The loot-slot item value**, `ns.LOOT_SLOT_TYPE_ITEM`: `Enum.LootSlotType.Item` where that table exists (Forever), otherwise `LOOT_SLOT_ITEM`.
- **`ns.GetTooltipLines`**, for Validate Data: `C_TooltipInfo` where the client ships both its item and spell getters (Forever), otherwise the scan tooltip.
- **`ns.GetItemStats`**, for Validate Data: `C_Item.GetItemStats` on Forever, the legacy `GetItemStats` global on Era and TBC, which have only that.

`ns.BIND_ON_PICKUP` in [Data.lua](Data/Data.lua) reads `Enum.ItemBind.OnAcquire` where it exists and falls back to `1`, its value on every target, so a renumbering cannot silently reclassify items. The master-loot method is the literal `2` rather than an `Enum` read, because `Enum.LootMethod` is not guaranteed on Era and TBC (on Forever the literal matches `Enum.LootMethod.Masterlooter`). It appears as `LOOT_METHOD_MASTER` in [Speedy-Loot.lua](Features/Speedy-Loot.lua) and again in [Manifests.lua](Diagnostics/Manifests.lua), where the Open Sesame Context report prints the live returns that verify the mapping.

Every API above has a row in `ns.DIAGNOSTIC_API_CHECKS`. So do the client strings the add-on reads rather than translates: `LOCKED`, `ITEM_MIN_SKILL`, `LOOT_ITEM_SELF` and `LOOT_ITEM_PUSHED_SELF`, and the `ITEM_QUALITYn_DESC` names. A missing string silences its feature rather than erroring, with one exception: without `LOCKED`, every box reads as unlocked and the queue tries to open boxes it cannot. Because the namespaced calls are unguarded, a `[FAIL]` row is a real break on that client rather than a note that a fallback took over. **Before adding a flavor gate or a legacy fallback, run the API Endpoints report on every client and let it prove the difference.**

## Auto-Opening Queue

The queue handles two kinds of item differently, encoded by the value in `ns.ALLOWED_ITEMS`:

- `true`, safe to open on sight (clams, coin pouches, gift boxes). Queued whenever present.
- `false`, a lockbox or locked chest. Queued **only once the client reports it unlocked**, detected by scanning the item's tooltip lines for the global `LOCKED` string (`ns.IsItemLocked`). Until then it sits in the bag.

`ShouldOpen` is the one test both `BuildQueue` and the post-open recheck use. Beyond the two kinds above it skips an item on the Ignore List, an item whose required level is above the player's, and an item set aside as refused.

**Refused opens.** A container the game opens answers with a loot window, so `OpenTick` records the open as pending and waits for `LOOT_OPENED` (`ns.OnOpenAnswered`) before the next one, up to `ns.OPEN_ANSWER_TIMEOUT` (1s). One still unanswered by then was refused: a holiday, a level requirement the cache had not answered, or another rule no API reports. After `ns.OPEN_REFUSAL_LIMIT` (3) refusals in a row the item is left alone until the next level-up or login, rather than tried every tick into the same red error.

`LOCKED` is matched against the whole tooltip line, never as a substring: it is a short word, and other add-ons write lines that contain it without meaning it.

Two events re-trigger a scan so a freshly unlocked box opens without waiting for the next bag update:

- `UNIT_SPELLCAST_SUCCEEDED` for the player's own **Pick Lock** (`ns.SPELLS.PICK_LOCK`), which rescans through `ns.RescanAfterUnlock` after `ns.PICK_LOCK_RESCAN_DELAY` (0.5s of settle).
- `TRADE_CLOSED`, which runs the shared immediate rescan **and** that same delayed rescan. Another rogue picking locks on boxes in the trade window fires no event on our side, and the unlocked state often has not settled client-side by the time `TRADE_CLOSED` arrives, so an immediate scan alone still reads the boxes as locked.

**Looted-container notices.** `ns.AnnounceLootedContainer`, called from Core's `CHAT_MSG_LOOT`, prints `ITEM_WILL_AUTO_OPEN` when a `false` item is looted, so the player knows it is queued rather than ignored. That notice needs the lockbox notifications toggle and its scope (`LockboxNotificationsEnabled`) **and** `autoOpen`, because the message promises automatic opening: with Auto-Opening off there is nothing to promise, so it stays quiet even though its own toggle lives on the **Lockboxes** panel. An item on the Ignore List gets `ITEM_IGNORED` instead; see [Ignore List](#ignore-list).

## Pause, Resume, and the Status Channel

Auto-Opening pauses itself when bag space runs low. **Pause and resume share a single threshold**, `ns.MIN_FREE_SLOTS` (4): `ShouldPause` pauses below it and `IsSafeToOpen` resumes on reaching it, so `PAUSED_BAG_SLOTS` reports `ns.MIN_FREE_SLOTS` directly. The count the message promises is the count that actually resumes opening, and adding an offset to either side would break that. Only general-purpose space counts: `ns.GetFreeSlots` skips any bag with a non-zero bag family, so a herb bag or quiver with room in it never counts toward the threshold.

A hard `UI_ERROR_MESSAGE` inventory-full firing, while Auto-Opening is on, forces an immediate pause, prints the client's own `ERR_INV_FULL` string through the status channel, and plays a race- and gender-specific "bags full" voice line from `ns.SOUND_KIT_IDS.BAG_FULL_BY_RACE`, falling back to `ns.SOUND_KIT_IDS.BAG_FULL_FALLBACK`. All of it is rate-limited by `ns.BAG_FULL_COOLDOWN` (10s). The next scan lifts the pause once enough slots are free. `ns.IsBagFullErrorID` is the only inventory-full test in the add-on: the handler and the Diagnostics event-log filter both classify `UI_ERROR_MESSAGE` through it, so a firing can never pause the add-on while the log files it away as uncorrelated noise. Never add a message-text match beside it, because the two would disagree exactly when a bug report needs the log line.

`AnnounceStatus` in [Auto-Opening.lua](Features/Auto-Opening.lua) speaks only when the pause state differs from what the player was last told (`ns.state.announcedPaused`), and holds its message while an interaction frame is open: it returns early when `IsInteractionActive()` is true, and `OnInteractionClosed` calls it again after `ns.STATUS_FLUSH_DELAY` (0.25s), so a "Resumed" is not lost in the middle of the player's vendoring. Because the last-told state only moves when something is said, the flush reports the current state rather than replaying a stale one.

Those prints go through `ns:StatusPrint` in [Announcements.lua](Features/Announcements.lua), which:

- suppresses output during the **quiet window** (`ns:SetQuiet` and `IsQuiet`), raised on loading screens and on zoning so transient churn stays silent. `SetQuiet` only ever extends the window, never shortens it.
- drops an identical message repeated inside `ns.STATUS_REPEAT_COOLDOWN` (5s).

Per-item notices use a separate throttle, `ns:AnnounceItemOnce`, which allows one message per item ID per `ns.ITEM_ANNOUNCE_COOLDOWN` (5s). Both Ignore List notices share that stamp deliberately: a player who was just told Speedy Loot left an item behind does not also need to be told it will not be opened.

## Ignore List

[Ignore-List.lua](Features/Ignore-List.lua) owns the player's list of containers Open Sesame leaves alone entirely: Speedy Loot leaves them in the loot window, and Auto-Opening never queues them even when `ns.ALLOWED_ITEMS` allows the item. Every consumer asks the same question, `ns:IsIgnored(itemId)`: `ShouldOpen`, `ns.GetLockedBoxes`, `ns.AnnounceLootedContainer`, Speedy Loot's per-slot skip, and the Locked Boxes table in the Open Sesame Context report.

Two notices say when the list stepped in, both gated by `ignoreListNotifications` (the toggle on the Ignore List panel) and throttled by `ns:AnnounceItemOnce`: `ITEM_IGNORED` when an ignored container is looted, and `ITEM_OPEN_MANUALLY` when Speedy Loot leaves one in the loot window.

**The list is account-wide**, in `ns.db.global.ignoreList`. Which containers a player hoards is a decision about the items, not about the character, and a hand-built list must survive a profile reset.

**Two tables, two shapes, and they are not interchangeable.** `ns.DEFAULT_IGNORE_ITEMS` in the flavor folder's `Default-Ignore-Items-{Game}.lua` is the shipped seed and stores a reason key per ID. The saved list stores `true` per ID and nothing else. `SeedFrom` writes `true`, never the entry.

That split is deliberate. The reason is looked up from `ns.DEFAULT_IGNORE_ITEMS` at read time rather than copied in at seed time, so any saved list shows it and better copy reaches every player without a migration. The reason resolves to one of six locale keys (`RAID`, `QUEST`, `RECIPE`, `GEAR`, `HOLIDAY`, `ITEM`, the last also the fallback for an unknown key) rather than carrying its own sentence, because free text per row would be one string per row for every locale to translate, sitting outside `Locales/` entirely. Item names stay out of those strings: the client already draws its own localized tooltip directly above the line. `ns:GetIgnoreNote` prefixes the reason with `ns.ICON_IGNORED`, the client's own red pass icon, so the row reads as refused at a glance, and returns nil for anything the player added.

**Seeding follows the house default-list rule.** `ns:SeedIgnoreList` runs from `PLAYER_LOGIN` right after `AceDB:New` and rebuilds only when the saved list is missing or empty. Note what that means at the edge: an empty list is indistinguishable from a fresh install, so a player who removes *every* row keeps it empty for the rest of the session and finds it reseeded at their next login. Removing rows individually is what sticks, which is the case the rule exists for.

**Seeding and Restore Defaults write every row this client loaded.** Each flavor folder carries only the rows whose item that client has, so an ID from a later expansion, which would never answer `C_Item.GetItemInfo` and sit in the panel as a bare number, is never loaded on that client in the first place.

Every mutation (`ns:AddIgnoredItem`, `ns:RemoveIgnoredItem`, `ns:RestoreDefaultIgnoreList`) forces a rescan and ends in `AceConfigRegistry:NotifyChange` on the Ignore List registry so the panel redraws.

### Panel and the Shared Item-List Builder

The panel itself ([Options-Ignore-List.lua](Options/Options-Ignore-List.lua)) supplies only copy, the source table, and callbacks. The shape comes from `ns:BuildItemListOptions` in [Options-Utilities.lua](Options/Options-Utilities.lua): an add box that parses a dragged item, a pasted link, or a bare ID, then one inline group per item sorted **by item name**, each row an item-link cell plus an icon-only remove button whose widths total `ns.OPTIONS_ROW_WIDTH`, and Restore Defaults (confirmed) last. A row whose item is not cached yet shows `OPTIONS_ITEM_LOADING` until the cache answers. Removing a row takes one click with no confirm, since dragging the item back in restores it. The panel starts its list at `startOrder = 10`, leaving orders 1 to 9 for its own description and the notifications toggle.

Four mechanics are worth knowing before editing it:

- **It registers the builder, not a built table.** `AceConfigRegistry:RegisterOptionsTable` accepts a function and calls it afresh on every fetch, which is what lets `NotifyChange` draw rows that did not exist at login. Registering `ns.BuildIgnoreListOptions()` instead of `ns.BuildIgnoreListOptions` would freeze the list at its login contents.
- **Uncached items resolve through Core's dispatcher.** A row with no `C_Item.GetItemInfo` answer yet registers through `ns.WatchUncachedItem`, which sets `ns.OnItemInfoReceived`. Core's `GET_ITEM_INFO_RECEIVED` handler calls it. Answers arrive in bursts on a cold cache, so the redraw waits `ITEM_INFO_REDRAW_DELAY` (0.3s) and covers the whole burst rather than rebuilding once per item. The callback clears once nothing is outstanding, so the dispatcher stops doing work. Uncached rows sort under their raw ID until then.
- **Unresolvable IDs are dropped before a row is built.** Each row is tested with `C_Item.GetItemInfoInstant` first, which answers synchronously from the client's own database and so separates "not cached yet" from "does not exist here" without waiting on an event that will never fire. An ID the server answers with `success == false` (Forever knows later expansions' IDs but never serves them) is remembered and gets no row either, or it would sit as a bare number and hold the watcher open forever.
- **The row's note is drawn by the widget, not by AceConfig.** `noteFor(itemId)` is carried as the option's `desc`; AceConfigDialog's `InjectInfo` hangs the option table off the widget's user data, and the item-link widget (`ns.ITEM_LINK_WIDGET_TYPE`) reads `option.desc` in its own `OnEnter` and appends it under the item tooltip. That step is required rather than incidental: the widget replaces AceConfigDialog's `OnEnter` so it can show the game's item tooltip, which means a `desc` would otherwise never be drawn at all.

## Speedy Loot

[Speedy-Loot.lua](Features/Speedy-Loot.lua) loots corpses instantly and hides the loot window. `ns.HandleSpeedyLoot` is invoked from Core's `LOOT_READY` handler rather than from a frame of its own, so a single registration owns the event and the ordering is explicit rather than left to dispatch order.

**Window suppression runs through `OnShow`.** A plain `LootFrame:Hide()` on `LOOT_READY` is a no-op: the frame is not shown yet, the default UI shows it on `LOOT_OPENED`, and nothing re-hides it, which is the roughly half-second flash. Instead a one-time `HookScript("OnShow", ...)`, installed at file load, re-hides the frame the instant the default UI shows it, but only while `suppressLootWindow` is set. That flag is `not leftBehind and not bagsTight`, true only when the pass took *everything* with room to spare. Anything left behind keeps the window visible through an explicit `LootFrame:Show()`.

**Hiding the loot window closes the loot.** The default UI calls `CloseLoot()` from the loot frame's `OnHide`, so the suppression hide lands before the server has answered a single `LootSlot`, and a pickup that then fails is left on a corpse the player can no longer see. The free-slot count is only a guess until the server answers, because items from the previous corpse can still be arriving. So `bagsTight`, set when the pass took an item and leaves fewer than `ns.MIN_FREE_SLOTS` free (the line Auto-Opening pauses at), keeps the window up: it closes itself once the last item is taken, and anything that bounced off full bags stays in it. For the same reason the pass never hides the frame itself; only the `OnShow` hook does, and only when the verdict is safe.

**Some slots keep the window up.** A slot `GetLootSlotInfo` reports locked is still being rolled for, or isn't the player's to take yet, so the pass skips it and leaves it to its roll window rather than calling `LootSlot` into an error. A Bind on Pickup item is taken but sets `leftBehind`: the client asks its bind question only while the loot session is open, and hiding the window would cancel it. An ignored item, or one skipped because bags filled mid-loop, sets `leftBehind` too.

**`suppressLootWindow` resets on `LOOT_CLOSED`.** Because `LOOT_READY` can be throttled, one corpse's "fully looted" verdict must not carry onto the next corpse's unlooted window. Core's `LOOT_CLOSED` handler calls `ns.ResetSpeedyLootWindow()`.

**Master looter stands the whole pass down.** Master loot is a managed flow: at or above threshold, items are assigned through the master looter window, and below it the group method hands them out, so there is nothing for Speedy Loot to take. Calling `LootSlot` on a threshold item also pops `MasterLooterFrame_Show` with no selection, which crashes on a nil `colorInfo` on some clients. `IsPlayerMasterLooter()` reads `C_PartyInfo.GetLootMethod()` and tests `method == LOOT_METHOD_MASTER and masterLooterPartyID == 0`.

**Bag-full safety.** Money and currency slots (`IsItemLootSlot` false) take no bag space and are always looted. Real item slots are only taken while `freeSlots > 0`, one slot per item even when it would stack onto one already carried; if general bags are full and real items are waiting, the pass loots nothing and leaves the window open so items can be taken by hand. Only general-purpose bag space counts, by design. Speedy Loot never reads Auto-Opening's pause state; the two only share the `ns.MIN_FREE_SLOTS` line.

**Auto Loot is respected, not overridden.** The pass runs only when `autoLootDefault` and `IsModifiedClick("AUTOLOOTTOGGLE")` disagree, which is the same rule the default UI applies: holding the auto-loot modifier inverts the setting. Repeat firings inside `ns.LOOT_DELAY` (0.25s) of a completed pass are dropped.

## Auto Loot Enforcement

Speedy Loot and Auto-Opening both depend on the game's Auto Loot, and Open Sesame enforces it. `ns.EnsureAutoLoot()` in [Utilities.lua](Features/Utilities.lua) reads `autoLootDefault` and writes `1` only when it is off, then prints `AUTO_LOOT_ENABLED`. It runs on profile apply and world load when either feature is on, and on each of the four toggles that turn one on (the two on the General panel and the two on the mini-map button).

**This is the one enforced CVar the add-on ships without an opt-out toggle**, and that is deliberate: Open Sesame cannot do its job with Auto Loot off, so a toggle would only offer a way to break the add-on. Every other rule on an enforced write still binds: the write happens only on an actual change, the player is told through a `PrintMessage` notice, and `README.md` discloses the behaviour in its Setup section. Keep that disclosure in place if the Setup copy is rewritten. The `taintLog` CVar in the Diagnostics panel is the only other CVar the add-on writes, and it is user-initiated rather than enforced.

## Lockboxes

Two features share the **Lockboxes** panel, and both work the same way: a toggle (default on) plus a **Show for** scope of `"ROGUES"` or `"ALL"`, defaulting to Rogues only. A non-Rogue cannot pick a lock, so neither feature has much to say to them out of the box.

Both apply one scope rule, `ns.LockboxScopeAllows` in [Utilities.lua](Features/Utilities.lua), alongside `ns.IsPlayerRogue`. Each keeps its own on/off predicate as a file-local beside the code that reads it: `LockboxTooltipsEnabled` in [Lockbox-Tooltips.lua](Features/Lockbox-Tooltips.lua), and `LockboxNotificationsEnabled` in [Auto-Opening.lua](Features/Auto-Opening.lua) for the looted-container notice. A feature is on when its toggle is on **and** its scope either covers everyone or the player is a Rogue.

### Lockbox Tooltips

[Lockbox-Tooltips.lua](Features/Lockbox-Tooltips.lua) answers the question a locked box in the bag raises on its own: what skill does this need, and can I open it yet. It adds its own block, set off from the client's lines by a blank separator: the add-on's name, then a label and a number as an `AddDoubleLine`, so the number sits in the tooltip's right column. Both labels are bare text, with the number passed as a separate argument rather than as a `%d` in the string. Read-only throughout: nothing casts, sends chat, or writes state.

**Two shapes, never both.** When the client does not state the requirement itself, the block shows `TOOLTIP_REQUIRES_LOCKPICKING_LABEL` with the box's required skill, green on a Rogue whose skill clears it, red on one whose skill does not, and neutral body colour when the rank is unknown (a non-Rogue under the `"ALL"` scope, or Forever). When the client already prints its own requirement line, repeating it would be noise, so the block shows `TOOLTIP_YOUR_LOCKPICKING_LABEL` with the player's own rank, coloured the same way; with no rank to show, the block is skipped entirely.

**The data.** `ns.LOCKBOX_SKILL_LEVELS` maps item ID to required skill, one row for every `false` row of `ns.ALLOWED_ITEMS` whose lock a Rogue can pick. A container whose lock asks for something else (a key, or another profession) has no row, which means no tooltip block for that box rather than a guessed number. The values are numbers and the tooltip formats them as numbers, so a placeholder string here would error on hover.

**Reading the player's skill.** `ns.GetPlayerLockpickingSkill` asks `ns.GetSkillLineRank` in [Utilities.lua](Features/Utilities.lua), which scans `GetNumSkillLines` and `GetSkillLineInfo` for the line whose name matches the localized name of the Lockpicking skill line, because the skill lines are the only place the player's *current* rank lives. The tooltip asks only on a Rogue. It returns nil for an untrained Rogue, a client that did not answer for the skill line's name, or Forever, which has no skill-line API, and every caller treats nil as unknown and falls back to neutral colouring instead of erroring. That last case is a recorded decision (README-Notes).

That localized name comes from the **skill line record** `ns.SKILL_LINE_IDS.LOCKPICKING` (633) itself, through `C_TradeSkillUI.GetTradeSkillDisplayName`: the skill list shows skill-line names, so the lookup asks for the same kind of record, from the client's static database, before the player has trained anything. `ns.DIAGNOSTIC_API_CHECKS` probes the lookup, so a client that stopped answering shows as a FAIL row rather than as a silently neutral tooltip.

Three other sources for that name are **deliberately not used**, and none should come back:

- The `LOCKPICKING` **global string**. The clients do not publish it.
- The name of the **Lockpicking skill spell**. A spell and a skill line are separate records, and their names can differ by locale.
- The client's own **"Requires Lockpicking (N)" tooltip line**, read through an `ITEM_MIN_SKILL` pattern. That is circular: on a client that does not print that line, the name is never learned, the rank is always nil, and the requirement line stays neutral instead of green or red.

**Two duplicates, two different guards.** A tooltip can be re-processed without being cleared, so `TooltipHasText` looks for the branded header and bails, one check covering every line the block adds. Separately, `ClientStatesRequirement` decides between the two shapes above by matching the `ITEM_MIN_SKILL` format (turned into a pattern by `ns.BuildFormatPattern`) rather than the skill's name, on purpose: other add-ons print lines that name Lockpicking without stating a requirement, ATT's "World Drop > Lockpicking" breadcrumb among them, and a name match would read those as the client's line.

**Which hook, and when it is installed.** `hooksecurefunc(GameTooltip, "SetBagItem", ...)`, unguarded: a widget method present on all three clients, firing for exactly the bag and bank slots the feature is about. `TooltipDataProcessor.AddTooltipPostCall` would reach every item tooltip, links and vendor windows included, and Classic Era does not have it.

The hook is installed from `PLAYER_LOGIN` rather than at file scope, and that placement is the whole ordering strategy. Post-hooks on `SetBagItem` run in the order they were registered, so registering after every other add-on has loaded puts our block last for free. A `SetBagItem` post-hook is also about as late as a synchronous add can be: the client's lines are set, and every add-on that adds to the item tooltip while it is built has had its say.

**Deferring the add to the next frame is rejected outright.** `C_Timer.After(0)` does put the block under everything, and it strobes badly: a hovered bag button re-runs `SetBagItem` every frame, so the tooltip is rebuilt without the block, gets it a frame later, loses it on the next rebuild, and flickers for as long as the cursor rests on the item. A row out of place beats a tooltip that strobes. Do not reintroduce it, in any form that adds lines outside the build itself.

### Why There Is No Click-to-Pick-Lock Gesture

**Do not build this again without new evidence.** A modifier-click gesture that put a `SecureActionButtonTemplate` over the hovered bag button, with `macrotext` of `/cast Pick Lock` plus `/use <bag> <slot>`, does not work, because the click never reaches the button.

What has been ruled out, so nobody re-runs these experiments:

- **The macro is correct.** Pasted into a real macro, `/cast Pick Lock` then `/use 0 5` picks the lock.
- **Bag replacement add-ons are not the cause.** It fails with every bag add-on disabled, on the default bags.
- **Frame stacking is not the cause.** `HIGH` loses to the bags, which set their own frame levels; `TOOLTIP` clears them outright. It still does not fire.
- **Tooltip ownership is not the cause.** Reading `GameTooltip:GetOwner()` is unreliable when another add-on re-owns the shared tooltip; `GetMouseFoci` answers what the pointer is actually inside. It still does not fire.
- **The overlay strobe is a separate bug** with its own fix: hiding the overlay when the tooltip hides hands the cursor back to the bag button, which re-shows the tooltip, which re-raises the overlay, at frame rate.

Two add-ons implementing this pattern, Locksmith and LazyLockBoxes, use the same choices (`TOOLTIP` strata, `GetMouseFoci`, restoring the tooltip from the overlay's `OnEnter`, a lockpick cursor), and **neither is confirmed working on Classic Era 1.15.x either.** The most likely explanation is that the client no longer lets an add-on's secure button take a click over a bag slot, which is not something an add-on can work around.

What ships instead is enough: the tooltip says what a box needs and whether the player clears it, `UNIT_SPELLCAST_SUCCEEDED` on Pick Lock rescans so a hand-picked box opens itself half a second later, and the mini-map tooltip lists what is still locked.

## Loot Sounds

[Loot-Sounds.lua](Features/Loot-Sounds.lua) owns both sounds; Core's dispatcher only calls into it. The loot sound must fire only for loot pulled from a corpse, chest, or node, never for disenchanting, prospecting or milling, container opens, or the server's white-into-green item merge, all of which travel the same `LOOT_OPENED` plus `CHAT_MSG_LOOT` path a corpse does. They differ only in the **loot source GUID**:

- `CurrentLootFromWorldSource()` classifies the open loot window as `"world"` (at least one `Creature-`, `Vehicle-`, or `GameObject-` source), `"item"` (every resolved source is `Item-`), or `"unknown"` (the window is empty or the GUIDs have not populated).
- `ns.StampWorldLoot()` runs on both `LOOT_READY` and `LOOT_OPENED`, because the GUID can populate on either and Speedy Loot may empty the slots between them. It sets `ns.state.worldLootOpen` on `"world"`, clears it (and the close time) on `"item"` so a disenchant cannot reuse a real corpse's window, and leaves it alone on `"unknown"`. That third state is kept distinct from `"item"` on purpose: a late-arriving world GUID must still be able to open the window, and one just opened for this corpse must survive an empty re-read. Core's `LOOT_CLOSED` calls `ns.CloseWorldLoot`, which records `ns.state.worldLootClosedAt`.
- `ns.PlayLootSound`, called from Core's `CHAT_MSG_LOOT`, plays `ns.LOOT_SOUND_FILE` (`Includes/Sounds/item-pick-up.ogg`, through `PlaySoundFile`) only when loot sounds are on, a corpse or chest window is open or closed less than `ns.LOOT_SOUND_WINDOW` (1s) ago (so an item looted by hand, or a Bind on Pickup item confirmed, after the window opened still sounds), and the item link's colour gives a quality at or above `lootSoundThreshold` (default 2, Uncommon; the dropdown offers Uncommon to Epic, named by the client's `ITEM_QUALITYn_DESC` strings).

`ns.GetLinkQuality` reads quality off the link's colour because that is the only quality signal available without a `C_Item.GetItemInfo` round trip. The Retail engine's `|cnIQn:` escape carries the quality directly, and a Classic hex colour maps through `ns.QUALITY_COLORS`. Heirloom shares Legendary's 5 so it always plays at any threshold; a colour the table does not carry, quest yellow for instance, returns nil, and the loot sound stays quiet on it. Core's loot-line link capture accepts either colour form.

### Pick Pocket

A rogue's pickpocket is the loot Speedy Loot hides most completely: it is mostly coin, which carries no quality, and its window is gone before it is seen. `pickPocketSound` plays `ns.SOUND_KIT_IDS.PICK_POCKET` for it, and the two halves are deliberately split across two events:

- `UNIT_SPELLCAST_SUCCEEDED` for `ns.SPELLS.PICK_POCKET` only **arms** it, through `ns.ArmPickPocketSound`, stamping `ns.state.pickPocketAt`.
- `ns.PlayPickPocketSound`, called from `LOOT_READY` and `LOOT_OPENED`, plays it only if a loot window with at least one slot opened within `ns.PICK_POCKET_LOOT_WINDOW` (1s) of that stamp, and disarms as it plays so one cast sounds once no matter how many loot events the window generates.

**The cast is not the confirmation.** Picking a target whose pockets are already empty fires `UNIT_SPELLCAST_SUCCEEDED` *and* an "already had its pockets picked" error together, and yields nothing, so hanging the sound on the cast would announce a haul that does not exist. A pickpocket that comes up empty opens no window at all and the arming simply times out.

`PlayPickPocketSound` **must be called before `ns.HandleSpeedyLoot`** in the `LOOT_READY` handler: Speedy Loot empties the slots, and an emptied window is indistinguishable from a pickpocket that found nothing. `ns.StampWorldLoot` runs first of all, for the same reason.

## End of Support Notice

`ns:PrintEndOfSupport()` in [Announcements.lua](Features/Announcements.lua) prints `CHAT_END_OF_SUPPORT` through `ns:PrintMessage` at every login, straight after the welcome. It has no setting and never reads `showWelcome`, so it shows even for a player who turned the welcome message off. That is a recorded decision (README-Notes): every player should learn that Open Sesame now lives on inside GogoLoot.

Loot Toasts no longer exists; its fix ships in GogoLoot. Its saved settings are cleared at login by a tagged migration (see [Saved Variables](#saved-variables)).

## Mini-map Button

[Minimap-Button.lua](Features/Minimap-Button.lua) registers a LibDataBroker launcher and shows it through LibDBIcon-1.0. The icon swaps between the `on`, `paused`, and `off` textures in `ns.ICONS` to mirror runtime state, and the broker's `text` field carries the same state in words for display add-ons. Clicks: **left** toggles Auto-Opening, **right** toggles Speedy Loot, **middle** toggles Loot Sounds, and **Shift + Middle-Click** opens the Options Interface, checked first in `OnClick` before any feature button. The combat refusal lives inside `ns:OpenOptionsPanel` and is never duplicated here. After a toggle click the tooltip re-renders in place while the button still owns it, so the on/off states stay live.

A **Locked Items** list leads the tooltip, directly under the title and above the feature blocks, drawn only when boxes are actually waiting (a recorded decision in README-Notes). It is the one part that reflects the bags rather than a setting, so it is what the player opened the tooltip to check. It comes from `ns.GetLockedBoxes` in [Auto-Opening.lua](Features/Auto-Opening.lua): allowed-but-locked containers that are not on the Ignore List and still report `LOCKED`, collapsed to one row per distinct item with a stack count and **sorted by name**. Each line is the item's icon, then its name taken from the container's own item link, already localized and quality-coloured, with the brackets stripped since a tooltip line is not running text, and ` xN` appended only when more than one is held so no locale needs a plural form.

It is computed on demand rather than cached: it runs once per tooltip render, not per frame, and a cache would need invalidating on every bag, trade, and pick-lock event. The scan stays cheap because `ns.IsItemLocked` is reached only for IDs `ns.ALLOWED_ITEMS` already marks as needing an unlock.

Both the button's position and its visibility live in `ns.db.profile.minimap`, the subtable handed straight to LibDBIcon. `hide` is the single source of truth for visibility, written by `ns:SetMinimapShown` and read by the options toggle, inverted for its "Enable" label. Under the Simple model this is profile state, so switching or resetting a profile changes it, and `ns:UpdateMinimapIcon` calls `LDBIcon:Refresh` with the live subtable on the profile callbacks so the change applies without a reload. On `Camelot` and `Mainline`, `ns:InitMinimap` re-centers the icon and masks it round right after `LDBIcon:Register`, because LibDBIcon leaves the square icon off-center in the Retail-engine ring.

## Options Panels

Six panels, registered in [Options.lua](Options/Options.lua) in the house order: **General** (root), then the feature panels **Notifications**, **Lockboxes**, and **Ignore List**, then **Profiles** second to last and **Diagnostic Tools** last. That order is the order of the `AddToBlizOptions` calls. The feature panels are grouped by what the player notices rather than one per feature file: Notifications holds Loot Sound and the Pick Pocket sound; Lockboxes holds Lockbox Tooltips and the lockbox notifications; and the root panel keeps the welcome and mini-map toggles, Auto-Opening with its Where and Group rules, Speedy Loot, `/Commands`, the four links, and the version line.

**Registration is deferred, never at file scope.** `ns:RegisterOptionsPanels` is called from `PLAYER_LOGIN` immediately after `AceDB:New`, because the Profiles builder calls `AceDBOptions:GetOptionsTable(ns.db)` and `ns.db` does not exist earlier.

**The opener routes by captured category ID.** `AddToBlizOptions` returns `(frame, categoryID)`, and both are captured at the root panel's registration as `ns.GeneralPanel` and `ns.GeneralCategoryID`. `ns:OpenOptionsPanel` gates on combat, then calls `Settings.OpenToCategory(ns.GeneralCategoryID)`, then falls through to `AceConfigDialog:Open` as a last resort a correctly routed add-on never reaches. **Never look up the category by name:** a title lookup fails wherever the category ID is a number assigned at registration, execution falls through to the dialog, and the panel appears as a floating window instead of docking. It breaks on TBC Anniversary while still working on Classic Era, so it survives testing on one flavor.

**Sub-option rows are shared, not per-panel.** `ns.OptionsSubRow`, `ns.OptionsSubLabel`, and `ns.OptionsSubSelectRow` live in [Options-Utilities.lua](Options/Options-Utilities.lua). Three panels build sub-rows (General's Where and Group rules, Lockboxes' two scopes, Notifications' quality threshold), so one shared shape keeps them from drifting apart. The mechanical constraints hold wherever they are built: one unnamed inline group per sub-option, a real indent widget rather than padded caption text, control widths sized with slack rather than to an exact fit, and `hidden` on the group rather than on its members. The shared caption and control widths are `ns.OPTIONS_SUB_LABEL_WIDTH` and `ns.OPTIONS_SUB_CONTROL_WIDTH` in [Data.lua](Data/Data.lua). The Loot Sound threshold row carries a third cell, a speaker button that previews the sound, so it is built with `ns.OptionsSubRow` directly.

**The Ignore List panel registers its builder, not a built table**, so the list can redraw rows that did not exist at login. See [Panel and the Shared Item-List Builder](#panel-and-the-shared-item-list-builder).

**The Profiles panel returns the stock AceDBOptions-3.0 table unmodified.** It is never mutated: `GetOptionsTable` does not return a private copy, so writing to the returned `args` would change every other Ace add-on's Profiles panel in the session.

## Diagnostics Panel

[Diagnostics/](Diagnostics/) is the house Diagnostic Tools framework, shared with the other Gogo1951 add-ons; only [Manifests.lua](Diagnostics/Manifests.lua), the Open Sesame Context row in [Report-Runner.lua](Diagnostics/Report-Runner.lua), and that probe's two strings in [Diagnostics-Core.lua](Diagnostics/Diagnostics-Core.lua) are Open Sesame's own. It generates bug-report text, not unit tests: everything is environment probing and state capture, read-only and side-effect free except the explicit Taint Log buttons, which set the `taintLog` CVar. Reports build only on a button press, never on load or on panel open.

**The enable gate is runtime-only.** `ns.diagnostics` is a plain namespace table initialized at file scope and never persisted, so the panel starts off at every login. Off means off: the dispatcher's logging branch is a single boolean read before any allocation, and disabling the panel stops the event log, stops any run, and clears every report. The four tabs are left out of the options table while the gate is off, and the panel is registered as its builder (`ns.BuildDiagnosticsOptions`) so every repaint rebuilds it.

**Four tabs.** **Run Tests** holds the live tools: the Event Log (Start, Stop, which keeps what was captured, and Show), the Taint Log, and the In-Game Tools and External Tools boxes (`/etrace`, `/console scriptErrors 1`, Bug Grabber and Bug Sack). **Settings** runs Open Sesame Context, Saved Variables, Display Context and Other Add-ons; **Code** runs Event Registration (over `ns.EVENT_NAMES`), API Endpoints and Library Versions; **Data** runs one Validate Data report per `ns.DIAGNOSTIC_DATA_SOURCES` entry. Each report tab has a Run All, one row per report with its last state, and one output box showing whatever ran last on that tab. Every report opens with the same client header, which carries the flavor (`ns.FLAVOR`, marked when Season of Discovery is active) and the data folder (`ns.DATA_FOLDER`), never `WOW_PROJECT_ID`.

**Firehose traffic is counted, not dropped.** `UI_ERROR_MESSAGE` is the one firehose Open Sesame registers, and it is only *sometimes* noise, because the inventory-full firing is exactly what the log needs. `ns.MESSAGE_ID_FILTERED_EVENTS` in [Event-Log.lua](Diagnostics/Event-Log.lua) names it, and `ns:SuppressUncorrelatedMessage` classifies each firing through `ns.IsBagFullErrorID`, the same call the live handler uses, so the filter cannot drift from it. Everything else folds into a per-ID counter rendered as one block at the end of the report.

**Open Sesame Context** is the add-on's own probe, for "nothing happens" reports: class and level; each spell in `ns.SPELLS` with its client name and `IsPlayerSpell`; the Lockpicking rank exactly as `ns.GetPlayerLockpickingSkill` reads it (always unavailable on Forever); the live returns of `C_PartyInfo.GetLootMethod` with the verdict Speedy Loot's master-looter stand-down draws from them, and `GetLootThreshold`; `autoLootDefault`, the runtime flags and the free bag slots; and a Locked Boxes table of every bag slot holding an `ns.ALLOWED_ITEMS` ID, with its link, value, ignored state, the `ns.IsItemLocked` verdict and the scan tooltip's line count. That count is the point: a box reading "not locked" with zero tooltip lines means the scan tooltip read nothing.

**Validate Data** has one manifest entry per flavor-folder file (Openable-Items, Lockbox-Skill-Levels, Default-Ignore-Items, Spells, Game-IDs), so one manifest serves every flavor. Each report is tab-separated text for a spreadsheet: a status column (`OK`, `NOT ON CLIENT`, `INCOMPLETE`, `ERROR`, `TABLE MISSING`), every reader the client ships for the ID, the file's own values in `DATA_*` columns, and the whole tooltip in one cell. A `NOT ON CLIENT` row is a row in the wrong folder. Its tooltip text comes from `ns.GetTooltipLines` and its stat table from `ns.GetItemStats`, both in [Utilities.lua](Features/Utilities.lua).

**Saved Variables** prints every row of `OpenSesameDB`, the Ignore List included, since those rows explain an Ignore List bug report.

Diagnostics strings live in `ns.DiagnosticsStrings` as plain English and are intentionally **not** localized, because they are developer-facing. The one localized string the panel reads is `ns.L["ADDON_TITLE"]`.

## Data Tables

Each flavor folder declares the same five tables whole, each sitting beside the others it must agree with. Feature code reads them without checking which flavor built them.

**The tables must agree, per folder:**

- **Every `ns.DEFAULT_IGNORE_ITEMS` row is also a `true` row of `ns.ALLOWED_ITEMS`.** `ShouldOpen` requires the item to be openable *and* not ignored. A row on the Ignore List but missing from `ns.ALLOWED_ITEMS` is a trap: the player removes it from the list expecting it to start opening, nothing happens, and there is nothing on screen to explain why.
- **Every `ns.LOCKBOX_SKILL_LEVELS` row is a `false` row of `ns.ALLOWED_ITEMS`.** The tooltip block reads only the skill table, so a row for an item Auto-Opening does not treat as locked would describe a lock nothing waits on.

Both rules hold per folder, since each folder is one client's whole truth.

`ns.ITEM_IDS.ICON_PROBE` exists only for Diagnostics, which asks `C_Item.GetItemInfoInstant` for its icon to prove the fifth return on each client.

## Saved Variables

The single SavedVariables table is **`OpenSesameDB`**, declared identically in every flavor TOC and managed by AceDB-3.0. It holds every setting and the player's Ignore List. `ns.SAVED_VARIABLES_NAME` in [Data.lua](Data/Data.lua) carries the name for Diagnostics.

Open Sesame uses the **Simple** model: one shared `"Default"` profile for every character, with `true` as `AceDB:New`'s third argument. **Reset Profile therefore clears every setting back to install defaults, the mini-map button's position and visibility included; the Ignore List, in `ns.db.global`, survives.** A new setting belongs in `profile`.

- **`profile`** carries every user setting: each feature's toggle, scope, threshold and hold-off rules, the notification toggles, `showWelcome`, and `minimap`, the LibDBIcon position and `hide` subtable.
- **`global`** carries only reset-proof state, which under Simple means presentation or data the player built. Today that is `ignoreList` alone, a hand-built list that a profile switch, copy, reset, or delete must not take from the player. Anything else placed here would escape Reset Profile.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed, and explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*`/`**` wildcard defaults resolve through metatables.

The one default list is the Ignore List, and it follows the house default-list rule: `ns:SeedIgnoreList` rebuilds it from `ns.DEFAULT_IGNORE_ITEMS` only when the saved list is missing or empty, with no saved flag, and Restore Defaults rebuilds it on demand. Shipping new default entries therefore does not change an existing player's list, so note additions in the release notes.

**Profile switches, resets, and copies apply live.** All three AceDB callbacks are wired to `ApplyProfile` right after `AceDB:New`. It pushes the profile onto the runtime flags, re-runs `ns.EnsureAutoLoot` when either feature needs it, forces a scan, refreshes the mini-map icon, and calls `NotifyChange` for every registered panel so open options redraw. It is deliberately not called on initial login: `PLAYER_LOGIN` and `PLAYER_ENTERING_WORLD` own first-time setup and its ordering.

**Migrations.** There is no migration chain. Two tagged blocks in `PLAYER_LOGIN`, both `MIGRATION (remove after 2026-11-04)`, clear retired keys outright rather than converting them:

- `ns.db.global.minimap`, left from before the subtable moved to the profile.
- Every `lootToast*` key in every stored profile (`ns.db.profiles`), not just the active one, and `ns.db.global.lootToastPosition`, because Loot Toasts was removed.

## Adding a New Openable Item

1. Decide its value: `true` for an item safe to open on sight, `false` for a lockbox or locked chest that must be unlocked first.
2. Add `[itemId] = value, -- Item Name` to `ns.ALLOWED_ITEMS` in `Data/{Game}/Openable-Items-{Game}.lua` in every folder whose client has the item. A row true on three flavors is written in three files.
3. For a `false` entry, add its required skill to `ns.LOCKBOX_SKILL_LEVELS` in the same folders' `Lockbox-Skill-Levels-{Game}.lua`, or leave it out deliberately rather than guessing. Never add a stand-in value; the tooltip formats a number.
4. Run Validate Data on every client afterwards. A `NOT ON CLIENT` row is a row in the wrong folder.
5. Nothing else to wire. `BuildQueue`, `ns.GetLockedBoxes`, and the looted-container notice all read the table directly.

## Adding a Default Ignored Item

1. Add `[itemId] = "REASON", -- Item Name (the loot)` to `ns.DEFAULT_IGNORE_ITEMS` in `Data/{Game}/Default-Ignore-Items-{Game}.lua` in every folder whose client has the item. Placement is functional: seeding writes every row the client loaded, so a row in the wrong folder seeds an ID the client cannot resolve.
2. The reason is one of `RAID`, `QUEST`, `RECIPE`, `GEAR`, `HOLIDAY`, or `ITEM`, each mapping to an `OPTIONS_IGNORE_REASON_*` key in `REASON_TEXT` in [Ignore-List.lua](Features/Ignore-List.lua). An unknown key silently shows the `ITEM` text, so a seventh reason needs its key in `enUS.lua` and its mapping there.
3. Confirm the ID is in that folder's `ns.ALLOWED_ITEMS` as `true`, per [Data Tables](#data-tables).
4. The table is only a **seed**. Existing players keep the list they have, and the new entry reaches them through Restore Defaults or a fresh install, so note it in the release notes.

## Adding a New Registered Event

1. In [Features/Core.lua](Features/Core.lua), add a handler: either `function EventHandlers:EVENT_NAME(...)` or an alias onto an existing helper (`EventHandlers.EVENT_NAME = OnScanRequest`). Keep it thin and call into the feature file that owns the behaviour.
2. That is the only registration step. The registration loop, the `C_EventUtils.IsEventValid` guard, and `ns.EVENT_NAMES` are all derived from the `EventHandlers` table, so the dispatcher and the diagnostics probe pick the new event up together.
3. If the event is a firehose that is only sometimes signal, add it to `ns.MESSAGE_ID_FILTERED_EVENTS` with the argument position its message ID arrives in, and extend `ns:SuppressUncorrelatedMessage` to allowlist the IDs the add-on actually correlates. Never hand-maintain a denylist of noise IDs.

## Localization

Strings are localized through AceLocale-3.0. Each locale file registers with `NewLocale("Open-Sesame", "<locale>")`, and [Data.lua](Data/Data.lua) resolves `ns.L` once with `GetLocale(ADDON_NAME)` for every other file to read; the installed folder name and the locale literal are the same string. Every supported locale file already exists, so this is maintenance, not expansion.

- **`enUS.lua` is the source of truth.** [Locales/enUS.lua](Locales/enUS.lua) is the only file that passes the `true` default-fallback flag. Every key originates there, and the other ten locales translate the same key set. The Localization pass (`3 - Copy Cleanup & Localization Prompt.md`) owns those ten files; never hand-edit them during ordinary work. A retired key name is never reused, because a stale translation left under it would silently win over the enUS fallback.
- **Placeholders.** `%s` and `%d` count, type, and order must match `enUS` per key in every locale, or `string.format` errors at runtime. The keys carrying format arguments are `CHAT_LOADED` (`%s`), `PAUSED_BAG_SLOTS` (`%d`), `AUTO_OPENING_DESCRIPTION` (`%d`), `ITEM_WILL_AUTO_OPEN` (`%s`), `ITEM_IGNORED` (`%s`), `ITEM_OPEN_MANUALLY` (`%s`), `OPTIONS_ITEM_LOADING` (`%d`), and `OPTIONS_VERSION` (`%s`).
- **Game names never go in `Locales/`.** The client names every game record:
  - The Lockpicking skill line is stored as `ns.SKILL_LINE_IDS.LOCKPICKING` and named by `C_TradeSkillUI.GetTradeSkillDisplayName`.
  - `ns.SPELLS` (Pick Lock, Pick Pocket, Shadowmeld) are compared by spell ID only, against `UNIT_SPELLCAST_SUCCEEDED` and buff data; Diagnostics names them with `C_Spell.GetSpellName`.
  - Item names come from the item's own link, or `C_Item.GetItemInfo` on the Ignore List panel.
  - Quality names are the `ITEM_QUALITYn_DESC` globals, and the bag-full message is the `ERR_INV_FULL` global.
  - `LOCKED`, `ITEM_MIN_SKILL`, `LOOT_ITEM_SELF` and `LOOT_ITEM_PUSHED_SELF` are read from the client to match its own text, never translated.
- **Diagnostics strings are not localized.** `ns.DiagnosticsStrings` is developer-facing English, kept out of `Locales/` entirely.

Everything else (the Spanish file pairing, the overflow canary, the output ceilings) follows Style Guide → LOCALIZATION and MESSAGES → Message Length.

## Common Pitfalls

- **Setting a scan tooltip's owner once at file scope.** `ns.IsItemLocked` hides `OpenSesameScanTooltip` when it is done, because setting a tooltip shows it. Hiding a tooltip drops its owner, and an **unowned tooltip accepts `SetBagItem` without complaint and populates nothing**, so every box reads as unlocked and the mini-map's Locked Items list quietly empties. `SetOwner` therefore runs at the top of every call. If that list goes missing while the boxes are plainly still in the bags, check this first.
- **Matching `LOCKED` as a substring.** It is a short word, and other add-ons write tooltip lines that contain it without meaning it. `TooltipHasLine` compares whole lines.
- **Hiding the loot window on `LOOT_READY`.** A no-op, because the frame is not shown yet, so the default UI shows it afterwards with nothing to re-hide it. That is the flash. Suppress only through the `LootFrame` `OnShow` hook gated by `suppressLootWindow`.
- **Carrying a "fully looted" verdict across corpses.** A throttled `LOOT_READY` can reuse the previous corpse's `suppressLootWindow`. `LOOT_CLOSED` resets it through `ns.ResetSpeedyLootWindow`.
- **Reordering the `LOOT_READY` handler.** `ns.StampWorldLoot` and `ns.PlayPickPocketSound` must read the slots before `ns.HandleSpeedyLoot` empties them; an emptied window reads as item loot that came from nowhere and as a pickpocket that found nothing.
- **Looting while master looter.** Calling `LootSlot` on a threshold item pops `MasterLooterFrame_Show` with no selection, which crashes on a nil `colorInfo` on some clients. `IsPlayerMasterLooter()` stands the whole pass down.
- **Comparing the loot method to `"master"`.** `C_PartyInfo.GetLootMethod` returns an enum **number**. Compare against `LOOT_METHOD_MASTER` (`2`); a string comparison reports "not master looter" forever.
- **Trusting `IsStealthed` alone.** Night Elf Shadowmeld does not always register through it, so `IsPlayerStealthed` also scans buffs for `ns.SPELLS.SHADOWMELD`. Opening a container while stealthed would break stealth.
- **Item-produced loot playing the loot sound.** Disenchant, prospect, mill, container opens, and the white-into-green merge all share the corpse loot path. Only a `"world"` GUID opens `worldLootOpen`; never widen it to `"unknown"`.
- **Adding an offset to the pause threshold.** Pause and resume share `ns.MIN_FREE_SLOTS`, and `PAUSED_BAG_SLOTS` reports it directly. A `+ 1` on either side makes the message promise a count that does not actually resume opening.
- **Confusing the two ignore tables.** `ns.DEFAULT_IGNORE_ITEMS` stores the reason key; the saved list stores `true`. Seeding writes `true`, and the reason is looked up from the defaults table at read time, which is what lets better copy reach saved lists without a migration.
- **Seeding a row this client cannot resolve.** An ID this client does not have never answers `C_Item.GetItemInfo`, so it would sit in the panel as a bare number and keep the cache watcher armed for news that never comes. The folder split keeps such rows off the client; the panel also drops IDs `C_Item.GetItemInfoInstant` cannot resolve and IDs the server refuses, which covers any saved list that already holds one.
- **Registering a built options table where the builder is needed.** `RegisterOptionsTable(name, ns.BuildIgnoreListOptions())` freezes the Ignore List at its login contents. Pass the function.
- **Moving the tooltip hook to file scope, or deferring it.** Installed while `Lockbox-Tooltips.lua` loads, the hook runs before add-ons that load later and the block no longer reads last; deferred with `C_Timer.After(0)`, the tooltip strobes. It is installed from `PLAYER_LOGIN` and adds its lines synchronously.
- **Matching the own-loot prefix anywhere in the line.** In koKR another player's loot line contains the player's own prefix whole, so a plain `find` reads a groupmate's loot as the player's. `StartsWithPrefix` anchors it.
- **Speedy-looting a locked slot.** A slot `GetLootSlotInfo` reports locked is being rolled for or isn't the player's yet; `LootSlot` on it only errors, and counting it against the free slots can strand real loot. Skip it.
- **Hiding the window over a Bind on Pickup item.** The bind question lives only as long as the loot session; the suppression hide closes it. A Bind on Pickup pickup sets `leftBehind`.
- **Stopping the open tick on a tooltip or pop-up.** Nothing fires when either closes, so a tick that returns without re-arming leaves the queue in the bags. They belong in `IsWaitingOnPlayer`, which re-arms.
- **Retrying a refused open every tick.** A container the game won't open (level, holiday) never answers with a loot window. `OpenTick` waits for `LOOT_OPENED` up to `ns.OPEN_ANSWER_TIMEOUT` and sets the item aside after `ns.OPEN_REFUSAL_LIMIT` misses.
- **Re-adding a modern-to-legacy fallback.** The legacy globals in [Client Targets and API Surface](#client-targets-and-api-surface) are gone or unusable on at least one target, so an `or`-chained fallback is dead code that hides a real break. Call the namespaced API directly and add a row to `ns.DIAGNOSTIC_API_CHECKS`. `ns.GetItemStats` is the deliberate exception: Era and TBC ship only the legacy global.

## Contributing

- **Issues.** Open them on the [GitHub Issues tab](https://github.com/Gogo1951/Open-Sesame/issues).
- **Bug reports.** Include game version and locale, class and level, repro steps, and the relevant chat output. Enabling the Diagnostic Tools panel and running the relevant report produces text whose header already carries the add-on version, client, build, TOC, locale, and flavor.
- **Discord.** [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **PR guidelines.** Keep changes tightly scoped. Match the surrounding code style, which is StyLua's default output, and keep `luacheck .` clean. Never hand-merge defaults around AceDB, and never write `db.field = db.field or default`, which overwrites an explicit `false`. Any change to the shape, name, or scope of saved data ships with its own tagged migration for the data players already have. Keep placeholder counts aligned across locales. Update this document in the same change if the architecture, the file map, or the saved-variables shape moves. Open Sesame prints to the player only, sends no chat, and writes no macros, so neither 255-byte ceiling (Style Guide → MESSAGES → Message Length) binds any string here today; adding a sent message brings the chat check into scope for every locale, tested against the widest-encoding one.
- **Commit and PR descriptions require a User Story.** Do not just say "I changed X" or "I fixed Y". Frame the change in terms of who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a rogue trading locked boxes to a guildmate to crack, I wanted the boxes to open on their own once unlocked rather than waiting on a bag event. This change adds a second forced rescan after `TRADE_CLOSED` on the pick-lock settle delay.*
