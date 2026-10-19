
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "KAMAZ-5350"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Грузовики"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/kamaz5350/kamaz5350.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1100
ENT.MaxVelocityReverse = 350
ENT.MaxHealth = 1000

ENT.EngineCurve = 0.35
ENT.EngineTorque = 150
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 4500

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn3.wav"
ENT.HornPos = Vector(150,0,60)

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/222/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 65,
		PitchMul = 15,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/222/eng_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
		ProjectedTextures = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
		ProjectedTextures = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-179,-36.4,52), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-179,36.4,52), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-180,-49.2,27.8), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-180,49.2,27.8), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 3,
		Sprites = {
			{ pos = Vector(131.6,49.7,113.6), colorA = 200 },
			{ pos = Vector(124.5,-5.65,119.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(124.5,0,119.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(124.5,5.65,119.5), colorG = 150, colorB = 0, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(131.6,49.7,113.6), colorA = 200 },
		},
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(164,-36.2,41.6), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(145.5,-50.55,69.4), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(86.5,-49.5,68.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(11.4,-57.1,58.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-105,-57.1,58.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-150,-57.1,58.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-179,-55.5,27.75), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-179,-42,52), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(164,36.2,41.6), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(145.5,50.55,69.4), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(86.5,49.5,68.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(11.4,57.1,58.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-105,57.1,58.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-150,57.1,58.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-179,55.5,27.75), colorG = 150, colorB = 0, colorA = 150 },		
			{ pos = Vector(-179,42,52), colorG = 150, colorB = 0, colorA = 150 },		
		},
	},
}


ENT.ExhaustPositions = {
	{
		pos = Vector(-13,-52.6,31.7),
		ang = Angle(0,-90,0),
	},
	{
		pos = Vector(-13,-52.6,31.7),
		ang = Angle(0,-90,0),
	},
	{
		pos = Vector(-13,-52.6,31.7),
		ang = Angle(0,-90,0),
	},
}
