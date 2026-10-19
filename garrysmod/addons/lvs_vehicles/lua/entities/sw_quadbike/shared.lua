ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Quadbike"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Автомобиль"
ENT.VehicleCategory = "Автомобиль"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/quadbike/quadbike.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1100
ENT.MaxVelocityReverse = 100
ENT.MaxHealth = 500
ENT.MaxHealthEngine = 100
ENT.MaxHealthFuelTank = 50


ENT.FastSteerActiveVelocity = 2000

ENT.EngineCurve = 0.25
ENT.EngineTorque = 150
ENT.EngineIdleRPM = 3000
ENT.EngineMaxRPM = 5200

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/222/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 45,
		PitchMul = 15,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/222/eng_loop.wav",
		Volume = 1,
		Pitch = 40,
		PitchMul = 50,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(28.35,9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
			{ pos = Vector(28.35,-9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(28.35,9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
			{ pos = Vector(28.35,-9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(28.35,9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
			{ pos = Vector(28.35,-9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(28.35,9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
			{ pos = Vector(28.35,-9.38,27.45), ang = Angle(0,0,0), colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		Sprites = {
			{ pos = Vector(-43.55,0,31), colorR = 150,  colorG = 0, colorB = 0, colorA = 250 },	
		},
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-44.3,-7.625,28),
		ang = Angle(0,180,0),
	},
	{
		pos = Vector(-44.3,-7.625,28),
		ang = Angle(0,180,0),
	},
	{
		pos = Vector(-44.3,-7.625,28),
		ang = Angle(0,180,0),
	},
}