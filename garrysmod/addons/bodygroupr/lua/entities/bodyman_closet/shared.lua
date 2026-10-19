ENT.Type = "anim"

ENT.PrintName = "Шкаф"
ENT.Purpose = "Opens the bodyGroupr menu"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Category = "Fusion | Entities"

ENT.WorldModel = "models/reizer_props/srsp/sci_fi/armory_02_2/armory_02_2.mdl"

function ENT:Initialize()

	self:SetModel( self.WorldModel )
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
 	
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass( 50 )
	end

	if SERVER then
		self:SetUseType( SIMPLE_USE )
		self.health = BODYMAN.ClosetHealth or 100
	end

end