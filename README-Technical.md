# Open Sesame // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Open Sesame. For end-user documentation, see [README.md](https://github.com/Gogo1951/Open-Sesame/blob/main/README.md).

## File Map

```text
Open-Sesame/
├── .github/
│   └── workflows/
│       └── package.yml            CurseForge release and library vendoring
├── .gitattributes                 Line-ending normalization
├── .gitignore                     Dev-clutter ignore list
├── .luacheckrc                    Lint config
├── .pkgmeta                       Externals and packager ignore list
├── Open-Sesame.toc                Load order, metadata, SavedVariables declaration
├── Data/
│   ├── Data.lua                   Constants, palette, spell and sound ids, options grid, registry names
│   ├── Default-Settings.lua       ns.DATABASE_DEFAULTS plus ns.DEFAULT_IGNORE_ITEMS
│   └── Openable-Items.lua         ns.AllowedItems, the generated openable-container table
├── Features/
│   ├── Core.lua                   Event dispatcher, scan/queue/open pipeline, pause state, profile apply
│   ├── Utilities.lua              C_Container references, color and money helpers, lockbox scope predicates
│   ├── Announcements.lua          PrintMessage, the deduped status channel, the quiet window
│   ├── Ignore-List.lua            Account-wide Ignore List: seed, query, mutate
│   ├── Speedy-Loot.lua            Loot-window suppression and the master-looter stand-down
│   ├── Lockbox-Tooltips.lua       Lockpicking requirement line on locked containers
│   ├── Loot-Toasts.lua            On-screen readout of what was just looted
│   ├── Diagnostics.lua            Read-only bug-report probes and the event log
│   └── Minimap-Button.lua         LibDataBroker launcher, tooltip, click handlers
├── Includes/
│   ├── Images/
│   │   └── Open-Sesame.tga        Add-on icon
│   ├── Libraries/                 Vendored third-party code, never hand-edited
│   └── Sounds/
│       └── item-pick-up.ogg       The rare-loot chime
├── Locales/
│   ├── enUS.lua                   Source of truth, the only file passing the true fallback flag
│   └── (ten more locale files)    deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW
├── Options/
│   ├── Options-Utilities.lua      Shared widget helpers, sub-rows, item-link widget, item-list builder
│   ├── Options-General.lua        Root panel
│   ├── Options-Notifications.lua  Loot Sound, Pick Pocket sound, Loot Toasts
│   ├── Options-Lockboxes.lua      Lockbox tooltips and lockbox notifications
│   ├── Options-Ignore-List.lua    Ignore List panel: copy and callbacks only
│   ├── Options-Profiles.lua       Stock AceDBOptions-3.0 table, returned unmodified
│   ├── Options-Diagnostics.lua    The gated Diagnostic Tools panel
│   └── Options.lua                Panel registration, the options opener, /os
├── LICENSE                        MIT
├── README.md                      Player-facing documentation
└── README-Technical.md            This file
```

No deprecated or dead files are present, and every `Data/`, `Features/`, `Options/`, and `Locales/` file is listed in the TOC load order. `Includes/Libraries/` vendors LibStub, CallbackHandler-1.0, the Ace3 stack (AceLocale, AceDB, AceGUI, AceConfig, AceDBOptions), LibDataBroker-1.1 and LibDBIcon-1.0 for the mini-map button, and LibSharedMedia-3.0 for the Loot Toasts font picker.

## Architecture

### Event Loop

A single hidden frame in [Core.lua](Features/Core.lua) owns every event. Its `OnEvent` script logs the firing when diagnostics logging is active, then dispatches to a handler keyed by event name in the `EventHandlers` table. Handlers are plain functions, or aliases onto a shared helper (`EventHandlers.BAG_UPDATE_DELAYED = OnScanRequest`). Nothing else in the add-on registers an event.

Registration is driven from the `EventHandlers` table itself, so the frame can never listen for an event that has no handler, or hold a handler nothing routes to:

- `ns.EVENT_NAMES` is built by iterating `EventHandlers`, sorted, and exported so [Diagnostics.lua](Features/Diagnostics.lua) probes the exact set the add-on uses.
- Registration walks the same keys and skips any name `C_EventUtils.IsEventValid` rejects, so an event absent on a future client build is skipped rather than aborting the loop. Every name in the table is valid on both target clients today.
- `UNIT_SPELLCAST_SUCCEEDED` is the one special case: it registers through `RegisterUnitEvent(event, "player")` so the frame does not wake on every group member's cast. The handler keeps its own `unit == "player"` guard as well.

