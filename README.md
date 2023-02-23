# Automatic Open (Wrath Classic)

Just a simple add-on that does what the title says.

⚙️ Automatically opens containers in your inventory under the following conditions:

- You are not in combat.
- You are not actively trying to loot something else.
- The container is not locked.
- The container did not drop off a raid boss.
- The container is tradable, but does not contain a BoP item.
- The container is tradable, but does not contain a unique item.
- You do not have a Merchant Window Open.
- You do not have your Bank Window Open.
- You do not have your Guild Bank Window Open.
- You do not have your Mailbox Window Open.

### Download

⏬ Auto Open Items on CurseForge : https://www.curseforge.com/wow/addons/automatic-open-wrath-classic

⏬ Auto Open Items on GitHub : https://github.com/Gogo1951/Automatic-Open

### How It Works

AutoOpenItems looks for items in your inventory [that are on the list](https://github.com/Gogo1951/Automatic-Open/blob/main/AutoOpenItems.lua#L7) (containers that meet the above stated criteria), and runs [a public API call](https://wowpedia.fandom.com/wiki/API_C_Container.UseContainerItem) to open them as soon as they are detected. AutoOpenItems runs on less than 3kb of memory; it's very lightweight and won't impact performance. 

🚫 **Due to API changes in Wrath, "UseContainerItem" no longer works on clams. Likely has something to do with the "[Clam Weaving](https://www.youtube.com/watch?v=h3YO7jeoOWs)" hack.**

### Similar Add-ons

👏 **I didn't create this add-on, I just updated it for TBC and Wrath.**

Looking around CurseForge, it looks like bulk of the original code came from kAutoOpen.

- https://beta.curseforge.com/wow/addons/auto-open-items
- https://beta.curseforge.com/wow/addons/autoclam
- https://beta.curseforge.com/wow/addons/autoopen
- https://beta.curseforge.com/wow/addons/kautoopen
- https://beta.curseforge.com/wow/addons/kautoopen-dragonflight
