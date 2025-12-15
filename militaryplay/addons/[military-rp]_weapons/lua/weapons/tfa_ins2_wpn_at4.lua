if CLIENT then
    SWEP.BounceWeaponIcon = false
    SWEP.DrawWeaponInfoBox = false
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/tfa_ins2_wpns_icons/tfa_ins2_wpn_at4" )
    killicon.Add( "tfa_ins2_wpn_at4", "vgui/tfa_ins2_wpns_icons/tfa_ins2_wpn_at4_kill", Color( 255, 255, 255, 255 ) )
    killicon.Add( "tfa_ins2_ent_at4rocket", "vgui/tfa_ins2_wpns_icons/tfa_ins2_wpn_at4_kill", Color( 255, 255, 255, 255 ) )
end

SWEP.SubCategory 				= "Launchers"
SWEP.Purpose 					= "High explosive, metal piercing rocket launcher manufactured in the United States"
SWEP.Base                       = "tfa_ins2_base"
SWEP.Category                   = "Military Play | Оружие" -- The category.
SWEP.Manufacturer               = "SAAB Bofors Dynamics" -- Gun Manufactrer (e.g. Hoeckler and Koch)
SWEP.Spawnable                  = true -- Can you, as a normal user, spawn this?
SWEP.AdminSpawnable             = false -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair              = true      -- Draw the crosshair?

-- AKA DrawCrosshairIS
SWEP.DrawCrosshairIronSights    = false -- Draw the crosshair in ironsights?
SWEP.PrintName                  = "AT4"       -- Weapon name (Shown on HUD)
SWEP.Slot                       = 4             -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos                    = 1            -- Position in the slot
SWEP.AutoSwitchTo               = true      -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom             = true      -- Auto switch from if you pick up a better weapon
SWEP.Weight                     = 30            -- This controls how "good" the weapon is for autopickup.
SWEP.Type                       = "Launcher" -- Weapon type. Autodetected, but in some cases needs to be set manually. PLEASE MAKE SURE THE TYPE IS SET PROPERLY so that autodetection code won't make funky stuff.ers"
SWEP.Type_Displayed             = "Launcher" -- Weapon type override for displaying in the inspection menu. If you want to add wacky text below the gun name, DO IT HERE AND NOT IN THE ACTUAL TYPE FIELD!
-- Recognized generic types: "Pistol", "Machine Pistol", "Revolver", "Sub-Machine Gun", "Rifle", "Carbine", "Light Machine Gun", "Shotgun", "Designated Marksman Rifle", "Sniper Rifle", "Grenade", "Launcher"; "Dual Pistols", "Dual Revolvers", "Dual Sub-Machine Guns" and "Dual Guns".

----------------- The Most basic weapon stats
SWEP.Primary.RPM                = 60 / 0.5 -- This is in Rounds Per Minute / RPM
SWEP.Primary.Automatic          = false -- Automatic/Semi Auto
SWEP.FiresUnderwater    		= false -- Whenever this weapon can fire underwater

----------------- TFA Base Basic sound handling
SWEP.Primary.Sound                  = Sound("TFA_INS2_AT4.Fire") -- This is the sound of the weapon, when you shoot.
SWEP.IronInSound 				    = Sound("TFA_INS2.IronIn")
SWEP.IronOutSound				    = Sound("TFA_INS2.IronOut")
SWEP.FireSoundAffectedByClipSize 	= false -- Play low ammo and last shot sounds? Controlled by "Enable nearly-empty sounds" server option.

----------------- Silencing
SWEP.CanBeSilenced                = false -- Can we silence?  Requires animations.
SWEP.Silenced                     = false -- Silenced by default?
SWEP.SelectiveFire                = false -- Allow selecting your firemode?

----------------- Ammo Related
SWEP.Primary.ClipSize           = 1 -- This is the size of a clip
SWEP.Primary.DefaultClip        = 1 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo               = "AT4 Rocket" -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption    = 1 -- Ammo consumed per shot
SWEP.DisableChambering 			= true -- Disable round-in-the-chamber

-- Recoil Related
SWEP.Primary.KickUp             = 0.8 -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown           = 0.8 -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal     = 0.1 -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.4-- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

