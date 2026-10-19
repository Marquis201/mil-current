moonEsc = moonEsc or {}

local escpanel
hook.Add("PreRender", "moonEsc.PreRender", function()
	if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
		if ValidPanel(escpanel) then
			gui.HideGameUI()
			moonEsc.Open(false)
		else
			gui.HideGameUI()
			moonEsc.Open(true)
		end
	end
end)

-- Цвета из донат-меню
local color_background = Color(29, 29, 29, 225)
local color_panel = Color(108, 117, 125)
local color_bottom = Color(33, 37, 41)

-- Шрифты из донат-меню
local title_font
local goback_font
local cat_font
local welcome_font
local name_font
local price_font
local draw = draw
local surface = surface
local vgui = vgui
local Color = Color
local ColorAlpha = ColorAlpha

-- Безопасная инициализация шрифтов
timer.Simple(1, function()
	local mp = mp

	title_font = mp and mp.font and mp.font("40:Futura PT Medium") or "DermaLarge"
	goback_font = mp and mp.font and mp.font("25:mr_ApexMk3MediumG") or "DermaDefault"
	cat_font = mp and mp.font and mp.font("24:Futura PT Book") or "DermaDefault"
	welcome_font = mp and mp.font and mp.font("30:Futura PT Book") or "DermaDefault"
	name_font = mp and mp.font and mp.font("25:Futura PT Light") or "DermaDefault"
	price_font = mp and mp.font and mp.font("22:Futura PT Medium") or "DermaDefault"
end)

local title_text = "MILITARY PLAY"
local exit_text = "× Закрыть"
local welcome_text = "Здравствуйте, "

moonEsc.Buttons = {
	{
		name = "Закрыть панель",
		f = function()
			if gui and gui.HideGameUI then
				gui.HideGameUI()
			end
			moonEsc.Open(false)
		end,
	},
	{
		name = "Изменить настройки игры",
		f = function()
			moonEsc.Open(false)
			if gui and gui.ActivateGameUI then
				gui.ActivateGameUI()
			end
			RunConsoleCommand("gamemenucommand", "openoptionsdialog")
		end,
	},
	{
		name = "Купить донат",
		f = function()
			RunConsoleCommand("mp.CreateDonateMenu")
			moonEsc.Open(false)
		end,
	},
	{
		name = "Правила сервера",
		f = function()
			-- Безопасное открытие URL
			timer.Simple(0.1, function()
				if gui and gui.OpenURL then
					gui.OpenURL(
						"https://docs.google.com/document/d/1cT8TTT2Cgnwrtbm2yg2IJWWzixyVYOlYFu3jMqjXjdM/edit?pli=1")
				end
			end)
		end,
	},
	{
		name = "Отключиться от сервера",
		f = function() RunConsoleCommand("disconnect") end
	}
}

local function GetPlayerBalance()
	local ply = LocalPlayer()
	if ply and ply.GetMoney then
		return ply:GetMoney() or 0
	end
	return 0
end

local function FormatBalance(balance)
	return string.Comma(balance) .. " RUB"
end

local function SafeDrawText(font, text, x, y, color, xalign, yalign)
	if draw and draw.SimpleText then
		draw.SimpleText(text, font, x, y, color, xalign, yalign)
	end
end

