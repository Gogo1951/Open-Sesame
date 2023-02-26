# Open Sesame!

Just a simple add-on that automatically opens containers in your inventory.

<br>

⚙️ Works under the following conditions:

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

<br>

### Game Version Notes

- 🚧 **Retail** : Needs testing! Please report any issues you find!
- ✅ **Wreath Classic** : Good to go!
- ✅ **Classic Era** : Good to go!

<br>

### Download

⏬ Open Sesame! on CurseForge : https://www.curseforge.com/wow/addons/open-sesame

⏬ Open Sesame! on GitHub : https://github.com/Gogo1951/Open-Sesame

<br>

### How It Works

Open Sesame! looks for items in your inventory [that are on the list](https://github.com/Gogo1951/Open-Sesame/blob/main/Automatic-Open.lua#L7) (containers that meet the above stated criteria), and runs [a public API call](https://wowpedia.fandom.com/wiki/API_C_Container.UseContainerItem) to open them as soon as they are detected. 

Open Sesame! runs on less than 35kb of memory; it's very lightweight and won't impact performance. 

🚫 **Due to API changes in Wrath Classic, "UseContainerItem" no longer works on clams. This likely has something to do with the "[Clam Weaving](https://www.youtube.com/watch?v=h3YO7jeoOWs)" hack.**

<br>

### Similar Add-ons & Weak Auras

👏 **I didn't create this add-on, I just updated it for TBC and Wrath.**

Looking around CurseForge, it looks like the bulk of the original code came from kAutoOpen.

- [Auto Open Items](https://www.curseforge.com/wow/addons/auto-open-items)
- [AutoClam](https://www.curseforge.com/wow/addons/autoclam)
- [AutoOpen](https://www.curseforge.com/wow/addons/autoopen)
- [kAutoOpen Dragonflight](https://www.curseforge.com/wow/addons/kautoopen-dragonflight)
- [kAutoOpen](https://www.curseforge.com/wow/addons/kautoopen)
- [Openables (Weak Aura)](https://wago.io/gtRVJZetK)
