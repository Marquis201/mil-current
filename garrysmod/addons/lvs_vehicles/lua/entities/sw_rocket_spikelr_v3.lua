AddCSLuaFile()
DEFINE_BASECLASS( "sw_base_rocket_v3" )

local StartSnds = {}
StartSnds[1] = "sw/rocket/missilelaunch1.wav"
StartSnds[2] = "sw/rocket/missilelaunch1.wav"
StartSnds[3] = "sw/rocket/missilelaunch1.wav"

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

--Main info
ENT.Type = "anim"
ENT.Spawnable		            	 =	true
ENT.AdminSpawnable		             =	false
ENT.AdminOnly						 =	false
ENT.PrintName		                 =	"Spkie LR II"
ENT.Author			                 =	"Shermann Wolf"
ENT.Contact			                 =	"shermannwolf@gmail.com"
ENT.Category                         =	"SW Bombs V3 | IL"
ENT.Editable						 =	true
ENT.SWBombV3						 =	true

--Visual
ENT.Model                            =	"models/sw/il/missiles/atgm/spike_lr.mdl"
ENT.Effect                           =	"ins_m203_explosion"
ENT.EffectAir                        =	"ins_m203_explosion"
ENT.EffectWater        				 =  "ins_water_explosion"
ENT.Engine1Att						 =	"engine_1"
ENT.Engine2Att						 =	"engine_2"
ENT.AngEffect						 =	true

--Sounds
ENT.ImpactSound                  	 =	table.Random(ImpSnds)
ENT.WaterImpactSoundSound            =	table.Random(WtrImpSnds)
ENT.DebrisSound                  	 =	table.Random(DbrSnds)
ENT.WhistleSound                  	 =	"sw/bomb/whistle.wav"
ENT.ExplosionSound                   =	table.Random(ExpSnds)
ENT.FarExplosionSound				 =	table.Random(FarExpSnds)
ENT.DistExplosionSound				 =	table.Random(DstExpSnds)
ENT.WaterExplosionSound				 =	table.Random(WtrExpSnds)
ENT.WaterFarExplosionSound			 =	nil
ENT.StartSound          			 =	table.Random(StartSnds)

--Physics
ENT.TraceLength                      =	150
ENT.ImpactSpeed                      =	500
ENT.ImpactDepth						 =	0
ENT.Mass                             =	100
ENT.Durability						 =	100
ENT.MaxVelocity						 =	180
ENT.FuelBurnoutTime					 =	1
ENT.RotationalForce					 =	0

--Explosion
ENT.ExplosionDamage                  =	300
ENT.ExplosionRadius                  =	70
ENT.BlastRadius                 	 =	0
ENT.FragDamage						 =	25
ENT.FragRadius						 =	140
ENT.FragCount						 =	100

ENT.HEAT							 =	true
ENT.HEATRadius						 =	3
ENT.ArmorPenetration				 = 	90000
ENT.PenetrationDamage				 =	2000

--Guidance
ENT.HaveGuidance = true
ENT.Agility = 100

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal )
	ent:SetAngles( Angle(0, ply:EyeAngles().y, 0 ) )
	ent:Spawn()
	ent:Activate()
	
	ent.StartSound          			 =	table.Random(StartSnds)
	ent.ImpactSound                  	 =	table.Random(ImpSnds)
	ent.WaterImpactSoundSound            =	table.Random(WtrImpSnds)
	ent.DebrisSound                  	 =	table.Random(DbrSnds)
	ent.ExplosionSound                   =	table.Random(ExpSnds)
	ent.FarExplosionSound				 =	table.Random(FarExpSnds)
	ent.DistExplosionSound				 =	table.Random(DstExpSnds)
	ent.WaterExplosionSound				 =	table.Random(WtrExpSnds)
	return ent
end

function ENT:InitLaunch(phys)

	self:EmitSound(self.StartSound)
	util.ScreenShake( self:GetPos(), 1, 10, 1, 150+self.ExplosionRadius, true, nil )
	self:SetBodygroup(1,1)

	phys:AddAngleVelocity(Vector(self.RotationalForce or 0,0,0))

	if self.RocketTrail then
		timer.Simple(0,function()
			if !IsValid(self) then return end
			
			if self.Engine1Att then
				local ID = self:LookupAttachment( self.Engine1Att )
				ParticleEffectAttach(self.RocketTrail,PATTACH_POINT_FOLLOW,self,ID)
			end
			if self.Engine2Att then
				local ID = self:LookupAttachment( self.Engine2Att )
				ParticleEffectAttach(self.RocketTrail,PATTACH_POINT_FOLLOW,self,ID)
			end
			if not self.Engine1Att and not self.Engine2Att then
				ParticleEffectAttach(self.RocketTrail,PATTACH_ABSORIGIN_FOLLOW,self,1)
			end

			if self.Tracer1Att then
				if self.TracerEffect then
					local ID = self:LookupAttachment( self.Tracer1Att )
					ParticleEffectAttach(self.TracerEffect,PATTACH_POINT_FOLLOW,self,ID)
				end
			end
			if self.Tracer2Att then
				if self.TracerEffect then
					local ID = self:LookupAttachment( self.Tracer2Att )
					ParticleEffectAttach(self.TracerEffect,PATTACH_POINT_FOLLOW,self,ID)
				end
			end
		end)
	end
	
	if self.FuelBurnoutTime and self.FuelBurnoutTime != 0 then 
		timer.Simple(self.FuelBurnoutTime,function()
			if !IsValid(self) then return end
			
			self.Burnt = true
			if self.SkyfallMode then
				self.Agility = 150
				self.MaxVelocity = 100
				if IsValid(self.target) then
					self.targetOffset = self.target:WorldToLocal(self.target:GetPos()+self.target:GetForward()*(self.target:GetVelocity():Length()/7))
				end
			end
			self:SetNWBool("Burnt",true)
			self:StopParticles()
			self:StopSound(self.EngineSound)
			self:StopSound(self.StartSound)
			
			if self.Engine1Att then
				local ID = self:LookupAttachment( self.Engine1Att )
				ParticleEffectAttach(self.RocketBurnoutTrail,PATTACH_POINT_FOLLOW,self,ID)
			end
			if self.Engine2Att then
				local ID = self:LookupAttachment( self.Engine2Att )
				ParticleEffectAttach(self.RocketBurnoutTrail,PATTACH_POINT_FOLLOW,self,ID)
			end
			if not self.Engine1Att and not self.Engine2Att then
				ParticleEffectAttach(self.RocketBurnoutTrail,PATTACH_ABSORIGIN_FOLLOW,self,1)
			end
			if self.Tracer1Att then
				if self.TracerEffect then
					local ID = self:LookupAttachment( self.Tracer1Att )
					ParticleEffectAttach(self.TracerEffect,PATTACH_POINT_FOLLOW,self,ID)
				end
			end
			if self.Tracer2Att then
				if self.TracerEffect then
					local ID = self:LookupAttachment( self.Tracer2Att )
					ParticleEffectAttach(self.TracerEffect,PATTACH_POINT_FOLLOW,self,ID)
				end
			end
		end)
	end
end