local function L(...) return SH_REPORTS:L(...) end

local matBack = Material("shenesis/general/back.png")

local matBack = Material("shenesis/general/back.png")
local icon_center = Material('stalker/job/ui_job_center.png')
local icon_button = Material('stalker/hud/ui_button_main.png')
local icon_button_press = Material('stalker/hud/ui_button_main2.png')

surface.CreateFont('Prototype', {font='30:Futura PT Light',size=15,weight = 600, extended = true, antialias = true})
surface.CreateFont('Prototype', {font='30:Futura PT Light',size=15,weight = 600, extended = true, antialias = true})
surface.CreateFont('Prototype', {font='30:Futura PT Light',size=14,weight = 300, extended = true, antialias = true})
surface.CreateFont('Prototype', {size = 25, weight = 500,	antialias = true,	extended = true,	font = "DermaDefault"})

function SH_REPORTS:ShowReport(report)
	if (IsValid(_SH_REPORTS_VIEW)) then
		_SH_REPORTS_VIEW:Remove()
	end

	local styl = self.Style
	local th, m = self:GetPadding(), self:GetMargin()
	local m2 = m * 0.5
	local ss = self:GetScreenScale()

	local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
	local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
	local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
	local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
	local C_B_55 = ColorAlpha(mp.Color.BLACK, 55)
	local C_W_10 = ColorAlpha(mp.Color.WHITE, 10)
	local C_W_35 = ColorAlpha(mp.Color.WHITE, 35)

	local title_font = mp.font('30:Futura PT Light')
	local list_font = mp.font('16:DIN Pro Regular')

	local frame = self:MakeWindow(L"")
	frame:SetSize(400 * ss, 400 * ss)
	frame:Center()
	frame:MakePopup()
	frame.Paint = function(self,w,h)
		mp.PanelBlur( self, 2 )

        draw.RoundedBox(0, 0, 0, w, h, C_B_200)
		draw.RoundedBox(0, 0, 0, w, 48, mp.Color.BASE_TO)

        mp.Icon( 0, 0, w, 48, mp.Material.GRADIENT_D, C_B_25 )
        mp.Icon( 0, 0, w, 48, mp.Material.GRADIENT_L, C_B_10 )
        mp.Icon( 0, 48, w, 10, mp.Material.GRADIENT_U, C_B_150 )

		draw.SimpleText('Просмотр жалоб',title_font,25,25,mp.Color.WHITE,0,1)

		--draw.SimpleText('Подал:','JobsHeaderMoney_Desc',30,45,Color(245,245,225),0,0)
		--draw.RoundedBox(1, 2, 2, w-4, h-4, Color(75,75,75,95))
		--draw.RoundedBox(1, 0, 0, w, h, styl.inbg)
	end
	_SH_REPORTS_VIEW = frame

		frame:AddHeaderButton(matBack, function()
			frame:Close()
			self:ShowReports()
		end)

		local body = vgui.Create("DPanel", frame)
		body:SetDrawBackground(false)
		body:DockPadding(m+12, m, m, m)
		body:Dock(FILL)

			local players = vgui.Create("DPanel", body)
			players:SetDrawBackground(false)
			players:SetWide(frame:GetWide() - m * 2)
			players:Dock(TOP)

				local lbl1 = self:QuickLabel(L"reporter", list_font, styl.text, players)
				lbl1:SetContentAlignment(7)
				lbl1:SetTextInset(m2, m2)
				lbl1:SetWide(frame:GetWide() * 0.5 - m2)
				lbl1:Dock(LEFT)
				lbl1:DockPadding(m2, lbl1:GetTall() + m * 1.5, m2, m2)
				lbl1.Paint = function(me, w, h)
					draw.RoundedBox(1, 0, 0, w, h, Color(15,15,15,200))
				end

					local avi = self:Avatar(report.reporter_id, 32, lbl1)
					avi:Dock(LEFT)
					avi:DockMargin(0, 0, m2, 0)

					local nic = self:QuickButton(report.reporter_name, function()
						SetClipboardText(report.reporter_name)
						surface.PlaySound("common/bugreporter_succeeded.wav")
					end, lbl1)
					nic:SetContentAlignment(4)
					nic:Dock(TOP)
					nic:SetFont(list_font)

					local s1 = util.SteamIDFrom64(report.reporter_id)
					local steamid = self:QuickButton(s1, function()
						SetClipboardText(s1)
						surface.PlaySound("common/bugreporter_succeeded.wav")
					end, lbl1)
					steamid:SetContentAlignment(4)
					steamid:Dock(TOP)

				local lbl = self:QuickLabel(L"reported_player", list_font, styl.text, players)
				lbl:SetContentAlignment(9)
				lbl:SetTextInset(m2, m2)
				lbl:Dock(FILL)
				lbl:DockPadding(m2, lbl1:GetTall() + m * 1.5, m2, m2)
				lbl.Paint = lbl1.Paint

					local avi = self:Avatar(report.reported_id, 32, lbl)
					avi:Dock(RIGHT)
					avi:DockMargin(m2, 0, 0, 0)

					local nic = self:QuickButton(report.reported_name, function()
						SetClipboardText(report.reported_name)
						surface.PlaySound("common/bugreporter_succeeded.wav")
					end, lbl)
					nic:SetContentAlignment(6)
					nic:Dock(TOP)
					nic:SetFont(list_font)
					nic.Think = function(me)
						me:SetTextColor(IsValid(player.GetBySteamID64(report.reported_id)) and styl.text or styl.failure)
					end

					local s2 = util.SteamIDFrom64(report.reported_id)
					local steamid = self:QuickButton(s2, function()
						SetClipboardText(s2)
						surface.PlaySound("common/bugreporter_succeeded.wav")
					end, lbl)
					steamid:SetContentAlignment(6)
					steamid:Dock(TOP)
					steamid:SetFont(list_font)

					if (report.reported_id == "0") then
						nic.Think = function() end
						nic:Dock(FILL)
						steamid:SetVisible(false)
						avi:SetVisible(false)
					end

				players:SetTall(lbl1:GetTall() + m * 2.5 + 32)

			local reason = self:QuickLabel(L("reason") .. ":", list_font, styl.text, body)
			reason:Dock(TOP)
			reason:DockMargin(8, m, 0, 0)
			reason:DockPadding(reason:GetWide() + m2, 0, 0, 0)

				local r = self:QuickEntry(self.ReportReasons[report.reason_id], reason)
				r:SetEnabled(false)
				r:SetContentAlignment(6)
				r:Dock(FILL)
				r:SetFont(list_font)

			local comment = self:QuickLabel(L("comment") .. ":", list_font, styl.text, body)
			comment:SetContentAlignment(7)
			comment:Dock(FILL)
			comment:DockMargin(8, m, 0, m2)

				local tx = self:QuickEntry("", comment)
				tx:SetEnabled(false)
				tx:SetMultiline(true)
				tx:SetValue(report.comment)
				tx:Dock(FILL)
				tx:DockMargin(0, comment:GetTall() + m2, 0, 0)

			local actions = vgui.Create("DPanel", body)
			actions:SetDrawBackground(false)
			actions:Dock(BOTTOM)

				if (self:IsAdmin(LocalPlayer())) then
					if (report.admin_id == "") then
						if (self.ClaimNoTeleport) then
							local claim = self:QuickButton(L"claim_report", function()
								easynet.SendToServer("SH_REPORTS.Claim", {id = report.id})
							end, actions)
							claim:Dock(LEFT)
						else
							local lbl = self:QuickLabel(L"", "StalkerDesc_1", styl.text, actions)
							lbl:SetContentAlignment(4)
							lbl:Dock(LEFT)
							lbl:DockMargin(0, 0, m2, 0)

							local goto = self:QuickButton(L"goto", function()
								if (IsValid(player.GetBySteamID64(report.reported_id))) then
									local m = self:Menu()
									m:AddOption("bring_reported_player"):SetMouseInputEnabled(false)
									m:AddOption("yes", function()
										easynet.SendToServer("SH_REPORTS.ClaimAndTeleport", {id = report.id, bring = false, bring_reported = true})
									end)
									m:AddOption("no", function()
										easynet.SendToServer("SH_REPORTS.ClaimAndTeleport", {id = report.id, bring = false, bring_reported = false})
									end)
									m:Open()
								else
									easynet.SendToServer("SH_REPORTS.ClaimAndTeleport", {id = report.id, bring = false, bring_reported = false})
								end
							end, actions)
							goto:Dock(LEFT)
							goto:SetText('')
							goto:SetSize(115,15)
							goto.Paint = function(self,w,h)
								if self:IsHovered() then
									draw.RoundedBox(0, 4, 4, w-2, h, C_W_35)
								else
									draw.RoundedBox(0, 4, 4, w-2, h, C_W_10)
								end

									draw.SimpleText('ТП к игроку', list_font,w/2,h/2,Color(245,245,225),1,1)
							end

							local bring = self:QuickButton(L"bring", function()
								if (IsValid(player.GetBySteamID64(report.reported_id))) then
									local m = self:Menu()
									m:AddOption("bring_reported_player"):SetMouseInputEnabled(false)
									m:AddOption("yes", function()
										easynet.SendToServer("SH_REPORTS.ClaimAndTeleport", {id = report.id, bring = true, bring_reported = true})
									end)
									m:AddOption("no", function()
										easynet.SendToServer("SH_REPORTS.ClaimAndTeleport", {id = report.id, bring = true, bring_reported = false})
									end)
									m:Open()
								else
									easynet.SendToServer("SH_REPORTS.ClaimAndTeleport", {id = report.id, bring = true, bring_reported = false})
								end
							end, actions)
							bring:Dock(LEFT)
							bring:SetText('')
							bring:SetSize(95,15)
							bring:DockMargin(m2, 0, 0, 0)
							bring.Paint = function(self,w,h)
								if self:IsHovered() then
									draw.RoundedBox(0, 4, 4, w-2, h, C_W_35)
								else
									draw.RoundedBox(0, 4, 4, w-2, h, C_W_10)
								end

								draw.SimpleText('ТП к себе', list_font,w/2,h/2,Color(245,245,225),1,1)
							end
						end

						if (sitsys) then
							local session = self:QuickButton(L"start_sit_session", function()
								easynet.SendToServer("SH_REPORTS.ClaimAndCSit", {id = report.id})
							end, actions)
							session:Dock(LEFT)
							session:DockMargin(m2, 0, 0, 0)
						end
					else
						local lbl = self:QuickLabel(L("claimed_by_x", ""), list_font, styl.text, actions)
						lbl:SetContentAlignment(4)
						lbl:Dock(LEFT)
						lbl:DockMargin(0, 0, m2, 0)

						self:GetName(report.admin_id, function(nick)
							if (IsValid(lbl)) then
								lbl:SetText(L("claimed_by_x", nick))
								lbl:SizeToContents()
							end
						end)
					end
				end

				if (report.reporter_id == LocalPlayer():SteamID64()) or (report.admin_id == "" and self.CanDeleteWhenUnclaimed) or (report.admin_id == LocalPlayer():SteamID64()) then
					local close = self:QuickButton(L"close_report", function()
						easynet.SendToServer("SH_REPORTS.CloseReport", {id = report.id})
						frame:Close()
					end, actions, nil, self.Style.close_hover)
					close:Dock(RIGHT)
					close:SetSize(95,15)
					close.Paint = function(self,w,h)
						if self:IsHovered() then
							draw.RoundedBox(0, 4, 4, w-2, h, C_W_35)
						else
							draw.RoundedBox(0, 4, 4, w-2, h, C_W_10)
						end

						draw.SimpleText('Закрыть', list_font,w/2,h/2,Color(245,245,225),1,1)
					end
				end

	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.1)
