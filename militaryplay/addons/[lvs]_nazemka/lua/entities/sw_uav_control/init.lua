AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass(100)
	local DriverSeat = self:AddDriverSeat( Vector(-50,50,-5), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true
	DriverSeat.ExitPos = Vector(-20,0,20)
end

function ENT:Use( ply )
	if IsValid(self:GetNWEntity("UAV")) then
		if self:GetNWEntity("UAV"):GetAI() then return end
		ply:EnterVehicle(self:GetNWEntity("UAV"):GetDriverSeat())
		self:GetNWEntity("UAV"):AlignView( ply )
	
		if hook.Run( "LVS.CanPlayerDrive", ply, self ) ~= false then
			ply:EnterVehicle( self:GetNWEntity("UAV"):GetDriverSeat() )
			self:GetNWEntity("UAV"):AlignView( ply )
		else
			hook.Run( "LVS.OnPlayerCannotDrive", ply, self )
		end
	end
end

function ENT:Explode()
	if self.ExplodedAlready then return end

	self.ExplodedAlready = true

	if IsValid(self:GetNWEntity("UAV")) then
		local Driver = self:GetNWEntity("UAV"):GetDriver()

		if IsValid( Driver ) then
			self:HurtPlayer( Driver, Driver:Health() + Driver:Armor(), self.FinalAttacker, self.FinalInflictor )
		end
		self:GetNWEntity("UAV"):SetlvsLockedStatus(true)
	end

	self:OnFinishExplosion()

	self:Remove()
end