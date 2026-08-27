# Open Sesame // Manual Test Plan

This is the manual test plan for Open Sesame, the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Open-Sesame/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Open-Sesame/blob/main/README-Technical.md).

## Before you start

**Run the whole list on Classic Era, then `/reload` and run it again on TBC Anniversary.** Steps are numbered continuously so you can report "failed on step N."

Gather these once so you aren't caught short mid-run:

- **Both flavors installed** — Classic Era and TBC Anniversary. The add-on ships for both, and a run on one flavor is half a run.
- **A Rogue with Lockpicking trained.** Steps 7, 13 and 19 need one. Any skill level works — a rank far below what a box asks for is as useful a result as a rank above it.
- **A non-Rogue character**, any class, for step 8.
- **Openable containers in your bags** — clams are the easiest to come by (Small Barnacled Clam, Big-mouth Clam, Thick-shelled Clam), from fishing or murloc drops. Bring several; the add-on opens them as fast as you can stock them.
- **A locked box in your bags** — a Battered, Worn or Sturdy Junkbox from pickpocketing, or any Lockbox fished up or looted from humanoids. Bring two of the same kind if you can, for the stack count in step 9.
- **Something to kill and loot repeatedly**, for coin, greens, and a common drop you can farm (cloth, a grey trinket). Humanoids give you all of it at once.
- **Bag space you can fill and empty on demand** — vendor trash you're willing to carry, so you can drop below four free slots and climb back out.
- **A dungeon entrance you can zone into**, for step 10. You don't have to clear anything; walking in and back out is the whole test.
- **A non-English client** — only for the optional spot-check in step 24.

Unless a step says otherwise, be **out of combat, out of instances, and not stealthed**, with no vendor, mail, bank or trade window open. Every step in this plan works solo.

This plan deliberately skips the Loot Toasts appearance settings (font, size, outline, grow direction, alignment, seconds on screen, maximum rows, minimum quality, and the nine Always Show toggles), the Group hold-off, and the contents of the Loot Method, Relevant CVars and Display Context reports beyond confirming they produce text. Those are settings you judge by eye. The steps below cover the paths that break silently.

## Verify this release's changes

This release adds Loot Toasts, the Ignore List, Lockbox Tooltips, the Locked Items list on the mini-map tooltip, and the Auto-Opening Where hold-off; it moves the mini-map button from account-wide storage onto the profile, and narrows the loot sound to loot that came off a corpse or out of a chest. These thirteen steps are the ones that prove it.

**Loot Toasts**

**1.** Log in for the first time on this build. A dark panel must appear above the centre of your screen reading **Open Sesame Loot Toasts**, with the lines *"Click + Drag to Position"* and *"Right-Click to Lock"* and a **Disable Loot Toasts** button, and a stack of sample rows reading **Example Item** in assorted item colours with matching potion icons. Failure is no panel at all, a panel with no sample rows, or a panel with no way out of it — the feature ships turned on, so this introduction is the only warning a player gets before loot starts drawing on their screen.

**2.** Left-click and drag the panel somewhere you want it, then **right-click it**. The panel and its samples must vanish on the spot. Now go kill something and loot it. Rows must appear where you left the panel — the item's own icon, its name in its quality colour, an ` x2` suffix on a stack of more than one — and fade away on their own after about five seconds. Coin must get its own row, with a coin icon and an amount reading like *"1g 24s 07c"*. Failure is rows drawing in the old position or in the screen centre, rows that never fade, no row for coin, or the item name arriving as a bare number.

**3.** Type `/reload`. The introduction panel must **not** come back, and the next thing you loot must toast in the position you chose. Then open **Options → AddOns → Open Sesame → Notifications**, scroll to Loot Toasts, and click **Reset Position** — the panel's rows must return to the middle-top of the screen. Failure is the introduction reappearing on every reload (it is meant to be shown once per profile), or a position that resets itself.

**Ignore List**

**4.** Open **Options → AddOns → Open Sesame → Ignore List**. It must list shipped containers as real item links with icons, sorted by name, each with a red "no entry" note in its tooltip explaining why it's on the list. Failure is rows showing as bare item numbers that never resolve into names, or an empty list. **The list is longer on TBC Anniversary than on Classic Era by design** — containers a client has never heard of are left off it, so the two flavors are meant to differ here.

**5.** Pick a common thing you can farm — cloth, a grey drop — and add it: paste its item link (or its item ID) into the **Add Item** box and press Enter. It must appear as a row immediately. Now go kill something that drops it. Speedy Loot must **leave that item sitting in the loot window** for you to take by hand, and your chat must read *"[Item] was left in the loot window for you to open yourself."* Failure is the item being looted anyway, or being left behind with no explanation in chat.

**6.** Drop a clam into your bags and add **that** to the list too. It must sit in your bags **unopened** for as long as it's on the list. Then click **Restore Defaults** and confirm the prompt. Both items you added must be gone, the shipped rows must all be back, and the clam in your bags must now open on its own within a second or two. Failure is a clam that opens while it's on the list, a Restore Defaults that fires with no confirmation prompt, or one that leaves your own additions behind.

