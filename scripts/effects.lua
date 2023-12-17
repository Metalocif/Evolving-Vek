
--------------------------------------
--Skill Effect Modification prefixes--
--------------------------------------

--These prefixes add a second weapon to the pawn it will always choose (instead of the original).
--That second weapon runs the target area and skill effect of the first one, modifying the skill effect.
--Some prefixes just alter stats/traits and won't use anything in this file.	

Meta_MirrorWeapon = Skill:new{
	Name="Mirror",
	Description="Copies the user's other weapon, firing it forward and backwards.",
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

function Meta_MirrorWeapon:GetTargetArea(point)
	return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
end

function Meta_MirrorWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dist = p1:Manhattan(p2)
	local revDir = GetDirection(p1-p2)
	local target = p1
	repeat
		target = target + DIR_VECTORS[revDir]
	until target:Manhattan(p1) == dist or not Board:IsValid(target + DIR_VECTORS[revDir])
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		local revFx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, target)
		ret.q_effect:AppendAll(fx.q_effect)
		ret.q_effect:AppendAll(revFx.q_effect)
		ret.effect:AppendAll(fx.effect)
		ret.effect:AppendAll(revFx.effect)
	end
	return ret
end


Meta_PushingWeapon = Skill:new{
	Name="Pushing",
	Description="Copies the user's other weapon, adding push to all damages that don't push.",
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

function Meta_PushingWeapon:GetTargetArea(point)
	return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
end

function Meta_PushingWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		local new_damage_list = DamageList()
		for i = 1, fx.q_effect:size() do
			local curr_space_damage = fx.q_effect:index(i)
			if curr_space_damage.iPush == DIR_NONE and curr_space_damage.loc ~= p1 then 
				curr_space_damage.iPush = GetDirection(curr_space_damage.loc - p1) 
			end
			new_damage_list:push_back(curr_space_damage)
		end
		fx.q_effect = new_damage_list
		ret = fx
	end
	return ret
end


Meta_CrackingWeapon = Skill:new{
	Name="Groundbreaking",
	Description="Copies the user's other weapon, cracking tiles hit.",
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

function Meta_CrackingWeapon:GetTargetArea(point)
	if Board:GetPawn(point) then
		return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
	end
	return PointList()
end

function Meta_CrackingWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		local new_damage_list = DamageList()
		for i = 1, fx.q_effect:size() do
			local curr_space_damage = fx.q_effect:index(i)
			if curr_space_damage.iDamage > 0 then curr_space_damage.iCrack = 1 end
			new_damage_list:push_back(curr_space_damage)
		end

		fx.q_effect = new_damage_list
		ret = fx
	end
	return ret
end


Meta_VenomousWeapon = Skill:new{
	Name="Venomous",
	Description="Copies the user's other weapon, firing an acid projectile first.",
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

function Meta_VenomousWeapon:GetTargetArea(point)
	return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
end

function Meta_VenomousWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		if p1 ~= p2 then
			local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
			local target = GetProjectileEnd(p1, p2, PATH_PROJECTILE)
			local acidDamage = SpaceDamage(target)
			acidDamage.iAcid = 1
			fx:AddProjectile(p1, acidDamage, "effects/shot_firefly2", NO_DELAY)
			ret = fx
		end
	end
	return ret
end



Meta_WebbingWeapon = Skill:new{
	Name="Webbing",
	Description="Copies the user's other weapon, webbing adjacent enemies first.",
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

function Meta_WebbingWeapon:GetTargetArea(point)
	return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
end

function Meta_WebbingWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		for i = DIR_START, DIR_END do
			local curr = p1 + DIR_VECTORS[i]
			if (Board:GetPawn(curr) and Board:GetPawn(curr):GetTeam() == TEAM_PLAYER) or Board:IsBuilding(curr) then fx:AddGrapple(p1, curr, "hold") end
		end
		ret = fx
	end
	return ret
end


Meta_FrenziedWeapon = Skill:new{
	Name="Frenzied",
	Description="Copies the user's other weapon, dealing two more damage.",
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

function Meta_FrenziedWeapon:GetTargetArea(point)
	return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
end

function Meta_FrenziedWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		local new_damage_list = DamageList()
		for i = 1, fx.q_effect:size() do
			local curr_space_damage = fx.q_effect:index(i)
			if curr_space_damage.iDamage > 0 then curr_space_damage.iDamage = curr_space_damage.iDamage + 2 end
			new_damage_list:push_back(curr_space_damage)
		end

		fx.q_effect = new_damage_list
		ret = fx
	end
	return ret
end

Meta_WrathfulWeapon = Skill:new{
	Name="Wrathful",
	Description="Copies the user's other weapon, dealing one more damage.",
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

function Meta_WrathfulWeapon:GetTargetArea(point)
	return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
end

function Meta_WrathfulWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		ret = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		ret:AddScript(string.format("modApi:runLater(function() Board:GetPawn(%s):SetBoosted(true) end)", p1:GetString()))
	end
	return ret
end


Meta_FreezingWeapon = Skill:new{
	Name="Freezing",
	Description="Copies the user's other weapon, freezing anything it damages.",
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

function Meta_FreezingWeapon:GetTargetArea(point)
	return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
end

function Meta_FreezingWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	if Board:GetPawn(p1) then	--otherwise we get errors on moving/death
		local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		local new_damage_list = DamageList()
		for i = 1, fx.q_effect:size() do
			local curr_space_damage = fx.q_effect:index(i)
			if curr_space_damage.iDamage > 0 then curr_space_damage.iFrozen = 1 end
			new_damage_list:push_back(curr_space_damage)
		end

		fx.q_effect = new_damage_list
		ret = fx
	end
	return ret
end


-- Meta_GrapplingWeapon = Skill:new{
	-- Name="Grappling",
	-- Description="Copies the user's other weapon, grappling first.",
	-- Class = "Enemy",
	-- Icon = "weapons/enemy_scarab1.png",
	-- Projectile = "",
	-- Explosion = "",
	-- ImpactSound = "",
	-- TipImage = {
		-- Unit = Point(2,4),
		-- Enemy = Point(2,1),
		-- Building = Point(2,2),
		-- Target = Point(2,1),
		-- CustomPawn = "Jelly_Health1"
	-- }
-- }

-- function Meta_GrapplingWeapon:GetTargetArea(point)
	-- return _G[Board:GetPawn(point):GetWeaponType(1)]:GetTargetArea(point)
-- end

-- function Meta_GrapplingWeapon:GetSkillEffect(p1, p2)
	-- local ret = SkillEffect()
	
	-- if Board:GetPawn(p1) then 
		-- local fx = _G[Board:GetPawn(p1):GetWeaponType(1)]:GetSkillEffect(p1, p2)
		-- if p1:Manhattan(p2) > 1 then		--checks p1 ~= p2 and we are not adjacent
			-- local dir = GetDirection(p2-p1)
			-- local target = p1 + DIR_VECTORS[dir]
			-- while not Board:IsBlocked(target, PATH_PROJECTILE) and Board:IsValid(target) do
				-- target = target + DIR_VECTORS[dir]
			-- end
			-- local valid = true
		
			-- if not Board:IsValid(target) then valid = false end
			-- if (Board:GetPawn(target):IsGuarding() or Board:GetTerrain(target) == TERRAIN_MOUNTAIN or Board:GetTerrain(target) == TERRAIN_BUILDING) and
			   -- (Board:GetTerrain(target - DIR_VECTORS[dir]) == TERRAIN_WATER or Board:GetTerrain(target - DIR_VECTORS[dir]) == TERRAIN_HOLE) and
			   -- not Board:GetPawn(p1):IsFlying() then
				-- -- if the dash would suicide, don't
				-- valid = false
			-- end
			-- if (Board:GetPawn(target):IsGuarding() or Board:GetTerrain(target) == TERRAIN_MOUNTAIN or Board:GetTerrain(target) == TERRAIN_BUILDING) and 
				-- Board:IsSmoke(target - DIR_VECTORS[dir]) and not Board:GetPawn(p1):IsIgnoreSmoke() then
				-- -- if the dash would put pawn in smoke, don't
				-- valid = false
			-- end
			-- if valid then 
				-- fx:AddProjectile(damage,"effects/shot_grapple")
				-- if Board:IsPawnSpace(target) and not Board:GetPawn(target):IsGuarding() then	-- If it's a pawn
					-- fx:AddCharge(Board:GetSimplePath(target, p1 + DIR_VECTORS[direction]), FULL_DELAY)
				-- elseif Board:IsBlocked(target, PATH_GROUND) then     --If it's an obstruction
					-- fx:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)	
				-- end
			-- end
		-- end
		-- ret = fx
	-- end
	-- return ret
-- end


--helper functions to check whether a weapon modifying prefix would be valid for a given weapon

function SEMovesSelf(skillName)
	local p1 = Point(4,4)
	local p2 = Point(4,5)
	local skillEffect = _G[skillName]:GetSkillEffect(p1,p2)
	for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
		if spacedamage and spaceDamage:IsMovement() and spaceDamage:GetMoveType() ~= 3 and spaceDamage:GetSource() == p1 then return true end
		--MoveType of 3 is just AddMelee
	end
	for _, spaceDamage in ipairs(extract_table(skillEffect.effect)) do
		if spacedamage and spaceDamage:IsMovement() and spaceDamage:GetMoveType() ~= 3 and spaceDamage:GetSource() == p1 then return true end
	end
	return false
end

function SEPushes(skillName)
	local p1 = Point(4,4)
	local p2 = Point(4,5)
	local skillEffect = _G[skillName]:GetSkillEffect(p1,p2)
	for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
		if spacedamage and spaceDamage.iPush ~= DIR_NONE then return true end
	end
	return false
end

function SEIsMirror(skillName)
	local p1 = Point(4,4)
	local p2 = Point(4,5)
	local revDir = GetDirection(p1-p2)
	local skillEffect = _G[skillName]:GetSkillEffect(p1,p2)
	for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
		if spacedamage and spacedamage.loc ~= p1 and GetDirection(spaceDamage.loc - p1) == revDir then return true end
	end
	return false
end

function SEIsArtillery(skillName)
	local p1 = Point(4,4)
	local p2 = Point(4,5)
	local skillEffect = _G[skillName]:GetSkillEffect(p1,p2)
	for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
		if spacedamage and spaceDamage:GetType() == 1 then return true end	--0 is no projectile displayed, 1 is artillery, 2 is projectile
	end
	return false
end

function SECracks(skillName)
	local p1 = Point(4,4)
	local p2 = Point(4,5)
	local skillEffect = _G[skillName]:GetSkillEffect(p1,p2)
	for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
		if spacedamage and spaceDamage.iCrack == 1 then return true end
	end
	return false
end

function SEIsFire(skillName)
	local p1 = Point(4,4)
	local p2 = Point(4,5)
	local skillEffect = _G[skillName]:GetSkillEffect(p1,p2)
	for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
		if spacedamage and spaceDamage.iFire == 1 then return true end
	end
	return false
end

function SEIsIce(skillName)
	local p1 = Point(4,4)
	local p2 = Point(4,5)
	local skillEffect = _G[skillName]:GetSkillEffect(p1,p2)
	for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
		if spacedamage and spaceDamage.iFrozen == 1 then return true end
	end
	return false
end

----------------------
--GetWeapon prefixes--
----------------------

--these prefixes are triggered by the GetWeapon function, which runs once at the start of movement
--so they are effects that trigger at movement start
--I use a conditional hook to make two trigger at the end of movement instead

function CopyingMelee()
	return Copying(false)
end

function CopyingRanged()
	return Copying(true)
end

function Copying(isRanged)
	local bestWeapon = ""
	local bestWeaponTier = 0
	if Pawn:GetWeaponCount() == 2 then
		bestWeapon = Pawn:GetWeaponType(2)
		bestWeaponTier = GetWeaponTier(bestWeapon)
	end
	for _, curr in ipairs(Board) do
		local target = Board:GetPawn(curr)
		if target and target:IsEnemy() and target:GetWeaponCount() > 0 and target:IsRanged() == isRanged then --and not target:GetTeam() == TEAM_BOTS then 
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

function GetWeaponTier(weaponType)
	if string.sub(weaponType, 1, -2) == "1" then return 1 end
	if string.sub(weaponType, 1, -2) == "2" then return 2 end
	if string.sub(weaponType, 1, -2) == "B" then return 3 end
	return 0
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

-- function Wrathful()
	-- modApi:conditionalHook(
		-- function()
			-- GAME.WrathfulPawnId = Pawn:GetId()
			-- return Pawn and Pawn:IsQueued() and string.find(Pawn:GetType(), "Wrathful") 
		-- end,
		-- function()
			-- ret = SkillEffect()
			-- ret:AddScript(string.format("Board:GetPawn(%s):SetBoosted(true)", GAME.WrathfulPawnId))
			-- Board:AddEffect(ret)
		-- end
	-- )
	-- return 1
-- end

-- function Webbing()
	-- modApi:conditionalHook(
		-- function()
			-- GAME.WebbingPawnId = Pawn:GetId()
			-- return Pawn and Pawn:IsQueued() and not Pawn:IsActive() and string.find(Pawn:GetType(), "Webbing") 
		-- end,
		-- function()
			-- local pawn = Board:GetPawn(GAME.WebbingPawnId)
			-- ret = SkillEffect()
			-- for i = DIR_START, DIR_END do
				-- local curr = pawn:GetSpace() + DIR_VECTORS[i]
				-- Board:Ping(curr, COLOR_BLACK)
				-- if Board:GetPawn(curr) and Board:GetPawn(curr):IsPlayer() then
					-- ret:AddGrapple(pawn:GetSpace(), curr, "hold")
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

-------------------------
--Extra Weapon prefixes--
-------------------------

--just adds a weapon to the pawn

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

-------------------------
--Death Effect prefixes--
-------------------------

--effects that trigger on death

function UndyingDE(pawn, point)
	ret = SkillEffect()
	if Board:GetTerrain(point) == TERRAIN_WATER then Pawn:SetCorpse(false) end
	return ret
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
		local curr = point + DIR_VECTORS[i]
		local damage = SpaceDamage(curr, -1)
		local pawn = Board:GetPawn(curr)
		if pawn and pawn:GetTeam() == TEAM_ENEMY and pawn:GetTeam() ~= TEAM_BOTS then 
			if pawn:IsDead() then ret:AddScript(string.format("Board:GetPawn(%s):SetHealth(1)", curr:GetString())) else ret:AddDamage(damage) end
		end
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

function BroodDE(pawn, point)
	ret = SkillEffect()
	local damage = SpaceDamage(point)
	damage.sPawn = "WebbEgg1"
	ret:AddDamage(damage)
	return ret
end
