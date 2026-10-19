SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "E-Tool"
SWEP.Type		= "Small Blunt"
SWEP.Description = ""
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_etool.mdl"
SWEP.ViewModelFOV = 77 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_etool_wm.mdl"
SWEP.HoldType = "melee"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = 2,
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

SWEP.InspectPos = Vector(5, -1, -2.688)
SWEP.InspectAng = Vector(15, 40, 10)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.ETool.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 11 * 4.5, -- Trace distance
		["dir"] = Vector(0,15,-80), -- Trace arc cast
		["dmg"] = 121, --Damage
		["dmgtype"] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.250, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.ETool.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(9, -1, 0), --viewpunch angle
		["end"] = 0.9, --time before next attack
		["hull"] = 86, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.ETool.HitFlesh",
		["hitworld"] = "L4D2_MW.ETool.HitWorld",
		["combotime"] = 0.1
	},
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 12.5 * 4.5, -- Trace distance
		["dir"] = Vector(-100, 0, 0), -- Trace arc cast
		["dmg"] = 106, --Damage
		["dmgtype"] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.ETool.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 6, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 86, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.ETool.HitFlesh",
		["hitworld"] = "L4D2_MW.ETool.HitWorld",
		["combotime"] = 0.1
	},
}