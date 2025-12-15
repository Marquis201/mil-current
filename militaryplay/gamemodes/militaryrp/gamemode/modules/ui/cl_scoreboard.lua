local SetClipboardText = SetClipboardText
local ColorAlpha = ColorAlpha
local mp = mp
local Color = Color
local vgui = vgui
local draw = draw
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime
local no_close_onedit = {}
local Vector, Angle = Vector, Angle

local PlayerInfo = {
	[1] = {
		Title = "Фамилия: ",
		func = function(pl)
			SetClipboardText(pl:Name())
		end,
	},
	[2] = {
		Title = "Специальность: ",
		func = function(pl)
			SetClipboardText(pl:FeatureName())
		end,
	},
	[3] = {
		Title = "Средства: ",
		func = function(pl)
			SetClipboardText(pl:GetMoney())
		end,
	},
	[4] = {
		Title = "Звание: ",
		func = function(pl)
			SetClipboardText(pl:GetNetVar("meta_rank"))
		end,
	},
	[5] = {
		Title = "Номер: ",
		func = function(pl)
			SetClipboardText(pl:GetRPID())
		end,
	},
	[6] = {
		Title = "Привилегии: ",
		func = function(pl)
			SetClipboardText(pl:GetUserGroup())
		end,
	},
	[7] = {
		Title = "Ник: ",
		func = function(pl)
			SetClipboardText(pl:OldName())
		end,
	},
	[8] = {
		Title = "STEAM_ID: ",
		func = function(pl)
			SetClipboardText(pl:SteamID())
		end,
	},
}

local setclose_text = "Выдать и закрыть"
local set_text = "Выдать"
local settime_text = "На время"
local title_text = "Личное дело: "
local spawn_text = "Заспаванить после выдачи"
local Server_name = "Military-Play"
local selected = "Выбрать"
local online_text = "Онлайн: "

local C_B_245 = ColorAlpha(mp.Color.BLACK, 245)
local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_B_155 = ColorAlpha(mp.Color.BLACK, 155)
local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)
local C_B_55 = ColorAlpha(mp.Color.BLACK, 55)

local C_W_5 = ColorAlpha(mp.Color.WHITE, 5)
local C_W_10 = ColorAlpha(mp.Color.WHITE, 10)
local C_W_15 = ColorAlpha(mp.Color.WHITE, 15)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)

local C_R_100 = ColorAlpha(mp.Color.RED, 100)
local C_R_25 = ColorAlpha(mp.Color.RED, 25)
local C_R_10 = ColorAlpha(mp.Color.RED, 10)

local C_G_25 = ColorAlpha(mp.Color.GREEN, 25)
local C_G_10 = ColorAlpha(mp.Color.GREEN, 10)

local C_BL_25 = ColorAlpha(mp.Color.BLUE, 25)
local C_BL_10 = ColorAlpha(mp.Color.BLUE, 10)

local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)

local C_B_75 = ColorAlpha(mp.Color.BLACK, 75)

local C_BT_20 = ColorAlpha(mp.Color.BASE_TO, 20)

local rank_font = mp.font("16:Montserrat Light")
local search_font = mp.font("20:DIN Pro Regular")
local list_font = mp.font("16:DIN Pro Regular")
local button_font = mp.font("20:Futura PT Medium")
local info_fonts = mp.font("18:DIN Pro Regular")
local name_font = mp.font("25:Futura PT Light")
local choose_font = mp.font("20:mr_ApexMk3MediumG")
local frags_font = mp.font("20:mr_ApexMk3ExtraLightG")
local name_server_font = mp.font("70:Futura PT Light")
local time_font = mp.font("25:Futura PT Light")

