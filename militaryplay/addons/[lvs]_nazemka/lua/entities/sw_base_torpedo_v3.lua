AddCSLuaFile()

local ImpSnds = {}
ImpSnds[1] = "sw/bomb/impact_1.wav"
ImpSnds[2] = "sw/bomb/impact_2.wav"
ImpSnds[3] = "sw/bomb/impact_3.wav"

local WtrImpSnds = {}
WtrImpSnds[1] = "sw/bomb/impact_wtr_1.wav"
WtrImpSnds[2] = "sw/bomb/impact_wtr_2.wav"
WtrImpSnds[3] = "sw/bomb/impact_wtr_3.wav"

local DbrSnds = {}
DbrSnds[1] = "sw/bomb/debris_1.wav"
DbrSnds[2] = "sw/bomb/debris_2.wav"
DbrSnds[3] = "sw/bomb/debris_3.wav"
DbrSnds[4] = "sw/bomb/debris_4.wav"

local ExpSnds = {}
ExpSnds[1] = "sw/explosion/exp_tny_1.wav"
ExpSnds[2] = "sw/explosion/exp_tny_2.wav"
ExpSnds[3] = "sw/explosion/exp_tny_3.wav"

local FarExpSnds = {}
FarExpSnds[1] = "sw/explosion/exp_sml_dst_1.wav"
FarExpSnds[2] = "sw/explosion/exp_sml_dst_2.wav"
FarExpSnds[3] = "sw/explosion/exp_sml_dst_3.wav"
FarExpSnds[4] = "sw/explosion/exp_sml_dst_4.wav"
FarExpSnds[5] = "sw/explosion/exp_sml_dst_5.wav"
FarExpSnds[6] = "sw/explosion/exp_sml_dst_6.wav"
FarExpSnds[7] = "sw/explosion/exp_sml_dst_7.wav"
FarExpSnds[8] = "sw/explosion/exp_sml_dst_8.wav"

local DstExpSnds = {}
DstExpSnds[1] = "sw/explosion/exp_sml_far_1.wav"
DstExpSnds[2] = "sw/explosion/exp_sml_far_2.wav"
DstExpSnds[3] = "sw/explosion/exp_sml_far_3.wav"
DstExpSnds[4] = "sw/explosion/exp_sml_far_4.wav"
DstExpSnds[5] = "sw/explosion/exp_sml_far_5.wav"
DstExpSnds[6] = "sw/explosion/exp_sml_far_6.wav"
DstExpSnds[7] = "sw/explosion/exp_sml_far_7.wav"
DstExpSnds[8] = "sw/explosion/exp_sml_far_8.wav"

local WtrExpSnds = {}
WtrExpSnds[1] = "sw/explosion/exp_trp_1.wav"
WtrExpSnds[2] = "sw/explosion/exp_trp_2.wav"
WtrExpSnds[3] = "sw/explosion/exp_trp_3.wav"

sound.Add( {
	name = "SW_TORP_ENG_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 70,
	sound = "sw/torpedoes/torpedo_run.wav"
} )

--Main info
ENT.Type = "anim"
ENT.Spawnable		            	 =	false
ENT.AdminSpawnable		             =	false
ENT.AdminOnly						 =	false
ENT.PrintName		                 =	"Torpedo basescript V3"
ENT.Author			                 =	"Shermann Wolf"
ENT.Contact			                 =	"shermannwolf@gmail.com"
ENT.Category                         =	"SW Bombs V3"
ENT.SWBombV3						 =	true
ENT.IsRocket						 =	true

--Effects
ENT.Effect                           =	"gw_250lb_explosion"
ENT.EffectAir                        =	"gw_250lb_explosion"
ENT.EffectWater                      =	"ins_water_explosion"

--Sounds
ENT.ArmSound						 =	"sw/bomb/arm.wav"
ENT.StartSound						 =	"sw/torpedoes/torpedo_launch_1.wav"
ENT.EngineSound						 =  "SW_TORP_ENG_LOOP"
ENT.ImpactSound                  	 =	table.Random(ImpSnds)
ENT.WaterImpactSound           		 =	table.Random(WtrImpSnds)
ENT.DebrisSound                  	 =	table.Random(DbrSnds)
ENT.ExplosionSound                   =	table.Random(ExpSnds)
ENT.FarExplosionSound				 =	table.Random(FarExpSnds)
ENT.DistExplosionSound				 =	table.Random(DstExpSnds)
ENT.WaterExplosionSound				 =	table.Random(WtrExpSnds)
ENT.WaterFarExplosionSound			 =	nil

--Visual
ENT.Model                            =	"models/sw/rus/torpedoes/45_36.mdl"

--Physics
ENT.ImpactSpeed                      =	500
ENT.Mass                             =	100
ENT.MaxVelocity        				 =	1000
ENT.WaterThrustForce 				 =  1500
ENT.RotationalForce     			 =	0
ENT.Buoyancy						 =  0.15
ENT.FuelBurnoutTime 				 =	20
ENT.Agility							 =	100


