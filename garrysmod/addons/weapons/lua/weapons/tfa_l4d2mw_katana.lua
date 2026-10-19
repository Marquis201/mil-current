SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Katana"
SWEP.Type		= "Sword"
SWEP.Description = ""
SWEP.Purpose = ""
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_katana.mdl"
SWEP.ViewModelFOV = 60 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_katana_wm.mdl"
SWEP.HoldType = "melee2"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = 0,
		Right = 1.5,
		Forward = 3.8,
		},
		Ang = {
		Up = 200,
		Right = 185,
		Forward = -9
		},
		Scale = 1
}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.InspectPos = Vector(8, -5, -2.688)
SWEP.InspectAng = Vector(15, 40, 10)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.Katana.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 19 * 4.5, -- Trace distance
		["dir"] = Vector(-150, 0, 0), -- Trace arc cast
		["dmg"] = 132, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Katana.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 5, 0.1), --viewpunch angle
		["end"] = 0.750, --time before next attack
		["hull"] = 106, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.Katana.HitFlesh",
		["hitworld"] = "L4D2_MW.Katana.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 19 * 4.5, -- Trace distance
		["dir"] = Vector(-100, 0, 0), -- Trace arc cast
		["dmg"] = 129, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Katana.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 5, 0.1), --viewpunch angle
		["end"] = 0.660, --time before next attack
		["hull"] = 106, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.Katana.HitFlesh",
		["hitworld"] = "L4D2_MW.Katana.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 19 * 4.5, -- Trace distance
		["dir"] = Vector(150, 0, 0), -- Trace arc cast
		["dmg"] = 131, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Katana.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 5, 0), --viewpunch angle
		["end"] = 0.692, --time before next attack
		["hull"] = 106, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "L4D2_MW.Katana.HitFlesh",
		["hitworld"] = "L4D2_MW.Katana.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 19 * 4.5, -- Trace distance
		["dir"] = Vector(100, 0, 0), -- Trace arc cast
		["dmg"] = 130, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Katana.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 5, 0), --viewpunch angle
		["end"] = 0.621, --time before next attack
		["hull"] = 106, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "L4D2_MW.Katana.HitFlesh",
		["hitworld"] = "L4D2_MW.Katana.HitWorld",
		["combotime"] = 0.1
	},
}