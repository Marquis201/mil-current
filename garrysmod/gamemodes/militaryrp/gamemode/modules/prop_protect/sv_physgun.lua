hook.Add('EntityTakeDamage', 'AntiPK.EntityTakeDamage', function(pl, dmginfo)
	if (dmginfo:GetDamageType() == DMG_CRUSH) then
		return true
	end
end)

local vec = Vector(0, 0, 0)

hook.Add("OnPhysgunPickup", "StopCollideBitch", function(p, e)
	if IsValid(e) and ! e:IsPlayer() and e:GetClass() ~= 'wheelchair' then
		if e.Old_ColGroup or ! e.Old_ColGroup then
			e.Old_ColGroup = e:GetCollisionGroup() or COLLISION_GROUP_NONE
			e:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			local phys = e:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
				phys:SetVelocityInstantaneous(vec)
				phys:EnableMotion(false)
			end
		end
	end
end)

hook.Add("OnPhysgunReload", "NoNonono", function()
	return false
end)
