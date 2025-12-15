
ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "UH60"
ENT.Author = "DarkLord20172002"
ENT.Information = ""
ENT.Category = "[MP/LVS] - Воздух"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/UH-60.mdl"

ENT.AITEAM = 1


ENT.Mass = 6500
ENT.Inertia = Vector(7000,7000,7000)
ENT.Drag = 0

ENT.SeatPos = Vector(110,-32,10)
ENT.SeatAng = Angle(0,-90,1)

ENT.MaxThrustHeli = 7
ENT.MaxTurnPitchHeli = 18
ENT.MaxTurnYawHeli = 20
ENT.MaxTurnRollHeli = 50

ENT.ThrustEfficiencyHeli = 0.6

ENT.RotorPos = Vector(80,0,188)
ENT.RotorAngle = Angle(0,0,0)
ENT.RotorRadius = 310

ENT.MaxHealth = 3100