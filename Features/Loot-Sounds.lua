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
    Drive lastWorldLootAt, the timestamp that gates the loot sound in
    ns.PlayLootSound, from the classified source:

      world   - stamp now. Run on both LOOT_READY and LOOT_OPENED because the
                source GUID can populate on either and Speedy Loot may empty the
                slots between them; whichever event sees the world GUID records it.
      item    - clear the stamp so a disenchant or merge within LOOT_SOUND_WINDOW
                of a real corpse loot can't reuse that window and play the sound.
      unknown - leave it alone: a late-arriving world GUID on a later event must
                still be able to stamp, and a stamp just set for this same corpse
                must survive an empty or not-yet-populated re-read.
]]
function ns.StampWorldLoot()
	local source = CurrentLootFromWorldSource()
	if source == "world" then
		ns.state.lastWorldLootAt = GetTime()
	elseif source == "item" then
		ns.state.lastWorldLootAt = 0
	end
end

--------------------------------------------------------------------------------
-- Loot Sound
--------------------------------------------------------------------------------

--[[
    Only sound off for loot that came from a corpse or chest within the last
    ns.LOOT_SOUND_WINDOW seconds. Item-produced loot (disenchant, prospect,
    merge, container opens) never stamps lastWorldLootAt, so it stays silent
    even though it travels the same loot + CHAT_MSG_LOOT path.
]]
function ns.PlayLootSound(link)
	if ns.db.profile.lootSounds and (GetTime() - ns.state.lastWorldLootAt) < ns.LOOT_SOUND_WINDOW then
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
	PlaySound(ns.PICK_POCKET_SOUND, "Master")
end
