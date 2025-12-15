AddCSLuaFile()
DEFINE_BASECLASS( "sw_base_bomb_v3" )

--Main info
ENT.Type = "anim"
ENT.Spawnable		            	 =	true
ENT.AdminSpawnable		             =	false
ENT.AdminOnly						 =	false
ENT.PrintName		                 =	"ФАБ-9000М54"
ENT.Author			                 =	"Shermann Wolf"
ENT.Contact			                 =	"shermannwolf@gmail.com"
ENT.Category                         =	"MP Bombs | RU"
ENT.Editable						 =	true
ENT.SWBombV3						 =	true

--Visual
ENT.Model                            =	"models/sw/rus/bombs/fab9000m54.mdl"
ENT.Effect                           =  "tb_explosion"
ENT.EffectAir                        =  "tb_air"
ENT.EffectWater                      =	"ins_water_explosion"
ENT.Decal							 =	"scorch_x10"
ENT.AngEffect						 =	false

--Sounds
ENT.ImpactSound                  	 =	"sw/bomb/impact_1.wav"
ENT.DebrisSound                  	 =	"sw/bomb/debris_1.wav"
ENT.WhistleSound                  	 =	"sw/bomb/whistle.wav"
ENT.ExplosionSound                   =	"sw/explosion/exp_hvy_cls_1.wav"
ENT.FarExplosionSound				 =	"sw/explosion/exp_hvy_dst_1.wav"
ENT.DistExplosionSound				 =	"sw/explosion/exp_hvy_far_1.wav"
ENT.WaterExplosionSound				 =	"sw/explosion/exp_trp_1.wav"
ENT.WaterFarExplosionSound			 =	nil

--Physics
ENT.TraceLength                      =	115
ENT.ImpactSpeed                      =	150
ENT.ImpactDepth						 =	100
ENT.Mass                             =	9000
ENT.Durability						 =	100

--Explosion
ENT.ExplosionDamage                  =	15000
ENT.ExplosionRadius                  =	2235.174179077149
ENT.BlastRadius                 	 =	3352.761268615724
ENT.FragDamage						 =	25
ENT.FragRadius						 =	4470.348358154298
ENT.FragCount						 =	100