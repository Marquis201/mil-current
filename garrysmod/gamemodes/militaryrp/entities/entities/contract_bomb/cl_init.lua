include('shared.lua')

local SetClipboardText = SetClipboardText
local ColorAlpha = ColorAlpha
local Color = Color
local vgui = vgui
local draw = draw
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime
local no_close_onedit = {}
local Vector, Angle = Vector, Angle
local mp = mp

local title_text = "Детонатор"

local C_B_245 = ColorAlpha(mp.Color.BLACK, 245)
local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_B_155 = ColorAlpha(mp.Color.BLACK, 155)
local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)
local C_B_55 = ColorAlpha(mp.Color.BLACK, 55)

local C_W_5 = ColorAlpha(mp.Color.WHITE, 5)
local C_W_10 = ColorAlpha(mp.Color.WHITE, 10)
local C_W_15 = ColorAlpha(mp.Color.WHITE, 15)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)

local C_R_100 = ColorAlpha(mp.Color.RED, 100)
local C_R_25 = ColorAlpha(mp.Color.RED, 25)
local C_R_10 = ColorAlpha(mp.Color.RED, 10)

local C_G_25 = ColorAlpha(mp.Color.GREEN, 25)
local C_G_10 = ColorAlpha(mp.Color.GREEN, 10)

local C_BL_25 = ColorAlpha(mp.Color.BLUE, 25)
local C_BL_10 = ColorAlpha(mp.Color.BLUE, 10)

local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)

local C_B_75 = ColorAlpha(mp.Color.BLACK, 75)

local C_BT_20 = ColorAlpha(mp.Color.BASE_TO, 20)

local item_font = mp.font("20:Montserrat Light")
local rank_font = mp.font("16:Montserrat Light")
local search_font = mp.font("20:DIN Pro Regular")
local list_font = mp.font("16:DIN Pro Regular")
local button_font = mp.font("20:Futura PT Medium")
local info_fonts = mp.font("18:DIN Pro Regular")
local name_font = mp.font("25:Futura PT Light")
local choose_font = mp.font("20:mr_ApexMk3MediumG")
local frags_font = mp.font("20:mr_ApexMk3ExtraLightG")
local name_server_font = mp.font("70:Futura PT Light")
local time_font = mp.font("25:Futura PT Light")

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

	local text = self.PrintName .. ": [E] взаимодействие"
	surface.SetFont(title_font)
	local tw, th = surface.GetTextSize(text)

	tw = tw + 50
	th = th + 30

	cam.Start3D2D(pos, ang, 0.05)

	draw.RoundedBox(0, -tw / 2, LerpPos, tw, th, ColorAlpha(ColorBackground_100, LerpAlpha / 2))

	surface.SetDrawColor(ColorAlpha(ColorOutline, LerpAlpha / 2))
	surface.DrawOutlinedRect(-tw / 2, LerpPos, tw, th, 3)

	draw.SimpleText(text, title_font, 0, th / 2 + LerpPos, ColorAlpha(mp.Color.BASE, LerpAlpha), 1, 1)

	cam.End3D2D()
end

local selectText = ""
local BombPanel
local btns = {
	{
		name = "1",
	},

	{
		name = "2",
	},

	{
		name = "3",
	},

	{
		name = "4",
	},

	{
		name = "5",
	},

	{
		name = "6",
	},

	{
		name = "7",
	},

	{
		name = "8",
	},

	{
		name = "9",
	},

	{
		name = "✔",
		color = mp.Color.GREEN,
		click = function(text)
			net.Start("mp.ContractBombOpen")
			net.WriteInt(math.Clamp(text, 111111, 999999), 32)
			net.SendToServer()

			if IsValid(BombPanel) then
				BombPanel:AlphaTo(0, 0.2, 0)
				BombPanel:MoveTo(ScrW() * .5 - BombPanel:GetWide() / 2, ScrH() / 2, 0.1, 0.1, 0.9, function()
					BombPanel:Remove()
					BombPanel = nil
				end)
			end
		end
	},

	{
		name = "0",
	},

	{
		name = "✖",
		color = mp.Color.RED,
		click = function(text, panel)
			selectText = ""
			panel:SetText("")
		end
	},
}

