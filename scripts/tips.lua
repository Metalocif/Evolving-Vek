local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local tips = require(path .."libs/tutorialTips")

--I have tips for all of the vek, and then you can turn them on or off in the init.lua
tips:Add{id = "Tip_Stable",title = "Stable",text = "The Stable prefix makes a Vek immune to forced movement."}
tips:Add{id = "Tip_Fireproof",title = "Fireproof",text = "The Fireproof prefix makes a Vek immune to fire."}
tips:Add{id = "Tip_Smokeproof",title = "Smokeproof",text = "The Smokeproof prefix makes a Vek immune to smoke."}
tips:Add{id = "Tip_Leaping",title = "Leaping",text = "The Leaping prefix makes a Vek move by leaping."}
tips:Add{id = "Tip_Armored",title = "Armored",text = "The Armored prefix makes a Vek armored, reducing all incoming weapon damage by 1."}
tips:Add{id = "Tip_Heavy",title = "Heavy",text = "The Heavy prefix increases the Vek's max HP by 2 and reduces its movement speed by 2."}
tips:Add{id = "Tip_Light",title = "Light",text = "The Light prefix reduces the Vek's max HP by 1 and increases its movement speed by 1."}
tips:Add{id = "Tip_Volatile",title = "Volatile",text = "The Volatile prefix makes a Vek explode on death."}
tips:Add{id = "Tip_Massive",title = "Massive",text = "The Massive prefix makes a Vek immune to death by drowning."}
tips:Add{id = "Tip_Undying",title = "Undying",text = "The Undying prefix makes a Vek leave a corpse when it dies, unless it was drowned. The corpse can be revived by healing effects."}
tips:Add{id = "Tip_Burrowing",title = "Burrowing",text = "The Burrowing prefix makes a Vek move by burrowing and burrow when taking damage. Burrowing extinguishes fire on the Vek."}
tips:Add{id = "Tip_Ruinous",title = "Ruinous",text = "The Ruinous prefix makes a Vek crack its tile when it dies."}
tips:Add{id = "Tip_Purifying",title = "Purifying",text = "The Purifying prefix makes a Vek remove A.C.I.D. from its tile and adjacent tiles when it dies."}
tips:Add{id = "Tip_Healing",title = "Healing",text = "The Healing prefix makes a Vek heal 1 HP to adjacent Vek when it dies."}
tips:Add{id = "Tip_Spiteful",title = "Spiteful",text = "The Spiteful prefix makes a Vek fire projectiles to all player units on the same row/column when it dies. Damage dealt depends on the Vek's tier; normal Vek deal 1 damage, alpha Vek deal 2, bosses deal 3."}
tips:Add{id = "Tip_Brood",title = "Brood",text = "The Brood prefix makes a Vek spawn a spider egg when it dies."}
tips:Add{id = "Tip_Splitting",title = "Splitting",text = "The Splitting prefix makes a Vek spawn a blob at the start of its movement."}
tips:Add{id = "Tip_Oozing",title = "Oozing",text = "The Oozing prefix makes a Vek spawn a small goo at the start of its movement."}
tips:Add{id = "Tip_Infectious",title = "Infectious",text = "The Infectious prefix makes a Vek infect adjacent player units with Vek Mites at the start of its movement. If it would infect an infected unit, the unit takes 1 damage instead."}
tips:Add{id = "Tip_Regenerating",title = "Regenerating",text = "The Regenerating prefix makes a Vek heal 1 HP at the start of its movement."}
tips:Add{id = "Tip_Wrathful",title = "Wrathful",text = "The Wrathful prefix makes a Vek deal 1 extra damage with its weapon."}
tips:Add{id = "Tip_Webbing",title = "Webbing",text = "The Webbing prefix makes a Vek web all adjacent player units when it prepares to fire its weapon."}
tips:Add{id = "Tip_Cannibalistic",title = "Cannibalistic",text = "The Cannibalistic prefix makes a Vek deal 1 damage to all adjacent Vek and Cyborgs at the start of its movement. For each unit thus damaged, it heals 2 HP, increases its maximum HP by 2, and increases its movement speed by 1."}
tips:Add{id = "Tip_CopyingMelee",title = "Copying",text = "The Copying prefix makes a Vek copy the highest tiered weapon of its type (melee/ranged) on the board at the start of its turn. A humble Leaper could copy the weapon of a Hornet Leader, for instance, but an Alpha Leaper would not copy a Hornet's weapon."}
tips:Add{id = "Tip_CopyingRanged",title = "Copying",text = "The Copying prefix makes a Vek copy the highest tiered weapon of its type (melee/ranged) on the board at the start of its turn. A humble Firefly could copy the weapon of a Crab Leader, for instance, but an Alpha Firefly would not copy a Crab's weapon."}
tips:Add{id = "Tip_Mirroring",title = "Mirroring",text = "The Mirroring prefix makes a Vek fire its weapon forward and backwards at the same time, much like a Firefly Leader."}
tips:Add{id = "Tip_Pushing",title = "Pushing",text = "The Pushing prefix makes a Vek's weapon push all tiles it damages."}
tips:Add{id = "Tip_Groundbreaking",title = "Groundbreaking",text = "The Groundbreaking prefix makes a Vek's weapon crack all tiles it damages."}
tips:Add{id = "Tip_Venomous",title = "Venomous",text = "The Venomous prefix makes a Vek fire an instant projectile applying A.C.I.D. when it queues its weapon."}
tips:Add{id = "Tip_Frenzied",title = "Frenzied",text = "The Frenzied prefix makes a Vek deal 2 extra damage with its weapon, but have 1 less maximum HP."}
tips:Add{id = "Tip_Freezing",title = "Freezing",text = "The Freezing prefix makes a Vek's weapon freeze all tiles it damages."}

--Put the hooks in here for pawn creation
local this = {}

--@param vek	string	the name of the vek, capitalized
local function HasPrefix(pawn, prefix)
	return pawn and (pawn:GetType():sub(1, #prefix)) == prefix
end

local function PawnCreated(mission, pawn)
	if _G[pawn:GetType()].Prefixed then 
		local prefixes = {"Stable","Fireproof","Smokeproof","Leaping","Armored","Heavy","Light","Volatile","Massive","Undying","Burrowing","Ruinous","Purifying","Healing","Spiteful","Brood","Splitting","Oozing","Infectious","Regenerating","Wrathful","Webbing","Cannibalistic","CopyingMelee","CopyingRanged","Mirroring","Pushing","Groundbreaking","Venomous","Frenzied","Freezing"}
		for _, prefix in ipairs(prefixes) do
			if HasPrefix(pawn, prefix) then tips:Trigger("Tip_"..prefix, pawn:GetSpace()) end
		end
	end
end

function this:load(EvolvingVek_ModApiExt)
	EvolvingVek_ModApiExt:addPawnTrackedHook(PawnCreated)
end

return this
