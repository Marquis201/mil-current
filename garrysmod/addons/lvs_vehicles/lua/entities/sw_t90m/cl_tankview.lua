
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetGunnerSeat() then

		angles = ply:EyeAngles() 
		if not pod:GetThirdPersonMode() then
			if ply:lvsKeyDown( "ZOOM" ) then

				local ID = self:LookupAttachment( "view" )

				local Muzzle = self:GetAttachment( ID )

				if Muzzle then
					pos =  Muzzle.Pos - Muzzle.Ang:Up() * -3
				end

			else

				local ID = self:LookupAttachment( "view" )

				local Muzzle = self:GetAttachment( ID )

				if Muzzle then
					pos =  Muzzle.Pos
				end

			end
		end
	end


	if pod == self:GetCommanderSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "view_com" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos
		end
	end

	return pos, angles, fov
end

function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )
	return self:CalcTankView( ply, pos, angles, fov, pod )
end
