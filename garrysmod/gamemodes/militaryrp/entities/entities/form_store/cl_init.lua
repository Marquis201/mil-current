include('shared.lua')

local complex_off = Vector(0, 0, 20)
local simple_off = Vector(0, 0, 45)

local ang = Angle(0, 90, 90)
local pos

local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)

local title_font
local LerpPos, LerpAlpha = 0, 0

function ENT:Draw()
	title_font = title_font or mp.font("75:Futura PT Book")

	local pl = LocalPlayer()
	local dist = pl:GetPos():Distance(self:GetPos())


	self:DrawModel()

	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	if bone then
		pos = self:GetBonePosition(bone) + complex_off
	else
		pos = self:GetPos() + simple_off
	end

	ang.y = (pl:EyeAngles().y - 90)

	LerpAlpha = Lerp(FrameTime() * 5, LerpAlpha, (dist > 300) and 0 or 300)
	LerpPos = Lerp(FrameTime() * 4, LerpPos, (dist > 300) and 150 or 0)

	if LerpAlpha <= 1 then return end

	surface.SetFont(title_font)
	local tw, th = surface.GetTextSize(self.PrintName)

	tw = tw + 50
	th = th + 30

	cam.Start3D2D(pos, ang, 0.05)

	draw.RoundedBox(0, -tw / 2, LerpPos, tw, th, ColorAlpha(ColorBackground_100, LerpAlpha / 2))

	surface.SetDrawColor(ColorAlpha(ColorOutline, LerpAlpha / 2))
	surface.DrawOutlinedRect(-tw / 2, LerpPos, tw, th, 3)

	draw.SimpleText(self.PrintName, title_font, 0, th / 2 + LerpPos, ColorAlpha(mp.Color.BASE, LerpAlpha), 1, 1)

	cam.End3D2D()
end

