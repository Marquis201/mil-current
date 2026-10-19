hook.Add( "KeyPress", "AntiLadderGlitchFly", function( ply, key )
	if ( key == IN_USE ) then
		if not IsValid(ply) then return end
		if ply:IsPlayer() and ply:Alive() then
			if IsValid(ply:GetActiveWeapon()) then
				if ply:GetActiveWeapon():GetClass() == "weapon_physgun" then
					if ply:GetMoveType() == MOVETYPE_LADDER and ply:GetActiveWeapon():GetClass() == "weapon_physgun" then
						ply:ConCommand("-attack")
					end
				end	
			end
		end
	end
end)