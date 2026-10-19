
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawDriver()
	local pod = self:GetDriverSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "driver" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "driver" ) self:SetBodygroup(2,0) return end

	local ID = self:LookupAttachment( "root" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "driver" ) return end

	local Pos,Ang = LocalToWorld( Vector(0,-25,35), Angle(20,90,0), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "driver" )

	model:SetSequence( "drive_airboat" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:ManipulateBoneAngles(1,Angle(0,0,0))
	model:ManipulateBoneAngles(9,Angle(0,20,0))
	model:ManipulateBoneAngles(10,Angle(0,-20,0))
	model:ManipulateBoneAngles(14,Angle(0,20,0))
	model:ManipulateBoneAngles(15,Angle(0,-20,0))

	model:ManipulateBoneAngles(18,Angle(10,0,0))
	model:ManipulateBoneAngles(19,Angle(20,70,0))
	model:ManipulateBoneAngles(20,Angle(0,-40,0))
	model:ManipulateBoneAngles(22,Angle(-10,0,0))
	model:ManipulateBoneAngles(23,Angle(-20,70,0))
	model:ManipulateBoneAngles(24,Angle(0,-40,0))
	model:SetPoseParameter("vehicle_steer", self:GetSteer() /  self:GetMaxSteerAngle())
	model:DrawModel()
end
function ENT:PreDraw()
	self:DrawDriver()
	return true
end