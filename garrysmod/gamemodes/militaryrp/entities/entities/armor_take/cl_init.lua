include("shared.lua")

local complex_off = Vector(0, 0, 20)
local simple_off = Vector(0, 0, 50)

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
local title_font = mp.font("50:Futura PT Book")
local cat_font = mp.font("20:DIN Pro Regular")
local name_font = mp.font("25:Futura PT Book")
local number_font = mp.font("100:mr_ApexMk3MediumG")
local settings_font = mp.font("26:Futura PT Light")
local seats_font = mp.font("25:DIN Pro Regular")
local teams_font = mp.font("24:Futura PT Light")
local add_font = mp.font("18:DIN Pro Regular")

local C_B_200 = ColorAlpha(mp.Color.BASE_TO, 200)
local C_B_100 = ColorAlpha(mp.Color.BASE_TO, 100)

local C_W_5 = ColorAlpha(mp.Color.WHITE, 5)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)

local C_GR_100 = ColorAlpha(mp.Color.GREEN, 100)
local C_R_100 = ColorAlpha(mp.Color.RED, 100)

local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_BS_100 = ColorAlpha(mp.Color.BASE, 100)

local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
local color_panel = mp.Color.BASE
local color_text = ColorAlpha(mp.Color.BASE, 200)

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

	local WepHat = vgui.Create("DPanel", WEP_BACKGROUND)
	WEP_HAT = WepHat
	WEP_HAT:SetSize(1024, 720)
	WEP_HAT:SetPos(scrw / 2 - 512, scrh / 2 - 360)
	WEP_HAT.Paint = function(self, w, h)
		mp.Text(title_text, title_font, w / 2, 50, mp.Color.WHITE, 1, 1)
	end

	local GoExit = vgui.Create("DButton", WEP_BACKGROUND)
	GO_EXIT = GoExit
	GO_EXIT:SetSize(100, 30)
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
	GO_EXIT:SetPos(WepHat:GetX(), WepHat:GetY())

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
	local WP = {}

	if mp.profession[PlyFeatures] then
		WP = mp.profession[PlyFeatures].weapons
	end

	if ply:HasAccessTeam("milpolice") then
		table.Add(WP, mp.config.access_list["milpolice"].armor_take)
	end

	local donateWep = {}

	for k, v in ipairs(IGS.GetItems()) do
		if not v:GetMeta("weapons") then continue end

		if ply:HasPurchase(v.uid) then
			donateWep[#donateWep + 1] = v:GetMeta("weapons")
		end
	end

	if #donateWep > 0 then
		table.Add(WP, donateWep)
	end

	local number = "0"

	local icon
	local spec = ply:GetNetVar("meta_features")

	if spec and mp.profession[spec] and mp.profession[spec].add_stats then
		local stats = mp.profession[spec].add_stats

		local ArmorTake = vgui.Create("DPanel", WEP_SCROLL)
		ArmorTake:Dock(TOP)
		ArmorTake:SetTall(64)
		ArmorTake:DockMargin(0, 0, 5, 8)
		ArmorTake:SetText("")
		ArmorTake:IsVisible()
		ArmorTake.Hover = 0
		ArmorTake.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
			draw.RoundedBox(0, 0, 0, 1, h, C_W_25)
			draw.RoundedBox(0, w - 1, 0, 1, h, C_W_25)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)

			mp.Icon(0, 0, w / 2, 1, mp.Material.GRADIENT_L, C_W_25)
			mp.Icon(0, h - 1, w / 2, 1, mp.Material.GRADIENT_L, C_W_25)
			mp.Icon(w / 2, 0, w / 2, 1, mp.Material.GRADIENT_R, C_W_25)
			mp.Icon(w / 2, h - 1, w / 2, 1, mp.Material.GRADIENT_R, C_W_25)

			mp.Icon(16, h / 2 - 12, 24, 24, mp.Material.HEALTH, mp.Color.BASE)

			local hp = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())
			local armor = math.Clamp(ply:Armor(), 0, ply:GetMaxArmor())

			mp.Text(hp, seats_font, 45, h / 2, mp.Color.WHITE, 0, 1)
			mp.Text(armor, seats_font, 132, h / 2, mp.Color.WHITE, 0, 1)

			if stats.health then
				mp.Icon(16, h / 2 - 12, 24, 24, mp.Material.HEALTH, mp.Color.BASE)
				mp.Text("+" .. math.Clamp(stats.health - hp, 0, stats.health), add_font, 45, h / 2 + 8, mp.Color.ORANGE,
					0, 0)
			end

			if stats.armor then
				mp.Icon(100, h / 2 - 12, 24, 24, mp.Material.ARMOR, mp.Color.BASE)
				mp.Text("+" .. math.Clamp(stats.armor - armor, 0, stats.armor), add_font, 132, h / 2 + 8, mp.Color
					.ORANGE, 0, 0)
			end
		end

		local TakeBtn = vgui.Create("DButton", ArmorTake)
		TakeBtn:Dock(LEFT)
		TakeBtn:SetWide(110)
		TakeBtn:DockMargin(200, 10, 10, 10)
		TakeBtn:SetText("Получить")
		TakeBtn:SetTextColor(Color(0, 0, 0, 0))
		TakeBtn.Hover = 0
		TakeBtn.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_panel, self.Hover))

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			local next_armor = ply:GetNetVar("NextArmorTake") or 0
			local text = next_armor > CurTime() and math.Round(next_armor - CurTime()) .. " сек." or "Получить"

			draw.SimpleText(text, cat_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
				1)
			draw.SimpleText(text, cat_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
		end

		TakeBtn.DoClick = function(self)
			netstream.Start("Weapons_ArmorTake")
		end

		local TakeAll = vgui.Create("DButton", ArmorTake)
		TakeAll:Dock(RIGHT)
		TakeAll:SetWide(180)
		TakeAll:DockMargin(0, 10, 10, 10)
		TakeAll:SetText("Получить")
		TakeAll:SetTextColor(Color(0, 0, 0, 0))
		TakeAll.Hover = 0
		TakeAll.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_panel, self.Hover))

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			local next_armor = ply:GetNetVar("NextArmorTake") or 0
			local text = "Забрать всё"

			draw.SimpleText(text, cat_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
				1)
			draw.SimpleText(text, cat_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
		end

		TakeAll.DoClick = function(self)
			netstream.Start("Weapons_SpawnAll")
		end

		local ReturnAll = vgui.Create("DButton", ArmorTake)
		ReturnAll:Dock(RIGHT)
		ReturnAll:SetWide(180)
		ReturnAll:DockMargin(0, 10, 10, 10)
		ReturnAll:SetText("Получить")
		ReturnAll:SetTextColor(Color(0, 0, 0, 0))
		ReturnAll.Hover = 0
		ReturnAll.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_panel, self.Hover))

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			local next_armor = ply:GetNetVar("NextArmorTake") or 0
			local text = "Вернуть всё"

			draw.SimpleText(text, cat_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
				1)
			draw.SimpleText(text, cat_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
		end

		ReturnAll.DoClick = function(self)
			netstream.Start("Weapons_ReturnAll")
		end
	end

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

			mp.Text(WeaponName, name_font, 15, 20, mp.Color.WHITE, 0, 1)
			mp.Text(WeaponCategory, cat_font, 15, 40, mp.Color.BASE, 0, 1)
			mp.Text(number .. k, number_font, 75, h / 2, C_W_5, 1, 1)

			if WeaponClipSize > 0 then
				mp.Text(magazine_text .. WeaponClipSize, teams_font, 160, h / 2 - 35, C_W_100, 0, 1)
			end

			if WeaponDefaultClip > 0 then
				mp.Text(ammo_text .. WeaponDefaultClip, teams_font, 160, h / 2 - 15, C_BS_100, 0, 1)
			end

			if WeaponAmmo ~= "none" then
				mp.Text("Партроны: " .. WeaponAmmo, teams_font, 160, h / 2 + 15, C_BS_100, 0, 1)
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
