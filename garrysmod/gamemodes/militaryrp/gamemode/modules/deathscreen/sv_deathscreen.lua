local hook = hook
local mp = mp
local util = util
local IsValid = IsValid
local CurTime = CurTime
local net = net

util.AddNetworkString("mp.DeathScreen")

local function CreateRagdoll(pl)
	if IsValid(pl.RevivalRagdoll) then return end
	if pl:Alive() then return end

	pl.ReviveWeapons = {}
	for k, v in pairs(pl:GetWeapons()) do
		if not IsValid(v) then continue end
		pl.ReviveWeapons[#pl.ReviveWeapons + 1] = v:GetClass()
	end

	pl.RevivePos = pl:GetPos()
	pl.ReviveAng = pl:EyeAngles()

	pl.RevivalPreviousAmmo = {}
	for k, v in pairs(pl:GetAmmo()) do
		pl.RevivalPreviousAmmo[k] = v
	end

	local rag = ents.Create("prop_ragdoll")
	rag:SetPos(pl:GetPos())
	rag:SetModel(pl:GetModel())
	rag:SetAngles(pl:GetAngles())
	rag:SetColor(pl:GetColor())
	rag:SetOwner(pl)
	rag.revive = true
	rag.owner = pl
	rag:Spawn()
	rag:Activate()
	rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	local num = rag:GetPhysicsObjectCount() - 1
	local v = pl:GetVelocity() / 2

	for I = 0, num do
		local bone = rag:GetPhysicsObjectNum(I)
		if IsValid(bone) then
			local bp, ba = pl:GetBonePosition(rag:TranslatePhysBoneToBone(I))
			if bp and ba then
				bone:SetPos(bp)
				bone:SetAngles(ba)
			end

			bone:SetVelocity(v)
		end
	end

	if pl:GetSaveBodygroup() and pl:GetSaveBodygroup()[pl:GetModel()] then
		local t = pl:GetSaveBodygroup()[pl:GetModel()]

		if t.skin then
			rag:SetSkin(tonumber(t.skin))
		end

		if t.bodygroup then
			for id, typ in pairs(t.bodygroup) do
				if not tonumber(id) or not tonumber(typ) then continue end
				rag:SetBodygroup(tonumber(id), tonumber(typ))
			end
		end
	end

	pl.RevivalRagdoll = rag

	pl:Spectate(OBS_MODE_CHASE)
	pl:SpectateEntity(pl.RevivalRagdoll)

	pl.CannotBeRevived = true

	timer.Create("RemoveRevive." .. rag:EntIndex(), pl.deadtime or 30, 1, function()
		if IsValid(rag) and not IsValid(rag.owner) then
			rag:Remove()
		end
	end)

	return rag
end

hook.Add("DoPlayerDeath", "mp.DoPlayerDeath", function(pl, attacker, dmginfo)
	pl:AddDeaths(1)
end)

hook.Add("PlayerDeath", "mp.Revive.PlayerDeath", function(pl, inflictor, attacker)
	if (IsValid(attacker) and attacker:IsPlayer()) then
		if (attacker == pl) then
			attacker:AddFrags(-1)
		else
			attacker:AddFrags(1)
		end
	end

	local time = mp.config.reswn_time
	pl.deadtime = CurTime() + time

	pl:SetNetVar("revive.Info", {
		time = CurTime() + time,
		death = time,
		killer = (IsValid(attacker) and attacker:IsPlayer()) and attacker or nil,
	})

	net.Start("mp.DeathScreen")
	net.Send(pl)

	if pl:InVehicle() then return end

	local rag = CreateRagdoll(pl)
end)

hook.Add("PlayerDeathThink", "mp.RespawnTimer", function(pl)
	return false
end)

hook.Add("CreateEntityRagdoll", "mp.Death.CreateEntityRagdoll", function(pl, ragdoll)
	if IsValid(ragdoll) then
		ragdoll:Remove()
		return false
	end
end)

hook.Add("OnEntityCreated", "mp.Death.OnEntityCreated", function(ent)
	if IsValid(ent) and ent:GetClass() == "hl2mp_ragdoll" then
		ent:Remove()
	end
end)

hook.Add("PlayerSpawn", "mp.RevivalPlayerSpawn", function(pl)
	if IsValid(pl.RevivalRagdoll) then
		pl.RevivalRagdoll:Remove()
		pl.CannotBeRevived = nil
	end

	if pl:GetReviveInfo() then
		pl:SetNetVar("revive.Info", nil)
	end
end)

timer.Create("ClearRagdolls", 120, 0, function()
	for k, v in ipairs(ents.FindByClass("prop_ragdoll")) do
		if v.revive and (IsValid(v.owner) and v.owner:Alive() or not IsValid(v.owner)) then
			v:Remove()
		end
	end
end)

hook.Add("OnNPCDropItem", "mp.OnNPCDropItem", function(npc, item)
	item:Remove()
end)

hook.Add("PlayerDroppedWeapon", "mp.PlayerDroppedWeapon", function(owner, wep)
	if owner:IsNPC() then
		wep:Remove()
	end
end)

local function OnNPCKilled(npc, attacker, inflictor)
	--npc:Remove()
end

hook.Add("OnNPCKilled", "mp.OnNPCKilled", OnNPCKilled)