local function open(bool)
	if ValidPanel(escpanel) then
		escpanel:AlphaTo(0, 0.2, 0, function()
			if ValidPanel(escpanel) then
				escpanel:Remove()
				escpanel = nil
			end

			surface.PlaySound(mp.Sound.DEPLOY_2)
		end)
	end

	if gui and gui.EnableScreenClicker then
		gui.EnableScreenClicker(bool)
	end

	if not bool then return end

	local scrw, scrh = ScrW(), ScrH()
	local ply = LocalPlayer()
	local mp = mp

	local color_title = ColorAlpha(mp.Color.BASE_TO, 200)
	local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
	local color_text = ColorAlpha(mp.Color.BASE, 200)
	local color_item = ColorAlpha(mp.Color.BASE_TO, 150)
	local color_name = mp.Color.BASE

	surface.PlaySound(mp.Sound.DEPLOY)

	escpanel = vgui.Create("EditablePanel")
	escpanel:SetSize(scrw, scrh)
	escpanel:SetPos(0, 0)
	escpanel:MakePopup()
	escpanel:SetAlpha(0)
	escpanel:AlphaTo(255, 0.2, 0)

	escpanel.Paint = function(self, w, h)
		-- Безопасное блюр
		if mp and mp.BlurBG then
			mp.BlurBG(self, 1)
		end

		draw.RoundedBox(0, 0, 0, w, h, color_background)

		-- Верхняя и нижняя панели как в донат-меню
		draw.RoundedBox(0, 0, 0, w, 64, color_title)
		draw.RoundedBox(0, 0, h - 64, w, 64, color_title)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, 64, 1)
		surface.DrawOutlinedRect(0, h - 64, w, 64, 1)

		-- Заголовок
		SafeDrawText(title_font or "DermaLarge", title_text, w / 2, 32, color_white, 1, 1)

		-- Приветствие и баланс
		if ply then
			SafeDrawText(welcome_font or "DermaDefault", welcome_text .. ply:Name(), w - 25, h - 32, color_name, 2, 1)

			local current_balance = GetPlayerBalance()
			local balance_display = "Баланс: " .. FormatBalance(current_balance)
			SafeDrawText(welcome_font or "DermaDefault", balance_display, 25, h - 32, color_name, 0, 1)
		end
	end

	-- Основная панель с кнопками
	local MainPanel = vgui.Create("DPanel", escpanel)
	MainPanel:SetSize(400, 400)
	MainPanel:Center()
	MainPanel:SetAlpha(0)
	MainPanel:AlphaTo(255, 0.3, 0.1)
	MainPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, color_item)
		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	-- Создание кнопок меню
	local buttonHeight = 60
	local buttonSpacing = 10
	local totalHeight = (#moonEsc.Buttons * buttonHeight) + ((#moonEsc.Buttons - 1) * buttonSpacing)
	local startY = (400 - totalHeight) / 2

	for i, buttonInfo in ipairs(moonEsc.Buttons) do
		local Button = vgui.Create("DButton", MainPanel)
		Button:SetSize(360, buttonHeight)
		Button:SetPos(20, startY + ((i - 1) * (buttonHeight + buttonSpacing)))
		Button:SetText("")
		Button.Hover = 0

		Button.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, color_item)
			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_text, self.Hover))

			SafeDrawText(cat_font or "DermaDefault", buttonInfo.name, w / 2, h / 2,
				ColorAlpha(color_text, 255 - self.Hover), 1, 1)
			SafeDrawText(cat_font or "DermaDefault", buttonInfo.name, w / 2, h / 2,
				ColorAlpha(color_title, self.Hover), 1, 1)
		end

		Button.DoClick = function()
			buttonInfo.f()
			surface.PlaySound(mp.Sound.CLICK_2)
		end

		function Button:OnCursorEntered()
			surface.PlaySound(mp.Sound.HOVER_2)
		end
	end

	-- Обработка закрытия по ESC
	local Dealy = CurTime() + 0.5
	escpanel.Think = function(self)
		if input.IsKeyDown(KEY_ESCAPE) and Dealy < CurTime() then
			if IsValid(self) then
				self:AlphaTo(0, 0.2, 0, function()
					if IsValid(self) then
						self:Remove()
					end

					surface.PlaySound(mp.Sound.DEPLOY_2)
				end)
				if gui and gui.HideGameUI then
					gui.HideGameUI()
				end
				Dealy = CurTime() + 0.5
			end
		end
	end
end

moonEsc.Open = open
