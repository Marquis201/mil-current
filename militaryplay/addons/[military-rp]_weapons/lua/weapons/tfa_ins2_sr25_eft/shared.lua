-- Variables that are used on both client and server
SWEP.Gun = ("tfa_ins2_sr25_eft") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Military Play | Оружие" --Category where you will find your weapons
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "shell" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.Manufacturer = "Knight´s Manufactory Co." --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Author				= "The Master MLG"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "SR-25"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 35		-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV			= 72
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_sr25_eft.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_sr25_ins2_eft.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE! 
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.ShowWorldModel			= true
SWEP.UseHands = true
SWEP.Type = "Automatic Sniper Rifle"

SWEP.Primary.Sound			= Sound("weapons/tfa_ins2_sr25_eft/m14_fp.wav")
SWEP.Primary.SilencedSound			= Sound("weapons/tfa_ins2_sr25_eft/m14_suppressed_fp.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 255			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 20		-- Size of a clip
SWEP.Primary.DefaultClip		= 120		-- Bullets you start with
SWEP.Primary.KickUp			= 0.7		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.65		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.47		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false	-- Automatic = true; Semi Auto = false
SWEP.Primary.StaticRecoilFactor = 0.69
SWEP.IronRecoilMultiplier = 0.68
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
SWEP.DisableChambering = false

SWEP.MoveSpeed = 0.76 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed  * 0.85 --Multiply the player's movespeed by this when sighting.
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire		= true
SWEP.DisableBurstFire = true --Only auto/single?

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode

SWEP.Primary.Damage		= 60	-- Base damage per bullet
SWEP.Primary.Spread		= .026	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .001 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-1.81, 0, 0.19)
SWEP.IronSightsAng = Vector(-0.06, 0, 0)
SWEP.IronSightsPos_EOTech = Vector(-1.86, 0, -0.175)
SWEP.IronSightsAng_EOTech = Vector(-0.06, 0, 0)
SWEP.IronSightsPos_RDS = Vector(-1.86, 0, -0.175)
SWEP.IronSightsAng_RDS = Vector(-0.06, 0, 0)
SWEP.IronSightsPos_2XRDS = Vector(-1.848, 0, -0.190)
SWEP.IronSightsAng_2XRDS = Vector(-0.06, 0, 0)
SWEP.IronSightsPos_C79 = Vector(-1.852, -0.8, -0.607)
SWEP.IronSightsAng_C79 = Vector(-0.06, 0, 0)
SWEP.IronSightsPos_Kobra = Vector(-1.853, 0, 0.070)
SWEP.IronSightsAng_Kobra = Vector(-0.06, 0, 0)
SWEP.IronSightsPos_Mosin = Vector(-1.828, 0, 0.395)
SWEP.IronSightsAng_Mosin = Vector(-0.06, 0, 0)
SWEP.IronSightsPos_MX4 = Vector(-1.863, 0.4, 0.26)
SWEP.IronSightsAng_MX4 = Vector(-0.06, 0, 0)
SWEP.RunSightsPos = Vector(4.762, -4.238, -0.717)
SWEP.RunSightsAng = Vector(-6.743, 46.284, 0)
SWEP.InspectPos = Vector(7.76, -2, 0.016)
SWEP.InspectAng = Vector(1, 37.277, 3.2)

SWEP.IronAnimation = {
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_PRIMARYATTACK_1, --Number for act, String/Number for sequence
		["value_last"] = ACT_VM_PRIMARYATTACK_2,
		["value_empty"] = ACT_VM_PRIMARYATTACK_3
	} --What do you think
}

SWEP.Offset = {
	Pos = {
		Up = -1.0,
		Right = 1,
		Forward = 4.295
	},
	Ang = {
		Up = -1.043,
		Right = 0,
		Forward = 180,
	},
	Scale = 1
} --Procedural world model animation, defaulted for CS:S purposes.

