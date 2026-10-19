local IsValid          = IsValid
local min              = math.min
local random           = math.random
local SimpleTimer      = timer.Simple
local CurTime          = CurTime

SWEP.Base              = "tfa_gun_base"
SWEP.Category          = "Military Play | Прочее"
SWEP.Author            = ""        --Author Tooltip
SWEP.Contact           = ""        --Contact Info Tooltip
SWEP.Purpose           = ""        --Purpose Tooltip
SWEP.Instructions      = ""        --Instructions Tooltip
SWEP.Spawnable         = true      --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable    = true      --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair     = true      -- Draw the crosshair?
SWEP.PrintName         = "M26 Taser" -- Weapon name (Shown on HUD)	
SWEP.Slot              = 1         -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos           = 80        -- Position in the slot
SWEP.DrawAmmo          = true      -- Should draw the default HL2 ammo counter if enabled in the GUI.
SWEP.DrawWeaponInfoBox = false     -- Should draw the weapon info box
SWEP.BounceWeaponIcon  = false     -- Should the weapon icon bounce?
SWEP.AutoSwitchTo      = true      -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom    = true      -- Auto switch from if you pick up a better weapon
SWEP.Weight            = 30        -- This controls how "good" the weapon is for autopickup.

if TFA then
	local path = "stungun/"
	local pref = "TFA_Realistic_Taser"

	TFA.AddWeaponSound(pref .. ".Draw", path .. "taser_draw.wav")
	TFA.AddWeaponSound(pref .. ".Fire", path .. "taser_shoot.mp3")
	TFA.AddWeaponSound(pref .. ".Hit", path .. "active_stun.mp3")
	TFA.AddWeaponSound(pref .. ".Reload", path .. "taser_reload.mp3")

	TFA.AddAmmo("taser_charges", "Taser Charges")
end

--[[WEAPON HANDLING]] --

--Firing related
SWEP.Primary.Sound                 = Sound("TFA_Realistic_Taser.Fire") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.HitSound              = Sound("TFA_Realistic_Taser.Hit") -- This is the sound of the weapon, when you shoot.

SWEP.Primary.PenetrationMultiplier = 0                     --Change the amount of something this gun can penetrate through
SWEP.DamageType                    = nil                   --See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.
SWEP.Primary.NumShots              = 1                     --The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.
SWEP.Primary.Automatic             = false                 -- Automatic/Semi Auto
SWEP.Primary.RPM                   = 200                   -- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Semi              = nil                   -- RPM for semi-automatic or burst fire.  This is in Rounds Per Minute / RPM
SWEP.FiresUnderwater               = false

-- Selective Fire Stuff

SWEP.SelectiveFire                 = false --Allow selecting your firemode?
SWEP.DisableBurstFire              = false --Only auto/single?
SWEP.OnlyBurstFire                 = false --No auto, only burst/single?
SWEP.DefaultFireMode               = "" --Default to auto or whatev

--Ammo Related

SWEP.Primary.ClipSize              = 1 -- This is the size of a clip
SWEP.Primary.DefaultClip           = 5 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo                  =
"taser_charges"                       -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering             = true --Disable round-in-the-chamber

--Recoil Related
SWEP.Primary.KickUp                = 0.4 -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown              = 0.4 -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal        = 0.3 -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor    = 0.5 --Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

--Firing Cone Related

SWEP.Primary.Spread                = .25 --This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy          = .001 -- Ironsight accuracy, should be the same for shotguns

--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.

SWEP.Primary.SpreadMultiplierMax   = 6 --How far the spread can expand when you shoot.
SWEP.Primary.SpreadIncrement       = 1.4 --What percentage of the modifier is added on, per shot.
SWEP.Primary.SpreadRecovery        = 5.5 --How much the spread recovers, per second.

--Range Related
SWEP.Primary.Range                 = 5                         -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff          = -1                        -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

--[[PROJECTILES]]                                              --

SWEP.ProjectileEntity = nil                                    --Entity to shoot
SWEP.ProjectileVelocity = 0                                    --Entity to shoot's velocity
SWEP.LuaShellEject = false                                     --Entity to shoot's model

--[[VIEWMODEL]]                                                --

