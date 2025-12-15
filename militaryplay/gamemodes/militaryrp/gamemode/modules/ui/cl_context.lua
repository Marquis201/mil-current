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
local ammo_font = mp.font("30:mr_ApexMk3MediumG")
local ammo_type = mp.font("20:Futura PT Light")
local title_font = mp.font("20:Futura PT Book")

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

local LerpArmor = 0
local LerpHealth = 0

local X_t, Y_t = "X: ", "Y: "
local null = "000"
local firemode = "[E+R]"
local customization = "[B]"

local FireModeSafe = "passive"  -- предохранитель
local FireModeAuto = "auto"     -- авто
local FireMode3Burst = "3burst" -- 3 выстр.
local FireMode2Burst = "2burst" -- 2 выстр.
local FireModeSemi = "semi"     -- одиночные

local function drawArmor(scrw, scrh, pl)
	local x = scrw - 220
	local y = scrh - 100
	local w, h = 200, 20
	local armor = pl:Armor()

	if armor > 0 then
		LerpArmor = Lerp(FrameTime() * 5, LerpArmor, armor)

		local getArmor = LerpArmor / 50
		local maxArmor = 1 / w
		getArmor = math.Clamp(getArmor, 0, 1)

		surface.SetDrawColor(C_B_150)
		surface.DrawRect(x, 5 + y, 98, 6)
		surface.DrawRect(x + 105, 5 + y, 96, 6)

		mp.Icon(scrw - 75, y - 39, 24, 24, mp.Material.ARMOR, C_W_45)

		if getArmor == 0 then return end
		for i = 0, getArmor, maxArmor do
			surface.SetDrawColor(C_BL_200)
			if (i >= 0.485 and i < 0.515) then
				surface.SetDrawColor(0, 0, 0, 0)
			end
			surface.DrawLine(x, 5 + y, x, y + 10)
			x = x + 1
		end
	end
end

local function drawHealth(scrw, scrh, pl)
	local x = scrw - 220
	local y = scrh - 110
	local w, h = 200, 20
	local health = pl:Health()

	LerpHealth = Lerp(FrameTime() * 5, LerpHealth, health)

	local getHealth = LerpHealth / 100
	local maxHealth = 1 / w
	getHealth = math.Clamp(getHealth, 0, 1)

	surface.SetDrawColor(C_B_150)
	surface.DrawRect(x, 5 + y, 48, 6)
	surface.DrawRect(x + 52, 5 + y, 46, 6)
	surface.DrawRect(x + 102, 5 + y, 46, 6)
	surface.DrawRect(x + 152, 5 + y, 49, 6)

	mp.Icon(scrw - 44, y - 29, 24, 24, mp.Material.HEALTH, C_W_45)

	if getHealth == 0 then return end
	for i = 0, getHealth, maxHealth do
		if health < 25 then
			surface.SetDrawColor(C_R_200)
		elseif health < 50 then
			surface.SetDrawColor(C_O_200)
		elseif health < 75 then
			surface.SetDrawColor(C_Y_200)
		else
			surface.SetDrawColor(C_G_200)
		end

		if (i >= 0.235 and i < 0.265) or (i >= 0.485 and i < 0.515) or (i >= 0.735 and i < 0.765) then
			surface.SetDrawColor(0, 0, 0, 0)
		end
		surface.DrawLine(x, 5 + y, x, y + 10)
		x = x + 1
	end
end

