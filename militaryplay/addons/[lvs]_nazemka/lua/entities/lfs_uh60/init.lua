--SHITTY CODE BY MERYDIAN

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 50 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick()
end

function ENT:RunOnSpawn()
	self:GetDriverSeat().ExitPos = Vector(190,75,11)
	
	self:AddPassengerSeat( Vector(110,21,10), Angle(0,-90,2) ).ExitPos = Vector(140,75,11)
	self:AddPassengerSeat( Vector(29,14,10), Angle(0,90,2) ).ExitPos = Vector(140,75,11)
	self:AddPassengerSeat( Vector(29,-25,10), Angle(0,90,2) ).ExitPos = Vector(140,75,11)
	self:AddPassengerSeat( Vector(-53,14,10), Angle(0,-90,2) ).ExitPos = Vector(140,75,11)
	self:AddPassengerSeat( Vector(-53,-25,10), Angle(0,-90,2) ).ExitPos = Vector(140,75,11)
	self:AddPassengerSeat( Vector(-53,-6,10), Angle(0,-90,2) ).ExitPos = Vector(140,75,11)

end

function ENT:PrimaryAttack()
end

function ENT:SecondaryAttack()
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:OnEngineStarted()	
end

function ENT:OnEngineStopped()
end

function ENT:HandleWeapons(Fire1, Fire2, Fire3)
end

function ENT:GetMissileOffset()
end

function ENT:OnRotorDestroyed()
	self:EmitSound( "physics/metal/metal_box_break2.wav" )
	
	self:SetBodygroup( 3, 2 )
	self:SetBodygroup( 4, 2 ) 
	
	self:SetHP(1)
	
	timer.Simple(2, function()
		if not IsValid( self ) then return end
		self:Destroy()
	end)
end


function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "vehicles/tank_readyfire1.wav" )
	if bOn then
		self:PlayAnimation("hatch_open")
	else
		self:PlayAnimation("hatch_close")
	end
end

function ENT:HandleLandingGear()
end

function ENT:ToggleLandingGear()
	self.LandingGearUp = not self.LandingGearUp
	
	self:OnLandingGearToggled( self.LandingGearUp )
end

function ENT:RaiseLandingGear()
	if not self.LandingGearUp then
		self.LandingGearUp = true
		
		self:OnLandingGearToggled( self.LandingGearUp )
	end
end

function ENT:DeployLandingGear()
	if self.LandingGearUp then
		self.LandingGearUp = false
		
		self:OnLandingGearToggled( self.LandingGearUp )
	end
end
