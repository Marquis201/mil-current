
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawGunner()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "gunner" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "gunner" ) return end

	local ID = self:LookupAttachment( "gunner_seat" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "gunner" ) return end

	local Pos,Ang = LocalToWorld( Vector(0,0,0), Angle(-5,10,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "gunner" )

	model:SetSequence( "sit_knife" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawMGSeat()
	local pod = self:GetMGSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "commander" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "commander" ) return end

	local ID = self:LookupAttachment( "comm_seat" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "commander" ) return end

	local Pos,Ang = LocalToWorld( Vector(0,-5,0), Angle(0,10,-95), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "commander" )

	model:SetSequence( "sit_knife" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end
