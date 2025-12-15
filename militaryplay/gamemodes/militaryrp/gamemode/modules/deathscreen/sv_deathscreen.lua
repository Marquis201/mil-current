local hook = hook
local mp = mp
local util = util
local IsValid = IsValid
local CurTime = CurTime
local net = net

util.AddNetworkString("mp.DeathScreen")

local function RespawnTimerSystem(pl)
	if pl:IsUserGroup("founder") then return 3 end

	if pl:HasLevel(mp.Perks[19].level) then
		return mp.Perks[19].effect
	elseif pl:HasLevel(mp.Perks[18].level) then
		return mp.Perks[18].effect
	elseif pl:HasLevel(mp.Perks[17].level) then
		return mp.Perks[17].effect
	else
		return mp.config.reswn_time
	end
end

local function CreateRagdoll(pl)
	if IsValid(pl.RevivalRagdoll) then return end
	if pl:Alive() then return end

	if IsValid(pl:GetActiveWeapon()) then
		pl.ReviveActiveWeapon = pl:GetActiveWeapon():GetClass()
	end

	pl.ReviveWeapons = {}
	for k, v in pairs(pl:GetWeapons()) do
		if not IsValid(v) then continue end
		table.insert(pl.ReviveWeapons, v:GetClass())
	end

	pl.RevivePos = pl:GetPos()
	pl.ReviveAng = pl:EyeAngles()

	pl.RevivalPreviousAmmo = {}
	for k, v in pairs(pl:GetWeapons()) do
		local primary = v:GetPrimaryAmmoType()
		local secondary = v:GetSecondaryAmmoType()

		local newPrimary = math.floor(pl:GetAmmoCount(primary))
		local newSecondary = math.floor(pl:GetAmmoCount(secondary))

		pl.RevivalPreviousAmmo[primary] = newPrimary
		pl.RevivalPreviousAmmo[secondary] = newSecondary
	end

	local rag = ents.Create("prop_ragdoll")
	rag:SetPos(pl:GetPos())
	rag:SetModel(pl:GetModel())
	rag:SetAngles(pl:GetAngles())
	rag:SetColor(pl:GetColor())
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

	pl.RevivalRagdoll = rag

	pl:Spectate(OBS_MODE_CHASE)
	pl:SpectateEntity(pl.RevivalRagdoll)

	pl.CannotBeRevived = true

	timer.Create("RemoveRevive." .. rag:EntIndex(), 30, 1, function()
		if IsValid(rag) and not IsValid(rag.owner) then
			rag:Remove()
		end
	end)
end

hook.Add("DoPlayerDeath", "mp.DoPlayerDeath", function(pl, attacker, dmginfo)
	pl:AddDeaths(1)

	if (attacker:IsValid() and attacker:IsPlayer()) then
		if (attacker == pl) then
			attacker:AddFrags(-1)
		else
			attacker:AddFrags(1)
		end
	end

	local time = RespawnTimerSystem(pl)
	pl.deadtime = CurTime() + time

	pl:SetNetVar("revive.Info", {
		time = CurTime() + time,
		death = time,
		killer = (IsValid(attacker) and attacker:IsPlayer()) and attacker or nil,
	})

	net.Start("mp.DeathScreen")
	net.Send(pl)

	CreateRagdoll(pl)
end)

hook.Add("PlayerDeathThink", "mp.RespawnTimer", function(pl)
	--local time = RespawnTimerSystem(pl)

	--if pl.deadtime and pl.deadtime > CurTime() then
	--	return false
	--end

	--pl:SetNetVar("revive.Info", nil)
	--pl:Spawn()

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
