local net = net
local IsValid = IsValid

function PLAYER:IsArrested()
	return self:GetNetVar("Arrested")
end

if CLIENT then
	local mp = mp
	local ColorAlpha = ColorAlpha
	local surface = surface
	local draw = draw

	local SetClipboardText = SetClipboardText
	local Color = Color
	local vgui = vgui
	local Lerp = Lerp
	local FrameTime = FrameTime
	local Vector, Angle = Vector, Angle

	local btn_font = mp.font("22:Futura PT Medium")
	local search_font = mp.font("20:DIN Pro Regular")
	local info_fonts = mp.font("18:DIN Pro Regular")

	local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
	local C_B_T_150 = ColorAlpha(mp.Color.BASE_TO, 150)
	local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)
	local C_W_100 = ColorAlpha(mp.Color.WHITE, 150)

	local text_help = "Нажмите [Е] для взаимодействия"

	local fr
	local function OpenMenu(pl)
		if IsValid(fr) then
			fr:Remove()
		end

		local scrw, scrh = ScrW(), ScrH()

		fr = vgui.Create("EditablePanel")
		fr:MakePopup()
		fr:SetSize(360, 285)
		fr:SetPos(scrw / 2 - fr:GetWide() / 2, scrh / 2 - fr:GetTall() / 2)
		fr:SetAlpha(0)
		fr:AlphaTo(255, 0.25, 0)
		fr.TitleText = "Арест: " .. pl:Name()
		function fr:Paint(w, h)
			mp.paint:Main(self, w, h)
		end

		mp.paint:CloseButton(fr)

		local parent = vgui.Create("Panel", fr)
		parent:Dock(FILL)
		parent:DockMargin(10, 40, 10, 10)

		local titleReason = vgui.Create("DLabel", parent)
		titleReason:Dock(TOP)
		titleReason:SetSize(0, 28)
		titleReason:DockMargin(0, 0, 5, 0)
		titleReason:SetText("Причина:")
		titleReason:SetFont(info_fonts)
		titleReason:SetColor(mp.Color.WHITE)

		local _reason = vgui.Create("DTextEntry", parent)
		_reason:Dock(TOP)
		_reason:SetSize(0, 24)
		_reason:DockMargin(0, 0, 5, 0)
		_reason:SetFont(search_font)
		_reason:SetValue("введите причину")
		_reason.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, C_B_100)
			self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
		end

		function _reason:OnMousePressed()
			self:SetText("")
		end

		function titleReason:Paint(w, h)
			local len = utf8.len(_reason:GetText())

			mp.Text(len .. " из " .. mp.config.arrest.reason.max, info_fonts, w, 5, mp.Color.BASE, 2, 0)
		end

		local titleTime = vgui.Create("DLabel", parent)
		titleTime:Dock(TOP)
		titleTime:SetSize(0, 28)
		titleTime:DockMargin(0, 0, 5, 0)
		titleTime:SetText("Срок:")
		titleTime:SetFont(info_fonts)
		titleTime:SetColor(mp.Color.WHITE)

		local _time = vgui.Create("DTextEntry", parent)
		_time:Dock(TOP)
		_time:SetSize(0, 24)
		_time:DockMargin(0, 0, 5, 0)
		_time:SetFont(search_font)
		_time:SetValue("60")
		_time:SetNumeric(true)
		_time.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, C_B_100)
			self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
		end

		function _time:OnMousePressed()
			self:SetText("")
		end

		_time.OnChange = function(s)
			if s.GetText then
				local text = s:GetText()

				if text == nil or text == "" then
					s:SetValue("60")
				end
			end
		end

		function titleTime:Paint(w, h)
			print(_time:GetText())
			local time = math.Clamp(
				tonumber((_time:GetText() ~= nil and _time:GetText() ~= "") and _time:GetText() or 0),
				mp.config.arrest.time.min,
				mp.config.arrest.time.max)

			mp.Text(time .. " из " .. mp.config.arrest.time.max .. "с.", info_fonts, w, 5, mp.Color.BASE, 2, 0)
		end

		local titleInfo = vgui.Create("DLabel", parent)
		titleInfo:Dock(TOP)
		titleInfo:SetSize(0, 24)
		titleInfo:DockMargin(0, 0, 5, 0)
		titleInfo:SetText("Сведения:")
		titleInfo:SetFont(info_fonts)
		titleInfo:SetColor(mp.Color.WHITE)

		local _steam = vgui.Create("DLabel", parent)
		_steam:Dock(TOP)
		_steam:SetSize(0, 20)
		_steam:DockMargin(0, 0, 5, 0)
		_steam:SetText("SteamID: " .. pl:SteamID())
		_steam:SetFont(info_fonts)
		_steam:SetColor(C_W_100)

		local _name = vgui.Create("DLabel", parent)
		_name:Dock(TOP)
		_name:SetSize(0, 20)
		_name:DockMargin(0, 0, 5, 0)
		_name:SetText("Имя: " .. pl:Name())
		_name:SetFont(info_fonts)
		_name:SetColor(C_W_100)

		local _job = vgui.Create("DLabel", parent)
		_job:Dock(TOP)
		_job:SetSize(0, 20)
		_job:DockMargin(0, 0, 5, 0)
		_job:SetText("Профессия: " .. pl:GetJobName())
		_job:SetFont(info_fonts)
		_job:SetColor(C_W_100)

		local btnSend = vgui.Create("DButton", parent)
		btnSend:Dock(BOTTOM)
		btnSend:SetTall(30)
		btnSend:DockMargin(0, 5, 0, 0)
		btnSend:SetText("")
		btnSend:SetVisible(true)
		btnSend.TitleText = "Отправить"
		btnSend.Paint = function(self, w, h)
			mp.paint:Button(self, w, h)
		end

		btnSend.OnCursorEntered = function()
			surface.PlaySound(mp.Sound.CLICK)
		end

		btnSend.DoClick = function(self)
			surface.PlaySound(mp.Sound.CLICK_2)

			net.Start("mp.ArrestMenu")
			net.WriteString(_reason:GetText())
			net.WriteUInt(math.Clamp(
				tonumber((_time:GetText() ~= nil and _time:GetText() ~= "") and _time:GetText() or 0),
				mp.config.arrest.time.min,
				mp.config.arrest.time.max), 32)
			net.WriteEntity(pl)
			net.SendToServer()

			fr:AlphaTo(0, 0.2, 0, function()
				fr:Remove()
			end)
		end
	end

	net.Receive("mp.ArrestMenu", function()
		local target = net.ReadEntity()

		if not IsValid(target) then return end

		OpenMenu(target)
	end)
end
