local col_on, col_off = Color(0, 0, 0, 100), Color(255, 255, 255)

function PLAYER:ProtectOn(time)
	self:SetColor(col_on)
	self:SetRenderMode(4)
	self.protected = true
	self:Timer("Protection", time, 1, function(ply)
		ply:SetColor(col_off)
		ply:SetRenderMode(0)
		ply.protected = nil
	end)
end

function PLAYER:ProtectOff()
	self:SetColor(col_off)
	self:SetRenderMode(0)
	self.protected = nil
end

hook.Add("rp.SelectRandomSpawn", "FlameDev.Protect_Elable", function(ply)
	ply:ProtectOn(5)
end)

hook.Add("PlayerShouldTakeDamage", "FlameDev.Protect.PlayerShouldTakeDamage", function(ply, attacker)
	if ply.protected then
		return false
	end
	if IsValid(attacker) and attacker.protected then
		return false
	end
end)

hook.Add("ScalePlayerDamage", "FlameDev.Protect.ScalePlayerDamage", function(ply, hitgroup, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if (IsValid(attacker) and attacker.protected) or ply.protected then
		dmginfo:ScaleDamage(0)
	end
end)
