AddCSLuaFile()
DEFINE_BASECLASS( "sw_base_rocket_v3" )

local StartSnds = {}
StartSnds[1] = "sw/rocket/rocket_start_01.wav"
StartSnds[2] = "sw/rocket/rocket_start_02.wav"
StartSnds[3] = "sw/rocket/rocket_start_03.wav"
StartSnds[4] = "sw/rocket/rocket_start_04.wav"

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
ENT.PrintName		                 =	"ZT6"
ENT.Author			                 =	"Shermann Wolf"
ENT.Contact			                 =	"shermannwolf@gmail.com"
ENT.Category                         =	"SW Bombs V3 | SA"
ENT.Editable						 =	true
ENT.SWBombV3						 =	true

--Visual
ENT.Model                            =	"models/sw/sa/missiles/agm/zt6.mdl"
ENT.Effect                           =	"ins_c4_explosion"
ENT.EffectAir                        =	"ins_c4_explosion"
ENT.EffectWater        				 =  "ins_water_explosion"  

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
ENT.MaxVelocity						 =	530
ENT.FuelBurnoutTime					 =	1.25

--Explosion
ENT.ExplosionDamage                  =	300
ENT.ExplosionRadius                  =	70
ENT.BlastRadius                 	 =	140
ENT.FragDamage						 =	25
ENT.FragRadius						 =	280
ENT.FragCount						 =	100


ENT.HEAT							 =	true
ENT.HEATRadius						 =	3
ENT.ArmorPenetration				 = 	100000
ENT.PenetrationDamage				 =	3500

--Guidance
ENT.HaveGuidance = true
ENT.Agility = 75

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

function ENT:Explode(pos)
	local angle_reg = Angle(0,0,0)
	local angle_dif = Angle(-90,0,0)
	local Normal = Vector(1,1,0)
	local Normal2 = Vector(0.1,1,1)
	local trlength = Vector(0,0,9000)
	local angle_zero = Angle()
	local angle_1 = Angle(-90,0,0)
	if !self.Exploded then return end
	if !self.Armed then return end
	pos = self:LocalToWorld(self:OBBCenter())			 
	if(self:WaterLevel() >= 1) then
		local tr = util.TraceLine({
			start = pos,
			endpos = pos + Vector(0,0,9000),
			filter  = self,
		}) 			
		local tr2 = util.TraceLine({
			start = tr.HitPos,
			endpos = tr.HitPos - Vector(0,0,9000),
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

	local heat = {}
	heat.Src 	= self:GetPos()
	heat.Dir 	= self:GetAngles():Forward()
	heat.Spread = Vector(0,0,0)
	heat.Force	= self.ArmorPenetration+math.Rand(-self.ArmorPenetration/10,self.ArmorPenetration/10)
	heat.HullSize = self.HEATRadius or 0
	heat.Damage	= self.PenetrationDamage+math.Rand(-self.PenetrationDamage/5,self.PenetrationDamage/5)
	heat.Velocity = 16000
	heat.Attacker 	= self.Owner
	LVS:FireBullet( heat )
	debugoverlay.Text(pos+Vector(0,0,10),"Penetration: "..heat.Force,5)
	debugoverlay.Text(pos-Vector(0,0,10),"Damage: "..heat.Damage,5)
	debugoverlay.Sphere(pos,self.ExplosionRadius,5,Color(255,0,0,100),false)
	debugoverlay.Sphere(pos,self.BlastRadius,5,Color(200,150,0,100),false)	
	debugoverlay.Sphere(pos,self.FragRadius,5,Color(200,200,0,100),false)

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
		self:BlastDoors(self, pos, 10)
	end

	--Frags
	if self.FragCount > 0 then
		self:Fragmentation(self,pos,10000,self.FragDamage,self.FragRadius,((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or game.GetWorld()))
	end

	swv3.CreateSound(pos,false,self.ExplosionSound,self.FarExplosionSound,self.DistExplosionSound)
	timer.Simple(0,function()
		if !IsValid(self) then return end
		self:Remove()
	end)
end