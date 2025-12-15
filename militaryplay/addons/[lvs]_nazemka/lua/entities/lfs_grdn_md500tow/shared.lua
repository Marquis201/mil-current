ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_heli" )

ENT.PrintName = "MD-500 Defender"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Воздух"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/gordon/israel/helicopters/md500tow.mdl"

ENT.AITEAM = 1

ENT.Mass = 650
ENT.Inertia = Vector(5000,5000,5000)
ENT.Drag = 0

ENT.SeatPos = Vector(25,-14,-52)
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

ENT.MaxPrimaryAmmo = -1
ENT.MaxSecondaryAmmo = 14

ENT.Loadouts = 2
ENT.MISSILES = {
	[1] = {
		bodygroups = {{1, 1}}, caps_bodygroup = nil,
		ammo = 14,
		model = "models/gordon/usa/rockets/ffar.mdl", entity = "gb_rocket_ffar",
		posang = {
			{Vector(-1.36,	1.24507,	-1.730692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	-1.24507,	-1.730692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	1.32307,	-1.730692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	-1.32307,	-1.730692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	1.28407,	-1.660692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	-1.28407,	-1.660692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	1.20607,	-1.660692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	-1.20607,	-1.660692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	1.36208,	-1.660692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	-1.36208,	-1.660692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	1.24507,	-1.596692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	-1.24507,	-1.596692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	1.32307,	-1.596692)*40,Angle(0, 0, 0)},
			{Vector(-1.36,	-1.32307,	-1.596692)*40,Angle(0, 0, 0)},
		}
	},
	[2] = {
		bodygroups = {{1, 2}}, caps_bodygroup = nil,
		ammo = 4,
		model = "models/gordon/usa/rockets/bgm71.mdl", entity = "gb_rocket_bgm71",
		posang = {
			{Vector(-0.96,	1.17405,	-1.705)*40,Angle(0, 0, 0)},
			{Vector(-0.96,	-1.17405,	-1.705)*40,Angle(0, 0, 0)},
			{Vector(-0.96,	1.39332,	-1.705)*40,Angle(0, 0, 0)},
			{Vector(-0.96,	-1.39332,	-1.705)*40,Angle(0, 0, 0)},
		}
	}
}

function ENT:AddDataTables()
	self:NetworkVar( "Int",11, "Loadout", { KeyName = "loadout", Edit = { type = "Int", order = 4,min = 0, max = self.Loadouts, category = "Weapons"} } )
	
	if SERVER then
		self:SetLoadout(0)
	end
end