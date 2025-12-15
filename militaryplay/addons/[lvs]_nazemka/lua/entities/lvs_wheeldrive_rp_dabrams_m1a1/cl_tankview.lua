
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
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

				local ID = self:LookupAttachment( "sight" )

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

	if pod == self:GetCommSeat() and not pod:GetThirdPersonMode() then
		if ply:lvsKeyDown( "ZOOM" ) then

		local ID = self:LookupAttachment( "cupola_sight" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos
		end

		else

		local ID = self:LookupAttachment( "comm_eye2" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Right() * 3
		end

		end
	end

	if pod == self:GetLoaderSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "loader" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Right() * 45 + Muzzle.Ang:Forward() * 10
		end
	end

	if pod == self:GetTopGunnerSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "mg_eye" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos
		end
	end

	return pos, angles, fov
end