end

local matStats = Material("shenesis/reports/stats.png")
local matAdd = Material("shenesis/reports/add.png")

function SH_REPORTS:ShowReports()
	if (IsValid(_SH_REPORTS)) then
		_SH_REPORTS:Remove()
	end
	if (IsValid(_SH_REPORTS_VIEW)) then
		_SH_REPORTS_VIEW:Remove()
	end

	local styl = self.Style
	local th, m = self:GetPadding(), self:GetMargin()
	local ss = self:GetScreenScale()

	local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
	local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
	local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
	local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
	local C_B_55 = ColorAlpha(mp.Color.BLACK, 55)
	local C_W_10 = ColorAlpha(mp.Color.WHITE, 10)
	local C_W_35 = ColorAlpha(mp.Color.WHITE, 35)

	local title_font = mp.font('30:Futura PT Light')
	local list_font = mp.font('16:DIN Pro Regular')

	local delay = 0
	if (self.ServerTime) then
		delay = self.ServerTime - os.time()
	end

	local frame = self:MakeWindow(self:IsAdmin(LocalPlayer()) and L"" or L"your_reports")
	frame:SetSize(1000 * ss, 600 * ss)
	frame:Center()
	frame:MakePopup()
	frame:SetAlpha(0)
    frame:AlphaTo(255, 0.3, 0) 
	frame.Paint = function(self,w,h)
		--draw.RoundedBox(1, 2, 2, w-4, h-4, Color(75,75,75,95))
		--draw.RoundedBox(1, 0, 0, w, h, styl.inbg)
        mp.PanelBlur( self, 2 )

        draw.RoundedBox(0, 0, 0, w, h, C_B_200)
		draw.RoundedBox(0, 0, 0, w, 48, mp.Color.BASE_TO)

        mp.Icon( 0, 0, w, 48, mp.Material.GRADIENT_D, C_B_25 )
        mp.Icon( 0, 0, w, 48, mp.Material.GRADIENT_L, C_B_10 )
        mp.Icon( 0, 48, w, 10, mp.Material.GRADIENT_U, C_B_150 )

		draw.SimpleText('Список жалоб',title_font,25,25,mp.Color.WHITE,0,1)
	end
	_SH_REPORTS = frame

		if (self.UsergroupsPerformance[LocalPlayer():GetUserGroup()]) then
			local btn = frame:AddHeaderButton(matStats, function()
				easynet.SendToServer("SH_REPORTS.RequestPerfReports")
				frame:Close()
			end)
			btn:SetToolTip(L"performance_reports")
		end
		if (!self:IsAdmin(LocalPlayer()) or self.StaffCanReport) then
			local btn = frame:AddHeaderButton(matAdd, function()
				self:ShowMakeReports()
				frame:Close()
			end)
			btn:SetToolTip(L"new_report")
		end

		local ilist = vgui.Create("DListView", frame)
		ilist:SetSortable(false)
		ilist:SetDrawBackground(false)
		ilist:SetDataHeight(32)
		ilist:Dock(FILL)
		ilist:AddColumn(L"reporter")
		ilist:AddColumn(L"reported_player")
		ilist:AddColumn(L"reason")
		ilist:AddColumn(L"waiting_time")
		ilist:AddColumn(L"claimed")
		ilist:AddColumn(L"actions")
		ilist:SetHeaderHeight( 32 )
		ilist:SetDataHeight( 33 )

		self:PaintList(ilist)

		local function RePaintDListTeams()
			for k, line in pairs( ilist:GetLines() ) do
				for k, v in pairs(line.Columns) do
					v:SetText('')
				end
	
				line.Paint = function( self, w, h )
					if k%2 != 0 then
						draw.RoundedBox(0, 0, 0, w, h, C_B_55)
					end
	
					if line:IsSelected() then
						draw.RoundedBox(0, 0, 0, w, h, C_W_10)
					end
	
					local wi = 0
					for k, v in pairs(line.Columns) do
						wi = k == 1 and wi or wi + line.Columns[k-1]:GetWide()
						draw.SimpleText(v.Value, list_font, wi+4, 0, color_white)
					end
				end
			end
	
		end
		
		RePaintDListTeams()

		for _, colum in pairs(ilist.Columns) do
			local text = colum.Header:GetText()
			colum.Header.Paint = function( self, w, h )

				if self:IsHovered() then
					draw.RoundedBox(0, 4, 4, w-2, h, C_W_35)
				else
					draw.RoundedBox(0, 4, 4, w-2, h, C_W_10)
				end

				draw.SimpleText(text, list_font, w/2, h/2+2, mp.Color.WHITE, 1, 1)
			end
			colum.Header:SetText('')
		end	

			for _, report in SortedPairsByMemberValue (self.ActiveReports, "time", true) do
				local reporter = vgui.Create("DPanel", frame)
				reporter:SetDrawBackground(false)

					local avi = self:Avatar(report.reporter_id, 24, reporter)
					avi:SetPos(4, 4)

					local name = self:QuickLabel(report.reporter_name, list_font, styl.text, reporter)
					name:Dock(FILL)
					name:SetTextInset(ilist:GetDataHeight(), 0)

				local reported = vgui.Create("DPanel", frame)
				reported:SetDrawBackground(false)

					local avi = self:Avatar(report.reported_id, 24, reported)
					avi:SetPos(4, 4)

					local name = self:QuickLabel(report.reported_name, list_font, styl.text, reported)
					name:Dock(FILL)
					name:SetTextInset(32, 0)

					if (report.reported_id ~= "0") then
						name.Think = function(me)
							me:SetTextColor(IsValid(player.GetBySteamID64(report.reported_id)) and styl.text or styl.failure)
						end
					else
						avi:SetVisible(false)
						name:SetContentAlignment(5)
						name:SetTextInset(0, 0)
					end

				local claimed = vgui.Create("DPanel", frame)
				claimed:SetDrawBackground(false)

					local avi = self:Avatar("", 24, claimed)
					avi:SetPos(4, 4)
					claimed.avi = avi

					local name = self:QuickLabel(L"unclaimed", list_font, styl.text, claimed)
					name:Dock(FILL)
					name:SetTextInset(32, 0)
					claimed.name = name

					if (report.admin_id ~= "") then
						avi:SetSteamID(report.admin_id)

						self:GetName(report.admin_id, function(nick)
							if (IsValid(name)) then
								name:SetText(nick)
							end
						end)
					else
						avi:SetVisible(false)
						name:SetContentAlignment(5)
						name:SetTextInset(0, 0)
					end

				local actions = vgui.Create("DPanel", frame)
				actions:SetDrawBackground(false)
				actions:SetTall(32)
				actions:DockPadding(5, 5, 5, 5)

					local act_view = self:QuickButton(L"view", function() end, actions)
					act_view:Dock(LEFT)
					act_view:DockMargin(10, 0, 4, 0)
					act_view:SetText('')
					act_view:SetWide(actions:GetTall()+65)
					act_view.Paint = function(self,w,h)
						if self:IsHovered() then
							draw.RoundedBox(0, 4, 4, w-2, h, C_W_35)
						else
							draw.RoundedBox(0, 4, 4, w-2, h, C_W_10)
						end

						draw.SimpleText('Просмотр', list_font,w/2+2,h/2+1,color_white,1,1)
					end
					act_view.DoClick = function()
						frame:Close()
						self:ShowReport(report)
					end

					local act_delete
					if (report.admin_id == "" and self.CanDeleteWhenUnclaimed) or (report.admin_id == LocalPlayer():SteamID64()) then
						act_delete = self:QuickButton('L"close_report"', function() end, actions, nil, self.Style.close_hover)
						act_delete:Dock(LEFT)
						act_delete:SetSize(28,15)
						act_delete.Paint = function(self,w,h)
							if self:IsHovered() then
								draw.RoundedBox(0, 4, 4, w-2, h, C_W_35)
							else
								draw.RoundedBox(0, 4, 4, w-2, h, C_W_10)
							end

							draw.SimpleText('x', title_font,w/2+2,h/2-2,color_white,1,1)
						end
						act_delete.DoClick = function()
							easynet.SendToServer("SH_REPORTS.CloseReport", {id = report.id})
						end
					end

				local time = self:QuickLabel("", "{prefix}Medium", styl.text, frame)
				time:SetContentAlignment(5)
				time.Think = function(me)
					if (!me.m_fNextRefresh or RealTime() >= me.m_fNextRefresh) then
						me.m_fNextRefresh = RealTime() + 5
						me:SetText(self:FullFormatTime(os.time() + delay - report.time))
						me:SetFont(list_font)
					end
				end

			local line = ilist:AddLine(reporter, reported, self.ReportReasons[report.reason_id], time, claimed, actions)
			-- line:SetSelectable(false)
			line.claimed = claimed
			line.delete = act_delete
			line.Close = function(me)
				me:AlphaTo(0, 0.2, nil, function()
					if (!ilist.Lines[me:GetID()]) then
						return end

					ilist:RemoveLine(me:GetID())
				end)
			end
			self:LineStyle(line)

			for _, rep in pairs (self.ActiveReports) do
				if (rep.id == report.id) then
					rep.line = line
				end
			end
		end
