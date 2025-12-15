include("shared.lua")

function ENT:UpdatePoseParameters( steer )
	self:SetPoseParameter( "steer_wheels", -steer )
end

function ENT:OnFrame()
	local Pod = ply:GetVehicle()
	if not IsValid(Pod) then return end
	
	if (Pod == self:GetGunnerSeat()) and (self:GetHatch()) then
		self:SetPoseParameter("hatch_gunner", 30)
		
	else
		self:SetPoseParameter("hatch_gunner", 0)	
	end
	
end

function ENT:PreDraw()
	self:DrawDriverTurret()

	return true
end

function ENT:DrawDriverTurret()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and plyL:GetViewEntity() == plyL and not pod:GetThirdPersonMode()) then return end

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return end

	local _,Ang = LocalToWorld( Vector(0,0,0), Angle(0,0,0), Muzzle.Pos, Muzzle.Ang )

	local LAng = self:WorldToLocalAngles( Ang )
	LAng.p = 0
	LAng.r = 0
	
	if self:GetHatch() then
		ply:SetSequence( "idle_all_02" )
		ply:SetModelScale(1, 0) 
	else
		ply:SetSequence( "cidle_knife" )	
		ply:SetModelScale(0.75, 0)
	end	
	ply:SetRenderAngles( self:LocalToWorldAngles( LAng ) )
	ply:DrawModel()
end

