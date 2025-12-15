if CLIENT then
    SWEP.BounceWeaponIcon = false
    SWEP.DrawWeaponInfoBox = false
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/tfa_ins2_wpns_icons/tfa_ins2_wpn_m40a1" )
    killicon.Add( "tfa_ins2_wpn_m40a1", "vgui/tfa_ins2_wpns_icons/tfa_ins2_wpn_m40a1_kill", Color( 255, 255, 255, 255 ) )
end

SWEP.SubCategory 				= "Sniper Rifles"
SWEP.Purpose               		= "Bolt action sniper rifle manufactured in the United States" -- Instructions Tooltip
SWEP.Base                       = "tfa_ins2_base"
SWEP.Category                   = "Military Play | Оружие" -- The category.
SWEP.Manufacturer               = "Remington" -- Gun Manufactrer (e.g. Hoeckler and Koch)
SWEP.Spawnable                  = true -- Can you, as a normal user, spawn this?
SWEP.AdminSpawnable             = false -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair              = true      -- Draw the crosshair?

-- AKA DrawCrosshairIS
SWEP.DrawCrosshairIronSights    = false -- Draw the crosshair in ironsights?
SWEP.PrintName                  = "M40A1"       -- Weapon name (Shown on HUD)
SWEP.Slot                       = 3             -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos                    = 1            -- Position in the slot
SWEP.AutoSwitchTo               = true      -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom             = true      -- Auto switch from if you pick up a better weapon
SWEP.Weight                     = 30            -- This controls how "good" the weapon is for autopickup.
SWEP.Type                       = "Sniper Rifle" -- Weapon type. Autodetected, but in some cases needs to be set manually. PLEASE MAKE SURE THE TYPE IS SET PROPERLY so that autodetection code won't make funky stuff.ers"
SWEP.Type_Displayed             = "Sniper Rifle" -- Weapon type override for displaying in the inspection menu. If you want to add wacky text below the gun name, DO IT HERE AND NOT IN THE ACTUAL TYPE FIELD!
-- Recognized generic types: "Pistol", "Machine Pistol", "Revolver", "Sub-Machine Gun", "Rifle", "Carbine", "Light Machine Gun", "Shotgun", "Designated Marksman Rifle", "Sniper Rifle", "Grenade", "Launcher"; "Dual Pistols", "Dual Revolvers", "Dual Sub-Machine Guns" and "Dual Guns".

----------------- The Most basic weapon stats
SWEP.Primary.RPM 				= 60 / (10 / 30) -- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Displayed 		= 40 -- This is in Rounds Per Minute / RPM
SWEP.Primary.NumShots           = 1 -- The number of shots the weapon fires
SWEP.Primary.HullSize           = 0 -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.
SWEP.Primary.Automatic          = false  -- Automatic/Semi Auto
SWEP.FireModeName               = "BOLT-ACTION"              -- Change to a text value to override it

-- If your gun is bullet based
SWEP.Primary.Damage             = 160 -- Damage, in standard damage points.
SWEP.Primary.Force              = nil -- Force value, leave nil to autocalc

-- AKA FiresUnderwater
SWEP.Primary.FiresUnderwater    = false -- Whenever this weapon can fire underwater

----------------- TFA Base Basic sound handling
SWEP.Primary.Sound                  = Sound("TFA_INS2_M40A1.Fire") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.SilencedSound          = Sound("TFA_INS2_M40A1.Silenced") -- This is the sound of the weapon, when silenced.
SWEP.IronInSound 				    = Sound("TFA_INS2.IronIn")
SWEP.IronOutSound				    = Sound("TFA_INS2.IronOut")
SWEP.FireSoundAffectedByClipSize = true -- Play low ammo and last shot sounds? Controlled by "Enable nearly-empty sounds" server option.

----------------- Silencing
SWEP.CanBeSilenced                = false -- Can we silence?  Requires animations.
SWEP.Silenced                     = false -- Silenced by default?

