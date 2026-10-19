local ColorAlpha = ColorAlpha
local mp = mp
local vgui = vgui
local draw = draw
local surface = surface
local Color = Color
local FrameTime = FrameTime
local Lerp = Lerp

local oxy = mp.font("20:Futura PT Medium")
local fire_font = mp.font("20:Futura PT Medium")
local magazine_font = mp.font("40:mr_ApexMk3MediumG")
local ammo_font = mp.font("25:mr_ApexMk3MediumG")
local ammo_type = mp.font("20:Futura PT Light")
local title_font = mp.font("20:Futura PT Book")
local flag_font = mp.font("16:Futura PT Medium")
local search_font = mp.font("20:DIN Pro Regular")
local quest_font = mp.font("18:DIN Pro Regular")

local C_B_75 = ColorAlpha(mp.Color.BLACK, 75)
local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)
local C_W_45 = ColorAlpha(mp.Color.WHITE, 45)
local C_W_75 = ColorAlpha(mp.Color.BASE_TO, 75)
local C_W_2 = ColorAlpha(mp.Color.WHITE, 2)
local C_G_200 = ColorAlpha(Color(62, 255, 126), 200)
local C_Y_200 = ColorAlpha(mp.Color.YELLOW, 200)
local C_O_200 = ColorAlpha(mp.Color.ORANGE, 200)
local C_BL_200 = ColorAlpha(Color(86, 179, 255), 200)
local C_R_200 = ColorAlpha(mp.Color.RED, 200)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)
local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_G_25 = ColorAlpha(Color(62, 255, 126), 25)

local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 100)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)

local X_t, Y_t = "X: ", "Y: "
local test

local pos_gps_x, pos_gps_y

