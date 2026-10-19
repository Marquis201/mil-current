
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawGunner()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "passenger" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "passenger" ) self:SetBodygroup(2,0) return end

	local ID = self:LookupAttachment( "turret" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "passenger" ) return end

	local Pos,Ang = LocalToWorld( Vector(0,-5,-40), Angle(0,90,0), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "passenger" )

	model:SetSequence( "idle_dual" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawGunner()
	return true
end