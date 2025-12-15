
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:TopDrawGunner()
	local pod = self:GetTopGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "gunner" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "gunner" ) return end

	local ID = self:LookupAttachment( "mg_gunner" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "gunner" ) return end

	local Pos,Ang = LocalToWorld( Vector(13,-35,0), Angle(0,15,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "gunner" )

	model:SetSequence( "idle_camera" )
	model:SetRenderOrigin( Pos - Ang:Forward() * 5 )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:TopDrawGunner()

	return true
end
