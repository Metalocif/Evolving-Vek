local description = "Adds prefixes to enemies. Each enemy can have a random buff."
local mod = {
	id = "Meta_EvolvingVek",
	name = "Evolving Vek",
	version = "1.0",
	requirements = {},
	dependencies = { 
		modApiExt = "1.18", --We can get this by using the variable `modapiext`
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

return mod
