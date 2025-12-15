if CLIENT then
    SWEP.BounceWeaponIcon = false
    SWEP.DrawWeaponInfoBox = false
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/tfa_ins2_wpns_icons/tfa_ins2_wpn_38revolver" )
    killicon.Add( "tfa_ins2_wpn_38revolver", "vgui/tfa_ins2_wpns_icons/tfa_ins2_wpn_38revolver_kill", Color( 255, 255, 255, 255 ) )
end

SWEP.SubCategory 				= "Sidearms"
SWEP.Purpose 					= "Antique .38 revolver manufactured in the United States"
SWEP.Base                       = "tfa_ins2_base"
SWEP.Category                   = "Military Play | Оружие" -- The category.
SWEP.Manufacturer               = "Smith & Wesson" -- Gun Manufactrer (e.g. Hoeckler and Koch)
SWEP.Spawnable                  = true -- Can you, as a normal user, spawn this?
SWEP.AdminSpawnable             = false -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair              = true      -- Draw the crosshair?

-- AKA DrawCrosshairIS
SWEP.DrawCrosshairIronSights    = false -- Draw the crosshair in ironsights?
SWEP.PrintName                  = "Model 10"       -- Weapon name (Shown on HUD)
SWEP.Slot                       = 1             -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos                    = 1            -- Position in the slot
SWEP.AutoSwitchTo               = true      -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom             = true      -- Auto switch from if you pick up a better weapon
SWEP.Weight                     = 30            -- This controls how "good" the weapon is for autopickup.
SWEP.Type                       = "Revolver" -- Weapon type. Autodetected, but in some cases needs to be set manually. PLEASE MAKE SURE THE TYPE IS SET PROPERLY so that autodetection code won't make funky stuff.ers"
SWEP.Type_Displayed             = "Revolver" -- Weapon type override for displaying in the inspection menu. If you want to add wacky text below the gun name, DO IT HERE AND NOT IN THE ACTUAL TYPE FIELD!
-- Recognized generic types: "Pistol", "Machine Pistol", "Revolver", "Sub-Machine Gun", "Rifle", "Carbine", "Light Machine Gun", "Shotgun", "Designated Marksman Rifle", "Sniper Rifle", "Grenade", "Launcher"; "Dual Pistols", "Dual Revolvers", "Dual Sub-Machine Guns" and "Dual Guns".

----------------- The Most basic weapon stats
SWEP.Primary.RPM                = 300 -- This is in Rounds Per Minute / RPM
SWEP.Primary.NumShots           = 1 -- The number of shots the weapon fires
SWEP.Primary.HullSize           = 0 -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.
SWEP.Primary.Automatic          = false  -- Automatic/Semi Auto

-- If your gun is bullet based
SWEP.Primary.Damage             = 48 -- Damage, in standard damage points.
SWEP.Primary.Force              = nil -- Force value, leave nil to autocalc

-- AKA FiresUnderwater
SWEP.Primary.FiresUnderwater    = false -- Whenever this weapon can fire underwater

----------------- TFA Base Basic sound handling
SWEP.Primary.Sound                  = Sound("TFA_INS2_38REVOLVER.Fire") -- This is the sound of the weapon, when you shoot.
SWEP.IronInSound 				    = Sound("TFA_INS2.IronIn")
SWEP.IronOutSound				    = Sound("TFA_INS2.IronOut")

-- LOW AMMO
SWEP.FireSoundAffectedByClipSize = true -- Play low ammo and last shot sounds? Controlled by "Enable nearly-empty sounds" server option.

----------------- Silencing
SWEP.CanBeSilenced              = false -- Can we silence?  Requires animations.
SWEP.Silenced                   = false -- Silenced by default?

----------------- Selective Fire Stuff
SWEP.SelectiveFire              = false  -- Allow selecting your firemode?

----------------- Ammo Related
SWEP.Primary.ClipSize           = 6 -- This is the size of a clip
SWEP.Primary.DefaultClip        = 6 * 5-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo               = "357" -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption    = 1 -- Ammo consumed per shot
SWEP.DisableChambering  		= true -- Disable round-in-the-chamber

-- Recoil Related
SWEP.Primary.KickUp             = 1.5 -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown           = 1.3 -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal     = 0.5 -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.7-- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

----------------- Spread stats
SWEP.Primary.Spread             	= .025 -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.SpreadMultiplierMax 	= 3.5-- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement     	= 1/2                        -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery      	= 2.8                        -- How much the spread recovers, per second. Example val: 3
SWEP.Primary.IronAccuracy       	= .01 -- Ironsight accuracy, should be the same for shotguns
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
SWEP.MoveSpeed 									= 0.96
SWEP.IronSightsMoveSpeed 						= SWEP.MoveSpeed  * 0.8
SWEP.IronSightTime 								= 0.35

----------------- ViewModel related
SWEP.ViewModel          = "models/tfa_ins2_wpns/38revolver/v_38rev.mdl" -- Viewmodel path
SWEP.ViewModelFOV		= 56		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip      = false     -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands           = true -- Use gmod c_arms system.

