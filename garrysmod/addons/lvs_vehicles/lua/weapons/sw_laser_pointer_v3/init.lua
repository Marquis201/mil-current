include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function SWEP:PrimaryAttack()
	if self.Owner:KeyDown(IN_ATTACK2) then
		if IsValid(self:GetNWEntity("PairedObj")) then
			if self:GetNWEntity("PairedObj").SWBombV3 and self:GetNWEntity("PairedObj").HaveGuidance then
				local tr = self.Owner:GetEyeTrace()
				self:GetNWEntity("PairedObj").GuidanceActive = true
				self:GetNWEntity("PairedObj").target = tr.Entity
				self:GetNWEntity("PairedObj").targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
				self:SetNWVector("TarPos", tr.HitPos )
				self:EmitSound("sw/misc/point.wav")
				print(tr.HitPos)
			end		
			if IsValid(self:GetNWEntity("PairedObj"):GetNWEntity("Missile")) then
				if self:GetNWEntity("PairedObj"):GetNWEntity("Missile").SWBombV3 and self:GetNWEntity("PairedObj"):GetNWEntity("Missile").HaveGuidance then
					local tr = self.Owner:GetEyeTrace()
					self:SetNWEntity("Projectile",self:GetNWEntity("PairedObj"):GetNWEntity("Missile"))
					self:GetNWEntity("PairedObj"):GetNWEntity("Missile").GuidanceActive = true
					self:GetNWEntity("PairedObj"):GetNWEntity("Missile").LaserGuided = false
					self:GetNWEntity("PairedObj"):GetNWEntity("Missile").target = tr.Entity
					self:GetNWEntity("PairedObj"):GetNWEntity("Missile").targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
					self:SetNWVector("TarPos", tr.HitPos )
					self:EmitSound("sw/misc/point.wav")
					print(tr.HitPos)
				end
			end
		end
	end
	
	if self.Owner:KeyDown(IN_ATTACK2) then return end	
	local tr = self.Owner:GetEyeTrace()
	if IsValid(tr.Entity) and tr.StartPos:DistToSqr(tr.HitPos) < self.MaxPairDistance then
		if ((tr.Entity.LVS or tr.Entity.LFS) and tr.Entity.Pairable ) or (tr.Entity.SWBombV3 and tr.Entity.HaveGuidance) then
			if !IsValid(self:GetNWEntity("PairedObj")) then
				tr.Entity:SetNWBool("HaveDesignator",true)
				self:SetNWEntity("PairedObj",tr.Entity)
				self:SetNWBool("Paired",true)
				self.Owner:PrintMessage(HUD_PRINTCENTER,"You have paired target designator with:"..self:GetNWEntity("PairedObj").PrintName)
			else
				return
			end
		end
	end
end
function SWEP:SecondaryAttack()
end
function SWEP:CanReload(ct)
	return self.NextReload <= ct
end
function SWEP:Reload()
	local ct = CurTime()
	if not self:CanReload(ct) then return end
	self.NextReload = ct + 0.3
end
function SWEP:OnRemove()
	if IsValid(self) and IsValid(self:GetNWEntity("PairedObj")) then
		self:GetNWEntity("PairedObj"):SetNWBool("HaveDesignator",false)
		self:SetNWEntity("PairedObj",nil)
		self:SetNWBool("Paired",false)
	end
end