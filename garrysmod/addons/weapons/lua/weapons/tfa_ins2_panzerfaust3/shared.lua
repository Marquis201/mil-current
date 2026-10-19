-- Variables that are used on both client and server
SWEP.Gun = ("tfa_ins2_panzerfaust3") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Military Play | Оружие"
SWEP.Manufacturer = "Dynamit Nobel AG" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Author				= "The Master MLG"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "PanzerFaust - 3"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 2			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon
SWEP.Type = "Anti-Tank Rocket Launcher"
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_panzerfaust3_sandstorm.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_panzerfaust3_sandstorm.mdl"	-- Weapon world model
SWEP.Base					= "tfa_3dbash_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.UseHands = true

SWEP.Primary.Sound			= Sound("weapons/tfa_ins2_panzerfaust3/panzerfaust3_fire.wav")		-- Script that calls the primary fire sound		
SWEP.Primary.RPM			= 125			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip		= 1		-- Bullets you start with
SWEP.Primary.KickUp				= 0.345		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.267		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.186		-- Maximum up recoil (stock)
SWEP.Primary.StaticRecoilFactor = 0.63 --Amount of recoil to directly apply to EyeAngles. Enter what fraction or percentage (in decimal form) you want. This is also affected by a convar that defaults to 0.5.
SWEP.IronRecoilMultiplier = 0.61
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "PanzerFaust3 Rocket"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV = 70 -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.
SWEP.MoveSpeed = 0.72 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed  * 0.91

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 100	-- Base damage per bullet
SWEP.Primary.Spread		= .001	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .001 -- Ironsight accuracy, should be the same for shotguns
SWEP.DisableChambering = true

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-0.565, -4, 0.97)
SWEP.IronSightsAng = Vector(16.535, 0, 0)
SWEP.RunSightsPos = Vector(4.762, -4.238, -0.717)
SWEP.RunSightsAng = Vector(-6.743, 46.284, 0)
SWEP.InspectPos = Vector(7.76, -2, 0.016)
SWEP.InspectAng = Vector(1, 37.277, 3.2)

SWEP.ProjectileEntity = "tfa_panzerfaust3_rocket" --Entity to shoot
SWEP.ProjectileVelocity = 7000 * 16 / 12 --Entity to shoot's velocity
SWEP.FireModeName = "One-Shot"

SWEP.RTMaterialOverride = -1 --the number of the texture, which you subtract from GetAttachment

SWEP.ScopeAngleTransforms = {
    {"P",-6}, --Pitch, 1
    {"Y",1.25}, --Yaw, 1
    {"R",20}, --Roll, 1
}

SWEP.RTScopeFOV = 9.32
SWEP.RTScopeAttachment = 3

SWEP.RTMaterialOverride = -1

SWEP.IronSightsSensitivity = 1 / 3

SWEP.ScopeShadow = nil

SWEP.UpdateScopeType = function() end

SWEP.RTScopeAttachment = 3

SWEP.ScopeReticule = ("models/weapons/panzerfaust3_sandstorm/panzefaust_reticle")


SWEP.SelectiveFire		= false
SWEP.DisableBurstFire = false --Only auto/single?

SWEP.Offset = {
        Pos = {
        Up = -8.8,
        Right = 2,
        Forward = 7.5,
        },
        Ang = {
        Up = -5,
        Right = 170,
        Forward = 185,
        },
		Scale = 1
}

SWEP.VElements = {
	["RT_Scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "Weapon", rel = "", pos = Vector(2.644, -3.55, 5.192), angle = Angle(0, 90, -20), size = Vector(0.428, 0.428, 0.428), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}


SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "base_sprint", --Number for act, String/Number for sequence
		["is_idle"] = true
	}
}

SWEP.WElements = {
	["ref"] = { type = "Model", model = SWEP.WorldModel, bone = "oof", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false }
}
