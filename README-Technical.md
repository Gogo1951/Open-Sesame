# Open Sesame — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Open Sesame. For end-user documentation, see [README.md](https://github.com/Gogo1951/Open-Sesame/blob/main/README.md).

## File Map

```
Open-Sesame/
├── Open-Sesame.toc              Load order, metadata, SavedVariables declaration
├── README.md                    Player-facing documentation
├── README-Technical.md          This file
│
├── Data/
│   ├── Data.lua                 Constants, spell/sound IDs, color palette, and the
│   │                            hand-curated AllowedItems / IgnoreItems tables
│   └── Default-Settings.lua     ns.DATABASE_DEFAULTS (AceDB profile + global defaults)
│
├── Features/
│   ├── Core.lua                 Event dispatcher, scan/queue/open pipeline, pause logic,
│   │                            profile application, SavedVariables migration
│   ├── Utilities.lua            C_Container API selection, color derivation, GetFreeSlots
│   ├── Announcements.lua        PrintMessage, the deduped StatusPrint channel, quiet window
│   ├── Speedy-Loot.lua          LOOT_READY handler, loot-window suppression, master-looter guard
│   ├── Diagnostics.lua          Read-only bug-report probes (events, API, loot method, dumps)
│   └── Minimap-Button.lua       LibDataBroker launcher, tooltip, click handlers
│
├── Options/
│   ├── Options.lua              Registers the three AceConfig panels; /os slash command
│   ├── Options-General.lua      Main settings panel (toggles, links, version)
│   ├── Options-Utilities.lua    Shared header/description/spacer widget builders
│   ├── Options-Profiles.lua     Stock AceDBOptions-3.0 profiles table, returned as-is
│   └── Options-Diagnostics.lua  Gated diagnostics panel wiring the Diagnostics.lua probes
│
├── Locales/
│   ├── enUS.lua                 Source of truth (NewLocale ..., true)
│   └── deDE/esES/esMX/frFR/     Translations; fall back to enUS via AceLocale __index
│       itIT/koKR/ptBR/ruRU/
│       zhCN/zhTW.lua
│
└── Includes/
    ├── Images/Open-Sesame.tga   Add-on icon
    └── Libraries/               Embedded Ace3 stack, LibStub, CallbackHandler,
                                 LibDataBroker-1.1, LibDBIcon-1.0
```

No deprecated or dead files are present. Every `Features/`, `Options/`, and `Data/` file is listed in the TOC load order.

## Architecture

### Event Loop

A single hidden frame in [Core.lua](Features/Core.lua) owns every event. Its `OnEvent` script logs the event when diagnostics logging is active, then dispatches to a handler keyed by event name in the `EventHandlers` table. Handlers are plain functions (or shared aliases such as `EventHandlers.BAG_UPDATE_DELAYED = OnScanRequest`); nothing else registers events directly.

Registration is driven from the `EventHandlers` table itself, so the frame can never listen for an event that has no handler and vice versa:

- `ns.EVENT_NAMES` is built by iterating `EventHandlers`, sorted, and exported so [Diagnostics.lua](Features/Diagnostics.lua) probes the exact set the add-on uses.
- Registration walks the same keys and calls `C_EventUtils.IsEventValid` first (falling back to a `pcall`-guarded `RegisterEvent`), so an event name absent on a future client build is skipped instead of aborting the loop.

Most bag/loot events funnel into `OnScanRequest → ScheduleScan()`, which debounces (see below). Interaction-close events (`MERCHANT_CLOSED`, `MAIL_CLOSED`, `BANKFRAME_CLOSED`, `GOSSIP_CLOSED`, `QUEST_FINISHED`, `PLAYER_INTERACTION_MANAGER_FRAME_HIDE`) share `OnInteractionClosed`, which forces an immediate rescan and flushes any held status message.

### Combat & Safety Gating