----------------- Attachments
SWEP.Attachments = {
	[2] = { atts = { "am_match", "am_magnum", "am_gib" } },
	[4] = { atts = { "ins2_mag_speedloader" } },
}

SWEP.ViewModelBoneMods = {
	["L Clavicle"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["R Clavicle"] = { scale = Vector(0.75, 0.75, 0.75), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.VElements = {
	["mag"] = { type = "Model", model = "models/tfa_ins2_wpns/38revolver/a_speedloader_rev.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = true },
}

SWEP.IronSightsPos = Vector(-1.851, 0, 1.12)
SWEP.IronSightsAng = Vector(-1.871, 0.019, 0)

SWEP.InspectPos = Vector(4.96, 0, -0.45)
SWEP.InspectAng = Vector(16.18, 21.809, 14.069)

----------------- Iron sights related
SWEP.Secondary.IronSightsEnabled    = true
SWEP.Secondary.IronFOV             	= 80
SWEP.Secondary.ViewModelFOV         = SWEP.ViewModelFOV - math.Round(SWEP.ViewModelFOV / 15) -- Defaults to 65. Target viewmodel FOV when aiming down the sights.

----------------- Worldmodel related
SWEP.WorldModel                 = "models/tfa_ins2_wpns/38revolver/w_38rev.mdl" -- Weapon world model path
SWEP.Offset = {
	Pos = {
		Up = -1.7,
		Right = 1.6,
		Forward = 4.8
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
	},
	Scale = .9
}

SWEP.HoldType                   = "pistol"
SWEP.IronSightHoldTypeOverride  = "revolver" -- ADS
SWEP.SprintHoldTypeOverride     = "normal" -- Sprinting, holster and safety/passive hold
SWEP.ReloadHoldTypeOverride     = "slam" -- Reloading
SWEP.CrouchHoldTypeOverride     = "pistol" -- Crouching

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

SWEP.Shotgun = true --Enable shotgun style reloading.
SWEP.ShotgunEmptyAnim = false --Enable emtpy reloads on shotguns?
SWEP.ShotgunEmptyAnim_Shell = false  --Enable insertion of a shell directly into the chamber on empty reload?

SWEP.EventTable = {
	[ACT_VM_DRAW_DEPLOYED] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function(wep, vm)
			wep.Bodygroups_V[1] = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1())
			wep.Bodygroups_V[2] = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1())
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_VM_PRIMARYATTACK] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function(wep, vm)
			wep.Bodygroups_V[1] = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1())
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_VM_PRIMARYATTACK_1] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function(wep, vm)
			wep.Bodygroups_V[1] = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1())
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_SHOTGUN_RELOAD_START] = {
		{ ["time"] = 58 / 33.5, ["type"] = "lua", ["value"] = function(wep, vm)
			if wep.EventShell then
				for i = 1, wep.Bodygroups_V[2] do
					wep:EventShell()
				end
				wep.Bodygroups_V[2] = 0
			end
			wep:Unload()
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function(wep, vm)
			local clip = math.Clamp(wep:Clip1() + 1, 0, wep:GetMaxClip1())
			wep.Bodygroups_V[1] = clip
			wep.Bodygroups_V[2] = clip
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_VM_RELOAD_DEPLOYED] = {
		{ ["time"] = 58 / 33.5, ["type"] = "lua", ["value"] = function(wep, vm)
			if wep.EventShell then
				for i = 1, wep.Bodygroups_V[2] do
					wep:EventShell()
				end
			end
			wep:Unload()
		end, ["client"] = true, ["server"] = true},
		{ ["time"] = 65 / 33.5, ["type"] = "lua", ["value"] = function(wep, vm)
			local ammo = math.Clamp(wep:Ammo1(), 0, wep:GetMaxClip1())
			wep.Bodygroups_V[1] = ammo
			wep.Bodygroups_V[2] = ammo
		end, ["client"] = true, ["server"] = true},
	},
}

SWEP.StatusLengthOverride = {
    ["base_reload_insert"] = 8 / 34.6,
    ["base_reload_speed"] = 84 / 33.5,
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
SWEP.MuzzleFlashEffect          = "tfa_muzzleflash_revolver" -- Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.SmokeParticle              = nil -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled       = false -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject      = false -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0 -- The delay to actually eject things
SWEP.LuaShellEffect 	= "ShellEject" --The effect used for shell ejection; Defaults to that used for blowback
SWEP.LuaShellModel      = "models/tfa/pistolshell.mdl" -- The model to use for ejected shells
SWEP.LuaShellScale      = 0.6 -- The model scale to use for ejected shells
SWEP.LuaShellYaw        = nil -- The model yaw rotation ( relative ) to use for ejected shells

SWEP.TracerCount        = 1     -- 0 disables, otherwise, 1 in X chance
SWEP.LaserSightModAttachment      = 1
SWEP.LaserSightModAttachmentWorld = 1
SWEP.LaserDotISMovement           = true

DEFINE_BASECLASS(SWEP.Base)