ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "Sud-Aviation SA 316B"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Воздух"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/gordon/france/helicopters/sa316b.mdl"

ENT.AITEAM = 1

ENT.Mass = 2200
ENT.Inertia = Vector(5000,5000,5000)
ENT.Drag = 0

ENT.SeatPos = Vector(65,-22.5,-8)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxThrustHeli = 9
ENT.MaxTurnPitchHeli = 30
ENT.MaxTurnYawHeli = 40
ENT.MaxTurnRollHeli = 80

ENT.ThrustEfficiencyHeli = 0.9

ENT.RotorPos = Vector(4.26105,0,37.338)
ENT.RotorAngle = Angle(2,0,0)
ENT.RotorRadius = 200

ENT.WheelMass = 200
ENT.WheelRadius = 7.5
ENT.WheelPos_C = Vector(2.07773,-0.001732,-1.22708)*40
ENT.WheelPos_L = Vector(-0.798033,1.23973,-1.22408)*40
ENT.WheelPos_R = Vector(-0.798033,-1.23973,-1.22408)*40

ENT.MaxHealth = 8000

ENT.MaxPrimaryAmmo = -1
ENT.MaxSecondaryAmmo = 4

ENT.Loadouts = 1
ENT.MISSILES = {
	[1] = {
		bodygroups = {{1, 1}}, caps_bodygroup = nil,
		ammo = 4,
		model = "models/gordon/france/rockets/ss11.mdl", entity = "gb_rocket_ss11",
		posang = {
			{Vector(14.3934+8.5,-82.1046, -20), Angle(-2, 0, 0)},
			{Vector(14.3934+8.5,82.6398, -20), Angle(-2, 0, 0)},
			{Vector(14.3934+8.5,-62.6146, -20), Angle(-2, 0, 0)},
			{Vector(14.3934+8.5,63.169, -20), Angle(-2, 0, 0)}
		}
	}
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 4,min = 0, max = self.Loadouts, category = "Weapons"} } )
	
	if SERVER then
		self:SetLoadout(0)
	end
end