Open Sesame never uses protected macros, so there is no dirty-flag/replay pattern. Instead, all opening funnels through `IsSafeToOpen()`, which refuses to act while any of these hold: the add-on is disabled or paused, the player is in combat (`UnitAffectingCombat`), a merchant/mail/trade/bank/guild-bank/auction/gossip/quest/static-popup frame is open (`IsInteractionActive`), the player is stealthed (`IsStealthed` **or** carrying the Shadowmeld aura — see [Common Pitfalls](#common-pitfalls)), a cast or channel is in progress, or a genuine item tooltip is showing.

Combat itself is handled by deferral rather than a queue replay: the open tick simply stops firing while `IsSafeToOpen` is false, and `PLAYER_REGEN_ENABLED` forces a fresh scan the moment combat ends. `UPDATE_STEALTH` does the same when the player leaves stealth. This keeps the design free of any combat-lockdown taint surface.

### Scan → Queue → Open

The pipeline lives entirely in [Core.lua](Features/Core.lua) and runs in three phases:

1. **Scan** — `ScheduleScan(force)` debounces bag churn. Unforced calls coalesce inside `ns.SCAN_DEBOUNCE` (0.5s) using a pending flag and a timestamp; only the newest request survives. Forced calls (profile apply, combat end, pick-lock settle, interaction close) run immediately. Each run recomputes free slots, updates the pause state with hysteresis, and — if enabled — rebuilds the queue.
2. **Queue** — `BuildQueue()` walks bags 0–4, resolves each slot's item ID via `SafeFastItemID`, and pushes it when `ns.AllowedItems[id]` is `true` (open now) or `false` **and** the tooltip does not report the item as `LOCKED`. The queue is a flat array of `(bag, slot, itemId)` triples with head/tail cursors, wiped and reset when drained.
3. **Open** — `OpenTick()` fires every `ns.OPEN_TICK_INTERVAL` (0.25s). It re-verifies safety, pops one triple, confirms the slot still holds the cached item ID, calls `UseContainerItem`, then schedules a recheck after `ns.OPEN_RECHECK_DELAY` to requeue the slot if the item survived (a locked box that produced another openable, etc.). A single `openTimerLive` flag prevents overlapping tick chains.

### Item Identity Caching

Open Sesame keys everything off numeric item IDs, not `GetItemInfo`. `SafeFastItemID(bag, slot)` first tries `ns.GetContainerItemID` (synchronous, never a cold-cache nil), and only if that returns nil falls back to parsing the item ID out of `ns.GetContainerItemLink`. Because the ID comes straight from the container API, there is no asynchronous `GetItemInfo` cold-call to guard and no per-item cache to invalidate. The eligibility data — `ns.AllowedItems` and `ns.IgnoreItems` in [Data.lua](Data/Data.lua) — is a compile-time constant, not a runtime cache.

The container API references themselves are resolved once in [Utilities.lua](Features/Utilities.lua): each `ns.GetContainer*` upvalue picks `C_Container.X` on modern builds or the legacy global `X` where the namespace is absent. The selection stores a function *reference* (never a call result), so it sidesteps the truthy-fallthrough trap that bans `or` between call results.

## Auto-Opening Queue

The queue deliberately handles two kinds of items differently, encoded by the value in `ns.AllowedItems`:

- `true` — safe to open on sight (clams, coin pouches, gift boxes). Queued whenever present.
- `false` — a lockbox or locked chest. Queued **only once the client reports it unlocked**, detected by scanning the item's tooltip lines for the global `LOCKED` string (`IsItemLocked`). Until then it sits in the bag.

When Auto Loot delivers a still-locked box, the `false` entry is skipped, so it waits. Two events re-trigger a scan so a freshly unlocked box opens without waiting for the next bag update:

- `UNIT_SPELLCAST_SUCCEEDED` for the player's own **Pick Lock** (spell 1804) → rescan after `ns.PICK_LOCK_RESCAN_DELAY` (0.5s settle).
- `TRADE_CLOSED` → immediate rescan **plus** a second forced scan after the same settle delay, because another rogue picking locks on boxes in the trade window fires no event on our side and the unlocked state often has not settled client-side when `TRADE_CLOSED` arrives.

`ITEM_WILL_AUTO_OPEN` is printed (when lockbox notifications are on) the first time a `false` item is looted, so the player knows it is queued rather than ignored.

## Speedy Loot

[Speedy-Loot.lua](Features/Speedy-Loot.lua) loots corpses instantly and hides the loot window. The non-obvious parts:

**Window suppression via `OnShow`.** A plain `LootFrame:Hide()` on `LOOT_READY` is a no-op — the frame is not shown yet, and the default UI shows it on `LOOT_OPENED` with nothing to re-hide it, which is what produces the ~0.5s flash. Instead a one-time `HookScript("OnShow", …)` re-hides the frame the instant the default UI shows it, but only when `suppressLootWindow` is set. That flag is set to `not leftBehind` — true only when the pass took *everything*. Anything left behind (a lockbox we open by hand, or items skipped because bags filled mid-loop) keeps the window visible via an explicit `LootFrame:Show()`.

**`suppressLootWindow` reset on `LOOT_CLOSED`.** Because `LOOT_READY` can be throttled, one corpse's "fully looted" verdict must not carry onto the next corpse's unlooted window. Core's `LOOT_CLOSED` handler calls `ns.ResetSpeedyLootWindow()` to clear it.

**Master-looter stand-down.** When the player is the master looter (`lootMethod == "master"` and `masterLooterPartyID == 0`), Speedy Loot does nothing: threshold items flow through the ML window and calling `LootSlot` on one pops `MasterLooterFrame_Show` with no selection, which crashes on a nil `colorInfo` on some clients. Loot method is read through `GetLootMethodCompat`, which normalizes the legacy string API and the enum-returning `C_PartyInfo.GetLootMethod` (mapping enum `2` → `"master"` since `Enum.LootMethod` is nil on some Classic builds).

**Bag-full safety.** Money and currency slots (`IsItemLootSlot` false) take no bag space and are always looted. Real item slots are only taken while `freeSlots > 0`; if general bags are full and real items wait, the pass loots nothing and leaves the window open so items can be taken by hand. Ignored items (`ns.IgnoreItems`) are left in the window with an `ITEM_OPEN_MANUALLY` notice (throttled to once per 5s per item).

## Loot Sounds

The rare-loot sound must fire only for loot pulled from a corpse, chest, or node — never for disenchanting, prospecting/milling, container opens, or the server's white-into-green merge, all of which travel the same `LOOT_OPENED` + `CHAT_MSG_LOOT` path. They are distinguished by the **loot source GUID**:

- `CurrentLootFromWorldSource()` classifies the open loot window as `"world"` (a `Creature-`/`Vehicle-`/`GameObject-` source), `"item"` (every source is `Item-`), or `"unknown"` (source info not yet populated).
- `StampWorldLoot()` — run on both `LOOT_READY` and `LOOT_OPENED`, because the GUID can populate on either and Speedy Loot may empty the slots between them — records `lastWorldLootAt` on `"world"`, clears it on `"item"`, and leaves it alone on `"unknown"` (a late-arriving world GUID must still be able to stamp, and a just-set stamp must survive an empty re-read).
- `CHAT_MSG_LOOT` plays `ns.LOOT_SOUND_ID` (2847) only if loot sounds are enabled, the stamp is within `ns.LOOT_SOUND_WINDOW` (1s), and the item link's color code is not gray (`9d9d9d`, poor) or white (`ffffff`, common).

## Pause / Resume & the Status Channel

Auto-Opening pauses itself when bag space runs low, with hysteresis to avoid flapping: `ShouldPause` pauses below `ns.MIN_FREE_SLOTS` (4) but only resumes once free slots reach `MIN_FREE_SLOTS + 1`. The resume message therefore formats with `MIN_FREE_SLOTS + 1`, not `MIN_FREE_SLOTS`, so it does not promise a threshold that still leaves the player paused.

A hard `UI_ERROR_MESSAGE` "inventory full" forces an immediate pause and plays a race/gender-specific "bags full" sound (`ns.RACE_SOUNDS`, falling back to `ns.BAG_FULL_SOUND_FALLBACK`), rate-limited by `ns.BAG_FULL_COOLDOWN` (10s).

Status prints go through `ns.StatusPrint` ([Announcements.lua](Features/Announcements.lua)), which:

- suppresses output during the **quiet window** (`ns.SetQuiet` / `IsQuiet`), raised on loading screens and login so transient churn stays silent;
- dedupes an identical message within 5 seconds;
- is held while an interaction frame is open — `AnnounceStatus` returns early if `IsInteractionActive`, and `OnInteractionClosed` flushes the held message after `ns.STATUS_FLUSH_DELAY` so a "Resumed" is not lost in the player's vendoring. `ns.state.announcedPaused` tracks what the player was last told.

## Minimap Button

[Minimap-Button.lua](Features/Minimap-Button.lua) registers a LibDataBroker launcher and shows it through LibDBIcon-1.0. The icon swaps between `on` / `paused` / `off` textures (`ns.ICONS`) to mirror runtime state. Clicks: **left** toggles Auto-Opening, **right** toggles Speedy Loot, **middle** toggles Loot Sounds, **Shift+middle** opens the options panel (checked first).

`showMinimap` (a profile setting) is the source of truth for visibility; the LibDBIcon `hide` field is kept inverted in sync. The minimap *position* lives in `ns.db.global.minimap` (account-wide, profile-independent), so switching or resetting a profile never moves the button — and `PLAYER_LOGIN` re-derives `hide` from `showMinimap` so a profile reset restores the button.

## Diagnostics Panel

[Diagnostics.lua](Features/Diagnostics.lua) generates bug-report text, not unit tests — WoW's sandboxed Lua has no assertion runner. Everything is read-only and side-effect free except the explicit Taint Log button, which sets the `taintLog` CVar. Reports build only on a button press. A single runtime toggle (`ns.diagnostics.enabled`, **not** a SavedVariable) gates the whole panel.

The probes: event log (bounded ring buffer, arguments snapshotted to escaped strings), event registration check (over `ns.EVENT_NAMES`), API endpoint existence checks (kept aligned with the guards in Utilities/Core/Speedy-Loot), a live loot-method report, installed add-on list, saved-variables dump, library versions, and the taint-log toggle. Diagnostics strings live in `ns.DiagnosticsStrings` and are intentionally **not** localized — they are developer-facing.

## Auto Loot Enforcement

Speedy Loot and Auto-Opening both depend on the game's Auto Loot. `ns.EnsureAutoLoot()` sets the `autoLootDefault` CVar to `1` and prints `AUTO_LOOT_ENABLED` if it was off. It runs on profile apply, on the toggles that need it, and on world entry. The CVar accessors are picked by availability (`C_CVar.GetCVarBool` / `SetCVar` vs. the legacy globals).

## Saved Variables

The single SavedVariables table is **`OpenSesameDB`** (declared in [Open-Sesame.toc](Open-Sesame.toc)), managed by AceDB-3.0.

- **`profile`** — per-profile user settings: `autoOpen`, `speedyLoot`, `lootSounds`, `showWelcome`, `showMinimap`, `lockboxNotifications`.
- **`global`** — account-wide, profile-independent state: `minimap` (the LibDBIcon position/`hide` subtable). Kept in `global` so switching or resetting a profile never moves the minimap button.

### Migration Chain

There is one migration, run inline in `EventHandlers:PLAYER_LOGIN` immediately after `AceDB:New` (there are no numbered `MigrateXxx` functions):

- **Flat → AceDB (remove after 2026-10-06)** — the pre-AceDB build stored each setting as a flat top-level key on `OpenSesameDB` and the minimap position at `OpenSesameDB.minimap`. AceDB leaves unknown top-level keys untouched, so the migration lifts the known flat keys into `ns.db.profile`, lifts the `minimap` table into `ns.db.global.minimap`, and clears the originals so leftover state can't shadow future edits.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied lazily by AceDB-3.0 via metatables — nothing is copied into the saved table, and explicit user values (including `false`) are never overridden.

There is no refill-on-empty logic: the openable/ignored item lists (`ns.AllowedItems`, `ns.IgnoreItems`) are compile-time constants in [Data.lua](Data/Data.lua), not saved variables, so there is no user-editable list to re-seed.

## Adding a New Openable Item

1. Open [Data/Data.lua](Data/Data.lua) and find `ns.AllowedItems`.
2. Add `[itemId] = true` for an item safe to open on sight, or `[itemId] = false` for a lockbox/locked chest that must be unlocked first.
3. Place it in the correct expansion block (`01. World of Warcraft`, `02. The Burning Crusade`, `03. Wrath of the Lich King`) and keep the block alphabetized by the trailing `-- Item Name` comment.
4. Nothing else to wire — `BuildQueue` reads the table directly.

## Adding an Ignored Item

Add `[itemId] = true` to `ns.IgnoreItems` in [Data/Data.lua](Data/Data.lua). Speedy Loot will leave the item in the loot window with an `ITEM_OPEN_MANUALLY` notice instead of auto-looting it — used for items that are Unique, Bind on Pickup, temporary, or raid-boss drops.

## Adding a New Registered Event

1. In [Features/Core.lua](Features/Core.lua), add a handler: either `function EventHandlers:EVENT_NAME(...)` or an alias to an existing helper (`EventHandlers.EVENT_NAME = OnScanRequest`).
2. That is the only step. The registration loop and `ns.EVENT_NAMES` (used by the diagnostics probe) are both derived from the `EventHandlers` table, so the dispatcher, the client-validity guard, and diagnostics all pick the new event up together.

## Localization

Strings are localized through AceLocale-3.0. Locale files live in `Locales/<locale>.lua`, each registered with `NewLocale("Open-Sesame", "<locale>")`.

- **Source of truth** — [Locales/enUS.lua](Locales/enUS.lua) is the only file that passes the `true` default-fallback flag. Every key originates there; the other locales translate the same key set.
- **Keeping locales in sync** — at runtime AceLocale falls back to English via `__index` for any missing key, so a locale can lag without crashing. Translating each `enUS.lua` key into every locale and keeping the files aligned is the job of the Localization pass — don't hand-edit the other locales during ordinary work.
- **Placeholders** — `%s`/`%d` count, type, and order must match `enUS` per key in every locale, or `string.format` errors at runtime. Keys carrying format args here include `CHAT_LOADED` (`%s`), `PAUSED_BAG_SLOTS` (`%d`), `AUTO_OPENING_DESC` (`%d`), `ITEM_WILL_AUTO_OPEN` (`%s`), and `ITEM_OPEN_MANUALLY` (`%s`).
- **Spanish** — esES and esMX are plain, fully translated `NewLocale` files, the same as every other locale. There is no shared Spanish `strings` table.
- **Diagnostics strings are not localized** — `ns.DiagnosticsStrings` is developer-facing English only, kept out of `Locales/` entirely.

WoW ships a fixed locale set and every supported locale file already exists (`deDE`, `esES`, `esMX`, `frFR`, `itIT`, `koKR`, `ptBR`, `ruRU`, `zhCN`, `zhTW`), so there is no "add a new locale" step — this is maintenance, not expansion.

## Common Pitfalls

- **Hiding the loot window on `LOOT_READY`**: a no-op — the frame isn't shown yet, so the default UI shows it afterward with nothing to re-hide it (the flash). Always suppress through the `LootFrame` `OnShow` hook gated by `suppressLootWindow`.
- **Carrying a "fully looted" verdict across corpses**: a throttled `LOOT_READY` can reuse the previous corpse's `suppressLootWindow`. `LOOT_CLOSED` must reset it via `ns.ResetSpeedyLootWindow`.
- **Looting while master looter**: calling `LootSlot` on a threshold item crashes on a nil `colorInfo` on some clients. The `lootMethod == "master" and masterLooterPartyID == 0` guard stands the whole pass down.
- **Trusting `IsStealthed` alone**: Night Elf **Shadowmeld** does not always register through `IsStealthed`, so `IsPlayerStealthed` also scans buffs for the Shadowmeld aura (spell 20580). Auto-opening while stealthed would break stealth.
- **Comparing the loot method enum to `"master"`**: `C_PartyInfo.GetLootMethod` returns a number, not the legacy string. Always go through `GetLootMethodCompat`, which maps enum `2` → `"master"`.
- **`or` between two API *calls*** for compat fallbacks: falls through whenever the modern call legitimately returns `false` (e.g. auto-loot off). Select the function *reference* with `or` (Utilities.lua) or branch on availability with an `if` (Speedy-Loot.lua / Announcements.lua).
- **Resume threshold off-by-one**: the pause hysteresis resumes at `MIN_FREE_SLOTS + 1`. The `PAUSED_BAG_SLOTS` message must format with `+ 1` or it promises a slot count that still leaves the player paused.
- **Item-produced loot playing the rare sound**: disenchant/prospect/merge share the corpse loot path. Only a `"world"` GUID stamps `lastWorldLootAt`; never widen the stamp to `"unknown"`.

## Contributing

- **Issues** — open them on the [GitHub Issues tab](https://github.com/Gogo1951/Open-Sesame/issues).
- **Bug reports** — include game version + locale, class + level, repro steps, and relevant chat output. The Diagnostics panel (enable it, then run the relevant probe) generates a report header with all of the client/build/locale details.
- **Discord** — [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **PR guidelines** — keep changes tightly scoped; match the surrounding code style; respect migration discipline (leave the dated flat→AceDB block until its removal date, and never hand-merge defaults around AceDB); keep placeholder counts aligned across locales; and update this document if the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X" or "I fixed Y." Frame the change in terms of who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a rogue trading locked boxes to a guildmate to crack, I wanted the boxes to open on their own once unlocked without waiting on a bag event. This change adds a second forced rescan after `TRADE_CLOSED` on the pick-lock settle delay.*

  The User Story makes review faster and gives future maintainers context the diff alone won't carry.

## Guide Feedback

Generated on 2026-07-08 after performing README-Technical generation on Open Sesame.

- **Drop the Spanish shared-`strings`-table rule (maintainer-confirmed).** The guide's Localization section says *"esES/esMX use the style guide's shared-`strings`-table pattern; reference it rather than duplicating strings."* Spanish locales are no longer shared — [Locales/esES.lua](Locales/esES.lua) and [Locales/esMX.lua](Locales/esMX.lua) are plain, fully translated `NewLocale` files like every other locale (verified: no `strings` reference in any locale file). Suggested edit: delete the Spanish bullet from the guide (and the corresponding note in the Style Guide), since it now documents a pattern the codebase doesn't use and will otherwise be re-flagged every run.
- **Remove "Adding a New Locale" from the guide and the live references (maintainer-confirmed).** The guide already treats localization as maintenance-not-expansion, but the live reference [Connoisseur/README-Technical.md](https://github.com/Gogo1951/Connoisseur/blob/main/README-Technical.md) still ships an `## Adding a New Locale` section, so a future run that copies the reference structure will reintroduce it. Suggested edit: drop the `## Adding a New Locale` section from the Connoisseur and Water-Dispenser references so the guide and references agree.
