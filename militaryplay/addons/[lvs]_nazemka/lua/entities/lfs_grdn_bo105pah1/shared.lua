ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "BO 105 PAH-1"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Воздух"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/gordon/germany/helicopters/bo105pah1.mdl"

ENT.AITEAM = 1

ENT.Mass = 2500
ENT.Inertia = Vector(5000,5000,5000)
ENT.Drag = 0

ENT.SeatPos = Vector(50,-14,-15)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxThrustHeli = 4
ENT.MaxTurnPitchHeli = 60
ENT.MaxTurnYawHeli = 60
ENT.MaxTurnRollHeli = 50

ENT.ThrustEfficiencyHeli = 0.7

ENT.RotorPos = Vector(4.26105,0,37.338)
ENT.RotorAngle = Angle(2,0,0)
ENT.RotorRadius = 200

ENT.MaxHealth = 8000

ENT.MaxPrimaryAmmo = 800
ENT.MaxSecondaryAmmo = 6

ENT.Loadouts = 3
ENT.MISSILES = {
	[1] = {
		bodygroups = {{1, 1}}, caps_bodygroup = nil,
		ammo = 6,
		model = "models/gordon/france/rockets/hot.mdl", entity = "gb_rocket_hot",
		posang = {
			{Vector(-0.19,	1.69187,	-0.278897)*40,Angle(0, 0, 0)},
			{Vector(-0.19,	-1.69187,	-0.278897)*40,Angle(0, 0, 0)},
			{Vector(-0.19,	1.49149,	-0.278897)*40,Angle(0, 0, 0)},
			{Vector(-0.19,	-1.49149,	-0.278897)*40,Angle(0, 0, 0)},
			{Vector(-0.19,	1.28919,	-0.278897)*40,Angle(0, 0, 0)},
			{Vector(-0.19,	-1.28919,	-0.278897)*40,Angle(0, 0, 0)},
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
		ammo = 6,
		model = "models/gordon/usa/rockets/ffar.mdl", entity = "gb_rocket_ffar",
		posang = {
			{Vector(-0.88,	1.35782,	-0.917885)*40,Angle(0, 0, 0)},
			{Vector(-0.88,	-1.35782,	-0.917885)*40,Angle(0, 0, 0)},
			{Vector(-0.88,	1.48976,	-0.917885)*40,Angle(0, 0, 0)},
			{Vector(-0.88,	-1.48976,	-0.917885)*40,Angle(0, 0, 0)},
			{Vector(-0.88,	1.62171,	-0.917885)*40,Angle(0, 0, 0)},
			{Vector(-0.88,	-1.62171,	-0.917885)*40,Angle(0, 0, 0)},
		}
	},
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 4,min = 0, max = self.Loadouts, category = "Weapons"} } )
	
	if SERVER then
		self:SetLoadout(0)
	end
end