ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "AH-64D"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Воздух"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/gordon/usa/helicopters/ah64d.mdl"

ENT.AITEAM = 1

ENT.Mass = 10000
ENT.Inertia = Vector(5000,5000,5000)
ENT.Drag = 0

ENT.SeatPos = Vector(48,0,0)
ENT.SeatAng = Angle(0,-90,0)
--ENT.CustomViewPoint = Vector(52, 0, 8)

ENT.WheelMass = 700
ENT.WheelRadius = 15
ENT.WheelPos_L = Vector(1.05565,1.14225,-1.76468)*40
ENT.WheelPos_R = Vector(1.05565,-1.14225,-1.76468)*40
ENT.WheelPos_C = Vector(-9.53841,0,-1.575)*40

ENT.MaxThrustHeli = 7
ENT.MaxTurnPitchHeli = 60
ENT.MaxTurnYawHeli = 60
ENT.MaxTurnRollHeli = 50

ENT.ThrustEfficiencyHeli = 0.8

ENT.RotorPos = Vector(0,0,1.35365)*40
ENT.RotorAngle = Angle(2,0,0)
ENT.RotorRadius = 200

ENT.MaxHealth = 8000

ENT.MaxPrimaryAmmo = -1
ENT.MaxTurretAmmo = 750
ENT.MaxSecondaryAmmo = 76

ENT.Loadouts = 3
ENT.MISSILES = {
	[1] = {
		bodygroups = {{1, 2}}, caps_bodygroup = nil,
		ammo = 38*2,
		model = "models/gordon/usa/rockets/ffar.mdl", entity = "gb_rocket_ffar",
		posang = {
			{Vector(-0.5,		1.49551,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.49551,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.57211,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.57211,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.64871,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.64871,	-0.700064)*40,Angle(0, 0, 0)},

			{Vector(-0.5,		1.45680,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.45680,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.53344,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.53344,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.61078,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.61078,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.68742,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.68742,	-0.767824)*40,Angle(0, 0, 0)},
			
			{Vector(-0.5,		1.41739,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.41739,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.49551,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.49551,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.57211,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.57211,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.64871,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.64871,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.72683,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.72683,	-0.834478)*40,Angle(0, 0, 0)},

			{Vector(-0.5,		1.45680,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.45680,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.53344,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.53344,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.61078,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.61078,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.68742,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.68742,	-0.901361)*40,Angle(0, 0, 0)},

			{Vector(-0.5,		1.49551,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.49551,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.57211,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.57211,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		1.64871,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-1.64871,	-0.968901)*40,Angle(0, 0, 0)},

			{Vector(-0.5,		2.29214,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.29214,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.36874,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.36874,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.44533,	-0.700064)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.44533,	-0.700064)*40,Angle(0, 0, 0)},

			{Vector(-0.5,		2.25343,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.25343,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.33007,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.33007,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.40741,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.40741,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.48404,	-0.767824)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.48404,	-0.767824)*40,Angle(0, 0, 0)},
			
			{Vector(-0.5,		2.21402,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.21402,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.29214,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.29214,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.36874,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.36874,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.44533,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.44533,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.52346,	-0.834478)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.52346,	-0.834478)*40,Angle(0, 0, 0)},

			{Vector(-0.5,		2.25343,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.25343,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.33007,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.33007,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.40741,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.40741,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.48404,	-0.901361)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.48404,	-0.901361)*40,Angle(0, 0, 0)},

			{Vector(-0.5,		2.29214,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.29214,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.36874,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.36874,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		2.44533,	-0.968901)*40,Angle(0, 0, 0)},
			{Vector(-0.5,		-2.44533,	-0.968901)*40,Angle(0, 0, 0)},
		}
	},
	[2] = {
		bodygroups = {{1, 1}}, caps_bodygroup = nil,
		ammo = 8,
		model = "models/gordon/usa/rockets/hellfire.mdl", entity = "gb_rocket_m13",
		posang = {
			{Vector(0.515912,		1.28682+0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.28682-0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		1.62699+0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.62699-0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		1.89303+0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.89303-0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		2.23457+0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-2.23457-0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},
		}
	},
	[3] = {
		bodygroups = {{1, 3}}, caps_bodygroup = nil,
		ammo = 16,
		model = "models/gordon/usa/rockets/hellfire.mdl", entity = "gb_rocket_m13",
		posang = {
			{Vector(0.515912,		1.28682+0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.28682-0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		1.62699+0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.62699-0.115,	-1.18333+0.27)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		1.89303+0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.89303-0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		2.23457+0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-2.23457-0.3,	-1.10717+0.193)*40,	Angle(0, 0, 0)},

			{Vector(0.515912,		1.31688+0.115,	-1.18333-0.33+0.275)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.31688-0.115,	-1.18333-0.33+0.275)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		1.59688+0.115,	-1.18333-0.33+0.275)*40,	Angle(0, 0, 0)},
			{Vector(0.515912,		-1.59688-0.115,	-1.18333-0.33+0.275)*40,	Angle(0, 0, 0)},
			{Vector(0.405735,		1.92410+0.3,	-1.10717-0.33+0.198)*40,	Angle(0, 0, 0)},
			{Vector(0.405735,		-1.92410-0.3,	-1.10717-0.33+0.198)*40,	Angle(0, 0, 0)},
			{Vector(0.405735,		2.20345+0.3,	-1.10717-0.33+0.198)*40,	Angle(0, 0, 0)},
			{Vector(0.405735,		-2.20345-0.3,	-1.10717-0.33+0.198)*40,	Angle(0, 0, 0)},
		}
	},
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 4,min = 0, max = self.Loadouts, category = "Weapons"} } )
	self:NetworkVar( "Int",12, "TurretAmmo", { KeyName = "turretammo", Edit = { type = "Int", order = 5,min = 0, max = self.MaxTurretAmmo, category = "Weapons"} })

	self:NetworkVar( "Bool", 15, "IsGunnerAiming")

	if SERVER then
		self:SetLoadout(0)
		self:SetTurretAmmo(self.MaxTurretAmmo)

		self:SetIsGunnerAiming(false)
	end
end