----------------- Selective Fire Stuff
SWEP.SelectiveFire                	= false -- Allow selecting your firemode?
SWEP.DisableBurstFire             	= false -- Only auto/single?
SWEP.OnlyBurstFire                	= false -- No auto, only burst/single?

----------------- Ammo Related
SWEP.Primary.ClipSize           = 5 -- This is the size of a clip
SWEP.Primary.DefaultClip        = 5 * 4-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo               = "SniperPenetratedRound" -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption    = 1 -- Ammo consumed per shot
SWEP.DisableChambering 			= false

-- Recoil Related
SWEP.Primary.KickUp             = 1.5 -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown           = 1.5 -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal     = 0.2 -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.4-- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

----------------- Spread stats
-- Firing Cone Related
SWEP.Primary.Spread             	= .02 -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.SpreadMultiplierMax 	= 4-- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement     	= 1/.25                        -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery      	= 1.65                       -- How much the spread recovers, per second. Example val: 3
SWEP.Primary.IronAccuracy       	= .0015 -- Ironsight accuracy, should be the same for shotguns
SWEP.CrouchAccuracyMultiplier   	= 0.9

----------------- Recoil related things
SWEP.ViewModelPunchPitchMultiplier               = 0.1 -- Default value is 0.5
SWEP.ViewModelPunchPitchMultiplier_IronSights    = 0 -- Default value is 0.09
SWEP.ViewModelPunch_MaxVertialOffset             = 2.6 -- Default value is 3
SWEP.ViewModelPunch_MaxVertialOffset_IronSights  = 0 -- Default value is 1.95
SWEP.ViewModelPunch_VertialMultiplier            = 1.1 -- Default value is 1
SWEP.ViewModelPunch_VertialMultiplier_IronSights = 0 -- Default value is 0.25
SWEP.ViewModelPunchYawMultiplier                 = 0.4 -- Default value is 0.6
SWEP.ViewModelPunchYawMultiplier_IronSights      = 0 -- Default value is 0.25

SWEP.IronRecoilMultiplier               		= .8 -- Multiply recoil by this factor when we're in ironsights. This is proportional, not inversely.
SWEP.MoveSpeed 									= 0.79
SWEP.IronSightsMoveSpeed 						= SWEP.MoveSpeed  * 0.8
SWEP.IronSightTime 								= 0.5

----------------- ViewModel related
SWEP.ViewModel          = "models/tfa_ins2_wpns/m40a1/v_m40a1.mdl" -- Viewmodel path
SWEP.ViewModelFOV		= 56		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip      = false     -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands           = true -- Use gmod c_arms system.

----------------- Attachments
SWEP.Attachments = {
    [1] = { atts = { "ins2_br_supp" } },
	[2] = { atts = { "ins2_si_eotech", "ins2_si_kobra", "ins2_si_rds", "ins2_si_2xrds", "ins2_si_c79", "ins2_si_po4x","ins2_si_mx4"} },
	[3] = { atts = { "ins2_ub_laser", "ins2_ub_flashlight" } },
	[4] = { atts = { "tfa_ins2_bipod_fake" } },
	[5] = { atts = { "am_match", "am_magnum" } },
	[6] = { atts = { "tfa_ins2_skin_m40a1_desert", "tfa_ins2_skin_m40a1_forest" } },
}

