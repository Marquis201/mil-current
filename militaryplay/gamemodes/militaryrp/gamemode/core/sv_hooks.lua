local GM = GM
local mp = mp
local player_manager = player_manager
local OZ = OZ
local net = net

function GM:PlayerSetHandsModel(pl, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(pl:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)
	if (info) then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end

function GM:PlayerSpawn(pl)
	local _, pos = hook.Call("PlayerSelectSpawn", GAMEMODE, pl)

	pl:SetPos(pos)

	hook.Call("PlayerLoadout", GAMEMODE, pl);

	player_manager.SetPlayerClass(pl, "player_mp")

	hook.Run("PostPlayerSpawn", pl)

	local oldHands = pl:GetHands()

	if (IsValid(oldHands)) then
		oldHands:Remove()
	end

	pl:SetupHands()
	pl:StripAmmo()
	pl:GiveAmmo(5, "40MM", true)
end

function GM:OnNPCKilled(npc, attacker)
	if attacker:IsPlayer() then
		attacker:AddFrags(1)
	end
end

local addStats = {
	maxhealth = function(pl, num)
		pl:SetMaxHealth(num)
	end,
	maxarmor = function(pl, num)
		pl:SetMaxArmor(num)
	end
}

local function BoostSpeedSystem(pl)
	if pl:HasLevel(mp.Perks[13].level) then
		return mp.Perks[13].effect
	elseif pl:HasLevel(mp.Perks[12].level) then
		return mp.Perks[12].effect
	elseif pl:HasLevel(mp.Perks[11].level) then
		return mp.Perks[11].effect
	else
		return 0
	end
end

function GM:PlayerLoadout(pl)
	local team = mp.jobs[pl:Team()]

	if not (team) then return end

	if team.stats then
		for k, v in pairs(team.stats) do
			if addStats[k] then
				addStats[k](pl, v)
			end
		end
	end

	pl:ShouldDropWeapon(false)

	if (pl:FlashlightIsOn()) then
		pl:Flashlight(false)
	end

	pl:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	pl:SetMoveType(MOVETYPE_WALK)
	pl:Extinguish()
	pl:UnSpectate()
	pl:GodDisable()
	pl:StopZooming()

	pl:AllowFlashlight(true)
	pl:SetModelScale(1)
	pl:SetCanZoom(false)

	pl:SetJumpPower(mp.config.player_stats.jumppower)
	pl:SetRunSpeed(mp.config.player_stats.runspeed)
	pl:SetWalkSpeed(mp.config.player_stats.walkspeed)

	local rank = pl:GetNetVar("meta_rank")
	local rank_weapons = {}

	if rank then
		rank_weapons = (mp.ranks[rank] and mp.ranks[rank].weapons) and mp.ranks[rank].weapons or
			{}
	end

	for i = 1, #rank_weapons do
		pl:Give(rank_weapons[i])
	end

	pl:SetNoTarget(team.notarget and team.notarget or false)

	for i = 1, #team.weapons do
		pl:Give(team.weapons[i])
	end

	if pl:IsAdmin() then
		for k, v in ipairs(mp.config.admin_weapons) do
			pl:Give(v)
		end
	end

	pl:Give("weapon_hands")
	pl:SelectWeapon("weapon_hands")
	pl:SetCustomCollisionCheck(true)

	local features = pl:GetNetVar("meta_features")
	local profession = mp.profession[features]

	if profession and profession.model then
		if istable(profession.model) then
			pl:SetModel(profession.model
				[math.random(1, #profession.model)])
		else
			pl:SetModel(profession.model)
		end

		if profession.spawn then
			profession.spawn(pl)
		end
	elseif team.model then
		if istable(team.model) then
			pl:SetModel(table.Random(team.model))
		else
			pl:SetModel(team.model)
		end

		if pl and team.spawn then
			team.spawn(pl)
		end
	end

	local run_boost = BoostSpeedSystem(pl)

	pl.OldRunSpeed = pl:GetRunSpeed() + (run_boost * (pl:GetRunSpeed() / 100))
	pl.OldWalkSpeed = pl:GetWalkSpeed()
	pl.OldJumpPower = pl:GetJumpPower()

	return true
end

function GM:GetFallDamage(pl, flFallSpeed)
	return (flFallSpeed / 12)
end

function GM:PlayerSpawnSWEP(pl, class, info)
	return pl:IsAdmin()
end

function GM:PlayerGiveSWEP(pl, class, info)
	return pl:IsAdmin()
end

function GM:PlayerSpawnEffect(pl, model)
	return pl:IsAdmin()
end

function GM:PlayerSpawnVehicle(pl, model, class, info)
	return pl:IsAdmin()
end

function GM:PlayerSpawnedVehicle(pl, ent)
	return pl:IsAdmin()
end

function GM:PlayerSpawnNPC(pl, type, weapon)
	return pl:IsAdmin()
end

function GM:PlayerSpawnedNPC(pl, ent)
	return pl:IsAdmin()
end

function GM:PlayerSpawnRagdoll(pl, model)
	return pl:IsAdmin()
end

function GM:PlayerSpawnedRagdoll(pl, model, ent)
	return pl:IsAdmin()
end

function GM:PlayerSpawnSENT(pl, class)
	return pl:IsAdmin()
end

function GM:PlayerSpawnProp(pl, model)
	return pl:IsAdmin()
end

function GM:ShowHelp(pl)
	pl:ConCommand("CreateHelpMenu")
end

function GM:PlayerEnteredVehicle(pl, vehicle, role)
	return false
end

function GM:PlayerUse(pl, ent)
	return true
end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
	if ent.PhysgunFreeze and (ent:PhysgunFreeze(pl) == false) then
		return false
	end

	if not IsValid(phys) then return end
	if (ent:GetPersistent()) then return false end
	if (! phys:IsMoveable()) then return false end
	if (ent:GetUnFreezable()) then return false end

	phys:EnableMotion(false)

	if (ent:GetClass() == "prop_vehicle_jeep") then
		local objects = ent:GetPhysicsObjectCount()

		for i = 0, objects - 1 do
			local physobject = ent:GetPhysicsObjectNum(i)

			physobject:EnableMotion(false)
		end
	end

	pl:AddFrozenPhysicsObject(ent, phys)

	return true
end

function StopDS()
	return true
end

hook.Add("PlayerDeathSound", "StopDS", StopDS)

local allowed = {
	["76561198131773834"] = true,
}

hook.Add("CheckPassword", "access_whitelist", function(steamID64)
	if allowed[steamID64] then
		return true
	end
end)

local function MakeInvisible(pl, invisible)
	pl:SetNoDraw(invisible)
	pl:SetNotSolid(invisible)

	pl:DrawWorldModel(not invisible)

	if (invisible) then
		pl:GodEnable()
	else
		pl:GodDisable()
	end
end

hook.Add("PlayerNoClip", "mp.PlayerNoCLip", function(pl, desiredNoClipState)
	MakeInvisible(pl, desiredNoClipState)
	pl.NoclipPlayer = desiredNoClipState
end)

do
	function GM:DoPlayerDeath(pl, attacker, dmginfo) end

	function GM:PlayerDeathThink(pl) end

	function GM:PlayerDeath(pl, weapon, killer) end

	--[[function GM:PlayerCanHearPlayersVoice(listener, talker) end
	function GM:PlayerStartTaunt(pl, act, l) end
	function GM:PlayerAuthed(pl) end
	function GM:PlayerSay(pl, text, teamonly, dead) end
	function GM:CanDrive(pl, ent) end
	function GM:CanProperty(pl, property, ent) end
	function GM:CanTool(pl, trace, mode) end
	function GM:PlayerSpray(pl) end
	function GM:PlayerShouldTaunt(pl, actid) end
	function GM:CanPlayerSuicide(pl) end
	function GM:PlayerNoClip(pl, on) end
	function GM:PlayerInitialSpawn(pl) end
	function GM:OnPlayerChangedTeam(pl, oldTeam, newTeam) end
	function GM:PlayerCanPickupWeapon(pl, weapon) end
	function GM:PlayerSetModel(pl) end
	function GM:PlayerDisconnected(pl) end
	function GM:PlayerTraceAttack(pl, dmginfo, dir, trace) end
	function GM:SetPlayerSpeed(pl, walk, run) end
	function GM:PlayerFootstep(pl, vPos, iFoot, strSoundName, fVolume, pFilter) end
	function GM:PlayerStepSoundTime(pl, iType, bWalking) end
	function GM:FindUseEntity(pl, ent) end
	function GM:PlayerTick(pl, mv) end
	function GM:PlayerSwitchWeapon(pl, oldwep, newwep) end
	function GM:ShouldDropWeapon() end
	function GM:InitPostEntity() end
	function GM:CanDropWeapon(pl, weapon) end]]
end
