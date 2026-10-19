local mp = mp

local os_date = os.date
local os_time = os.time

local SetClipboardText = SetClipboardText
local ColorAlpha = ColorAlpha
local Color = Color
local vgui = vgui
local draw = draw
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime
local no_close_onedit = {}
local Vector, Angle = Vector, Angle

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

local item_font = mp.font("20:Montserrat Light")
local rank_font = mp.font("16:Montserrat Light")
local search_font = mp.font("20:DIN Pro Regular")
local list_font = mp.font("18:DIN Pro Regular")
local button_font = mp.font("20:Futura PT Medium")
local info_fonts = mp.font("20:DIN Pro Regular")
local name_font = mp.font("25:Futura PT Light")
local choose_font = mp.font("20:mr_ApexMk3MediumG")
local frags_font = mp.font("20:mr_ApexMk3ExtraLightG")
local name_server_font = mp.font("70:Futura PT Light")
local time_font = mp.font("25:Futura PT Light")

local LogsTitle = {
	player_logs = "История игрока",
	physgun = "Физган",
	["admin command"] = "Команды админа",
	props = "Пропы",
	damage = "Урон",
	connection = "Подключения",
	police = "Полиция",
	chat = "Чат",
	["Kill|deaths"] = "Убийства/Смерти",
	rpcommands = "РП Команды",
	toolgun = "Тулган",
	admin_command = "Админка",
	whitelist = "Вайт-лист",
}


local fr
function SearchMenu(title, data)
	if IsValid(fr) then fr:Remove() end

	local w, h = eui.ScaleWide(1280), eui.ScaleTall(720)
	local pr = ui.Create("DFrame", function(self)
		self:SetTitle(title)
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
		self._Close = self.Close
		self.Close = function()
			if IsValid(fr) then fr:SetVisible(true) end
			self:_Close()
		end
	end)
	local cont = ui.Create("ui_panel", function(self, p)
		self:DockToFrame()
	end, pr)
	LayoutLogs(cont, data)
end

