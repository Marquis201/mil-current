AddCSLuaFile()
ENT.Type = "anim"
ENT.SWBombV3 =	true
ENT.Author			= "Shermann Wolf"
ENT.Contact			= "shermannwolf@gmail.com"
ENT.PrintName		= "Flare"
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable 		= false
ENT.AdminSpawnable  = false
ENT.Model 			= "models/sw/shared/flare.mdl"

function ENT:Initialize()
	self:SetModel( self.Model)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )	
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local pObj = self:GetPhysicsObject()
	pObj:SetMass( 1 ) 
	pObj:EnableGravity( true ) 
	pObj:EnableMotion( true )
	pObj:EnableDrag( true )
	pObj:SetDragCoefficient(0)
	pObj:Wake()
	timer.Simple(3,function()
		if IsValid(self) then
			self:Remove()
		end
	end)
end
function ENT:Think()
	for k,v in pairs( ents.FindInSphere( self:GetPos(), math.random(1500,2000) ) ) do
		if( IsValid( v ) && IsValid( v.Target ) ) && !string.EndsWith(tostring(v.Target), "gtav_cm_flare]") then
			local tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = v:GetPos(),	
			} )		
			if tr.Hit and tr.Entity == v then
				v.Target = self
				if IsFirstTimePredicted() then
					timer.Simple(2,function() 
						if IsValid(v) then
							v:Detonate()
						end
					end)
				end
			end
		end
		if ( IsValid(v) ) and v.IsRocket and (v.JDAM or v.GuidanceActive) then 
			local tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = v:GetPos(),	
			} )		
			if tr.Hit and tr.Entity == v then
				self:SetNWEntity("TarRocket",v)
				v.target = (self)			
				if v.lg == true then
					v.lg = false 
					v.target = (self)		
				end
				if v.LaserGuided == true then
					v.LaserGuided = false 
					v.target = (self)
				end				
			end		
		end
		if ( IsValid(v) ) and v:GetClass() == "lunasflightschool_missile" and IsValid(v:GetLockOn()) then 
			local tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = v:GetPos(),	
			} )		
			if tr.Hit and tr.Entity == v then
				v:SetLockOn( self )
				if IsFirstTimePredicted() then
					timer.Simple(4,function() 
						if IsValid(v) then
							v:Detonate()
						end
					end)
				end
			end
		end
		if ( IsValid(v) ) and v:GetClass() == "lvs_missile" and IsValid(v:GetNWTarget()) then 
			local tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = v:GetPos(),	
			} )		
			if tr.Hit and tr.Entity == v then
				v:SetNWTarget( self )
			end
		end
		if ( IsValid(v) ) and v:GetClass() == "dronesrewrite_rocketbig" then
			local tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = v:GetPos(),	
			} )		
			if tr.Hit and tr.Entity == v then
				v.Enemy = self
				if IsFirstTimePredicted() then
					timer.Simple(1,function() 
						if IsValid(v) then
							v:Boom()
						end
					end)
				end
			end
		end
		if ( IsValid(v) ) and v:GetClass() == "rpg_missile" then 
			local tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = v:GetPos(),	
			} )		
			if tr.Hit and tr.Entity == v then
				local d = DamageInfo()
				d:SetDamage( 100 )
				d:SetAttacker(self)
				d:SetDamageType( DMG_MISSILEDEFENSE )
				v:TakeDamageInfo( d )
			end
		end
	end 
end

if CLIENT then 
	local emitter = ParticleEmitter(Vector(0, 0, 0))
	function ENT:Initialize()
		self.lifetime = RealTime()
		self.cooltime = CurTime()
	end
	function ENT:Draw()
		self:DrawModel()
	end
	function ENT:Think()
		local dist = 0
		if (self.cooltime < CurTime()) then
			local smoke = emitter:Add("effects/smoke_a", self:GetPos() + self:GetForward()*-dist)
			smoke:SetVelocity(self:GetForward()*-10)
			smoke:SetDieTime(math.Rand(1,3.5))
			smoke:SetStartAlpha(150)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(90)
			smoke:SetEndSize(30)
			smoke:SetRoll(math.Rand(180,480))
			smoke:SetRollDelta(math.Rand(-4,2))
			smoke:SetGravity( Vector( 0, math.random(1,90), math.random(151,355) ) )
			smoke:SetColor( 135,135, 135 )
			smoke:SetAirResistance(50)
			local fire = emitter:Add("effects/yellowflare", self:GetPos() + self:GetForward()*-dist)
			fire:SetVelocity(self:GetForward()*-10)
			fire:SetDieTime(math.Rand(.25,.35))
			fire:SetStartAlpha(250)
			fire:SetEndAlpha(250)
			fire:SetStartSize(150)
			fire:SetEndSize(50)
			fire:SetAirResistance(150)
			fire:SetRoll(math.Rand(180,480))
			fire:SetRollDelta(math.Rand(-3,3))
			fire:SetColor(220,150,0)
			self.cooltime = CurTime() + .0001
		end
	end
end
function ENT:OnRemove()
	if IsValid(self:GetNWEntity("TarRocket")) then
		self:GetNWEntity("TarRocket").JDAM = false
		self:GetNWEntity("TarRocket").GuidanceActive = false
	end
end
function ENT:PhysicsUpdate()
end
function ENT:PhysicsCollide()
end