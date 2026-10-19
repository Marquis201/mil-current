AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "АТРО-2М"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "stunstick"

SWEP.UseHands = true

SWEP.ViewModel = Model("models/weapons/darky_m/c_syringe_v2.mdl")
SWEP.WorldModel = Model("models/weapons/darky_m/w_syringe_v2.mdl")

SWEP.Instructions = "Left click to unarrest\nRight click to switch batons"

SWEP.Category = "Military Play | Прочее"
SWEP.Spawnable = true
SWEP.AdminOnly = true

local SOUND_FILE = "weapons/rust_mp3/syringe-inject-friend.mp3"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.HoldType = "slam"

SWEP.Insert = 0
SWEP.IdleTimer = CurTime()
SWEP.InsertTimer = CurTime()

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    return true
end

function SWEP:Holster()
    self.Insert = 0
    self.IdleTimer = CurTime()
    self.InsertTimer = CurTime()
    return true
end


function SWEP:PrimaryAttack()
    local Owner = self:GetOwner()
    if self.Insert != 0 then return end

    local Traced = self:CheckTrace()


    if IsValid(Traced) then
        Owner:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)
        if CLIENT then return end
        local CT = CurTime()

        
        self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) 
        self.Friend = Traced
        self.TraceCheckTimer = CT + 0.2
        self.Insert = 2 -- 
        self.InsertTimer = CT + Owner:GetViewModel():SequenceDuration()
        self.SoundTimer = CT + 0.3
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:CheckTrace()
    local Owner = self:GetOwner()
    Owner:LagCompensation(true)

    local Trace = util.TraceLine({
        start = Owner:GetShootPos(),
        endpos = Owner:GetShootPos() + Owner:GetAimVector() * 80, -- Немного увеличил дистанцию
        filter = Owner
    })

    Owner:LagCompensation(false)

    return Trace.Entity
end

function SWEP:FinishAnimation()
    self.Insert = 0
    self.IdleTimer = CurTime()
    self.Friend = nil
end

function SWEP:Think()
    local CT = CurTime()
    local Owner = self:GetOwner()

    if self.IdleTimer <= CT then
        self:IdleAnimation()
    end

    if CLIENT then return end


    if self.SoundTimer and self.SoundTimer <= CT then
        if self.Insert == 2 then
            Owner:EmitSound(SOUND_FILE, 75, 100)
           

            local target = self.Friend
            if not IsValid(target) then target = self:CheckTrace() end

            if IsValid(target) and target.revive and IsValid(target.owner) then
                if not target.owner:Alive() then
                    target.owner:Revive(true)
                end
            end
        end
        self.SoundTimer = nil
    end

    if self.Insert == 2 then
        if self.InsertTimer <= CT then
            self:FinishAnimation()
            self.TraceCheckTimer = nil
        end

        if self.TraceCheckTimer and self.TraceCheckTimer <= CT then
            if self:CheckTrace() != self.Friend then

                self.TraceCheckTimer = nil 
            else
                self.TraceCheckTimer = CT + 0.2
            end
        end
    end
end

function SWEP:IdleAnimation()
    if SERVER and self.Insert == 0 then
        local vm = self:GetOwner():GetViewModel()
        if IsValid(vm) then
            self:SendWeaponAnim(ACT_VM_IDLE)
            self.IdleTimer = CurTime() + vm:SequenceDuration()
        end
    end
end


