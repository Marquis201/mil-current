AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
	self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)

	self:SetNextPrimaryFire(CurTime() + 1)

	local tr = self.Owner:GetEyeTrace()

	if (not tr.Entity:IsPlayer()) then return end
	if tr.Entity:isHandcuffed() then return end
	if tr.Entity:InVehicle() then tr.Entity:ExitVehicle() end

	if tr.Entity:Team() == TEAM_ADMIN then
		return mp.util.Notify(self.Owner, NOTIFY_ERROR,
			"На администратора нельзя надеть наручники.")
	end

	if (self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 120) and (not tr.Entity:isHandcuffed()) then
		tr.Entity:HandCuff(self:GetOwner())
	end
end

function SWEP:SecondaryAttack()
	local tr = self.Owner:GetEyeTraceNoCursor()

	if (not tr.Entity:IsPlayer()) then return end
	if tr.Entity:InVehicle() then tr.Entity:ExitVehicle() end

	if (self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 120) and (tr.Entity:isHandcuffed()) then
		if tr.Entity:isCarried() then
			timer.Create("UnCollisionPlayer_" .. tr.Entity:SteamID64(), 1, 1, function()
				if IsValid(tr.Entity) then
					tr.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
				end
			end)
		end

		tr.Entity:UnHandCuff()
	end
end

function SWEP:Reload()
	if not self.NextReload then self.NextReload = 0 end
	if self.NextReload > CurTime() then return end

	local tr = self:GetOwner():GetEyeTraceNoCursor()


	self.NextReload = CurTime() + 1
end
