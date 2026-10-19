if CLIENT then
    SWEP.BounceWeaponIcon = false
    SWEP.DrawWeaponInfoBox = false
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/tfa_ins2_wpns_icons/tfa_Ins2_wpn_rpkalash" )
    killicon.Add( "tfa_Ins2_wpn_rpkalash", "vgui/tfa_ins2_wpns_icons/tfa_Ins2_wpn_rpkalash_kill", Color( 255, 255, 255, 255 ) )
end


SWEP.Purpose 					= "Light drum-fed machine gun manufactured in the Soviet Union"
SWEP.Base                       = "tfa_ins2_base"
SWEP.Category                   = "Military Play | Оружие" -- The category.
SWEP.Manufacturer               = "Izhmash" -- Gun Manufactrer (e.g. Hoeckler and Koch)
SWEP.Spawnable                  = true -- Can you, as a normal user, spawn this?
SWEP.AdminSpawnable             = false -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair              = true      -- Draw the crosshair?

-- AKA DrawCrosshairIS
SWEP.DrawCrosshairIronSights    = false -- Draw the crosshair in ironsights?
SWEP.PrintName                  = "RPK"       -- Weapon name (Shown on HUD)
SWEP.Slot                       = 3             -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos                    = 1            -- Position in the slot
SWEP.AutoSwitchTo               = true      -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom             = true      -- Auto switch from if you pick up a better weapon
SWEP.Weight                     = 30            -- This controls how "good" the weapon is for autopickup.
SWEP.Type                       = "Light Machine Gun" -- Weapon type. Autodetected, but in some cases needs to be set manually. PLEASE MAKE SURE THE TYPE IS SET PROPERLY so that autodetection code won't make funky stuff.ers"
SWEP.Type_Displayed             = "Light Machine Gun" -- Weapon type override for displaying in the inspection menu. If you want to add wacky text below the gun name, DO IT HERE AND NOT IN THE ACTUAL TYPE FIELD!
-- Recognized generic types: "Pistol", "Machine Pistol", "Revolver", "Sub-Machine Gun", "Rifle", "Carbine", "Light Machine Gun", "Shotgun", "Designated Marksman Rifle", "Sniper Rifle", "Grenade", "Launcher"; "Dual Pistols", "Dual Revolvers", "Dual Sub-Machine Guns" and "Dual Guns".

----------------- The Most basic weapon stats
SWEP.Primary.RPM                = 600  -- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Semi           = 600 / 1.25 -- RPM for semi-automatic or burst fire.  This is in Rounds Per Minute / RPM
SWEP.Primary.NumShots           = 1 -- The number of shots the weapon fires
SWEP.Primary.HullSize           = 0 -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.
SWEP.Primary.Automatic          = true -- Automatic/Semi Auto

-- If your gun is bullet based
SWEP.Primary.Damage             = 46 -- Damage, in standard damage points.
SWEP.Primary.Force              = nil -- Force value, leave nil to autocalc

-- AKA FiresUnderwater
SWEP.Primary.FiresUnderwater    = false -- Whenever this weapon can fire underwater

----------------- TFA Base Basic sound handling
SWEP.Primary.Sound                  = Sound("TFA_INS2_RPKALASH.Fire") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.SilencedSound          = Sound("TFA_INS2_RPKALASH.Silenced") -- This is the sound of the weapon, when silenced.
SWEP.IronInSound 				    = Sound("TFA_INS2.IronIn")
SWEP.IronOutSound				    = Sound("TFA_INS2.IronOut")

-- LOW AMMO
SWEP.FireSoundAffectedByClipSize = true -- Play low ammo and last shot sounds? Controlled by "Enable nearly-empty sounds" server option.

----------------- Silencing
SWEP.CanBeSilenced                = false -- Can we silence?  Requires animations.
SWEP.Silenced                     = false -- Silenced by default?

----------------- Selective Fire Stuff
SWEP.SelectiveFire                	= true -- Allow selecting your firemode?
SWEP.DefaultFireMode 				= "Automatic" --Default to auto or whatev
SWEP.DisableBurstFire             	= true   -- Only auto/single?
SWEP.OnlyBurstFire                	= false -- No auto, only burst/single?

----------------- Ammo Related
SWEP.Primary.ClipSize           = 75 -- This is the size of a clip
SWEP.Primary.DefaultClip        = 75 * 2-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo               = "ar2" -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption    = 1 -- Ammo consumed per shot
SWEP.DisableChambering  		= false -- Disable round-in-the-chamber

