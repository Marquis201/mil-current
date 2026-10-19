include("shared.lua")
local posX = {
	0.29,
	0.5,
	0.71,
	0.71,
	0.71,
	0.5,
	0.29,
	0.29,
}
local posY = {
	0.29,
	0.29,
	0.29,
	0.5,
	0.71,
	0.71,
	0.71,
	0.5,
}
local COLOR_GREEN = Color(0, 255, 0, 255)
local COLOR_BLACK = Color(0, 0, 0, 255)
local COLOR_WHITE = Color(255, 255, 255, 255)
local COLOR_WHITE_HOVERED = Color(200, 200, 200, 150)
local HOOK_ADDED = false
local LANGUAGE
local ints = {
	[8] = 1,
	[2] = 2,
	[4] = 3,
}

local icon_misc = Material("icons/mis.png")
local icon_plane = Material("icons/plane.png")
local mat_color = Material("pp/colour")

local function DrawCircle(X, Y, radius)
	local segmentdist = 360 / (2 * math.pi * radius / 2)
	for a = 0, 360, segmentdist do
		surface.DrawLine(X + math.cos(math.rad(a)) * radius, Y - math.sin(math.rad(a)) * radius,
			X + math.cos(math.rad(a + segmentdist)) * radius, Y - math.sin(math.rad(a + segmentdist)) * radius)
	end
end
function SWEP:DrawHUD()
	local X = ScrW()
	local Y = ScrH()
	if self.Zoom.Val == 0 then
		local tr = self.Owner:GetEyeTrace()
		if IsValid(tr.Entity) and tr.StartPos:DistToSqr(tr.HitPos) < self.MaxPairDistance then
			if (tr.Entity.LVS or tr.Entity.LFS or (tr.Entity.SWBombV3 and tr.Entity.HaveGuidance)) and tr.Entity:GetNWBool("HaveDesignator") == false then
				if ! IsValid(self:GetNWEntity("PairedObj")) then
					draw.DrawText("Click to pair designator", "Trebuchet24", X * 0.5, Y * 0.25, color_white,
						TEXT_ALIGN_CENTER)
				else
					return
				end
			end
		end
	end
	if IsValid(self:GetNWEntity("Projectile")) then
		local Pos = self:GetNWVector("TarPos"):ToScreen()
		surface.SetDrawColor(255, 255, 255, self.Zoom.Val * 255)
		DrawCircle(Pos.x, Pos.y, 10)
		local Pos2 = self:GetNWEntity("Projectile"):GetPos():ToScreen()
		surface.SetDrawColor(255, 255, 255, self.Zoom.Val * 255)
		surface.SetMaterial(icon_misc)
		surface.DrawTexturedRect(Pos2.x, Pos2.y, 25, 25)
	end
	if IsValid(self:GetNWEntity("PairedObj")) and self:GetNWEntity("PairedObj").SWBombV3 then
		local Pos = self:GetNWVector("TarPos"):ToScreen()
		surface.SetDrawColor(255, 255, 255, self.Zoom.Val * 255)
		DrawCircle(Pos.x, Pos.y, 10)
		local Pos2 = self:GetNWEntity("PairedObj"):GetPos():ToScreen()
		surface.SetDrawColor(255, 255, 255, self.Zoom.Val * 255)
		surface.SetMaterial(icon_misc)
		surface.DrawTexturedRect(Pos2.x, Pos2.y, 25, 25)
	end
	if IsValid(self:GetNWEntity("PairedObj")) and not self:GetNWEntity("PairedObj").SWBombV3 then
		local Pos = self:GetNWEntity("PairedObj"):GetPos():ToScreen()
		surface.SetDrawColor(255, 255, 255, self.Zoom.Val * 255)
		surface.SetMaterial(icon_plane)
		surface.DrawTexturedRect(Pos.x, Pos.y, 25, 25)
	end
	surface.SetDrawColor(0, 0, 0, self.Zoom.Val * 255)
	surface.SetTexture(surface.GetTextureID("models/sw/shared/sights/binoculars"))
	surface.DrawTexturedRect(0, -(X - Y) / 2, X, X)
	local tr = self.Owner:GetEyeTrace()
	local range = (math.ceil(100 * (tr.StartPos:Distance(tr.HitPos) * 0.024)) / 100)
	if tr.HitSky then
		range = "-"
	else
		range = range .. "m"
	end
	surface.SetTextColor(255, 255, 255, self.Zoom.Val * 255)
	surface.SetTextPos((X * 0.165), (Y / 2))
	surface.DrawText("Range: " .. range)
	surface.SetTextPos((X * 0.165), (Y / 2) + 16)
	surface.DrawText("X: " .. (math.ceil(100 * tr.HitPos.x)) / 100)
	surface.SetTextPos((X * 0.165), (Y / 2) + 32)
	surface.DrawText("Y: " .. (math.ceil(100 * tr.HitPos.y) / 100))
	surface.SetTextPos((X * 0.165), (Y / 2) + 48)
	surface.DrawText("Z: " .. (math.ceil(100 * tr.HitPos.z) / 100))

	if self:GetNWBool("NVG") == true then
		surface.SetTextPos((X * 0.165), (Y / 2) + 64)
		surface.DrawText("NVG: ON")
		local dlight = DynamicLight(self:EntIndex())
		dlight.r = self.Zoom.Val * 255
		dlight.g = self.Zoom.Val * 255
		dlight.b = self.Zoom.Val * 255
		dlight.minlight = 0
		dlight.style = 0
		dlight.Brightness = self.Zoom.Val * 0.1
		dlight.Pos = EyePos()
		dlight.Size = self.Zoom.Val * 2048
		dlight.Decay = self.Zoom.Val * 10000
		dlight.DieTime = CurTime() + 0.1
		render.UpdateScreenEffectTexture()
		mat_color:SetTexture("$fbtexture", render.GetScreenEffectTexture())
		mat_color:SetFloat("$pp_colour_addr", -self.Zoom.Val * 255)
		mat_color:SetFloat("$pp_colour_addg", 0)
		mat_color:SetFloat("$pp_colour_addb", 0)
		mat_color:SetFloat("$pp_colour_mulr", 0)
		mat_color:SetFloat("$pp_colour_mulg", 0)
		mat_color:SetFloat("$pp_colour_mulb", 0)
		mat_color:SetFloat("$pp_colour_brightness", self.Zoom.Val * 0.01)
		mat_color:SetFloat("$pp_colour_contrast", 1 + self.Zoom.Val * 5)
		mat_color:SetFloat("$pp_colour_colour", 1)
		render.SetMaterial(mat_color)
		render.DrawScreenQuad()
		DrawBloom(self.Zoom.Val * 0.5, self.Zoom.Val * 1, self.Zoom.Val * 10, self.Zoom.Val * 10, self.Zoom.Val * 2,
			self.Zoom.Val * 1, self.Zoom.Val * 1, self.Zoom.Val * 1, self.Zoom.Val * 1)
	else
		surface.SetTextPos((X * 0.165), (Y / 2) + 64)
		surface.DrawText("NVG: OFF")
	end
