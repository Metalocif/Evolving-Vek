local description = "Adds prefixes to enemies. Each enemy can have a random buff."
local mod = {
	id = "Meta_EvolvingVek",
	name = "Evolving Vek",
	version = "1.1",
	requirements = {},
	dependencies = { 
		modApiExt = "1.18", --We can get this by using the variable `modapiext`
		memedit = "1.0.2",
		easyEdit = "2.0.4",
	},
	modApiVersion = "2.9.1",
	icon = "img/mod_icon.png",
	description = description,
}

function mod:init()
	require(self.scriptPath .."evolutions")
end

function mod:load( options, version)
	mod.icon = self.resourcePath .."img/mod_icon.png"
end

function mod:metadata()
	modApi:addGenerationOption(
		"PrefixSpawns",
		"Modify spawns during mission",
		"Check to modify spawns during missions instead of solely before deployment; this is currently buggy (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"PrefixStartCount",
		"Max prefixes at start of mission",
		"Choose how many Vek can have a prefix on the first turn (default: 1).",
		{
			values = { 1, 2, 3, 4, 5, 6}
		}
	)
	modApi:addGenerationOption(
		"Enable_Stable",
		"Enable the Stable prefix",
		"Check to allow Vek to be given the Stable prefix, making them immune to pushes (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Fireproof",
		"Enable the Fireproof prefix",
		"Check to allow Vek to be given the Fireproof prefix, making them immune to fire (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Smokeproof",
		"Enable the Smokeproof prefix",
		"Check to allow Vek to be given the Smokeproof prefix, making them immune to smoke (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Leaping",
		"Enable the Leaping prefix",
		"Check to allow Vek to be given the Leaping prefix, making them move by leaping (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Armored",
		"Enable the Armored prefix",
		"Check to allow Vek to be given the Armored prefix, granting them armor (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Heavy",
		"Enable the Heavy prefix",
		"Check to allow Vek to be given the Heavy prefix, granting them +2 HP at the cost of 1 movement (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Light",
		"Enable the Light prefix",
		"Check to allow Vek to be given the Light prefix, granting them +2 movement at the cost of 1 HP (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Volatile",
		"Enable the Volatile prefix",
		"Check to allow Vek to be given the Volatile prefix, making them explode when killed (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Massive",
		"Enable the Massive prefix",
		"Check to allow Vek to be given the Massive prefix, making them immune to death by drowning (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Undying",
		"Enable the Undying prefix",
		"Check to allow Vek to be given the Undying prefix, making them leave a corpse when killed (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Burrowing",
		"Enable the Burrowing prefix",
		"Check to allow Vek to be given the Burrowing prefix, making them move by burrowing and burrow when they take damage (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Ruinous",
		"Enable the Ruinous prefix",
		"Check to allow Vek to be given the Ruinous prefix, making them crack their tile when killed (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Purifying",
		"Enable the Purifying prefix",
		"Check to allow Vek to be given the Purifying prefix, making them remove A.C.I.D. from adjacent tiles when killed (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Healing",
		"Enable the Healing prefix",
		"Check to allow Vek to be given the Healing prefix, making them heal adjacent Veks when killed (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Spiteful",
		"Enable the Spiteful prefix",
		"Check to allow Vek to be given the Spiteful prefix, making them fire at all mechs on the same row/column; the projectiles deal damage equal to the Vek's tier (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Splitting",
		"Enable the Splitting prefix",
		"Check to allow Vek to be given the Splitting prefix, making them leave a blob at the start of movement after their first turn alive (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Oozing",
		"Enable the Oozing prefix",
		"Check to allow Vek to be given the Oozing prefix, making them leave a small goo at the start of movement after their first turn alive (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Infectious",
		"Enable the Infectious prefix",
		"Check to allow Vek to be given the Infectious prefix, making them spread Vek mites on allied units at the start of movement and damaging infected units (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Regenerating",
		"Enable the Regenerating prefix",
		"Check to allow Vek to be given the Regenerating prefix, making them heal 1 HP at the start of movement (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Wrathful",
		"Enable the Wrathful prefix",
		"Check to allow Vek to be given the Wrathful prefix, making them boosted at the start of movement (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Cannibalistic",
		"Enable the Cannibalistic prefix",
		"Check to allow Vek to be given the Cannibalistic prefix, making them damage adjacent Vek and Cyborgs at the start of movement to gain health and movement speed (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_CopyingMelee",
		"Enable the Copying prefix for melee Vek",
		"Check to allow melee Vek to be given the Copying prefix, making them use the best melee Vek weapon on the board instead of their own (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_CopyingRanged",
		"Enable the Copying prefix for ranged Vek",
		"Check to allow ranged Vek to be given the Copying prefix, making them use the best ranged Vek weapon on the board instead of their own (default: true).",
		{ enabled = true }
	)
	modApi:addGenerationOption(
		"Enable_Tyrannical",
		"Enable the Tyrannical prefix",
		"Check to allow Psions to be given the Tyrannical prefix, granting them a weak artillery attack (default: true).",
		{ enabled = true }
	)
end

return mod
