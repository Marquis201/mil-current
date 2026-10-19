SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Golf Club"
SWEP.Type		= "Blunt"
SWEP.Description = ""
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_golfclub.mdl"
SWEP.ViewModelFOV = 73 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_golfclub_wm.mdl"
SWEP.HoldType = "melee2"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = 1,
		Right = 1,
		Forward = 3.5,
		},
		Ang = {
		Up = 300,
		Right = 185,
		Forward = 1
		},
		Scale = 1
}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.InspectPos = Vector(5, -5, -2.688)
SWEP.InspectAng = Vector(15, 40, 10)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.GolfClub.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 5.5, -- Trace distance
		["dir"] = Vector(0,15,-80), -- Trace arc cast
		["dmg"] = 126, --Damage
		["dmgtype"] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.1, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.GolfClub.Swing", -- Sound ID
		["snd_delay"] = 0.01,
		["viewpunch"] = Angle(9, -1, 0), --viewpunch angle
		["end"] = 0.650, --time before next attack
		["hull"] = 105, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.GolfClub.HitFlesh",
		["hitworld"] = "L4D2_MW.GolfClub.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 18 * 4.5, -- Trace distance
		["dir"] = Vector(100, 0, 0), -- Trace arc cast
		["dmg"] = 128, --Damage
		["dmgtype"] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.1, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.GolfClub.Swing", -- Sound ID
		["snd_delay"] = 0.01,
		["viewpunch"] = Angle(1, 5, -1), --viewpunch angle
		["end"] = 0.695, --time before next attack
		["hull"] = 90, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "L4D2_MW.GolfClub.HitFlesh",
		["hitworld"] = "L4D2_MW.GolfClub.HitWorld",
		["combotime"] = 0.1
	},
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(-0.218, 0, -0.371), angle = Angle(1.851, 8.866, -7.878) },
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 56.083, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -31.07) }
}