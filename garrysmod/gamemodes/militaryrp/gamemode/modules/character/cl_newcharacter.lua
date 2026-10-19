local mp = mp
local ColorAlpha = ColorAlpha
local draw = draw
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime
local netstream = netstream
local Angle, Vector = Angle, Vector
local Color = Color
local vgui = vgui

local add_text = "Создать персонажа"
local welcome_text = "Добро пожаловать"
local number_text = "Номер: "
local new_text = "Новый персонаж"
local goback_text = "⋘ Назад"
local exit_text = "× Закрыть"
local secont_text = "Фамилия"
local save_text = "Сохранить"
local limite_text = "Достигнут лимит"
local rf_text = "РОССИЙСКАЯ ФЕДЕРАЦИЯ"
local pmc_text = "НАТО"

local select_font = mp.font("30:mr_ApexMk3MediumG")
local add_font = mp.font("70:mr_ApexMk3MediumG")
local teams_font = mp.font("50:mr_ApexMk3MediumG")
local character_font = mp.font("35:Futura PT Medium")
local welcome_font = mp.font("50:Futura PT Book")
local err_font = mp.font("22:Montserrat Light")
local save_font = mp.font("30:Futura PT Light")
local team_font = mp.font("20:DIN Pro Regular")
local number_font = mp.font("22:Montserrat Light")
local goback_font = mp.font("25:Futura PT Book")
local desc_font = mp.font("20:Montserrat Light")
local n_font = mp.font("25:DIN Pro Regular")
local second_font = mp.font("25:Futura PT Light")
local admin_font = mp.font("18:Montserrat Light")
local limite_font = mp.font("35:Futura PT Light")
local info_fonts = mp.font("18:DIN Pro Regular")

local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)

local C_W_5 = ColorAlpha(mp.Color.WHITE, 5)
local C_W_15 = ColorAlpha(mp.Color.WHITE, 15)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)

local C_R_100 = ColorAlpha(mp.Color.RED, 100)
local C_R_25 = ColorAlpha(mp.Color.RED, 25)
local C_R_10 = ColorAlpha(mp.Color.RED, 10)

local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)

local ColorBackground = ColorAlpha(mp.Color.BASE_TO, 200)
local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 100)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)

local nato_desc =
[[В данном конфликте представляет собой коалицию государств, которая, обвиняя Россию в поддержке диверсий и радикальных группировок в Прибалтике, действует как единый оборонный блок.
Его целью является сдерживание и защита союзников путём развёртывания многонациональных сил быстрого реагирования и ведения операций, основанных на стандартизированной тактике и технологическом превосходстве.]]

local rf_desc =
[[Выступает как национальное государство, отрицающее прямое вмешательство и рассматривающее события как внутренние дела региона, а усиление НАТО — как угрозу.
Её действия направлены на защиту стратегических интересов через демонстрацию военной мощи и готовность к ведению комбинированных боевых действий с упором на интеграцию различных родов войск и нерегулярные методы.]]

