AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false
ENT.ExplosionSound                   =   "weapons/grenade.mp3"
ENT.Shocktime                        =  0
ENT.HBOWNER                          =  nil    

game.AddParticles( "particles/grenade_particle.pcf")
DEFINE_BASECLASS( "hb_base_advanced" )
function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.KaboomTime = self.KaboomTime or CurTime() + 4
	if SERVER then
		self:SetModel( "models/weapons/w_nam_rgd5.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:DrawShadow( true )
		self:SetAngles( self:GetOwner():GetAngles() )
	end
end

function ENT:Think()
	if SERVER and self.KaboomTime <= CurTime() then
		self:Explode()
		self:Remove()
	end
end

function ENT:Explode()


local pos = self:LocalToWorld(self:OBBCenter())

local ent = ents.Create("hb_shockwave_sound_lowsh")
	ent:SetPos( pos ) 
	ent:Spawn()
	ent:Activate()
	ent:SetVar("HBOWNER", self.HBOWNER)
	ent:SetVar("MAX_RANGE",30000)
	ent:SetVar("SHOCKWAVE_INCREMENT",1000)
	ent:SetVar("DELAY",0.01)
	ent:SetVar("SOUND", self.ExplosionSound)
	ent:SetVar("Shocktime", self.Shocktime)




	ParticleExplode = ents.Create("info_particle_system")
	ParticleExplode:SetPos(self:GetPos())
	ParticleExplode:SetKeyValue("effect_name", "rgd_explo") -- The names are cluster_explode, 40mm_explode, and agm_explode.
	ParticleExplode:SetKeyValue("start_active", "1")
	ParticleExplode:Spawn()
	ParticleExplode:Activate()
	ParticleExplode:Fire("kill", "", 20) -- Be sure to leave this at 20, or else the explosion may not be fully rendered because 2/3 of the effects have smoke that stays for a while.
	util.ScreenShake( self.Entity:GetPos(), 15, 15, 0.5, 2000 )



	rgdsrpnl = ents.Create("rgd5_srpnl")
	rgdsrpnl:SetPos(self:GetPos())
-- The names are cluster_explode, 40mm_explode, and agm_explode.
	rgdsrpnl:SetKeyValue("start_active", "1")
	rgdsrpnl:Spawn()
	rgdsrpnl:Activate()
	rgdsrpnl:Fire("kill", "", 20) -- Be sure to leave this at 20, or else the explosion may not be fully rendered because 2/3 of the effects have smoke that stays for a while.
	util.ScreenShake( self.Entity:GetPos(), 15, 15, 0.5, 2000 )








	self:Remove()
end

function ENT:PhysicsCollide( data )
	if SERVER and data.Speed > 150 then
	self:EmitSound( "Weapon_mk2.Bounce" )
	end
end

