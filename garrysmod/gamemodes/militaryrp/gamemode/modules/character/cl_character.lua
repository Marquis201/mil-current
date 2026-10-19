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

local welcome_text = "MILITARY"
local welcome_text2 = "PLAY"
local to_text = "ДОБРО ПОЖАЛОВАТЬ"

local select_font = mp.font("22:mr_ApexMk3MediumG")
local add_font = mp.font("55:mr_ApexMk3MediumG")
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
local title_font = mp.font("35:mr_ApexMk3MediumG")

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

local Background = {
	--[[{
		name = "Наш дискорд",
		desc = "Вступай, чтобы быть в курсе событий",
		icon = Material("military_play/character_system/background/discord_url.png", "smooth")
	},
	{
		name = "Название",
		desc = "Описание",
		icon = Material("military_play/character_system/background/test_url.png", "smooth")
	},
	{
		name = "Сервер обновился",
		desc = "Новые механики и исправления",
		icon = Material("military_play/character_system/background/update_url.png", "smooth")
	}]]
}

function mp.CharacterMenu(data)
	local scrw, scrh = ScrW(), ScrH()
	local pl = LocalPlayer()

	local characters = data.characters
	local err = data.err

	if IsValid(CREATION_MENU) then
		CREATION_MENU:Remove()
	end

	local CreationMenu = vgui.Create("EditablePanel")
	CREATION_MENU = CreationMenu
	CreationMenu:SetPos(0, 0)
	CreationMenu:SetSize(scrw, scrh)
	CreationMenu:SetAlpha(0)
	CreationMenu:AlphaTo(255, 0.5, 0)
	CreationMenu:MakePopup()
	CreationMenu.Paint = function(self, w, h)
		mp.BlurBG(self, 4)

		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
		mp.Icon(0, h / 2, w, h / 2, mp.Material.GRADIENT_D, mp.Color.BLACK)

		if err then
			surface.SetFont(err_font)
			local t_w, t_h = surface.GetTextSize(err)

			t_w, t_h = t_w + 20, t_h + 10

			draw.RoundedBox(0, 10, h - t_h - 10, t_w, t_h, C_R_25)

			draw.SimpleText(err, err_font, 10 + t_w / 2, h - t_h / 2 - 10, mp.Color.WHITE, 1, 1)
		end
	end

	timer.Create("RemoveERROR", 5, 1, function()
		err = nil
	end)

	local BanerPanel = vgui.Create("Panel", CreationMenu)
	BanerPanel:Dock(TOP)
	BanerPanel:DockMargin(20, 20, 20, 20)
	BanerPanel:SetTall(scrh * .15)
	function BanerPanel:Paint(w, h)
		draw.SimpleText(welcome_text2, add_font, 185, 0, mp.Color.BASE, 0, 0)
		draw.SimpleText(welcome_text, add_font, 0, 0, mp.Color.WHITE, 0, 0)
		draw.SimpleText(to_text, select_font, 0, 50, ColorAlpha(mp.Color.ORANGE, 150), 0, 0)
	end

	if Background and #Background > 0 then
		local LerpAlpha = 0
		local SelectBackgrnd = 1
		local BanerBackground = vgui.Create("Panel", BanerPanel)
		BanerBackground:Dock(RIGHT)
		BanerBackground:SetWide(scrw * .3)
		BanerBackground:DockMargin(0, 0, 0, 0)
		function BanerBackground:Paint(w, h)
			LerpAlpha = Lerp(FrameTime() * 3, LerpAlpha, 255)

			local x, y = self:LocalToScreen(0, 0)

			paint.roundedBoxes.roundedBox(16, x, y, w, h, ColorAlpha(mp.Color.WHITE, LerpAlpha),
				Background[SelectBackgrnd].icon)
			--paint.roundedBoxes.roundedBox(16, x, y, w, h, ColorAlpha(mp.Color.BLACK, LerpAlpha / 1.1))

			--draw.SimpleText(Background[SelectBackgrnd].name, select_font, 12, 12, C_B_150, 0, 0)
			--draw.SimpleText(Background[SelectBackgrnd].name, select_font, 10, 10, mp.Color.WHITE, 0, 0)
			--draw.SimpleText(Background[SelectBackgrnd].desc, info_fonts, 12, 32, mp.Color.WHITE, 0, 0)
		end

		local addX = -scrw * .01
		local nextSelect = CurTime() + 5

		for i = 1, #Background do
			local v = Background[i]

			addX = addX + scrw * .03 + scrw * .01

			local SelectBackground = vgui.Create("DButton", BanerBackground)
			SelectBackground:SetSize(scrw * .03, 8)
			SelectBackground:SetPos(addX, scrh * .15 - 28)
			SelectBackground:SetText("")
			SelectBackground.Hover = 0
			SelectBackground.Paint = function(self, w, h)
				if self:IsHovered() or SelectBackgrnd == i then
					self.Hover = Lerp(FrameTime() * 4, self.Hover, 255)
				else
					self.Hover = Lerp(FrameTime() * 4, self.Hover, 0)
				end

				draw.RoundedBox(8, 0, 0, w, h, C_W_25)
				draw.RoundedBox(8, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover))

				if nextSelect < CurTime() then
					SelectBackgrnd = SelectBackgrnd + 1

					if SelectBackgrnd > #Background then
						SelectBackgrnd = 1
					end

					LerpAlpha = 0

					nextSelect = CurTime() + 5
				end
			end

			SelectBackground.DoClick = function(self)
				surface.PlaySound(mp.Sound.CLICK_6)

				SelectBackgrnd = i
				nextSelect = CurTime() + 5
				LerpAlpha = 0
			end

			SelectBackground.OnCursorEntered = function(self)
				surface.PlaySound(mp.Sound.CLICK)
			end
		end
	end


	local HScroll = vgui.Create("HorizontalScrollPanel", CreationMenu)
	HScroll:Dock(FILL)
	HScroll:DockMargin(20, scrh / 4 - scrh * .15 - 40, 20, scrh / 4)
	HScroll.Hover = 0

	function HScroll:Paint(w, h)
		--draw.RoundedBox(0, 0, 0, w, h, C_W_15)
	end

	if not IsValid(pl) then
		mp.CharacterMenu(data)
		return
	end

	local max_characters = 1
	local limit_character = mp.config.max_characters[pl:GetUserGroup()] or 1
	local select_character

	for k, v in pairs(mp.config.max_characters) do
		if v > max_characters then
			max_characters = v
		end
	end

	for i = 1, max_characters do
		local char = characters[i]
		local CharacterPanel = vgui.Create("HorizontalScrollPanel", HScroll)
		CharacterPanel:Dock(LEFT)
		CharacterPanel:SetWide(CreationMenu:GetWide() / max_characters - 25)
		CharacterPanel:DockMargin(0, 0, 20, 0)
		CharacterPanel.Hover = 0
		function CharacterPanel:Paint(w, h)
			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_150)
			draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D,
				ColorAlpha(i > limit_character and mp.Color.RED or mp.Color.BASE, self.Hover / 10))
			surface.SetDrawColor(ColorAlpha(i > limit_character and mp.Color.RED or mp.Color.BASE,
				self.Hover))
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			if not char then
				mp.Icon(w / 2 - 32, h / 2 - 32 - self.Hover / 8, 64, 64,
					i > limit_character and mp.Material.BLOCK_CHARACTER or mp.Material.ADD_CHARACTER,
					i > limit_character and ColorAlpha(mp.Color.RED, 100) or mp.Color.BASE)
			end
		end

		if char then
			local ChooseModel = vgui.Create("DModelPanel", CharacterPanel)
			ChooseModel:SetPos(0, 0)
			ChooseModel:SetFOV(scrh / 28)
			ChooseModel:SetModel(char.model)
			ChooseModel:SetSize(CharacterPanel:GetWide(), scrh / 2)
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
				ent:SetPos(Vector(0, 0, 0))
			end

			local team = mp.jobs_by_id[char.team_id]

			if not team then
				if IsValid(CharacterPanel) then
					CharacterPanel:Remove()
				end

				continue
			end
			local faction = (team and team.faction) and team.faction or false
			local profession = (char.features and mp.profession[char.features]) and mp.profession[char.features] or false

			local CharacterIcon = vgui.Create("DButton", CharacterPanel)
			CharacterIcon:SetPos(0, 0)
			CharacterIcon:SetSize(CharacterPanel:GetWide(), scrh / 2)
			CharacterIcon:SetText("")

			local CharacterTeam = vgui.Create("DLabel", CharacterIcon)
			CharacterTeam:Dock(BOTTOM)
			CharacterTeam:DockMargin(10, 0, 10, (profession and profession.icon) and 50 or 10)
			CharacterTeam:SetFont(admin_font)
			CharacterTeam:SetVisible(true)
			CharacterTeam:SetText(team.Name)
			CharacterTeam:SetWrap(true)
			CharacterTeam:SetContentAlignment(8)
			CharacterTeam:SetAutoStretchVertical(true)
			CharacterTeam:SetTextColor(team.color)

			local CharacterName = vgui.Create("DLabel", CharacterIcon)
			CharacterName:Dock(BOTTOM)
			CharacterName:DockMargin(10, 0, 10, 0)
			CharacterName:SetFont(team_font)
			CharacterName:SetVisible(true)
			CharacterName:SetText(char.character_name)
			CharacterName:SetWrap(true)
			CharacterName:SetContentAlignment(8)
			CharacterName:SetAutoStretchVertical(true)
			CharacterName:SetTextColor(color_white)

			function CharacterIcon:Paint(w, h)
				if faction and mp.faction[faction] and mp.faction[faction].logo then
					mp.Icon(w / 2 - 24, 24, 48, 48, mp.faction[faction].logo, color_white)
				end

				if profession and profession.icon then
					mp.Icon(w / 2 - 12, h - 38, 24, 24, profession.icon, C_W_100)
				end

				CharacterPanel.Hover = Lerp(FrameTime() * 10, CharacterPanel.Hover,
					((select_character and select_character.character_id == char.character_id) or self:IsHovered()) and
					200 or 25)
			end

			CharacterIcon.OnCursorEntered = function(s)
				surface.PlaySound(mp.Sound.CLICK)
			end

			function CharacterIcon:DoClick()
				surface.PlaySound(mp.Sound.CLICK_3)

				select_character = char
			end

			if pl:IsSuperAdmin() then
				local DeleteChar = vgui.Create("DButton", CharacterIcon)
				DeleteChar:SetSize(32, 32)
				DeleteChar:SetPos(CharacterIcon:GetWide() - 37, 5)
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
					surface.PlaySound(mp.Sound.CLICK_7)

					if pl:GetNetVar("meta_character") and pl:GetNetVar("meta_character") == char.character_id then
						err = "Вы не можете удалить этого персонажа играя за него."
						timer.Create("RemoveERROR", 5, 1, function()
							err = nil
						end)
						return
					end

					local code = math.random(11111, 9999)
					Derma_StringRequest(
						"Персонаж",
						"Если хотите удалить персонажа, введите в поле: " .. code,
						"",
						function(text)
							if tostring(code) ~= text then return end

							netstream.Start("RemovePlayerCharacter", { character_id = char.character_id })

							CreationMenu:Remove()
						end,
						function(text) end
					)
				end

				DeleteChar.OnCursorEntered = function(self)
					surface.PlaySound(mp.Sound.CLICK_2)
					mp.ToolTip(self, "Удалить персонажа", mp.Color.RED)
				end
			end
		else
			local AddCharacter = vgui.Create("DButton", CharacterPanel)
			AddCharacter:SetPos(0, 0)
			AddCharacter:SetSize(CharacterPanel:GetWide(), scrh / 2)
			AddCharacter:SetText("")
			function AddCharacter:Paint(w, h)
				CharacterPanel.Hover = Lerp(FrameTime() * 10, CharacterPanel.Hover, self:IsHovered() and 200 or 25)
			end

			AddCharacter.OnCursorEntered = function(s)
				surface.PlaySound(mp.Sound.CLICK)
			end

			function AddCharacter:DoClick()
				surface.PlaySound(mp.Sound.CLICK_3)

				if limit_character > #characters then
					mp.NewCharacter(characters)

					CreationMenu:AlphaTo(0, 0.3, 0, function()
						CreationMenu:Remove()
					end)
				end
			end
		end
	end

	local StartButton = vgui.Create("DButton", CreationMenu)
	StartButton:SetSize(156, 54)
	StartButton:SetPos(CreationMenu:GetWide() * .5 - StartButton:GetWide() * .5, scrh - StartButton:GetTall() - 50)
	StartButton:SetText("")
	StartButton.text = "ИГРАТЬ"
	StartButton.Hover = 0
	StartButton.Paint = function(self, w, h)
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

		draw.SimpleText(self.text, title_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, self.Hover), 1, 1)
		draw.SimpleText(self.text, title_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1, 1)
	end

	function StartButton:Think()
		self:SetAlpha(select_character and 255 or 25)
	end

	StartButton.OnCursorEntered = function(self)
		surface.PlaySound(mp.Sound.HOVER_2)
	end

	StartButton.DoClick = function(self)
		surface.PlaySound(mp.Sound.SELECT)

		if not select_character then return end
		netstream.Start("SpawnPlayerCharacter", { character_id = select_character.character_id })

		CreationMenu:AlphaTo(0, 0.3, 0, function()
			CreationMenu:Remove()
		end)
	end
end

netstream.Hook("OpenInitCharacterMenu", function(characters)
	mp.CharacterMenu(characters)
end)


netstream.Hook("OpenCharacterMenu", function(characters)
	mp.CharacterMenu(characters)
end)
