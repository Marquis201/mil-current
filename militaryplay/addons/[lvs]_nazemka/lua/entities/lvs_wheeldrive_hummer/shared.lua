ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Hummer"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Автомобиль"

ENT.VehicleCategory = "Автомобиль"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/cars/usa/hummer/humvee.mdl"

ENT.AITEAM = 1
ENT.MaxHealth = 1000

ENT.MaxVelocity = 2000
ENT.EngineTorque = 150
ENT.EngineIdleRPM = 300
ENT.EngineMaxRPM = 6000
ENT.SteerSpeed = 5

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn2.wav"
ENT.HornPos = Vector(40,0,35)

ENT.EngineSounds = {
	{
		sound = "vehicles/hummer/idle2.wav",
		Volume = 0.5,
		Pitch = 45,
		PitchMul = 75,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
		{
		sound = "vehicles/hummer/mid.wav",
		Volume = 1,
		Pitch = 40,
		PitchMul = 50,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(39.6,-35.24,73.29),
		ang = Angle(-90,0,0),
	},
	{
		pos = Vector(39.6,-35.24,73.29),
		ang = Angle(-90,0,0),
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		ProjectedTextures = {
			{ pos = Vector(86,30.2,41.75), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(90,19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
			{ pos = Vector(90,-19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
			{ pos = Vector(90,19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
			{ pos = Vector(90,-19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
		},
	},
	{
	Trigger = "main",
		SubMaterialID = 15,
		Sprites = {
			{ pos = Vector(86,30.2,41.75), colorB = 240, colorA = 215 },
		},
	},
	{
	Trigger = "high",
		Sprites = {
			{ pos = Vector(90,19.88,38.85), colorB = 240, colorA = 215 },
			{ pos = Vector(90,-19.88,38.85), colorB = 240, colorA = 215 },
			{ pos = Vector(90,19.88,38.85), colorB = 240, colorA = 215 },
			{ pos = Vector(90,-19.88,38.85), colorB = 240, colorA = 215 },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 12,
		Sprites = {
			{ pos = Vector(86,30.2,41.75), colorG = 0, colorB = 0, colorA = 65 },
		}
	},
	{
		Trigger = "brake",
			{ pos = Vector(-90.85,34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,-34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,-34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
		Sprites = {
		}
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 12,
		Sprites = {
			{ pos = Vector(-90.85,34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,-34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
		}
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ width = 35, height = 35, pos = Vector(-91.06,-40.25,37.05), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-87.16,-43.61,37.12), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(86.13,-36.05,41.39), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(83.63,-42.99,40.26), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ width = 35, height = 35, pos = Vector(-91.06,40.25,37.05), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-87.16,43.61,37.12), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(86.13,36.05,41.39), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(83.63,42.99,40.26), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
}

ENT.PlayerBoneManipulate = {
	[1] = {
		["ValveBiped.Bip01_R_UpperArm"] = Angle(0,35,0),
		["ValveBiped.Bip01_L_UpperArm"] = Angle(0,35,0),
		
		["ValveBiped.Bip01_R_Forearm"] = Angle(0,-55, 0),
		["ValveBiped.Bip01_L_Forearm"] = Angle(0, -55, 0),
	},
}
