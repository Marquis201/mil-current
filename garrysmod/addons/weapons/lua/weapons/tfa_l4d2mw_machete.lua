SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Machete"
SWEP.Type		= "Knife"
SWEP.Description = ""
SWEP.Purpose = "Probably used to kill councellors at a summer camp or something."
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_machete.mdl"
SWEP.ViewModelFOV = 60 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_machete_wm.mdl"
SWEP.HoldType = "melee"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = 1,
		Right = 1.5,
		Forward = 4,
		},
		Ang = {
		Up = 200,
		Right = 185,
		Forward = 7
		},
		Scale = 1
}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.InspectPos = Vector(8, -1, -2.688)
SWEP.InspectAng = Vector(15, 40, 10)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.Machete.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 4.5, -- Trace distance
		["dir"] = Vector(-100, 120, -50), -- Trace arc cast
		["dmg"] = 124, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Machete.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(4, -1, 0), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 100, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.Machete.HitFlesh",
		["hitworld"] = "L4D2_MW.Machete.HitWorld",
		["combotime"] = 0.1
	},
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 4.5, -- Trace distance
		["dir"] = Vector(-100, 0, 0), -- Trace arc cast
		["dmg"] = 122, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Machete.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 6, 0), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 96, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.Machete.HitFlesh",
		["hitworld"] = "L4D2_MW.Machete.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 4.5, -- Trace distance
		["dir"] = Vector(100, 0, 0), -- Trace arc cast
		["dmg"] = 122, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Machete.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(1, 5, -1), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 96, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "L4D2_MW.Machete.HitFlesh",
		["hitworld"] = "L4D2_MW.Machete.HitWorld",
		["combotime"] = 0.1
	},
}