local mp = mp
local ColorAlpha = ColorAlpha
local draw = draw
local vgui = vgui
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime

local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)
local C_W_150 = ColorAlpha(mp.Color.WHITE, 150)
local C_B_100 = ColorAlpha(mp.Color.BASE, 100)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_BS_100 = ColorAlpha(mp.Color.BASE, 100)

local ColorBackground = ColorAlpha(mp.Color.BASE_TO, 200)
local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 100)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
local ColorClose = ColorAlpha(mp.Color.RED, 50)

local welcome_font = mp.font("35:Futura PT Light")
local help_font = mp.font("24:Futura PT Light")
local btn_font = mp.font("20:Futura PT Medium")
local n_font = mp.font("20:DIN Pro Regular")
local n_font2 = mp.font("18:DIN Pro Regular")

local welcome_text = "Здравствуйте, "
local help_text = "Чтобы закрыть меню нажмите F1 "
local dis_text = "Дискорд"
local steam_text = "Контент"
local site_text = "Сайт"
local rules_text = "Правила"
local sound_text = "Остановить звуки"

local url_content = "https://steamcommunity.com/workshop/filedetails/?id=3605141517"
local url_discord_nato = "https://discord.gg/8fb2mXhh7w"
local url_discord_rf = "https://discord.gg/VU65REqS9S"
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
CreateButtons("Дискорд Стороны НАТО", mp.Material.DISCORD, function() gui.OpenURL(url_discord_nato) end)
CreateButtons("Дискорд Стороны РФ", mp.Material.DISCORD, function() gui.OpenURL(url_discord_rf) end)
CreateButtons("Дискорд", mp.Material.DISCORD, function() gui.OpenURL(url_discord) end)
CreateButtons("Правила", mp.Material.RULES, function() gui.OpenURL(url_rules) end)
CreateButtons("Правила Сторон", mp.Material.RULES, function() gui.OpenURL(url_ranks) end)
CreateButtons("Карта Местности", mp.Material.RULES, function()
	RunConsoleCommand("say", "/map")

	if IsValid(CREATE_HELP) then
		CREATE_HELP:AlphaTo(0, 0.2, 0, function()
			CREATE_HELP:Remove()
		end)

		surface.PlaySound(mp.Sound.ROLLUP_2)
	end
end)

local playerStats = {
	{
		text = function(pl)
			return "Имя: " .. pl:Name()
		end
	},

	{
		text = function(pl)
			if not pl:GetNetVar("meta_rank") then return nil end
			return "Звание: " .. pl:GetNetVar("meta_rank")
		end
	},

	{
		text = function(pl)
			return "Сторона: " ..
				((pl:GetFaction() and mp.faction[pl:GetFaction()]) and mp.faction[pl:GetFaction()].title or "Отсутствует")
		end
	},

	{
		text = function(pl)
			return "Специальность: " .. pl:FeatureName()
		end
	},

	{
		text = function(pl)
			local time = string.FormattedTime((pl:GetNetVar("PlayTime") or 0) + CurTime())

			return "Время в игре: " .. time.h .. "ч. " .. time.m .. "м. " .. time.s .. "с."
		end
	},

	{
		text = function(pl)
			return "Убийства / Смерти: " .. ((pl:Frags() + pl:Deaths()) / 2)
		end
	},
}

