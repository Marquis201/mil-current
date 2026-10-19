SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Knife"
SWEP.Type		= "Knife"
SWEP.Description = ""
SWEP.Purpose = ""
SWEP.Author = "teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_knife.mdl"
SWEP.ViewModelFOV = 65 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_knife_wm.mdl"
SWEP.HoldType = "knife"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = 1,
		Right = 1.5,
		Forward = 3,
		},
		Ang = {
		Up = 200,
		Right = 160,
		Forward = 7
		},
		Scale = 1
}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.Secondary.BashLength = 45
SWEP.Secondary.BashDamage = 52
SWEP.Secondary.BashDelay = 0.115

SWEP.InspectPos = Vector(8, -2, -0.688)
SWEP.InspectAng = Vector(15, 40, 10)

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.Knife.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{

		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 12 * 4.5, -- Trace distance
		["dir"] = Vector(-50, 0, 0), -- Trace arc cast
		["dmg"] = 130, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.185, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.Knife.Swing", -- Sound ID
		["snd_delay"] = 0.165,
		["viewpunch"] = Angle(0, 6, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 110, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "L4D2_MW.Knife.HitFlesh",
		["hitworld"] = "L4D2_MW.Knife.HitWorld",
		["combotime"] = 0.1
	},

}

--[[VIEWMODEL]]--
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-13.346, 52.627, -2.909) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 7.876, 0) }
}