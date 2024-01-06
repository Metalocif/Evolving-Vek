local mod = modApi:getCurrentMod()

--This file contains the logic that assigns and maintains prefixes; for prefix effects, see effects.lua

function IsPrefixValidForVek(prefix, vekType)
	local options = mod_loader.currentModContent[mod.id].options
	if options["Enable"..prefix] and not options["Enable"..prefix].enabled then return false end
	if _G[vekType].Prefixed then return false end									  --prevents double-prefixing
	if prefix == "Stable" and not _G[vekType].Pushable then return false end
	if prefix == "Fireproof" and _G[vekType].IgnoreFire then return false end
	if prefix == "Smokeproof" and _G[vekType].IgnoreSmoke then return false end
	if prefix == "Leaping" and (_G[vekType].Jumper or _G[vekType].Flying or _G[vekType].Burrows) then return false end
	if prefix == "Armored" and _G[vekType].Armor then return false end
	if prefix == "Heavy" and (_G[vekType].Health > 7 or _G[vekType].MoveSpeed < 3 or _G[vekType].VoidShockImmune) then return false end
	-- _G[vekType].VoidShockImmune is true for weaponless enemies, basically string.find(_G[vekType].Name, "Psion")/Blobber/Spider/...
	if prefix == "Light" and _G[vekType].Health == 1 then return false end
	if prefix == "Volatile" and _G[vekType].Explodes then return false end
	if prefix == "Massive" and (_G[vekType].Massive or _G[vekType].Flying) then return false end
	if prefix == "Undying" and (_G[vekType].Corpse or _G[vekType].IsDeathEffect) then return false end
	if prefix == "Burrowing" and (_G[vekType].Jumper or _G[vekType].Flying or _G[vekType].Burrows or _G[vekType].Tier == TIER_BOSS or _G[vekType].Health < 3) then return false end
	if prefix == "Ruinous" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Purifying" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Healing" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Spiteful" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Brood" and _G[vekType].IsDeathEffect then return false end
	if prefix == "Webbing" and (_G[vekType].Ranged == 1 or _G[vekType].MoveSpeed < 3) then return false end
	if prefix == "Splitting" and _G[vekType].MoveSpeed == 0 then return false end	
	if prefix == "Oozing" and _G[vekType].MoveSpeed == 0 then return false end	
	if prefix == "Infectious" and (_G[vekType].Ranged == 1 or _G[vekType].MoveSpeed < 3) then return false end	
	if prefix == "Regenerating" and _G[vekType].Health == 1 then return false end
	if prefix == "Wrathful" and _G[vekType].VoidShockImmune then return false end
	if prefix == "Cannibalistic" and _G[vekType].VoidShockImmune then return false end
	if prefix == "CopyingMelee" and (_G[vekType].Ranged == 1 or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1 or _G[vekType].Tier == TIER_BOSS) then return false end
	if prefix == "CopyingRanged" and (_G[vekType].Ranged == 0 or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1 or _G[vekType].Tier == TIER_BOSS) then return false end
	if prefix == "Tyrannical" and not string.find(_G[vekType].Name, "Psion") then return false end
	if prefix == "Mirroring" and (_G[vekType].VoidShockImmune or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1) then return false end
	if prefix == "Pushing" and (_G[vekType].VoidShockImmune or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1 or SEPushes(_G[vekType].SkillList[1]) or SEIsMirror(_G[vekType].SkillList[1])) then return false end
	if prefix == "Groundbreaking" and (_G[vekType].VoidShockImmune or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1 or SECracks(_G[vekType].SkillList[1])) then return false end
	if prefix == "Venomous" and (_G[vekType].VoidShockImmune or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1 or SEIsArtillery(_G[vekType].SkillList[1])) then return false end
	if prefix == "Frenzied" and (_G[vekType].VoidShockImmune or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1 or _G[vekType].Health == 1 or (_G[vekType].SkillList[1].Damage and (_G[vekType].SkillList[1].Damage <= 0 or _G[vekType].SkillList[1].Damage >= 3))) then return false end
	if prefix == "Freezing" and (_G[vekType].VoidShockImmune or not _G[vekType].SkillList or #_G[vekType].SkillList ~= 1 or (_G[vekType].SkillList[1].Damage and _G[vekType].SkillList[1].Damage <= 1) or SEIsFire(_G[vekType].SkillList[1]) or SEIsIce(_G[vekType].SkillList[1])) then return false end
	-- if prefix == "Grappling" and (_G[vekType].VoidShockImmune or #_G[vekType].SkillList ~= 1 or _G[vekType].Ranged == 0 or SEMovesSelf(_G[vekType].SkillList[1]) or SEIsArtillery(_G[vekType].SkillList[1])) then return false end
	return true
end

function CreateEvolvedVek(prefix, vekType)
	--local name = _G[vekType].Name
	local name = PAWN_FACTORY:CreatePawn(vekType):GetMechName()	--used because in AE, the .Name field has wrong values, eg. Dung Beetle instead of Tumblebug
	local portrait = "enemy/"..vekType
	if _G[prefix..vekType] and _G[prefix..vekType].Name == "Missing Mod" then _G[prefix..vekType] = nil end --error handling, seems to occur on load
	if _G[prefix..vekType] ~= nil then return true end
	if prefix == "Stable" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Pushable = false,} end
	if prefix == "Fireproof" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IgnoreFire = true,} end
	if prefix == "Smokeproof" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IgnoreSmoke = true,} end
	if prefix == "Leaping" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Jumper = true,} end
	if prefix == "Armored" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Armor = true,} end
	if prefix == "Heavy" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Health = _G[vekType].Health + 2, MoveSpeed = _G[vekType].MoveSpeed - 2,} end
	if prefix == "Light" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Health = _G[vekType].Health - 1, MoveSpeed = _G[vekType].MoveSpeed + 2,} end
	if prefix == "Volatile" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Explodes = true,} end
	if prefix == "Massive" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Massive = true,} end
	if prefix == "Undying" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Corpse = true, IsDeathEffect = true, GetDeathEffect = UndyingDE} end
	if prefix == "Burrowing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Burrows = true,} end
	if prefix == "Ruinous" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = RuinousDE} end
	if prefix == "Purifying" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = PurifyingDE} end
	if prefix == "Healing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = HealingDE} end
	if prefix == "Webbing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_WebbingWeapon" }, Weapon = 2,} end
	if prefix == "Splitting" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Splitting,} end
	if prefix == "Oozing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Oozing,} end
	if prefix == "Infectious" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Infectious,} end
	if prefix == "Regenerating" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Regenerating,} end
	if prefix == "Wrathful" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_WrathfulWeapon" }, Weapon = 2,} end
	if prefix == "CopyingMelee" then _G[prefix..vekType] = _G[vekType]:new{Name = "Copying".." "..name, Prefixed = true, Portrait = portrait, GetWeapon = CopyingMelee,} end
	if prefix == "CopyingRanged" then _G[prefix..vekType] = _G[vekType]:new{Name = "Copying".." "..name, Prefixed = true, Portrait = portrait, GetWeapon = CopyingRanged,} end
	if prefix == "Cannibalistic" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, GetWeapon = Cannibalistic,} end
	if prefix == "Spiteful" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = SpitefulDE} end
	if prefix == "Brood" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, IsDeathEffect = true, GetDeathEffect = BroodDE} end
	if prefix == "Tyrannical" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, Ranged = 1, SkillList = {"TyrannicalAtk1"}, Tooltip = ""} end
	if prefix == "Mirroring" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_MirrorWeapon" }, Weapon = 2} end
	if prefix == "Pushing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_PushingWeapon" }, Weapon = 2} end
	if prefix == "Groundbreaking" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_CrackingWeapon" }, Weapon = 2} end
	if prefix == "Venomous" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_VenomousWeapon" }, Weapon = 2} end
	if prefix == "Frenzied" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_FrenziedWeapon" }, Weapon = 2, Health = _G[vekType].Health - 1,} end
	if prefix == "Freezing" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_FreezingWeapon" }, Weapon = 2, } end
	-- if prefix == "Grappling" then _G[prefix..vekType] = _G[vekType]:new{Name = prefix.." "..name, Prefixed = true, Portrait = portrait, SkillList = { _G[vekType].SkillList[1], "Meta_GrapplingWeapon" }, Weapon = 2} end
	return false
