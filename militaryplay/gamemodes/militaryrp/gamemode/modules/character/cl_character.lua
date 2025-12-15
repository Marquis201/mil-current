local LastName = {
	[TEAM_CADETRF] = {
		-- Русские фамилии
		"Иванов", "Смирнов", "Кузнецов", "Попов", "Васильев", "Петров", "Соколов", "Михайлов", "Новиков",
		"Федоров", "Морозов", "Волков", "Алексеев", "Лебедев", "Семенов", "Егоров", "Павлов", "Козлов", "Степанов",
		"Николаев", "Орлов", "Андреев", "Макаров", "Никитин", "Захаров", "Зайцев", "Соловьев", "Борисов", "Яковлев",
		"Григорьев", "Романов", "Воробьев", "Сергеев", "Кузьмин", "Фролов", "Александров", "Дмитриев", "Королев",
		"Гусев", "Киселев", "Ильин", "Максимов", "Поляков", "Сорокин", "Виноградов", "Ковалев", "Белов", "Медведев",
	},
	[TEAM_CADET] = {
		-- Американские фамилии
		"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
		"Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin",
		"Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson",
		"Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores",
		"Green", "Adams", "Baker", "Hall", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner"
	},
}

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

local add_text = "+"
local welcome_text = "Добро пожаловать"
local number_text = "Номер: "
local new_text = "Новый персонаж"
local goback_text = "⋘ Назад"
local exit_text = "× Закрыть"
local secont_text = "Фамилия"
local save_text = "Сохранить"
local limite_text = "Достигнут лимит"
local rf_text = "РФ"
local pmc_text = "NATO"

local add_font = mp.font("70:mr_ApexMk3MediumG")
local teams_font = mp.font("50:mr_ApexMk3MediumG")
local character_font = mp.font("35:Futura PT Medium")
local welcome_font = mp.font("70:Futura PT Light")
local err_font = mp.font("22:Montserrat Light")
local save_font = mp.font("30:Futura PT Light")
local team_font = mp.font("20:DIN Pro Regular")
local number_font = mp.font("22:Montserrat Light")
local goback_font = mp.font("30:Futura PT Light")
local desc_font = mp.font("20:Montserrat Light")
local n_font = mp.font("25:DIN Pro Regular")
local second_font = mp.font("25:Futura PT Light")
local admin_font = mp.font("18:Montserrat Light")
local limite_font = mp.font("35:Futura PT Light")

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