SWEP.Primary.KickUp 			= 0.4
SWEP.Primary.KickDown 			= 0.2
SWEP.Primary.KickHorizontal 	= 0.2
SWEP.Primary.StaticRecoilFactor = 0.4-- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

----------------- Spread stats
-- Firing Cone Related
SWEP.Primary.Spread             	= .024 -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.SpreadMultiplierMax 	= 3.7-- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement     	= 1/3.2                        -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery      	= 3                       -- How much the spread recovers, per second. Example val: 3
SWEP.Primary.IronAccuracy       	= .001 -- Ironsight accuracy, should be the same for shotguns
SWEP.CrouchAccuracyMultiplier   	= 0.9

----------------- Recoil related things
SWEP.ViewModelPunchPitchMultiplier               = 0.5 -- Default value is 0.5
SWEP.ViewModelPunchPitchMultiplier_IronSights    = 0 -- Default value is 0.09
SWEP.ViewModelPunch_MaxVertialOffset             = 2.6 -- Default value is 3
SWEP.ViewModelPunch_MaxVertialOffset_IronSights  = 0 -- Default value is 1.95
SWEP.ViewModelPunch_VertialMultiplier            = 1.1 -- Default value is 1
SWEP.ViewModelPunch_VertialMultiplier_IronSights = 0 -- Default value is 0.25
SWEP.ViewModelPunchYawMultiplier                 = 0.4 -- Default value is 0.6
SWEP.ViewModelPunchYawMultiplier_IronSights      = 0 -- Default value is 0.25

SWEP.IronRecoilMultiplier               		= .8 -- Multiply recoil by this factor when we're in ironsights. This is proportional, not inversely.
SWEP.MoveSpeed 									= 0.78
SWEP.IronSightsMoveSpeed 						= SWEP.MoveSpeed  * 0.8
SWEP.IronSightTime 								= 0.55

----------------- ViewModel related
SWEP.ViewModel          = "models/tfa_ins2_wpns/rpkalash/v_rpk.mdl" -- Viewmodel path
SWEP.ViewModelFOV		= 56		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip      = false     -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands           = true -- Use gmod c_arms system.

----------------- Attachments
SWEP.Attachments = {
	[1] = { atts = { "ins2_si_kobra", "ins2_si_2xrds", "ins2_si_po4x"} },
	[2] = { atts = { "ins2_ub_laser", "ins2_ub_flashlight" } },
	[3] = { atts = { "am_match", "am_magnum" } },
	[4] = { atts = { "tfa_ins2_skin_rpk_desert", "tfa_ins2_skin_rpk_tac" } }
}