hook.Add("OnContextMenuOpen", "mp.OnContextMenuOpen", function()
	if not LocalPlayer():Alive() then return end
	if CMENU_BACKGROUND then CMENU_BACKGROUND:Remove() end
	local thirtperson = thirtperson

	RunConsoleCommand("+show_compass")

	surface.PlaySound(mp.Sound.ROLLUP)

	local scrw, scrh = ScrW(), ScrH()
	local pl = LocalPlayer()

	local LerpEXP = 0

	local head_color = nil
	local torso_color = nil
	local larm_color = nil
	local rarm_color = nil
	local lleg_color = nil
	local rleg_color = nil

	local body_x, body_y, body_w, body_h = 20, 212, 96, 192
	local stats = mp.body_stats

	if not IsValid(g_ContextMenu) then
		RunConsoleCommand("spawnmenu_reload")
		return
	end

	local CMenuBackground = vgui.Create("Panel", g_ContextMenu)
	CMENU_BACKGROUND = CMenuBackground
	CMENU_BACKGROUND:SetSize(scrw, scrh)
	CMENU_BACKGROUND:SetPos(0, 0)
	CMENU_BACKGROUND:SetAlpha(0)
	CMENU_BACKGROUND:AlphaTo(255, 0.2, 0)
	CMENU_BACKGROUND:SetMouseInputEnabled(true)
	g_ContextMenu.Canvas:SetParent(CMENU_BACKGROUND)
	CMENU_BACKGROUND.Paint = function(self, w, h)
		local Head = pl:GetHead()
		local Torso = pl:GetToso()
		local LeftArm = pl:GetLeftArm()
		local RightArm = pl:GetRightArm()
		local LeftLeg = pl:GetLeftLeg()
		local RightLeg = pl:GetRightLeg()
		local Blooding = pl:GetBlooding()
		local Fracture = pl:GetFracture()
		local Concussion = pl:GetConcussion()
		local Burns = pl:GetBurns()
		local Health = pl:Health()
		local MaxHealth = pl:GetMaxHealth()
		local Wep = pl:GetActiveWeapon()
		local bool_pos = 212

		if Head > ((stats.head / 100) * 75) then
			head_color = mp.Color.WHITE
		elseif Head > ((stats.head / 100) * 50) then
			head_color = mp.Color.YELLOW
		elseif
			Head > ((stats.head / 100) * 25) then
			head_color = mp.Color.ORANGE
		elseif Head > 0 then
			head_color = mp.Color.RED
		else
			head_color = mp.Color.BLACK
		end

		if Torso > ((stats.torso / 100) * 75) then
			torso_color = mp.Color.WHITE
		elseif Torso > ((stats.torso / 100) * 50) then
			torso_color = mp.Color.YELLOW
		elseif
			Torso > ((stats.torso / 100) * 25) then
			torso_color = mp.Color.ORANGE
		elseif Torso > 0 then
			torso_color = mp.Color.RED
		else
			torso_color = mp.Color.BLACK
		end

		if LeftArm > ((stats.l_arm / 100) * 75) then
			larm_color = mp.Color.WHITE
		elseif LeftArm > ((stats.l_arm / 100) * 50) then
			larm_color = mp.Color.YELLOW
		elseif
			LeftArm > ((stats.l_arm / 100) * 25) then
			larm_color = mp.Color.ORANGE
		elseif LeftArm > 0 then
			larm_color = mp.Color.RED
		else
			larm_color = mp.Color.BLACK
		end

		if RightArm > ((stats.r_arm / 100) * 75) then
			rarm_color = mp.Color.WHITE
		elseif RightArm > ((stats.r_arm / 100) * 50) then
			rarm_color = mp.Color.YELLOW
		elseif
			RightArm > ((stats.r_arm / 100) * 25) then
			rarm_color = mp.Color.ORANGE
		elseif RightArm > 0 then
			rarm_color = mp.Color.RED
		else
			rarm_color = mp.Color.BLACK
		end

		if LeftLeg > ((stats.l_leg / 100) * 75) then
			lleg_color = mp.Color.WHITE
		elseif LeftLeg > ((stats.l_leg / 100) * 50) then
			lleg_color = mp.Color.YELLOW
		elseif
			LeftLeg > ((stats.l_leg / 100) * 25) then
			lleg_color = mp.Color.ORANGE
		elseif LeftLeg > 0 then
			lleg_color = mp.Color.RED
		else
			lleg_color = mp.Color.BLACK
		end

		if RightLeg > ((stats.r_leg / 100) * 75) then
			rleg_color = mp.Color.WHITE
		elseif RightLeg > ((stats.r_leg / 100) * 50) then
			rleg_color = mp.Color.YELLOW
		elseif
			RightLeg > ((stats.r_leg / 100) * 25) then
			rleg_color = mp.Color.ORANGE
		elseif RightLeg > 0 then
			rleg_color = mp.Color.RED
		else
			rleg_color = mp.Color.BLACK
		end

		mp.Icon(0, 0, w, h, mp.Material.BACKGROUND, C_B_75)
		mp.Icon(0, h - h / 2, w, h / 2, mp.Material.GRADIENT_D, C_B_200)
		mp.Icon(w - w / 2, 0, w / 2, h, mp.Material.GRADIENT_R, C_B_200)
		mp.Icon(0, 0, w / 2, h, mp.Material.GRADIENT_L, C_B_200)

		mp.Icon(body_x, h - body_y, body_w, body_h, mp.Material.BODY_TRASH, C_W_2)
		mp.Icon(body_x, h - body_y, body_w, body_h, mp.Material.HEAD, ColorAlpha(head_color, 50))
		mp.Icon(body_x, h - body_y, body_w, body_h, mp.Material.TORSO, ColorAlpha(torso_color, 50))
		mp.Icon(body_x, h - body_y, body_w, body_h, mp.Material.LARM, ColorAlpha(larm_color, 50))
		mp.Icon(body_x, h - body_y, body_w, body_h, mp.Material.RARM, ColorAlpha(rarm_color, 50))
		mp.Icon(body_x, h - body_y, body_w, body_h, mp.Material.LLEG, ColorAlpha(lleg_color, 50))
		mp.Icon(body_x, h - body_y, body_w, body_h, mp.Material.RLEG, ColorAlpha(rleg_color, 50))

		if Fracture then
			mp.Icon(128, h - bool_pos, 24, 24, mp.Material.FRACTURE, C_W_200)

			bool_pos = bool_pos - 35
		end

		if Blooding then
			mp.Icon(128, h - bool_pos, 24, 24, mp.Material.BLOOD, C_W_200)

			bool_pos = bool_pos - 35
		end

		if Concussion then
			mp.Icon(128, h - bool_pos, 24, 24, mp.Material.CONCUSSION, C_W_200)

			bool_pos = bool_pos - 35
		end

		if Burns then
			mp.Icon(128, h - bool_pos, 24, 24, mp.Material.BURNS, C_W_200)
		end
	end

	CMENU_BACKGROUND.Think = function(self, w, h)
		if IsValid(CMENU_BACKGROUND) and not pl:Alive() then
			CMENU_BACKGROUND:AlphaTo(0, 0.2, 0, function()
				CMENU_BACKGROUND:Remove()
			end)

			surface.PlaySound(mp.Sound.ROLLUP_2)
		end
	end

	local size = 37 * table.Count(Conquest.cache)

	local TerritoryPanel = vgui.Create("Panel", CMENU_BACKGROUND)
	TerritoryPanel:SetSize(size, 32)
	TerritoryPanel:SetPos(scrw / 2 - TerritoryPanel:GetWide() / 2, scrh * .1)
	TerritoryPanel.Hover = 0

	for k, v in pairs(Conquest.cache) do
		local c_color = ColorAlpha(GetIconColor(v), 200)
		local TerritoryButton = vgui.Create("Panel", TerritoryPanel)
		TerritoryButton:Dock(LEFT)
		TerritoryButton:SetWide(32)
		TerritoryButton:DockMargin(0, 0, 5, 0)
		function TerritoryButton:Paint(w, h)
			mp.Icon(0, 0, h, h, mp.Material.FLAG, c_color)
			draw.SimpleText(v.tag, flag_font, w / 2, h / 2, c_color, 1, 1)
		end

		TerritoryButton.OnCursorEntered = function(s)
			mp.ToolTip(s, v.name, c_color)
			surface.PlaySound(mp.Sound.CLICK)
		end
	end

	local ThirdPersonButton = vgui.Create("DButton", CMENU_BACKGROUND)
	TP_BUTTON = ThirdPersonButton
	TP_BUTTON:SetSize(32, 32)
	TP_BUTTON:SetText("")
	TP_BUTTON:SetPos(scrw / 2 - 16, 20)
	TP_BUTTON.Hover = 0
	TP_BUTTON.Paint = function(self, w, h)
		if thirdperson_enabled then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		if not thirdperson_enabled then
			mp.Icon(0, 0, w, h, mp.Material.THIRD_PERSON, ColorAlpha(mp.Color.WHITE, 255 - self.Hover))
		else
			mp.Icon(0, 0, w, h, mp.Material.FIRST_PERSON, ColorAlpha(mp.Color.WHITE, self.Hover))
		end
	end

	TP_BUTTON.OnCursorEntered = function(s)
		mp.ToolTip(s, "Включить третье лицо", mp.Color.BASE)
		surface.PlaySound(mp.Sound.CLICK)
	end

	TP_BUTTON.DoClick = function(self)
		thirdperson_enabled = not thirdperson_enabled

		surface.PlaySound(mp.Sound.CLICK_2)
	end

	local VoiceButton = vgui.Create("DButton", CMENU_BACKGROUND)
	VoiceButton:SetSize(32, 32)
	VoiceButton:SetText("")
	VoiceButton:SetPos(scrw / 2 + 5, scrh - 42)
	VoiceButton.Hover = 0
	VoiceButton.Paint = function(self, w, h)
		if ! pl:GetRadioSpeak() then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		if pl:GetRadioSpeak() then
			mp.Icon(0, 0, w, h, mp.Material.VOICE_ON, ColorAlpha(mp.Color.WHITE, 255 - self.Hover))
		else
			mp.Icon(0, 0, w, h, mp.Material.VOICE_OFF, ColorAlpha(mp.Color.RED, self.Hover))
		end
	end

	VoiceButton.OnCursorEntered = function(s)
		mp.ToolTip(s, pl:GetRadioSpeak() and "Отключить звук от рации" or "Включить звук от рации", mp.Color.BASE)
		surface.PlaySound(mp.Sound.CLICK)
	end

	VoiceButton.DoClick = function(self)
		net.Start("mp.SpeakerToggle")
		net.WriteEntity(pl)
		net.SendToServer()

		surface.PlaySound(mp.Sound.ERROR_2)
	end

	local MicroButton = vgui.Create("DButton", CMENU_BACKGROUND)
	MicroButton:SetSize(32, 32)
	MicroButton:SetText("")
	MicroButton:SetPos(scrw / 2 - 37, scrh - 42)
	MicroButton.Hover = 0
	MicroButton.Paint = function(self, w, h)
		if ! pl:GetRadioMicro() then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		if pl:GetRadioMicro() then
			mp.Icon(0, 0, w, h, mp.Material.MICRO_ON, ColorAlpha(mp.Color.WHITE, 255 - self.Hover))
		else
			mp.Icon(0, 0, w, h, mp.Material.MICRO_OFF, ColorAlpha(mp.Color.RED, self.Hover))
		end
	end

	MicroButton.OnCursorEntered = function(s)
		mp.ToolTip(s, pl:GetRadioSpeak() and "Отключить голос в рации" or "Включить голос в рации", mp.Color.BASE)
		surface.PlaySound(mp.Sound.CLICK)
	end

	MicroButton.DoClick = function(self)
		net.Start("mp.MicroToggle")
		net.WriteEntity(pl)
		net.SendToServer()

		surface.PlaySound(mp.Sound.ERROR_2)
	end

	local ThirdPersonSlider = vgui.Create("DSlider", CMENU_BACKGROUND)
	TP_SLIDER = ThirdPersonSlider
	TP_SLIDER:SetSize(128, 128)
	TP_SLIDER:SetPos(20, 20)
	TP_SLIDER:SetLockX()
	TP_SLIDER:SetLockY()
	TP_SLIDER:SetSlideY(tonumber(thirtperson.z:GetString()))
	TP_SLIDER:SetSlideX(tonumber(thirtperson.y:GetString()))
	TP_SLIDER.ZPos = tonumber(thirtperson.z:GetString())
	TP_SLIDER.YPos = tonumber(thirtperson.y:GetString())
	TP_SLIDER.Knob:SetSize(16, 16)
	TP_SLIDER.Knob.Paint = function(self, w, h)
		draw.RoundedBox(h / 2, 0, 0, w, h, mp.Color.WHITE)
	end
	TP_SLIDER.Paint = function(self, w, h)
		local y, z = self:GetSlideX(), self:GetSlideY()

		draw.RoundedBox(16, 0, 0, w, h, C_B_150)

		surface.SetDrawColor(C_W_2)
		surface.DrawLine(0, w * .5, w, w * .5)
		surface.DrawLine(h * .5, 0, h * .5, h)

		self.YPos = Lerp(FrameTime() * 5, self.YPos, y)
		self.ZPos = Lerp(FrameTime() * 5, self.ZPos, z)

		draw.SimpleText(X_t .. math.Round(self.YPos * 100), oxy, w / 2 + 10, h / 2 - 25, C_W_45, 0, 0)
		draw.SimpleText(Y_t .. math.Round(self.ZPos * 100), oxy, w / 2 + 10, h / 2 - 45, C_W_45, 0, 0)

		thirtperson.y:SetString(self.YPos)
		thirtperson.z:SetString(z)
	end

	TP_SLIDER.Knob.OnCursorEntered = function()
		surface.PlaySound(mp.Sound.HOVER_2)
	end

	local ThirdPersonZSlider = vgui.Create("DNumSlider", CMENU_BACKGROUND)
	TP_ZSLIDER = ThirdPersonZSlider
	TP_ZSLIDER:SetSize(128, 16)
	TP_ZSLIDER:SetPos(20, 162)
	TP_ZSLIDER:SetMin(40)
	TP_ZSLIDER:SetMax(200)
	TP_ZSLIDER:SetDecimals(0)
	TP_ZSLIDER:SetValue(tonumber(thirtperson.x:GetString()))
	TP_ZSLIDER.XPos = tonumber(thirtperson.x:GetString())
	TP_ZSLIDER.Paint = function(self, w, h)
		local x = self:GetValue()

		draw.RoundedBox(h / 2, 0, 0, w, h, C_B_150)

		surface.SetDrawColor(C_W_2)
		surface.DrawLine(w * .5, 0, w * .5, w)

		self.XPos = Lerp(FrameTime() * 5, self.XPos, x)

		thirtperson.x:SetString(self.XPos)
	end

	TP_ZSLIDER.Slider.Knob.OnCursorEntered = function()
		surface.PlaySound(mp.Sound.HOVER_2)
	end

	TP_ZSLIDER.PerformLayout = function()
		TP_ZSLIDER:GetTextArea():SetWide(0)
		TP_ZSLIDER.Label:SetWide(0)
		TP_ZSLIDER.Slider:SetPos(0, 0)
		TP_ZSLIDER.Slider.Knob:SetSize(16, 16)
		TP_ZSLIDER.Slider.Paint = function(self, w, h) end
		TP_ZSLIDER.Slider.Knob.Paint = function(self, w, h)
			draw.RoundedBox(h / 2, 0, 0, w, h, mp.Color.BASE)
		end
	end

	local gpsMenu = vgui.Create("DFrame", CMENU_BACKGROUND)
	gpsMenu:SetTitle("")
	gpsMenu:SetSize(250, 360)
	gpsMenu:SetDraggable(true)
	gpsMenu:ShowCloseButton(false)
	gpsMenu:SetScreenLock(true)

	pos_gps_x, pos_gps_y = pos_gps_x or scrw / 2 + gpsMenu:GetWide() * 1.5, pos_gps_y or scrh - gpsMenu:GetTall() - 20

	gpsMenu:SetPos(pos_gps_x, pos_gps_y)
	gpsMenu.title = "GPS"

	function gpsMenu:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
		draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
		mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

		surface.SetDrawColor(C_B_25)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		mp.Text(self.title, search_font, w / 2, 20, mp.Color.BASE, 1, 1)

		pos_gps_x, pos_gps_y = self:GetX(), self:GetY()
	end

	local list_scroll = vgui.Create("DScrollPanel", gpsMenu)
	list_scroll:Dock(FILL)
	list_scroll:DockMargin(5, 20, 5, 5)
	list_scroll.Hover = 0
	list_scroll.VBar:SetWide(5)
	list_scroll.Paint = function(self, w, h)
		local x2, y2 = self:LocalCursorPos()

		if x2 < w and x2 > 0 and y2 < h and y2 > 0 then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		self.VBar:SetAlpha(self.Hover)
	end
	local sbar = list_scroll:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
	end

	local allGps = {}

	table.Merge(allGps, mp.Territory.GPS)
	table.Merge(allGps, mp.Territory.CustomGPS)

	for k, v in pairs(allGps) do
		if v.control and (not pl:GetFaction() or pl:GetFaction() ~= v.control) then continue end

		local panel_gps = vgui.Create("DButton", list_scroll)
		panel_gps:Dock(TOP)
		panel_gps:SetTall(32)
		panel_gps:DockMargin(0, 0, 0, 5)
		panel_gps:SetText("")
		panel_gps.Hover = 0

		function panel_gps:Paint(w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 150)
			else
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

			if pl.GPSCash and pl.GPSCash[k] then
				draw.RoundedBox(0, 0, 0, w, h, C_G_25)
			end

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end

		function panel_gps:DoClick()
			pl.GPSCash = pl.GPSCash or {}

			if k == "delete" then
				pl.GPSCash = {}

				return
			end

			if pl.GPSCash[k] then
				pl.GPSCash[k] = nil

				return
			end

			pl.GPSCash[k] = true
		end

		local tilte_text = vgui.Create("DLabel", panel_gps)
		tilte_text:Dock(TOP)
		tilte_text:DockMargin(5, 5, 5, 5)
		tilte_text:SetText(v.name)
		tilte_text:SetWrap(true)
		tilte_text:SetAutoStretchVertical(true)
		tilte_text:SetFont(quest_font)

		function panel_gps:PerformLayout()
			self:SetTall(math.Clamp(tilte_text:GetTall() + 10, 30, 999))
		end
	end
end)

hook.Add("OnContextMenuClose", "mp.OnContextMenuClose", function()
	surface.PlaySound(mp.Sound.ROLLUP_2)

	RunConsoleCommand("-show_compass")

	if IsValid(CMENU_BACKGROUND) then
		CMENU_BACKGROUND:AlphaTo(0, 0.2, 0, function()
			CMENU_BACKGROUND:Remove()
		end)
	end

	if IsValid(ParrentClean) then
		ParrentClean:Remove()
	end
end)