local function ChoosePanel(value, parent)
	if not value then return end

	if IsValid(CHOOSE_PANEL) then
		CHOOSE_PANEL:AlphaTo(0, 0.2, 0)
		CHOOSE_PANEL:MoveTo(parent:GetWide() / 2 - 512, parent:GetTall() / 2 + 360, 0.1, 0.1, 0.9, function()
			CHOOSE_PANEL:Remove()
			CHOOSE_PANEL = nil
		end)

		return
	end

	local t = value:Team()
	local team_color = mp.jobs[t].color
	local team_name = nil or "Отсутствует"
	local name = value:Name()
	local steam_name = value:OldName()
	local money = value:GetMoney()
	local group = value:GetUserGroup()
	local steamid = value:SteamID()
	local rpid = value:GetRPID()
	local rank = value:GetNetVar("meta_rank")
	local frags, deaths = value:Frags(), value:Deaths()
	local ping = value:Ping() or 0
	local info = ""
	local features = value:FeatureName()

	local C_T_20 = ColorAlpha(team_color, 20)

	local ChoosePanel = vgui.Create("DPanel", parent)
	CHOOSE_PANEL = ChoosePanel
	CHOOSE_PANEL:SetSize(1024, 100)
	CHOOSE_PANEL:SetPos(parent:GetWide() / 2 - 512, parent:GetTall() / 2 + 360)
	CHOOSE_PANEL:MoveTo(parent:GetWide() / 2 - 512, parent:GetTall() / 2 + 265, 0.91, 0, 0.1)
	CHOOSE_PANEL:SetVisible(true)
	CHOOSE_PANEL:SetAlpha(0)
	CHOOSE_PANEL:AlphaTo(255, 0.3, 0)
	CHOOSE_PANEL.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE_TO)
		draw.RoundedBox(0, 11, 11, h - 22, h - 22, team_color)

		mp.Icon(0, 0, w, h, mp.Material.TAB_PATTERN_5, C_W_200)
		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_T_20)
	end

	local GridPanel = vgui.Create("DGrid", CHOOSE_PANEL)
	GRID_PANEL = GridPanel
	GRID_PANEL:SetPos(100, 10)
	GRID_PANEL:SetCols(3)
	GRID_PANEL:SetColWide(305)
	GRID_PANEL:SetRowHeight(28)

	for _, v in ipairs(PlayerInfo) do
		local InfoPanel = vgui.Create("DButton", CHOOSE_PANEL)
		INFO_PANEL = InfoPanel
		INFO_PANEL:SetSize(300, 24)
		INFO_PANEL:SetText("")
		INFO_PANEL.Hover = 0
		INFO_PANEL.Paint = function(self, w, h)
			if _ == 1 then
				info = name
			elseif _ == 2 then
				info = features or "Отсутствует"
			elseif _ == 3 then
				info = money or 0
			elseif _ == 4 then
				info = rank or "Отсутствует"
			elseif _ == 5 then
				info = rpid
			elseif _ == 6 then
				info = group
			elseif _ == 7 then
				info = steam_name
			elseif _ == 8 then
				info = steamid
			else
				info = "" or 0
			end

			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, C_B_75)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, ColorAlpha(mp.Color.WHITE, self.Hover / 2))

			mp.Text(v.Title .. info, info_fonts, 8, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 0, 1)
			mp.Text(v.Title .. info, info_fonts, 8, h / 2, ColorAlpha(mp.Color.BLACK, 0 + self.Hover), 0, 1)
		end

		INFO_PANEL.OnCursorEntered = function(self)
			surface.PlaySound(mp.Sound.HOVER_2)

			mp.ToolTip(self, "ЛКМ: скопировать", mp.Color.WHITE)
		end

		INFO_PANEL.DoClick = function(self)
			notification.AddLegacy("Успешно скопировано!", NOTIFY_HINT, 5)

			v.func(value)
		end

		GRID_PANEL:AddItem(INFO_PANEL)
	end

	local AvatarPanel = vgui.Create("AvatarImage", CHOOSE_PANEL)
	AVATAR_PANEL = AvatarPanel
	AVATAR_PANEL:SetPos(14, 14)
	AVATAR_PANEL:SetSize(72, 72)
	AVATAR_PANEL:SetPlayer(value, 128)
end