end

function SH_REPORTS:MakeTab(report)
	if (IsValid(_SH_REPORTS_TAB)) then
		_SH_REPORTS_TAB:Close()
	end

	local styl = self.Style
	local th, m = self:GetPadding(), self:GetMargin()
	local m2 = m * 0.5

	local rep = vgui.Create("DButton")
	rep:SetText("")
	rep:SetSize(160, 32 + m)
	rep:SetPos(ScrW() * 0.5, ScrH())
	rep:MoveToFront()
	rep:DockPadding(m2, m2, m2, m2)
	rep.Paint = function(me, w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, styl.header, true, true, false, false)
	end
	rep.DoClick = function(me)
		if (me.m_bClosing) then
			return end

		self:ShowReport(report)
	end
	rep.Close = function(me)
		if (me.m_bClosing) then
			return end

		me.m_bClosing = true
		me:Stop()
		me:MoveTo(rep.x, ScrH(), 0.2, 0, -1, function()
			me:Remove()
		end)
	end
	rep.id = report.id
	_SH_REPORTS_TAB = rep

		local avi = self:Avatar(report.reporter_id, 32, rep)
		avi:SetMouseInputEnabled(false)
		avi:Dock(LEFT)
		avi:DockMargin(0, 0, m2, 0)

		local name = self:QuickLabel(L("report_of_x", report.reporter_name), "{prefix}Large", styl.text, rep)
		name:Dock(FILL)

	rep:SetWide(name:GetWide() + avi:GetWide() + m * 1.5)
	rep:CenterHorizontal()
	rep:MoveTo(rep.x, ScrH() - rep:GetTall(), 0.2)
