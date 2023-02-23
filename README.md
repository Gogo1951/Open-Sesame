# AutoOpenItems

Just a simple add-on that does what the title says.

⚙️ Automatically opens containers in your inventory under the following conditions:

- You are not in combat.
- The container is not locked.
- The container did not drop off a raid boss.
- The container is tradable, but does not contain a BoP item.
- The container is tradable, but does not contain a unique item.
- You do not have a Merchant Window Open.
- You do not have your Bank Window Open.
- You do not have your Guild Bank Window Open.
- You do not have your Mailbox Window Open.

### Download

⏬ Auto Open Items on CurseForge : https://beta.curseforge.com/wow/addons/auto-open-items

### How It Works

AutoOpenItems looks for items on a whitelist (containers that meet the above stated criteria), and runs a "UseContainerItem" on those items to open them as soon as they land in your inventory. 

- https://wowpedia.fandom.com/wiki/API_C_Container.UseContainerItem

🚫 NOTE: Due to API changes in Wrath, "UseContainerItem" no longer works on clams. Likely has something to do with the "Clam Weaving" hack.

- https://www.youtube.com/watch?v=h3YO7jeoOWs

### Similar Add-ons

👏 **NOTE: I didn't create this add-on, I just updated it for TBC and Wrath.**

Looking around CurseForge, it looks like code originated from kAutoOpen.

- https://beta.curseforge.com/wow/addons/kautoopen
- https://beta.curseforge.com/wow/addons/kautoopen-dragonflight
- https://beta.curseforge.com/wow/addons/autoopen
- https://beta.curseforge.com/wow/addons/autoclam