function GM:OnContextMenuOpen()
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

	local CMenuBackground = vgui.Create("EditablePanel")
	CMENU_BACKGROUND = CMenuBackground
	CMENU_BACKGROUND:SetSize(scrw, scrh)
	CMENU_BACKGROUND:SetPos(0, 0)
	CMENU_BACKGROUND:MakePopup()
	CMENU_BACKGROUND:SetAlpha(0)
	CMENU_BACKGROUND:AlphaTo(255, 0.2, 0)
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
		local Level = pl:GetLevel()
		local EXP = pl:GetExperience()
		local MaxEXP = pl:GetNeedExperience()
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

		mp.Icon(0, 0, w, h, mp.Material.BACKGROUND, C_B_150)
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

		drawArmor(scrw, scrh, pl)
		drawHealth(scrw, scrh, pl)

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

		if Wep and Wep:IsWeapon() and Wep:HasAmmo() then
			surface.SetFont(magazine_font)
			local x, y = surface.GetTextSize(Wep:Clip1())

			if Wep:Clip1() > 0 then
				draw.SimpleText(Wep:Clip1(), magazine_font, w - 220, h - 149, C_W_200, 0, 0)
			end

			if pl:GetAmmoCount(Wep:GetPrimaryAmmoType()) > 0 then
				draw.SimpleText(pl:GetAmmoCount(Wep:GetPrimaryAmmoType()), ammo_font, w - 215 + x, h - 142,
					mp.Color.BASE, 0, 0)
			end

			if game.GetAmmoName(Wep:GetPrimaryAmmoType()) then
				draw.SimpleText(game.GetAmmoName(Wep:GetPrimaryAmmoType()), ammo_type, w - 20, h - 165, C_W_45, 2, 0)
			end
		else
			draw.SimpleText(null, magazine_font, w - 220, h - 149, C_W_25, 0, 0)
			draw.SimpleText(null, ammo_font, w - 163, h - 142, C_W_25, 0, 0)
		end

		-- Изменено: замена CW20Weapon на TFA систему
		if IsValid(Wep) and Wep.IsTFAWeapon and Wep:GetFireMode() then
			local fireMode = Wep:GetFireMode()

			if fireMode == 4 then -- Safe mode
				mp.Icon(w - 265, h - 112, 24, 24, mp.Material.SAFE, C_W_200)
			elseif fireMode == 2 then -- Semi-auto
				mp.Icon(w - 265, h - 112, 24, 24, mp.Material.ONE_WEP, C_W_200)
			elseif fireMode == 3 then -- Burst
				mp.Icon(w - 265, h - 112, 24, 24, mp.Material.AUTO, C_W_200)
			elseif fireMode == 1 then -- Full-auto
				mp.Icon(w - 265, h - 112, 24, 24, mp.Material.AUTO, C_W_200)
			end

			mp.Icon(w - 265, h - 150, 24, 24, mp.Material.CUSTOM_MENU, C_W_200)

			draw.SimpleText(customization, fire_font, w - 275, h - 148, C_W_45, 2, 0)
			draw.SimpleText(firemode, fire_font, w - 275, h - 110, C_W_45, 2, 0)
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

	local TerritoryPanel = vgui.Create("DScrollPanel", CMENU_BACKGROUND)
	TerritoryPanel:SetSize(300, 300)
	TerritoryPanel:SetPos(scrw - TerritoryPanel:GetWide() - 25, 25)
	TerritoryPanel.Hover = 0
	TerritoryPanel.VBar:SetWide(5)
	TerritoryPanel.Paint = function(self, w, h)
		local x, y = self:LocalCursorPos()
		local w, h = self:GetWide(), self:GetTall()

		if x < w and x > 0 and y < h and y > 0 then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		self.VBar:SetAlpha(self.Hover)

		draw.RoundedBox(0, 0, 0, w, h, C_B_100)

		mp.Icon(0, 0, w, h, mp.Material.BACKGROUND, C_W_75)
	end
	local sbar = TerritoryPanel:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
	end

	for k, v in pairs(mp.Territory.Table) do
		local pos = (v.pos.x + v.pos.y) / 2

		local TerritoryButton = vgui.Create("Panel", TerritoryPanel)
		TerritoryButton:Dock(TOP)
		TerritoryButton:SetTall(45)
		TerritoryButton:DockMargin(5, 5, 5, 0)
		function TerritoryButton:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, C_B_100)

			local c_text = mp.faction[v.control] and mp.faction[v.control].title or "Нейтральная"
			local c_color = mp.faction[v.control] and mp.faction[v.control].color or C_W_100

			local d = math.floor(LocalPlayer():GetPos():Distance(pos) / 10)

			draw.RoundedBox(0, 0, 0, 5, h, c_color)
			mp.Icon(0, 0, w / 2, h, mp.Material.GRADIENT_L, ColorAlpha(c_color, 15))
			mp.Icon(0, 0, w / 2, 1, mp.Material.GRADIENT_L, ColorAlpha(c_color, 50))
			mp.Icon(0, h - 1, w / 2, 1, mp.Material.GRADIENT_L, ColorAlpha(c_color, 50))

			draw.SimpleText(v.name, title_font, 10, 5, mp.Color.WHITE, 0, 0)
			draw.SimpleText(c_text, ammo_type, 10, h / 2, c_color, 0, 0)
			draw.SimpleText(d .. "м", ammo_type, w - 10, h / 2, mp.Color.PURPLE, 2, 1)
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
		if pl:GetRadioSpeak() then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		if not pl:GetRadioSpeak() then
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
		if pl:GetRadioMicro() then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		if not pl:GetRadioMicro() then
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
end

function GM:OnContextMenuClose()
	surface.PlaySound(mp.Sound.ROLLUP_2)

	RunConsoleCommand("-show_compass")

	if IsValid(CMENU_BACKGROUND) then
		CMENU_BACKGROUND:AlphaTo(0, 0.2, 0, function()
			CMENU_BACKGROUND:Remove()
		end)
	end
end
