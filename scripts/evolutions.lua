local mod = modApi:getCurrentMod()

function IsPrefixValidForVek(prefix, vekType)
	local options = mod_loader.currentModContent[mod.id].options
	if options["Enable"..prefix] and not options["Enable"..prefix].enabled then return false end
	if _G[vekType].Prefixed then return false end									  --prevents double-prefixing
	if prefix == "Stable" and not _G[vekType].Pushable then return false end
	if prefix == "Fireproof" and _G[vekType].IgnoreFire then return false end
	if prefix == "Smokeproof" and _G[vekType].IgnoreSmoke then return false end
	if prefix == "Leaping" and (_G[vekType].Jumper or _G[vekType].Flying or _G[vekType].Burrows) then return false end
	if prefix == "Armored" and _G[vekType].Armor then return false end
	if prefix == "Heavy" and (_G[vekType].Health > 7 or _G[vekType].MoveSpeed < 2 or _G[vekType].VoidShockImmune) then return false end
	if prefix == "Light" and _G[vekType].Health == 1 then return false end
	if prefix == "Volatile" and _G[vekType].Explodes then return false end
	if prefix == "Massive" and _G[vekType].Massive then return false end
	if prefix == "Undying" and _G[vekType].Corpse then return false end
	if prefix == "Burrowing" and (_G[vekType].Jumper or _G[vekType].Flying or _G[vekType].Burrows or _G[vekType].Tier == TIER_BOSS or _G[vekType].Health < 3) then return false end
	if prefix == "Ruinous" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Purifying" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Healing" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Spiteful" and _G[vekType].IsDeathEffect then return false end
	-- if prefix == "Webbing" and (_G[vekType].Ranged == 1 or _G[vekType].MoveSpeed < 3) then return false end
	if prefix == "Splitting" and _G[vekType].MoveSpeed == 0 then return false end	
	if prefix == "Oozing" and _G[vekType].MoveSpeed == 0 then return false end	
	if prefix == "Infectious" and (_G[vekType].Ranged == 1 or _G[vekType].MoveSpeed < 3) then return false end	
	if prefix == "Regenerating" and _G[vekType].Health == 1 then return false end
	if prefix == "Wrathful" and _G[vekType].VoidShockImmune then return false end
	if prefix == "Cannibalistic" and _G[vekType].VoidShockImmune then return false end
	if prefix == "CopyingMelee" and (_G[vekType].Ranged == 1 or #_G[vekType].SkillList ~= 1 or _G[vekType].Tier == TIER_BOSS) then return false end
	if prefix == "CopyingRanged" and (_G[vekType].Ranged == 0 or #_G[vekType].SkillList ~= 1 or _G[vekType].Tier == TIER_BOSS) then return false end
	if prefix == "Tyrannical" and not string.find(_G[vekType].Name, "Psion") then return false end
	-- _G[vekType].VoidShockImmune is true for weaponless enemies, basically string.find(_G[vekType].Name, "Psion")/Blobber/Spider/...
	return true
end

function CreateEvolvedVek(prefix, vekType)
	--local name = _G[vekType].Name
	local name = PAWN_FACTORY:CreatePawn(vekType):GetMechName()	--used because in AE, the .Name field has wrong values, eg. Dung Beetle instead of Tumblebug
	local portrait = "enemy/"..vekType
	if _G[prefix..vekType] ~= nil then return true end
	if prefix == "Stable" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Pushable = false,} end
	if prefix == "Fireproof" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IgnoreFire = true,} end
	if prefix == "Smokeproof" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IgnoreSmoke = true,} end
	if prefix == "Leaping" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Jumper = true,} end
	if prefix == "Armored" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Armor = true,} end
	if prefix == "Heavy" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Health = _G[vekType].Health + 2, MoveSpeed = _G[vekType].MoveSpeed - 1,} end
	if prefix == "Light" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Health = _G[vekType].Health - 1, MoveSpeed = _G[vekType].MoveSpeed + 2,} end
	if prefix == "Volatile" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Explodes = true,} end
	if prefix == "Massive" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Massive = true,} end
	if prefix == "Undying" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Corpse = true,} end
	if prefix == "Burrowing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Burrows = true,} end
	if prefix == "Ruinous" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = RuinousDE} end
	if prefix == "Purifying" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = PurifyingDE} end
	if prefix == "Healing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = HealingDE} end
	-- if prefix == "Webbing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Webbing,} end
	-- GetWeapon triggers at start of movement so I can't web things at end of movement, big sad
	if prefix == "Splitting" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Splitting,} end
	if prefix == "Oozing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Oozing,} end
	if prefix == "Infectious" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Infectious,} end
	if prefix == "Regenerating" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Regenerating,} end
	if prefix == "Wrathful" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Wrathful,} end
	if prefix == "CopyingMelee" then _G[prefix..vekType] = _G[vekType]:new{Name = "Copying".." "..name, Prefixed = true, Portrait = portrait, GetWeapon = CopyingMelee,} end
	if prefix == "CopyingRanged" then _G[prefix..vekType] = _G[vekType]:new{Name = "Copying".." "..name, Prefixed = true, Portrait = portrait, GetWeapon = CopyingRanged,} end
	if prefix == "Cannibalistic" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Cannibalistic,} end
	if prefix == "Spiteful" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect, GetDeathEffect = SpitefulDE} end
	if prefix == "Tyrannical" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Ranged = 1, SkillList = {"TyrannicalAtk1"}, Tooltip = ""} end
	return false
