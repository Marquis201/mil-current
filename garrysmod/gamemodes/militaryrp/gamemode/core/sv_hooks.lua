local GM = GM
local mp = mp
local player_manager = player_manager
local OZ = OZ
local net = net
local Vector = Vector
local Angle = Angle

NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_CLEANUP = 3
NOTIFY_HINT = 4

local randomWeapons = {
	"tfa_ins2_ak12",
	"tfa_ins2_wpn_hkg36compact",
	"tfa_ins2_uzi",
	"tfa_ins2_wpn_m40a1",
	"tfa_ins2_l85a2"
}

local function InternalSpawnNPC(Player, Position, Normal, Class, Equipment)
	local NPCList = list.Get("NPC")
	local NPCData = NPCList[Class]

	if (! NPCData) then
		return
	end

	if (NPCData.AdminOnly && ! Player:IsAdmin()) then return end

	local bDropToFloor = false

	if (NPCData.OnCeiling && Vector(0, 0, -1):Dot(Normal) < 0.95) then
		return nil
	end

	if (NPCData.OnFloor && Vector(0, 0, 1):Dot(Normal) < 0.95) then
		return nil
	else
		bDropToFloor = true
	end

	if (NPCData.NoDrop) then bDropToFloor = false end

	local Offset = NPCData.Offset or 32
	Position = Position + Normal * Offset

	local NPC = ents.Create(NPCData.Class)
	if (! IsValid(NPC)) then return end

	NPC:SetPos(Position)
	NPC:SetHealth(200)

	local Angles = Angle(0, 0, 0)

	if (IsValid(Player)) then
		Angles = Player:GetAngles()
	end

	Angles.pitch = 0
	Angles.roll = 0
	Angles.yaw = Angles.yaw + 180

	if (NPCData.Rotate) then Angles = Angles + NPCData.Rotate end

	NPC:SetAngles(Angles)

	if (NPCData.Model) then
		NPC:SetModel(NPCData.Model)
	end

	if (NPCData.Material) then
		NPC:SetMaterial(NPCData.Material)
	end

	local SpawnFlags = bit.bor(SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK)
	if (NPCData.SpawnFlags) then SpawnFlags = bit.bor(SpawnFlags, NPCData.SpawnFlags) end
	if (NPCData.TotalSpawnFlags) then SpawnFlags = NPCData.TotalSpawnFlags end
	NPC:SetKeyValue("spawnflags", SpawnFlags)

	if (NPCData.KeyValues) then
		for k, v in pairs(NPCData.KeyValues) do
			NPC:SetKeyValue(k, v)
		end
	end

	if (NPCData.Skin) then
		NPC:SetSkin(NPCData.Skin)
	end

	local valid = false
	for _, v in pairs(list.Get("NPCUsableWeapons")) do
		if v.class == Equipment then
			valid = true
			break
		end
	end

	if (Equipment && Equipment != "none" && valid) then
		NPC:SetKeyValue("additionalequipment", Equipment)
		NPC.Equipment = Equipment
	end

	--local randomWeapon = table.Random(randomWeapons)
	--NPC:SetKeyValue("additionalequipment", randomWeapon)
	--NPC.Equipment = randomWeapon

	NPC:Spawn()
	NPC:Activate()
	NPC:SetSchedule(SCHED_PATROL_WALK)

	local numBodyGroups = NPC:GetNumBodyGroups()
	for i = 0, numBodyGroups - 1 do
		local count = NPC:GetBodygroupCount(i)
		if count > 1 then
			NPC:SetBodygroup(i, math.random(0, count - 1))
		end
	end

	if (bDropToFloor && ! NPCData.OnCeiling) then
		NPC:DropToFloor()
	end

	return NPC
end

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
	pl:SetRadioSpeak(true)
	pl:SetRadioMicro(true)
	pl:StopZooming()
	pl:SetCanZoom(false)
end

function GM:OnNPCKilled(npc, attacker)
	if attacker:IsPlayer() then
		attacker:AddFrags(1)
		attacker:AddPoints(15)

		mp.util.Notify(attacker, NOTIFY_GENERIC, "Вы получили: " .. 15 .. " поинтов за убийство npc!")
	end

	if npc.spawn_id and npc.respawn_data then
		local t = npc.respawn_data

		timer.Create("RespawnNPC." .. npc:EntIndex(), 300, 1, function()
			local ent = InternalSpawnNPC(nil, t.pos, t.normal, t.class, t.ang)
			ent.spawn_id = npc.spawn_id
			ent.respawn_data = {
				pos = t.pos,
				ang = t.ang,
				normal = t.normal,
				class = t.class
			}
		end)
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

