SWEP.Base					= "tfa_gun_base"                   -- Weapon Base
SWEP.Category				= "TFA Escape From Tarkov"                 -- The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.PrintName				= "SVDS"		                   -- Weapon name (Shown on HUD)
SWEP.Manufacturer 			= "Kalashnikov Concern"                        -- Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Purpose				= ""
SWEP.Instructions			= ""              

SWEP.Author				    = "nightmatt"    
SWEP.Contact				= "https://steamcommunity.com/id/nightmattxd/" 

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true                             -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.

SWEP.Slot					= 3			                       -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 73			                   -- Position in the slot
SWEP.AutoSwitchTo			= true		                       -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		                       -- Auto switch from if you pick up a better weapon
SWEP.Weight					= 67
SWEP.Ergonomics				= 3			                   -- This controls how "good" the weapon is for autopickup.
SWEP.Type                   = "Rifle"

--[[WEAPON HANDLING]]--
SWEP.Primary.Sound = Sound("TFA_EFT.SVD.1") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.SilencedSound = Sound("TFA_EFT.SVD.2") -- This is the sound of the weapon, when silenced.	
SWEP.Primary.LoopSoundAutoOnly = false

SWEP.Primary.Damage                = 45                        -- Damage, in standard damage points.
SWEP.Primary.DamageTypeHandled     = true                      -- true will handle damagetype in base
SWEP.Primary.DamageType            = nil                       -- See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.  Leave nil to autodetect.  DMG_AIRBOAT opens doors.
SWEP.Primary.PenetrationMultiplier = 1.1                      -- Change the amount of something this gun can penetrate through
SWEP.Primary.Velocity              = 825                    -- m/s
SWEP.Primary.NumShots              = 1                         -- The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.

SWEP.Primary.Automatic             = false                      -- Automatic/Semi Auto
SWEP.Primary.RPM                   = 450                      -- This is in Rounds Per Minute / RPM

SWEP.Primary.Force                 = 0                       -- Force value, leave nil to autocalc
SWEP.Primary.Knockback             = 0                       -- Autodetected if nil; this is the velocity kickback
SWEP.Primary.HullSize              = 0                         -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.
SWEP.IronSightTime = 0.3
SWEP.FiresUnderwater               = false

SWEP.SprintFOVOffset = 5

-- Miscelaneous Sounds

-- Selective Fire Stuff
SWEP.SelectiveFire                 = false                      -- Allow selecting your firemode?
SWEP.DisableBurstFire              = true                      -- Only auto/single?
SWEP.OnlyBurstFire                 = false                     -- No auto, only burst/single?
SWEP.FireModeName                  = nil                       -- Change to a text value to override it
SWEP.DefaultFireMode               = ""

-- Ammo Related
SWEP.Primary.ClipSize              = 20                        -- This is the size of a clip
SWEP.Primary.DefaultClip           = SWEP.Primary.ClipSize * 8 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo                  = "SniperPenetratedRound"                     -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption       = 1                         -- Ammo consumed per shot

-- Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering             = false                     -- Disable round-in-the-chamber

-- Recoil Related
SWEP.Primary.KickUp = 250 / 150 -- EFT Stat / 150 -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown = 250 / 250 -- EFT Stat / 250 -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal = 270 / 1200 -- EFT Stat / 1200 -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0 -- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

-- Firing Cone Related
SWEP.Primary.IronAccuracy = 1.24 * 0.002
SWEP.Primary.Spread = SWEP.Primary.IronAccuracy + (150 - 32) * 0.0005 + (1 / 1.24) * 0.025

SWEP.Primary.SpreadMultiplierMax = 1 -- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement = (SWEP.Primary.KickUp + SWEP.Primary.KickHorizontal) * 2 -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery = SWEP.Primary.SpreadIncrement * 7.5 -- How much the spread recovers, per second. Example val: 3


-- Range Related
SWEP.Primary.Range = 0.3 * (3280.84 * 17)     -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff        = 0.9                       -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