**Lockbox Tooltips**

**7.** On your Rogue, hover a locked box in your bags. Below the client's own lines there must be a block headed **Open Sesame** carrying a Lockpicking number — either *Requires Lockpicking* with what the box needs, or *Your Lockpicking* with the rank you have — coloured **green when your skill clears the box and red when it doesn't**. **Which of the two lines you get depends on the client**: the flavor that prints its own "Requires Lockpicking" line gets *Your Lockpicking* instead, so run this on both and expect them to differ. Failure is no block on a Rogue who plainly has the skill, both lines at once, or a colour that disagrees with the numbers.

**8.** Hover the same kind of box on your non-Rogue. There must be **no Open Sesame block at all** — the feature is set to Rogues only out of the box. Now open **Options → AddOns → Open Sesame → Lockboxes** and set **Show for** to **For All Characters**, then hover again: the requirement line must appear, in neutral white, with no rank of your own beside it. On the flavor that already prints its own requirement line there is deliberately nothing left to add and no block appears — that is correct, not a failure. Failure is a block showing on a non-Rogue while the setting still reads For Rogues.

**Locked Items on the mini-map tooltip**

**9.** With at least one locked box in your bags, hover the mini-map button. Above the Auto-Opening block there must be a **Locked Items** heading listing each waiting box — its icon, its name in the item's own colour, and an ` x2` count when you're carrying more than one of the same box. Have the Rogue pick one open and hover again: that row must be gone. Failure is the list missing while a locked box is plainly in your bags, a row that persists after the box is opened, or the list appearing with no locked boxes at all.

**Auto-Opening: Where**

**10.** Left-click the mini-map button to turn **Auto-Opening off**, put a clam in your bags, and walk into a dungeon. Open the main panel, set **Where** to **Outside Instances**, then turn Auto-Opening back on. The clam must stay shut for as long as you're inside. Walk back out — it must open on its own within a couple of seconds, with no bag click and no reload. Failure is the clam opening inside the instance, or staying shut after you leave.

**Mini-map button now lives on the profile**

**11.** On the main panel, untick **Enable Mini-map Button**. The button must disappear immediately. Now go to **Profiles** and click **Reset Profile**. The mini-map button must come back **on its own, without a `/reload`**, and the Enable Mini-map Button box must show ticked again the moment you click back to the main panel. Failure is the button staying hidden until you reload, or the checkbox disagreeing with what's on your mini-map.

**Loot sound narrowed to corpse and chest loot**

**12.** With Loot Sounds on, kill mobs until an Uncommon (green) or better drops. A single chime must play as it lands. Then have your Rogue open a junkbox, or open a clam, that yields a green: **no chime may play**, because that item came out of a container rather than off a corpse. Failure is a chime on box or clam contents, a chime on a white or grey item off a corpse, or no chime at all on a green off a corpse.

**Pick Pocket sound**

**13.** On your Rogue, stealth up and pickpocket a humanoid that has something in its pockets. A bag-rustle sound must play once as the loot arrives. Pickpocket the same target again, now that its pockets are empty: the cast succeeds and **nothing may sound**. Failure is silence on a successful pick, a sound on an already-picked target, or the same pick sounding twice.

When steps 1–13 pass on both flavors, this release's changes are verified. Run the rest of the plan, then proceed to `4 - Pre-Launch Review Prompt.md`.

## Core checks

**14.** Log in with Open Sesame enabled. No Lua error window may appear and no red error text may print. A welcome line must print, coloured, in the shape *"Open Sesame // Version … Settings … can be found under Options > AddOns > Open Sesame."* — reading a real dated version in a packaged build, or **Dev** in an unpackaged working copy. If your Auto Loot setting was off, one extra line reads *"Auto Loot has been enabled. Open Sesame requires it to function."*, which is correct. Then type `/reload`: the UI must come back clean and the welcome line must print again. Failure is any error naming Open Sesame, a missing or uncoloured welcome line, or a line containing `nil` or a stray `%s`.