end

function GeneratePrefix(pawn, nondeterministic)
	local tile = pawn:GetSpace()
	local options = mod_loader.currentModContent[mod.id].options
	if options["PrefixDeterministic"] and not options["PrefixDeterministic"].enabled then nondeterministic = true end
	if not nondeterministic then
		if string.find(pawn:GetMechName(), "Psion") and pawn:GetType() ~= "Jelly_Lava1" then return "Tyrannical" end 	--hardcoded but Tyrants should basically never be prefixed anyway
		if pawn:IsFire() and IsPrefixValidForVek("Fireproof", pawn:GetType()) then return "Fireproof" end
		if Board:IsEdge(tile) and IsPrefixValidForVek("Stable", pawn:GetType()) then return "Stable" end
		if Board:IsSmoke(tile) and IsPrefixValidForVek("Smokeproof", pawn:GetType()) then return "Smokeproof" end
		if pawn:GetMutation() == 4 and IsPrefixValidForVek("Regenerating", pawn:GetType()) then return "Regenerating" end
		if pawn:GetMutation() == 5 and IsPrefixValidForVek("Armored", pawn:GetType()) then return "Armored" end
		if pawn:GetMutation() == 6 and IsPrefixValidForVek("Volatile", pawn:GetType()) then return "Volatile" end	
		if pawn:GetMutation() == 7 and IsPrefixValidForVek("Wrathful", pawn:GetType()) then return "Wrathful" end
		if pawn:IsDamaged() and IsPrefixValidForVek("Frenzied", pawn:GetType()) then return "Frenzied" end
		if GetCurrentMission() == Mission_BlobBoss and IsPrefixValidForVek("Oozing", pawn:GetType()) then return "Oozing" end
	end
	local prefixes = {"Stable","Fireproof","Smokeproof","Leaping","Armored","Heavy","Light","Volatile","Massive","Undying","Burrowing","Ruinous","Purifying","Healing","Spiteful","Brood","Splitting","Oozing","Infectious","Regenerating","Wrathful","Webbing","Cannibalistic","CopyingMelee","CopyingRanged","Mirroring","Pushing","Groundbreaking","Venomous","Frenzied","Freezing"}
	-- local prefixes = {"Webbing","Wrathful"}
	local prefix = ""
	local i = 0
	repeat
		prefix = prefixes[math.random(#prefixes)]
		i = i + 1
	until IsPrefixValidForVek(prefix, pawn:GetType()) or i > 100
	if prefix == "" then prefix = "Heavy" end 	--default to that
	return prefix
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
					Board:Ping(tile, COLOR_BLACK)
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
			GetCurrentMission():RemoveSpawnPoint(spawnData.location)
			modApi:runLater(function()
				GetCurrentMission():SpawnPawn(spawnData.location, GAME.EvolvedVeks[i].Prefix..GAME.EvolvedVeks[i].Type)
				Board:Ping(spawnData.location, COLOR_BLACK)
			end)
			GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining - 1
			break
		end
	end
end

local function HOOK_ProcessVekRetreat(mission, endFx, pawn)
	--check pawn should be evolved, generate a random valid prefix for it, add it to _G
	if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetTeam() ~= TEAM_BOTS and not _G[pawn:GetType()].Prefixed and not pawn:IsFrozen() and not pawn:IsDead() and not pawn:IsMinor() then
		local i = 0
		local prefix
		repeat
			prefix = GeneratePrefix(pawn, i > 0)	--this'll make the prefix random past first try in case eg. Fireproof causes Missing Mod...
			CreateEvolvedVek(prefix, pawn:GetType())
			if _G[prefix..pawn:GetType()].Name == "Missing Mod" then LOG(prefix.." "..pawn:GetType().." was a Missing Mod???") end
			i = i + 1
		until _G[prefix..pawn:GetType()].Name ~= "Missing Mod" or i > 100
		if GAME.EvolvedVeks == nil then GAME.EvolvedVeks = {} end
		local found = false
		for i = 1, #GAME.EvolvedVeks do
			if GAME.EvolvedVeks[i].Type == pawn:GetType() and GAME.EvolvedVeks[i].Prefix == prefix then GAME.EvolvedVeks[i].Remaining = GAME.EvolvedVeks[i].Remaining + 1 found = true break end
		end
		if not found then GAME.EvolvedVeks[#GAME.EvolvedVeks+1] = {Type = pawn:GetType(), Prefix = prefix, Remaining = 1} end
		LOG("Added a "..prefix.." "..pawn:GetType()..", we stored "..tostring(#GAME.EvolvedVeks).." different Vek.")
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
	modApi:addMissionStartHook(HOOK_MissionStart)			--add evolved Vek at start of battle
	modApi:addVekSpawnAddedHook(HOOK_VekSpawnAdded)			--replace spawns with evolved Vek	
	modApi:addProcessVekRetreatHook(HOOK_ProcessVekRetreat)	--iterate on surviving Vek to evolve them
	--modApi:addPreLoadGameHook(HOOK_PostLoadGame)			--for undoturn? doesn't seem to help
	modApi:addPostLoadGameHook(HOOK_PostLoadGame)			--regenerate entries in _G as needed by the EvolvedVeks table
	-- modApi:addModsLoadedHook(HOOK_PostLoadGame)				--regenerate entries in _G as needed by the EvolvedVeks table
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