-- Penetration Related
SWEP.MaxPenetrationCounter      = 3                            -- The maximum number of ricochets.  To prevent stack overflows.

-- Misc
SWEP.IronRecoilMultiplier       = 0.6                     -- Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier   = 0.7 

SWEP.RecoilDelay = 0.25
 
-- Movespeed
SWEP.MoveSpeed                  = 0.85                          -- Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed        = 0.80                         -- Multiply the player's movespeed by this when sighting.

--[[EFFECTS]]--

-- Attachments
SWEP.MuzzleFlashEnabled         = true                     -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw        = nil                          -- This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.MuzzleFlashEffect          = "tfa_muzzleflash_rifle"           

SWEP.MuzzleAttachment			= "muzzle" 		               -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "shell" 		               -- Should be "2" for CSS models or "shell" for hl2 models

SWEP.AutoDetectMuzzleAttachment = false                        -- For multi-barrel weapons, detect the proper attachment?
SWEP.SmokeParticle              = nil                          -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled       = false                        -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject              = true                         -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay         = 0                            -- The delay to actually eject things
SWEP.LuaShellEffect             = "ShellEject"            -- The effect used for shell ejection; Defaults to that used for blowback
SWEP.LuaShellModel = "models/weapons/tfa_eft/shells/762x54/762x54.mdl" -- shell model

-- Tracer Stuff
SWEP.TracerName 		        = nil 	                       -- Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		        = 2 	                       -- 0 disables, otherwise, 1 in X chance

--[[VIEWMODEL]]--

SWEP.ViewModel	         = "models/weapons/v_tarkov_svd.mdl"
SWEP.VMPos               = Vector(0, 0, 0)                 -- The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng               = Vector(0, 0, 0)              -- The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive      = false                               -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.ViewModelFOV	     = 75		                           -- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip	     = false		                       -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands            = true                                -- Use gmod c_arms system.

SWEP.CenteredPos         = nil                                 -- The viewmodel positional offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.CenteredAng         = nil                                 -- The viewmodel angular offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.Bodygroups_V        = nil

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.AllowViewAttachment      = true                            -- Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.

--[[ANIMATION]]--

SWEP.SequenceLengthOverride     = {}                           -- Changes both the status delay and the nextprimaryfire of a given animation
SWEP.SequenceRateOverrideScaled = {}                           -- Like above but scales animation length rather than being absolute

SWEP.ProceduralHoslterEnabled   = nil
SWEP.ProceduralHolsterTime      = 0.35

SWEP.ProceduralHolsterPos       = Vector(3, 0, -5)
SWEP.ProceduralHolsterAng       = Vector(-40, -30, 10)

SWEP.Sights_Mode   = TFA.Enum.LOCOMOTION_HYBRID              -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Sprint_Mode   = TFA.Enum.LOCOMOTION_ANI                -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintBobMult = 0

SWEP.Idle_Mode     = TFA.Enum.IDLE_BOTH                        -- TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend    = 0.25                                      -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth   = 0.05                                     -- Start an idle this far early into the end of another animation

-- MDL Animations Below

SWEP.IronAnimation = {
    ["shoot"] = {
        ["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
        ["value"] = "ACT_VM_PRIMARYATTACK_1", --Number for act, String/Number for sequence
        ["value_empty"] =" ACT_VM_PRIMARYATTACK_EMPTY",
		["is_idle"] = true
    }
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "ACT_VM_SPRINT", --Number for act, String/Number for sequence
		["is_idle"] = true
	}
}
--[[EVENT TABLE]]--

--[[WORLDMODEL]]--

SWEP.WorldModel	  = "models/weapons/w_tarkov_svd.mdl" -- Weapon world model path 
SWEP.Bodygroups_W = nil 

SWEP.HoldType     = "ar2" 

-- This is how others view you carrying the weapon. Options include:  
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = {
	Pos = {
		Up = -4.5,
		Right = 0,
		Forward = 12
	},
	Ang = {
		Up = -85,
		Right = 0,
		Forward = 190
	},
	Scale = 1.25
} -- Procedural worlodel animation, defaulted for CS:S purposes.

