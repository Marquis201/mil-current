AddCSLuaFile()
DEFINE_BASECLASS( "sw_base_rocket_v3" )

local StartSnds = {}
StartSnds[1] = "sw/rocket/rocket_start_01.wav"
StartSnds[2] = "sw/rocket/rocket_start_02.wav"
StartSnds[3] = "sw/rocket/rocket_start_03.wav"
StartSnds[4] = "sw/rocket/rocket_start_04.wav"

local WtrImpSnds = {}
WtrImpSnds[1] = "sw/bomb/impact_wtr_1.wav"
WtrImpSnds[2] = "sw/bomb/impact_wtr_2.wav"
WtrImpSnds[3] = "sw/bomb/impact_wtr_3.wav"

--Main info
ENT.Type = "anim"
ENT.Spawnable		            	 =	true
ENT.AdminSpawnable		             =	false
ENT.AdminOnly						 =	false
ENT.PrintName		                 =	"РС-82"
ENT.Author			                 =	"Shermann Wolf"
ENT.Contact			                 =	"shermannwolf@gmail.com"
ENT.Category                         =	"MP Bombs | RU"
ENT.Editable						 =	true
ENT.SWBombV3						 =	true

--Visual
ENT.Model                            =	"models/sw/rus/rockets/rs82.mdl"
ENT.Effect                           =	"ins_m203_explosion"
ENT.EffectAir                        =	"ins_m203_explosion"
ENT.EffectWater                      =	"ins_water_explosion"

ENT.AngEffect						 =	true

--Sounds
ENT.WaterImpactSoundSound            =	table.Random(WtrImpSnds)
ENT.ImpactSound                  	 =	"sw/bomb/impact_1.wav"
ENT.DebrisSound                  	 =	"sw/bomb/debris_1.wav"
ENT.WhistleSound                  	 =	"sw/bomb/whistle.wav"
ENT.ExplosionSound                   =	"sw/explosion/exp_tny_1.wav"
ENT.FarExplosionSound				 =	"sw/explosion/exp_sml_dst_1.wav"
ENT.DistExplosionSound				 =	"sw/explosion/exp_sml_far_1.wav"
ENT.WaterExplosionSound				 =	"sw/explosion/exp_trp_1.wav"
ENT.WaterFarExplosionSound			 =	nil
ENT.StartSound          			 =	table.Random(StartSnds)

--Physics
ENT.TraceLength                      =	150
ENT.ImpactSpeed                      =	500
ENT.ImpactDepth						 =	0
ENT.Mass                             =	100
ENT.Durability						 =	100
ENT.MaxVelocity						 =	350
ENT.FuelBurnoutTime					 =	1.5

--Explosion
ENT.ExplosionDamage                  =	1000
ENT.ExplosionRadius                  =	70
ENT.BlastRadius                 	 =  140
ENT.FragDamage						 =	25
ENT.FragRadius						 =	210
ENT.FragCount						 =	100