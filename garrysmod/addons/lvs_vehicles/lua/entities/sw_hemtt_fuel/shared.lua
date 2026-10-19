ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "[LVS] HEMTT (Fuel)"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Грузовики"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/hemtt/hemtt_fuel.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1200
ENT.MaxVelocityReverse = 500
ENT.MaxHealth = 1500
ENT.DSArmorIgnoreForce = nil

ENT.EngineCurve = 0.45
ENT.EngineTorque = 200
ENT.EngineIdleRPM = 2500
ENT.EngineMaxRPM = 5000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn2.wav"
ENT.HornPos = Vector(155,0,65)

function ENT:OnSetupDataTables()
	self:AddDT("Entity","User")
	self:AddDT( "Int", "FuelType" , { KeyName = "fueltype",	Edit = { type = "Int",	order = 1, min = 0, max = 3, category = "Misc"} } )
end

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/222/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 65,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/222/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(184.2,34.7,59.1), colorA = 150 },
			{ pos = Vector(184.2,-34.7,59.1), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(184.2,34.7,59.1), colorA = 150 },
			{ pos = Vector(184.2,-34.7,59.1), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(184.2,34.7,59.1), colorA = 150 },
			{ pos = Vector(184.2,-34.7,59.1), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(184.2,34.7,59.1), colorA = 150 },
			{ pos = Vector(184.2,-34.7,59.1), colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		Sprites = {
			{ pos = Vector(171.2,-34.55,93), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(171.2,-7.4,93), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(171.2,7.4,93), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(171.2,34.55,93), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-171.6,-43.35,55), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-171.6,43.35,55), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-173.2,-33.9,45), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-173.2,33.9,45), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-157,-9.4,41), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-157,9.4,41), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(183.5,-28,61), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(178.1,-44,61), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(178.1,-44,58.85), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(16.85,-42.15,65.15), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(16.85,-43,62.8), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-170.6,-42.25,75), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-174.7,-23.7,86.2), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(183.5,28,61), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(178.1,44,61), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(178.1,44,58.85), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(16.85,42.15,65.15), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(16.85,43,62.8), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-170.6,42.25,75), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-174.7,23.7,86.2), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(47.5,-32,123),
		ang = Angle(-40,180,0),
	},
	{
		pos = Vector(47.5,-32,123),
		ang = Angle(-40,180,0),
	},
	{
		pos = Vector(47.5,-32,123),
		ang = Angle(-40,180,0),
	},
}