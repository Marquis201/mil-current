AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/weapons/w_crowbar.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:EmitSound("npc/zombie/claw_miss1.wav",75,60)
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then phys:Wake() phys:EnableGravity(false) end
	
	util.SpriteTrail(self, 0, Color(255,255,255), false, 10, 1, 0.5, 8, "trails/smoke.vmt")
end

function ENT:Think()
	if self:GetVelocity():Length() <= 400 then
		self:PhysicsCollide()
		return
	end

	self:EmitSound("weapons/slam/throw.wav")
end

function ENT:Use(activator,caller)
end

hook.Add("EntityTakeDamage","Sledgehammer_Kill",function(ply,dmginfo)
	if IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():GetClass() and dmginfo:GetAttacker():GetClass() == "ent_lordi_sledgehammer" then
		if IsValid(dmginfo:GetAttacker():GetOwner()) and dmginfo:GetAttacker():GetOwner():IsPlayer() then
			dmginfo:SetAttacker(dmginfo:GetAttacker():GetOwner())
		end
	end
end)

function ENT:Touch( ent )
	if ent:IsValid() then
		if ent:IsPlayer() or ent:IsNPC() then
			for i=1,3 do
				ent:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav",75,math.random(70,90))
				local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetPos() + Vector(0,0,math.random(5,20)))
				effectdata:SetEntity(ent)
				util.Effect( "BloodImpact", effectdata )
			end
			ent:TakeDamage(math.random(70,120),self)
		end
	end
end

function ENT:PhysicsCollide(data,obj)
	timer.Create("sledge_hammer_next_frame"..self:EntIndex(),0,1,function()
	self:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")
	local sledge = ents.Create("weapon_lordi_sledgehammer")
	sledge:SetPos(self:GetPos())
	sledge:SetAngles(self:GetAngles())
	sledge:Spawn()
	
	sledge:GetPhysicsObject():ApplyForceCenter( self:GetVelocity() * 15 )
	
	self:Remove()
	/*
	local explode = ents.Create("env_explosion")
	explode:SetPos( self:GetPos() )
	explode:SetOwner( self:GetOwner() )
	explode:Spawn()
	explode:SetKeyValue("iMagnitude","125")
	explode:Fire("Explode", 0, 0 )
	self:EmitSound("ambient/explosions/explode_"..math.random(1,5)..".wav")
	self:Remove()
	*/
	end)
end