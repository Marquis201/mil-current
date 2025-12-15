EFFECT.InValid = false

function EFFECT:FindTracer(wep)
	if not IsValid(wep) then return "weapon_tracers" end

	if not wep.TracerParticleName then
		local ammotype = (wep.Primary.Ammo or wep:GetPrimaryAmmoType()):lower()
		local guntype = (wep.Type or wep:GetHoldType()):lower()

		if guntype:find("sniper") or ammotype:find("sniper") or guntype:find("dmr") or ammotype:find("dmr") then
			wep.TracerParticleName = "weapon_tracers_rifle"
		elseif guntype:find("ar2") or ammotype:find("rifle") then
			wep.TracerParticleName = "weapon_tracers_assrifle"
		elseif ammotype:find("pist") or guntype:find("pist") then
			wep.TracerParticleName = "weapon_tracers_pistol"
		elseif ammotype:find("357") or guntype:find("357") then
			wep.TracerParticleName = "weapon_tracers_pistol"
		elseif ammotype:find("smg1") or guntype:find("smg1") then
			wep.TracerParticleName = "weapon_tracers_smg"
		elseif ammotype:find("buckshot") or ammotype:find("shotgun") or guntype:find("shot") then
			wep.TracerParticleName = "weapon_tracers_shot"
		else
			wep.TracerParticleName = "weapon_tracers"
		end
	end

	return wep.TracerParticleName
end

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	self.ParticleName = self:FindTracer(self.WeaponEnt)
	--print(self.ParticleName)
	
	if self.WeaponEnt.Silenced then
		self.ParticleName = "weapon_tracers_silenced"
	end
	
	if not IsValid(self.WeaponEnt) then return end
	
	if (self.WeaponEnt.Akimbo) then
		self.Attachment = 1 + (game.SinglePlayer() and self.WeaponEnt:GetNW2Int("AnimCycle") or self.WeaponEnt.AnimCycle)
	else
		self.Attachment = data:GetAttachment()
	end
	
	self.Position = self:GetTracerShootPos(data:GetStart(), self.WeaponEnt, self.Attachment)

	if IsValid(self.WeaponEnt.Owner) then
		if self.WeaponEnt.Owner == LocalPlayer() then
			if not self.WeaponEnt.Owner:GetViewEntity() then
				ang = self.WeaponEnt.Owner:EyeAngles()
				ang:Normalize()
				--ang.p = math.max(math.min(ang.p,55),-55)
				self.Forward = ang:Forward()
			else
				self.WeaponEnt = self.WeaponEnt.Owner:GetViewModel()
			end
			--ang.p = math.max(math.min(ang.p,55),-55)
		else
			ang = self.WeaponEnt.Owner:EyeAngles()
			ang:Normalize()
			self.Forward = ang:Forward()
		end
	end

	self.EndPos = data:GetOrigin()
	--util.ParticleTracerEx(self.ParticleName, self.StartPos, self.EndPos, false, self:EntIndex(), self.Attachment)
	local pcf = CreateParticleSystem(self.WeaponEnt, self.ParticleName, PATTACH_POINT, self.Attachment)
	if IsValid(pcf) then
		pcf:SetControlPoint(0,self.Position)
		pcf:SetControlPoint(1,self.EndPos)
		pcf:StartEmission()
	end
	timer.Simple(3.0, function()
		if IsValid(pcf) then
			pcf:StopEmissionAndDestroyImmediately()
		end
	end)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	if self.InValid then return false end
end