--Explosion
ENT.DamageType						 =	DMG_BURN
ENT.ExplosionDamage                  =	15000
ENT.ExplosionRadius                  =	585.9375
ENT.BlastRadius                 	 =	878.90625

if SERVER then
	local angle_reg = Angle(0,0,0)
	local angle_dif = Angle(-90,0,0)
	local Normal = Vector(1,1,0)
	local Normal2 = Vector(0.1,1,1)
	local trlength = Vector(0,0,9000)
	local angle_zero = Angle()
	local angle_1 = Angle(-90,0,0)

	--Spawn
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end
		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal )
		ent:SetAngles( Angle(0, ply:EyeAngles().y, 0 ) )
		ent:Spawn()
		ent:Activate()
		return ent
	end
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysWake()
		local pObj = self:GetPhysicsObject()
		pObj:SetMass( self.Mass ) 
		pObj:EnableGravity( true ) 
		pObj:EnableMotion( true )
		pObj:EnableDrag( false )
		self.Armed = false
		self.Fired = false
		self.Exploded = false
		self.MaxVelocityUnitsSquared = self.MaxVelocity and self:ConvertMetersToUnits(self.MaxVelocity^2) or nil
		pObj:SetBuoyancyRatio(self.Buoyancy)	
	end

	--Arming
	function ENT:Use( activator, caller )
		if !self.Exploded and !self.Armed then
			self:EmitSound(self.ArmSound)
			self.Armed = true
			self:Launch()
		end
	end
	function ENT:Launch()
		if self.Exploded then return end
		
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		
		local phys = self:GetPhysicsObject()
		
		if !IsValid(phys) then return end
		
		self.ImpactSpeed = 10
		
		self.Fired = true
		self:SetNWBool("Fired",true)
		
		constraint.RemoveAll(self)
		
		phys:Wake()
		phys:EnableMotion(true)
		
		self:InitLaunch(phys)
	end
	function ENT:InitLaunch(phys)
		self:EmitSound(self.StartSound)
		phys:AddAngleVelocity(Vector(self.RotationalForce or 0,0,0))
		if self.TorpedoTrail then
			timer.Simple(0,function()
				if !IsValid(self) then return end
				
				if self.Engine1Att then
					local ID = self:LookupAttachment( self.Engine1Att )
					ParticleEffectAttach(self.TorpedoTrail,PATTACH_POINT_FOLLOW,self,ID)
				end
				if self.Engine2Att then
					local ID = self:LookupAttachment( self.Engine2Att )
					ParticleEffectAttach(self.TorpedoTrail,PATTACH_POINT_FOLLOW,self,ID)
				end
				if not self.Engine1Att and not self.Engine2Att then
					ParticleEffectAttach(self.TorpedoTrail,PATTACH_ABSORIGIN_FOLLOW,self,1)
				end
			end)
		end
		
		if self.FuelBurnoutTime and self.FuelBurnoutTime != 0 then 
			timer.Simple(self.FuelBurnoutTime,function()
				if !IsValid(self) then return end
				self.Exploded = true
				self:Explode(self:GetPos())
			end)
		end
	end

	--Move
	function ENT:ConvertMetersToUnits(Meters)
		return Meters / 0.01905
	end
	function ENT:ConvertUnitsToMeters(Units)
		return Units * 0.01905
	end	
	function ENT:Think()
		if self.Fired then
			if self:WaterLevel() >= 1 then
				local VelForward = self:GetForward()
				local VelForward_Norm = Vector(VelForward:GetNormalized().x,VelForward:GetNormalized().y,0)
				if self.MaxVelocityUnitsSquared and self:GetPhysicsObject():GetVelocity():LengthSqr() < self.MaxVelocityUnitsSquared then			
					self:GetPhysicsObject():AddVelocity(VelForward_Norm*(self.WaterThrustForce))
				end

				if self.GuidanceActive then
					if self.target != NULL then
						local ph = self:GetPhysicsObject()
						if IsValid(self.target) or self.target:GetClass() == "worldspawn" then
							if not self.Armed or self.InEntity then return end
							local pos = self:GetPos()
							local vel = self:WorldToLocal(pos+ph:GetVelocity())*0.4
							vel.x = 0
							local target = self.target:LocalToWorld(self.targetOffset) 
							local v = self:WorldToLocal(target + Vector(0,0,math.Clamp((pos*Normal):Distance(target*Normal)/5 - 0,0,0 or 0))):GetNormal()				
							v.y = math.Clamp(v.y*10,-1,1)*(self.Agility or 10)
							v.z = math.Clamp(v.z*10,-1,1)*(self.Agility or 10)
							ph:AddAngleVelocity(
								ph:GetAngleVelocity()*-0.1
								+ Vector(0,0,0)
								+ Vector(0,-vel.z,vel.y)
								+ Vector(0,-v.z,v.y)
							)
							ph:AddVelocity(VelForward_Norm - self:LocalToWorld(vel*Normal2) + pos)
						end
					end
				end
			end
		else
			if self.Armed then
				if self:WaterLevel() >= 1 then
					self:Launch()
				end
			end
		end
	end

	--Explosion
	function ENT:Explode(pos)
		if !self.Exploded then return end
		if !self.Armed then return end
		pos = self:LocalToWorld(self:OBBCenter())			 
		if(self:WaterLevel() >= 1) then
			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0,0,90000),
				filter  = self,
			}) 			
			local tr2 = util.TraceLine({
				start = tr.HitPos,
				endpos = tr.HitPos - Vector(0,0,90000),
				filter = self,
				mask = MASK_WATER + CONTENTS_TRANSLUCENT,
			})			
			if tr2.Hit then
				ParticleEffect(self.EffectWater, tr2.HitPos,(self.AngEffect and angle_dif or angle_reg), nil)   
			end
		else			   
			local tr = util.TraceLine({
				start = pos,
				endpos = pos - Vector(0, 0, self.TraceLength),
				filter = self,
			})
			if tr.HitWorld then
				ParticleEffect(self.Effect,pos,(self.AngEffect and angle_dif or angle_reg),nil)			
			else 
				ParticleEffect(self.EffectAir,pos,(self.AngEffect and angle_dif or angle_reg),nil) 
			end
		end
		debugoverlay.Sphere(pos,self.ExplosionRadius,5,Color(255,0,0,100),false)
		debugoverlay.Sphere(pos,self.BlastRadius,5,Color(200,150,0,100),false)	

		--Deadly zone
		if self.ExplosionRadius > 0 then
			for k, v in pairs(ents.FindInSphere(pos,self.ExplosionRadius)) do
				if v:IsValid() and not v.SWBombV3 then
					local dmg = DamageInfo()
					dmg:SetInflictor(self)
					dmg:SetDamage(self.ExplosionDamage)
					dmg:SetDamageType(self.DamageType)
					dmg:SetAttacker((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or game.GetWorld())
					v:TakeDamageInfo(dmg)
				end
			end
		end

		--Blast wave
		if self.BlastRadius > 0 then
			util.BlastDamage( self, ((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or game.GetWorld()), pos, self.BlastRadius,self.ExplosionDamage/2 )
		end

		if self:WaterLevel() >= 1 then
			swv3.CreateSound(pos,false,self.WaterExplosionSound,self.WaterFarExplosionSound,self.DistExplosionSound)
		else
			swv3.CreateSound(pos,false,self.ExplosionSound,self.FarExplosionSound,self.DistExplosionSound)
		end
		timer.Simple(0,function()
			if !IsValid(self) then return end
			self:Remove()
		end)
	end

	--Impact
	function ENT:PhysicsCollide( data, physobj )
		if self:GetVelocity():Length() >= self.ImpactSpeed then
			if self:GetNWBool("Fired") == true then
				self.Exploded = true
				self:Explode(self:GetPos())
			else
				if !self.Armed and !self.Fired then
					self:EmitSound(self.ArmSound)
					self.Armed = true
					self:Launch()
				end
			end
		end
	end
end

if CLIENT then
	function ENT:Initialize()
		self.EngSND = CreateSound( self, self.EngineSound )
	end
	function ENT:Think()
		if self:GetNWBool("Fired",false) then
			if self:WaterLevel() >= 1 then
				local traceWater = util.TraceLine( {
					start = self:LocalToWorld(Vector(-25,0,20)),
					endpos = self:LocalToWorld(Vector(-25,0,20)) - Vector(0,0,40),
					filter = self,
					mask = MASK_WATER,
				} )

				if traceWater.Hit then
					local effectdata = EffectData()
					effectdata:SetOrigin( traceWater.HitPos )
					effectdata:SetEntity( self )
					util.Effect( "sw_torpedo_v3", effectdata )
				end

				self.EngSND:Play()
			else
				if self.EngSND then
					self.EngSND:Stop()
				end
			end
		else
			if self.EngSND then
				self.EngSND:Stop()
			end
		end
	end
	function ENT:GetParticleEmitter( Pos )
		local EntTable = self:GetTable()

		local T = CurTime()

		if IsValid( EntTable.Emitter ) and (EntTable.EmitterTime or 0) > T then
			return EntTable.Emitter
		end

		self:StopEmitter()

		EntTable.Emitter = ParticleEmitter( Pos, false )
		EntTable.EmitterTime = T + 2

		return EntTable.Emitter
	end
	function ENT:StopEmitter()
		if IsValid( self.Emitter ) then
			self.Emitter:Finish()
		end
	end
	function ENT:Draw()
		self:DrawModel()
	end
	function ENT:SoundStop()
		if self.EngSND then
			self.EngSND:Stop()
		end
	end
	function ENT:OnRemove()
		self:SoundStop()
	end
end