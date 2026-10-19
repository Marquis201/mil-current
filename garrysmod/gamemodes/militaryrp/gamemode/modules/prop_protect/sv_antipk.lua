local HookAdd = hook.Add

HookAdd("PlayerShouldTakeDamage", "AntiPK_PlayerShouldTakeDamage", function(victim, attacker)
end)

HookAdd("EntityTakeDamage", "AntiPK.EntityTakeDamage", function(pl, dmginfo)
	if (dmginfo:GetDamageType() == DMG_CRUSH) then
		return true
	end
end)

HookAdd("ShouldCollide", "AntiPK.NoColide", function(ent1, ent2)
	--if IsValid(ent1) and IsValid(ent2) and Modification.Config.NoColide[ent1:GetClass()] and Modification.Config.NoColide[ent2:GetClass()] then
	--	return false
	--end
end)