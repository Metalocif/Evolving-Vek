function IsPrefixValidForVek(prefix, vekType)
	if _G[vekType].Prefixed then return false end									  --prevents double-prefixing
	if prefix == "Stable" and not _G[vekType].Pushable then return false end
	if prefix == "Fireproof" and _G[vekType].IgnoreFire then return false end
	--if prefix == "Acidproof" and _G[vekType].IgnoresAcid then return false end	  --not sure it's a thing
	if prefix == "Smokeproof" and _G[vekType].IgnoreSmoke then return false end
	-- if prefix == "Freezeproof" and _G[vekType].IgnoresFreeze then return false end --not a thing
	if prefix == "Leaping" and (_G[vekType].Jumper or _G[vekType].Flying or _G[vekType].Burrows) then return false end
	if prefix == "Armored" and _G[vekType].Armor then return false end
	if prefix == "Heavy" and (_G[vekType].Health > 7 or _G[vekType].MoveSpeed < 2) then return false end	--block on Psions? how to make it work with Vextra's?
	if prefix == "Volatile" and _G[vekType].Explodes then return false end
	if prefix == "Massive" and _G[vekType].Massive then return false end
	if prefix == "Undying" and _G[vekType].Corpse then return false end
	if prefix == "Ruinous" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Purifying" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Healing" and _G[vekType].IsDeathEffect then return false end
	return true
end

function CreateEvolvedVek(prefix, vekType)
	local name = _G[vekType].Name
	local portrait = "enemy/"..vekType
	if _G[prefix..vekType] ~= nil then return true end
	if prefix == "Stable" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Pushable = false,} end
	if prefix == "Fireproof" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IgnoreFire = true,} end
	-- if prefix == "Acidproof" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IgnoresAcid = true,} end
	if prefix == "Smokeproof" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IgnoreSmoke = true,} end
	if prefix == "Leaping" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Jumper = true,} end
	if prefix == "Armored" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Armor = true,} end
	if prefix == "Heavy" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Health = _G[vekType].Health + 2, MoveSpeed = _G[vekType].MoveSpeed - 1,} end
	if prefix == "Volatile" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Explodes = true,} end
	if prefix == "Massive" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Massive = true,} end
	if prefix == "Undying" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Corpse = true,} end
	if prefix == "Ruinous" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = RuinousDE} end
	if prefix == "Purifying" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = PurifyingDE} end
	if prefix == "Healing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = HealingDE} end
	return false
end