SWEP.ViewModel            = "models/realistic_police/taser/c_taser.mdl" --Viewmodel path
SWEP.ViewModelFOV         = 60                                 -- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip        = false                              -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands             = true                               --Use gmod c_arms system.
SWEP.EjectionSmokeEnabled = false

--[[WORLDMODEL]]                                                --

SWEP.WorldModel               = "models/realistic_police/taser/w_taser.mdl" -- Weapon world model path

SWEP.Bodygroups_W             = nil
SWEP.HoldType                 = "pistol"

-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset                   = {
	Pos = {
		Up = -2,
		Right = 1.1,
		Forward = 1.5
	},

	Ang = {
		Up = -85,
		Right = 0,
		Forward = 80
	},
	Scale = 1.10
}

SWEP.ThirdPersonReloadDisable = false -- Disable third person reload?  True disables.

--[[SHOTGUN CODE]]                    --

SWEP.Shotgun   = false                --Enable shotgun style reloading.

SWEP.ShellTime = .35                  -- For shotguns, how long it takes to insert a shell.

--[[SPRINTING]]                       --

SWEP.RunSightsPos = Vector(2.202, -13.457, -8.447)
SWEP.RunSightsAng = Vector(64.723, 0, 0)

--[[IRONSIGHTS]] --

SWEP.data              = {}
SWEP.data.ironsights   = 1    --Enable Ironsights
SWEP.Secondary.IronFOV = 70   -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsPos     = Vector(-4.325, 0, 2.3)
SWEP.IronSightsAng     = Vector(-1.5, -4, 0)

--[[INSPECTION]] --

SWEP.InspectPos = Vector(6, -7, 0)
SWEP.InspectAng = Vector(19.618, 31, 16.884)

--[[VIEWMODEL ANIMATION HANDLING]]      --

SWEP.SprintBobMult = 1.5                -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this > 1 probably for sprinting.
SWEP.IronBobMult = 0                    -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this < 1 for sighting, 0 to outright disable.
SWEP.AllowViewAttachment = true         --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS!!!!11111oneONEELEVEN

--[[VIEWMODEL BLOWBACK]]                --

SWEP.BlowbackEnabled = false            --Enable Blowback?
SWEP.BlowbackVector = Vector(0, -3, 0.05) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0            --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0                --Amount of blowback currently, for bones

SWEP.BlowbackBoneMods = {}

--[[ANIMATION]]                    --

SWEP.ForceDryFireOff            = true --Disables dryfire.  Set to false to enable them.
SWEP.DisableIdleAnimations      = false --Disables idle animations.  Set to false to enable them.
SWEP.ForceEmptyFireOff          = true --Disables empty fire animations.  Set to false to enable them.

--If you really want, you can remove things from SWEP.actlist and manually enable animations and set their lengths.

SWEP.SequenceEnabled            = {}             --Self explanitory.  This can forcefully enable or disable a certain ACT_VM
SWEP.SequenceLength             = {}             --This controls the length of a certain ACT_VM
SWEP.SequenceLengthOverride     = {}             --Override this if you want to change the length of a sequence but not the next idle

SWEP.MuzzleAttachment           = "muzzle"       -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment            = "shell"        -- Should be "2" for CSS models or "shell" for hl2 models

SWEP.DoMuzzleFlash              = true           --Do a muzzle flash?
SWEP.CustomMuzzleFlash          = true           --Disable muzzle anim events and use our custom flashes?
SWEP.AutoDetectMuzzleAttachment = false          --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect          =
"tfa_csgo_muzzle_taser"                          --Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.TracerParticleName         = "weapon_tracers_taser"

--[[EVENT TABLE]] --

SWEP.EventTable = {
	["draw"] = {
		{ time = 0, type = "sound", value = Sound("TFA_Realistic_Taser.Draw") },
	},

	["reload"] = {
		{ time = 0.53, type = "sound", value = Sound("TFA_Realistic_Taser.Reload") },
	},
}

--Convar support

SWEP.RangeFalloffLUTMaxRange = 5
SWEP.RangeFallottLUTModifier = 0.0049
SWEP.RangeFalloffLUTGenerate = true