end

function GetWeaponTier(weaponType)
	if string.sub(weaponType, 1, -2) == "1" then return 1 end
	if string.sub(weaponType, 1, -2) == "2" then return 2 end
	if string.sub(weaponType, 1, -2) == "B" then return 3 end
	return 0
end

function CopyingMelee()
	local bestWeapon = ""
	local bestWeaponTier = 0
	if Pawn:GetWeaponCount() == 2 then
		bestWeapon = Pawn:GetWeaponType(2)
		bestWeaponTier = GetWeaponTier(bestWeapon)
	end
	for _, curr in ipairs(Board) do
		local target = Board:GetPawn(curr)
		if target then LOG(target:GetType()..", "..", "..tostring(target:IsEnemy())..", "..tostring(target:GetWeaponCount())..", "..tostring(target:IsRanged())..", "..tostring(target:GetTeam()==TEAM_BOTS)) end
		if target and target:IsEnemy() and target:GetWeaponCount() > 0 and not target:IsRanged() then --and not target:GetTeam() == TEAM_BOTS then 
			local tier = GetWeaponTier(target:GetWeaponType(1))
			if tier >= bestWeaponTier and target:GetWeaponType(1) ~= Pawn:GetWeaponType(1) then
				bestWeaponTier = tier
				bestWeapon = target:GetWeaponType(1)
			end
		end
	end
	if Pawn:GetWeaponCount() == 2 and bestWeapon ~= Pawn:GetWeaponType(2) then Pawn:RemoveWeapon(2) end
	if bestWeapon ~= "" then Pawn:AddWeapon(bestWeapon) end
	return Pawn:GetWeaponCount()
end

function CopyingRanged()
	local bestWeapon = ""
	local bestWeaponTier = 0
	if Pawn:GetWeaponCount() == 2 then
		bestWeapon = Pawn:GetWeaponType(2)
		bestWeaponTier = GetWeaponTier(bestWeapon)
	end
	for _, curr in ipairs(Board) do
		local target = Board:GetPawn(curr)
		if target then LOG(target:GetType()..", "..", "..tostring(target:IsEnemy())..", "..tostring(target:GetWeaponCount())..", "..tostring(target:IsRanged())..", "..tostring(target:GetTeam()==TEAM_BOTS)) end
		if target and target:IsEnemy() and target:GetWeaponCount() > 0 and target:IsRanged() then --and not target:GetTeam() == TEAM_BOTS then 
			local tier = GetWeaponTier(target:GetWeaponType(1))
			if tier >= bestWeaponTier and target:GetWeaponType(1) ~= Pawn:GetWeaponType(1) then
				bestWeaponTier = tier
				bestWeapon = target:GetWeaponType(1)
			end
		end
	end
	if Pawn:GetWeaponCount() == 2 and bestWeapon ~= Pawn:GetWeaponType(2) then Pawn:RemoveWeapon(2) end
	if bestWeapon ~= "" then Pawn:AddWeapon(bestWeapon) end
	return Pawn:GetWeaponCount()
end

