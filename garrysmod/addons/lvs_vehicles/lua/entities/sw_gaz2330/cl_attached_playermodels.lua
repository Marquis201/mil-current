
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawGunner()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "passenger" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "passenger" ) self:SetBodygroup(2,0) return end

	if self:GetHatch() then
		local ID = self:LookupAttachment( "turret" )
		local Att = self:GetAttachment( ID )
	
		if not Att then self:RemovePlayerModel( "passenger" ) return end
	
		local Pos,Ang = LocalToWorld( Vector(0,-5,-40), Angle(0,90,0), Att.Pos, Att.Ang )
	
		local model = self:CreatePlayerModel( ply, "passenger" )
	
		self:SetBodygroup(2,1)
	
		if self:GetNWInt("Loadout") == 5 then
			model:SetSequence( "idle_rpg" )
		else
			model:SetSequence( "idle_dual" )
		end
		model:SetRenderOrigin( Pos )
		model:SetRenderAngles( Ang )
		model:DrawModel()
	else
		local ID = self:LookupAttachment( "root" )
		local Att = self:GetAttachment( ID )
	
		if not Att then self:RemovePlayerModel( "passenger" ) return end
	
		local Pos,Ang = LocalToWorld( Vector(25,-20,47), Angle(0,90,0), Att.Pos, Att.Ang )
	
		local model = self:CreatePlayerModel( ply, "passenger" )
	
		self:SetBodygroup(2,1)
	
		model:SetSequence( "sit" )
		model:SetRenderOrigin( Pos )
		model:SetRenderAngles( Ang )
		model:DrawModel()
	end
end

function ENT:PreDraw()
	self:DrawGunner()
	return true
end