local function CreateHelpMenu()
	local scrw, scrh = ScrW(), ScrH()
	local pl = LocalPlayer()

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

		--[[

		draw.SimpleText(welcome_text .. ply:Name(), welcome_font, 25, 25, mp.Color.WHITE, 0, 0)
		draw.SimpleText(help_text, help_font, 25, 55, mp.Color.YELLOW, 0, 0)]]
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

		if IsValid(self) and not pl:Alive() then
			self:AlphaTo(0, 0.2, 0, function()
				self:Remove()
			end)

			surface.PlaySound(mp.Sound.ROLLUP_2)
		end
	end

	local wide_p = HelpMenu:GetWide() / 4 - 100

	local FillPanel = vgui.Create("Panel", HelpMenu)
	FillPanel:Dock(FILL)
	FillPanel:DockMargin(50, 0, 50, 0)

	local PlayerStats = vgui.Create("Panel", FillPanel)
	PlayerStats:Dock(LEFT)
	PlayerStats:SetWide(HelpMenu:GetWide() / 2 - 100)
	PlayerStats.Paint = function(self, w, h)
		local wide = w - wide_p

		draw.RoundedBox(0, 0, 0, wide, h, ColorBackground)
		draw.RoundedBox(0, 10, 10, wide - 20, 42, ColorBackground)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, wide, h, 1)
		surface.DrawOutlinedRect(10, 10, wide - 20, 42, 1)

		draw.SimpleText("Основная информация", n_font, wide / 2, 30, mp.Color.BASE, 1, 1)
	end

	local addY = 0
	for k, v in ipairs(playerStats) do
		if not v.text(pl) then continue end

		addY = addY + 1

		local stats_panel = vgui.Create("Panel", PlayerStats)
		stats_panel:SetPos(10, 52 + -32 + addY * 37)
		stats_panel:SetSize(PlayerStats:GetWide() - wide_p - 20, 32)
		stats_panel:DockMargin(10, 52, 10, 10)
		stats_panel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, C_B_10)

			draw.SimpleText(v.text(pl), n_font2, 10, h / 2, C_W_150, 0, 1)
		end
	end

	local ChooseModel = vgui.Create("DModelPanel", PlayerStats)
	ChooseModel:SetFOV(mp.Wide(22))
	ChooseModel:Dock(RIGHT)
	ChooseModel:SetWide(wide_p)
	ChooseModel:SetModel(pl:GetModel())
	ChooseModel.Angles = Angle(0, 75, 0)
	ChooseModel:SetCamPos(Vector(0, 100, 50))
	ChooseModel:SetDirectionalLight(BOX_RIGHT, mp.Color.WHITE)
	ChooseModel:SetDirectionalLight(BOX_BACK, mp.Color.WHITE)
	ChooseModel:SetDirectionalLight(BOX_FRONT, mp.Color.BLACK)
	ChooseModel.Hover = 0
	function ChooseModel:DragMousePress()
		self.PressX, self.PressY = input.GetCursorPos()
		self.Pressed = true
	end

	function ChooseModel:DragMouseRelease()
		self.Pressed = false
	end

	function ChooseModel:LayoutEntity(ent)
		if (self.bAnimated) then self:RunAnimation() end

		local mx, my = input.GetCursorPos()

		if (self.Pressed) then
			ChooseModel.Hover = Lerp(FrameTime() * 2, ChooseModel.Hover, (self.PressX or mx) - mx)

			self.Angles = self.Angles - Angle(0, ChooseModel.Hover, 0)
			self.PressX, self.PressY = input.GetCursorPos()
		else
			ChooseModel.Hover = Lerp(FrameTime() * 4, ChooseModel.Hover, 0)

			self.Angles = self.Angles - Angle(0, ChooseModel.Hover, 0)
			self.PressX, self.PressY = input.GetCursorPos()
		end

		ent:SetAngles(self.Angles)
		ent:SetPos(Vector(0, 0, 2))
	end

	if pl:GetSaveBodygroup() and pl:GetSaveBodygroup()[pl:GetModel()] then
		local t = pl:GetSaveBodygroup()[pl:GetModel()]

		if t.skin then
			ChooseModel.Entity:SetSkin(tonumber(t.skin))
		end

		if t.bodygroup then
			for id, typ in pairs(t.bodygroup) do
				if not tonumber(id) or not tonumber(typ) then continue end

				ChooseModel.Entity:SetBodygroup(tonumber(id), tonumber(typ))
			end
		end
	end

	local PlayerPanel = vgui.Create("Panel", HelpMenu)
	PlayerPanel:Dock(TOP)
	PlayerPanel:SetTall(64)
	PlayerPanel:DockMargin(50, 20, 50, 20)

	PlayerPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
		draw.RoundedBox(0, h + 10, 10, 2, h - 20, ColorOutline)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText(pl:GetName(), n_font, h + 25, h / 2, mp.Color.WHITE, 0, 4)
		draw.SimpleText(pl:SteamID(), n_font2, h + 25, h / 2, C_W_100, 0, 0)
	end


	local BottomPanel = vgui.Create("Panel", HelpMenu)
	BottomPanel:Dock(BOTTOM)
	BottomPanel:SetTall(42)
	BottomPanel:DockMargin(50, 20, 50, 20)

	BottomPanel.Paint = function(self, w, h)
		--draw.RoundedBox(0, 0, 0, w, h, ColorBackground)

		--surface.SetDrawColor(ColorOutline)
		--surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	local ExitBtn = vgui.Create("DButton", BottomPanel)
	ExitBtn:Dock(LEFT)
	ExitBtn:SetWide(125)
	ExitBtn:DockMargin(0, 0, 0, 0)
	ExitBtn:SetText("")
	ExitBtn.Hover = 0
	ExitBtn.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

		surface.SetDrawColor(self:IsHovered() and ColorOutline or ColorClose)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText("F1 | Закрыть", n_font2, w / 2, h / 2, ColorAlpha(ColorClose, 150 - self.Hover), 1,
			1)
		draw.SimpleText("F1 | Закрыть", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
	end

	ExitBtn.DoClick = function(self)
		if IsValid(HelpMenu) then
			HelpMenu:AlphaTo(0, 0.2, 0, function()
				HelpMenu:Remove()
			end)

			surface.PlaySound(mp.Sound.ROLLUP_2)
		end
	end

	local StopSound = vgui.Create("DButton", BottomPanel)
	StopSound:Dock(LEFT)
	StopSound:SetWide(150)
	StopSound:DockMargin(10, 0, 0, 0)
	StopSound:SetText("")
	StopSound.Hover = 0
	StopSound.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText("Остановить звуки", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
			1)
		draw.SimpleText("Остановить звуки", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
	end

	StopSound.DoClick = function(self)
		RunConsoleCommand("stopsound")
	end

	local Avatar = vgui.Create("AvatarImage", PlayerPanel)
	Avatar:SetSize(PlayerPanel:GetTall() - 10, PlayerPanel:GetTall() - 10)
	Avatar:SetPos(5, 5)
	Avatar:SetPlayer(pl, PlayerPanel:GetTall())

	for k, v in ipairs(ButtonsTable) do
		surface.SetFont(btn_font)
		local size_x = surface.GetTextSize(v.name)

		local BtnPanel = vgui.Create("DButton", PlayerPanel)
		BtnPanel:Dock(RIGHT)
		BtnPanel:SetWide(size_x + 30)
		BtnPanel:DockMargin(-22, 5, 20, 5)
		BtnPanel:SetText("")
		BtnPanel:SetVisible(true)
		BtnPanel.Hover = 0
		BtnPanel.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 15, self.Hover, 200)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 50)
			end

			draw.RoundedBox(0, 0, 10, w, h - 20, ColorAlpha(mp.Color.BASE, -50 + self.Hover / 2))

			mp.Text(v.name, btn_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)

			draw.RoundedBox(0, 0, 10, 2, h - 20, ColorOutline)
		end

		BtnPanel.OnCursorEntered = function()
			surface.PlaySound(mp.Sound.CLICK)
		end

		BtnPanel.DoClick = function(self)
			surface.PlaySound(mp.Sound.CLICK_2)

			v.open()
		end
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
