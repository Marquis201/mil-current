local mp = mp
local ColorAlpha = ColorAlpha
local draw = draw
local vgui = vgui
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime

local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)
local C_B_100 = ColorAlpha(mp.Color.BASE, 100)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)

local welcome_font = mp.font("35:Futura PT Light")
local help_font = mp.font("24:Futura PT Light")
local btn_font = mp.font("20:Futura PT Medium")

local welcome_text = "Здравствуйте, "
local help_text = "Чтобы закрыть меню нажмите F1 "
local dis_text = "Дискорд"
local steam_text = "Контент"
local site_text = "Сайт"
local rules_text = "Правила"
local sound_text = "Остановить звуки"

local url_content = "https://steamcommunity.com/workshop/filedetails/?id=3591107521"
local url_site = "----"
local url_discord = "https://discord.gg/m9MFYp2gDq"
local url_rules = "https://docs.google.com/document/d/1cT8TTT2Cgnwrtbm2yg2IJWWzixyVYOlYFu3jMqjXjdM/edit?pli=1"
local url_ranks = "https://docs.google.com/document/d/1NqF5HXozBNQhTNm756kaOM82hYzT0iCZvNHYw8KhxNM/edit?usp=sharing"

local ButtonsTable = {}

local function CreateButtons(name, icon, open)
	ButtonsTable[#ButtonsTable + 1] = {
		name = name,
		icon = icon,
		open = open,
	}
end

CreateButtons("Контент", mp.Material.STEAM, function() gui.OpenURL(url_content) end)
CreateButtons("Сайт", mp.Material.SITE, function() gui.OpenURL(url_site) end)
CreateButtons("Дискорд", mp.Material.DISCORD, function() gui.OpenURL(url_discord) end)
CreateButtons("Правила", mp.Material.RULES, function() gui.OpenURL(url_rules) end)
CreateButtons("Правила Сторон", mp.Material.RULES, function() gui.OpenURL(url_ranks) end)
CreateButtons("Карта Местности", mp.Material.RULES, function()
	RunConsoleCommand("say", "/map")
	surface.PlaySound(mp.Sound.CLICK_2)
end)

local function CreateHelpMenu()
	local scrw, scrh = ScrW(), ScrH()
	local ply = LocalPlayer()

	if IsValid(CREATE_HELP) then
		CREATE_HELP:Remove()
	end

	local HelpMenu = vgui.Create("EditablePanel")
	CREATE_HELP = HelpMenu
	HelpMenu:SetSize(scrw, scrh)
	HelpMenu:SetPos(0, 0)
	HelpMenu:MakePopup()
	HelpMenu:SetAlpha(0)
	HelpMenu:AlphaTo(255, 0.2, 0)
	HelpMenu.Paint = function(self, w, h)
		mp.BlurBG(self, 2)

		draw.RoundedBox(0, 0, 0, w, h, C_B_150)

		mp.Icon(w / 2 - 128, 20, 256, 256, mp.Material.LOGO, C_W_200)

		draw.SimpleText(welcome_text .. ply:Name(), welcome_font, 25, 25, mp.Color.WHITE, 0, 0)
		draw.SimpleText(help_text, help_font, 25, 55, mp.Color.YELLOW, 0, 0)
	end

	for k, v in ipairs(ButtonsTable) do
		local BtnPanel = vgui.Create("DButton", HelpMenu)
		BtnPanel:SetSize(200, 48)
		BtnPanel:SetText("")
		BtnPanel:SetVisible(true)
		BtnPanel.Hover = 0
		BtnPanel:SetPos(10, scrh / 3 + (58 * k))
		BtnPanel.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 15, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE_TO)

			mp.Icon(0, 1, w, h - 1, mp.Material.GRADIENT_D, C_B_100)
			mp.Icon(0, 1, w, h - 1, mp.Material.GRADIENT_L, C_B_150)
			mp.Icon(0, 1, w, h - 1, mp.Material.GRADIENT_R, C_B_150)
			mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_100)

			mp.Icon(10, h / 2 - 16, 32, 32, v.icon, mp.Color.BASE)

			mp.Text(v.name, btn_font, w / 2, h / 2, mp.Color.WHITE, 1, 1)

			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover))

			mp.Icon(10, h / 2 - 16, 32, 32, v.icon, ColorAlpha(mp.Color.BLACK, self.Hover))

			mp.Text(v.name, btn_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, self.Hover), 1, 1)
		end

		BtnPanel.OnCursorEntered = function()
			surface.PlaySound(mp.Sound.CLICK)
		end

		BtnPanel.DoClick = function(self)
			surface.PlaySound(mp.Sound.CLICK_2)

			v.open()
		end
	end

	local Dealy = CurTime() + 0.5
	HelpMenu.Think = function(self, w, h)
		if Dealy > CurTime() then return end

		if input.IsKeyDown(KEY_F1) then
			if IsValid(self) then
				self:AlphaTo(0, 0.2, 0, function()
					self:Remove()
				end)

				surface.PlaySound(mp.Sound.ROLLUP_2)
			end
		end

		if IsValid(self) and not ply:Alive() then
			self:AlphaTo(0, 0.2, 0, function()
				self:Remove()
			end)

			surface.PlaySound(mp.Sound.ROLLUP_2)
		end
	end

	local VoiceButton = vgui.Create("DButton", HelpMenu)
	VoiceButton:SetSize(160, 32)
	VoiceButton:SetText("")
	VoiceButton:SetPos(scrw / 2 - 80, scrh - 52)
	VoiceButton.Hover = 0
	VoiceButton.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 150)
		end

		mp.Icon(0, 0, h, h, mp.Material.VOICE_ON, ColorAlpha(mp.Color.WHITE, self.Hover))
		mp.Text(sound_text, btn_font, w, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 2, 1)
	end

	VoiceButton.OnCursorEntered = function()
		surface.PlaySound(mp.Sound.CLICK)
	end

	VoiceButton.DoClick = function(self)
		RunConsoleCommand("stopsound")

		surface.PlaySound(mp.Sound.ERROR_2)
	end
end
concommand.Add("CreateHelpMenu", CreateHelpMenu)

local g_station = nil

net.Receive("mp.PlaySound", function()
	local snd = net.ReadString()

	RunConsoleCommand("stopsound")

	if not snd then return end

	sound.PlayURL(snd, "2d", function(station)
		if (IsValid(station)) then
			if g_station then
				g_station:Stop()
			end

			station:SetPos(LocalPlayer():GetPos())

			station:Play()

			-- Keep a reference to the audio object, so it doesn"t get garbage collected which will stop the sound
			g_station = station
		else
			LocalPlayer():ChatPrint("Invalid URL!")
		end
	end)
end)