local function OpenCharacterMenu(data)
	local scrw, scrh = ScrW(), ScrH()
	local pl = LocalPlayer()

	local characters = data.characters
	local err = data.err

	if IsValid(CREATION_MENU) then
		CREATION_MENU:Remove()
	end

	local CreationMenu = vgui.Create("EditablePanel")
	CREATION_MENU = CreationMenu
	CREATION_MENU:SetPos(0, 0)
	CREATION_MENU:SetSize(scrw, scrh)
	CREATION_MENU:SetAlpha(0)
	CREATION_MENU:AlphaTo(255, 0.5, 0)
	CREATION_MENU.Paint = function(self, w, h)
		mp.BlurBG(self, 4)

		draw.RoundedBox(0, 0, 0, w, h, C_B_200)

		draw.SimpleText(welcome_text, welcome_font, w / 2, 25, mp.Color.WHITE, 1)

		if err then
			surface.SetFont(err_font)
			local t_w, t_h = surface.GetTextSize(err)

			t_w, t_h = t_w + 20, t_h + 10

			draw.RoundedBox(0, w / 2 - t_w / 2, h - t_h - 10, t_w, t_h, C_R_25)

			draw.SimpleText(err, err_font, w / 2, h - t_h / 2 - 10, mp.Color.WHITE, 1, 1)
		end
	end

	local GoExit = vgui.Create("DButton", CREATION_MENU)
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
	end

	GO_EXIT.DoClick = function(self)
		CREATION_MENU:AlphaTo(0, 0.4, 0, function()
			CREATION_MENU:Remove()
		end)
	end

	timer.Simple(5, function()
		err = nil
	end)

	CREATION_MENU:MakePopup()

	local cm_wide, cm_tall = CREATION_MENU:GetWide(), CREATION_MENU:GetTall()

	local CharacterScroll = vgui.Create("DScrollPanel", CREATION_MENU)
	CHARACTER_SCROLL = CharacterScroll
	CHARACTER_SCROLL:SetSize(356, 360)
	CHARACTER_SCROLL:SetPos(10, cm_tall / 2 - 256)
	CHARACTER_SCROLL.Hover = 0
	CHARACTER_SCROLL.VBar:SetWide(5)
	CHARACTER_SCROLL.Paint = function(self, w, h)
		local x, y = self:LocalCursorPos()
		local w, h = self:GetWide(), self:GetTall()

		if x < w and x > 0 and y < h and y > 0 then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		self.VBar:SetAlpha(self.Hover)

		draw.RoundedBox(0, 0, 0, w, h, C_W_5)

		mp.Icon(0, h - 10, w, 10, mp.Material.GRADIENT_D, C_B_150)
		mp.Icon(0, 0, w, 10, mp.Material.GRADIENT_U, C_B_150)
	end
	local sbar = CHARACTER_SCROLL:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
	end

	local function ChooseCharacter(char)
		if not char then return end

		if IsValid(CHOOSE_MODEL) then
			CHOOSE_MODEL:Remove()
		end

		local model = mp.jobs[char.team_index].model

		if istable(model) then
			model = table.Random(model)
		end

		if char.model then
			model = char.model
		end

		local ChooseModel = vgui.Create("DModelPanel", CREATION_MENU)
		CHOOSE_MODEL = ChooseModel
		CHOOSE_MODEL:SetFOV(25)
		CHOOSE_MODEL:SetSize(cm_wide / 2.5, cm_tall)
		CHOOSE_MODEL:SetPos(cm_wide, 0)
		CHOOSE_MODEL:MoveTo(cm_wide / 1.6, 0, 0.9, 0, 0.4)
		CHOOSE_MODEL:SetModel(model)
		CHOOSE_MODEL.Angles = Angle(0, 75, 0)
		CHOOSE_MODEL:SetCamPos(Vector(0, 100, 50))
		CHOOSE_MODEL:SetDirectionalLight(BOX_RIGHT, mp.Color.WHITE)
		CHOOSE_MODEL:SetDirectionalLight(BOX_BACK, mp.Color.WHITE)
		CHOOSE_MODEL:SetDirectionalLight(BOX_FRONT, mp.Color.BLACK)
		CHOOSE_MODEL.Hover = 0
		function CHOOSE_MODEL:DragMousePress()
			self.PressX, self.PressY = input.GetCursorPos()
			self.Pressed = true
		end

		function CHOOSE_MODEL:DragMouseRelease()
			self.Pressed = false
		end

		function CHOOSE_MODEL:LayoutEntity(ent)
			if (self.bAnimated) then self:RunAnimation() end

			local mx, my = input.GetCursorPos()

			if (self.Pressed) then
				CHOOSE_MODEL.Hover = Lerp(FrameTime() * 2, CHOOSE_MODEL.Hover, (self.PressX or mx) - mx)

				self.Angles = self.Angles - Angle(0, CHOOSE_MODEL.Hover, 0)
				self.PressX, self.PressY = input.GetCursorPos()
			else
				CHOOSE_MODEL.Hover = Lerp(FrameTime() * 4, CHOOSE_MODEL.Hover, 0)

				self.Angles = self.Angles - Angle(0, CHOOSE_MODEL.Hover, 0)
				self.PressX, self.PressY = input.GetCursorPos()
			end

			ent:SetAngles(self.Angles)
			ent:SetPos(Vector(0, 0, -8))
		end
	end

	local max_characters = mp.config.max_characters[pl:GetUserGroup()] or 1

	characters = characters or {}
	for k, char in pairs(characters) do
		if not char.team_index or not mp.jobs[char.team_index] then continue end
		local team_color = mp.jobs[char.team_index].color
		local name = char.character_name
		local rpid = char.rpid
		local team_name = mp.jobs[char.team_index].Name
		local model = mp.jobs[char.team_index].model
		local C_T_25 = ColorAlpha(team_color, 25)

		local CharPanel = vgui.Create("DPanel", CHARACTER_SCROLL)
		CHAR_PANEL = CharPanel
		CHAR_PANEL:Dock(TOP)
		CHAR_PANEL:SetTall(90)
		CHAR_PANEL:DockMargin(0, 5, 0, 0)
		CHAR_PANEL.Paint = function(self, w, h)
		end

		local CharSelect = vgui.Create("DButton", CHAR_PANEL)
		CHAR_SELECT = CharSelect
		CHAR_SELECT:Dock(FILL)
		CHAR_SELECT:SetText("")
		CHAR_SELECT.Hover = 0
		CHAR_SELECT.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 25)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, C_W_5)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_T_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, C_T_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.WHITE, self.Hover))

			draw.RoundedBox(0, 5, 5, h - 10, h - 10, C_B_100)

			mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_25)
			mp.Icon(0, h - 1, w, 1, mp.Material.GRADIENT_C, C_W_25)

			draw.SimpleText(name, save_font, 95, 10, mp.Color.WHITE, 0, 0)
			draw.SimpleText(team_name, team_font, 95, h / 2, team_color, 0, 1)
			draw.SimpleText(number_text .. rpid, number_font, 95, h - 30, mp.Color.BASE, 0, 0)
		end

		CHAR_SELECT.DoClick = function(self)
			netstream.Start("SpawnPlayerCharacter", { character_id = char.character_id })

			CREATION_MENU:AlphaTo(0, 0.1, 0, function()
				CREATION_MENU:Remove()
			end)

			RunConsoleCommand("stopsound")
		end

		CHAR_SELECT.OnCursorEntered = function(self)
			ChooseCharacter(char)
		end

		function CHAR_SELECT:DoRightClick()
			netstream.Start("RemovePlayerCharacter", { character_id = char.character_id })

			CREATION_MENU:Remove()
		end

		local DModel = vgui.Create("DModelPanel", CHAR_PANEL)
		D_MODEL = DModel
		if istable(model) then
			model = table.Random(model)
		end

		if char.model then
			model = char.model
		end

		D_MODEL:SetModel(model)
		D_MODEL:SetPos(5, 5)
		D_MODEL:SetSize(80, 80)
		D_MODEL:SetFOV(8)

		D_MODEL.Angles = Angle(0, 50, 0)
		D_MODEL:SetCamPos(Vector(140, 50, 60))
		function D_MODEL:LayoutEntity(ent)
			ent:SetPos(Vector(0, 3, -25))
		end

		local DeleteChar = vgui.Create("DButton", CHAR_SELECT)
		DeleteChar:SetSize(32, 32)
		DeleteChar:SetPos(CHARACTER_SCROLL:GetWide() - 37, 5)
		DeleteChar:SetText("")
		DeleteChar.Hover = 0
		DeleteChar.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 125)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 50)
			end

			draw.RoundedBox(0, 0, 0, w, h, C_B_10)

			mp.Icon(w / 2 - 10, h / 2 - 10, 20, 20, mp.Material.CLOSE, ColorAlpha(RED, self.Hover))
		end

		DeleteChar.DoClick = function(self)
			local code = math.random(11111, 9999)
			Derma_StringRequest(
				"Персонаж",
				"Если хотите удалить персонажа, введите в поле: " .. code,
				"",
				function(text)
					if tostring(code) ~= text then return end

					netstream.Start("RemovePlayerCharacter", { character_id = char.character_id })

					CREATION_MENU:Remove()
				end,
				function(text) end
			)
		end

		DeleteChar.OnCursorEntered = function(self)
			mp.ToolTip(self, "Удалить персонажа", mp.Color.RED)
		end
	end

	local function OpenNewCharacterMenu(characters)
		if IsValid(CREATE_MENU) then
			CREATE_MENU:AlphaTo(0, 0.1, 0, function()
				CREATE_MENU:Remove()
			end)
		end

		local text =
		[[ Military-play RP — Сервер созданый для симуляции ведения тактического боя в условиях реального опыта.]]

		local CreateMenu = vgui.Create("EditablePanel")
		CREATE_MENU = CreateMenu
		CREATE_MENU:SetPos(0, 0)
		CREATE_MENU:SetSize(scrw, scrh)
		CREATE_MENU:SetAlpha(0)
		CREATE_MENU:AlphaTo(255, 0.5, 0)
		CREATE_MENU.Paint = function(self, w, h)
			mp.BlurBG(self, 4)

			draw.RoundedBox(0, 0, 0, w, h, C_B_200)

			draw.SimpleText(new_text, character_font, w / 2, h / 2 - 180, mp.Color.WHITE, 1, 1)
		end

		CREATE_MENU:MakePopup()

		local cc_wide, cc_tall = CREATE_MENU:GetWide(), CREATE_MENU:GetTall()

		local NewCharacter = vgui.Create("DPanel", CREATE_MENU)
		NEW_CHARACTER = NewCharacter
		NEW_CHARACTER:SetSize(360, 320)
		NEW_CHARACTER:SetPos(cc_wide * .5 - NEW_CHARACTER:GetWide() * .5, cc_tall * .5 - NEW_CHARACTER:GetTall() * .5)
		NEW_CHARACTER.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, C_W_5)

			mp.Icon(0, 0, w, 10, mp.Material.GRADIENT_U, C_B_150)
		end

		local n_wide, n_tall = NEW_CHARACTER:GetWide(), NEW_CHARACTER:GetTall()

		local DescriptionTab = vgui.Create("DLabel", NEW_CHARACTER)
		DESCTRIPTION_TAB = DescriptionTab
		DESCTRIPTION_TAB:SetSize(350, 260)
		DESCTRIPTION_TAB:SetPos(5, 5)
		DESCTRIPTION_TAB:SetFont(desc_font)
		DESCTRIPTION_TAB:SetVisible(true)
		DESCTRIPTION_TAB:SetText(draw.textWrap(text, desc_font, 350))
		DESCTRIPTION_TAB:SetContentAlignment(7)
		DESCTRIPTION_TAB:SetAutoStretchVertical(true)
		DESCTRIPTION_TAB:SetTextColor(Color(200, 200, 200, 200))

		local select_team_group = false
		local NameEntry = vgui.Create("DTextEntry", NEW_CHARACTER)
		NAME_ENTRY = NameEntry
		NAME_ENTRY:SetSize(n_wide / 1.5 - 5, 30)
		NAME_ENTRY:SetPos(n_wide / 3, 195)
		NAME_ENTRY:SetPaintBorderEnabled(true)
		NAME_ENTRY:SetFont(n_font)
		NAME_ENTRY:SetVisible(true)
		NAME_ENTRY:SetAllowNonAsciiCharacters(true)
		NAME_ENTRY:SetText("")
		NAME_ENTRY.Paint = function(self, w, h)
			surface.SetDrawColor(240, 143, 52, TimedCos(0.5, 100, -50, CurTime()))
			surface.DrawLine(0, h - 1, w, h - 1)

			self:DrawTextEntryText(mp.Color.WHITE, mp.Color.BASE_TO, mp.Color.WHITE)
		end

		local RandomID = vgui.Create("DButton", NEW_CHARACTER)
		RANDOM_ID = RandomID
		RANDOM_ID:SetSize(115, 30)
		RANDOM_ID:SetPos(5, 195)
		RANDOM_ID:SetText("")
		RANDOM_ID:SetVisible(true)
		RANDOM_ID.Hover = 0
		RANDOM_ID.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE_TO, 255 - self.Hover))
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, self.Hover))

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, C_B_10)

			draw.SimpleText(secont_text, second_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
			draw.SimpleText(secont_text, second_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)

			mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_25)
		end
		RANDOM_ID.DoClick = function(self)
			NAME_ENTRY:SetText(select_team_group and table.Random(LastName[select_team_group]) or
				table.Random(LastName[TEAM_CADETRF]))
		end

		local SaveCharacter = vgui.Create("DButton", NEW_CHARACTER)
		SAVE_CHARACTER = SaveCharacter
		SAVE_CHARACTER:SetSize(n_wide / 2, 60)
		SAVE_CHARACTER:SetPos(n_wide / 2 - SAVE_CHARACTER:GetWide() / 2, 240)
		SAVE_CHARACTER:SetText("")
		SAVE_CHARACTER:SetVisible(true)
		SAVE_CHARACTER.Hover = 0
		SAVE_CHARACTER.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, C_W_5)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.BLUE, self.Hover))

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_W_15)
			mp.Icon(w / 2, 0, w / 2, h, mp.Material.GRADIENT_R, C_W_15)

			draw.SimpleText(save_text, save_font, w / 2, h / 2, mp.Color.WHITE, 1, 1)
		end


		local RFTeam = vgui.Create("DButton", CREATE_MENU)
		RFTeam:SetSize(CREATE_MENU:GetWide() / 3, CREATE_MENU:GetTall())
		RFTeam:SetPos(CREATE_MENU:GetWide() - RFTeam:GetWide(), 0)
		RFTeam:SetText("")
		RFTeam:SetVisible(true)
		RFTeam.Hover = 0
		RFTeam.Paint = function(self, w, h)
			if select_team_group == TEAM_CADETRF then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
			elseif self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_W_15)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, Color(153, 0, 0, self.Hover))

			draw.SimpleText(rf_text, teams_font, w / 2, h / 2, mp.Color.WHITE, 1, 1)
		end

		RFTeam.DoClick = function(self)
			select_team_group = TEAM_CADETRF
			NAME_ENTRY:SetText(table.Random(LastName[TEAM_CADETRF]))
		end

		local PMCTeam = vgui.Create("DButton", CREATE_MENU)
		PMCTeam:SetSize(CREATE_MENU:GetWide() / 3, CREATE_MENU:GetTall())
		PMCTeam:SetPos(0, 0)
		PMCTeam:SetText("")
		PMCTeam:SetVisible(true)
		PMCTeam.Hover = 0
		PMCTeam.Paint = function(self, w, h)
			if select_team_group == TEAM_CADET then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
			elseif self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, C_W_15)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, Color(69, 128, 197, self.Hover))

			draw.SimpleText(pmc_text, teams_font, w / 2, h / 2, mp.Color.WHITE, 1, 1)
		end

		PMCTeam.DoClick = function(self)
			select_team_group = TEAM_CADET
			NAME_ENTRY:SetText(table.Random(LastName[TEAM_CADET]))
		end

		local GoBack = vgui.Create("DButton", CREATE_MENU)
		GO_BACK = GoBack
		GO_BACK:SetSize(90, 30)
		GO_BACK:SetPos(NEW_CHARACTER:GetX() - 95, NEW_CHARACTER:GetY())
		GO_BACK:SetText("")
		GO_BACK.Hover = 0
		GO_BACK.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, C_W_5)

			draw.SimpleText(goback_text, goback_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1, 1)
			draw.SimpleText(goback_text, goback_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
		end

		GO_BACK.DoClick = function(self)
			OpenCharacterMenu({ characters = characters })

			CREATE_MENU:AlphaTo(0, 0.4, 0, function()
				CREATE_MENU:Remove()
			end)
		end

		SAVE_CHARACTER.DoClick = function(self)
			if not select_team_group then return end

			netstream.Start("NewPlayerCharacter", {
				name = NAME_ENTRY:GetValue(),
				start_team = select_team_group
			})

			CREATE_MENU:AlphaTo(0, 0.4, 0, function()
				CREATE_MENU:Remove()
			end)
		end
	end

	local AddChar = vgui.Create("DButton", CREATION_MENU)
	AddChar:SetSize(356, 90)
	AddChar:SetPos(10, cm_tall / 2 + 104)
	AddChar:SetText("")
	AddChar.Hover = 0
	AddChar.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE_TO, 255 - self.Hover))
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, self.Hover))

		if max_characters <= #characters then
			draw.SimpleText(limite_text, limite_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
			draw.SimpleText(limite_text, limite_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_R_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, C_R_10)

			mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_25)
			mp.Icon(0, h - 1, w, 1, mp.Material.GRADIENT_C, C_W_25)
		else
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, C_B_10)


			draw.SimpleText(add_text, add_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
			draw.SimpleText(add_text, add_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)

			mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_25)
			mp.Icon(0, h - 1, w, 1, mp.Material.GRADIENT_C, C_W_25)
		end
	end

	AddChar.DoClick = function(self)
		if max_characters > #characters then
			OpenNewCharacterMenu(characters)

			CREATION_MENU:AlphaTo(0, 0.3, 0, function()
				CREATION_MENU:Remove()
			end)
		end
	end
