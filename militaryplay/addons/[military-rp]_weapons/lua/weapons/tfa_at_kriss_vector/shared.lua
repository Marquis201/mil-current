SWEP.Category				= "Military Play | Оружие"
SWEP.Manufacturer                       = "T.D.I." 
SWEP.Author				= "OLDMaster_24"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.PrintName				= "KRISS Vector"
SWEP.Slot				= 2
SWEP.SlotPos				= 52
SWEP.Type				= "Assault Rifle"
SWEP.DrawAmmo				= true
SWEP.DrawWeaponInfoBox		        = false
SWEP.BounceWeaponIcon   	        = false
SWEP.DrawCrosshair			= true
SWEP.Weight				= 35
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= true
SWEP.HoldType 				= "smg"


SWEP.ViewModelFOV			= 75
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/kriss_vector/v_kriss_vector_45acp.mdl"
SWEP.WorldModel				= "models/weapons/kriss_vector/w_kriss_vector_45acp.mdl"
SWEP.Base				= "tfa_gun_base"
SWEP.VMPos                              = Vector(0, 0, 0)
SWEP.VMPos_Additive                     = false
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.ShowWorldModel			= true
SWEP.UseHands = true

SWEP.Primary.Sound			= Sound("Weapon_kriss_vector.1")
SWEP.Primary.SilencedSound              = Sound("Weapon_kriss_vector.2")
SWEP.Primary.RPM			= 1100
SWEP.Primary.ClipSize			= 25
SWEP.Primary.DefaultClip		= 360
SWEP.Primary.NumShots = 1


SWEP.Primary.KickUp                     = 0.4
SWEP.Primary.KickDown                   = 0.3
SWEP.Primary.KickHorizontal             = 0.2
SWEP.Primary.StaticRecoilFactor         = 0.5

SWEP.IronRecoilMultiplier               = 0.6
SWEP.CrouchAccuracyMultiplier           = 0.5

SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo			= "smg1"
SWEP.MoveSpeed                          = 0.87
SWEP.DisableChambering                  = false
SWEP.IronSightsMoveSpeed                = SWEP.MoveSpeed  * 0.85


SWEP.SelectiveFire		        = true
SWEP.DisableBurstFire                   = true

SWEP.Secondary.IronFOV			= 70	


SWEP.Primary.Damage		        = 38
SWEP.Primary.Spread		        = .025
SWEP.Primary.IronAccuracy               = .005


SWEP.Primary.SpreadMultiplierMax        = 4
SWEP.Primary.SpreadIncrement            = 0.5
SWEP.Primary.SpreadRecovery             = 2

SWEP.Primary.Range                      = 650 * 48
SWEP.Primary.RangeFalloff               = 0.5

--[[EVENT TABLE]]--
SWEP.EventTable = {
	[ACT_VM_DRAW_DEPLOYED] = {
		{time = 23 / 30, type = "sound", value = Sound("Slidebackvector")},
		{time = 34 / 30, type = "sound", value = Sound("Slideforwardvector")},
	},
	[ACT_VM_RELOAD] = {
		{time = 13 / 30, type = "sound", value = Sound("ClipOutvector")},
		{time = 61 / 30, type = "sound", value = Sound("ClipInvector")},
	},
	[ACT_VM_RELOAD_EMPTY] = {
		{time = 13 / 30, type = "sound", value = Sound("ClipOutvector")},
		{time = 75 / 30, type = "sound", value = Sound("ClipInvector")},
		{time = 104 / 30, type = "sound", value = Sound("Slideforwardvector")},
	},
	[ACT_VM_FIREMODE] = {
		{time = 8 / 30, type = "sound", value = Sound("Firevector")},
	},
}

SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-16.869, 33.129, -16.056)
SWEP.CrouchPos = Vector(-1, 0, -1)
SWEP.CrouchAng = Vector(0, 0, -10)
SWEP.InspectPos = Vector(5, -4.619, -2.787)
SWEP.InspectAng = Vector(22.386, 34.417, 5)

SWEP.data = {}
SWEP.data.ironsights = 1
SWEP.Secondary.IronFOV = 70
SWEP.IronSightsPos = Vector(-2.745, -2, 1.1)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.IronSightsPos_1P87 = Vector(-2.745, -2, 0.5)
SWEP.IronSightsAng_1P87 = Vector(0, 0, 0)

SWEP.IronSightsPos_RDS = Vector(-2.745, -2, 0.2)
SWEP.IronSightsAng_RDS = Vector(0.2, 0, 0)

SWEP.IronSightsPos_EOTech = Vector(-2.745, -2, 0.4)
SWEP.IronSightsAng_EOTech = Vector(0.2, 0, 0)

SWEP.IronSightsPos_Kobra = Vector(-2.745, -2, 0.4)
SWEP.IronSightsAng_Kobra = Vector(0.3, 0, 0)

SWEP.IronSightsPos_2XRDS = Vector(-2.74, -2, 0.23)
SWEP.IronSightsAng_2XRDS = Vector(-0.25, 0, 0)
SWEP.Secondary.IronFOV_2XRDS = 55

SWEP.IronSightsPos_C792 = Vector(-2.745, -2, -1.09)
SWEP.IronSightsAng_C792 = Vector(0, 0, 0)