end

function SH_REPORTS:MakeNotification(report)
	if (IsValid(report.notif)) then
		report.notif:Close()
	end

	local styl = self.Style
	local th, m = self:GetPadding(), self:GetMargin()
	local m2 = m * 0.5

	local rep = vgui.Create("DButton")
	rep:SetText("")
	rep:SetSize(160, 32 + m)
	rep:SetPos(ScrW() * 0.5, -rep:GetTall())
	rep:MoveToFront()
	rep:DockPadding(m2, m2, m2, m2)
	rep.Paint = function(me, w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, styl.header, false, false, true, true)
	end
	rep.DoClick = function(me)
		if (me.m_bClosing) then
			return end

		self:ShowReport(report)
		me:Close()
	end
	rep.Close = function(me)
		if (me.m_bClosing) then
			return end

		me.m_bClosing = true
		me:Stop()
		me:MoveTo(rep.x, -me:GetTall(), 0.2, 0, -1, function()
			me:Remove()
		end)
	end
	report.notif = rep

		local avi = self:Avatar(report.reporter_id, 32, rep)
		avi:SetMouseInputEnabled(false)
		avi:Dock(LEFT)
		avi:DockMargin(0, 0, m2, 0)

		local name = self:QuickLabel(L("report_received", report.reporter_name, report.reported_name, self.ReportReasons[report.reason_id]), "{prefix}Large", styl.text, rep)
		name:Dock(FILL)

	rep:SetWide(name:GetWide() + avi:GetWide() + m * 1.5)
	rep:CenterHorizontal()
	rep:MoveTo(rep.x, 0, 0.2, nil, nil, function()
		rep:MoveTo(rep.x, -rep:GetTall(), 0.2, 7.5, nil, function()
			rep:Remove()
		end)
	end)