local function Scoreboard(check)
	if not LocalPlayer():Alive() then return end

	local scrw, scrh = ScrW(), ScrH()
	local pl = LocalPlayer()
	local AllPlayers = player.GetAll()

	if check then
		table.sort(AllPlayers, function(a, b) return a:Team() < b:Team() end)

		if IsValid(TAB_BACKGROUND) then
			TAB_BACKGROUND:AlphaTo(0, 0.3, 0, function()
				TAB_BACKGROUND:Remove()
			end)

			surface.PlaySound(mp.Sound.DEPLOY_2)

			return
		end

		surface.PlaySound(mp.Sound.DEPLOY)

		local TabBackground = vgui.Create("DFrame")
		TAB_BACKGROUND = TabBackground
		TAB_BACKGROUND:SetTitle("")
		TAB_BACKGROUND:SetSize(scrw, scrh)
		TAB_BACKGROUND:Center()
		TAB_BACKGROUND:MakePopup()
		TAB_BACKGROUND:ShowCloseButton(false)
		TAB_BACKGROUND:SetVisible(true)
		TAB_BACKGROUND:SetDraggable(false)
		TAB_BACKGROUND:SetAlpha(0)
		TAB_BACKGROUND:AlphaTo(255, 0.5, 0)
		TAB_BACKGROUND.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, C_B_200)

			mp.BlurBG(self, 2)
		end

		TAB_BACKGROUND.Think = function(self, w, h)
			if IsValid(TAB_BACKGROUND) and not pl:Alive() then
				TAB_CENTER:MoveTo(scrw * .5 - 512, scrh / 2, 0.9, 0.1, 0.1)
				TAB_BACKGROUND:AlphaTo(0, 0.25, 0, function()
					TAB_BACKGROUND:Remove()
				end)

				surface.PlaySound(mp.Sound.DEPLOY_2)
			end
		end

		local TabCenter = vgui.Create("DPanel", TAB_BACKGROUND)
		TAB_CENTER = TabCenter
		TAB_CENTER:SetSize(1024, 720)
		TAB_CENTER:SetPos(scrw * .5 - 512, scrh / 2)
		TAB_CENTER:MoveTo(scrw * .5 - 512, scrh * .5 - 360, 1, 0.1, 0.1)
		TAB_CENTER.SildeSize = 0
		TAB_CENTER.Paint = function(self, w, h)
			if IsValid(CHOOSE_PANEL) then
				self.SildeSize = Lerp(FrameTime() * 8, self.SildeSize, 615)
			else
				self.SildeSize = Lerp(FrameTime() * 8, self.SildeSize, 720)
			end

			self:SetSize(1024, self.SildeSize)
		end

		local TabScroll = vgui.Create("DScrollPanel", TAB_CENTER)
		TabScroll:Dock(FILL)
		TabScroll:DockMargin(0, 90, 0, 0)
		TabScroll.Hover = 0
		TabScroll.VBar:SetWide(5)
		TabScroll.Paint = function(self, w, h)
			local x, y = self:LocalCursorPos()
			local w, h = self:GetWide(), self:GetTall()

			if x < w and x > 0 and y < h and y > 0 then
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			self.VBar:SetAlpha(self.Hover)
		end
		local sbar = TabScroll:GetVBar()
		sbar:SetHideButtons(true)

		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, C_B_100)
		end

		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
		end

		for k, v in ipairs(AllPlayers) do
			local t = v:Team()
			local team_color = mp.jobs[t].color
			local team_name = mp.jobs[t].Name
			local name = v:Name()
			local rpid = v:GetRPID()
			local rank = v:GetNetVar("meta_rank")

			local C_T_40 = ColorAlpha(team_color, 40)

			surface.SetFont(mp.font("18:mr_ApexMk3MediumG"))
			local number_w, number_h = surface.GetTextSize(rpid)

			if rpid == "Отсутствует" then
				number_w, number_h = -15, 0

				rpid = false
			end

			if t == TEAM_CONNECTING or t == TEAM_SPECTATOR or t == TEAM_UNASSIGNED then continue end
			--if mp.jobs[pl:Team()].Type ~= mp.jobs[v:Team()].Type and not pl:IsAdmin() then continue end

			if IsValid(v) then
				if v:GetNWBool("HideMode") and v ~= pl then continue end
				local TabPlayer = vgui.Create("DLabel", TabScroll)
				TabPlayer:Dock(TOP)
				TabPlayer:SetSize(0, 40)
				TabPlayer:DockMargin(0, 0, 5, 8)
				TabPlayer:SetText("")
				TabPlayer:IsVisible()
				TabPlayer.Hover = 0
				TabPlayer.Hover2 = 0
				TabPlayer.Hover3 = 0
				TabPlayer.Paint = function(self, w, h)
					if not IsValid(v) then
						self:Remove()
						return
					end
					local frags, deaths = v:Frags(), v:Deaths()
					local ping = v:Ping() or 0

					local x, y = self:LocalCursorPos()

					if self:IsHovered() then
						self.Hover = Lerp(FrameTime() * 10, self.Hover, 20)
						self.Hover2 = Lerp(FrameTime() * 10, self.Hover2, -20)
						self.Hover3 = Lerp(FrameTime() * 10, self.Hover3, 50)
					else
						self.Hover = Lerp(FrameTime() * 10, self.Hover, -17)
						self.Hover2 = Lerp(FrameTime() * 10, self.Hover2, 2)
						self.Hover3 = Lerp(FrameTime() * 10, self.Hover3, 0)
					end

					draw.RoundedBox(0, 0, 0, w, h, C_BT_20)

					if rpid then
						draw.RoundedBox(0, 5, 5, number_w + 15, h - 10, C_W_15)
					end

					mp.Icon(20, 0, w - 20, 75, mp.Material.GRADIENT_R, ColorAlpha(team_color, 20))


					if v:GetNWBool("HideMode") and v == pl then
						surface.SetFont(name_font)
						local x, y = surface.GetTextSize(name)

						mp.Text("(Скрытый)", name_font, number_w + 35 + x, h / 2, mp.Color.BASE, 0, 1)
					end

					mp.Text(name, name_font, number_w + 30, h / 2, mp.Color.WHITE, 0, 1)
					mp.Text(team_name, info_fonts, w / 2, rank and self.Hover2 or -self.Hover, team_color, 1,
					rank and 0 or 1)

					if rank then
						mp.Text(rank, info_fonts, w / 2, -self.Hover, C_W_200, 1, 0)
					end

					if rpid then
						mp.Text(rpid, info_fonts, 10, h / 2, mp.Color.WHITE, 0, 1)
					end

					mp.Text(selected, choose_font, w / 2, self.Hover, mp.Color.WHITE, 1, 1)

					draw.RoundedBox(0, w - 62, 0, 62, h, team_color)

					mp.Icon(w - 190, 0, 128, h, mp.Material.AVATAR, team_color)

					mp.Icon(w - 148, h / 2 - 7, 16, 16, mp.Material.FRAGS, color_black)
					mp.Icon(w - 101, h / 2 - 7, 16, 16, mp.Material.DEATH, color_black)
					mp.Icon(w - 55, h / 2 - 7, 16, 16, mp.Material.PINGS, color_black)

					mp.Text(math.Clamp(frags, 0, 999), choose_font, w - 130, h / 2, color_black, 0, 1)
					mp.Text(math.Clamp(deaths, 0, 999), choose_font, w - 83, h / 2, color_black, 0, 1)
					mp.Text(math.Clamp(ping, 0, 999), choose_font, w - 38, h / 2, color_black, 0, 1)

					mp.Icon(0, -1, w, h + 2, mp.Material.OUTLINE, ColorAlpha(team_color, 20))
				end

				TabPlayer.OnCursorEntered = function()
					surface.PlaySound(mp.Sound.HOVER_6)
				end

				TabPlayer:SetMouseInputEnabled(true)
				function TabPlayer:DoClick()
					ChoosePanel(v, TAB_BACKGROUND)

					surface.PlaySound(mp.Sound.HOVER_3)
				end

				TabPlayer.Alpha = 0
				function TabPlayer:Think()
					local posx, posy = TabScroll:GetChildPosition(self)

					if posy < -20 then
						self.Alpha = Lerp(FrameTime() * 10, self.Alpha, 0)
					elseif IsValid(CHOOSE_PANEL) and posy > 500 then
						self.Alpha = Lerp(FrameTime() * 10, self.Alpha, 0)
					elseif posy > 600 then
						self.Alpha = Lerp(FrameTime() * 10, self.Alpha, 0)
					else
						self.Alpha = Lerp(FrameTime() * 5, self.Alpha, 255)
					end

					self:SetAlpha(self.Alpha)
				end

				function TabPlayer:DoRightClick()
					if not IsValid(v) then return end

					local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(pl))
					local commands = serverguard.command:GetTable()

					local bNoAccess = true
					local menu = DermaMenu(false, TabPlayer)
					menu:SetAlpha(0)
					menu:AlphaTo(255, 0.25, 0)
					menu:SetSkin("serverguard")
					menu:AddSpacer()

					if LocalPlayer():CanUseWhitelist() then
						menu:AddSubMenu("Управление ролью", function()
							mp.TeamsMenu(v)

							TAB_CENTER:MoveTo(scrw * .5 - 512, scrh / 2, 0.9, 0.1, 0.1)
							TAB_BACKGROUND:AlphaTo(0, 0.25, 0, function()
								TAB_BACKGROUND:Remove()
							end)

							surface.PlaySound(mp.Sound.CLICK_5)
						end)
					end

					if LocalPlayer():IsAdmin() then
						local sub_commands = menu:AddSubMenu("Администрирование")
						for unique, data in pairs(commands) do
							if (data.ContextMenu and (! data.permissions or serverguard.player:HasPermission(pl, data.permissions))) then
								data:ContextMenu(v, sub_commands, rankData);
								bNoAccess = false;
							end
						end

						menu:AddOption("Изменить имя", function()
							Derma_StringRequest(
								"Имя",
								"Укажите новое имя",
								"",
								function(text) RunConsoleCommand("mp", "nickname", v:SteamID(), text) end,
								function(text) end
							)
						end)

						menu:AddOption("Комната админов", function()
							RunConsoleCommand("mp", "sit")
						end)
						menu:AddOption("Скрыть/Показать", function()
							if v:GetNWBool("HideMode") then
								LocalPlayer():ConCommand("say !unhide")
							else
								LocalPlayer():ConCommand("say !hide")
							end
						end)
					end
					menu:Open()

					surface.PlaySound(mp.Sound.CLICK_3)
				end
			end
		end

		local TabHat = vgui.Create("DPanel", TAB_CENTER)
		TabHat:SetSize(1024, 100)
		TabHat:SetPos(0, 0)
		TabHat.Paint = function(self, w, h)
			local time = os.time()
			local timedata = os.date("%H:%M:%S / %d.%m.%Y", time)

			mp.Text(Server_name, name_server_font, w / 2, 2, mp.Color.WHITE, 1, 0)
			mp.Text(timedata, time_font, 0, 60, mp.Color.TIME, 0, 0)
			mp.Text(online_text .. player.GetCount(), time_font, w, 60, mp.Color.WHITE, 2, 0)

			mp.Icon(0, h - 10, w, 10, mp.Material.GRADIENT_U, C_B_150)
		end
	else
		if IsValid(TAB_BACKGROUND) then
			TAB_CENTER:MoveTo(scrw * .5 - 512, scrh / 2, 0.9, 0.1, 0.1)
			TAB_BACKGROUND:AlphaTo(0, 0.25, 0, function()
				TAB_BACKGROUND:Remove()
			end)

			surface.PlaySound(mp.Sound.DEPLOY_2)
		end
	end
end

hook.Add("ScoreboardShow", "OpenScoreboard", function()
	Scoreboard(true)

	no_close_onedit = no_close_onedit or {}
	return false
end)

hook.Add("ScoreboardHide", "HideScoreboard", function()
	Scoreboard(false)

	no_close_onedit = no_close_onedit or {}
	if TAB_BACKGROUND and IsValid(TAB_BACKGROUND) then
		for k, v in pairs(no_close_onedit) do
			if v and IsValid(v) then
				if v.IsEditing and v:IsEditing() then
					return
				end

				if v.GetToggle and v:GetToggle() then
					return
				end
			end
		end
	end
end)
