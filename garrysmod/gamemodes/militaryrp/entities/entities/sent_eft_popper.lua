AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "EFT Popper"
ENT.Category = "Fun + Games"
ENT.Author = "Darsu"
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.AutomaticFrameAdvance = false

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/darsu_eft/Shooting_range_popper.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)

		self.ResetTime = 0
	end

	function ENT:PopDown(forced)
		self:ResetSequence("down")
		self:EmitSound(
			table.Random({ "darsu_eft/arena_shooting_range_popper_fold.wav",
				"darsu_eft/arena_shooting_range_popper_fold2.wav", "darsu_eft/arena_shooting_range_popper_fold3.wav" }),
			45)
		if forced then self.ResetTime = math.huge end
		-- self:SetSolid(SOLID_NONE)
	end

	function ENT:PopUp()
		self:ResetSequence("up")
		-- self:SetSolid(SOLID_VPHYSICS)
		self:EmitSound("darsu_eft/shooting_range_popper_unfold.wav", 45)
		self.ResetTime = CurTime() + 0.2
	end

	function ENT:OnTakeDamage(dmginfo)
		local attacker = dmginfo:GetAttacker()

		if IsValid(self.active_tir) and self.active_tir:GetNetVar("mp.PlayerTir") then
			if IsValid(attacker) and attacker == self.active_tir and attacker.tir_count and attacker.tir_count > 0 and not self.complete_tir then
				local wep = dmginfo:GetWeapon()
				if self.tir_weapon and not IsValid(wep) or wep:GetClass() ~= self.tir_weapon then return end

				attacker.tir_count = attacker.tir_count - 1

				self:PopDown()
				self.complete_tir = true

				net.Start("tfaHitmarker", true)
				net.Send(attacker)

				if attacker.tir_count <= 0 then
					attacker:CompleteTir()
					mp.util.Notify(attacker, NOTIFY_HINT, "Вы поразили все мишени!")
					attacker.NextTirStart = CurTime() + 30

					if attacker.tir_weapon then
						attacker:StripWeapon(attacker.tir_weapon)
					end

					local t = nw.GetGlobal("mp.Tir") or {}

					if t[attacker:GetFaction()] and t[attacker:GetFaction()].steamid == attacker:SteamID64() then
						for k, v in pairs(mp.Territory.Tir) do
							if v.tir_id == t[attacker:GetFaction()].id then
								v.active_tir = nil
							end
						end

						t[attacker:GetFaction()] = nil
						nw.SetGlobal("mp.Tir", t)
					end
				end
			end

			return
		end

		if self.ResetTime < CurTime() then
			self:PopDown()
			self.ResetTime = CurTime() + 4

			timer.Create("UPEft." .. self:EntIndex(), 4, 1, function()
				if self:IsValid() then
					self:PopUp()
				end
			end)
		end
	end
else
	ENT.AutomaticFrameAdvance = true

	local complex_off = Vector(0, 0, 20)
	local simple_off = Vector(0, 0, 50)

	local ang = Angle(0, 90, 90)
	local pos
	local title_font

	function ENT:Draw()
		title_font = title_font or mp.font("100:Futura PT Book")
		self:DrawModel()

		local pl = LocalPlayer()

		if !pl:GetNetVar("mp.PlayerTir") or self:GetSequence() ~= 3 then return end

		local dist = pl:GetPos():Distance(self:GetPos())

		pos = self:GetPos() + simple_off
		ang.y = (pl:EyeAngles().y - 90)

		ang.x = 180

		cam.Start3D2D(pos, ang, 0.15)

		draw.SimpleText("▲", title_font, 0, 100 + TimedCos(0.5, -25, 50, CurTime()), mp.Color.RED, 1, 1)

		cam.End3D2D()
	end
end



function ENT:Think()
	self:NextThink(CurTime())
	self:FrameAdvance()

	if SERVER then
		if not IsValid(self.active_tir) and not timer.Exists("UPEft." .. self:EntIndex()) and self:GetSequence() == 2 then
			self:PopUp()
			self.active_tir = nil
		elseif IsValid(self.active_tir) and not self.active_tir:GetNetVar("mp.PlayerTir") and not timer.Exists("UPEft." .. self:EntIndex()) and self:GetSequence() == 2 then
			self:PopUp()
			self.active_tir = nil
		end
	end


	return true
end