function GeneratePrefix(pawn)
	local tile = pawn:GetSpace()
	if pawn:IsFire() and IsPrefixValidForVek("Fireproof", pawn:GetType()) then return "Fireproof" end
	if Board:IsEdge(tile) and IsPrefixValidForVek("Stable", pawn:GetType()) then return "Stable" end
	if Board:IsSmoke(tile) and IsPrefixValidForVek("Smokeproof", pawn:GetType()) then return "Smokeproof" end
	-- local wasBlocked = true
	-- for i = DIR_START, DIR_END do
		-- if not Board:IsBlocked(tile, pawn:GetPathProf()) then wasBlocked = false end
	-- end
	-- if wasBlocked and IsPrefixValidForVek("Leaping", pawn:GetType()) then return "Leaping" end
	--if we couldn't find anything 'logical', just pick something at random
	local prefixes = {"Stable","Fireproof","Smokeproof","Leaping","Armored","Heavy","Volatile","Massive","Undying","Ruinous","Purifying","Healing"}
	local prefix
	repeat
		prefix = prefixes[math.random(#prefixes)]
	until IsPrefixValidForVek(prefix, pawn:GetType())
	return prefix
end

function AreSameFamily(type1, type2)
	local family = string.sub(type1, 1, -2)
	return string.find(type2, family)
end

function RuinousDE(pawn, point)
	ret = SkillEffect()
	local damage = SpaceDamage(point)
	damage.iCrack = 1
	ret:AddDamage(damage)
	return ret
end

function PurifyingDE(pawn, point)
	ret = SkillEffect()
	for i = DIR_START, DIR_END do
		local damage = SpaceDamage(point + DIR_VECTORS[i])
		damage.iAcid = EFFECT_REMOVE
		ret:AddDamage(damage)
	end
	return ret
end

function HealingDE(pawn, point)
	ret = SkillEffect()
	for i = DIR_START, DIR_END do
		local damage = SpaceDamage(point + DIR_VECTORS[i], -1)
		local pawn = Board:GetPawn(point + DIR_VECTORS[i])
		if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetTeam() ~= TEAM_BOTS then ret:AddDamage(damage) end
	end
	return ret
end

--Hook stuff

local function HOOK_MissionStart(mission)
	if GAME.EvolvedVeks == nil then return false end
	while Board:IsBusy() do
	end
	local delayDamage = SpaceDamage(Point(0, 0))
	delayDamage.fDelay = 2
	Board:AddEffect(delayDamage)
	for _, tile in ipairs(Board) do
		local pawn = Board:GetPawn(tile)
		if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetTeam() ~= TEAM_BOTS then
			for i = 1, #GAME.EvolvedVeks do
				if GAME.EvolvedVeks[i].Type == pawn:GetType() and GAME.EvolvedVeks[i].Remaining > 0 then
					Board:RemovePawn(tile)
					Board:AddPawn(GAME.EvolvedVeks[i].Prefix..pawn:GetType(), tile)
					GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining - 1
					break
				end
			end
		end
	end
end

local function HOOK_VekSpawnAdded(mission, spawnData)
	if GAME.EvolvedVeks == nil then return false end
	for i = 1, #GAME.EvolvedVeks do
		if GAME.EvolvedVeks[i].Type == spawnData.type and GAME.EvolvedVeks[i].Remaining > 0 then
			--mission:ModifySpawnPoint(spawnData.location, {location = spawnData.location, type = GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type})
			Mission:ChangeSpawnPointPawnType(spawnData.location, GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type)
			GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining - 1
			break
		end
	end
end

local function HOOK_MissionEnd(mission, ret)
	for _, tile in ipairs(Board) do
		local pawn = Board:GetPawn(tile)
		if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetTeam() ~= TEAM_BOTS and not _G[pawn:GetType()].Prefixed then
			local prefix = GeneratePrefix(pawn)
			CreateEvolvedVek(prefix, pawn:GetType())
			if GAME.EvolvedVeks == nil then GAME.EvolvedVeks = {} end
			local found = false
			for i = 1, #GAME.EvolvedVeks do
				if GAME.EvolvedVeks[i].Type == pawn:GetType() and GAME.EvolvedVeks[i].Prefix == prefix then GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining + 1 found = true break end
			end
			if not found then GAME.EvolvedVeks[#GAME.EvolvedVeks+1] = {Type = pawn:GetType(), Prefix = prefix, Remaining = 1} end
			--LOG("added a "..prefix.." "..pawn:GetType()..", we stored "..tostring(#GAME.EvolvedVeks).." different Vek.")
		end
	end
end

local function HOOK_PostLoadGame()
	if GAME.EvolvedVeks == nil then LOG("no table") else LOG("remaking "..tostring(#GAME.EvolvedVeks).." prefixed Veks") end
	for i = 1, #GAME.EvolvedVeks do
		CreateEvolvedVek(GAME.EvolvedVeks[i].Prefix, GAME.EvolvedVeks[i].Type)
		if not CreateEvolvedVek(GAME.EvolvedVeks[i].Prefix, GAME.EvolvedVeks[i].Type) then
			LOG("added a "..GAME.EvolvedVeks[i].Prefix.." "..GAME.EvolvedVeks[i].Type..", that is the "..tostring(i).." we stored.")
		end
	end
end

local function EVENT_onModsLoaded()
	modApi:addMissionStartHook(HOOK_MissionStart)	--add evolved Vek at start of battle
	modApi:addVekSpawnAddedHook(HOOK_VekSpawnAdded)	--replace spawns with evolved Vek
	modApi:addMissionEndHook(HOOK_MissionEnd)		--iterate on surviving Vek to evolve them
	modApi:addPreLoadGameHook(HOOK_PostLoadGame)	--for undoturn? doesn't seem to help
	modApi:addPostLoadGameHook(HOOK_PostLoadGame)	--regenerate entries in _G as needed by the EvolvedVeks table
	modApi:addModsLoadedHook(HOOK_PostLoadGame)		--regenerate entries in _G as needed by the EvolvedVeks table
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
