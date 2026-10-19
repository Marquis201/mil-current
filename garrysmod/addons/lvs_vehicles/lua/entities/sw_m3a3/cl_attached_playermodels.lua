
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawCommander()
	local pod = self:GetCommanderSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "commander" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "commander" ) return end

	local ID = self:LookupAttachment( "turret" )
	local Att = self:GetAttachment( ID )
	
	if not Att then self:RemovePlayerModel( "commander" ) return end
	
	local Pos,Ang = LocalToWorld( Vector(-9,-15,40), Angle(0,50,0), Att.Pos, Att.Ang )
	
	local model = self:CreatePlayerModel( ply, "commander" )
	
	model:SetSequence( "sit" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawGunner()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "gunner" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "gunner" ) return end


	local ID = self:LookupAttachment( "turret" )
	local Att = self:GetAttachment( ID )
	
	if not Att then self:RemovePlayerModel( "gunner" ) return end
	
	local Pos,Ang = LocalToWorld( Vector(-11,13,40), Angle(0,-50,0), Att.Pos, Att.Ang )
	
	local model = self:CreatePlayerModel( ply, "gunner" )
	
	model:SetSequence( "sit" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawGunner()
	self:DrawCommander()
	return true
end
function ENT:PreDrawTranslucent()
	self:DrawGunner()
	self:DrawCommander()
	return true
end