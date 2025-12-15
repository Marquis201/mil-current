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
ExpSnds[1] = "sw/explosion/exp_sml_cls_1.wav"
ExpSnds[2] = "sw/explosion/exp_sml_cls_2.wav"
ExpSnds[3] = "sw/explosion/exp_sml_cls_3.wav"
ExpSnds[4] = "sw/explosion/exp_sml_cls_4.wav"
ExpSnds[5] = "sw/explosion/exp_sml_cls_5.wav"
ExpSnds[6] = "sw/explosion/exp_sml_cls_6.wav"
ExpSnds[7] = "sw/explosion/exp_sml_cls_7.wav"
ExpSnds[8] = "sw/explosion/exp_sml_cls_8.wav"

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
ENT.PrintName		                 =	"С-1ОФ"
ENT.Author			                 =	"Shermann Wolf"
ENT.Contact			                 =	"shermannwolf@gmail.com"
ENT.Category                         =	"MP Bombs | RU"
ENT.Editable						 =	true
ENT.SWBombV3						 =	true

--Visual
ENT.Model                            =	"models/sw/rus/rockets/s1of.mdl"
ENT.Effect             				 =  "ins_c4_explosion"
ENT.EffectAir          				 =  "ins_c4_explosion"
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
ENT.ImpactDepth						 =  0
ENT.Mass                             =	100
ENT.Durability						 =	100
ENT.MaxVelocity						 =	440
ENT.FuelBurnoutTime					 =	1.5

--Explosion
ENT.ExplosionDamage                  =	5000
ENT.ExplosionRadius                  =	200
ENT.BlastRadius                 	 =	400
ENT.FragDamage						 =	25
ENT.FragRadius						 =	600
ENT.FragCount						 =	100

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