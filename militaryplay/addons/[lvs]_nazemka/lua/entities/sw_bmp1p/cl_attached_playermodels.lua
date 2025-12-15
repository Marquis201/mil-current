
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawGunner()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "gunner" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "gunner" ) return end

	local ID = self:LookupAttachment( "turret" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "gunner" ) return end

	local Pos,Ang = LocalToWorld( Vector(-8,5,-25), Angle(0,0,0), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "gunner" )

	if self:GetHatch() then
		model:SetSequence( "idle_rpg" )
	else
		model:SetSequence( "sit" )
	end
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawGunner()
	return true
end