end

function SWEP:CalcView(ply, pos, ang, fov)
	return pos, ang, fov - (self.Zoom.Val * self.Zoom.FOV)
end

function SWEP:AdjustMouseSensitivity()
	return self.Owner:KeyDown(IN_ATTACK2) and 0.1 or 1
end

function SWEP:CalcViewModelView(ViewModel, OldEyePos)
	if self.Zoom.Val > 0.8 then
		return Vector(0, 0, 0)
	else
		return OldEyePos - Vector(0, 0, 1.3)
	end
end

function SWEP:Think()
	local keydown = self.Owner:KeyDown(IN_ATTACK2)
	self.Zoom.Val = math.Clamp(self.Zoom.Val + (keydown and self.Zoom.Rate or -self.Zoom.Rate), 0, 1)
	if keydown and not self.IsZooming then
		self.IsZooming = true
		self.IsUnZooming = false
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	elseif ! keydown and not self.IsUnZooming and self.IsZooming then
		self.IsZooming = false
		self.IsUnZooming = true
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	if keydown then
		local Zoom = self.Zoom.FOV
		local ZoomSwitch = self.Owner:KeyDown(IN_SPEED)
		if self.OldZoomSwitch ~= ZoomSwitch then
			if ZoomSwitch and Zoom == 70 then
				self.Zoom.FOV = 40
			elseif ZoomSwitch and Zoom == 40 then
				self.Zoom.FOV = 70
			end
			self.OldZoomSwitch = ZoomSwitch
		end
		local NVGSwitch = self.Owner:KeyDown(IN_ZOOM)
		if self.OldNVGSwitch ~= NVGSwitch then
			if NVGSwitch and self:GetNWBool("NVG") == true then
				self:SetNWBool("NVG", false)
				self:EmitSound("sw/misc/nv_off.wav")
			elseif NVGSwitch and self:GetNWBool("NVG") == false then
				self:SetNWBool("NVG", true)
				self:EmitSound("sw/misc/nv_on.wav")
			end
			self.OldNVGSwitch = NVGSwitch
		end
	end
end
