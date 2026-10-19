
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawLoader()
	local pod = self:GetLoaderSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "loader" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "loader" ) return end


	local ID = self:LookupAttachment( "mg_yaw" )
	local Att = self:GetAttachment( ID )
	local ID2 = self:LookupAttachment( "turret" )
	local Att2 = self:GetAttachment( ID2 )
	
	if not Att then self:RemovePlayerModel( "loader" ) return end
	if not Att2 then self:RemovePlayerModel( "loader" ) return end
	
	local Pos,Ang = LocalToWorld( Vector(0,0,-45), Angle(0,0,0), Att.Pos, Att.Ang )
	local Pos2,Ang2 = LocalToWorld( Vector(-20,20,-23), Angle(0,0,0), Att2.Pos, Att2.Ang )
	
	local model = self:CreatePlayerModel( ply, "loader" )
	
	if self:GetHatchLoader() then
		model:SetSequence( "idle_dual" )
		model:SetRenderOrigin( Pos )
		model:SetRenderAngles( Ang )
	else
		model:SetSequence( "sit" )	
		model:SetRenderOrigin( Pos2 )
		model:SetRenderAngles( Ang2 )	
	end

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
	
	local Pos,Ang = LocalToWorld( Vector(2,-22,-23), Angle(0,0,0), Att.Pos, Att.Ang )
	
	local model = self:CreatePlayerModel( ply, "gunner" )

	model:SetSequence( "sit" )	
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )	
	model:DrawModel()
end

function ENT:DrawCommander()
	local pod = self:GetCommanderSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "commander" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "commander" ) return end


	local ID = self:LookupAttachment( "turret" )
	local Att = self:GetAttachment( ID )
	
	if not Att then self:RemovePlayerModel( "commander" ) return end
	
	local Pos,Ang = LocalToWorld( Vector(-30,-22,-5), Angle(0,0,0), Att.Pos, Att.Ang )
	
	local model = self:CreatePlayerModel( ply, "commander" )

	model:SetSequence( "sit" )	
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )	
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawLoader()
	self:DrawGunner()
	self:DrawCommander()
	return true
end
function ENT:PreDrawTranslucent()
	self:DrawLoader()
	self:DrawGunner()
	self:DrawCommander()
	return true
end