SWEP.ThirdPersonReloadDisable = false                          -- Disable third person reload?  True disables.

--[[IRONSIGHTS]]--

SWEP.data = {}

SWEP.data.ironsights   = 1    -- Enable Ironsights
SWEP.Secondary.IronFOV = 80   -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(2.5, 0.2, 0.2)
SWEP.RunSightsAng = Vector(-23, 30, -30)

--[[IRONSIGHTS]]--

SWEP.IronSightsPos = Vector(-2.75, -1, 1.7)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.IronSightsPos_Kobra = Vector(-2.68, -1, 0.24)
SWEP.IronSightsAng_Kobra = Vector(0, 0, 0)

SWEP.IronSightsPos_EOTech = Vector(-2.68, -1, 0.388)
SWEP.IronSightsAng_EOTech = Vector(0, 0, 0)

SWEP.IronSightsPos_RDS = Vector(-2.68, -1, 0.33)
SWEP.IronSightsAng_RDS = Vector(0, 0, 0)

SWEP.IronSightsPos_2XRDS = Vector(-2.66, -1, 0.33)
SWEP.IronSightsAng_2XRDS = Vector(0, 0, 0)

SWEP.IronSightsPos_PSO = Vector(-2.255, -2, 0.795)
SWEP.IronSightsAng_PSO = Vector(0, 0, 0)

--[[INSPECTION]]--

SWEP.InspectPos = Vector(10.877, -9.705, 3.171)
SWEP.InspectAng = Vector(47.527, 50.993, 56.782)
--Safety position
SWEP.SafetyPos = Vector(2.522, -1.721, -3.036)
SWEP.SafetyAng = Vector(-14.344, 37.99, -33.807)

----[[CROUCHING]]----
SWEP.CrouchPos = Vector(-2.35, 0, -1)
SWEP.CrouchAng = Vector(0, 0, -12.5)

----[[EVENT TABLE FUNCTIONS]]----

function SWEP:SVD_Mag1_Update(vm)
	if self:Clip1() == 0 then
		self.Bodygroups_V[2] = 1
	end
end

function SWEP:SVD_Mag1_Full(vm)
	self.Bodygroups_V[2] = 0
end

----[[EVENT TABLE]]---

SWEP.EventTable = {
	["base_idle"] = {
		{time = 0, type = "lua", value = function(wep, vm) wep:SVD_Mag1_Update() end},
	},
	["base_ready"] = {
		{time = 0, type = "lua", value = function(wep, vm) wep:SVD_Mag1_Full() end},
	},
	["base_reload"] = {
		{time = 0, type = "lua", value = function(wep, vm) wep:SVD_Mag1_Full() end},
	},
	["base_reloadempty"] = {
		{time = 0, type = "lua", value = function(wep, vm) wep:SVD_Mag1_Update() end},
	}
}

--[[ATTACHMENTS]]--

SWEP.Attachments = {
	[1] = { atts = { "eft_si_pso" } },
	[2] = { atts = { "eft_sil_rotor", "ins2_br_heavy" }},
	[3] = { atts = { "am_match", "am_magnum" } },
}

SWEP.AttachmentTableOverride = {
}

SWEP.ViewModelBoneMods = {
	["A_Optic"] = { scale = Vector(0.7, 0.7, 0.7), pos = Vector(-0.01, -1, 0.2), angle = Angle(0, 0, 0) },
}

SWEP.WorldModelBoneMods = {
}


SWEP.VElements = {
	["scope_pso"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/scopes/assault/pso/v_pso_w.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
}

SWEP.WElements = {
}

SWEP.MuzzleAttachmentSilenced = 1

SWEP.LaserSightModAttachment = 1
SWEP.LaserSightModAttachmentWorld = 4
SWEP.LaserDotISMovement = true

DEFINE_BASECLASS( SWEP.Base )