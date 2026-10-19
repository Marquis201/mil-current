
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Kamaz 5350 Repair"
ENT.Author = "Engineer"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] Грузовики"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/kamaz5350/mil_repair/kamaz_repair.mdl"

ENT.AITEAM = 0

ENT.MaxVelocity = 800

ENT.EngineCurve = 0.25
ENT.EngineTorque = 100

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "kamaz5350/throttle.wav",
		Volume = 0.8,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "kamaz5350/low.wav",
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
		--SubMaterialID = 0,
		Sprites = {
			[1] = {
				pos = Vector(127.5,29.7,47.612),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(127.5,-29.7,47.612),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-137.5,25,35),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[4] = {
				pos = Vector(-137.5,-25,35),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},

	-- {
		-- Trigger = "fog",
	-- },
	{
		Trigger = "high",
		Sprites = {
			[1] = {
				pos = Vector(127.5,29.7,47.612),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(127.5,-29.7,47.612),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(127.5,29.7,47.612),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(127.5,-29.7,47.612),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{

		Trigger = "brake",
		--SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(-137.5,-27,35),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},			
			[2] = {
				pos = Vector(-137.5,27,35),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
	{

		Trigger = "reverse",
		--SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(-137.5,-27,35),
				colorA = 150
			},			
			[2] = {
				pos = Vector(-137.5,27,35),
				colorA = 150
			},
		}
	},
	{
		Trigger = "fog",
		--SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(133.5,-30.7,33),
				colorB = 200,
				colorA = 150,
			},
						[2] = {
				pos = Vector(133.5,30.7,33),
				colorB = 200,
				colorA = 150,
			},
						[3] = {
				pos = Vector(106,-0,99),
				colorR = 255,
				colorG = 120,
				colorB = 0,
				colorA = 255
			},
						[4] = {
				pos = Vector(106,-4.5,99),
				colorR = 255,
				colorG = 120,
				colorB = 0,
				colorA = 255
			},
						[5] = {
				pos = Vector(106,4.5,99),
				colorR = 255,
				colorG = 120,
				colorB = 0,
				colorA = 255
			},
									[6] = {
				pos = Vector(106,-0,99),
				width = 15,
				height = 15,
				colorR = 255,
				colorG = 255,
				colorB = 0,
				colorA = 100
			},
									[7] = {
				pos = Vector(106,4.5,99),
								width = 15,
				height = 15,
				colorR = 255,
				colorG = 255,
				colorB = 0,
				colorA = 100
			},
									[8] = {
				pos = Vector(106,-4.5,99),
								width = 15,
				height = 15,
				colorR = 255,
				colorG = 255,
				colorB = 0,
				colorA = 100
			},
						[9] = {
				pos = Vector(113,45,95.5),
				colorB = 200,
				colorA = 150,
			},
		},
	},
	
		{

		Trigger = "turnright",
		--SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(133.5,-30.8,35),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},			
			[2] = {
				pos = Vector(124,-41,58),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},
			[3] = {
				pos = Vector(81.5,-41,57.5),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},
			[4] = {
				pos = Vector(-137.5,-29.5,35),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},
			
		}
	},
	{

		Trigger = "turnleft",
		--SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(133.5,30.4,35),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},			
			[2] = {
				pos = Vector(124,41,58),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},
			[3] = {
				pos = Vector(81.5,41,57.5),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},
			[4] = {
				pos = Vector(-137.5,29.5,35),
				colorG = 100,
				colorB = 0,
				colorA = 50
			},
			
		}
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-63,-39,36.4),
		ang = Angle(0,-90,0),
	},
}

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/horn.png")
	weapon.Ammo = -1
	weapon.Delay = 0.5
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.Attack = function( ent ) end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.HornSND ) then return end
		ent.HornSND:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.HornSND ) then return end
		ent.HornSND:Stop()
	end
	self:AddWeapon( weapon )
end