SWEP.VElements = {
	["sights_folded"] = { type = "Model", model = "models/weapons/upgrades/v_sr25_sights_eft.mdl", bone = "Weapon", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = true },
        ["foregrip"] = { type = "Model", model = "models/weapons/upgrades/v_sr25_grip.mdl", bone = "Weapon", rel = "", pos = Vector(0, 0, 4), angle = Angle(0, 90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["laser"] = { type = "Model", model = "models/weapons/upgrades/v_sr25_laser.mdl", bone = "Weapon", rel = "", pos = Vector(-0.545, 0.101, -0.1), angle = Angle(0, 0, 90), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "Weapon", rel = "laser", pos = Vector(-1.5, 13, 0.792), angle = Angle(0, -90, -180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
        ["suppressor"] = { type = "Model", model = "models/weapons/upgrades/v_sr25_silencer.mdl", bone = "Weapon", rel = "", pos = Vector(-2.609, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_eotech_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_eotech") or nil,
        ["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_rds_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_rds") or nil,
        ["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["sight_kobra_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_kobra") or nil,
        ["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimp2x.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_elcan.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["scope_mosin"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_mosin.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
        ["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_m40.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.046, -0.132, 1.2), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
}

SWEP.WElements = {
	["ref"] = { type = "Model", model = SWEP.WorldModel, bone = "oof", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
        ["sights_folded"] = { type = "Model", model = "models/weapons/upgrades/w_sr25_sights.mdl", bone = "R Hand", rel = "", pos = Vector(-46.015, 1.534, 19.391), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true, bonemerge = true },
        ["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_kobra.mdl", bone = "ATTACH_Standard", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_eotech.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_aimpoint.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_magaim.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_elcan.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["scope_mosin"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_scope_mosin.mdl", bone = "A_Optic", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
        ["laser"] = { type = "Model", model = "models/weapons/upgrades/w_sr25_laser.mdl", bone = "R Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["suppressor"] = { type = "Model", model = "models/weapons/upgrades/w_sr25_silencer.mdl", bone = "R Hand", rel = "", pos = Vector(1.877, 1.881, -10.833), angle = Angle(0, 0, 180), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["foregrip"] = { type = "Model", model = "models/weapons/upgrades/w_sr25_grip.mdl", bone = "R Hand", rel = "", pos = Vector(14.177, 1.381, -3.233), angle = Angle(0, 0, 180), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
        ["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_scope_m40.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
}

SWEP.ViewModelBoneMods = {
        ["A_Foregrip"] = { scale = Vector(0.5, 0.5, 0.5), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["A_Optic"] = { scale = Vector(1, 1, 1), pos = Vector(0, 2.6, -0.5), angle = Angle(0, 0, 0) }
}

SWEP.WorldModelBoneMods = {
        ["ATTACH_ModKit"] = { scale = Vector(1, 1, 1), pos = Vector(-3.1, 0.2, -0.5), angle = Angle(0, 0, 0) }
}

SWEP.LaserSightModAttachment = 1
SWEP.LaserSightModAttachmentWorld = 4
SWEP.MuzzleAttachmentSilenced = "2"

SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA

SWEP.BlowbackEnabled = false
SWEP.BlowbackVector = Vector(0,-2,0.0)
SWEP.Blowback_Shell_Effect = "ShellEject"

SWEP.LuaShellEject = true

SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "base_sprint", --Number for act, String/Number for sequence
		["is_idle"] = true
	}
}


SWEP.Attachments = {
                        [1] = { offset = { 0, 0 }, atts = { "ins2_br_supp", "ins2_br_heavy" }, order = 2 },
                        [2] = { offset = { 0, 0 }, atts = { "am_match", "am_magnum", "am_gib" }, order = 2 },
                        [3] = { offset = { 0, 0 }, atts = { "ins2_fg_grip" }, order = 3 },
                        [4] = { offset = { 0, 0 }, atts = { "ins2_si_eotech", "ins2_si_rds", "ins2_si_kobra", "ins2_si_2xrds", "ins2_si_c79", "ins2_si_mosin", "ins2_si_mx4" }, order = 2 },
                        [5] = { offset = { 0, 0 }, atts = { "ins2_ub_laser" }, order = 4 }
}