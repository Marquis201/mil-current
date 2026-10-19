
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawDriver()
	if IsValid(self:GetNWEntity("UAV")) then
		local pod = self:GetNWEntity("UAV"):GetDriverSeat()

		if not IsValid( pod ) then self:RemovePlayerModel( "driver" ) return self:SetBodygroup(1,0) end
	
		local plyL = LocalPlayer()
		local ply = pod:GetDriver()
	
		if not IsValid( ply ) then self:RemovePlayerModel( "driver" ) return self:SetBodygroup(1,0) end
	
		local model = self:CreatePlayerModel( ply, "driver" )
		model:SetSequence( "cidle_knife" )
		model:SetRenderOrigin( LocalToWorld(Vector(-30,0,-5),Angle(0,0,0),(self:LocalToWorld(Vector(0,0,0))),self:GetAngles()) )
		model:SetRenderAngles( self:LocalToWorldAngles(Angle(0,0,0)) )
		model:DrawModel()

		self:SetBodygroup(1,1)
	end
end


function ENT:PreDraw()
	self:DrawDriver()

	return true
end