sv_taser_stuntime = CreateConVar("sv_taser_stuntime", 5, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED },
	"How long the Taser will stun a user (In Seconds)")

local ImmuneJobs = {
	TEAM_MAYOR,
	TEAM_OVERWATCH
}

local TasedUsers = TasedUsers or {}

if SERVER then
	util.AddNetworkString("taser_stunned")
end

if CLIENT then
	-- visual slump when hit
	net.Receive("taser_stunned", function()
		local ply = net.ReadEntity()
		local stunned = net.ReadBool()
		if IsValid(ply) and ply:IsPlayer() and ply:Alive() then
			if stunned then
				ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_HL2MP_IDLE, false)
			else
				ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
			end
		end
	end)
end

function SWEP:Stun(ply)
	if not SERVER then return end

	TasedUsers[ply:SteamID()] = true

	ply:EmitSound("ambient/voices/m_scream1.wav")
	ply:EmitSound("stungun/active_stun.mp3")

	ply:Freeze(true)
	net.Start("taser_stunned")
	net.WriteEntity(ply)
	net.WriteBool(true)
	net.Broadcast()

	timer.Create("taser_unstun_" .. tostring(ply:EntIndex()), GetConVar("sv_taser_stuntime"):GetInt(), 1, function()
		if IsValid(ply) then
			TasedUsers[ply:SteamID()] = nil

			ply:Freeze(false)

			ply:StopSound("stungun/active_stun.mp3")

			net.Start("taser_stunned")
			net.WriteEntity(ply)
			net.WriteBool(false)
			net.Broadcast()
		end
	end)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:EmitSound(self.Primary.Sound)

	self:GetOwner():LagCompensation(true)
	local trace = self:GetOwner():GetEyeTrace()

	fxdata = EffectData()
	fxdata:SetEntity(self)
	fxdata:SetAttachment(1)
	fxdata:SetStart(self.Owner:GetShootPos())
	fxdata:SetOrigin(trace.HitPos)
	fxdata:SetNormal(trace.HitNormal)

	if trace.Hit and IsValid(trace.Entity) and (self:GetPos():Distance(trace.HitPos) <= 500) and (trace.Entity:IsRagdoll() or trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then
		self:EmitSound(self.Primary.HitSound)

		if CLIENT or game.SinglePlayer() and IsFirstTimePredicted() then
			util.Effect("tfa_tracer_csgo", fxdata)
		end

		local owner = self:GetOwner()
		local fireDir, firePos = owner:GetAimVector()

		if owner:IsPlayer() then
			local eyeTr = owner:GetEyeTrace()

			firePos = (eyeTr.StartPos + fireDir * min(eyeTr.StartPos:Distance(eyeTr.HitPos), 32))
		else
			firePos = (owner:GetShootPos() + fireDir * 32)
		end

		local ply = trace.Entity

		if IsValid(ply) and ply:IsPlayer() and ply:Alive() and not TasedUsers[ply:SteamID()] then
			if ((type(DarkRP) == "table") or (RPExtraTeams != nil)) then
				if table.HasValue(ImmuneJobs, ply:Team()) then return end
			end

			self:Stun(ply)
		end

		if ! trace.Entity:IsPlayer() then
			M9TranqGun_FireDart(firePos, fireDir, owner, self)
		end
	elseif trace.Hit and (self:GetPos():Distance(trace.HitPos) <= 500) then
		fxdata:SetOrigin(self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Primary.Range)
		util.Effect("tfa_tracer_csgo", fxdata)
	end

	if self.MuzzleFlashEnabled and (not self:IsFirstPerson() or not self.AutoDetectMuzzleAttachment) then
		self:ShootEffectsCustom()
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.RPM)
	self:GetOwner():LagCompensation(false)

	self:TakePrimaryAmmo(1)
	self:SendViewModelAnim(ACT_VM_PRIMARYATTACK, 1)
end

function SWEP:GetNPCBurstSettings()
	return 1, 1, 1.25
end

function SWEP:GetNPCRestTimes()
	return 1.25, 2.5
end

function SWEP:GetNPCBulletSpread()
	return 3
end

function SWEP:MuzzleSmoke()
end
