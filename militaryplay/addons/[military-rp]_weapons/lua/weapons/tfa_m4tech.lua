-- Variables that are used on both client and server
SWEP.Gun = ("tfa_m4tech") -- must be the name of your swep but NO CAPITALS!
SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-2.4,0.06) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "RifleShellEject"-- or ShellEject for a SMG    

SWEP.Category				= "Military Play | Оружие"
SWEP.Author				= "Dorian15"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "M4 Tech"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.SelectiveFire		= true
SWEP.CanBeSilenced		= false
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_rif_m4tech.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.MuzzleAttachment           = "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment            = "2" -- Should be "2" for CSS models or "shell" for hl2 models
SWEP.MuzzleFlashEnabled         = true -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw        = nil -- This will override whatever string you gave. This is the raw attachment NUMBER. This is overridden or created when a gun makes a muzzle event.
SWEP.AutoDetectMuzzleAttachment = false -- For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect          = "tfa_muzzleflash_rifle" -- Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.SmokeParticle              = nil -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled       = true -- Disable automatic ejection smoke



SWEP.Base				= "tfa_csgo23_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("M4Tech.Fire")		-- Script that calls the primary fire sound
SWEP.Primary.SilencedSound 	= Sound("M4Tech.FireS")			-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 720			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 30 * 4		-- Bullets you start with
SWEP.Primary.KickUp				= 0.1		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.2		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.1		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.FireModes = {
	"Auto",
	"3Burst",
	"Single"
}
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 32	-- Base damage per bullet
SWEP.Primary.Spread		= .025	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-2.839, -0.831, 0.619)
SWEP.IronSightsAng = Vector(0, 0.215, 0)

SWEP.IronSightsPos_Holo = Vector(-2.8, -2.136, 0.535)
SWEP.IronSightsAng_Holo = Vector(-3.912, 0.215, 0)
SWEP.Blowback_Holo = Vector(0,-1,0)

SWEP.IronSightsPos_EOTech = Vector(-2.865, -2.136, -0.12)
SWEP.IronSightsAng_EOTech = Vector(0, 0, 0)

SWEP.IronSightsPos_Kobra = Vector(-2.865, -2.136, -0.6)
SWEP.IronSightsAng_Kobra = Vector(1, 0, 0)

SWEP.IronSightsPos_RDS = Vector(-2.865, -2.136, -0.36)
SWEP.IronSightsAng_RDS = Vector(0, 0, 0)

SWEP.IronSightsPos_2XRDS = Vector(-2.865, -2.85, -0.37)
SWEP.IronSightsAng_2XRDS = Vector(0, 0, 0)
SWEP.Secondary.IronFOV_2XRDS = 43

SWEP.IronSightsPos_C79 = Vector(-2.865, -3, -0.72)
SWEP.IronSightsAng_C79 = Vector(0, 0, 0)
SWEP.Secondary.IronFOV_C79 = 43


SWEP.IronSightsPos_PO4X = Vector(-2.802, -2.7, -0.255)
SWEP.IronSightsAng_PO4X = Vector(0, 0, 0)
SWEP.Secondary.IronFOV_PO4X = 39



	--Clavus's Swep Construction Kit to get these vectors
SWEP.RunSightsPos = Vector(3.16, -2.04, -3.28)	--These are for the angles your viewmodel will be when running
SWEP.RunSightsAng = Vector(-14.301, 46.4, -34.201)	
SWEP.InspectPos = Vector(8.755, -0.971, -3.614)
SWEP.InspectAng = Vector(22.11, 52.541, 10.309)


SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/world/w_rif_m4tech.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(-6.393, -1.706, 180), size = Vector(1.039, 1.039, 1.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.VElements = {
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_sec.mdl", bone = "grip", rel = "", pos = Vector(-22.137, -3.991, -0.01), angle = Angle(180, 0, 0), size = Vector(0.517, 0.517, 0.517), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {},active = false },

	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_rail.mdl", bone = "grip", rel = "", pos = Vector(-11.596, -4.027, 1.062), angle = Angle(178.83, 0, 0), size = Vector(0.811, 0.811, 0.811), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "grip", rel = "", pos = Vector(-10.907, -4.042, 1.991), angle = Angle(180, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },

	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_eotech_m.mdl", bone = "grip", rel = "", pos = Vector(-3.3, -5.316, 0.009), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["sight_eotech_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_eotech") or nil,
	
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl", bone = "grip", rel = "", pos = Vector(-5, -5.502, 0.009), angle = Angle(-180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {},active = false },
	["sight_kobra_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_kobra") or nil,

	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint_m.mdl", bone = "grip", rel = "", pos = Vector(-5.211, -5.559, 0.009), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["sight_rds_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_rds") or nil,

	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimp2x_m.mdl", bone = "grip", rel = "", pos = Vector(-5.211, -5.559, 0.009), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_elcan_m.mdl", bone = "grip", rel = "", pos = Vector(-5.841, -5.559, 0.009), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },

	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_po4x24_m.mdl", bone = "grip", rel = "", pos = Vector(-5.2, -5.559, 0.009), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },

	["sight_holo1"] = { type = "Model", model = "models/weapons/v_rif_m4tech_sight.mdl", bone = "grip", rel = "", pos = Vector(7.653, -6.237, 2.880), angle = Angle(90, 180, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {},  active = false },
	["sight_holo_lens"] = { type = "Sprite", sprite = "models/weapons/tfa_ins2/optics/aimpoint_reticule", bone = "grip", rel = "", pos = Vector(-6, -6.753, 0.034), size = { x = 10, y = 12 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false, active = false}

}


SWEP.Attachments = {
	[1] = { atts = { "ins2_br_supp","ins2_br_heavy"} },
    [2] = { atts = { "codol_holo","ins2_si_eotech","ins2_si_kobra","ins2_si_rds","ins2_si_2xrds","ins2_si_c79","ins2_si_po4x"} },
	[3] = { atts = { "ins2_ub_laser"} },
	[4] = { atts = { "am_match","am_gib","am_magnum"} },
	[5] = { atts = { "m4_camo1","m4_camo2","m4_camo3","m4_camo4","m4_camo5","m4_camo6","m4_camo7","m4_camo8","m4_camo9","m4_camo10","m4_camo11","m4_camo12","m4_camo13","m4_camo14","m4_camo15","m4_camo16","m4_camo17","m4_camo18","m4_camo19","m4_camo20","m4_camo21","m4_camo22","m4_camo23","m4_camo24","m4_camo25"} },
}




SWEP.UseHands = true

SWEP.Sights_Mode                = TFA.Enum.LOCOMOTION_LUA

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 90, type = "sound", value = Sound("M4Tech.Draw")}
	},
	[ACT_VM_RELOAD] = {
		{time = 19 / 25, type = "sound", value = Sound("M4Tech.ClipOut")},
		{time = 41 / 25, type = "sound", value = Sound("M4tech.ClipIn")},
		{time = 48 / 25, type = "sound", value = Sound("M4Tech.ClipOn")}
	},
	
}

if GetConVar("sv_tfa_default_clip") == nil then
	print("sv_tfa_default_clip is missing!  You might've hit the lua limit.  Contact the SWEP author(s).")
else
	if GetConVar("sv_tfa_default_clip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("sv_tfa_default_clip"):GetInt()
	end
end

if GetConVar("sv_tfa_unique_slots") != nil then
	if not (GetConVar("sv_tfa_unique_slots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end