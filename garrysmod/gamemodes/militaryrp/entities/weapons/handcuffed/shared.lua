SWEP.Contact = ""
SWEP.PrintName = "Наручники"
SWEP.Category = 'Military Play | Прочее'
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModelFOV = 90
SWEP.ViewModel = "models/tobadforyou/c_hand_cuffs.mdl"
SWEP.WorldModel = "models/tobadforyou/handcuffs.mdl"

SWEP.ViewModelFlip = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true
SWEP.HoldType = "slam"
SWEP.FiresUnderwater = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	return false
end