SWEP.ViewModelBoneMods = {
	["L Clavicle"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["R Clavicle"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["a_laserflashlight"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["L Finger0"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_Optic"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_Modkit"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.WorldModelBoneMods = {
	["ATTACH_ModKit"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ATTACH_Laser"] = { scale = Vector(.95, .95, .95), pos = Vector(4, -0.45, .25), angle = Angle(0, 0, -90) },
}

SWEP.VElements = {--models/inss_wpns/galilarm/upgrades/a_standard_galil.mdl
	["rail_sights"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_modkit_06.mdl", bone = "A_Modkit", rel = "", pos = Vector(0, 0, .3), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, .5), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_kobra_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_kobra") or nil,

    ["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimp2x.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
   	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_po4x24_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },

	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_band.mdl", bone = "a_laserflashlight", rel = "", pos = Vector(1.3, 0, 0), angle = Angle(0, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_band.mdl", bone = "a_laserflashlight", rel = "", pos = Vector(1.27, 0, 0), angle = Angle(0, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
}

SWEP.WElements = {
    ["rail_sights"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_modkit_6.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, .3), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true  },
	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_magaim.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_po.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_kobra.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },

    ["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
    ["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
}

SWEP.IronSightsPos_Kobra = Vector(-2.31, -2, -.25)
SWEP.IronSightsAng_Kobra = Vector(0, 0, 0)

SWEP.IronSightsPos_2XRDS = Vector(-2.31, -1, -.433)
SWEP.IronSightsAng_2XRDS = Vector(0, 0, 0)

SWEP.IronSightsPos_PO4X = Vector(-2.262, -1, -.18)
SWEP.IronSightsAng_PO4X = Vector(0, 0, 0)

SWEP.IronSightsPos = Vector(-2.304, -1, 0.159)
SWEP.IronSightsAng = Vector(0.87, 0.02, 0)

SWEP.InspectPos = Vector(6.119, -0.805, 1.32)
SWEP.InspectAng = Vector(4.925, 32.361, 10.553)

SWEP.RTRedrawViewModel_2XRDS = false
SWEP.RTRedrawViewModel_PO4X = false

----------------- Iron sights related
SWEP.Secondary.IronSightsEnabled    = true
SWEP.Secondary.IronFOV             	= 80
SWEP.Secondary.ViewModelFOV         = SWEP.ViewModelFOV - math.Round(SWEP.ViewModelFOV / 15) -- Defaults to 65. Target viewmodel FOV when aiming down the sights.

----------------- Worldmodel related
SWEP.WorldModel                 = "models/tfa_ins2_wpns/rpkalash/w_rpk.mdl" -- Weapon world model path
SWEP.Offset = {
	Pos = {
		Up = -1,
		Right = 1,
		Forward = 4.1
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
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
SWEP.Sights_Mode 			= TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Sprint_Mode 			= TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintBobMult 			= 0
SWEP.Idle_Mode 				= TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend 			= 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth 			= 0.05 --Start an idle this far early into the end of another animation

SWEP.StatusLengthOverride = {
    ["base_reload"] 			= 103 / 30,
    ["base_reloadempty"] 		= 103 / 30,
	["deployed_reload"] 		= 118 / 30,
	["deployed_reloadempty"] 	= 118 / 30,
}

SWEP.SprintAnimation = {
    ["loop"] = {
        ["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
        ["value"] = "base_sprint",
        ["is_idle"] = true
    }
}

SWEP.IronAnimation = {
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_ACT,                    -- Sequence or act
		["value"] = ACT_VM_PRIMARYATTACK_1,
		["value_empty"] = ACT_VM_PRIMARYATTACK_3
	}
}

-- Attachments
SWEP.MuzzleAttachment           = "muzzle" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment            = "shell" -- Should be "2" for CSS models or "shell" for hl2 models
SWEP.MuzzleFlashEnabled         = true -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw        = nil -- This will override whatever string you gave. This is the raw attachment NUMBER. This is overridden or created when a gun makes a muzzle event.
SWEP.AutoDetectMuzzleAttachment = false -- For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect          = "tfa_muzzleflash_rifle" -- Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.SmokeParticle              = nil -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled       = false -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject      = true -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0 -- The delay to actually eject things
SWEP.LuaShellEffect 	= "RifleShellEject" --The effect used for shell ejection; Defaults to that used for blowback
local path 				= "models/tfa_ins2_wpns/shells/"
SWEP.LuaShellModel 		= path .. "rifleshell.mdl"
SWEP.LuaShellScale      = 0.55 -- The model scale to use for ejected shells
SWEP.LuaShellYaw        = nil -- The model yaw rotation ( relative ) to use for ejected shells

SWEP.TracerCount        = 1     -- 0 disables, otherwise, 1 in X chance
SWEP.LaserSightModAttachment      = 1
SWEP.LaserSightModAttachmentWorld = 1
SWEP.LaserDotISMovement           = true

DEFINE_BASECLASS(SWEP.Base)

SWEP.Bipod = 0
SWEP.BipodTimer = CurTime()
SWEP.OldY = 0

function SWEP:SetNextCurTime(t)
	self:SetNextPrimaryFire(CurTime() + t)
	self:SetStatusEnd(CurTime() + t)
	self:SetNextIdleAnim(CurTime() + t)
	self.BipodTimer = CurTime() + t
end

function SWEP:IsPlayingAnim()
	if self:GetNextPrimaryFire() <= CurTime() and self:GetStatusEnd() <= CurTime() and self.BipodTimer <= CurTime() then
		return true
	end
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self.StatCache_Blacklist["Primary.KickUp"] = true
	self.StatCache_Blacklist["Primary.KickDown"] = true
	self.StatCache_Blacklist["Primary.KickHorizontal"] = true
	self.StatCache_Blacklist["MoveSpeed"] = true
	self.StatCache_Blacklist["IronSightsMoveSpeed"] = true
	self.StatCache_Blacklist["Primary.StaticRecoilFactor"] = true
	self:ClearStatCache()
end

function SWEP:ToBipod(ply)
	if ply.IsProne != nil then
		if ply:IsProne() and ply:OnGround() and ply:GetVelocity():Length() <= 25 then
			return true
		end
	elseif ply.IsProne == nil then
		if ply:Crouching() and ply:OnGround() and ply:GetVelocity():Length() <= 25 then
			return true
		end
	end
	return false
end

function SWEP:Think2(...)
	if self.Owner:IsPlayer() then
		if self.Owner:KeyPressed(IN_WALK) and self:IsPlayingAnim() == true then
			if self.Bipod == 0 and self:ToBipod(self.Owner) then
				self:SendViewModelAnim(ACT_VM_DEPLOYED_IN)
				self.Bipod = 1
				self:SetNextCurTime(44/30)
			elseif self.Bipod == 1 and self:ToBipod(self.Owner) then
				self:SendViewModelAnim(ACT_VM_DEPLOYED_OUT)
				self.Bipod = 0
				self:SetNextCurTime(55/30)
			end
		end
		if !self:ToBipod(self.Owner) and self.Bipod == 1 and self:IsPlayingAnim() == true then
			self:SendViewModelAnim(ACT_VM_DEPLOYED_OUT)
			self.Bipod = 0
			self:SetNextCurTime(55/30)
		end
		if self.Bipod == 1 then
			if self.Owner:EyeAngles().x > 10 then
				self.Owner:SetEyeAngles(Angle(10, self.Owner:EyeAngles().y, self.Owner:EyeAngles().roll))
			end
			if self.Owner:EyeAngles().x < -10 then
				self.Owner:SetEyeAngles(Angle(-10, self.Owner:EyeAngles().y, self.Owner:EyeAngles().roll))
			end
			self.Primary_TFA.KickUp	= 0.4 / 2.45
			self.Primary_TFA.KickDown = 0.2 / 2.45
			self.Primary_TFA.KickHorizontal	= 0.2 / 2.45
			self.Primary_TFA.StaticRecoilFactor = 0.8
			self.MoveSpeed = 0.0000000001
			self.IronSightsMoveSpeed = 0.0000000001
		else
			self.OldY = self.Owner:EyeAngles().y
			self.Primary_TFA.KickUp = 0.4
			self.Primary_TFA.KickDown = 0.2
			self.Primary_TFA.KickHorizontal = 0.2
			self.Primary_TFA.StaticRecoilFactor = 0.4
			self.MoveSpeed = 0.78
			self.IronSightsMoveSpeed = 0.64
		end
	end
	BaseClass.Think2(self,...)
end

function SWEP:ChooseShootAnim()
	self:EventShell()
	if self.Bipod == 1 then
		if self:GetIronSights() then
			return self:SendViewModelAnim(ACT_VM_PRIMARYATTACK_DEPLOYED_1)
		else
			return self:SendViewModelAnim(ACT_VM_PRIMARYATTACK_DEPLOYED)
		end
	elseif self:GetIronSights() then
		return self:SendViewModelAnim(ACT_VM_PRIMARYATTACK_1)
	else
		return self:SendViewModelAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:ChooseIdleAnim(...)
	if self.Bipod == 1 then
		return self:SendViewModelAnim(ACT_VM_IDLE_DEPLOYED)
	else
		return BaseClass.ChooseIdleAnim(self,...)
	end
end

function SWEP:ChooseDryFireAnim(...)
	if self.Bipod == 1 then
		if self:GetIronSights() then
			return self:SendViewModelAnim(ACT_VM_PRIMARYATTACK_DEPLOYED_3)
		else
			return self:SendViewModelAnim(ACT_VM_DEPLOYED_DRYFIRE)
		end
	elseif self:GetIronSights() then
		return self:SendViewModelAnim(ACT_VM_PRIMARYATTACK_3)
	else
		return self:SendViewModelAnim(ACT_VM_DRYFIRE)
	end
end

function SWEP:ChooseROFAnim(...)
	if self.Bipod == 1 then
		if self:GetIronSights() then
			return self:SendViewModelAnim(ACT_VM_DEPLOYED_IRON_FIRE)
		else
			return self:SendViewModelAnim(ACT_VM_DEPLOYED_FIRE)
		end
	elseif self:GetIronSights() then
		return self:SendViewModelAnim(ACT_VM_IFIREMODE)
	else
		return self:SendViewModelAnim(ACT_VM_FIREMODE)
	end
end

function SWEP:ChooseReloadAnim(...)
	if self.Bipod == 1 then
		if self:Clip1() > 0 then
			return self:SendViewModelAnim(ACT_VM_RELOAD_DEPLOYED)
		else
			return self:SendViewModelAnim(ACT_VM_DEPLOYED_RELOAD_EMPTY)
		end
	else
		return BaseClass.ChooseReloadAnim(self,...)
	end
end
