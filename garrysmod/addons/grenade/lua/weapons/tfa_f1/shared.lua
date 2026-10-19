// MISC
SWEP.Base					= "tfa_bomb_nade_base"
SWEP.Category				= "[TFA] Realistic"
SWEP.Author					= "GNS"
SWEP.Contact					= "https://steamcommunity.com/id/svennebananguy/"
SWEP.PrintName				= "f1"
SWEP.Purpose				= "Deadly lemon shaped grenade with a 3.2 second fuse to eliminate enemies in an area."
SWEP.Type				= "Russian Fragmentation Hand Grenade"
SWEP.Slot					= 4
SWEP.SlotPos				= 99
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false
SWEP.Weight					= 2
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom			= true
SWEP.HoldType 				= "grenade"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.Sprint_Mode 				= TFA.Enum.LOCOMOTION_ANI
SWEP.SelectiveFire = false

// VIEWMODEL
SWEP.ViewModelFOV				= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/tfa_ins2/v_f1.mdl"

// WORLDMODEL
SWEP.WorldModel				= "models/weapons/tfa_ins2/w_f1.mdl"
SWEP.ShowWorldModel			= false
SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/tfa_ins2/w_f1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, -2.597), angle = Angle(180, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

// NADE STUFF
SWEP.Primary.RPM				= 30
SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo				= "grenade"
SWEP.Primary.Round 			= ("tfa_bombf1")
SWEP.Velocity = 1300
SWEP.Velocity_Underhand = 650
SWEP.Delay = 0.23
SWEP.DelayCooked = 0.24
SWEP.Delay_Underhand = 0.245
SWEP.CookStartDelay = 1
SWEP.UnderhandEnabled = true
SWEP.CookingEnabled = true
SWEP.CookTimer = 3.2

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "sprint",
		["is_idle"] = true
	}
}

SWEP.InspectPos 				= Vector(4, -3.619, -0.787)
SWEP.InspectAng 				= Vector(22.386, 34.417, 5)
