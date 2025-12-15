--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "✠ EC-665 UHT Tiger"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Воздух"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/gordon/germany/helicopters/ec665_uht.mdl"

ENT.AITEAM = 1

ENT.Mass = 3000
ENT.Inertia = Vector(5000,5000,5000)
ENT.Drag = 0

ENT.SeatPos = Vector(2.6,0,-0.1946)*40
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxThrustHeli = 8
ENT.MaxTurnPitchHeli = 30
ENT.MaxTurnYawHeli = 40
ENT.MaxTurnRollHeli = 80

ENT.ThrustEfficiencyHeli = .9

ENT.RotorPos = Vector(0,0,1.86169)*40
ENT.RotorAngle = Angle(2,0,0)
ENT.RotorRadius = 250

ENT.WheelMass = 150
ENT.WheelRadius = 13
ENT.WheelPos_C = Vector(-5.97524,-0.001732,-2.16)*40
ENT.WheelPos_L = Vector(1.73929,1.14179,-1.60448)*40
ENT.WheelPos_R = Vector(1.73929,-1.14179,-1.60448)*40

ENT.MaxHealth = 8000

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 38

ENT.Loadouts = 5
ENT.MISSILES = {
	[1] = {
		bodygroups = {{1, 3}}, caps_bodygroup = nil,
		ammo = 0,
		model = "models/gordon/usa/rockets/ffar.mdl", entity = "gb_rocket_ffar",
		posang = {}
	},
	[2] = {
		bodygroups = {{1, 2}}, caps_bodygroup = nil,
		ammo = 38,
		model = "models/gordon/usa/rockets/ffar.mdl", entity = "gb_rocket_ffar",
		posang = {
			{Vector(-0.25, 	1.33942, 	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.4144, 	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.48942, 	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.30188, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.3769, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.45188, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.52693, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.26441, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.33942, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.4144, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.48938, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.5644, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.30192, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.3769, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.45191, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.52693, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.33942, 	-0.684), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.4144,  	-0.684), Angle(0, 0, 0)},
			{Vector(-0.25, 	1.48942, 	-0.684), Angle(0, 0, 0)},

			{Vector(-0.25, 	-1.33942, 	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.4144,  	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.48942, 	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.30188, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.3769,  	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.45188, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.52693, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.26441, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.33942, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.4144,  	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.48938, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.5644,  	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.30192, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.3769,  	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.45191, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.52693, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.33942, 	-0.684), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.4144,  	-0.684), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.48942, 	-0.684), Angle(0, 0, 0)},
		}
	},
	[3] = {
		bodygroups = {{1, 1}}, caps_bodygroup = nil,
		ammo = 8,
		model = "models/gordon/france/rockets/hot2.mdl", entity = "gb_rocket_bgm71",
		posang = {
			{Vector(0.047184,		1.2457,		-0.531483+0.02), Angle(-8,0,0)},
			{Vector(0.047184,		-1.2457,		-0.531483+0.02), Angle(-8,0,0)},
			{Vector(0.047184,		1.58026,	-0.531483+0.02), Angle(-8,0,0)},
			{Vector(0.047184,		-1.58026,	-0.531483+0.02), Angle(-8,0,0)},
			{Vector(0.087184,		1.2457,		-0.808847+0.02), Angle(-8,0,0)},
			{Vector(0.087184,		-1.2457,		-0.808847+0.02), Angle(-8,0,0)},
			{Vector(0.087184,		1.58026,	-0.808847+0.02), Angle(-8,0,0)},
			{Vector(0.087184,		-1.58026,	-0.808847+0.02), Angle(-8,0,0)},
		}
	},
	[4] = {
		bodygroups = {{1, 4}}, caps_bodygroup = nil,
		ammo = 6,
		model = "models/gordon/usa/rockets/ffar.mdl", entity = "gb_rocket_ffar",
		posang = {
			{Vector(-0.482356, 	1.28628, 	-0.731059), Angle(0, 0, 0)},
			{Vector(-0.482356, 	1.41823, 	-0.731059), Angle(0, 0, 0)},
			{Vector(-0.482356, 	1.55016, 	-0.731059), Angle(0, 0, 0)},

			{Vector(-0.482356, 	-1.28628, 	-0.731059), Angle(0, 0, 0)},
			{Vector(-0.482356, 	-1.41823, 	-0.731059), Angle(0, 0, 0)},
			{Vector(-0.482356, 	-1.55016, 	-0.731059), Angle(0, 0, 0)},
		}
	},
	[5] = {
		bodygroups = {{1, 5}}, caps_bodygroup = nil,
		ammo = 22,
		model = "models/gordon/usa/rockets/ffar.mdl", entity = "gb_rocket_ffar",
		posang = {
			{Vector(-0.482356, 	1.28628, 	-0.731059), Angle(0, 0, 0)},
			{Vector(-0.482356, 	1.41823, 	-0.731059), Angle(0, 0, 0)},
			{Vector(-0.482356, 	1.55016, 	-0.731059), Angle(0, 0, 0)},

			{Vector(-0.25, 	-1.33942, 	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.4144,  	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.48942, 	-0.428335), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.30188, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.3769,  	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.45188, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.52693, 	-0.4924), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.26441, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.33942, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.4144,  	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.48938, 	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.5644,  	-0.55617), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.30192, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.3769,  	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.45191, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.52693, 	-0.620135), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.33942, 	-0.684), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.4144,  	-0.684), Angle(0, 0, 0)},
			{Vector(-0.25, 	-1.48942, 	-0.684), Angle(0, 0, 0)},
		}
	},
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 4,min = 0, max = self.Loadouts, category = "Weapons"} } )
	self:NetworkVar( "Float",10, "AimV" )
	self:NetworkVar( "Float",11, "AimH" )
	self:NetworkVar( "Float",12, "AimZoom" )
	self:NetworkVar( "Bool", 10, "GunnerFocus" )
	self:NetworkVar( "Vector", 5, "Marker")
	
	if SERVER then
		self:SetLoadout(0)
		self:SetAimZoom(70)
	end
end