function GM:PlayerLoadout(pl)
	local team = mp.jobs[pl:Team()]

	if not (team) then
		timer.Simple(1, function()
			if IsValid(pl) then
				if not pl:GetNetVar("meta_character") then
					pl:RequestCharacters(function(characters, player_data)
						netstream.Start(pl, "OpenCharacterMenu", { characters = characters })
						pl.Characters = characters
					end)
					return
				end
			end
		end)
		return
	end

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

	pl.OldRunSpeed = pl:GetRunSpeed()
	pl.OldWalkSpeed = pl:GetWalkSpeed()
	pl.OldJumpPower = pl:GetJumpPower()

	pl:SetSaveBodyGroup()

	if pl.sg_jail then return end

	timer.Simple(1, function()
		if IsValid(pl) then
			if not pl:GetNetVar("meta_character") then
				pl:RequestCharacters(function(characters, player_data)
					netstream.Start(pl, "OpenCharacterMenu", { characters = characters })
					pl.Characters = characters
				end)
				return
			end
		end
	end)

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

	return true
end

function GM:CanPlayerEnterVehicle(pl, veh, role)
	if veh:GetNWInt("pPodIndex") and IsValid(veh:GetParent()) and not pl:CanEnterVehicle(veh:GetParent():GetClass(), veh:GetNWInt("pPodIndex"), true) then
		return false
	end

	return true
end

function GM:GetFallDamage(pl, flFallSpeed)
	return (flFallSpeed / 12)
end

function GM:PlayerSpawnSWEP(pl, class, info)
	if pl.sg_jail then return false end

	return pl:IsAdmin() and pl:CheckLimit("sents")
end

function GM:PlayerGiveSWEP(pl, class, info)
	if pl.sg_jail then return false end

	return pl:IsAdmin()
end

function GM:PlayerSpawnEffect(pl, model)
	if pl.sg_jail then return false end

	return pl:IsAdmin() and pl:CheckLimit("effects")
end

function GM:PlayerSpawnVehicle(pl, model, class, info)
	if pl.sg_jail then return false end

	return pl:IsAdmin() and pl:CheckLimit("vehicles")
end

local list_gp25 = {
	["sw_bmp1"] = true,
	["sw_bmp1am"] = true,
	["sw_bmp1m"] = true,
	["sw_bmp1p"] = true,
	["sw_bmp2"] = true,
	["sw_bmp2m"] = true,
	["sw_bmp3"] = true,
	["sw_bmp3m"] = true,
	["lvs_wheeldrive_m3a3"] = true,
	["lvs_wheeldrive_rp_dabrams_m1a1"] = true,
	["lvs_wheeldrive_rp_t90m"] = true,
	["lvs_wheeldrive_dabrams_m1a1"] = true,
	["lvs_wheeldrive_nonrp_t90m"] = true,
}

function GM:PlayerSpawnedSENT(pl, ent)
	if list_gp25[ent:GetClass()] then
		ent.stop_25gp = true
	end
end

function GM:PlayerSpawnedVehicle(pl, ent)
	return pl:IsAdmin()
end

function GM:PlayerSpawnNPC(pl, type, weapon)
	if pl.sg_jail then return false end

	return pl:IsAdmin() and pl:CheckLimit("npcs")
end

function GM:PlayerSpawnedNPC(pl, ent)
	return pl:IsAdmin()
end

function GM:PlayerSpawnRagdoll(pl, model)
	if pl.sg_jail then return false end

	return pl:IsAdmin() and pl:CheckLimit("ragdolls")
end

function GM:PlayerSpawnedRagdoll(pl, model, ent)
	return pl:IsAdmin()
end

function GM:PlayerSpawnSENT(pl, class)
	if pl.sg_jail then return false end

	return pl:IsAdmin() and pl:CheckLimit("sents")
end

function GM:PlayerSpawnProp(pl, model)
	if not mp.SpawnProp(pl, model) then return false end
	if pl.sg_jail then return false end

	local wep = pl:GetActiveWeapon()
	return (pl:IsAdmin() or (IsValid(wep) and wep:GetClass() == "alydus_fortificationbuildertablet")) and
		pl:CheckLimit("props")
end

function GM:ShowHelp(pl)
	pl:ConCommand("CreateHelpMenu")
end

function GM:PlayerEnteredVehicle(pl, vehicle, role)
	if not pl.god_mode and pl:HasGodMode() then
		pl:GodDisable()
	end
end

function GM:PlayerLeaveVehicle(pl, vehicle)
	if not pl.god_mode and pl:HasGodMode() then
		pl:GodDisable()
	end
