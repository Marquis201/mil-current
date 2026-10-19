AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Палка Освобождения"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "stunstick"

SWEP.UseHands = true

SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.Instructions = "Left click to unarrest\nRight click to switch batons"

SWEP.Category = "Military Play | Прочее"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:PrimaryAttack()
	self:SetHoldType("melee")

    self:SetNextPrimaryFire(CurTime() + 0.51) -- Actual delay is set later.

    local vm = self:GetOwner():GetViewModel()
    if IsValid(vm) then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("idle01"))
    end

	local eTrace = self.Owner:GetEyeTrace().Entity
	if SERVER then
		if eTrace and eTrace:IsPlayer() and eTrace:GetNetVar("Arrested") and self.Owner:GetPos():DistToSqr(eTrace:GetPos()) < 10000 then
			eTrace:UnArrest(self.Owner)
		end
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
	
	self:EmitSound(self.Sound,40)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:PreDrawViewModel( vm,pl,wep)
	--return true
end

