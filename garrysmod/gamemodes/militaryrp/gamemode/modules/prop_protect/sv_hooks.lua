local Tools = {
	["Дубликатор"] = true,
	["Стакер"] = true,
	["#Tool.stacker.name"] = true,
	["Advanced Duplicator 2"] = true,
	["#Tool.advdupe2.name"] = true,
}

local HookAdd = hook.Add

function mp.SpawnProp(pl, mdl)
	if pl.lastPropSpawn and (pl.lastPropSpawn + .2 >= CurTime()) then
		local wep = pl:GetActiveWeapon()
		local tool = pl:GetTool()

		if (Tools and wep and wep:GetClass() == "gmod_tool" and Tools[tool.Name]) and (pl.lastToolGun and pl.lastToolGun + .25 >= CurTime()) then return true end

		mp.util.Notify(pl, NOTIFY_ERROR, "Пожалуйста, не создавайте пропы так быстро.")

		if pl.failedPropAttempts and (pl.failedPropAttempts >= 5) and (pl.toldStaff ~= true) then
			local admins = {}

			for k, v in ipairs(player.GetAll()) do
				if (v:IsAdmin()) then
					admins[#admins + 1] = v
				end
			end

			serverguard.Notify(admins, pl:Name() .. " был остановлен из-за спавна пропов. Следите за ним!")

			pl.toldStaff = true
		end

		pl.lastPropSpawn = CurTime()
		pl.failedPropAttempts = (pl.failedPropAttempts or 0) + 1
		pl.lastToolGun = CurTime()

		return false
	end

	pl.toldStaff          = nil
	pl.failedPropAttempts = nil
	pl.lastPropSpawn      = CurTime()
	pl.lastToolGun        = CurTime()

	return true
end

local function isvehicle(ent)
	return ent:GetClass() == "lvs_wheeldrive_engine" or ent.IsSimfphyscar or ent:IsVehicle() or ent.LVS
end

HookAdd("PhysgunDrop", "mp.PhysgunDrop", function(pl, ent)
	ent.BeingPhysed = false
	if IsValid(ent) and (not ent:IsPlayer()) and ent:GetClass() ~= "wheelchair" then
		local veh = isvehicle(ent)
		--if IsValid(ent) and ent:InSpawn() then ent:Remove() end

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) and (ent:IsProp() or ent.FreezeEnt) then
			phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
			phys:SetVelocityInstantaneous(Vector(0, 0, 0))
			ent:GetPhysicsObject():EnableMotion(false)

			if ent:GetClass() ~= "gmod_cameraprop" then
				ent:SetCollisionGroup(COLLISION_GROUP_NONE)
			end

			ent.FreezeEnt = nil
		end

		if veh or not ent:IsProp() then
			ent:SetCollisionGroup(COLLISION_GROUP_NONE)
		else
			local ents = ents.FindInSphere(ent:GetPos(), 25)

			for k, v in ipairs(ents) do
				if IsValid(v) and v:IsPlayer() then
					ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)

					return
				end
			end
		end

		ent:SetRenderMode(RENDERMODE_NORMAL)
		ent:SetColor(Color(255, 255, 255, 255))
	end

	if IsValid(ent) and ent:IsPlayer() then
		local ents = ents.FindInSphere(ent:GetPos(), 25)

		for k, v in ipairs(ents) do
			if IsValid(v) and v:IsProp() then
				v:SetRenderMode(RENDERMODE_TRANSALPHA)
				v:SetColor(Color(255, 255, 255, 100))
				v:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			end
		end
	end
end)

local function IsInside(pos, ent)
	if (not IsValid(ent)) then return false end

	local vmin = ent:OBBMins()
	local vmax = ent:OBBMaxs()
	local vpos = ent:WorldToLocal(pos)

	vmin = vmin + Vector(vmin.x / 2, vmin.y / 2, vmin.z / 2)
	vmax = vmax - Vector(vmax.x / 2, vmax.y / 2, vmax.z / 2)

	return vpos:WithinAABox(vmax, vmin)
end

HookAdd("PlayerSpawnedProp", "pp.PlayerSpawnedProp", function(pl, mdl, ent)
	--if IsValid(ent) and ent:InSpawn() then ent:Remove() end
	local ghost = true
	local remove = false

	for k, v in ipairs(ents.FindInSphere(ent:GetPos(), 100)) do
		--[[if IsValid(v) and (v:CPPIGetOwner()) and IsInside(ent:GetPos(), v) then
			ent:Remove()
			remove = true
		end]]

		if not remove and IsValid(v) and v:IsPlayer() and v:GetPos():Distance(ent:GetPos()) < 50 then
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetColor(Color(255, 255, 255, 100))
			ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			ghost = false
		end
	end

	if remove then return end

	ent:SetCustomCollisionCheck(true)
	ent:CPPISetOwner(pl)
	local phys = ent:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:EnableGravity(false)
		phys:Sleep()
	end

	if ghost then
		ent:SetCollisionGroup(COLLISION_GROUP_NONE)
	end

	ent:DrawShadow(false)
end)

local CantTouch = {
	["prop_door_rotating"] = true,
	["prop_dynamic"] = true,
	["func_breakable_surf"] = true,
	["wheelchair"] = true,
}

HookAdd("PhysgunPickup", "pp.PhysgunPickup", function(pl, ent)
	if IsValid(ent) then
		if CantTouch[ent:GetClass()] then return false end
		if ent.PermaProps then return false end

		local canphys = mp.PlayerCanManipulate(pl, ent)

		if (not canphys) and ent.PhysgunPickup then
			canphys = ent:PhysgunPickup(pl)
		elseif ent.LazyFreeze then
			canphys = ((ent.ItemOwner == pl) or (ent.AllLazyFreeze == true)) and (not ent.BeingPhysed)
		end

		if (canphys == true) and not ent:IsPlayer() then
			ent.BeingPhysed = true
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetColor(Color(255, 255, 255, 100))
			hook.Call("PlayerPhysgunEntity", GAMEMODE, pl, ent)
		end

		return canphys
	end
	return false
end)

HookAdd("OnPhysgunFreeze", "pp.OnPhysgunFreeze", function(weapon, physobj, ent, pl)
	ent.BeingPhysed = false

	if IsValid(physobj) and (ent.ItemOwner == pl or ent.AllLazyFreeze) and ent.LazyFreeze then
		return false
	end

	ent.FreezeEnt = true

	return true
end)
