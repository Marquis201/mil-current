
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetDriverSeat() then
		if not pod:GetThirdPersonMode() then
			pos = self:LocalToWorld(Vector(45,21,102))
		end
	end
	return pos, angles, fov
end

function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )
	return self:CalcTankView( ply, pos, angles, fov, pod )
end
