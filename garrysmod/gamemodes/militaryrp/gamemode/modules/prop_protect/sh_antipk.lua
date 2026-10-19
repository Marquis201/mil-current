local Tag = "mp.PropKill"
local HookAdd = hook.Add
local HookRun = hook.Run
local ignore
local isvalid = IsValid

HookAdd("PhysgunPickup", Tag, function(pl, ent)
	if CLIENT then
		if not ent:IsWorld() then return end
		ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	else
		if ent:IsPlayer() then return end
		if ignore then return end
		ignore = true
		local canTouch = HookRun("PhysgunPickup", pl, ent)
		ignore = false

		if canTouch and not ent:CreatedByMap() and not (ent:GetCollisionGroup() == COLLISION_GROUP_WORLD) then
			ent.Old_ColGroup = ent:GetCollisionGroup() or COLLISION_GROUP_NONE
			ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end
	end
end)

if SERVER then
	HookAdd("PlayerSpawnedVehicle", Tag, function(pl, ent)
		ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		ent:CPPISetOwner(pl)
	end)

	HookAdd("PlayerSpawnedSENT", "pp.PlayerSpawnedSENT", function(pl, ent)
		ent:CPPISetOwner(pl)
	end)

	HookAdd("PlayerEnteredVehicle", Tag, function(pl, ent)
		ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end)

	HookAdd("PlayerLeaveVehicle", Tag, function(pl, ent)
		timer.Simple(1, function()
			if isvalid(ent) then
				ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			end
		end)
	end)

	HookAdd("PhysgunDrop", Tag, function(pl, ent)
		if ent:GetClass() == 'wheelchair' then return end
		if ent:IsPlayer() then return end
		ent:SetPos(ent:GetPos())

		if ent.Old_ColGroup then
			ent:SetCollisionGroup(ent.Old_ColGroup)
			ent.Old_ColGroup = nil
		end

		local phys = ent:GetPhysicsObject()

		if isvalid(phys) then
			phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
		end
	end)
end