SWEP.ViewModelBoneMods = {
	["L Clavicle"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["R Clavicle"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_Suppressor"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_Optic"] = { scale = Vector(.75, .75, .75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_LaserFlashlight"] = { scale = Vector(.95, .95, .95), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.WorldModelBoneMods = {
	["ATTACH_Muzzle"] = { scale = Vector(0.5, 0.5, 0.5), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ATTACH_Foregrip"] = { scale = Vector(0.5, 0.5, 0.5), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ATTACH_ModKit"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ATTACH_Laser"] = { scale = Vector(1.25, 1.25, 1.25), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
}

SWEP.VElements = {--models/inss_wpns/galilarm/upgrades/a_standard_galil.mdl
	["sights_folded"] = { type = "Model", model = "models/tfa_ins2_wpns/m40a1/upgrades/a_standard_m40.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = true },

	["bipod"] = { type = "Model", model = "models/tfa_ins2_wpns/m40a1/upgrades/a_bipod_m40.mdl", bone = "A_Bipod", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },

    ["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, .3), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },
	["sight_eotech_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_eotech") or nil,
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_kobra_l.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, .5), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_kobra_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_kobra") or nil,
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_rds_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_rds") or nil,

    ["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimp2x.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_elcan.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 1), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },
    ["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_po4x24.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },
    ["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_m40.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },

    ["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_sec.mdl", bone = "a_suppressor", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },

	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_band.mdl", bone = "a_laserflashlight", rel = "", pos = Vector(1.3, 0, 0), angle = Angle(0, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_band.mdl", bone = "a_laserflashlight", rel = "", pos = Vector(1.27, 0, 0), angle = Angle(0, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
}

SWEP.WElements = {
    ["bipod"] = { type = "Model", model = "models/tfa_ins2_wpns/m40a1/upgrades/w_bipod_m40.mdl", bone = "ATTACH_Foregrip", rel = "", pos = Vector(0, 0, 0), angle = Angle(180, 0, -90), size = Vector(.7, .7, .7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },

	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_eotech.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_elcan.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_aimpoint.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_magaim.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_po.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_kobra.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
   	["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_scope_m40.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },

	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_sil_sec1.mdl", bone = "ATTACH_Muzzle", rel = "", pos = Vector(-0, 0, 0), angle = Angle(0, 0, -90), size = Vector(.7, .7, .7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },

    ["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
    ["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
}

SWEP.IronSightsPos_EOTech = Vector(-2.811, -5, 0.384)
SWEP.IronSightsAng_EOTech = Vector(0, 0, 0)

SWEP.IronSightsPos_Kobra = Vector(-2.812, -5, 0.3731)
SWEP.IronSightsAng_Kobra = Vector(0, 0, 0)

SWEP.IronSightsPos_RDS = Vector(-2.811, -5, 0.38)
SWEP.IronSightsAng_RDS = Vector(0, 0, 0)

SWEP.IronSightsPos_2XRDS = Vector(-2.807, -5, 0.3783)
SWEP.IronSightsAng_2XRDS = Vector(0, 0, 0)

SWEP.IronSightsPos_C79 = Vector(-2.81, -5, .067)
SWEP.IronSightsAng_C79 = Vector(0, 0, 0)

SWEP.IronSightsPos_PO4X = Vector(-2.752, -5, 0.478)
SWEP.IronSightsAng_PO4X = Vector(0, 0, 0)

SWEP.IronSightsPos_MX4 = Vector(-2.82, -4, 0.7214)
SWEP.IronSightsAng_MX4 = Vector(0, 0, 0)

SWEP.IronSightsPos = Vector(-2.82, -0, 0.19)
SWEP.IronSightsAng = Vector(0.0, .0, 0)

SWEP.InspectPos = Vector(6.76, 0, 0.8)
SWEP.InspectAng = Vector(12.663, 31.658, 9.848)

SWEP.RTRedrawViewModel_2XRDS = false
SWEP.RTRedrawViewModel_C79 = false
SWEP.RTRedrawViewModel_PO4X = false
SWEP.RTRedrawViewModel_MX4 = false

----------------- Iron sights related
SWEP.Secondary.IronSightsEnabled    = true
SWEP.Secondary.IronFOV             	= 80
SWEP.Secondary.ViewModelFOV         = SWEP.ViewModelFOV - math.Round(SWEP.ViewModelFOV / 15) -- Defaults to 65. Target viewmodel FOV when aiming down the sights.

----------------- Worldmodel related
SWEP.WorldModel                 = "models/tfa_ins2_wpns/m40a1/w_m40.mdl" -- Weapon world model path
SWEP.Offset = {
	Pos = {
		Up = -1.4,
		Right = 1.2,
		Forward = 4.7
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 180
	},
	Scale = .9
}

SWEP.HoldType                   = "ar2"
SWEP.IronSightHoldTypeOverride  = "rpg" -- ADS
SWEP.SprintHoldTypeOverride     = "passive" -- Sprinting, holster and safety/passive hold
SWEP.ReloadHoldTypeOverride     = "slam" -- Reloading
SWEP.CrouchHoldTypeOverride     = "ar2" -- Crouching

----------------- Scopes related
SWEP.IronSightsSensitivity 	= 1 -- Useful for a RT scope.  Change this to 0.25 for 25% sensitivity.  This is if normal FOV compenstaion isn't your thing for whatever reason, so don't change it for normal scopes.
SWEP.BoltAction 			= false -- Unscope/sight after you shoot?
SWEP.Scoped 				= false -- Draw a scope overlay?

----------------- Animation stuff / procedural ones (Lua animated)
SWEP.Shotgun 				= true --Enable shotgun style reloading.
SWEP.ShotgunEmptyAnim 		= false --Enable insertion of a shell directly into the chamber on empty reload?
SWEP.ShellTime 				= 1 -- For shotguns, how long it takes to insert a shell.

SWEP.Sights_Mode 			= TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Sprint_Mode 			= TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintBobMult 			= 0
SWEP.Idle_Mode 				= TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend 			= 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth 			= 0.05 --Start an idle this far early into the end of another animation

SWEP.StatusLengthOverride = {
    ["base_reload_insert"] = 15 / 32
}

SWEP.SprintAnimation = {
    ["loop"] = {
        ["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
        ["value"] = "base_sprint",
        ["is_idle"] = true
    }
}

SWEP.PumpAction = {
	["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
	["value"] = ACT_SHOTGUN_PUMP, --Number for act, String/Number for sequence
	["value_is"] = ACT_VM_PULLBACK
}

SWEP.IronAnimation = {
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_ACT,
		["value"] = ACT_VM_PRIMARYATTACK_1,
		["value_last"] = ACT_VM_PRIMARYATTACK_2,
		["value_empty"] = ACT_VM_PRIMARYATTACK_3
	}
}

SWEP.EventTable = {
	[ACT_SHOTGUN_PUMP] = {
		{ ["time"] = 15 / 30, ["type"] = "lua", ["value"] = function(wep, vm)
			wep:EventShell()
		end, ["client"] = true, ["server"] = true }
	},
	[ACT_VM_PULLBACK] = {
		{ ["time"] = 17 / 28.5, ["type"] = "lua", ["value"] = function(wep, vm)
			wep:EventShell()
		end, ["client"] = true, ["server"] = true }
	},
	[ACT_SHOTGUN_RELOAD_START] = {
		{ ["time"] = 13 / 30, ["type"] = "lua", ["value"] = function(wep, vm)
			wep:EventShell()
		end, ["client"] = true, ["server"] = true }
	}
}

SWEP.MuzzleAttachment           = "muzzle" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment            = "shell" -- Should be "2" for CSS models or "shell" for hl2 models
SWEP.MuzzleFlashEnabled         = true -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw        = nil -- This will override whatever string you gave. This is the raw attachment NUMBER. This is overridden or created when a gun makes a muzzle event.
SWEP.AutoDetectMuzzleAttachment = false -- For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect          = "tfa_muzzleflash_sniper" -- Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.SmokeParticle              = nil -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled       = false -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject      = false -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0 -- The delay to actually eject things
SWEP.LuaShellEffect 	= "RifleShellEject" --The effect used for shell ejection; Defaults to that used for blowback
SWEP.LuaShellModel      = "models/tfa/rifleshell.mdl" -- The model to use for ejected shells
SWEP.LuaShellScale      = 0.5 -- The model scale to use for ejected shells
SWEP.LuaShellYaw        = nil -- The model yaw rotation ( relative ) to use for ejected shells

SWEP.TracerCount        			= 1     -- 0 disables, otherwise, 1 in X chance
SWEP.LaserSightModAttachment      	= 1
SWEP.LaserSightModAttachmentWorld 	= 1
SWEP.LaserDotISMovement           	= true

DEFINE_BASECLASS(SWEP.Base)