end

netstream.Hook("OpenInitCharacterMenu", function(characters)
	local title = "НАЧАТЬ"
	local title_font = mp.font("50:Futura PT Light")

	local StartMenu = vgui.Create("EditablePanel")
	START_MENU = StartMenu
	START_MENU:SetPos(0, 0)
	START_MENU:SetSize(ScrW(), ScrH())
	START_MENU:SetAlpha(0)
	START_MENU:AlphaTo(255, 1.5, 0.2)
	START_MENU.Paint = function(self, w, h)
		mp.PanelBlur(self, 4)

		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
	end

	START_MENU:MakePopup()

	local StartButton = vgui.Create("DButton", START_MENU)
	START_BUTTON = StartButton
	START_BUTTON:SetSize(196, 80)
	START_BUTTON:SetPos(START_MENU:GetWide() * .5 - START_BUTTON:GetWide() * .5,
		START_MENU:GetTall() * .5 - START_BUTTON:GetTall() * .5)
	START_BUTTON:SetText("")
	START_BUTTON.Hover = 0
	START_BUTTON.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 12, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 12, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover))

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.BASE, 155 - self.Hover))
		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.BLACK, self.Hover))

		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, 155 - self.Hover))

		mp.Icon(1, h - 1, w - 1, 1, mp.Material.GRADIENT_L, C_W_15)
		mp.Icon(1, 0, w - 1, 1, mp.Material.GRADIENT_R, C_W_15)
		mp.Icon(0, 0, 1, h, mp.Material.GRADIENT_D, C_W_15)
		mp.Icon(w - 1, 0, 1, h, mp.Material.GRADIENT_U, C_W_15)

		draw.SimpleText(title, title_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, self.Hover), 1, 1)
		draw.SimpleText(title, title_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1, 1)
	end

	START_BUTTON.DoClick = function(self)
		OpenCharacterMenu(characters)

		START_MENU:AlphaTo(0, 0.3, 0, function()
			START_MENU:Remove()
		end)
	end
end)


netstream.Hook("OpenCharacterMenu", function(characters)
	OpenCharacterMenu(characters)
end)