----------------- Spread stats
-- Firing Cone Related
SWEP.Primary.Spread             	= .02 -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.SpreadMultiplierMax 	= 1 -- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement     	= 1/5                        -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery      	= 5                        -- How much the spread recovers, per second. Example val: 3
SWEP.Primary.IronAccuracy       	= .02 -- Ironsight accuracy, should be the same for shotguns
SWEP.CrouchAccuracyMultiplier   	= 1

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
SWEP.MoveSpeed 									= 0.72
SWEP.IronSightsMoveSpeed 						= SWEP.MoveSpeed * 0.8
SWEP.IronSightTime 								= 0.6

----------------- ViewModel related
SWEP.ViewModel          = "models/tfa_ins2_wpns/at4/v_at4.mdl" -- Viewmodel path
SWEP.ViewModelFOV		= 56		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip      = false     -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands           = true -- Use gmod c_arms system.

SWEP.ViewModelBoneMods = {
	["L Clavicle"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["R Clavicle"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.IronSightsPos = Vector(-1.361, 0, 0.479)
SWEP.IronSightsAng = Vector(1.889, -2.201, 7)

SWEP.InspectPos = Vector(4.32, 2.813, -0.201)
SWEP.InspectAng = Vector(9.848, 24.622, 12.663)

----------------- Iron sights related
SWEP.Secondary.IronSightsEnabled    = true
SWEP.Secondary.IronFOV             	= 80
SWEP.Secondary.ViewModelFOV         = SWEP.ViewModelFOV - math.Round(SWEP.ViewModelFOV / 15) -- Defaults to 65. Target viewmodel FOV when aiming down the sights.

----------------- Worldmodel related
SWEP.WorldModel                 = "models/tfa_ins2_wpns/at4/w_at4.mdl" -- Weapon world model path
SWEP.Offset = {
	Pos = {
		Up = -2.9,
		Right = 1.5,
		Forward = -0
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
	},
	Scale = 1
}

SWEP.HoldType                   = "rpg"
SWEP.IronSightHoldTypeOverride  = "rpg" -- ADS
SWEP.SprintHoldTypeOverride     = "passive" -- Sprinting, holster and safety/passive hold
SWEP.ReloadHoldTypeOverride     = "slam" -- Reloading
SWEP.CrouchHoldTypeOverride     = "rpg" -- Crouching

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
		["value"] = ACT_VM_PRIMARYATTACK_1
	}
}

-- Attachments
SWEP.MuzzleAttachment           = "muzzle" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment            = "shell" -- Should be "2" for CSS models or "shell" for hl2 models
SWEP.MuzzleFlashEnabled         = true -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw        = nil -- This will override whatever string you gave. This is the raw attachment NUMBER. This is overridden or created when a gun makes a muzzle event.
SWEP.AutoDetectMuzzleAttachment = false -- For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect          = "tfa_muzzleflash_incendiary" -- Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.SmokeParticle              = nil -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled       = false -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject      = false -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0 -- The delay to actually eject things
SWEP.LuaShellEffect 	= "RifleShellEject" --The effect used for shell ejection; Defaults to that used for blowback
SWEP.LuaShellModel      = "models/tfa/rifleshell.mdl" -- The model to use for ejected shells
SWEP.LuaShellScale      = 0.5 -- The model scale to use for ejected shells
SWEP.LuaShellYaw        = nil -- The model yaw rotation ( relative ) to use for ejected shells

SWEP.Primary.Projectile  		= "tfa_ins2_ent_at4rocket" --Entity to shoot
SWEP.Primary.ProjectileVelocity = 2500  --Entity to shoot's velocity
SWEP.Primary.ProjectileModel 	= "models/tfa_ins2_wpns/at4/w_at4_projectile.mdl" --Entity to shoot

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Holster(...)
	if self:Clip1() <= 0 then
		timer.Simple( 1.2, function()
			if SERVER then
				local ent = ents.Create( "prop_physics" )
				ent:SetModel( self.WorldModel )
				ent:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				ent:DrawShadow( false )
				ent:SetOwner( self.Owner )
				if IsValid( ent ) then
					ent:SetPos( self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 16 + self.Owner:EyeAngles():Up() * -24 )
					ent:SetAngles( self.Owner:EyeAngles() )
					ent:Spawn()
					ent:GetPhysicsObject():SetVelocity( Vector( 0, 0, -100 ) )
				end
				timer.Simple( 5, function()
					ent:Remove()
				end )
			end
			self.Owner:StripWeapon("tfa_ins2_wpn_at4")
		end )
	end
	return BaseClass.Holster(self,...)
end