function Cannibalistic()
	for i = DIR_START, DIR_END do
		local curr = Pawn:GetSpace() + DIR_VECTORS[i]
		local target = Board:GetPawn(curr)
		if target and ((target:IsEnemy() and not target:GetTeam() == TEAM_BOTS) or (target:IsMech() and target:GetClass() == "TechnoVek")) then 
			Board:DamageSpace(curr, 1)
			if target:IsDead() then Board:RemovePawn(curr) end
			Pawn:SetMaxHealth(Pawn:GetMaxHealth() + 2)
			Board:DamageSpace(Pawn:GetSpace(), -2)
			Pawn:SetMoveSpeed(Pawn:GetMoveSpeed() + 1)
		end
	end
	return 1
end

function Infectious()
	for i = DIR_START, DIR_END do
		local curr = Pawn:GetSpace() + DIR_VECTORS[i]
		local target = Board:GetPawn(curr)
		if target and target:IsPlayer() then 
			if target:IsInfected() then Board:DamageSpace(curr, 1) else target:SetInfected(true) end
		end
	end
	return 1
end

function Regenerating()
	Board:DamageSpace(Pawn:GetSpace(), -1)
	return 1
end

function Wrathful()
	Pawn:SetBoosted(true)
	return 1
end

-- function Webbing()
	-- modApi:conditionalHook(
		-- function()
			-- GAME.WebbingPawnId = Pawn:GetId()
			-- return Pawn and Pawn:IsQueued() and string.find(Pawn:GetType(), "Webbing") 
		-- end,
		-- function()
			-- LOG("start webbing from "..Pawn:GetSpace():GetString())
			-- LOG("will look according to Id: "..Board:GetPawn(GAME.WebbingPawnId):GetType())
			-- ret = SkillEffect()
			-- for i = DIR_START, DIR_END do
				-- local curr = Pawn:GetSpace() + DIR_VECTORS[i]
				-- Board:Ping(curr, COLOR_BLACK)
				-- if Board:GetPawn(curr) and Board:GetPawn(curr):IsPlayer() then 
					-- LOG("found something in "..curr:GetString())
					-- ret:AddGrapple(Pawn:GetSpace(), curr, "hold")
				-- end
			-- end
			-- Board:AddEffect(ret)
		-- end
	-- )
	-- return 1
-- end

function Splitting()
	--we'll only spawn something if we are not above liquid/chasm, we could move to something adjacent, and we wouldn't move into fire/landmine
	--we have to move somewhere adjacent because I want the spawn's position to be the previous position of the spawner
	--but it's possible the spawner will move 0 tiles and I can't know this
	--I guess I could overwrite GetPositionScore but this is easier, also pawn could be stuck
	local startPos = Pawn:GetSpace()
	if Pawn:GetTurnCount() > 1 and Board:GetTerrain(startPos) ~= TERRAIN_WATER and Board:GetTerrain(startPos) ~= TERRAIN_HOLE then 
		local adjacents = extract_table(Board:GetReachable(startPos, 1, Pawn:GetPathProf()))
		for i = 1, #adjacents do
			if not (Board:IsFire(adjacents[i]) or Board:IsDangerousItem(adjacents[i])) then
				local ret = SkillEffect()
				ret:AddMove(Board:GetPath(startPos, adjacents[i], Pawn:GetPathProf()), NO_DELAY)
				Board:AddEffect(ret)
				Board:AddPawn("Blob1", startPos)
				break
			end
		end
	end
	return 1
end

function Oozing()
	local startPos = Pawn:GetSpace()
	if Pawn:GetTurnCount() > 1 and Board:GetTerrain(startPos) ~= TERRAIN_WATER and Board:GetTerrain(startPos) ~= TERRAIN_HOLE then 
		local adjacents = extract_table(Board:GetReachable(startPos, 1, Pawn:GetPathProf()))
		for i = 1, #adjacents do
			if not (Board:IsFire(adjacents[i]) or Board:IsDangerousItem(adjacents[i])) then
				local ret = SkillEffect()
				ret:AddMove(Board:GetPath(startPos, adjacents[i], Pawn:GetPathProf()), NO_DELAY)
				Board:AddEffect(ret)
				Board:AddPawn("BlobBossSmall", startPos)
				break
			end
		end
	end
	return 1
end

TyrannicalAtk1 = LineArtillery:new{
	Name="The Hive's Spite",
	Description="Strikes a target with tentacles. Will prioritize units over buildings.",
	ArtillerySize = 3,
	Damage = 1,
	Type = 1,
	ScoreEnemy = 6,
	Class = "Enemy",
	Icon = "weapons/enemy_scarab1.png",
	Projectile = "",
	Explosion = "",
	ImpactSound = "",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Building = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "Jelly_Health1"
	}
}

