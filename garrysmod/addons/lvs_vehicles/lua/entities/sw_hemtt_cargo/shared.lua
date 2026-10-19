ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "[LVS] HEMTT (Cargo)"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Грузовики"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/hemtt/hemtt_cargo.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1200
ENT.MaxVelocityReverse = 500
ENT.MaxHealth = 1500

ENT.EngineCurve = 0.45
ENT.EngineTorque = 200
ENT.EngineIdleRPM = 2500
ENT.EngineMaxRPM = 5000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn2.wav"
ENT.HornPos = Vector(155,0,65)

--Pylons
ENT.Pylons = {
	Vector(-25,0,58),
	Vector(-115,0,58),
}


function ENT:InitWeapons()
	local airdrop = {}
	airdrop.Icon = Material("icons/airdrop.png")
	airdrop.Ammo = 2
	airdrop.Delay = 0.25
	airdrop.HeatRateUp = 0
	airdrop.HeatRateDown = 0
	airdrop.Attack = function( ent )
		local ammo = ent:GetAmmo()
		ent:TakeAmmo( 1 )
		if istable( self.Cargo ) then
			local oldairdrop = self.Cargo[ammo]
			if !IsValid(oldairdrop) then return end
			local airdrop = ents.Create("sw_airdrop_large_v3")
			airdrop:SetPos(self:LocalToWorld(Vector(-180,0,60)))
			airdrop:SetAngles(oldairdrop:GetAngles())
			airdrop:Spawn()
			airdrop:Activate()
			oldairdrop:SetNoDraw(true)
		end
	end
	self:AddWeapon( airdrop, 2 )
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
			{ pos = Vector(-171,-42.4,60.4), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-171,42.4,60.4), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-178,-32.6,54.6), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-178,32.6,54.6), colorG = 0, colorB = 0, colorA = 150 },
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
			{ pos = Vector(-178.2,-40.65,53.15), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(183.5,28,61), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(178.1,44,61), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(178.1,44,58.85), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-178.2,40.65,53.15), colorG = 150, colorB = 0, colorA = 150 },
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