local function OpenMenu()
	if IsValid(fr) then fr:Remove() end

	surface.PlaySound(mp.Sound.DEPLOY)

	local scrw, scrh = ScrW(), ScrH()
	local pl = LocalPlayer()

	fr = vgui.Create("EditablePanel")
	fr:SetSize(1280, 720)
	fr:SetPos(scrw * .5 - fr:GetWide() / 2, scrh / 2)
	fr:MoveTo(scrw * .5 - fr:GetWide() / 2, scrh * .5 - fr:GetTall() / 2, 0.5, 0.1, 0.1)
	fr:MakePopup()
	fr:SetAlpha(0)
	fr:AlphaTo(255, 0.3, 0.1)
	fr.title = "Логи"
	fr.Paint = function(self, w, h)
		mp.PanelBlur(self, 1)

		draw.RoundedBox(0, 0, 0, w, h, C_B_200)
		draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
		mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
		mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

		mp.Text(self.title, search_font, w / 2, 20, mp.Color.BASE, 1, 1)
	end

	local ClosePanel = vgui.Create("DButton", fr)
	ClosePanel:SetSize(20, 20)
	ClosePanel:SetText("")
	ClosePanel.Hover = 0
	ClosePanel:SetPos(fr:GetWide() - ClosePanel:GetWide() - 15, 10)
	ClosePanel.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 75)
		end

		mp.Icon(0, 0, 20, 20, mp.Material.CLOSE, ColorAlpha(mp.Color.BASE, self.Hover))
	end

	ClosePanel.OnCursorEntered = function()
		surface.PlaySound(mp.Sound.CLICK)
	end

	ClosePanel.DoClick = function(self)
		fr:AlphaTo(0, 0.2, 0)
		fr:MoveTo(scrw * .5 - fr:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
			fr:Remove()
			fr = nil
		end)

		surface.PlaySound(mp.Sound.CLICK_10)
	end

	local TabsPanel = vgui.Create("DScrollPanel", fr)
	TabsPanel:Dock(LEFT)
	TabsPanel:SetWide(180)
	TabsPanel:DockMargin(10, 40, 10, 10)
	TabsPanel.Hover = 0
	TabsPanel.VBar:SetWide(5)
	TabsPanel.Paint = function(self, w, h)
		local x, y = self:LocalCursorPos()

		if x < w and x > 0 and y < h and y > 0 then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		self.VBar:SetAlpha(self.Hover)

		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end
	local sbar = TabsPanel:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
	end

	local LogsPanel = vgui.Create("DScrollPanel", fr)
	LogsPanel:Dock(FILL)
	LogsPanel:DockMargin(10, 50, 10, 10)
	LogsPanel.Hover = 0
	LogsPanel.VBar:SetWide(5)
	LogsPanel.Paint = function(self, w, h)
		local x, y = self:LocalCursorPos()

		if x < w and x > 0 and y < h and y > 0 then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		self.VBar:SetAlpha(self.Hover)

		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end
	local sbar = LogsPanel:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
	end

	local open = false
	local selectTab
	local selectData

	function fr:AddLogs(v)
		local message = mp.logs.Terms[v.Term] and mp.logs.Terms[v.Term].Message or nil

		local colors = {
			["Officer Name"] = mp.Color.ORANGE,
			["Имя"] = mp.Color.ORANGE,
			["Officer SteamID"] = mp.Color.ORANGE,
			["Attacker Name"] = mp.Color.ORANGE,
			Name = mp.Color.ORANGE,
			SteamID = Color(200, 200, 200),
			["Attacker SteamID"] = Color(200, 200, 200),
			Text = Color(200, 200, 200),
			Args = Color(200, 200, 200),
			Entity = mp.Color.BLUE,
			Damage = mp.Color.RED,
			Tool = mp.Color.GREEN,
			Job = mp.Color.GREEN,
			Profession = mp.Color.GREEN,
			Time = mp.Color.BLUE,
			Ent = mp.Color.BLUE,
			Weapon = mp.Color.BLUE,
			Prop = mp.Color.BLUE,
			Model = mp.Color.BLUE,
			TargetName = mp.Color.ORANGE,
			TargetSteamID = Color(200, 200, 200),
			["Target Name"] = mp.Color.ORANGE,
			["Target SteamID"] = Color(200, 200, 200),
			Reason = Color(200, 200, 200),
			Default = Color(150, 150, 150)
		}

		local LogPanel = vgui.Create("Panel", LogsPanel)
		LogPanel:Dock(TOP)
		LogPanel:SetTall(20)
		LogPanel:DockMargin(5, 5, 5, 0)
		LogPanel.Hover = 0
		LogPanel.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, C_B_100)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

			surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			local time = v.Time and v.Time or v.time

			surface.SetFont(list_font)
			local wT = surface.GetTextSize(time)

			draw.SimpleText(time, list_font, 5, h / 2, C_W_100, 0, 1)

			if not v.Term then
				if v.data then
					draw.SimpleText(v.data, list_font, wT + 10, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover / 2), 0,
						1)
				end

				return
			end

			local x = wT + 10
			local y = h / 2

			local copySequence = mp.logs.Terms[v.Term].Copy

			local parts = {}
			local lastPos = 1
			local placeholderCount = 0

			for pos in string.gmatch(message, "()#") do
				pos = tonumber(pos)
				if lastPos < pos then
					table.insert(parts, {
						text = string.sub(message, lastPos, pos - 1),
						color = colors.Default
					})
				end
				placeholderCount = placeholderCount + 1
				local key = copySequence[placeholderCount]
				local value = v.Copy[key] or ""

				table.insert(parts, {
					text = value,
					color = colors[key] or colors.Default
				})

				lastPos = pos + 1
			end

			if lastPos <= #message then
				table.insert(parts, {
					text = string.sub(message, lastPos),
					color = colors.Default
				})
			end

			for _, part in ipairs(parts) do
				draw.SimpleText(part.text, list_font, x, y, ColorAlpha(part.color, 255 - self.Hover / 2), 0, 1)

				surface.SetFont(list_font)
				local textWidth, _ = surface.GetTextSize(part.text)
				x = x + textWidth
			end
		end

		function LogPanel:OnMousePressed(keyCode)
			if keyCode == MOUSE_LEFT then
				local menu = DermaMenu(false, LogsPanel)
				menu:SetAlpha(0)
				menu:AlphaTo(255, 0.25, 0)
				menu:SetSkin("serverguard")
				menu:AddSpacer()

				menu:AddOption("Скопировать время", function()
					SetClipboardText(v.Time and v.Time or v.time)

					mp.util.Notify(NOTIFY_HINT, "Скопировано!")
				end)

				menu:AddOption("Скопировать строку", function()
					SetClipboardText(v.Data and v.Data or v.data)

					mp.util.Notify(NOTIFY_HINT, "Скопировано!")
				end)

				if v.Copy then
					for p, t in pairs(v.Copy) do
						menu:AddOption(p, function()
							SetClipboardText(t)

							mp.util.Notify(NOTIFY_HINT, t .. " скопировано!")
						end)
					end
				end

				menu:Open()

				surface.PlaySound(mp.Sound.CLICK_3)
			end
		end
	end

	function fr:AddData(name, data)
		local TabButton = vgui.Create("DButton", TabsPanel)
		TabButton:Dock(TOP)
		TabButton:SetTall(32)
		TabButton:DockMargin(5, 5, 5, 0)
		TabButton:SetText(LogsTitle[name] or name)
		TabButton:SetColor(Color(0, 0, 0, 0))
		TabButton.Hover = 0
		TabButton.data = data
		TabButton.name = name
		TabButton.Paint = function(self, w, h)
			if self:IsHovered() or (selectTab and selectTab == name) then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, C_B_100)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

			surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2,
				ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1,
				1)
			draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
		end

		TabButton.OnCursorEntered = function()
			surface.PlaySound(mp.Sound.HOVER)
		end

		TabButton.DoClick = function(self)
			selectTab = self.name
			selectData = self.data
			fr:SearchLog(self.data)
		end

		if not open then
			selectTab = name
			fr:SearchLog(data)
			selectData = data

			open = true
		end
	end

	local TabButtonPlayer = vgui.Create("DButton", TabsPanel)
	TabButtonPlayer:Dock(TOP)
	TabButtonPlayer:SetTall(32)
	TabButtonPlayer:DockMargin(5, 5, 5, 0)
	TabButtonPlayer:SetText("Логи игрока")
	TabButtonPlayer:SetColor(Color(0, 0, 0, 0))
	TabButtonPlayer.Hover = 0
	TabButtonPlayer.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

		surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2,
			ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1,
			1)
		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
	end

	TabButtonPlayer.OnCursorEntered = function()
		surface.PlaySound(mp.Sound.HOVER)
	end

	TabButtonPlayer.DoClick = function(self)
		Derma_StringRequest(
			"Логи игрока",
			"Укажите steamid игрока",
			"",
			function(text)
				if not text then return end

				fr:AlphaTo(0, 0.2, 0)
				fr:MoveTo(scrw * .5 - fr:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
					fr:Remove()
					fr = nil
				end)

				RunConsoleCommand("mp", "playerlogs", text)
			end,
			function(text) end
		)
	end

	local TabButtonHistory = vgui.Create("DButton", TabsPanel)
	TabButtonHistory:Dock(TOP)
	TabButtonHistory:SetTall(32)
	TabButtonHistory:DockMargin(5, 5, 5, 0)
	TabButtonHistory:SetText("История логов")
	TabButtonHistory:SetColor(Color(0, 0, 0, 0))
	TabButtonHistory.Hover = 0
	TabButtonHistory.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

		surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2,
			ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1,
			1)
		draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
	end

	TabButtonHistory.OnCursorEntered = function()
		surface.PlaySound(mp.Sound.HOVER)
	end

	TabButtonHistory.DoClick = function(self)
		local SelectCat
		local menu = DermaMenu()
		menu:SetAlpha(0)
		menu:AlphaTo(255, 0.25, 0)
		menu:SetSkin("serverguard")
		menu:AddSpacer()

		for k, v in pairs(LogsTitle) do
			menu:AddOption(v, function()
				SelectCat = k
				TabButtonHistory:SetText(v)

				Derma_StringRequest(
					v,
					"Введите дату (например: 2026-03-16 (год, месяц, день))",
					"",
					function(text)
						if not text then return end

						fr:AlphaTo(0, 0.2, 0)
						fr:MoveTo(scrw * .5 - fr:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
							fr:Remove()
							fr = nil
						end)

						RunConsoleCommand("mp", "historylogs", SelectCat, text)
					end,
					function(text) end
				)
			end)
		end

		menu:Open()
	end

	function fr:SearchLog(data, inf)
		LogsPanel:Clear()
		for i = 1, #data do
			local has = false

			for k, v in pairs(data[i]) do
				local str = tostring(v)

				if inf and (string.find((str:lower()), inf:lower(), 1, true)) then
					has = true

					break
				end
			end

			if has then
				fr:AddLogs(data[i])
			elseif (not inf) then
				fr:AddLogs(data[i])
			end
		end
	end

	local SearchPanel = vgui.Create("DPanel", fr)
	SearchPanel:Dock(BOTTOM)
	SearchPanel:SetTall(40)
	SearchPanel:DockMargin(10, 0, 10, 10)
	SearchPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	local searchText = vgui.Create("DLabel", SearchPanel)
	searchText:Dock(LEFT)
	searchText:SetWide(70)
	searchText:DockMargin(10, 5, 0, 5)
	searchText:SetText("Поиск:")
	searchText:SetFont(info_fonts)
	searchText:SetColor(mp.Color.WHITE)

	local searchEntry = vgui.Create("DTextEntry", SearchPanel)
	searchEntry:Dock(FILL)
	searchEntry:DockMargin(5, 5, 5, 5)
	searchEntry:SetPaintBorderEnabled(true)
	searchEntry:SetFont(search_font)
	searchEntry:SetVisible(true)
	searchEntry:SetAllowNonAsciiCharacters(true)
	searchEntry:SetText("")
	searchEntry.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
		self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
	end

	searchEntry.OnChange = function(s)
		fr:SearchLog(selectData, searchEntry:GetValue())
	end
end

net.Receive("mp.LogData", function(len)
	local name = net.ReadString()
	local data = net.ReadTable(true)

	--local size = net.ReadUInt(32)

	if not name then return end

	--local rawData = net.ReadData(size)
	--if not rawData then return end

	--local data = mp.logs.Decode(rawData)
	if not data then return end

	local log = mp.logs.Get(name)
	--if not log then return end

	if not IsValid(fr) then OpenMenu() end

	for _, v in ipairs(data) do
		if v.time then continue end

		local time = v.Time
		v.Time = os_date("%I:%M:%S", tonumber(time))

		local term = mp.logs.GetTerm(v.Term)
		v.Copy = {}

		if not term then continue end

		if term and term.Copy then
			for p, t in pairs(term.Copy) do
				if v[p] then
					v.Copy[t] = v[p]
				end
			end
		end

		local c = 0
		v.Data = term.Message:gsub("#", function()
			c = c + 1
			return v[c] or ""
		end)
	end

	mp.logs.Data[name] = data

	fr:AddData(name, data)
end)
