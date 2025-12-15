include("shared.lua")
function ENT:UpdatePoseParameters( steer )
	self:SetPoseParameter( "steer_wheels", -steer )
end