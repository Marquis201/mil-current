ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "Mi-28NM"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Воздух"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/gordon/ussr/helicopters/mi28nm.mdl"

ENT.AITEAM = 1

ENT.Mass = 12000
ENT.Inertia = Vector(5000,5000,5000)
ENT.Drag = 0

ENT.SeatPos = Vector(50, 0.6588, 10)
ENT.SeatAng = Angle(0,-90,0)
--ENT.CustomViewPoint = Vector(52, 0, 8)

ENT.WheelMass = 700
ENT.WheelRadius = 15
ENT.WheelPos_L = Vector(1.07732,1.20606,-1.61672)*40
ENT.WheelPos_R = Vector(1.07732,-1.20606,-1.61672)*40
ENT.WheelPos_C = Vector(-10.2691,0,-0.45)*40

ENT.MaxThrustHeli = 7
ENT.MaxTurnPitchHeli = 60
ENT.MaxTurnYawHeli = 60
ENT.MaxTurnRollHeli = 50

ENT.ThrustEfficiencyHeli = 0.8

ENT.RotorPos = Vector(0,0,1.35365)*40
ENT.RotorAngle = Angle(2,0,0)
ENT.RotorRadius = 200

ENT.MaxHealth = 8000

ENT.MaxPrimaryAmmo = 500
ENT.MaxTurretAmmo = 250
ENT.MaxSecondaryAmmo = 80

ENT.Loadouts = 3
ENT.MISSILES = {
	[1] = {
		bodygroups = {{1, 1}}, caps_bodygroup = nil,
		ammo = 80,
		model = "models/gordon/ussr/rockets/s_8ko.mdl", entity = "gb_rocket_s_8ko",
		posang = {
			{Vector(-0.845, 			1.67810,			-0.456074)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.67810,			-0.456074)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.62288,			-0.535119)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.62288,			-0.535119)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.64778,			-0.628044)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.64778,			-0.628044)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.73505,			-0.668624)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.73505,			-0.668624)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.82232,			-0.628044)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.82232,			-0.628044)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.84722,			-0.535119)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.84722,			-0.535119)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.79200,			-0.456074)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.79200,			-0.456074)*40,Angle(0, 0, 0)},

			{Vector(-0.845, 			1.64505,			-0.368034)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.64505,			-0.368034)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.57289,			-0.425539)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.57289,			-0.425539)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.53284,			-0.508549)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.53284,			-0.508549)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.53279,			-0.600949)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.53279,			-0.600949)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.57294,			-0.684089)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.57294,			-0.684089)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.64510,			-0.741589)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.64510,			-0.741589)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.73505,			-0.762209)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.73505,			-0.762209)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.82504,			-0.741589)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.82504,			-0.741589)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.89720,			-0.684089)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.89720,			-0.684089)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.93726,			-0.600949)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.93726,			-0.600949)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.93731,			-0.508549)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.93731,			-0.508549)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.89720,			-0.425539)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.89720,			-0.425539)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.82505,			-0.368034)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.82505,			-0.368034)*40,Angle(0, 0, 0)},

			{Vector(-0.845, 			1.67810+0.716,			-0.456074+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.67810-0.716,			-0.456074+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.62288+0.716,			-0.535119+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.62288-0.716,			-0.535119+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.64778+0.716,			-0.628044+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.64778-0.716,			-0.628044+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.73505+0.716,			-0.668624+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.73505-0.716,			-0.668624+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.82232+0.716,			-0.628044+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.82232-0.716,			-0.628044+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.84722+0.716,			-0.535119+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.84722-0.716,			-0.535119+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.79200+0.716,			-0.456074+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.79200-0.716,			-0.456074+0.0203)*40,Angle(0, 0, 0)},

			{Vector(-0.845, 			1.64505+0.716,			-0.368034+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.64505-0.716,			-0.368034+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.57289+0.716,			-0.425539+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.57289-0.716,			-0.425539+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.53284+0.716,			-0.508549+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.53284-0.716,			-0.508549+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.53279+0.716,			-0.600949+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.53279-0.716,			-0.600949+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.57294+0.716,			-0.684089+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.57294-0.716,			-0.684089+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.64510+0.716,			-0.741589+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.64510-0.716,			-0.741589+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.73505+0.716,			-0.762209+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.73505-0.716,			-0.762209+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.82504+0.716,			-0.741589+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.82504-0.716,			-0.741589+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.89720+0.716,			-0.684089+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.89720-0.716,			-0.684089+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.93726+0.716,			-0.600949+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.93726-0.716,			-0.600949+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.93731+0.716,			-0.508549+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.93731-0.716,			-0.508549+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.89720+0.716,			-0.425539+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.89720-0.716,			-0.425539+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			1.82505+0.716,			-0.368034+0.0203)*40,Angle(0, 0, 0)},
			{Vector(-0.845, 			-1.82505-0.716,			-0.368034+0.0203)*40,Angle(0, 0, 0)},
		}
	},
	[2] = {
		bodygroups = {{1, 2}}, caps_bodygroup = nil,
		ammo = 0,
		model = "", entity = "",
		posang = {}
	},
	[3] = {
		bodygroups = {{1, 3}}, caps_bodygroup = nil,
		ammo = 20,
		model = "models/gordon/ussr/rockets/s_13.mdl", entity = "gb_rocket_s_13",
		posang = {
			{Vector(-1.47, 			1.66050, 			-0.409687)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-1.66050, 			-0.409687)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			1.63000, 			-0.538172)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-1.63000, 			-0.538172)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			1.74118, 			-0.616687)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-1.74118, 			-0.616687)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			1.85236, 			-0.538172)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-1.85236, 			-0.538172)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			1.82191, 			-0.409687)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-1.82191, 			-0.409687)*40,	Angle(0, 0, 0)},

			{Vector(-1.47, 			2.36950, 			-0.409687+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-2.36950, 			-0.409687+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			2.33905, 			-0.538172+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-2.33905, 			-0.538172+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			2.45018, 			-0.616687+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-2.45018, 			-0.616687+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			2.56136, 			-0.538172+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-2.56136, 			-0.538172+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			2.53096, 			-0.409687+0.026844)*40,	Angle(0, 0, 0)},
			{Vector(-1.47, 			-2.53096, 			-0.409687+0.026844)*40,	Angle(0, 0, 0)},
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