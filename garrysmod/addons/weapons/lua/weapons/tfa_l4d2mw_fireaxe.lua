SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Fire Axe"
SWEP.Type		= "Axe"
SWEP.Description = ""
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_fireaxe.mdl"
SWEP.ViewModelFOV = 77 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_fireaxe_wm.mdl"
SWEP.HoldType = "melee2"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = 7,
		Right = 2,
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

SWEP.InspectPos = Vector(-3, 0, -2)
SWEP.InspectAng = Vector(10, 8, -15)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.FireAxe.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 10 * 9.5, -- Trace distance
		["dir"] = Vector(0,15,-80), -- Trace arc cast
		["dmg"] = 165, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.FireAxe.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(9, -1, 0), --viewpunch angle
		["end"] = 0.9, --time before next attack
		["hull"] = 120, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.FireAxe.HitFlesh",
		["hitworld"] = "L4D2_MW.FireAxe.HitWorld",
		["combotime"] = 0.1
	},
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 21 * 4.5, -- Trace distance
		["dir"] = Vector(-100, 0, 0), -- Trace arc cast
		["dmg"] = 106, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.FireAxe.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 6, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 96, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.FireAxe.HitFlesh",
		["hitworld"] = "L4D2_MW.FireAxe.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 14 * 4.5, -- Trace distance
		["dir"] = Vector(-100, 0, 0), -- Trace arc cast
		["dmg"] = 135, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.FireAxe.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(1, 5, -1), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 96, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "L4D2_MW.FireAxe.HitFlesh",
		["hitworld"] = "L4D2_MW.FireAxe.HitWorld",
		["combotime"] = 0.1
	},
}