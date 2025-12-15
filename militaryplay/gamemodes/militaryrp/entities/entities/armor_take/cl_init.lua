include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), 90)

		cam.Start3D2D(self:GetPos() + self:GetUp() * 45, Ang, 0.05)
		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
		mp.Text("Пирамида для оружия", mp.font("100:Gamestation Condensed"), 0, 0, ColorAlpha(mp.Color.WHITE, alpha), 1,
			0)
		render.PopFilterMin()
		cam.End3D2D()
	end
end

local ColorAlpha = ColorAlpha
local Color = Color
local mp = mp
local draw = draw
local Lerp = Lerp
local FrameTime = FrameTime
local vgui = vgui
local Vector, Angle = Vector, Angle
local IsValid = IsValid
local net = net
local surface = surface

local title_text = "Пирамида"
local exit_text = "× Закрыть"
local return_text = "ВЕРНУТЬ"
local select_text = "ВЫБРАТЬ"
local get_text = "НА ВЫДАЧЕ"
local magazine_text = "Объём магазина: "
local ammo_text = "Вместимость сумки: "

local goback_font = mp.font("30:Futura PT Light")
local title_font = mp.font("70:Futura PT Light")
local cat_font = mp.font("20:DIN Pro Regular")
local name_font = mp.font("25:Rostelecom Basis Light")
local number_font = mp.font("100:mr_ApexMk3MediumG")
local settings_font = mp.font("26:Rostelecom Basis Light")
local seats_font = mp.font("25:DIN Pro Regular")
local teams_font = mp.font("24:Futura PT Light")

local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)

local C_W_5 = ColorAlpha(mp.Color.WHITE, 5)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)

local C_GR_100 = ColorAlpha(mp.Color.GREEN, 100)
local C_R_100 = ColorAlpha(mp.Color.RED, 100)

local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_BS_100 = ColorAlpha(mp.Color.BASE, 100)

local BlackList = {
	["cw_kk_ins2_nade_anm14"] = true,
	["cw_kk_ins2_nade_f1"] = true,
	["cw_kk_ins2_nade_m18"] = true,
	["cw_kk_ins2_nade_m67"] = true,
	["cw_kk_ins2_nade_m84"] = true,
	["cw_kk_ins2_nade_molotov"] = true,
	["cw_kk_ins2_nade_c4"] = true,
	["cw_kk_ins2_nade_ied"] = true,
	["weapon_suicidebomber"] = true,
	["weapon_simmines"] = true,
	["weapon_grenadeplacer"] = true,
	["cw_kk_ins2_nade_c4rus"] = true,
	["fas2_ifakmed"] = true,
	["fas2_ifak"] = true,
}

