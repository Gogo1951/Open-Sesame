local _, ns = ...

--------------------------------------------------------------------------------
-- API References
--------------------------------------------------------------------------------

local GetTime = GetTime

--------------------------------------------------------------------------------
-- Loot Source
--------------------------------------------------------------------------------

--[[
    Distinguishes genuine corpse/chest looting from item-produced loot. A loot
    window alone is not enough: disenchanting, prospecting/milling, opening a
    container, and the server's white-into-green item merge all deliver their
    results through the same LOOT_OPENED + CHAT_MSG_LOOT path a corpse does. They
    differ only in the loot source GUID — an item carries an "Item-..." source,
    a corpse is "Creature-..."/"Vehicle-...", and a chest/node is "GameObject-...".

    Returns one of three states so StampWorldLoot can treat each differently:
    "world" when at least one open slot is a corpse/chest/node
    (Creature-/Vehicle-/GameObject-); "item" when every resolved source is an
    item (Item-) — disenchant, prospect/mill, container open, or the
    white-into-green merge; and "unknown" when there is nothing to go on yet,
    i.e. the window is empty or the GUIDs have not populated. "unknown" is kept
    distinct from "item" on purpose: source info can arrive late (and Speedy Loot
    may loot instantly), so a not-yet-populated corpse must not be mistaken for
    item loot.
]]
local function CurrentLootFromWorldSource()
	local numItems = GetNumLootItems()
	local sawItem = false
	for slot = 1, numItems do
		local guid = GetLootSourceInfo(slot)
		local guidType = guid and guid:match("^(%a+)")
		if guidType == "Creature" or guidType == "Vehicle" or guidType == "GameObject" then
			return "world"
		elseif guidType == "Item" then
			sawItem = true
		end
	end
	if sawItem then
		return "item"
	end
	return "unknown"
end

--[[
    Open the window the loot sound may play in, which stays open as long as the
    corpse or chest's loot window does, so a Bind on Pickup item confirmed or an
    item looted by hand seconds later still sounds:

      world   - open it. Run on both LOOT_READY and LOOT_OPENED because the
                source GUID can populate on either and Speedy Loot may empty the
                slots between them; whichever event sees the world GUID opens it.
      item    - close it outright so a disenchant or merge just after a real
                corpse loot can't reuse that window and play the sound.
      unknown - leave it alone: a late-arriving world GUID on a later event must
                still be able to open it, and one just opened for this same
                corpse must survive an empty or not-yet-populated re-read.
]]
function ns.StampWorldLoot()
	local source = CurrentLootFromWorldSource()
	if source == "world" then
		ns.state.worldLootOpen = true
	elseif source == "item" then
		ns.state.worldLootOpen = false
		ns.state.worldLootClosedAt = 0
	end
end

-- Called from Core's LOOT_CLOSED: loot lines can land just after the window shuts.
function ns.CloseWorldLoot()
	if ns.state.worldLootOpen then
		ns.state.worldLootOpen = false
		ns.state.worldLootClosedAt = GetTime()
	end
end

--------------------------------------------------------------------------------
-- Loot Sound
--------------------------------------------------------------------------------

--[[
    Only sound off for loot that came from a corpse or chest: while its loot
    window is open, or within ns.LOOT_SOUND_WINDOW seconds of its closing.
    Item-produced loot (disenchant, prospect, merge, container opens) never opens
    the window, so it stays silent even though it travels the same loot +
    CHAT_MSG_LOOT path.
]]
local function IsWorldLootWindow()
	return ns.state.worldLootOpen or (GetTime() - ns.state.worldLootClosedAt) < ns.LOOT_SOUND_WINDOW
end

function ns.PlayLootSound(link)
	if ns.db.profile.lootSounds and IsWorldLootWindow() then
		local quality = ns.GetLinkQuality(link)
		if quality and quality >= ns.db.profile.lootSoundThreshold then
			PlaySoundFile(ns.LOOT_SOUND_FILE, "Master")
		end
	end
end

--------------------------------------------------------------------------------
-- Pick Pocket Sound
--------------------------------------------------------------------------------

--[[
    A successful Pick Pocket cast ARMS the sound; it does not play it. The cast
    succeeding says nothing about whether the pockets held anything -- picking a
    target whose pockets are already emptied fires the cast event and a
    "Your target has already had its pockets picked" error together -- so what the
    player hears has to wait for loot to actually turn up. See PlayPickPocketSound.
]]
function ns.ArmPickPocketSound()
	ns.state.pickPocketAt = GetTime()
end

--[[
    The other half of the Pick Pocket sound, and the half that decides whether it
    is heard at all: a loot window with something in it, opening within
    PICK_POCKET_LOOT_WINDOW of the cast. A pickpocket that yields nothing opens no
    window, so nothing here fires and the arming simply times out -- which is the
    whole point, because the cast alone succeeds either way.

    Disarms as it plays, so the one cast sounds once no matter how many loot
    events the window generates on the way through.

    MUST BE CALLED BEFORE ns.HandleSpeedyLoot: Speedy Loot empties the slots, and
    an emptied window is indistinguishable from a pickpocket that came up empty.
]]
function ns.PlayPickPocketSound()
	if ns.state.pickPocketAt == 0 or not ns.db or not ns.db.profile.pickPocketSound then
		return
	end
	if (GetTime() - ns.state.pickPocketAt) >= ns.PICK_POCKET_LOOT_WINDOW or GetNumLootItems() == 0 then
		return
	end
	ns.state.pickPocketAt = 0
	PlaySound(ns.SOUND_KIT_IDS.PICK_POCKET, "Master")
end