TyrannicalAtk2 = TyrannicalAtk1:new{		--only relevant with things that upgrade Vek weapons, ie. my Rock Leader
	Name="The Hive's Scorn",
	ArtillerySize = 4,
	Damage = 3,
}
TyrannicalAtkB = TyrannicalAtk1:new{
	Name="The Hive's Hate",
	Description="Strikes a target and its surroundings with tentacles. Will prioritize units over buildings.",
	ArtillerySize = 5,
	Damage = 5,
	CrossAttack = true,
}

function TyrannicalAtk1:GetSkillEffect(p1, p2)
	--stolen from Generic's Secret Squad 2, go play it, very fun
	local ret = SkillEffect()
	local Tanim1 = SpaceDamage(p2,self.Damage)--the tentacles attacking from the front
	local Tanim2 = SpaceDamage(p2,0)--the tentacles attacking from the back
	Tanim1.sAnimation ="PsionAttack_Front"
	Tanim2.sAnimation ="PsionAttack_Back"
	ret:AddQueuedArtillery(Tanim1, "", PROJ_DELAY)
	ret:AddQueuedDamage(Tanim2)
	ret:AddQueuedBounce(p2,3)
	if self.CrossAttack then
		ret:AddQueuedDelay(0.25)
		Tanim1.iDamage = 2
		for i = DIR_START, DIR_END do
			local curr = p2 + DIR_VECTORS[i]
			Tanim1.loc = curr
			Tanim2.loc = curr
			ret:AddQueuedDamage(Tanim1)
			ret:AddQueuedDamage(Tanim2)
			ret:AddQueuedBounce(p2,2)
		end
	end
	return ret
end


function GeneratePrefix(pawn)
	local tile = pawn:GetSpace()
	if string.find(pawn:GetMechName(), "Psion") and pawn:GetType() ~= "Jelly_Lava1" then return "Tyrannical" end 	--hardcoded but Tyrants should basically never be prefixed anyway
	if pawn:IsFire() and IsPrefixValidForVek("Fireproof", pawn:GetType()) then return "Fireproof" end
	if Board:IsEdge(tile) and IsPrefixValidForVek("Stable", pawn:GetType()) then return "Stable" end
	if Board:IsSmoke(tile) and IsPrefixValidForVek("Smokeproof", pawn:GetType()) then return "Smokeproof" end
	if pawn:GetMutation() == 4 and IsPrefixValidForVek("Regenerating", pawn:GetType()) then return "Regenerating" end
	if pawn:GetMutation() == 5 and IsPrefixValidForVek("Armored", pawn:GetType()) then return "Armored" end
	if pawn:GetMutation() == 6 and IsPrefixValidForVek("Volatile", pawn:GetType()) then return "Volatile" end	
	if pawn:GetMutation() == 7 and IsPrefixValidForVek("Wrathful", pawn:GetType()) then return "Wrathful" end
	if GetCurrentMission() == Mission_BlobBoss and IsPrefixValidForVek("Oozing", pawn:GetType()) then return "Oozing" end
	local prefixes = {"Stable","Fireproof","Smokeproof","Leaping","Armored","Heavy","Light","Volatile","Massive","Undying","Burrowing","Ruinous","Purifying","Healing","Spiteful","Splitting","Oozing","Infectious","Regenerating","Wrathful","Cannibalistic","CopyingMelee","CopyingRanged"}
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

function SpitefulDE(pawn, point)
	ret = SkillEffect()
	local pawnTier = 1
	if _G[Pawn:GetType()].Tier == TIER_ALPHA then pawnTier = 2 end
	if _G[Pawn:GetType()].Tier == TIER_BOSS then pawnTier = 3 end
	local tierGraphics = tostring(pawnTier)
	if tierGraphics == "3" then tierGraphics = "B" end
	local tierGraphicsArt = tierGraphics
	if tierGraphics == "1" then tierGraphics = "" end
	for i = DIR_START, DIR_END do
		local target = GetProjectileEnd(point, point + DIR_VECTORS[i], PATH_PROJECTILE)
		local pawn = Board:GetPawn(target)
		if pawn and pawn:IsMech() then ret:AddProjectile(point, SpaceDamage(target, pawnTier), "effects/shot_firefly"..tierGraphics, NO_DELAY) end
		for j = 2, 8 do
			local curr2 = point + DIR_VECTORS[i] * j
			local pawn2 = Board:GetPawn(curr2)
			if curr2 ~= target and pawn2 and pawn2:IsMech() then ret:AddArtillery(point, SpaceDamage(curr2, pawnTier), "effects/shotup_ant"..tierGraphicsArt..".png", NO_DELAY) end
		end
	end
	return ret
