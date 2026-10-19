SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Pitchfork"
SWEP.Type		= "Farming Tool"
SWEP.Description = ""
SWEP.Purpose = ""
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_pitchfork.mdl"
SWEP.ViewModelFOV = 75 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_pitchfork_wm.mdl"
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
		Forward = 2.8,
		},
		Ang = {
		Up = 260,
		Right = 185,
		Forward = -9
		},
		Scale = 1
}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.InspectPos = Vector(8, -5, -2.688)
SWEP.InspectAng = Vector(15, 30, 10)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.Pitchfork.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 15 * 4.5, -- Trace distance
		["dir"] = Vector(10, 50, 0), -- Trace arc cast
		["dmg"] = 142, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Pitchfork.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 101, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.Pitchfork.HitFlesh",
		["hitworld"] = "L4D2_MW.Pitchfork.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 17 * 3.5, -- Trace distance
		["dir"] = Vector(0,15,-80), -- Trace arc cast
		["dmg"] = 123, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Pitchfork.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(8, 0, 0), --viewpunch angle
		["end"] = 0.495, --time before next attack
		["hull"] = 106, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.Pitchfork.HitFlesh",
		["hitworld"] = "L4D2_MW.Pitchfork.HitWorld",
		["combotime"] = 0.1
	},

	{
		["act"] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 4.5, -- Trace distance
		["dir"] = Vector(-150, 0, 0), -- Trace arc cast
		["dmg"] = 118, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Pitchfork.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 7.5, 0), --viewpunch angle
		["end"] = 0.7, --time before next attack
		["hull"] = 100, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.Pitchfork.HitFlesh",
		["hitworld"] = "L4D2_MW.Pitchfork.HitWorld",
		["combotime"] = 0.1
	},
}