function mp.NewCharacter(characters)
	if IsValid(CREATE_MENU) then
		CREATE_MENU:AlphaTo(0, 0.1, 0, function()
			CREATE_MENU:Remove()
		end)
	end

	local LastName = {
		[mp.faction.rf.default_team] = {
			-- Русские фамилии
			"Иванов", "Смирнов", "Кузнецов", "Попов", "Васильев", "Петров", "Соколов", "Михайлов", "Новиков",
			"Федоров", "Морозов", "Волков", "Алексеев", "Лебедев", "Семенов", "Егоров", "Павлов", "Козлов", "Степанов",
			"Николаев", "Орлов", "Андреев", "Макаров", "Никитин", "Захаров", "Зайцев", "Соловьев", "Борисов", "Яковлев",
			"Григорьев", "Романов", "Воробьев", "Сергеев", "Кузьмин", "Фролов", "Александров", "Дмитриев", "Королев",
			"Гусев", "Киселев", "Ильин", "Максимов", "Поляков", "Сорокин", "Виноградов", "Ковалев", "Белов", "Медведев",
		},
		[mp.faction.nato.default_team] = {
			-- Американские фамилии
			"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
			"Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin",
			"Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson",
			"Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores",
			"Green", "Adams", "Baker", "Hall", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner"
		},
	}

	local text =
	[[ Military-play RP — Сервер созданый для симуляции ведения тактического боя в условиях реального опыта.]]

	local scrw, scrh = ScrW(), ScrH()
	local pl = LocalPlayer()

	local NameEntry
	local select_team_group = false
	local CreateMenu = vgui.Create("EditablePanel")
	CREATE_MENU = CreateMenu
	CreateMenu:SetPos(0, 0)
	CreateMenu:SetSize(scrw, scrh)
	CreateMenu:SetAlpha(0)
	CreateMenu:AlphaTo(255, 0.5, 0)
	CreateMenu.Paint = function(self, w, h)
		mp.BlurBG(self, 4)

		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
		mp.Icon(0, h / 2, w, h / 2, mp.Material.GRADIENT_D, mp.Color.BLACK)

		draw.SimpleText(
			select_team_group and (select_team_group == mp.faction.rf.default_team and rf_text or pmc_text) or
			"Выберите сторону", select_font, w / 2, 30, C_W_100, 1, 0)
	end

	CreateMenu:MakePopup()

	local RFTeam = vgui.Create("DButton", CreateMenu)
	RFTeam:SetSize(CreateMenu:GetWide() / 3.5, CreateMenu:GetTall())
	RFTeam:SetPos(CreateMenu:GetWide() - RFTeam:GetWide(), 0)
	RFTeam:SetText("")
	RFTeam:SetVisible(true)
	RFTeam.Hover = 0
	RFTeam.HoverIcon = 0
	RFTeam.HoverText = 0
	RFTeam.Paint = function(self, w, h)
		local iw, ih = 600, 1000

		if select_team_group == mp.faction.rf.default_team then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			self.HoverIcon = Lerp(FrameTime() * 10, self.HoverIcon, h - ih / 2)
			self.HoverText = Lerp(FrameTime() * 10, self.HoverText, 255)
		elseif self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			self.HoverIcon = Lerp(FrameTime() * 10, self.HoverIcon, h - ih / 2)
			self.HoverText = Lerp(FrameTime() * 10, self.HoverText, 0)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 150)
			self.HoverIcon = Lerp(FrameTime() * 10, self.HoverIcon, h)
			self.HoverText = Lerp(FrameTime() * 10, self.HoverText, 0)
		end

		mp.Icon(w / 2 - iw / 2, self.HoverIcon - ih / 2, iw, ih, mp.Material.RF_SOLDIER,
			ColorAlpha(color_white, self.Hover))

		mp.Icon(w / 2, h - 128, 64, 64, mp.Material.RF_LOGO, ColorAlpha(color_white, self.Hover))
	end

	RFTeam.DoClick = function(self)
		surface.PlaySound(mp.Sound.CLICK_8)

		select_team_group = mp.faction.rf.default_team
		if NameEntry then
			NameEntry:SetText(table.Random(LastName[mp.faction.rf.default_team]))
		end
	end

	RFTeam.OnCursorEntered = function(self)
		surface.PlaySound(mp.Sound.HOVER)
	end

	local BaseDescFaction = vgui.Create("Panel", RFTeam)
	BaseDescFaction:SetSize(RFTeam:GetWide() / 1.1, RFTeam:GetTall() / 4)
	BaseDescFaction:SetPos(RFTeam:GetWide() / 2 - BaseDescFaction:GetWide() / 2,
		RFTeam:GetTall() / 2 - BaseDescFaction:GetTall() / 2)

	BaseDescFaction.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorBackground)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.RoundedBox(0, 1, 42, w - 2, 1, ColorOutline)

		draw.SimpleText(rf_text, select_font, 10, 21, mp.Color.BASE, 0, 1)
	end

	local DescriptionRF = vgui.Create("DLabel", BaseDescFaction)
	DescriptionRF:Dock(TOP)
	DescriptionRF:DockMargin(10, 52, 10, 10)
	DescriptionRF:SetFont(desc_font)
	DescriptionRF:SetVisible(true)
	DescriptionRF:SetText(rf_desc)
	DescriptionRF:SetFont(desc_font)
	DescriptionRF:SetWrap(true)
	DescriptionRF:SetContentAlignment(7)
	DescriptionRF:SetAutoStretchVertical(true)
	DescriptionRF:SetTextColor(color_white)

	RFTeam.Think = function(self, w, h)
		BaseDescFaction:SetAlpha(self.HoverText)
		BaseDescFaction:SizeToContents()
		BaseDescFaction:SetY(RFTeam:GetTall() / 2 - BaseDescFaction:GetTall() / 2)
	end

	local PMCTeam = vgui.Create("DButton", CreateMenu)
	PMCTeam:SetSize(CreateMenu:GetWide() / 3.5, CreateMenu:GetTall())
	PMCTeam:SetPos(0, 0)
	PMCTeam:SetText("")
	PMCTeam:SetVisible(true)
	PMCTeam.Hover = 0
	PMCTeam.HoverIcon = 0
	PMCTeam.HoverText = 0
	PMCTeam.Paint = function(self, w, h)
		local iw, ih = 600, 1000

		if select_team_group == mp.faction.nato.default_team then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			self.HoverIcon = Lerp(FrameTime() * 10, self.HoverIcon, h - ih / 2)
			self.HoverText = Lerp(FrameTime() * 10, self.HoverText, 255)
		elseif self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			self.HoverIcon = Lerp(FrameTime() * 10, self.HoverIcon, h - ih / 2)
			self.HoverText = Lerp(FrameTime() * 10, self.HoverText, 0)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 150)
			self.HoverIcon = Lerp(FrameTime() * 10, self.HoverIcon, h)
			self.HoverText = Lerp(FrameTime() * 10, self.HoverText, 0)
		end

		mp.Icon(w / 2 - iw / 2, self.HoverIcon - ih / 2, iw, ih, mp.Material.NATO_SOLDIER,
			ColorAlpha(color_white, self.Hover))

		mp.Icon(w / 2, h - 128, 64, 64, mp.Material.NATO_LOGO, ColorAlpha(color_white, self.Hover))
	end


	PMCTeam.OnCursorEntered = function(self)
		surface.PlaySound(mp.Sound.HOVER)
	end

	PMCTeam.DoClick = function(self)
		surface.PlaySound(mp.Sound.CLICK_8)

		select_team_group = mp.faction.nato.default_team

		if NameEntry then
			NameEntry:SetText(table.Random(LastName[mp.faction.nato.default_team]))
		end
	end

	local BaseDescFactionNato = vgui.Create("Panel", PMCTeam)
	BaseDescFactionNato:SetSize(RFTeam:GetWide() / 1.1, RFTeam:GetTall() / 4)
	BaseDescFactionNato:SetPos(RFTeam:GetWide() / 2 - BaseDescFactionNato:GetWide() / 2,
		RFTeam:GetTall() / 2 - BaseDescFactionNato:GetTall() / 2)

	BaseDescFactionNato.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorBackground)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.RoundedBox(0, 1, 42, w - 2, 1, ColorOutline)

		draw.SimpleText(pmc_text, select_font, 10, 21, mp.Color.BASE, 0, 1)
	end

	local DescriptionNATO = vgui.Create("DLabel", BaseDescFactionNato)
	DescriptionNATO:Dock(TOP)
	DescriptionNATO:DockMargin(10, 52, 10, 10)
	DescriptionNATO:SetFont(desc_font)
	DescriptionNATO:SetVisible(true)
	DescriptionNATO:SetText(nato_desc)
	DescriptionNATO:SetFont(desc_font)
	DescriptionNATO:SetWrap(true)
	DescriptionNATO:SetContentAlignment(7)
	DescriptionNATO:SetAutoStretchVertical(true)
	DescriptionNATO:SetTextColor(color_white)

	PMCTeam.Think = function(self, w, h)
		BaseDescFactionNato:SetAlpha(self.HoverText)
		BaseDescFactionNato:SizeToContents()
		BaseDescFactionNato:SetY(PMCTeam:GetTall() / 2 - BaseDescFactionNato:GetTall() / 2)
	end

	local NewCharacter = vgui.Create("DPanel", CreateMenu)
	NewCharacter:SetSize(360, 200)
	NewCharacter:Center()
	NewCharacter.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
		draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
		mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

		mp.Text(new_text, team_font, w / 2, 20, mp.Color.BASE, 1, 1)
	end

	NewCharacter.Hover = 0

	NameEntry = vgui.Create("DTextEntry", NewCharacter)
	NameEntry:Dock(TOP)
	NameEntry:SetSize(0, 32)
	NameEntry:DockMargin(10, 50, 10, 10)
	NameEntry:SetPaintBorderEnabled(true)
	NameEntry:SetFont(desc_font)
	NameEntry:SetVisible(true)
	NameEntry:SetAllowNonAsciiCharacters(true)
	NameEntry:SetText("")
	NameEntry.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
		self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
	end

	local RandomID = vgui.Create("DButton", NewCharacter)
	RandomID:Dock(TOP)
	RandomID:SetSize(0, 32)
	RandomID:DockMargin(10, 0, NewCharacter:GetWide() / 2, 10)
	RandomID:SetText("Случайная фамилия")
	RandomID:SetColor(Color(0, 0, 0, 0))
	RandomID.Hover = 0
	RandomID.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

		surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1, 1)
		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
	end

	RandomID.OnCursorEntered = function(self)
		surface.PlaySound(mp.Sound.HOVER_2)
	end

	RandomID.DoClick = function(self)
		surface.PlaySound(mp.Sound.SELECT)

		NameEntry:SetText(select_team_group and table.Random(LastName[select_team_group]) or
			table.Random(LastName[mp.faction.rf.default_team]))
	end

	local SaveCharacter = vgui.Create("DButton", NewCharacter)
	SaveCharacter:Dock(BOTTOM)
	SaveCharacter:SetTall(50)
	SaveCharacter:DockMargin(10, 10, 10, 10)
	SaveCharacter:SetText("Создать")
	SaveCharacter:SetTextColor(Color(0, 0, 0, 0))
	SaveCharacter.Hover = 0
	SaveCharacter.Paint = function(self, w, h)
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

		draw.SimpleText(self:GetText(), team_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
			1)
		draw.SimpleText(self:GetText(), team_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
	end

	local GoBack = vgui.Create("DButton", CreateMenu)
	GoBack:SetSize(90, 30)
	GoBack:SetPos(NewCharacter:GetX() - 95, NewCharacter:GetY())
	GoBack:SetText("Назад")
	GoBack:SetColor(Color(0, 0, 0, 0))
	GoBack.Hover = 0
	GoBack.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

		surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1, 1)
		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
	end

	GoBack.OnCursorEntered = function(self)
		surface.PlaySound(mp.Sound.HOVER_2)
	end

	GoBack.DoClick = function(self)
		surface.PlaySound(mp.Sound.SELECT)

		mp.CharacterMenu({ characters = characters })

		CreateMenu:AlphaTo(0, 0.4, 0, function()
			CreateMenu:Remove()
		end)
	end

	NewCharacter.Think = function(self, w, h)
		self.Hover = Lerp(FrameTime() * 10, self.Hover, select_team_group and 255 or 0)
		self:SetAlpha(self.Hover)
		GoBack:SetAlpha(self.Hover)
	end

	SaveCharacter.OnCursorEntered = function(self)
		surface.PlaySound(mp.Sound.HOVER_2)
	end

	SaveCharacter.DoClick = function(self)
		surface.PlaySound(mp.Sound.SELECT)

		if not select_team_group then return end

		netstream.Start("NewPlayerCharacter", {
			name = NameEntry:GetValue(),
			start_team = select_team_group
		})

		CreateMenu:AlphaTo(0, 0.4, 0, function()
			CreateMenu:Remove()
		end)
	end
end