SWEP.IronSightsPos_C79 = Vector(-2.745, -2, 0.1)
SWEP.IronSightsAng_C79 = Vector(-0.27, 0, 0)
SWEP.Secondary.IronFOV_C79 = 55

SWEP.IronSightsPos_PO4X = Vector(-2.66, -2, 0.5)
SWEP.IronSightsAng_PO4X = Vector(0.6, 0, 0)
SWEP.Secondary.IronFOV_PO4X = 55

SWEP.SprintHoldTypeOverride = ""

SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID 
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI 
SWEP.SprintBobMult = 0

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "base_sprint",
                                ["value_empty"] = "base_sprint",
		["is_idle"] = true
	}
}

SWEP.StatusLengthOverride     = {
	["base_reload"]           = 69 / 30,
	["base_reload_empty"]     = 114 / 30,
	["foregrip_reload"]       = 69 / 30,
	["foregrip_reload_empty"] = 114 / 30,
	["gl_reload"]             = 69 / 30,
	["gl_reload_empty"]       = 114 / 30,
	["glsetup_reload"]        = 38 / 30,

} -- Changes the status delay of a given animation; only used on reloads.  Otherwise, use SequenceLengthOverride or one of the others

SWEP.SequenceRateOverride     = {
	["base_reload"]           = 1,
	["base_reloadempty"]      = 1,
	["foregrip_reload"]       = 1,
	["foregrip_reloadempty"]  = 1,
} -- Like above but changes animation length to a target

SWEP.data = {}

SWEP.data.ironsights   = 1    -- Enable Ironsights
SWEP.Secondary.IronFOV = 80   -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.
SWEP.IronSightsReloadEnabled = true
SWEP.IronSightsReloadLock    = false



SWEP.Offset = {
	Pos = {
		Up = 0,
		Right = 1,
		Forward = 3
	},
	Ang = {
		Up = 0,
		Right = -10,
		Forward = 180,
	},
	Scale = 0.9
}

SWEP.Attachments = {
        [1] = { offset = { 0, 0 }, atts = { "ins2_br_supp", "ins2_br_heavy" }, order = 1 },
	[2] = { offset = { 0, 0 }, atts = { "eft_si_1p87", "ins2_si_kobra", "ins2_si_eotech", "ins2_si_rds", "ins2_si_2xrds", "ins2_si_c79", "ins2_si_c792", "ins2_si_po4x" }, order = 2 },
        [4] = { offset = { 0, 0 }, atts = { "am_match", "am_magnum" }, order = 4 },
	[3] = { offset = { 0, 0 }, atts = { "ins2_ub_laser", "ins2_ub_flashlight" }, order = 3 }
}

SWEP.ViewModelBoneMods = {
	["A_Optic"] = { scale = Vector(0.95, 0.95, 0.95), pos = Vector(0, 1.3, 0.05), angle = Angle(180, -180, -180) },
	["A_Suppressor"] = { scale = Vector(0.6, 0.6, 0.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_LaserFlashlight"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0.2, 0.7, -0.02), angle = Angle(0, 0, 90) },
}

SWEP.WorldModelBoneMods = {
	["ATTACH_Muzzle"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(1, 0, 0), angle = Angle(0, 0, 0) },
	["ATTACH_ModKit"] = { scale = Vector(.85, .85, .85), pos = Vector(2, -0.3, 0.4), angle = Angle(0, 0, 0) },
	["ATTACH_Laser"] = { scale =  Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}


SWEP.VElements = {
	["sight_1p87"] = { type = "Model", model = "models/weapons/kriss_vector/upgrades/a_standard_vector.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_kobra_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_kobra") or nil,
	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_eotech_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_eotech_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_eotech") or nil,
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_rds_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_rds") or nil,
	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimp2x.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_sec.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} , bonemerge = true, active = false },
	["scope_c792"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_elcan_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["foregrip"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_foregrip_sec.mdl", bone = "A_Foregrip", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.485, 0.485, 0.485), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["gl"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_gl_m203.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = color_white, surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false},
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_band.mdl", bone = "A_LaserFlashlight", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 180), size = Vector(0.76, 0.76, 0.76), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser", pos = Vector(0, 0.2, 0), angle = Angle(0, 0, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_elcan_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_band.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_po4x24_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
}

SWEP.WElements = {
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_kobra.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_eotech.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_aimpoint.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_elcan.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
        ["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_magaim.mdl", bone = "ATTACH_ModKit", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_c792"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_elcan.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_sil_sec1.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["foregrip"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_foregrip_sec1.mdl", bone = "ATTACH_Foregrip", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["gl"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_m203.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = color_white, surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_elcan.mdl", bone = "ATTACH_ModKit", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_po.mdl", bone = "ATTACH_ModKit", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
}

SWEP.Idle_Mode                          = TFA.Enum.IDLE_BOTH

SWEP.BlowbackEnabled                    = false
SWEP.BlowbackVector                     = Vector(0,-2,0.0)
SWEP.Blowback_Shell_Effect              = "ShellEject"

SWEP.LaserSightModAttachment = 1
SWEP.LaserSightModAttachmentWorld = 4
SWEP.LaserDotISMovement = true

SWEP.LuaShellEject                      = false
SWEP.LuaShellEjectDelay                 = 0
SWEP.LuaShellEffect                     = "ShotgunShellEject"
