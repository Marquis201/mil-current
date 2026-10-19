-- Variables that are used on both client and server
SWEP.Gun = ("tfa_ins2_glock_19") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Military Play | Оружие" --Category where you will find your weapons
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "shell" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Glock 19"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 35		-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV			= 54
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_glock19.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_ins2/w_glock19.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE! 
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.ShowWorldModel			= true
SWEP.UseHands = true

SWEP.Primary.Sound			= Sound("weapons/glock_19/glock18-1.wav")
SWEP.Primary.SilencedSound			= Sound("weapons/glock_19/glock18_suppresed.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 505			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10		-- Size of a clip
SWEP.Primary.DefaultClip		= 40		-- Bullets you start with
SWEP.Primary.KickUp				= 0.6		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.07		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.04		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false	-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "pistol"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire		= false
SWEP.CanBeSilenced		= false

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode

SWEP.Primary.Damage		= 31.3	-- Base damage per bullet
SWEP.Primary.Spread		= .013	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .001 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-1.950, 0, 0.450)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.InspectPos = Vector(7.76, -5.178, 0.016)
SWEP.InspectAng = Vector(1, 37.277, 3.2)

SWEP.Offset = {
	Pos = {
		Up = -0.9,
		Right = 0.964,
		Forward = 4.796
	},
	Ang = {
		Up = 0,
		Right = -5.844,
		Forward = 180
	},
	Scale = 0.9
} --Procedural world model animation, defaulted for CS:S purposes.

SWEP.WElements = {
	["ref"] = { type = "Model", model = SWEP.WorldModel, bone = "oof", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
}

SWEP.Primary.ClipSize_ExtPistol = 25

SWEP.VElements = {
                        ["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl", bone = "Weapon", rel = "", pos = Vector(-0.132, 4, 0.352), angle = Angle(0, -90.44, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active =false, bonemerge = true },
                        ["mag"] = { type = "Model", model = "models/weapons/upgrades/a_maganize_glock19.mdl", bone = "Magazine", rel = "", pos = Vector(1.409, -11.773, 5.793), angle = Angle(-11.528, -85.519, 0.18), size = Vector(1.500, 1.500, 1.500), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = true },
                        ["mag_ext"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_glock19_33.mdl", bone = "Magazine", rel = "", pos = Vector(1.409, -11.773, 5.793), angle = Angle(-11.528, -85.519, 0.18), size = Vector(1.500, 1.500, 1.500), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
                        ["laser"] = { type = "Model", model = "models/weapons/upgrades/a_laser_glock19.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(0.298, -7.654, 0.319), angle = Angle(1.453, -84.445, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
                         ["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(0.8, 0.1, -0.6), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = false },

}

SWEP.WElements = {
	["ref"] = { type = "Model", model = SWEP.WorldModel, bone = "oof", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
                        ["mag_ext"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_glock19_33.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-6.765, 2.45, -1.719), angle = Angle(-180, 180, 0), size = Vector(0.779, 0.779, 0.779), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_sil_pistol.mdl", bone = "ATTACH_Muzzle", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["laser"] = { type = "Model", model = "models/weapons/upgrades/w_glock19_laser.mdl", bone = "ATTACH_Laser", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true }

}


SWEP.MuzzleAttachmentSilenced = 3

SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "base_sprint", --Number for act, String/Number for sequence
		["value_empty"] = "empty_sprint",
		["is_idle"] = true
	}
}

SWEP.LaserSightModAttachment = 1
SWEP.MuzzleAttachmentSilenced = 3
SWEP.LaserSightModAttachmentWorld = 3
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true --Shoot shells through blowback animations
SWEP.Blowback_Shell_Effect = "ShellEject"--Which shell effect to use
SWEP.LuaShellEject = true --Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0 --The delay to actually eject things
SWEP.LuaShellEffect = "PistolShellEject" --The effect used for shell ejection; Defaults to that used for blowback

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "am_match", "am_magnum" }, order = 5 },
                        [2] = { offset = { 0, 0 }, atts = { "ins2_ub_laser" }, order = 4 },
                        [5] = { offset = { 0, 0 }, atts = { "ins2_br_supp" }, order = 2 },
                        [3] = { offset = { 0, 0 }, atts = { "ins2_mag_ext_pistol" }, order = 3 },
                        [4] = { offset = { 0, 0 }, atts = { "ins2_glock19_stainless_camo", "ins2_glock19_two_tone_camo" }, order = 6 },
}