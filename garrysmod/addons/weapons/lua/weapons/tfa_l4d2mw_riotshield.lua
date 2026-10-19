SWEP.Base = "tfa_melee_base"
SWEP.Category = "Military Play | Ножи"
SWEP.PrintName = "Riot Shield"
SWEP.Type		= "Shield"
SWEP.Description = "Ballistic-proof and explosive-resistant shield with increased melee damage."
SWEP.Author = "AidenTheZapperGuy, teap, mav, ThomasCat"
SWEP.Manufacturer = "Someone..."
SWEP.ViewModel = "models/viewmodels/c_mw2019_riotshield.mdl"
SWEP.ViewModelFOV = 65 -- L4D2 default is 51
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
SWEP.WorldModel = "models/worldmodels/w_mw2019_riotshield.mdl"
SWEP.HoldType = "camera"
SWEP.Primary.Directional = false
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.Secondary.CanBash = true

SWEP.Offset = {
		Pos = {
		Up = 1,
		Right = 1.5,
		Forward = 2,
		},
		Ang = {
		Up = 200,
		Right = 185,
		Forward = 8
		},
		Scale = 1
}

SWEP.Secondary.MaxCombo = 0
SWEP.Primary.MaxCombo = 0

SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(0, 0, 0)

SWEP.RiotShield = true
SWEP.RiotShieldCone = 90 --Think of the player's view direction as being the middle of a sector, with the sector's angle being this
SWEP.RiotShieldMaximum = 0.0 --Multiply damage by this for a maximumly effective block
SWEP.RiotShieldImpact = "L4D2_MW.RiotShield.Impact"
SWEP.RiotShieldCanDeflect = false
SWEP.RiotShieldDamageCap = 100
SWEP.RiotShieldDamageTypes = {
	DMG_SLASH,DMG_CLUB,DMG_BULLET,DMG_AIRBOAT,DMG_BLAST_SURFACE
}

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 30, type = "sound", value = Sound("L4D2_MW.RiotShield.Deploy")},
	}
}

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 15 * 4.5, -- Trace distance
		["dir"] = Vector(0,15,-80), -- Trace arc cast
		["dmg"] = 150, --Damage
		["dmgtype"] = SWEP.Primary.DamageType, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.250, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "L4D2_MW.RiotShield.Swing", -- Sound ID
		["snd_delay"] = 0.150,
		["viewpunch"] = Angle(0, 4, 0), --viewpunch angle
		["end"] = 1.2, --time before next attack
		["hull"] = 15, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "L4D2_MW.Sledgehammer.HitFlesh",
		["hitworld"] = "L4D2_MW.Sledgehammer.HitWorld",
		["combotime"] = 0.1
	},
}

--[Misc]--
SWEP.Primary.Sound = Sound("L4D2_MW.RiotShield.Swing")
SWEP.MoveSpeed = 0.85
SWEP.ImpactDecal = "ManhackCut"
SWEP.Primary.DamageType = bit.bor(DMG_CLUB, DMG_SLASH)
SWEP.Primary.RPM = 100
