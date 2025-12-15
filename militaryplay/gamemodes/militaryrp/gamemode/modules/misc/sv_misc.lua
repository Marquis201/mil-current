hook.Add( "CanPlayerSuicide", "playerNoDeath", function(ply)
	if ply.dealy_suicide and ply.dealy_suicide > CurTime() then 
       -- rp.notify( ply, 1, 4, "Подождите " .. math.Round(ply.dealy_suicide - CurTime()) .. " сек." )
        return false
	else
		ply.dealy_suicide = CurTime() + 600

		return true
    end
end)