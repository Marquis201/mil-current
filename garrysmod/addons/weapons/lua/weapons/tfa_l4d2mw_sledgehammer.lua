SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Sledgehammer"
SWEP.Type		= "Blunt"
SWEP.Description = ""
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_sledgehammer.mdl"
SWEP.ViewModelFOV = 73 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_sledgehammer_wm.mdl"
SWEP.HoldType = "melee2"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = -1,
		Right = 1.5,
		Forward = 3,
		},
		Ang = {
		Up = 200,
		Right = 185,
		Forward = 1
		},
		Scale = 1
}

SWEP.Precision = 75
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.InspectPos = Vector(-3, 0, -2)
SWEP.InspectAng = Vector(10, 8, -15)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 4 / 30, type = "sound", value = Sound("L4D2_MW.Sledgehammer.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 18 * 4.5, -- Trace distance
		["dir"] = Vector(0,15,-80), -- Trace arc cast
		["dmg"] = 200, --Damage
		["dmgtype"] = DMG_CRUSH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.250, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Sledgehammer.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(13, -3, 0), --viewpunch angle
		["end"] = 1.2, --time before next attack
		["hull"] = 110, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.Sledgehammer.HitFlesh",
		["hitworld"] = "L4D2_MW.Sledgehammer.HitWorld",
		["combotime"] = 0.1
	},
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 17 * 5.5, -- Trace distance
		["dir"] = Vector(-100, 0, 0), -- Trace arc cast
		["dmg"] = 144, --Damage
		["dmgtype"] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.250, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Sledgehammer.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(1, 13, -1), --viewpunch angle
		["end"] = 0.980, --time before next attack
		["hull"] = 96, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.Sledgehammer.HitFlesh",
		["hitworld"] = "L4D2_MW.Sledgehammer.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 14 * 6.5, -- Trace distance
		["dir"] = Vector(100, 0, 0), -- Trace arc cast
		["dmg"] = 120, --Damage
		["dmgtype"] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.2, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Sledgehammer.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(1, 13, -1), --viewpunch angle
		["end"] = 0.950, --time before next attack
		["hull"] = 105, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "L4D2_MW.Sledgehammer.HitFlesh",
		["hitworld"] = "L4D2_MW.Sledgehammer.HitWorld",
		["combotime"] = 0.1
	},
}

--[[VIEWMODEL]]--
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.691, 28.809, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -14.879) }
}
