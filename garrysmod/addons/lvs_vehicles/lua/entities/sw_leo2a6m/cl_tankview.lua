
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

				local ID = self:LookupAttachment( "turret" )

				local Muzzle = self:GetAttachment( ID )

				if Muzzle then
					pos =  Muzzle.Pos+Muzzle.Ang:Right()*18+Muzzle.Ang:Up()*9.5+Muzzle.Ang:Forward()*5
				end

			end
		end
	end
	return pos, angles, fov
end

function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )
	return self:CalcTankView( ply, pos, angles, fov, pod )
end