end

function GM:PlayerUse(pl, ent)
	if ent:IsDoor() then
		if ent:DoorState() == 0 or ent:DoorState() == 3 then
			timer.Create("AutoCloseDoor." .. ent:EntIndex(), 15, 1, function()
				if IsValid(ent) and not ent:GetPropertyClose() then
					ent:Fire("close")
				end
			end)
		end

		if ent:DoorState() == 1 or ent:DoorState() == 3 then return false end
	end

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

hook.Add("Conquest_FlagCaptured", "mp.RewardFlag.Conquest_FlagCaptured", function(owner, name)
	local flag

	for k, v in pairs(Conquest.cache) do
		if v.owner == owner and v.name == name then
			flag = v

			break
		end
	end

	if not flag or not IsValid(flag.flagent) then return end

	local players = ents.FindInSphere(flag.flagent:GetPos(), flag.radius)

	for k, pl in ipairs(players) do
		if IsValid(pl) and pl:IsPlayer() and pl:Alive() and Conquest.TeamManager.QuickCache[pl:Team()] and Conquest.TeamManager.QuickCache[pl:Team()] == owner then
			pl:AddPoints(mp.config.flag_reward)
		end
	end
end)

do
	function GM:DoPlayerDeath(pl, attacker, dmginfo) end

	function GM:PlayerDeathThink(pl) end

	function GM:PlayerDeath(pl, weapon, killer) end

	function GM:CanTool(pl, trace, mode)
		return mp.PlayerCanTool(pl, trace.Entity, mode)
	end

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

hook.Add("PlayerDisconnected", "mp.PlayerDisconnected.RemoveProps", function(pl)
	local all = ents.GetAll()
	for k, v in ipairs(all) do
		local owner = v:CPPIGetOwner()

		if owner and owner == pl then
			v:Remove()
		end
	end
end)

hook.Add("PlayerSpawnedProp", "mp.PlayerSpawnedProp.RemoveProp", function(pl, mdl, ent)
	if IsValid(ent) and not IsValid(ent.isPlayerPlacedFortification) then
		local wep = pl:GetActiveWeapon()
		if not pl:IsAdmin() and not (IsValid(wep) and wep:GetClass() == "alydus_fortificationbuildertablet") then
			ent:Remove()
		end
	end
end)

hook.Add("PropBreak", "mp.PropBreak", function(client, prop)
	if IsValid(prop) then
		prop:Remove()
	end
end)

hook.Add("OnEntityCreated", "mp.RandomNPCWeapon", function(ent)
	if ent:GetClass() == "npc_combine_s" then
		timer.Simple(0.1, function()
			if not IsValid(ent) then return end
			if not ent:IsNPC() then return end

			local randomWeapon = table.Random(randomWeapons)
			ent:Give(randomWeapon)
			ent:SetKeyValue("additionalequipment", randomWeapon)
			ent.Equipment = randomWeapon

			if math.random(1, 3) == 1 then
				ent:Give("weapon_frag")
			end
		end)
	end
end)

local function SpawnNPCS()
	for k, v in ipairs(ents.FindByClass("npc_combine_s")) do
		if IsValid(v) and v.spawn_id then
			v:Remove()
		end
	end

	for k, v in pairs(mp.config.spawn_npcs) do
		for i, ent in ipairs(ents.FindByClass("prop_physics")) do
			if IsValid(ent) and ent.spawn_id == k then
				ent:Remove()
			end
		end

		for i, t in ipairs(v) do
			if t.class == "prop_physics" then
				local ent = ents.Create(t.class)
				if (! IsValid(ent)) then continue end

				if t.mdl then
					ent:SetModel(t.mdl)
				end

				ent.spawn_id = k
				ent:SetAngles(t.ang)
				ent:SetPos(t.pos)
				ent:Spawn()
				ent:Activate()

				local phys = ent:GetPhysicsObject()

				if IsValid(phys) then
					phys:EnableMotion(false)
				end
			else
				local tr = util.TraceLine({
					start = t.pos + Vector(0, 0, 16),
					endpos = t.pos - Vector(0, 0, 128),
					mask = MASK_SOLID_BRUSHONLY
				})

				local ent = InternalSpawnNPC(nil, t.pos, tr.HitNormal, t.class, t.ang)

				if ent then
					ent.spawn_id = k
					ent.respawn_data = {
						pos = t.pos,
						ang = t.ang,
						normal = tr.HitNormal,
						class = t.class
					}
				end
			end
		end
	end
end