net.Receive("mp.ContractBombOpen", function()
	local pl = LocalPlayer()
	if not pl then return end

	if IsValid(BombPanel) then
		BombPanel:AlphaTo(0, 0.2, 0)
		BombPanel:MoveTo(scrw * .5 - BombPanel:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
			BombPanel:Remove()
			BombPanel = nil
		end)
	end

	surface.PlaySound(mp.Sound.DEPLOY)

	local scrw, scrh = ScrW(), ScrH()
	selectText = ""

	BombPanel = vgui.Create("EditablePanel")
	BombPanel:SetSize(225, 400)
	BombPanel:SetPos(scrw * .5 - BombPanel:GetWide() / 2, scrh / 2)
	BombPanel:MoveTo(scrw * .5 - BombPanel:GetWide() / 2, scrh * .5 - BombPanel:GetTall() / 2, 0.5, 0.1, 0.1)
	BombPanel:MakePopup()
	BombPanel:SetAlpha(0)
	BombPanel:AlphaTo(255, 0.3, 0.1)
	BombPanel.Paint = function(self, w, h)
		mp.PanelBlur(self, 1)

		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
		draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
		mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

		mp.Text(title_text, search_font, w / 2, 20, mp.Color.BASE, 1, 1)
	end

	local ClosePanel = vgui.Create("DButton", BombPanel)
	ClosePanel:SetSize(20, 20)
	ClosePanel:SetText("")
	ClosePanel.Hover = 0
	ClosePanel:SetPos(BombPanel:GetWide() - ClosePanel:GetWide() - 15, 10)
	ClosePanel.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 75)
		end

		mp.Icon(0, 0, 20, 20, mp.Material.CLOSE, ColorAlpha(mp.Color.BASE, self.Hover))
	end

	ClosePanel.OnCursorEntered = function()
		surface.PlaySound(mp.Sound.CLICK)
	end

	ClosePanel.DoClick = function(self)
		BombPanel:AlphaTo(0, 0.2, 0)
		BombPanel:MoveTo(scrw * .5 - BombPanel:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
			BombPanel:Remove()
			BombPanel = nil
		end)

		surface.PlaySound(mp.Sound.CLICK_10)
	end

	local Display = vgui.Create("DLabel", BombPanel)
	Display:Dock(TOP)
	Display:SetText(selectText)
	Display:SetFont(search_font)
	Display:DockMargin(10, 50, 10, 10)
	Display:SetContentAlignment(6)
	Display:SetTall(40)
	Display.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
	end

	local List = BombPanel:Add("DIconLayout")
	List:Dock(TOP)
	List:SetSpaceY(5)
	List:SetSpaceX(5)
	List:DockMargin(10, 0, 10, 10)

	for k, v in ipairs(btns) do
		local KeyButton = List:Add("DButton")
		KeyButton:SetSize(64, 64)
		KeyButton:SetText('')

		KeyButton.Hover = 0
		KeyButton.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			local color = mp.Color.BASE
			local color2 = C_W_25
			local color3 = C_B_25

			if v.color then
				color = ColorAlpha(v.color, 100)
				color2 = ColorAlpha(v.color, 25)
				color3 = ColorAlpha(v.color, 25)
			end

			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, 255 - self.Hover))
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(self:IsHovered() and mp.Color.WHITE or color, self.Hover))

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, color3)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)

			draw.SimpleText(v.name, choose_font, w / 2, h / 2, ColorAlpha(color, 255 - self.Hover), 1, 1)
			draw.SimpleText(v.name, choose_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, self.Hover), 1, 1)

			surface.SetDrawColor(color2)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end

		function KeyButton:OnCursorEntered()
			surface.PlaySound(mp.Sound.CLICK_6)
		end

		KeyButton.DoClick = function(s)
			surface.PlaySound(mp.Sound.SIGNAL)

			if v.click then
				v.click(tonumber(selectText), Display)
			else
				selectText = selectText .. v.name

				Display:SetText(selectText)
			end
		end
	end
end)
