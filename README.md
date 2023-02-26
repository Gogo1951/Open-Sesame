# Automatic Open

Just a simple add-on that does what the title says.

⚙️ Automatically opens containers in your inventory under the following conditions:

- You are not in combat (anything looted during combat will be opened as soon as combat is over).
- You are not actively trying to loot something else.
- The container is not locked.
- The container did not drop off a raid boss.
- The container is Bind on Pickup (BoP), and is not tradable.
- The container is tradable, but does not contain a BoP item.
- The container is tradable, but does not contain a unique item.
- You do not have a Merchant Window Open.
- You do not have your Bank Window Open.
- You do not have your Guild Bank Window Open.
- You do not have your Mailbox Window Open.

### Game Version Notes

- **Retail** : Needs testing! Please report any issues you find!
- **Wreath Classic** : Good to go!
- **Classic** : Good to go!

### Download

⏬ Automatic Open on CurseForge : https://www.curseforge.com/wow/addons/automatic-open

⏬ Automatic Open on GitHub : https://github.com/Gogo1951/Automatic-Open

### How It Works

Automatic Open looks for items in your inventory [that are on the list](https://github.com/Gogo1951/Automatic-Open/blob/main/Automatic-Open.lua#L7) (containers that meet the above stated criteria), and runs [a public API call](https://wowpedia.fandom.com/wiki/API_C_Container.UseContainerItem) to open them as soon as they are detected. 

Automatic Open runs on less than 35kb of memory; it's very lightweight and won't impact performance. 

🚫 **Due to API changes in Wrath, "UseContainerItem" no longer works on clams. Likely has something to do with the "[Clam Weaving](https://www.youtube.com/watch?v=h3YO7jeoOWs)" hack.**

### Similar Add-ons & Weak Auras

👏 **I didn't create this add-on, I just updated it for TBC and Wrath.**

Looking around CurseForge, it looks like bulk of the original code came from kAutoOpen.

- [Auto Open Items](https://www.curseforge.com/wow/addons/auto-open-items)
- [AutoClam](https://www.curseforge.com/wow/addons/autoclam)
- [AutoOpen](https://www.curseforge.com/wow/addons/autoopen)
- [kAutoOpen Dragonflight](https://www.curseforge.com/wow/addons/kautoopen-dragonflight)
- [kAutoOpen](https://www.curseforge.com/wow/addons/kautoopen)
- [Openables (Weak Aura)](https://wago.io/gtRVJZetK)