local config_entity = {
	// РФ

	{
		class = "vehicles_sales", pos = Vector(-13636, -11403, -468), ang = Angle(0, 90, 0),
	},
	{
		class = "bodygroup", pos = Vector(-12138, -11992, -428), ang = Angle(0, 180, 0),
	},
	{
		class = "armor_take", pos = Vector(-12080, -11818, -436), ang = Angle(0, -90, 0),
	},
	{
		class = "armor_take", pos = Vector(-12022, -11818, -436), ang = Angle(0, -90, 0),
	},

	{
		class = "wesupplycrate", pos = Vector(-12136, -12207, -456), ang = Angle(0, 0, 0),
	},
	{
		class = "wesupplycrate", pos = Vector(-12136, -12144, -456), ang = Angle(0, 0, 0),
	},
	{
		class = "wesupplycrate", pos = Vector(-12136, -12072, -455), ang = Angle(0, 0, 0),
	},
	{
		class = "lvs_vehicle_repair", Vector(-13520, -11616, -507), ang = Angle(0, 0, 0),
	},
	{
		class = "npc_trainer_rf", pos = Vector(-12978, -10208, -472), ang = Angle(0, 90, 0)
	},
	{
		class = "form_store", pos = Vector(-11293, -7387, -472), ang = Angle(0, 76, 0)
	},

	// NATO

	{
		class = "lvs_vehicle_repair", Vector(11336, -1394, -512), ang = Angle(0, -105, 0),
	},
	{
		class = "vehicles_sales", pos = Vector(12433, -1314, -468), ang = Angle(0, 0, 0),
	},
	{
		class = "armor_take", pos = Vector(11639, -3577, -436), ang = Angle(0, -90, 0),
	},
	{
		class = "armor_take", pos = Vector(11700, -3577, -436), ang = Angle(0, -90, 0),
	},
	{
		class = "wesupplycrate", pos = Vector(11624, -4014, -455), ang = Angle(0, 0, 0),
	},
	{
		class = "wesupplycrate", pos = Vector(11625, -3949, -456), ang = Angle(0, 0, 0),
	},
	{
		class = "wesupplycrate", pos = Vector(11624, -3881, -456), ang = Angle(0, 0, 0),
	},
	{
		class = "wesupplycrate", pos = Vector(11624, -3811, -456), ang = Angle(0, 0, 0),
	},
	{
		class = "wesupplycrate", pos = Vector(11624, -3745, -456), ang = Angle(0, 0, 0),
	},
	{
		class = "npc_trainer_nato", pos = Vector(12742, -2164, -472), ang = Angle(0, -90, 0)
	},
	{
		class = "form_store", pos = Vector(11727, -4588, -472), ang = Angle(0, 15, 0)
	}
}

local function CreateEntity()
	for k, v in ipairs(ents.GetAll()) do
		if IsValid(v) and v.perma_prop then
			v:Remove()
		end
	end

	for k, v in ipairs(config_entity) do
		local ent = ents.Create(v.class)
		if not IsValid(ent) then continue end

		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
			phys:EnableGravity(false)
			phys:Sleep()
		end

		ent.perma_prop = true
	end
end

local RemoveHoks = {
	{
		id = "PlayerSpawnProp",
		name = "restrictions.PlayerSpawnProp"
	}
}

hook.Add("InitPostEntity", "mp.CreateNPCs", function()
	--SpawnNPCS()
	CreateEntity()

	for k, v in ipairs(RemoveHoks) do
		hook.Remove(v.id, v.name)
	end
end)

hook.Add("PostCleanupMap", "mp.PostCleanupMap", function()
	--SpawnNPCS()
	CreateEntity()
end)

local time_salary = 600
local function PayDay(pl)
	if pl.sg_jail then return end

	local cd_time = CurTime()
	pl.cd_salary = pl.cd_salary or cd_time + time_salary
	if pl.cd_salary > cd_time then return end

	local t = mp.jobs[pl:Team()]

	if not t or not t.salary then return end

	pl:AddPoints(t.salary)

	mp.util.Notify(pl, NOTIFY_HINT, "Вы получаете денежное довольствие в размере " .. mp.FormatMoney(t.salary))

	pl.cd_salary = cd_time + time_salary
end

local cd = CurTime() + 5
hook.Add("Think", "mp.PlayerThink", function()
	local cd_time = CurTime()
	if cd > cd_time then return end

	local pls = player.GetAll()
	local count = player.GetCount()

	for i = 1, count do
		local pl = pls[i]

		if not IsValid(pl) then continue end

		PayDay(pl)
	end

	cd = cd_time + 5
end)