netstream.Hook("Weapons_OpenMenu", function(data)
	if not LocalPlayer():Alive() then return end

	local TableNumber = {}

	if IsValid(WEP_BACKGROUND) then
		WEP_BACKGROUND:AlphaTo(0, 0.3, 0, function()
			WEP_BACKGROUND:Remove()
		end)

		surface.PlaySound(mp.Sound.DEPLOY_2)

		return
	end

	local scrw, scrh = ScrW(), ScrH()
	local ply = LocalPlayer()

	local WepBackground = vgui.Create("EditablePanel")
	WEP_BACKGROUND = WepBackground
	WEP_BACKGROUND:SetSize(scrw, scrh)
	WEP_BACKGROUND:SetPos(0, 0)
	WEP_BACKGROUND:MakePopup()
	WEP_BACKGROUND:SetAlpha(0)
	WEP_BACKGROUND:AlphaTo(255, 0.5, 0)
	WEP_BACKGROUND.Paint = function(self, w, h)
		mp.BlurBG(self, 2)

		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
	end

	local GoExit = vgui.Create("DButton", WEP_BACKGROUND)
	GO_EXIT = GoExit
	GO_EXIT:SetSize(100, 30)
	GO_EXIT:SetPos(10, 10)
	GO_EXIT:SetText("")
	GO_EXIT.Hover = 0
	GO_EXIT.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		draw.SimpleText(exit_text, goback_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1, 1)
		draw.SimpleText(exit_text, goback_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
	end

	GO_EXIT.DoClick = function(self)
		WEP_BACKGROUND:AlphaTo(0, 0.1, 0, function()
			WEP_BACKGROUND:Remove()
		end)
	end

	local WepHat = vgui.Create("DPanel", WEP_BACKGROUND)
	WEP_HAT = WepHat
	WEP_HAT:SetSize(1024, 720)
	WEP_HAT:SetPos(scrw / 2 - 512, scrh / 2 - 360)
	WEP_HAT.Paint = function(self, w, h)
		mp.Text(title_text, title_font, w / 2, 2, mp.Color.WHITE, 1, 0)
	end

	local WepScroll = vgui.Create("DScrollPanel", WEP_HAT)
	WEP_SCROLL = WepScroll
	WEP_SCROLL:SetSize(1024, 620)
	WEP_SCROLL:SetPos(0, 100)
	WEP_SCROLL.Hover = 0
	WEP_SCROLL.VBar:SetWide(5)
	WEP_SCROLL.Paint = function(self, w, h)
		local x, y = self:LocalCursorPos()
		local w, h = self:GetWide(), self:GetTall()

		if x < w and x > 0 and y < h and y > 0 then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		self.VBar:SetAlpha(self.Hover)
	end
	local sbar = WEP_SCROLL:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
	end

	local PlyFeatures = ply:GetNetVar("meta_features")
	local WP

	if mp.profession[PlyFeatures] then
		WP = mp.profession[PlyFeatures].weapons
	end

	local number = "0"

	if not WP then return end

	for k = 1, #WP do
		local Weapon = weapons.Get(WP[k])
		if not Weapon then continue end
		local WeaponName = Weapon.PrintName or ""
		local WeaponWorldModel = Weapon.WorldModel
		local WeaponCategory = Weapon.Category
		local WeaponClipSize = Weapon.Primary.ClipSize
		local WeaponDefaultClip = Weapon.Primary.DefaultClip
		local WeaponAmmo = Weapon.Primary.Ammo

		if ply:GetWeapon(WP[k]) ~= NULL and BlackList[WP[k]] then continue end

		local WepVehicle = vgui.Create("DPanel", WEP_SCROLL)
		WEP_VEHICLE = WepVehicle
		WEP_VEHICLE:Dock(TOP)
		WEP_VEHICLE:SetTall(256)
		WEP_VEHICLE:DockMargin(0, 0, 5, 8)
		WEP_VEHICLE:SetText("")
		WEP_VEHICLE:IsVisible()
		WEP_VEHICLE.Hover = 0
		WEP_VEHICLE.Paint = function(self, w, h)
			if not WP[k] then self:Remove() end
			if ply:GetWeapon(WP[k]) ~= NULL and BlackList[WP[k]] then self:Remove() end

			draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
			draw.RoundedBox(0, 0, 0, 1, h, C_W_25)
			draw.RoundedBox(0, 150, 50, 1, h - 100, C_B_10)
			draw.RoundedBox(0, 151, h / 2, 125, 1, C_B_10)
			draw.RoundedBox(0, w - 1, 0, 1, h, C_W_25)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)

			mp.Icon(0, 0, w / 2, 1, mp.Material.GRADIENT_L, C_W_25)
			mp.Icon(0, h - 1, w / 2, 1, mp.Material.GRADIENT_L, C_W_25)
			mp.Icon(w / 2, 0, w / 2, 1, mp.Material.GRADIENT_R, C_W_25)
			mp.Icon(w / 2, h - 1, w / 2, 1, mp.Material.GRADIENT_R, C_W_25)

			mp.Text(WeaponName, name_font, 20, 25, mp.Color.ORANGE, 0, 1)
			mp.Text(WeaponCategory, cat_font, 20, 45, mp.Color.BASE, 0, 1)
			mp.Text(number .. k, number_font, 75, h / 2, C_W_5, 1, 1)

			if WeaponClipSize > 0 then
				mp.Text(magazine_text .. WeaponClipSize, teams_font, 160, h / 2 - 35, C_W_100, 0, 1)
			end

			if WeaponDefaultClip > 0 then
				mp.Text(ammo_text .. WeaponDefaultClip, teams_font, 160, h / 2 - 15, C_BS_100, 0, 1)
			end

			if WeaponAmmo ~= "none" then
				mp.Text(WeaponAmmo, teams_font, 160, h / 2 + 15, C_BS_100, 0, 1)
			end
		end

		local DModel = vgui.Create("DModelPanel", WEP_VEHICLE)
		D_MODEL = DModel
		D_MODEL:SetModel(WeaponWorldModel)
		D_MODEL:SetPos(1, 0)
		D_MODEL:SetSize(1024, 256)
		D_MODEL:SetFOV(15)
		D_MODEL.Angles = Angle(0, 0, 0)
		D_MODEL:SetDirectionalLight(BOX_LEFT, mp.Color.BLACK)
		D_MODEL:SetDirectionalLight(BOX_RIGHT, mp.Color.WHITE)
		D_MODEL:SetDirectionalLight(BOX_BACK, mp.Color.WHITE)
		D_MODEL:SetCamPos(Vector(90, 125, 80))
		function D_MODEL:LayoutEntity(ent)
			ent:SetPos(Vector(-100, -115, 0))
		end

		local CreateWep = vgui.Create("DButton", WEP_VEHICLE)
		CREATE_WEP = CreateWep
		CREATE_WEP:SetSize(128, 32)
		CREATE_WEP:SetPos(10, WEP_VEHICLE:GetTall() - 42)
		CREATE_WEP:SetText("")
		CREATE_WEP:SetVisible(true)
		CREATE_WEP.Hover = 0
		CREATE_WEP.Paint = function(self, w, h)
			local Owner = ply:GetWeapon(WP[k])

			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 25)
			else
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

			if self:IsHovered() and Owner ~= NULL and Owner ~= WP[k] then
				mp.Text(return_text, cat_font, w / 2, h / 2, C_GR_100, 1, 1)
				surface.SetDrawColor(C_GR_100)
			else
				if Owner ~= NULL and Owner ~= WP[k] then
					mp.Text(get_text, cat_font, w / 2, h / 2, C_R_100, 1, 1)
					surface.SetDrawColor(C_R_100)
				else
					mp.Text(select_text, cat_font, w / 2, h / 2, C_W_100, 1, 1)
					surface.SetDrawColor(C_W_100)
				end
			end

			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end

		CREATE_WEP.DoClick = function(self)
			local Owner = ply:GetWeapon(WP[k])

			if Owner ~= NULL and Owner ~= WP[k] then
				netstream.Start("Weapons_Return", { class = WP[k] })
			elseif Owner == NULL then
				netstream.Start("Weapons_Spawn", { class = WP[k] })
			end
		end
	end
end)