**15.** Open the settings three ways: type **`/os`** (the add-on's only slash command), **Shift + Middle-Click** the mini-map button, and press `Esc` → **Options** → **AddOns** → **Open Sesame**. All three must land you in the same place: the settings **docked inside the Blizzard Options window**, with Open Sesame selected in the category list on the left and five entries beneath it in this order — **Notifications**, **Lockboxes**, **Ignore List**, **Profiles**, **Diagnostic Tools**. Failure is nothing happening, or a standalone window floating free of the Options frame. **TBC Anniversary is the flavor that historically breaks this**, so a tester who ran only Era has not finished this step.

**16.** Pull a mob, and while still in combat type **`/os`**, then Shift + Middle-Click the mini-map button. Each must print *"As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must **not** open. Kill the mob and stand still: the panel must not open by itself once combat ends. Failure is the panel opening, silence with no message, or a red `ADDON_ACTION_BLOCKED` error naming Open Sesame.

**17.** Hover the mini-map button and read its three keybind lines, then try each. **Left-Click** must toggle Auto-Opening, **Right-Click** must toggle Speedy Loot, **Middle-Click** must toggle Loot Sound. After each click the tooltip must re-draw in place with that feature's state flipped between **Enabled** and **Disabled**, and the button's icon must follow Auto-Opening: green bag on, red bag off, black bag paused. Failure is a click doing something other than what its line says, a state that doesn't update until you move the cursor away, or an icon that disagrees with the tooltip.

**18.** With Auto-Opening on, put several clams in your bags. They must open one after another with no clicks from you, over a second or two. Now fill your bags until you have **fewer than four free slots**: chat must read *"Auto-Opening is Paused until you have at least 4 empty bag slots."*, the mini-map icon must go black, and nothing more may open. Free a slot: chat must read *"Auto-Opening has Resumed."* and the remaining clams must open. Failure is clams sitting unopened with slots to spare, opening while paused, or a pause message that never resolves into a resume.

**19.** Loot a locked box on your Rogue. Chat must read *"[Box] will be automatically opened once it's unlocked."* — on a non-Rogue this message is deliberately silent unless you set **Lockboxes → Show for** to For All Characters. Now pick the box open. It must open itself and hand you its contents within a second or so of the lock coming off, with no second click from you. Failure is the box sitting there unopened after it's unlocked, or the notice naming the wrong item.

**20.** With Speedy Loot on, loot a corpse. The loot window must **never appear at all** — not even a flash — and everything, coin included, must land in your bags. Now fill your bags completely and loot a corpse holding real items: the loot window must **stay up** with those items still in it, so you can take them by hand. Failure is a loot window flashing for half a second on every corpse, or a window hidden while loot is still stranded in it.

**21.** With a clam in your bags, try each of these in turn: pull a mob and fight, sit down and eat or drink, and open a vendor or mailbox window. **Nothing may open** in any of the three. Then leave combat, stand up, and close the window — the clam must open on its own within a second or two. Failure is a clam opening mid-fight, opening while a merchant window is up, or never opening once you're clear.

**22.** Read the add-on's chat lines back — the four you've now seen, about a box waiting to be unlocked, an item left in the loot window, an item on your Ignore List, and Auto-Opening pausing. Every one must be branded **Open Sesame //**, read as one complete sentence, and carry a **clickable item link** where an item is named, with the count in the pause line reading as a real number. Nothing this add-on prints is ever sent to another player, so nothing here should show up in any chat channel. Failure is `nil` or a stray `%s` or `%d` in a line, a raw `|cff…|Hitem:` sequence showing as text instead of a link, or the same line repeating over and over as your bags update.

**23.** Open **Diagnostic Tools**. Only the warning paragraph and the **Enable Diagnostic Tools** toggle may be visible, and the toggle must be **off**. Tick it: eleven sections must appear without reopening the panel — Event Log, Event Registration, API Endpoints, Loot Method, Other Add-ons, Relevant CVars, Display Context, Saved Variables, Library Versions, Taint Log, and External Tools. Click **Start Event Log**, then go fill your bags and loot something so the game tells you your inventory is full, and also spam an ability off cooldown a dozen times so the game prints red combat errors that have nothing to do with looting. Come back and click **Show Captured Events**. The inventory-full firing must appear as a **full timestamped line**; the combat errors must **not** appear as individual lines but as counted rows in the block at the end reading **"Suppressed uncorrelated traffic:"**, one row per error in the shape `UI_ERROR_MESSAGE(56, Ability is not ready yet.) x12`. Click each remaining report button in turn — every one must fill its box with readable text rather than an error or a blank. Untick the toggle: everything below it must vanish at once. Then `/reload` and reopen the panel — the toggle must be **off** again, because diagnostics never persists between sessions. Failure is the gate on by default, combat spam flooding the log as individual lines, the inventory-full firing being swallowed into the summary, or diagnostics surviving a reload.

**24.** *Optional, and only worth running on a non-English client.* Log in on one and open every panel. Every label, description and note must render in that language — failure is a raw key like `OPTIONS_ENABLE_LOOT_TOASTS` or `LOCKBOXES_DESCRIPTION` showing on screen instead of words. Then trigger the pause message and an item message: the number and the item name must land inside sensible sentences, with no `nil` and no leftover `%s` or `%d`. Loot coin and read the money toast — the amounts must carry that client's own gold, silver and copper symbols. Finally, hover a locked box on a Rogue: the Lockpicking block must name the skill exactly as that client spells it. **That last one is the highest-risk check here** — the skill name is read from the client rather than translated by the add-on, and when it doesn't match, the block simply never appears, with no error to warn you.

When every step passes on both Classic Era and TBC Anniversary, manual testing is complete. Proceed to `4 - Pre-Launch Review Prompt.md`.