end

SH_REPORTS.PendingPanels = SH_REPORTS.PendingPanels or {}

function SH_REPORTS:ClosePendingPanel(id)
	local cleaned = {}

	-- Clean closed reports
	for k, v in pairs (self.PendingPanels) do
		if (!IsValid(v)) then
			continue end

		local found = false
		for _, rep in pairs (SH_REPORTS.ActiveReports) do
			if (rep.id == v.m_iReportID) then
				found = true
			end
		end

		if (!found) or (v.m_iReportID == id) then
			v:Close()
			continue
		end

		table.insert(cleaned, v)
	end

	self.PendingPanels = cleaned
end

function SH_REPORTS:MakePending(report)
	if (IsValid(report.pending)) then
		report.pending:Remove()
	end

	local num = 0
	for _, w in pairs (self.PendingPanels) do
		if (IsValid(w) and !w.m_bClosing) then
			num = num + 1
		end
	end

	if (num >= self.PendingReportsDispNumber) then
		return end

	local styl = self.Style
	local th, m = self:GetPadding(), self:GetMargin()
	local hh = th * 0.66
	local m2, m3 = m * 0.5, m * 0.66
	local ss = self:GetScreenScale()



	local wnd = vgui.Create("DPanel")

	--wnd:SetPos(10,60)
	wnd:SetSize(300 * ss, 112 * ss)
	wnd:DockPadding(m3, hh + m3, m3, m3)
	wnd.Paint = function(me, w, h)
		if !wnd.xx then wnd.xx = 0 end
	wnd.xx = Lerp(FrameTime()*5.5, wnd.xx, 0 + w)
		--draw.RoundedBoxEx(1, 2, hh+2, w-4, h - hh - 4, Color(75,75,75,95))
		--draw.RoundedBoxEx(1, 0, 0, wnd.xx, hh, styl.header)
		--draw.RoundedBoxEx(1, 1, 1, w-2, hh-2, Color(0,0,0,75))
		--draw.RoundedBoxEx(1, 0, hh, wnd.xx, h - hh, styl.inbg)
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( icon_center )
		surface.DrawTexturedRect( 0, 0, w, h )
		draw.SimpleText("" .. L("report_of_x", report.reporter_name), "ReportSmall", m2 + 22, hh * 0.6, Color(238,238,238), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	wnd.m_iReportID = report.id
	report.pending = wnd

		local lbl = self:QuickLabel(L"reported_player" .. "", "JobsHeaderMoney_Desc", styl.text, wnd)
		lbl:Dock(TOP)
		lbl:DockMargin(15, m3-12, 0, 0)

			local reported = self:QuickLabel(report.reported_name, "JobsHeaderMoney_Desc", styl.text, lbl)
			reported:Dock(RIGHT)
			--reported:SetFont('StalkerDesc_1')

		local lbl = self:QuickLabel(L"reason" .. ":", "JobsHeaderMoney_Desc", styl.text, wnd)
		lbl:Dock(TOP)
		lbl:DockMargin(15, m3-10, 0, 0)

			local reason = self:QuickLabel(self.ReportReasons[report.reason_id], "JobsHeaderMoney_Desc", styl.text, lbl)
			reason:Dock(RIGHT)

		local buttons = vgui.Create("DPanel", wnd)
		buttons:SetDrawBackground(false)
		buttons:SetTall(20 * ss)
		buttons:Dock(BOTTOM)

			local close = self:QuickButton("✕", function()
				wnd:Close()
				report.ignored = true
			end, buttons)
			close:SetWide(buttons:GetTall()+5)
			close:Dock(LEFT)
			close:DockMargin(20, m3-10, 0, 0)
			close:SetText('')
			close.m_Background = styl.close_hover
			close.Paint = function(self,w,h)
				if self:IsHovered() then
					surface.SetDrawColor( 255, 255, 255 )
					surface.SetMaterial( icon_button_press )
					surface.DrawTexturedRect( 2, 0, w, h )
				else
					surface.SetDrawColor( 255, 255, 255 )
					surface.SetMaterial( icon_button )
					surface.DrawTexturedRect( 0, 0, w, h )
				end
				draw.SimpleText('x', 'ReportSmall',w/2,9,Color(238,238,238),1,1)
			end

			local view = self:QuickButton(L"view", function()
				self:ShowReport(report)
			end, buttons)
		  view:SetWide(buttons:GetTall()+75)
			view:Dock(RIGHT)
			view:SetText('')
			view.m_Background = styl.header
			view.Paint = function(self,w,h)
				--draw.RoundedBoxEx(1, 0, 0, w, h, styl.header)
				--draw.RoundedBoxEx(1, 1, 1, w-2, h-2, Color(0,0,0,75))
				if self:IsHovered() then
					surface.SetDrawColor( 255, 255, 255 )
					surface.SetMaterial( icon_button_press )
					surface.DrawTexturedRect( 2, 0, w, h )
				else
					surface.SetDrawColor( 255, 255, 255 )
					surface.SetMaterial( icon_button )
					surface.DrawTexturedRect( 0, 0, w, h )
				end
					draw.SimpleText('Просмотр', 'ReportSmall',w/2,9,Color(245,245,225),1,1)
			end

	local i = table.insert(self.PendingPanels, wnd)
	wnd:SetPos(m, m + (i - 1) * wnd:GetTall() + (i - 1) * m + 80)
	wnd:SetAlpha(0)
	wnd:AlphaTo(255, 0.1)

	wnd.Close = function(me)
		if (me.m_bClosing) then
			return end

		me.m_bClosing = true
		me:AlphaTo(0, 0.1, 0, function()
			local ma = #self.PendingPanels
			table.RemoveByValue(self.PendingPanels, me)
			me:Remove()

			local o = 0
			for j = i - 1, ma do
				local w = self.PendingPanels[j]
				if (IsValid(w) and w ~= me) then
					w:Stop()
					w:MoveTo(w.x, m + o * wnd:GetTall() + o * m, 0.2)
					o = o + 1
				end
			end

			-- Display any hidden panels
			for _, r in pairs (self.ActiveReports) do
				if (!IsValid(r.pending) and !r.ignored and r.admin_id == "") then
					self:MakePending(r)
				end
			end
		end)
	end
end
