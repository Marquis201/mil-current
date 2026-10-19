include('shared.lua')

local simple_off = Vector(0, 0, 30)

local ang = Angle(0, 90, 90)
local pos

local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
local ColorOutlineRed = ColorAlpha(mp.Color.RED, 25)

local title_font
local title_font2
local LerpPos, LerpAlpha = 0, 0

function ENT:Draw()
	title_font = title_font or mp.font("75:Futura PT Book")
	title_font2 = title_font2 or mp.font("50:Futura PT Book")

	local pl = LocalPlayer()
	local dist = pl:GetPos():Distance(self:GetPos())

	self:DrawModel()

	pos = self:GetPos() + simple_off

	ang.y = (pl:EyeAngles().y - 90)

	LerpAlpha = Lerp(FrameTime() * 5, LerpAlpha, (dist > 300) and 0 or 300)
	LerpPos = Lerp(FrameTime() * 4, LerpPos, (dist > 300) and 150 or 0)

	if LerpAlpha <= 1 then return end

	surface.SetFont(title_font)
	local tw, th = surface.GetTextSize(self.PrintName)

	tw = tw + 50
	th = th + 30

	local amount = self:GetNWInt("perk_armor_amount") or 0
	local wide = ((tw - 6) / 10) * amount
	local time = self:GetNWFloat("perk_armor_remove")

	cam.Start3D2D(pos, ang, 0.05)

	if time and time > CurTime() then
		local title2 = "Самоуничтожение: " ..
			string.FormattedTime(time - CurTime(), "%02i:%02i")

		surface.SetFont(title_font2)
		local tw2, th2 = surface.GetTextSize(title2)

		tw2 = tw2 + 50
		th2 = th2 + 30

		draw.RoundedBox(0, -tw2 / 2, LerpPos, tw2, th2, ColorAlpha(ColorBackground_100, LerpAlpha / 2))

		surface.SetDrawColor(ColorAlpha(ColorOutlineRed, LerpAlpha / 2))
		surface.DrawOutlinedRect(-tw2 / 2, LerpPos, tw2, th2, 3)

		draw.SimpleText(title2, title_font2, 0,
			th2 / 2 + LerpPos, ColorAlpha(mp.Color.RED, LerpAlpha), 1, 1)
	end

	draw.RoundedBox(0, -tw / 2, LerpPos - 130, tw, th + 10, ColorAlpha(ColorBackground_100, LerpAlpha / 2))
	draw.RoundedBox(0, -tw / 2 + 3, LerpPos + th - 3 - 130, tw - 6, 10, ColorAlpha(ColorBackground_100, LerpAlpha / 2))
	draw.RoundedBox(0, -tw / 2 + 3, LerpPos + th - 3 - 130, wide, 10, ColorAlpha(mp.Color.WHITE, LerpAlpha / 2))

	surface.SetDrawColor(ColorAlpha(ColorOutline, LerpAlpha / 2))
	surface.DrawOutlinedRect(-tw / 2, LerpPos - 130, tw, th + 10, 3)

	draw.SimpleText(self.PrintName, title_font, 0, th / 2 + LerpPos - 130, ColorAlpha(mp.Color.BASE, LerpAlpha), 1, 1)

	cam.End3D2D()
end
