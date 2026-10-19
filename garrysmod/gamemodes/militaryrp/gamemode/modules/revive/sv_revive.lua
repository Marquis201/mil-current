local util = util
local mp = mp
local hook = hook
local IsValid = IsValid
local CurTime = CurTime
local timer = timer
local math_Clamp = math.Clamp

local nw = { "Spawn" }

for k, v in ipairs(nw) do
	util.AddNetworkString("mp.Revive." .. v)
end

net.Receive("mp.Revive.Spawn", function(_, pl)
	if not IsValid(pl) or pl:Alive() then return end
	local data = pl:GetReviveInfo()

	if not data or not data.time or data.time > CurTime() then return end

	pl:SetNetVar("revive.Info", nil)
	pl:Spawn()
end)

function PLAYER:Revive(swep)
	if (self:Alive() or not IsValid(self.RevivalRagdoll) or not self.CannotBeRevived) then return end
	if self:GetReviveInfo() and self:GetReviveInfo().time < CurTime() then return end
	if self.revive_count and self.revive_count <= 0 then return end

	self.BeingRevived = true
	self.ReviveSwep = swep
	self:Spawn()
	local pos = self.RevivalRagdoll:GetPos()
	self:SetPos(pos + Vector(0, 0, 1))
	self:SetEyeAngles(self.ReviveAng)
	self:SetVelocity(self.RevivalRagdoll:GetPhysicsObject():GetVelocity())

	if self:GetCollisionGroup() ~= COLLISION_GROUP_WEAPON then
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		timer.Simple(2, function()
			if IsValid(self) then
				self:SetCollisionGroup(0)
			end
		end)
	end

	local stats = mp.body_stats
	local val = swep and .5 or .25
	self.Head = stats.head * val
	self.Torso = stats.torso * val
	self.LeftArm = stats.l_arm * val
	self.RightArm = stats.r_arm * val
	self.LeftLeg = stats.l_leg * val
	self.RightLeg = stats.r_leg * val

	self.Blooding = false
	self.Fracture = false
	self.Concussion = false
	self.Burns = false

	self:HPUpdate()
end

hook.Add("PlayerLoadout", "mp.Revive.PlayerSpawn", function(pl)
	if (not pl.BeingRevived or not IsValid(pl)) then
		pl.revive_count = 3
		return
	end

	pl.revive_count = pl.revive_count or 0
	pl.revive_count = pl.revive_count - 1

	pl.BeingRevived = nil
	pl:SetHealth(10)

	for k, v in pairs(pl.ReviveWeapons or {}) do
		pl:Give(v, true)
	end

	if pl.ReviveActiveWeapon then
		pl:SelectWeapon(pl.ReviveActiveWeapon)
	end

	timer.Simple(1, function()
		if IsValid(pl) then
			local ammos = pl.RevivalPreviousAmmo or {}
			for k, v in pairs(ammos) do
				pl:SetAmmo(v, k)
			end
		end
	end)


	if pl.ReviveSwep then
		pl:SetHealth(mp.config.player_stats.start_health / 2)
	end
end)

hook.Add("KeyPress", "mp.Revive.Use", function(pl, key)
	if (key == IN_USE) then
		local ent = pl:GetEyeTrace().Entity

		if ent and ent.revive and IsValid(ent.owner) and not ent.owner:Alive() and pl:GetPos():Distance(ent:GetPos()) < 150 and not ent.revive_use and not pl.revive_ent and not timer.Exists("RevivePlayer." .. ent:EntIndex()) then
			if ent.owner:GetReviveInfo() and ent.owner:GetReviveInfo().time < CurTime() then
				mp.util.Notify(pl, NOTIFY_ERROR, "Игрок уже мертв")
				return
			end
			if ent.owner.revive_count and ent.owner.revive_count <= 0 then
				mp.util.Notify(pl, NOTIFY_ERROR, "Игрок уже мёртв")
				return
			end

			pl.revive_ent = ent
			ent.revive_use = pl

			pl:SetNetVar("isRevive", CurTime() + mp.Revive.time)
			ent.owner:SetNetVar("isRevive", CurTime() + mp.Revive.time)

			timer.Create("RevivePlayer." .. ent:EntIndex(), mp.Revive.time, 1, function()
				if IsValid(pl) then
					pl:SetNetVar("isRevive", nil)
					pl.revive_ent = nil
				end

				if IsValid(ent) then
					if IsValid(ent.revive_use) then
						local reviver = ent.revive_use

						if reviver:Alive() and reviver:GetPos():Distance(ent:GetPos()) < 150 then
							ent.owner:Revive()
						end
					end

					if IsValid(ent.owner) then
						ent.owner:SetNetVar("isRevive", nil)
					end
					ent.revive_use = nil
				end
			end)
		end
	end
end)

hook.Add("KeyRelease", "mp.Revive.Use", function(pl, key)
	if (key == IN_USE) then
		if IsValid(pl.revive_ent) and pl:GetRevive() then
			pl:SetNetVar("isRevive", nil)
			local ent = pl:GetEyeTrace().Entity

			if IsValid(ent.owner) then
				ent.owner:SetNetVar("isRevive", nil)
				ent.revive_use = nil

				if timer.Exists("RevivePlayer." .. ent:EntIndex()) then
					timer.Remove("RevivePlayer." .. ent:EntIndex())
				end
			end

			pl.revive_ent = nil
		end
	end
end)
