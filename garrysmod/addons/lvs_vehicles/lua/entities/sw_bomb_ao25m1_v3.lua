AddCSLuaFile()
DEFINE_BASECLASS( "sw_base_bomb_v3" )

--Main info
ENT.Type = "anim"
ENT.Spawnable		            	 =	true
ENT.AdminSpawnable		             =	false
ENT.AdminOnly						 =	false
ENT.PrintName		                 =	"АО-25М1"
ENT.Author			                 =	"Shermann Wolf"
ENT.Contact			                 =	"shermannwolf@gmail.com"
ENT.Category                         =	"MP Bombs | RU"
ENT.Editable						 =	true
ENT.SWBombV3						 =	true

--Visual
ENT.Model                            =	"models/sw/rus/bombs/ao25m1.mdl"
ENT.Effect                           =	"ins_m203_explosion"
ENT.EffectAir                        =	"ins_m203_explosion"
ENT.EffectWater                      =	"ins_water_explosion"
ENT.Decal							 =	"scorch_25kg"
ENT.AngEffect						 =	true

--Sounds
ENT.ImpactSound                  	 =	"sw/bomb/impact_1.wav"
ENT.DebrisSound                  	 =	"sw/bomb/debris_1.wav"
ENT.WhistleSound                  	 =	"sw/bomb/whistle.wav"
ENT.ExplosionSound                   =	"sw/explosion/exp_tny_1.wav"
ENT.FarExplosionSound				 =	"sw/explosion/exp_sml_dst_1.wav"
ENT.DistExplosionSound				 =	"sw/explosion/exp_sml_far_1.wav"
ENT.WaterExplosionSound				 =	"sw/explosion/exp_trp_1.wav"
ENT.WaterFarExplosionSound			 =	nil

--Physics
ENT.TraceLength                      =	30
ENT.ImpactSpeed                      =	150
ENT.ImpactDepth						 =	25
ENT.Mass                             =	25
ENT.Durability						 =	100

--Explosion
ENT.ExplosionDamage                  =	10000
ENT.ExplosionRadius                  =	300
ENT.BlastRadius                 	 =	450
ENT.FragDamage						 =	25
ENT.FragRadius						 =	600
ENT.FragCount						 =	100