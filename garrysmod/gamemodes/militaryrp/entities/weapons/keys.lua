if SERVER then
	AddCSLuaFile()
end

SWEP.Category              = "Прочее"
SWEP.PrintName             = "Ключи"
SWEP.Slot                  = 1
SWEP.SlotPos               = 1
SWEP.DrawAmmo              = false
SWEP.DrawCrosshair         = false

SWEP.Author                = ""
SWEP.Instructions          = "ЛКМ - Открыть\nПКМ - Закрыть"

SWEP.Spawnable             = true
SWEP.Sound                 = "doors/door_latch3.wav"
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = 0
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = ""

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = ""

SWEP.HoldType              = "slam"
-- SWEP.ViewModelFOV          = 62.5
SWEP.ViewModelFlip         = false
SWEP.UseHands              = false
-- SWEP.ViewModel             = "models/weapons/c_slam.mdl"
-- SWEP.WorldModel            = "models/santosrp/key/car_key.mdl"
SWEP.ViewModel             = ""
SWEP.WorldModel            = ""
SWEP.ShowViewModel         = false
SWEP.ShowWorldModel        = false

local bell                 = {
	sound = Sound("ambient/alarms/warningbell1.wav"),
	delay = 5
}

local knock                = {
	sound = Sound("physics/wood/wood_crate_impact_hard2.wav"),
	delay = 0.1
}

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:PreDrawViewModel(vm)
	vm:SetMaterial("engine/occlusionproxy")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.5)
	self:SetNextSecondaryFire(CurTime() + 0.5)
	if SERVER then
		self.Owner:LagCompensation(true)
		local ent = self.Owner:GetEyeTrace().Entity
		self.Owner:LagCompensation(false)

		if not ent or not ent:IsProperty() then
			return
		end

		if self.Owner:GetPos():DistToSqr(ent:GetPos()) > 10000 then
			return
		end

		if not mp.properties.has_access(self.Owner, ent) then
			if not self.next_knock or self.next_knock < CurTime() then
				self.Owner:EmitSound(knock.sound, 60, math.random(90, 110))
				self.next_knock = CurTime() + knock.delay
			end
			return
		end

		if ent:GetNetVar("mp.DoorIsLocked") then return end

		mp.properties.close_door(ent)

		mp.util.Notify(self.Owner, 0, "Вы закрыли дверь!")
		ent:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav", 70, 100, 1, CHAN_AUTO)
	end
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.5)
	self:SetNextSecondaryFire(CurTime() + 0.5)
	if SERVER then
		self.Owner:LagCompensation(true)
		local ent = self.Owner:GetEyeTrace().Entity
		self.Owner:LagCompensation(false)

		if not ent or not ent:IsProperty() then
			return false
		end

		if self.Owner:GetPos():DistToSqr(ent:GetPos()) > 10000 then
			return
		end

		if not mp.properties.has_access(self.Owner, ent) then
			return
		end

		if not ent:GetNetVar("mp.DoorIsLocked") then return end

		mp.properties.open_door(ent)

		mp.util.Notify(self.Owner, 0, "Вы открыли дверь!")
		ent:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav", 70, 100, 1, CHAN_AUTO)
	end
end
