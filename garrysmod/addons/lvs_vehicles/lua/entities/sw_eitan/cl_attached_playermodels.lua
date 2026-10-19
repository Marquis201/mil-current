
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawCommander()
	local pod = self:GetCommanderSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "commander" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "commander" ) return end

	local ID = self:LookupAttachment( "root" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "commander" ) return end

	local Pos,Ang = LocalToWorld( Vector(15,-15,57), Angle(0,90,0), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "commander" )
	
	if self:GetHatch() then
		model:SetSequence( "idle_passive" )
	else
		model:SetSequence( "sit" )
	end
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawCommander()
	return true
end