end

--Hook stuff

local function HOOK_MissionStart(mission)
	if GAME.EvolvedVeks == nil then return false end
	local options = mod_loader.currentModContent[mod.id].options
	if options["PrefixStartCount"] and options["PrefixStartCount"] == 0 then return false end
	local prefixesApplied = 0
	for _, tile in ipairs(Board) do
		local pawn = Board:GetPawn(tile)
		if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetTeam() ~= TEAM_BOTS then
			for i = 1, #GAME.EvolvedVeks do
				if _G[GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type].Name == "Missing Mod" then LOG("prevented missing mod for "..GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type) end
				if GAME.EvolvedVeks[i].Type == pawn:GetType() and GAME.EvolvedVeks[i].Remaining > 0 and _G[GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type].Name ~= "Missing Mod" then
					Board:RemovePawn(tile)
					Board:AddPawn(GAME.EvolvedVeks[i].Prefix..pawn:GetType(), tile)
					Board:GetPawn(tile):SpawnAnimation()
					GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining - 1
					prefixesApplied = prefixesApplied + 1
					if options["PrefixStartCount"] and options["PrefixStartCount"] == prefixesApplied then return true end
				end
			end
		end
	end
end

local function HOOK_VekSpawnAdded(mission, spawnData)
	if GAME.EvolvedVeks == nil then return false end
	local options = mod_loader.currentModContent[mod.id].options
	if options["PrefixSpawns"] and not options["PrefixSpawns"].enabled then return false end
	for i = 1, #GAME.EvolvedVeks do
		if GAME.EvolvedVeks[i].Type == spawnData.type and GAME.EvolvedVeks[i].Remaining > 0 and _G[GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type].Name ~= "Missing Mod" then
			mission:ModifySpawnPoint(spawnData.location, {type = GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type})
			-- mission:ChangeSpawnPointPawnType(spawnData.location, GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type)
			-- mission:RemoveSpawnPoint(spawnData.location)
			-- mission:SpawnPawn(spawnData.location, GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type)	--or spawnPawnInternal?
			-- self.Board:SpawnPawn(pawn, location)
			-- addSpawnData(self, location, pawn:GetType(), pawn:GetId())
			-- LOG("trying to spawn a "..GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type)
			-- local loc = spawnData.location
			-- mission:RemoveSpawnPoint(loc)
			
			-- modApi:runLater(function()
				-- local id = Board:SpawnPawn(GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type, loc)
				-- addSpawnData(self, loc, GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type, id, 0)
				-- Board:Ping(loc, COLOR_BLACK)
			-- end)
			
			GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining - 1
			break
		end
	end
end

local function HOOK_MissionEnd(mission, ret)
	for _, tile in ipairs(Board) do
		local pawn = Board:GetPawn(tile)
		if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetTeam() ~= TEAM_BOTS and not _G[pawn:GetType()].Prefixed and not pawn:IsFrozen() then
			local prefix = GeneratePrefix(pawn)
			CreateEvolvedVek(prefix, pawn:GetType())
			if GAME.EvolvedVeks == nil then GAME.EvolvedVeks = {} end
			local found = false
			for i = 1, #GAME.EvolvedVeks do
				if GAME.EvolvedVeks[i].Type == pawn:GetType() and GAME.EvolvedVeks[i].Prefix == prefix then GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining + 1 found = true break end
			end
			if not found then GAME.EvolvedVeks[#GAME.EvolvedVeks+1] = {Type = pawn:GetType(), Prefix = prefix, Remaining = 1} end
			LOG("added a "..prefix.." "..pawn:GetType()..", we stored "..tostring(#GAME.EvolvedVeks).." different Vek.")
		end
	end
end

local function HOOK_PostLoadGame()
	-- if GAME.EvolvedVeks == nil then LOG("no table") else LOG("remaking "..tostring(#GAME.EvolvedVeks).." prefixed Veks") end
	if GAME.EvolvedVeks == nil then LOG("no table") return false end
	for i = 1, #GAME.EvolvedVeks do
		-- CreateEvolvedVek(GAME.EvolvedVeks[i].Prefix, GAME.EvolvedVeks[i].Type)
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