Most bag and loot events funnel into `OnScanRequest`, which calls the debounced `ScheduleScan()`. The interaction-close events (`MERCHANT_CLOSED`, `MAIL_CLOSED`, `BANKFRAME_CLOSED`, `GOSSIP_CLOSED`, `QUEST_FINISHED`, `PLAYER_INTERACTION_MANAGER_FRAME_HIDE`) share `OnInteractionClosed`, which forces an immediate rescan and flushes any held status message. `TRADE_CLOSED` runs that same helper plus a second delayed scan, for the reason given under [Auto-Opening Queue](#auto-opening-queue).

### Combat and Safety Gating

**Open Sesame never casts anything and owns no secure frames.** It writes no macros and creates no protected buttons, so there is no dirty-flag replay pattern and no taint surface to reason about: the add-on opens containers and reports what it finds.

Two things behave differently in combat.

**The options opener refuses outright.** `ns:OpenOptionsPanel` in [Options.lua](Options/Options.lua) checks `InCombatLockdown()` first, prints `CHAT_OPTIONS_IN_COMBAT`, and returns. It never queues, retries, or waits for `PLAYER_REGEN_ENABLED`. The gate sits in the opener and nowhere else, so the `/os` handler and the mini-map button's Shift + Middle-Click share one copy of it. Blizzard's Settings panel is protected in combat, and without the gate the player gets an `ADDON_ACTION_BLOCKED` error naming the add-on.

**Opening defers instead.** Everything that opens a container funnels through `IsSafeToOpen()`, which refuses while any of these hold: the add-on is disabled or paused, the player is in combat (`UnitAffectingCombat`), a merchant, mail, trade, bank, guild bank, auction, gossip, quest, or static-popup frame is open (`IsInteractionActive`), the player is stealthed (`IsStealthed` or carrying the Shadowmeld aura, see [Common Pitfalls](#common-pitfalls)), a cast or channel is in progress, a genuine item tooltip is showing, or free bag slots are below `ns.MIN_FREE_SLOTS`. There is no queue replay: the open tick simply stops firing, and `PLAYER_REGEN_ENABLED` forces a fresh scan the moment combat ends. `UPDATE_STEALTH` does the same when the player leaves stealth.

### Where and Group Hold-Offs

`IsSafeToOpen` also honours two player-set hold-offs, both defaulting to the original always-open behaviour:

- **`autoOpenWhere`**, `"ALWAYS"` (shown as *Anywhere*) or `"OUTSIDE_INSTANCES"`; the latter refuses while `IsInInstance()` is true.
- **`autoOpenGroup`**, `"ALWAYS"` (shown as *Solo or Grouped*) or `"SOLO_ONLY"`; the latter refuses while `IsInGroup()` is true, party or raid.

Both stored values are `ALWAYS` while the visible copy differs, on purpose: each dropdown's options have to answer its own label, so *Where* offers places and *Group* offers group states. One shared "Always" string read as though the two rows were duplicates of each other, and neither value answered the question its label asked.

The point is bag space: a player running dungeons wants slots free for drops, with the boxes opened later on their own time. Because both are read inside `IsSafeToOpen` rather than applied imperatively, nothing has to be re-applied on a profile switch. Two rescan paths cover leaving either state: `GROUP_ROSTER_UPDATE` (aliased to `OnScanRequest`) covers joining and leaving a group, and the non-initial branch of `PLAYER_ENTERING_WORLD` fires a debounced `ScheduleScan()` so zoning out of an instance resumes opening without waiting on a bag event.

### Scan → Queue → Open

The pipeline lives entirely in [Core.lua](Features/Core.lua) and runs in three phases:

1. **Scan.** `ScheduleScan(force)` absorbs bag churn. Unforced calls coalesce inside `ns.SCAN_DEBOUNCE` (0.5s) behind a pending flag and a timestamp, so only the newest request survives. Forced calls (profile apply, combat end, pick-lock settle, interaction close, ignore-list edit) run immediately. Each run recomputes free slots, updates the pause state, announces a change of state, and, when enabled, rebuilds the queue. `RunScan` and its debounce callback are file-locals rather than closures built inside `ScheduleScan`, because every bag or loot event would otherwise allocate two throwaway functions before deciding whether a scan is needed at all.
2. **Queue.** `BuildQueue()` walks bags 0 to 4, resolves each slot's item id through `SafeFastItemID`, and pushes it when `ns.AllowedItems[id]` is `true` (open now) or `false` and the tooltip does not report the item as `LOCKED`. Ignored ids never enter the queue. The queue is a flat array of `(bag, slot, itemId)` triples with head and tail cursors, wiped and reset when drained.
3. **Open.** `OpenTick()` fires every `ns.OPEN_TICK_INTERVAL` (0.25s). It re-verifies safety, pops one triple, confirms the slot still holds the cached id, calls `UseContainerItem`, then schedules a recheck after `ns.OPEN_RECHECK_DELAY` that requeues the slot if the same item is still sitting there. A single `openTimerLive` flag prevents overlapping tick chains. A cast or channel in progress reschedules the tick rather than dropping it, so the chain survives a mid-queue cast.

### Item Identity Caching

Open Sesame keys everything off numeric item ids, never off `GetItemInfo`. `SafeFastItemID(bag, slot)` tries `ns.GetContainerItemID` first, which answers synchronously from the client's own database with no cold-cache nil, and only falls back to parsing the id out of `ns.GetContainerItemLink`. Because the id comes straight from the container API, the opening pipeline has no asynchronous cold call to guard and no per-item cache to invalidate.

`GetItemInfo` cold-call nils do appear in two places, and both are handled where they arise rather than through a shared cache:

- **The Ignore List panel** draws item links, so a row whose item the client has not cached yet registers through `ns.WatchUncachedItem`. See [Panel and the Shared Item-List Builder](#panel-and-the-shared-item-list-builder).
- **Loot Toasts' Bind on Pickup bypass** reads `bindType` from the full `GetItemInfo`. A nil reads as "not Bind on Pickup" and leaves the quality threshold to decide, which is acceptable because the item was just looted, the one moment the client is certain to have it cached.

`ns.AllowedItems` in [Openable-Items.lua](Data/Openable-Items.lua) is a compile-time constant, not a runtime cache. The container API references themselves are cached once in [Utilities.lua](Features/Utilities.lua) as plain unguarded upvalues.

### Client Targets and API Surface

Open Sesame targets **Classic Era (1.15.x)** and **TBC Anniversary (2.5.x)**. On the API surface this add-on touches, the two flavors are in sync: both ship the namespaced APIs and both have already removed the identically-named legacy globals. The Diagnostics panel's **API Endpoints** report is what proves that on a given client.

**There are no compatibility shims.** Every API below is called directly, unguarded, with one exception noted in the last row:

| Used | Removed from both clients, do not call |
| --- | --- |
| `C_AddOns.GetAddOnMetadata` / `.GetAddOnInfo` / `.GetNumAddOns` | `GetAddOnMetadata`, `GetAddOnInfo`, `GetNumAddOns` |
| `C_Container.GetContainerNumSlots` / `.GetContainerNumFreeSlots` / `.GetContainerItemID` / `.GetContainerItemLink` / `.UseContainerItem` | `GetContainerNumSlots`, `GetContainerNumFreeSlots`, `GetContainerItemID`, `GetContainerItemLink`, `UseContainerItem` |
| `C_PartyInfo.GetLootMethod`, which returns an enum **number** | `GetLootMethod`, which returned a string |
| `C_UnitAuras.GetBuffDataByIndex` | `UnitBuff`, still present, but its `spellId` return position differs between Era and TBC |
| `C_CVar.GetCVar` / `.GetCVarBool` / `.SetCVar` | `GetCVar` / `SetCVar`, still present but unused, so CVar access has one shape |
| `C_EventUtils.IsEventValid`, `C_Timer.After` | |
| `LE_GAME_ERR_INV_FULL` | `Enum.UIERRORS.ERR_INV_FULL`, absent on both clients |
| `Settings.OpenToCategory`, the one availability guard the add-on keeps | |

Two values are written out as literals rather than read from an `Enum` table, because `Enum.LootMethod` is not guaranteed on these builds: `LOOT_METHOD_MASTER = 2` in [Speedy-Loot.lua](Features/Speedy-Loot.lua) and its twin in [Diagnostics.lua](Features/Diagnostics.lua), where the Loot Method report prints the live returns that verify the mapping.

Every API in the left column has a row in `ns.DIAGNOSTIC_API_CHECKS`. Because nothing is guarded, a `[FAIL]` row is a real break on that client rather than a note that a fallback took over. **Before adding a flavor guard or a legacy fallback, run the API Endpoints report on both clients and let it prove the difference.**

## Auto-Opening Queue

The queue handles two kinds of item differently, encoded by the value in `ns.AllowedItems`:

- `true`, safe to open on sight (clams, coin pouches, gift boxes). Queued whenever present.
- `false`, a lockbox or locked chest. Queued **only once the client reports it unlocked**, detected by scanning the item's tooltip lines for the global `LOCKED` string (`ns.IsItemLocked`). Until then it sits in the bag.

`LOCKED` is matched against the whole tooltip line, never as a substring: it is a short word, and other add-ons write lines that contain it without meaning it.

When Auto Loot delivers a still-locked box, the `false` entry is skipped, so it waits. Two events re-trigger a scan so a freshly unlocked box opens without waiting for the next bag update:

- `UNIT_SPELLCAST_SUCCEEDED` for the player's own **Pick Lock** (spell 1804), which rescans after `ns.PICK_LOCK_RESCAN_DELAY` (0.5s of settle).
- `TRADE_CLOSED`, which runs the shared immediate rescan **and** a second forced scan after that same settle delay. Another rogue picking locks on boxes in the trade window fires no event on our side, and the unlocked state often has not settled client-side by the time `TRADE_CLOSED` arrives, so an immediate scan alone still reads the boxes as locked.

`ITEM_WILL_AUTO_OPEN` prints when a `false` item is looted, so the player knows it is queued rather than ignored. It is gated by `ns.LockboxNotificationsEnabled()` **and** by `autoOpen`, since the message promises automatic opening: with Auto-Opening off there is nothing to promise, so the notice stays quiet even though its own toggle lives under **Lockboxes**. The sibling `ITEM_OPEN_MANUALLY` notice in Speedy Loot carries the same pairing.

## Ignore List

[Ignore-List.lua](Features/Ignore-List.lua) owns the player's list of containers Open Sesame leaves alone entirely: Speedy Loot leaves them in the loot window with an `ITEM_OPEN_MANUALLY` notice, and Auto-Opening never queues them even when `ns.AllowedItems` allows the item. Every consumer asks the same question, `ns:IsIgnored(itemId)`: `BuildQueue`, the `OpenTick` recheck, `ns.GetLockedBoxes`, the `ITEM_WILL_AUTO_OPEN` notice in `CHAT_MSG_LOOT`, and Speedy Loot's per-slot skip.

**The list is account-wide**, in `ns.db.global.ignoreList`. Which containers a player hoards is a decision about the items, not about the character, so it must not move or reset with a profile.

**Two tables, two shapes, and they are not interchangeable.** `ns.DEFAULT_IGNORE_ITEMS` in [Default-Settings.lua](Data/Default-Settings.lua) is the shipped seed and stores `{ expansionThatAddedIt, reasonKey }` per id. The saved list stores `true` per id and nothing else. `SeedFrom` writes `true`, never the entry.

That split is deliberate. The reason is looked up from `ns.DEFAULT_IGNORE_ITEMS` at read time rather than copied in at seed time, so a list saved before the notes existed still shows them and better copy reaches every player without a migration. The reason itself resolves to one of six locale keys (`RAID`, `QUEST`, `RECIPE`, `GEAR`, `HOLIDAY`, `ITEM`) rather than carrying its own sentence, because free text per row would be one string per row for every locale to translate, sitting outside `Locales/` entirely. Item names stay out of those strings: the client already draws its own localized tooltip directly above the line, so naming the loot again would ship English item names into every locale. `ns:GetIgnoreNote` prefixes the reason with `ns.ICON_IGNORED`, the client's own red pass icon, so the row reads as refused at a glance, and returns nil for anything the player added.

**Seeding follows the house default-list rule.** `ns:SeedIgnoreList` runs from `PLAYER_LOGIN` right after `AceDB:New` and rebuilds only when the saved list is missing or empty. Note what that means at the edge: an empty list is indistinguishable from a fresh install, so a player who removes *every* row keeps it empty for the rest of the session and finds it reseeded at their next login. Removing rows individually is what sticks, which is the case the rule exists for.

**Seeding and Restore Defaults both filter by expansion.** Only rows whose tag is at or below `ns.currentExpansion` are written. An id from a later expansion never answers `GetItemInfo` on this client, so it would sit in the panel as a bare number forever and keep the refresh watcher armed waiting for news that never comes.

Every mutation (`ns:AddIgnoredItem`, `ns:RemoveIgnoredItem`, `ns:RestoreDefaultIgnoreList`) forces a rescan and ends in `AceConfigRegistry:NotifyChange` on the Ignore List registry so the panel redraws.

### Panel and the Shared Item-List Builder

The panel itself ([Options-Ignore-List.lua](Options/Options-Ignore-List.lua)) supplies only copy, the source table, and callbacks. The shape comes from `ns:BuildItemListOptions` in [Options-Utilities.lua](Options/Options-Utilities.lua): Restore Defaults (confirmed), an add box that parses a dragged item, a pasted link, or a bare id and clears itself, then one inline group per item sorted **by item name**, each row an item-link cell plus an icon-only remove button whose widths total `ns.OPTIONS_ROW_WIDTH`. The panel starts its list at `startOrder = 10`, leaving orders 1 to 9 for its own description and the Ignore List notifications toggle.

Four mechanics are worth knowing before editing it:

- **It registers the builder, not a built table.** `AceConfigRegistry:RegisterOptionsTable` accepts a function and calls it afresh on every fetch, which is what lets `NotifyChange` draw rows that did not exist at login. Registering `ns.BuildIgnoreListOptions()` instead of `ns.BuildIgnoreListOptions` would freeze the list at its login contents.
- **Uncached items resolve through Core's dispatcher.** `GetItemInfo` returns nil until the client has the item, so a row with no answer yet registers through `ns.WatchUncachedItem`, which sets `ns.OnItemInfoReceived`. Core's `GET_ITEM_INFO_RECEIVED` handler calls it, the list redraws as answers arrive, and the callback clears once nothing is outstanding so the dispatcher stops doing work. Uncached rows sort under their raw id until then, and no bare id is left standing.
- **Unresolvable ids are dropped before a row is built.** A saved list can hold ids from a later expansion, so each row is tested with `GetItemInfoInstant` first. That answers synchronously from the client's own database, which is what separates "not cached yet" from "does not exist here" without waiting on an event that will never fire.
- **The row's note is drawn by the widget, not by AceConfig.** `noteFor(itemId)` is carried as the option's `desc`; AceConfigDialog's `InjectInfo` hangs the option table off the widget's user data, and the item-link widget reads `option.desc` in its own `OnEnter` and appends it under the item tooltip. That last step is required rather than incidental: the widget replaces AceConfigDialog's `OnEnter` so it can show the game's item tooltip, which means a `desc` would otherwise never be drawn at all.

## Speedy Loot

[Speedy-Loot.lua](Features/Speedy-Loot.lua) loots corpses instantly and hides the loot window. `ns.HandleSpeedyLoot` is invoked from Core's `LOOT_READY` handler rather than from a frame of its own, so a single registration owns the event and the ordering below is explicit rather than left to dispatch order.

**Window suppression runs through `OnShow`.** A plain `LootFrame:Hide()` on `LOOT_READY` is a no-op: the frame is not shown yet, the default UI shows it on `LOOT_OPENED`, and nothing re-hides it, which is the roughly half-second flash. Instead a one-time `HookScript("OnShow", ...)` re-hides the frame the instant the default UI shows it, but only while `suppressLootWindow` is set. That flag is `not leftBehind`, true only when the pass took *everything*. Anything left behind, a lockbox the player opens by hand or items skipped because bags filled mid-loop, keeps the window visible through an explicit `LootFrame:Show()`.

**`suppressLootWindow` resets on `LOOT_CLOSED`.** Because `LOOT_READY` can be throttled, one corpse's "fully looted" verdict must not carry onto the next corpse's unlooted window. Core's `LOOT_CLOSED` handler calls `ns.ResetSpeedyLootWindow()`.

**Master looter stands the whole pass down.** Master loot is a managed flow: at or above threshold, items are assigned through the ML window, and below it the group method hands them out, so there is nothing for Speedy Loot to take. Calling `LootSlot` on a threshold item also pops `MasterLooterFrame_Show` with no selection, which crashes on a nil `colorInfo` on some clients. `IsPlayerMasterLooter()` reads `C_PartyInfo.GetLootMethod()` and tests `method == LOOT_METHOD_MASTER (2) and masterLooterPartyID == 0`.

**Bag-full safety.** Money and currency slots (`IsItemLootSlot` false) take no bag space and are always looted. Real item slots are only taken while `freeSlots > 0`; if general bags are full and real items are waiting, the pass loots nothing and leaves the window open so items can be taken by hand. Only general-purpose bag space counts, by design: profession bags and quivers are ignored. Items on the Ignore List are left in the window with an `ITEM_OPEN_MANUALLY` notice, throttled to once per `ns.ITEM_ANNOUNCE_COOLDOWN` (5s) per item.

**Auto Loot is respected, not overridden.** The pass runs only when `autoLootDefault` and `IsModifiedClick("AUTOLOOTTOGGLE")` disagree, which is the same rule the default UI applies: holding the auto-loot modifier inverts the setting. Repeat firings inside `ns.LOOT_DELAY` (0.25s) are dropped.

## Lockboxes

Two features share the **Lockboxes** options section, and both work the same way: a toggle (default on) plus a **Show for** scope of `"ROGUES"` or `"ALL"`, defaulting to Rogues only. A non-Rogue cannot pick a lock, so neither feature has much to say to them out of the box.

Because three files ask that question, Core and Speedy-Loot for the notifications and Lockbox-Tooltips for the tooltip line, the predicates live in [Utilities.lua](Features/Utilities.lua) rather than in either feature: `ns.IsPlayerRogue`, `ns.LockboxTooltipsEnabled`, `ns.LockboxNotificationsEnabled`. A feature is on when its toggle is on **and** its scope either covers everyone or the player is a Rogue.

### Lockbox Tooltips

[Lockbox-Tooltips.lua](Features/Lockbox-Tooltips.lua) answers the question a locked box in the bag raises on its own: what skill does this need, and can I open it yet. It adds its own block, set off from the client's lines by a blank separator: the add-on's name, then `TOOLTIP_REQUIRES_LOCKPICKING_LABEL` or `TOOLTIP_YOUR_LOCKPICKING_LABEL` as an `AddDoubleLine` whose right column carries the number. Both labels are bare text, with the number passed as a separate argument rather than as a `%d` in the string. On a Rogue the row is green when their skill clears the box and red when it does not; a non-Rogue seeing it under the `"ALL"` scope gets neutral body colour. Read-only throughout: nothing casts, sends chat, or writes state.

**The data.** `ns.LOCKBOX_SKILL_LEVELS` in [Data.lua](Data/Data.lua) maps item id to required skill, covering the `ns.AllowedItems` entries whose value is `false` minus four that have no number to give: **Thieven' Kit** (7868) is flagged Locked but publishes no skill number, **Floral Foundations** (39014) requires Inscription rather than Lockpicking, and **Dark Iron Lockbox** (208838) and **Scarlet Junkbox** (239248) are Season of Discovery rows that reach `ns.AllowedItems` through the name-guess merge rule rather than from a source carrying a skill number. A missing row means no tooltip line for that box, which is the deliberate trade: none of the four gets a line rather than being given a guessed one. The table's values are numbers and the tooltip formats them with `%d`, so a placeholder string here would error on hover.

**Reading the player's skill.** `ns.GetPlayerLockpickingSkill` scans `GetNumSkillLines` and `GetSkillLineInfo` for the line whose name matches the localized name of the Lockpicking skill, because the skill lines are the only place the player's *current* rank lives. It returns nil for a non-Rogue, an untrained Rogue, or a client whose spell database did not answer, and every caller treats nil as unknown and falls back to neutral colouring instead of erroring.

That localized name comes from **spell 1809**, the skill spell behind skill line 633. Its name *is* the skill line's name in whatever language the client is running, so one `GetSpellInfo` lookup answers in every locale, from the client's static database, before the player has trained anything. `ns.SPELLS.LOCKPICKING` carries the id and `ns.DIAGNOSTIC_API_CHECKS` probes the lookup, so a client that stopped answering shows as a FAIL row rather than as a silently neutral tooltip. `ns.GetSpellName` in [Utilities.lua](Features/Utilities.lua) reads both documented `GetSpellInfo` shapes, the classic multiple returns and the newer single info table, rather than betting on one.

Two earlier sources are **deliberately not used**, and neither should come back:

- The `LOCKPICKING` **global string**. Neither target client publishes it, and it FAILs in the API Endpoints report.
- The client's own **"Requires Lockpicking (N)" tooltip line**, read through an `ITEM_MIN_SKILL` pattern. That was circular: Era never prints that line on a lockbox, so the name was never learned, the rank was always nil, and the requirement line stayed neutral white instead of green or red. The client's words cannot be the source for a name that is needed before the client has said anything.

**Two duplicates, two different guards.** A tooltip can be re-processed without being cleared, so `TooltipHasText` looks for the branded header and bails, one check covering every line the block adds. Separately, some builds print their own requirement line, and repeating it would be noise, so `ClientStatesRequirement` matches the `ITEM_MIN_SKILL` format and switches the block to `TOOLTIP_YOUR_LOCKPICKING_LABEL` instead. That match is on the format string rather than on the skill's name on purpose: other add-ons print lines that name Lockpicking without stating a requirement, ATT's "World Drop > Lockpicking" breadcrumb among them, and a name match would read those as the client's line.

**Which hook, and when it is installed.** `hooksecurefunc(GameTooltip, "SetBagItem", ...)`, unguarded: a widget method present on every client, firing for the bag and bank slots this feature is about. `TooltipDataProcessor.AddTooltipPostCall` would be the modern choice and is the wrong one here, because it does not exist on either target client and it hands over an item id with no bag or slot, so the still-locked check could not run on that path at all.

The hook is installed from `PLAYER_LOGIN` rather than at file scope, and that placement is the whole ordering strategy. Post-hooks on `SetBagItem` run in the order they were registered, so registering after every other add-on has loaded puts our block last for free. A `SetBagItem` post-hook is also about as late as a synchronous add can be: the client's lines are set, `OnTooltipSetItem` has fired, and every add-on watching that script has had its say.

**Deferring the add to the next frame is rejected outright.** `C_Timer.After(0)` does put the block under everything, and it strobes badly: a hovered bag button re-runs `SetBagItem` every frame, so the tooltip is rebuilt without the block, gets it a frame later, loses it on the next rebuild, and flickers for as long as the cursor rests on the item. A row out of place beats a tooltip that strobes. Do not reintroduce it, in any form that adds lines outside the build itself.

### Why There Is No Click-to-Pick-Lock Gesture

**Do not build this again without new evidence.** Twice the add-on carried a Shift + Right-Click gesture (originally Alt + Click) that put a `SecureActionButtonTemplate` over the hovered bag button with `macrotext` of `/cast Pick Lock` plus `/use <bag> <slot>`. Both times it came out again, because the click never reached the button.

What was ruled out along the way, so nobody re-runs these experiments:

- **The macro is correct.** Pasted into a real macro, `/cast Pick Lock` then `/use 0 5` picks the lock.
- **Bag replacement add-ons are not the cause.** It failed with every bag add-on disabled, on the default bags.
- **Frame stacking was addressed.** `HIGH` loses to the bags, which set their own frame levels; `TOOLTIP` clears them outright. It still did not fire.
- **Tooltip ownership was addressed.** Reading `GameTooltip:GetOwner()` is unreliable when another add-on re-owns the shared tooltip; `GetMouseFoci` answers what the pointer is actually inside. It still did not fire.
- **The strobe was a real and separate bug**, fixed on the way: hiding the overlay when the tooltip hid handed the cursor back to the bag button, which re-showed the tooltip, which re-raised the overlay, at frame rate.

Two add-ons implementing this pattern, Locksmith and LazyLockBoxes, were read closely and their choices adopted (`TOOLTIP` strata, `GetMouseFoci`, restoring the tooltip from the overlay's `OnEnter`, a lockpick cursor). **Neither is confirmed working on Classic Era 1.15.x either.** The most likely explanation left is that the client no longer lets an add-on's secure button take a click over a bag slot, which is not something an add-on can work around.

What ships instead is enough: the tooltip says what a box needs and whether the player clears it, `UNIT_SPELLCAST_SUCCEEDED` on Pick Lock rescans so a hand-picked box opens itself half a second later, and the mini-map lists what is still locked.

## Loot Sounds

The rare-loot sound must fire only for loot pulled from a corpse, chest, or node, never for disenchanting, prospecting or milling, container opens, or the server's white-into-green item merge, all of which travel the same `LOOT_OPENED` plus `CHAT_MSG_LOOT` path a corpse does. They differ only in the **loot source GUID**:

- `CurrentLootFromWorldSource()` classifies the open loot window as `"world"` (at least one `Creature-`, `Vehicle-`, or `GameObject-` source), `"item"` (every resolved source is `Item-`), or `"unknown"` (the window is empty or the GUIDs have not populated).
- `StampWorldLoot()` runs on both `LOOT_READY` and `LOOT_OPENED`, because the GUID can populate on either and Speedy Loot may empty the slots between them. It records `ns.state.lastWorldLootAt` on `"world"`, clears it on `"item"` so a disenchant cannot reuse a real corpse's window, and leaves it alone on `"unknown"`. That third state is kept distinct from `"item"` on purpose: a late-arriving world GUID must still be able to stamp, and a stamp just set for this corpse must survive an empty re-read.
- `CHAT_MSG_LOOT` plays `ns.LOOT_SOUND_FILE` (`Includes/Sounds/item-pick-up.ogg`, through `PlaySoundFile`) only when loot sounds are on, the stamp is within `ns.LOOT_SOUND_WINDOW` (1s), and the item link's colour maps through `ns.QUALITY_COLORS` to a quality at or above `lootSoundThreshold` (default 2, Uncommon).

`ns.GetLinkQuality` reads quality off the link's colour because that is the only quality signal available without a `GetItemInfo` round trip. Heirloom shares Legendary's 5 so it always plays at any threshold; a colour the table does not carry, quest yellow for instance, returns nil, and each caller decides what unknown means. The loot sound stays quiet on it; a toast shows it anyway, because silently swallowing something the player did loot is the worse failure for a display.

### Pick Pocket

A rogue's pickpocket is the loot Speedy Loot hides most completely: it is mostly coin, which carries no quality, and its window is gone before it is seen. `pickPocketSound` plays **SoundKit 1183** (`PickupBag`) for it, and the two halves are deliberately split across two events:

- `UNIT_SPELLCAST_SUCCEEDED` for spell 921 only **arms** it, stamping `ns.state.pickPocketAt`.
- `PlayPickPocketSound`, called from `LOOT_READY` and `LOOT_OPENED`, plays it only if a loot window with at least one slot opened within `ns.PICK_POCKET_LOOT_WINDOW` (1s) of that stamp, and disarms as it plays so one cast sounds once no matter how many loot events the window generates.

**The cast is not the confirmation.** Picking a target whose pockets are already empty fires `UNIT_SPELLCAST_SUCCEEDED` *and* a "your target has already had its pockets picked" error together, and yields nothing, so hanging the sound on the cast would announce a haul that does not exist. A pickpocket that comes up empty opens no window at all and the arming simply times out, which is the whole point.

`PlayPickPocketSound` **must be called before `ns.HandleSpeedyLoot`** in the `LOOT_READY` handler: Speedy Loot empties the slots, and an emptied window is indistinguishable from a pickpocket that found nothing.

## Loot Toasts

[Loot-Toasts.lua](Features/Loot-Toasts.lua) is the answer to what Speedy Loot takes away. With the loot window hidden, the only record of a pickup is the chat log. When `lootToasts` is on, Core's `CHAT_MSG_LOOT` hands the link and message to `ns.ShowLootToast` after its own work, so the player's-own-loot prefix match is already done. Each toast is an icon, the coloured link, and a quantity. The newest sits at the anchor and older rows ride away from it, upward by default and downward when `lootToastGrowth` is `"DOWN"`.

**On by default,** because shipping them on is what keeps hiding the loot window a net gain rather than a loss of information.

**Because they ship on, the feature introduces itself.** A profile that has never dismissed the drag handle gets it raised at login through `ns.ShowLootToastIntro`, called from `PLAYER_LOGIN` and again from `ns.ApplyLootToastSettings` on a profile switch. The handle says what the feature is, previews where it will draw and how many rows it holds, carries the two gestures, and offers a **Disable Loot Toasts** button. Otherwise a new player's first contact with toasts is loot they did not ask for, drawn somewhere they did not choose.

`lootToastsIntroSeen` records the dismissal, and it is **per profile, not account-wide, on purpose**: a new or reset profile has not been introduced either, so it is shown the handle again. All three ways out set it, the right-click the handle advertises, its Disable button, and the panel's Lock button, since each is the player saying they have seen it. Nothing else raises the handle on its own: `ns.lootToastsUnlocked` starts nil, and beyond the introduction only `ns.SetLootToastsEnabled` and the panel's Unlock button lift it.

**Eight kinds of item ignore the quality threshold**, each behind its own toggle, all on by default. For all eight the item's colour is a poor guide to whether the player cares, which is the whole reason the escape hatches exist. **They do nothing at the shipped threshold**, which is Poor and hides nothing at all; they exist for the player who raises it, and that is the moment a Common quest starter or a grey key would otherwise vanish.

| Toggle | Test | Read from |
| --- | --- | --- |
| `lootToastContainers` | **presence** in `ns.AllowedItems` | table lookup |
| `lootToastQuestItems` | `classId == 12`, **or** the tooltip says `ITEM_STARTS_QUEST` | `GetItemInfoInstant`, then a tooltip scan |
| `lootToastRecipes` | `classId == 9` | `GetItemInfoInstant` |
| `lootToastKeys` | `classId == 13` | `GetItemInfoInstant` |
| `lootToastBags` | `classId == 1` **or** `11` | `GetItemInfoInstant` |
| `lootToastMounts` | `classId == 15`, `subclassId == 5` | `GetItemInfoInstant` |
| `lootToastPets` | `classId == 15`, `subclassId == 2` | `GetItemInfoInstant` |
| `lootToastBindOnPickup` | `bindType == 1` | `GetItemInfo`, **14th return** |

Three of those rows carry a trap worth naming:

- **Bags are two classes, not one.** Quivers and ammo pouches are class 11, their own class rather than containers, a distinction the client's item database makes and a hunter does not. Both are the bag you were hoping would drop, so the Bags toggle covers the pair.
- **Bags are not Containers.** Class 1 is the client's "Container", the thing loot goes *into*. The add-on's own openable containers are matched by id against `ns.AllowedItems`, never by class, and by presence rather than by a `true` value, so a still-locked box counts as much as an openable one. That row also earns its place differently from the rest: it is about the **add-on** being on the point of acting, not about the item.
- **A quest starter is not a quest item.** `ITEM_STARTS_QUEST` rides with `lootToastQuestItems` because it is the same "do not walk away from this" case, but the class test misses it entirely, since a starter is as often an ordinary trinket or blade as it is class 12. Neither target client flags it in any API, so a tooltip is the only place the client will say so.

**`AlwaysShown` tests them in cost order,** which is the order in the table above and deliberately not the order the panel lists them in. The table lookup is free, the `GetItemInfoInstant` reads answer from the client's own database with no cold-cache nil, Bind on Pickup needs the full `GetItemInfo`, and the quest-starter tooltip scan goes last because it is the only question that builds anything. That scan is affordable precisely because of where it sits: it runs only for loot every cheaper test has already passed on, and only for loot the threshold would otherwise have hidden. The panel's order is the player's: the catch-all first, the named kinds next, the two storage rows together at the end. `GetItemInfo`'s 14th-return position is the one assumption no type check would catch, so `ns.DIAGNOSTIC_API_CHECKS` probes it against the Hearthstone, which is Bind on Pickup and in every player's bag.

**Quantity comes off the message, not the link.** The loot text carries an `x2` suffix; the link itself has no count. A single item has no suffix and renders as the plain name. The link's square brackets are stripped, since they are chat punctuation marking where a link starts and ends in running text and a toast is one item on its own line. The escape sequence is left intact so the text stays a real link rather than a lookalike.

### Money

**Coin is the only loot with no item behind it:** no link, no icon, no quality, so nothing the threshold or the always-shown kinds could ever have an opinion about. `lootToastMoney` gives it a toast on its own terms; without one, hiding the loot window leaves coin with no trace outside the chat log. It carries its own toggle for the same reason it needs a toast: every kill drops coin, so it is the row a player sees most often and the one they are most likely to want gone.

Core's `CHAT_MSG_MONEY` hands the message to `ns.ParseMoney`, which reads the amount back out of the sentence by matching the client's **own** `GOLD_AMOUNT`, `SILVER_AMOUNT`, and `COPPER_AMOUNT` formats. That is what makes it work in a locale that does not call them gold, silver, and copper, and `ns.BuildFormatPattern` is what turns a format string into a pattern with captures. A unit the message does not mention simply does not match, which is the same as none of it.

`ns.FormatMoney` renders `123g 02s 27c`: the largest unit the amount reaches, then every unit below it padded to two digits and nothing above it, so stacked toasts line up in one column while small change is not padded out with a leading `0g`. The suffixes are the client's own `*_AMOUNT_SYMBOL` globals, and the string **colours itself**, numerals in body white and each suffix in its own coin's colour from `ns.MONEY_PALETTE`. Those colours sit apart from `ns.PALETTE` because they are not the add-on's to choose: gold, silver, and copper look the way the client makes them look everywhere else, and splitting the colour at the letter is what lets the eye read the unit without reading the letter. Nothing wraps a colour around the result, which would flatten exactly that distinction. `ns.MoneyIcon` picks the coin pile by magnitude, `INV_Misc_Coin_02` at a gold or more, `_04` at a silver, `_06` below that, so the icon carries the size before the digits are read.

### Frames, Layout, and the Handle

**Frames are pooled, never leaked.** At most `lootToastMaxVisible` are live (1, 2, 3, 5, 8, 13, 21, or Unlimited, default 8). Unlimited is stored as the `ns.LOOT_TOAST_UNLIMITED` sentinel `0`, which `MaxVisible()` resolves to `math.huge`; the sentinel must never reach the cap arithmetic as a number, because `#active >= 0` is always true and would retire every row the instant it was drawn. Each toast fades after `lootToastDuration` seconds and returns to the pool, and the dwell is stamped onto the animation at play time rather than when the frame was built, because a pooled toast outlives any one choice of duration. The cap retires the **oldest** toast rather than dropping the new one: a burst of loot should show what just arrived, not freeze on the first rows.

**Growth and alignment pick a corner between them.** `Restack` composes the two settings into one anchor point, `lootToastGrowth` supplying `TOP` or `BOTTOM` and `lootToastAlign` supplying `LEFT` or `RIGHT`, and pins each row corner-to-corner with the anchor there, ageing rows away along the growth axis only. The arithmetic is what makes both movements right: adding an entry raises the count, so every row already on screen gains exactly one step, while retiring the oldest drops the count and every survivor's index together, which cancels, so nothing near the anchor twitches to fill the gap left at the far end.

**Every measurement is derived from the font size, and re-derived on every restack.** `Measure` owns both the row's size and its internal layout: the icon is `ICON_TO_FONT_RATIO` (1.5) times the font size, the gap a third of it, and the row's width ceiling `TEXT_WIDTH_RATIO` (32) times it, which is room for roughly 64 characters at any size. A fixed icon size was the bug: raise the font and the same icon shrinks against it. Running `Measure` from `Restack` rather than at creation is what lets a font, size, or alignment change reach toasts already on screen. Left-aligned the icon leads and the name runs right from it; right-aligned the icon trails and the name is justified back against it.

**The flag string carries the weight**, because the client offers no bold. `SetFont`'s flag string is the only control over how heavy the glyphs land, and none of the shipped faces has a bold cut, so a thicker outline is what reads as heavier against a bright world background. `lootToastFontFlags` is one of `ns.LOOT_TOAST_FONT_FLAGS` (`"NONE"`, `"OUTLINE"`, `"THICKOUTLINE"`, `"MONOCHROME"`, `"MONOCHROMEOUTLINE"`, default `"OUTLINE"`), offered as a single Font Outline dropdown. `ResolveFlags` passes it through verbatim and turns only `"NONE"` into the empty string `SetFont` expects, and the flags ride both `SetFont` calls in `ApplyFont` so a face that fails to load keeps its weight on the fallback.

**Fonts come from LibSharedMedia,** the registry ElvUI, Details, WeakAuras, and others publish into. Open Sesame ships the library so the dropdown is never empty: on its own it still registers the faces the client itself carries, and on a client running anything else that uses it the player gets that whole shared library. LSM also masks its list by locale, so a koKR client is only offered faces that can draw Korean. `DEFAULT` is the add-on's own sentinel rather than a registered face, resolving at runtime from `GameFontNormal`, which is the only correct answer on a locale whose client ships its own font; a face the library no longer knows falls back to the same place. `ns.GetLootToastFontChoices` rebuilds the list on every call rather than caching it, so a face registered by an add-on that loaded later still turns up the next time the dropdown opens.

**The anchor is the fixed point rows stack from, and its size must not drift.** `TOAST_HANDLE_WIDTH` (400) and `TOAST_HANDLE_HEIGHT` (130) are fixed, never font-derived: rows anchor to a corner of the handle, so a size that moved with the font would walk the whole stack. The caption is three blank-line-separated rows, the add-on's name and the feature's in title gold, then the two gestures in body white in the order a player meets them, hung from the top of a `TOAST_HANDLE_LABEL_WIDTH` (260) column with the Disable button in the bottom corner at the same inset, so the button's edge lines up with the text's. `ApplyHandleLayout` pins both to **the end the rows do not use**: rows left-aligned puts the caption right, and the reverse, which is what stops the nearest row from being drawn over the caption and why the caption's side is derived from `lootToastAlign` rather than being a setting of its own. Body white rather than helper silver because those lines are the point rather than an aside to it, and they are read over open world at whatever the ground happens to be. There is no third line pointing at the options panel: the button says the same thing.

**The handle locks itself.** The anchor is a `Button`: left-drag moves it, right-click locks it, and the caption says so, so a player who dragged it somewhere awkward does not have to find the Options Interface again. Turning the feature off also drops the handle, which would otherwise be stranded on screen with nothing to place.

**Unlocking previews itself.** While the handle is up, `ns.RefreshLootToastSamples` stands in one "Example Item" sample per row the cap allows, a fixed 8 when the cap is Unlimited, each in a random quality at or above the Minimum Quality and wearing the colour-matched potion icon from `ns.LOOT_TOAST_SAMPLE_ICONS`. The preview does three jobs at once: where the stack sits and how many rows it holds, what the chosen font and size look like, and which tiers the threshold is letting through. Samples rebuild, and deliberately re-roll their qualities, on every appearance change, so each change visibly answers in the preview. They never fade, are released outright when the handle goes away, and come from the same pool, so cycling them allocates nothing.

**The anchor position is account-wide.** `ns.db.global.lootToastPosition` sits alongside the Ignore List in `global`, because where a player wants this on their screen is not a per-character decision. `ns.ApplyLootToastPosition` runs on `PLAYER_LOGIN` and again from `ApplyProfile`; with nothing saved it defaults to centre plus 200, clear of the action bars and the chat frame.

## Pause, Resume, and the Status Channel

Auto-Opening pauses itself when bag space runs low. **Pause and resume share a single threshold**, `ns.MIN_FREE_SLOTS` (4): `ShouldPause` pauses below it and `IsSafeToOpen` resumes on reaching it, so `PAUSED_BAG_SLOTS` reports `ns.MIN_FREE_SLOTS` directly. The count the message promises is the count that actually resumes opening, and adding an offset to either side would break that.

A hard `UI_ERROR_MESSAGE` inventory-full firing forces an immediate pause and plays a race and gender specific "bags full" voice line from `ns.RACE_SOUNDS`, falling back to `ns.BAG_FULL_SOUND_FALLBACK`, rate-limited by `ns.BAG_FULL_COOLDOWN` (10s). `ns.IsBagFullErrorID` is the only inventory-full test in the add-on: the handler and the Diagnostics event-log filter both classify `UI_ERROR_MESSAGE` through it, so a firing can never pause the add-on while the log files it away as uncorrelated noise. Never add a message-text match beside it, because the two would disagree exactly when a bug report needs the log line.

Status prints go through `ns:StatusPrint` in [Announcements.lua](Features/Announcements.lua), which:

- suppresses output during the **quiet window** (`ns:SetQuiet` and `IsQuiet`), raised on loading screens and on zoning so transient churn stays silent. `SetQuiet` only ever extends the window, never shortens it.
- drops an identical message repeated inside `ns.STATUS_REPEAT_COOLDOWN` (5s).
- is held while an interaction frame is open. `AnnounceStatus` returns early when `IsInteractionActive()` is true, and `OnInteractionClosed` flushes the held message after `ns.STATUS_FLUSH_DELAY` so a "Resumed" is not lost in the middle of the player's vendoring. `ns.state.announcedPaused` tracks what the player was last told, so the flush says the current state rather than replaying a stale one.

Per-item notices use a separate throttle, `ns:AnnounceItemOnce`, which allows one message per item id per `ns.ITEM_ANNOUNCE_COOLDOWN` (5s). Both Ignore List notices share that stamp deliberately: a player who was just told Speedy Loot left an item behind does not also need to be told it will not be opened.

## Auto Loot Enforcement

Speedy Loot and Auto-Opening both depend on the game's Auto Loot, and Open Sesame enforces it. `ns.EnsureAutoLoot()` reads `autoLootDefault` first and writes `1` only when it is off, then prints `AUTO_LOOT_ENABLED` naming the setting and its new state. It runs on profile apply, on world entry, and on each of the four toggles that need it (the two on the General panel and the two on the mini-map button).

**This is the one enforced CVar the add-on ships without an opt-out toggle**, and that is deliberate: Open Sesame cannot do its job with Auto Loot off, so a toggle would only offer a way to break the add-on. Every other rule on an enforced write still binds: the write happens only on an actual change, the player is told through a `PrintMessage` notice naming the setting and its new state, and `README.md` discloses the behaviour in its Setup section. Keep that disclosure in place if the Setup copy is rewritten. The `taintLog` CVar in the Diagnostics panel is the only other CVar the add-on writes, and it is user-initiated rather than enforced.

Every CVar read and write goes through the `C_CVar` namespace, never the bare globals, so there is no chance of an `or`-chained read falling through when Auto Loot is legitimately off.

## Minimap Button

[Minimap-Button.lua](Features/Minimap-Button.lua) registers a LibDataBroker launcher and shows it through LibDBIcon-1.0. The icon swaps between the `on`, `paused`, and `off` textures in `ns.ICONS` to mirror runtime state, and the broker's `text` field carries the same state in words for display add-ons. Clicks: **left** toggles Auto-Opening, **right** toggles Speedy Loot, **middle** toggles Loot Sounds, and **Shift + Middle-Click** opens the Options Interface, checked first in `OnClick` before any feature button. The combat refusal lives inside `ns:OpenOptionsPanel` and is never duplicated here.

A **Locked Items** list leads the tooltip, directly under the title and above the feature blocks, drawn only when boxes are actually waiting. It is the one part that reflects the bags rather than a setting, so it is what the player opened the tooltip to check. It comes from `ns.GetLockedBoxes` in [Core.lua](Features/Core.lua): allowed-but-locked containers that are not on the Ignore List and still report `LOCKED`, collapsed to one row per distinct item with a stack count and **sorted by name**. Each line is the item's icon, then its name taken from the container's own item link, already localized and quality-coloured, with the brackets stripped since a tooltip line is not running text, and ` xN` appended only when more than one is held so no locale needs a plural form.

It is computed on demand rather than cached: it runs once per tooltip render, not per frame, and a cache would need invalidating on every bag, trade, and pick-lock event. The scan stays cheap because `IsItemLocked` is reached only for ids `ns.AllowedItems` already marks as needing an unlock, so it costs a handful of reads rather than one per bag slot. Because the tooltip re-renders in place after a toggle click while the button still owns it, the list and the on/off states stay live.

Both the button's position and its visibility live in `ns.db.profile.minimap`, the subtable handed straight to LibDBIcon. `hide` is the single source of truth for visibility, written by `ns:SetMinimapShown` and read by the options toggle, inverted for its "Enable" label. Under the Simple model this is profile state, so switching or resetting a profile changes it, and `ns:UpdateMinimapIcon` calls `LDBIcon:Refresh` with the live subtable on the profile callbacks so the change applies without a reload.

## Options Panels

Six panels, registered in [Options.lua](Options/Options.lua) in the order the house rules fix: **General** (root), then the feature panels **Notifications**, **Lockboxes**, and **Ignore List**, then **Profiles** second to last and **Diagnostic Tools** last. That order is the order of the `AddToBlizOptions` calls. The root panel keeps what does not belong to one feature: the welcome and mini-map toggles, `/Commands`, Auto-Opening, Speedy Loot, the four links, and the version line.

**Registration is deferred, never at file scope.** `ns:RegisterOptionsPanels` is called from `PLAYER_LOGIN` immediately after `AceDB:New`, because the Profiles builder calls `AceDBOptions:GetOptionsTable(ns.db)` and `ns.db` does not exist earlier.

**The opener routes by captured category id.** `AddToBlizOptions` returns `(frame, categoryID)`, and both are captured at the root panel's registration as `ns.GeneralPanel` and `ns.GeneralCategoryID`. `ns:OpenOptionsPanel` gates on combat, then calls `Settings.OpenToCategory(ns.GeneralCategoryID)`, then falls through to `AceConfigDialog:Open` as a last resort a correctly routed add-on never reaches. **Never look up the category by name:** passing the localized title returns nil on any client that has the Settings API, execution falls through to the dialog, and the panel appears as a floating window instead of docking. It breaks on TBC Anniversary while still working on Classic Era, so it survives testing on one flavor.

**Sub-option rows are shared, not per-panel.** `ns.OptionsSubRow`, `ns.OptionsSubLabel`, and `ns.OptionsSubSelectRow` live in [Options-Utilities.lua](Options/Options-Utilities.lua). Three panels build sub-rows (General's Where and Group rules, Lockboxes' two scopes, Notifications' thresholds and appearance rows), so one shared shape is what keeps them from drifting apart. The three mechanical constraints still hold wherever they are built: one unnamed inline group per sub-option, control widths sized with slack rather than to an exact fit, and `hidden` on the group rather than on its members.

Two panels size their sub-rows past the shared defaults, and both give back what they take: Notifications widens the caption to 1.4 for "Maximum Items to Display" and narrows its control to 0.9, and the bypass checkboxes take 2.4, which plus `ns.OPTIONS_SUB_INDENT_WIDTH` stays inside `ns.OPTIONS_ROW_WIDTH`.

**The Ignore List panel registers its builder, not a built table**, so the list can redraw rows that did not exist at login. See [Panel and the Shared Item-List Builder](#panel-and-the-shared-item-list-builder).

**The Profiles panel returns the stock AceDBOptions-3.0 table unmodified.** It is never mutated: `GetOptionsTable` does not return a private copy, so writing to the returned `args` would change every other Ace add-on's Profiles panel in the session.

## Diagnostics Panel

[Diagnostics.lua](Features/Diagnostics.lua) generates bug-report text, not unit tests. WoW's sandboxed Lua has no assertion runner, so everything here is environment probing and state capture. All of it is read-only and side-effect free except the explicit Taint Log button, which sets the `taintLog` CVar. Reports build only on a button press, never on load or on panel open.

**The enable gate is runtime-only.** `ns.diagnostics` is a plain namespace table (`{ enabled = false, logging = false, log = nil }`) initialized at file scope and never persisted, so the panel starts off at every login and nothing survives a session. Off means off: with logging disabled the dispatcher's logging branch is a single boolean read before any allocation, and disabling the panel calls `ns:StopEventLog`, which releases the buffer. Every gated section hides on that one condition, so the panel defines local `SectionHeader` and `ReportOutput` builders that bake it in alongside shared `Hidden` and `Refresh` locals.

The probes: **Event Log**, **Event Registration** (over `ns.EVENT_NAMES`), **API Endpoints**, **Loot Method**, **Other Add-ons**, **Relevant CVars**, **Display Context**, **Saved Variables**, **Library Versions**, the **Taint Log** control, and an **External Tools** section pointing at BugSack, `/console scriptErrors 1`, and `/etrace` rather than reimplementing them. Every report opens with the same client header: add-on version, client version and build, TOC, `GetLocale()`, and `WOW_PROJECT_ID`, so a pasted snippet always carries them. Reports are plain text with no colour escapes, which would paste as literal `|cff` codes.

**The event log is bounded and snapshotted.** Entries go into a fixed buffer of the most recent 500 events, written before the real handler runs. `ns:LogEvent` converts each argument to a string immediately and never retains references, since some events carry frames or tables that would leak or go stale, and caps the argument count at 8 and each argument at 255 bytes, sized to hold a full loot line with its item link. **Pipes are escaped after the length cut**, so a truncated argument can never leave a dangling pipe that would eat the following separator.

**Firehose traffic is counted, not dropped.** `ns.DIAGNOSTIC_EVENT_EXCLUDE` is empty and expected to stay that way: nothing Open Sesame registers is pure noise, since it listens on the coalesced `BAG_UPDATE_DELAYED` rather than raw `BAG_UPDATE`. `UI_ERROR_MESSAGE` is the one firehose, and it is only *sometimes* noise, because the inventory-full firing is exactly what the log needs. So it goes through the per-id filter instead: `ns.MESSAGE_ID_FILTERED_EVENTS` names the event and the argument position its message id arrives in, and `ns:SuppressUncorrelatedMessage` classifies each firing through `ns.IsBagFullErrorID`, the same call the live handler uses, so the filter cannot drift from it. Everything else folds into a per-id counter, first-seen text plus a count, rendered as one block at the end of the report with the biggest offender first. A firing carrying no numeric id in the filtered position is unclassifiable, and unclassifiable is signal: it logs verbatim. Filtering happens at capture rather than at render, because filtering at display time would still let spam push real events out of the buffer.

**Two probes are Open Sesame's own context.** **Loot Method** prints the live return values and types of `C_PartyInfo.GetLootMethod`, plus the verdict Speedy Loot draws from them, because an existence check cannot prove the call returns the shape and enum number the master-looter stand-down is written against. **Display Context** answers "my loot toasts are off the edge of the screen" reports with the resolution and scale the saved anchor was chosen against, the saved point, and the live one; it reads the anchor through `ns.GetLootToastAnchorFrame`, which returns nil rather than creating the frame, so the report never brings a frame into existence as a side effect.

**The saved-variables dump summarizes the Ignore List by length** rather than printing every row, and identifies it by table identity against the live list rather than by key name, so a rename cannot quietly turn the summary back into hundreds of rows. Recursion is capped at depth 8.

Diagnostics strings live in `ns.DiagnosticsStrings` as plain English and are intentionally **not** localized, because they are developer-facing. The one localized string the panel reads is `ns.L["ADDON_TITLE"]`.

## Regenerating the Item Tables

**Two sources feed these tables, and neither is sufficient alone.** Each table carries its own regeneration notes in a block comment directly above it; this is the overview.

| Source | Answers | Feeds |
| --- | --- | --- |
| **CMaNGOS (Wrath) world DB** | which containers exist, which kind they are, and why one belongs on the ignore list | `true`/`false` in `ns.AllowedItems`; membership and reason in `ns.DEFAULT_IGNORE_ITEMS` |
| **Wowhead per-client openable listings** (Classic Era including Season of Discovery, Burning Crusade, Wrath) | which clients have an item | every expansion block and tag, plus roughly 128 rows the Wrath DB has never heard of |
| **Maintainer decision** | the handful no rule reaches | 2 rows in `ns.DEFAULT_IGNORE_ITEMS`, marked `hand-added` in their comments |

**Never rebuild either table from SQL output alone.** Doing so silently drops every modern Classic re-add and Season of Discovery container, resets every expansion tag, and loses the hand-added rows. The block above each table says exactly what its query does and does not produce.

### The Two Tables Must Agree

**Every Ignore List row must also be in `ns.AllowedItems` as `true`.** `BuildQueue` requires both, since the item has to be openable *and* not ignored. A row that is on the Ignore List but missing from `ns.AllowedItems` is a trap: the player removes it from the list expecting it to start opening, nothing happens, and there is nothing on screen to explain why. The same goes for a row `ns.AllowedItems` marks `false`, which would sit waiting on an unlock that is never coming.

Their expansion tags have to agree too. Both come from the same Wowhead availability data, so a disagreement means one table was regenerated without the other, and the Ignore List would seed a row on a client whose `ns.AllowedItems` block does not carry the item.

### What Each Source Is Load-Bearing For

- **Expansion tags are Wowhead's, not the DB's.** The world DB records no expansion column, and id ranges do not work, because six-digit modern Classic re-adds sit alongside five-digit vanilla ids. In `ns.DEFAULT_IGNORE_ITEMS` the tag is *functional* rather than decorative: seeding only writes rows at or below `ns.currentExpansion`, so a wrong tag either hides a row from a client that has the item or offers one that can never resolve.
- **The DB misses whole categories.** Clams and the Lotteryboxes deliver loot through a spell rather than `item_loot_template`, so the openable query never returns them.
- **Loot references must be followed.** A container's real contents are frequently one `reference_loot_template` hop away, so the ignore-list query is recursive. On a reference row (`mincountOrRef < 0`) the `item` column carries no meaning, since it exists only to satisfy the primary key, so it is read as an item id **only** when `mincountOrRef` is positive.
- **The raid branch ignores container bonding on purpose.** The DB has Blue Sack of Gems as Bind on Pickup while its four siblings are tradeable; that is a data quirk rather than a real difference, and filtering on it would drop the row.
- **Unique is not a criterion.** An early ignore-list rule used `maxcount > 0` and produced 144 rows instead of 35, because nearly every quest item and one-off trinket is Unique.
- **A re-added id inherits by name.** The Anniversary client renumbers items without changing what they are, so a re-added id takes the `true`/`false` of the existing row sharing its name. Failing that, a name carrying "Lockbox", "Junkbox", or "Locked Chest" is taken as needing an unlock; only two rows rest on that guess today.
- **The Lockpicking skill number is in neither source.** `item_template.lockid` points into `Lock.dbc`, which is client data. Current values were read off each item's `warcraft.wiki.gg` page, and the comment above `ns.LOCKBOX_SKILL_LEVELS` carries a `-- TODO: Add SQL Query` marker plus a query listing which items *need* a value, for gap-checking after a regeneration.

## Saved Variables

The single SavedVariables table is **`OpenSesameDB`**, declared in [Open-Sesame.toc](Open-Sesame.toc) and managed by AceDB-3.0. It holds every setting, the player's Ignore List, and the two saved positions.

Open Sesame uses the **Simple** saved-variables model: one shared `"Default"` profile for every character, with `true` as `AceDB:New`'s third argument. **Reset Profile therefore clears every setting back to install defaults, the mini-map button's position and visibility included, and leaves `ns.db.global` untouched.**

- **`profile`** carries every user setting: the Auto-Opening toggle and its Where and Group rules, Speedy Loot, the lockbox tooltip and notification toggles with their scopes, the loot sound and its threshold, the Pick Pocket sound, the Ignore List notifications toggle, the whole Loot Toasts block (enabled, threshold, the eight bypasses, money, duration, count, growth, alignment, font, size, flags, and `lootToastsIntroSeen`), `showWelcome`, and `minimap`, the LibDBIcon position and `hide` subtable.
- **`global`** carries the two things that must not move with a profile: `ignoreList`, because which containers a player hoards is a decision about the items rather than the character, and `lootToastPosition`, because where a player wants the stack on their screen is not a per-character decision.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed, and explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*`/`**` wildcard defaults resolve through metatables.

The one player-editable list is the Ignore List, and it follows the house default-list rule: `ns:SeedIgnoreList` rebuilds it from `ns.DEFAULT_IGNORE_ITEMS` only when the saved list is missing or empty, and Restore Defaults rebuilds it on demand. Shipping new default entries therefore does not change an existing player's list, so note additions in the release notes. `ns.AllowedItems` is a compile-time constant with nothing to re-seed.

There is no migration chain. `PLAYER_LOGIN` clears three deprecated keys outright rather than converting them: `ns.db.global.minimap`, from before the subtable moved to the profile under the Simple model, and `lootToastFontOutline` and `lootToastFontBold`, which the single `lootToastFontFlags` dropdown replaced.

**Profile switches, resets, and copies apply live.** All three AceDB callbacks are wired to `ApplyProfile` right after `AceDB:New`. It pushes the profile onto the runtime flags, re-runs `ns.EnsureAutoLoot` when either feature needs it, forces a scan, refreshes the mini-map icon, re-applies the toast position and settings, and calls `NotifyChange` for every registered panel so open options redraw. It is deliberately not called on initial login: `PLAYER_LOGIN` and `PLAYER_ENTERING_WORLD` own first-time setup and its ordering.

## Adding a New Openable Item

1. Open [Data/Openable-Items.lua](Data/Openable-Items.lua) and find `ns.AllowedItems`.
2. Add `[itemId] = true` for an item safe to open on sight, or `[itemId] = false` for a lockbox or locked chest that must be unlocked first.
3. Place it in the correct expansion block (`01. World of Warcraft`, `02. The Burning Crusade`, `03. Wrath of the Lich King`) and keep the block sorted by the trailing `-- Item Name` comment.
4. For a `false` entry, add its required skill to `ns.LOCKBOX_SKILL_LEVELS` in [Data/Data.lua](Data/Data.lua) so the tooltip line has a number, or leave it out deliberately rather than guessing.
5. Nothing else to wire. `BuildQueue`, `ns.GetLockedBoxes`, and the Loot Toasts Containers bypass all read the table directly.

## Adding a Default Ignored Item

1. Add `[itemId] = { ns.VANILLA, "REASON" }` to `ns.DEFAULT_IGNORE_ITEMS` in [Data/Default-Settings.lua](Data/Default-Settings.lua), in the right expansion block with a trailing `-- Item Name` comment.
2. The expansion tag is functional: seeding skips anything above `ns.currentExpansion`, so tag it with the earliest client that has the item.
3. The reason is one of `RAID`, `QUEST`, `RECIPE`, `GEAR`, `HOLIDAY`, or `ITEM`, each mapping to an `OPTIONS_IGNORE_REASON_*` locale key. Do not invent a seventh without adding the key to `enUS.lua` and the mapping in [Features/Ignore-List.lua](Features/Ignore-List.lua).
4. Confirm the id is in `ns.AllowedItems` as `true`, per [The Two Tables Must Agree](#the-two-tables-must-agree).
5. The table is only a **seed**. Existing players keep the list they have, and the new entry reaches them through Restore Defaults or a fresh install, so note it in the release notes.

## Adding a New Registered Event

1. In [Features/Core.lua](Features/Core.lua), add a handler: either `function EventHandlers:EVENT_NAME(...)` or an alias onto an existing helper (`EventHandlers.EVENT_NAME = OnScanRequest`).
2. That is the only step. The registration loop, the `C_EventUtils.IsEventValid` guard, and `ns.EVENT_NAMES` are all derived from the `EventHandlers` table, so the dispatcher and the diagnostics probe pick the new event up together.
3. If the event is a firehose that is only sometimes signal, add it to `ns.MESSAGE_ID_FILTERED_EVENTS` with the argument position its message id arrives in, and extend `ns:SuppressUncorrelatedMessage` to allowlist the ids the add-on actually correlates. Never hand-maintain a denylist of noise ids.

## Localization

Strings are localized through AceLocale-3.0. Locale files live in `Locales/<locale>.lua`, each registered with `NewLocale("Open-Sesame", "<locale>")`, and `Data/Data.lua` resolves `ns.L` once from the TOC's `ADDON_NAME` vararg for every other file to read.

- **Source of truth.** [Locales/enUS.lua](Locales/enUS.lua) is the only file that passes the `true` default-fallback flag. Every key originates there, and the other ten locales translate the same key set. At runtime AceLocale falls back to English through `__index` for any key a locale does not define, so a locale can lag without crashing.
- **The Localization pass owns the other files.** Translating each `enUS.lua` key into every locale and keeping the files aligned is that pass's job. Do not hand-edit the other locales during ordinary work.
- **Placeholders.** `%s` and `%d` count, type, and order must match `enUS` per key in every locale, or `string.format` errors at runtime. The keys carrying format arguments are `CHAT_LOADED` (`%s`), `PAUSED_BAG_SLOTS` (`%d`), `AUTO_OPENING_DESCRIPTION` (`%d`), `ITEM_WILL_AUTO_OPEN` (`%s`), `ITEM_IGNORED` (`%s`), and `ITEM_OPEN_MANUALLY` (`%s`).
- **Renaming a key means renaming every call site with it.** A retired key name is never reused: AceLocale falls back to enUS only for keys a locale does not define, so a stale translation left under the old name would silently win.
- **Diagnostics strings are not localized.** `ns.DiagnosticsStrings` is developer-facing English, kept out of `Locales/` entirely.

WoW ships a fixed locale set and every supported locale file already exists (`deDE`, `esES`, `esMX`, `frFR`, `itIT`, `koKR`, `ptBR`, `ruRU`, `zhCN`, `zhTW`), so there is no "add a new locale" step. This is maintenance, not expansion.

## Common Pitfalls

- **A scan tooltip needs its owner set on every use, not once at file scope.** `IsItemLocked` hides `OpenSesameScanTooltip` when it is done, because setting a tooltip shows it and that one is anchored nowhere in particular. Hiding a tooltip drops its owner, and an **unowned tooltip accepts `SetBagItem` without complaint and populates nothing**, so every box reads as unlocked, the mini-map's Locked Items list quietly empties, and no tooltip line is added. `SetOwner` therefore runs at the top of every call. If that list goes missing while the boxes are plainly still in the bags, check this first.
- **Matching `LOCKED` as a substring.** It is a short word, and other add-ons write tooltip lines that contain it without meaning it. `TooltipHasLine` compares whole lines.
- **Hiding the loot window on `LOOT_READY`.** A no-op, because the frame is not shown yet, so the default UI shows it afterwards with nothing to re-hide it. That is the flash. Always suppress through the `LootFrame` `OnShow` hook gated by `suppressLootWindow`.
- **Carrying a "fully looted" verdict across corpses.** A throttled `LOOT_READY` can reuse the previous corpse's `suppressLootWindow`. `LOOT_CLOSED` must reset it through `ns.ResetSpeedyLootWindow`.
- **Looting while master looter.** Calling `LootSlot` on a threshold item pops `MasterLooterFrame_Show` with no selection, which crashes on a nil `colorInfo` on some clients. `IsPlayerMasterLooter()` stands the whole pass down.
- **Comparing the loot method to `"master"`.** `C_PartyInfo.GetLootMethod` returns an enum **number**. Compare against `LOOT_METHOD_MASTER` (`2`); a string comparison reports "not master looter" forever.
- **Trusting `IsStealthed` alone.** Night Elf Shadowmeld does not always register through it, so `IsPlayerStealthed` also scans buffs for the Shadowmeld aura (spell 20580). Opening a container while stealthed would break stealth.
- **Item-produced loot playing the rare sound.** Disenchant, prospect, mill, container opens, and the white-into-green merge all share the corpse loot path. Only a `"world"` GUID stamps `lastWorldLootAt`; never widen the stamp to `"unknown"`.
- **Adding an offset to the pause threshold.** Pause and resume share `ns.MIN_FREE_SLOTS`, and `PAUSED_BAG_SLOTS` reports it directly. A `+ 1` on either side makes the message promise a count that does not actually resume opening.
- **Confusing the two ignore tables.** `ns.DEFAULT_IGNORE_ITEMS` stores `{ expansion, reasonKey }`; the saved list stores `true`. Seeding writes `true`, and the reason is looked up from the defaults table at read time, which is what lets better copy reach saved lists without a migration.
- **Seeding a row this client cannot resolve.** An id above `ns.currentExpansion` never answers `GetItemInfo` here, so it sits in the panel as a bare number forever and keeps the refresh watcher armed for news that never comes. Both seeding and Restore Defaults filter by tag; the panel drops unresolvable ids again with `GetItemInfoInstant`.
- **Registering a built options table where the builder is needed.** `RegisterOptionsTable(name, ns.BuildIgnoreListOptions())` freezes the Ignore List at its login contents. Pass the function.
- **Letting the Unlimited sentinel reach the toast cap arithmetic.** It is stored as `0`, and `#active >= 0` is always true, so it would retire every row on sight. `MaxVisible()` resolves it to `math.huge` instead.
- **Positioning a toast's name with `SetJustifyH` across a row-wide text box.** A row is far wider than its name, so justification alone decided where the name landed, and any row holding a stale justification drew its name at the opposite end of the row from its own icon. `Measure` sizes the text box to the string with `SetWidth(0)` and pins it to the icon, so placement is geometry rather than justification. Related: `SetFont` resets a font string's justification, so `ApplyFont` must run **before** `SetJustifyH`, never after.
- **Releasing a pooled toast twice.** `fade:Stop()` can fire the group's own `OnFinished`, which releases again and pushes the frame into the pool a second time, after which one frame is handed out as two rows and a row silently vanishes. `ns.ReleaseLootToast` guards the pooling on `toast.pooled`, cleared by `AcquireToast`. The list removals in the same function are deliberately unguarded, because callers loop until a list shrinks and a release that removed nothing would spin forever.
- **Re-adding a modern to legacy fallback.** The legacy globals are gone from both target clients, so an `or`-chained fallback is dead code that hides a real break. Call the namespaced API directly and add a row to `ns.DIAGNOSTIC_API_CHECKS`. See [Client Targets and API Surface](#client-targets-and-api-surface).

## Contributing

- **Issues.** Open them on the [GitHub Issues tab](https://github.com/Gogo1951/Open-Sesame/issues).
- **Bug reports.** Include game version and locale, class and level, repro steps, and the relevant chat output. Enabling the Diagnostics panel and running the relevant probe produces a report whose header already carries the client, build, TOC, locale, and project id.
- **Discord.** [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **PR guidelines.** Keep changes tightly scoped. Match the surrounding code style, which is StyLua's default output. Never hand-merge defaults around AceDB, and never write `db.field = db.field or default`, which overwrites an explicit `false`. Keep placeholder counts aligned across locales. Update this document in the same change if the architecture, the file map, or the saved-variables shape moves. Open Sesame prints to the player only and sends no chat, so the 255-byte `SendChatMessage` ceiling does not currently bind any string here; adding a sent message brings that check into scope for every locale, and the widest-encoding locale is the one to test against.
- **Commit and PR descriptions require a User Story.** Do not just say "I changed X" or "I fixed Y". Frame the change in terms of who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a rogue trading locked boxes to a guildmate to crack, I wanted the boxes to open on their own once unlocked rather than waiting on a bag event. This change adds a second forced rescan after `TRADE_CLOSED` on the pick-lock settle delay.*

  The User Story makes review faster and gives future maintainers context the diff alone will not carry.
