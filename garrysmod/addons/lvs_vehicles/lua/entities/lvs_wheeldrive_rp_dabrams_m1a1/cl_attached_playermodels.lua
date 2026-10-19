
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawGunner()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "gunner" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "gunner" ) return end

	local ID = self:LookupAttachment( "gunner" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "gunner" ) return end

	local Pos,Ang = LocalToWorld( Vector(0,0,-3), Angle(-5,10,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "gunner" )

	model:SetSequence( "sit_passive" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawComm()
	local pod = self:GetCommSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "commander" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "commander" ) return end

	local ID = self:LookupAttachment( "comm_seat" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "commander" ) return end

	local Pos,Ang = LocalToWorld( Vector(-3,-45,0), Angle(0,0,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "commander" )

	model:SetSequence( "walk_slam" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawLoader()
	local pod = self:GetLoaderSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "loader" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "loader" ) return end

	local ID = self:LookupAttachment( "loader" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel( "loader" ) return end

	local Pos,Ang = LocalToWorld( Vector(15,-6,0), Angle(-121,10,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "loader" )

	model:SetSequence( "cwalk_knife" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawTopGunner()
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
