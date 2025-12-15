
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod, ent )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then

		local ID = self:LookupAttachment( "driver_eye" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos
		end
	end

	if pod == self:GetGunnerSeat() then

		angles = ply:EyeAngles() -- this will unlock the camera from tank rotation. See init.lua line 39 for server

		if not pod:GetThirdPersonMode() then
			if ply:lvsKeyDown( "ZOOM" ) then

				local ID = self:LookupAttachment( "gunner_visor" )

				local Muzzle = self:GetAttachment( ID )

				if Muzzle then
					pos =  Muzzle.Pos
				end

			else

				local ID = self:LookupAttachment( "gunner_eye" )

				local Muzzle = self:GetAttachment( ID )

				if Muzzle then
					pos =  Muzzle.Pos
				end

			end
		end
	end

	if pod == self:GetMGSeat() and not pod:GetThirdPersonMode() then	

		if self:GetHatch() then

			local ID = self:LookupAttachment( "mg_eye" )

			local Muzzle = self:GetAttachment( ID )

			if Muzzle then
				pos =  Muzzle.Pos
			end

		else
			local ID = self:LookupAttachment( "comm_eye" )

			local Muzzle = self:GetAttachment( ID )

			if Muzzle then
				pos =  Muzzle.Pos
			end
		end


	end

	return pos, angles, fov
end

function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )
	return self:CalcTankView( ply, pos, angles, fov, pod )
end
