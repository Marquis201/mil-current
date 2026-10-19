local ColorAlpha = ColorAlpha
local Color = Color
local mp = mp
local draw = draw
local vgui = vgui
local FrameTime = FrameTime
local Lerp = Lerp
local net = net
local surface = surface

local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)
local C_B_100 = ColorAlpha(mp.Color.BASE, 100)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)

local color_background = Color(29, 29, 29, 225)
local color_title = ColorAlpha(mp.Color.BASE_TO, 200)
local color_text = ColorAlpha(mp.Color.BASE, 200)
local color_panel = mp.Color.BASE
local color_bottom = mp.Color.BASE
local color_item = ColorAlpha(mp.Color.BASE_TO, 150)
local color_name = mp.Color.BASE
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)

local title_font = mp.font("40:Futura PT Medium")
local goback_font = mp.font("25:mr_ApexMk3MediumG")
local cat_font = mp.font("25:Futura PT Medium")
local welcome_font = mp.font("30:Futura PT Book")
local name_font = mp.font("22:Futura PT Book")
local price_font = mp.font("22:Futura PT Medium")
local search_font = mp.font("20:DIN Pro Regular")
local info_fonts = mp.font("18:DIN Pro Regular")

local title_text = "MILITARY PLAY"
local exit_text = "× Закрыть"
local welcome_text = "Здравствуйте, "
local buy_text = "Купить"
local balance_text = "Баланс: "

local CreateTable = {}

local HoverCat = "Все предметы"
local inventory = {}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Price(num)
	return string.Comma(num) .. " RUB" or 0
end

local function Day(num)
	return "на " .. num .. " дней"
end

local function GetPlayerBalance()
	if LocalPlayer().IGSFunds then
		return LocalPlayer():IGSFunds() or 0
	end
	return 0
end

local function FormatBalance(balance)
	return string.Comma(balance) .. " RUB"
end

local function CreateMaterial(url)
	local icon = texture.Create("example")
		:SetSize(128, 128)
		:SetFormat("png")
		:Download(url, print, print)
		:Render(function(self, w, h)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self:GetMaterial())
			surface.DrawTexturedRect(0, 0, w, h)
		end)

	if icon:GetMaterial() then
		return icon:GetMaterial()
	else
		return false
	end
end

net.Receive("OpenTopUpMenu", function()
	local amount = net.ReadInt(32)
	CreateTopUpMenu(amount)
end)

net.Receive("GetPlayerDonateWeapons", function()
	local weapons = net.ReadTable()
	-- Данные обрабатываются в меню изъятия
end)

local function getmodel(item)
	if item.category == "Подразделения" then
		return mp.jobs_by_id[item.uid] and
			(istable(mp.jobs_by_id[item.uid].model) and mp.jobs_by_id[item.uid].model[1] or mp.jobs_by_id[item.uid].model) or
			false
	elseif item.category == "Оружие" and item:GetMeta("weapons") then
		local weapons = weapons
		local wep = item:GetMeta("weapons")

		return weapons.Get(wep) and weapons.Get(wep).WorldModel or false
	end

	return false
end

local function getname(item)
	if item.category == "Подразделения" then
		return mp.jobs_by_id[item.uid] and mp.jobs_by_id[item.uid].Name or item.name
	elseif item.category == "Оружие" and item:GetMeta("weapons") then
		local weapons = weapons
		local wep = item:GetMeta("weapons")

		return weapons.Get(wep) and weapons.Get(wep).PrintName or item.name
	end

	return item.name
end

local function purchaseIGS(ITEM)
	IGS.Purchase(ITEM:UID(), function(errMsg, dbID)
		if errMsg then
			IGS.ShowNotify(errMsg, "Ошибка покупки")
			surface.PlaySound("ambient/voices/citizen_beaten1.wav") -- еще есть
			return
		end

		if not IGS.C.Inv_Enabled then
			IGS.ShowNotify("Спасибо за покупку. Это было просто, правда? :)", "Успешная покупка")
			return
		end

		IGS.BoolRequest("Успешная покупка",
			"Спасибо за покупку. Она находится в вашем /donate инвентаре.\n\nАктивировать ее сейчас?",
			function(yes)
				if not yes then return end

				IGS.ProcessActivate(dbID)
			end)

		surface.PlaySound("ambient/office/coinslot1.wav")
	end)
end

local function CreatPanel(Scroll, tbl)
	Scroll:Clear()

	local pl = LocalPlayer()

	local List = vgui.Create("DIconLayout", Scroll)
	List:Dock(TOP)
	List:SetSpaceY(10)
	List:SetSpaceX(10)
	List:DockMargin(10, 10, 0, 10)
	List:SetAlpha(0)
	List:AlphaTo(255, 0.2, 0)

	if tbl then
		for k, v in pairs(tbl) do
			local name = getname(v)
			local has_activate = false
			local icon = v.image_url and Material(v.image_url) or nil

			for _, item in ipairs(inventory) do
				if item.item.uid == v.uid and not pl:HasPurchase(v.uid) then
					has_activate = item.id
					break
				end
			end

			local ItemPanel = vgui.Create("Panel", List)
			ItemPanel:SetSize(308, 312)
			ItemPanel.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, color_item)
				--draw.RoundedBox(0, 0, 50, w, 1, color_bottom)
				draw.RoundedBox(0, 0, h - 50, w, 1, ColorOutline)


				surface.SetDrawColor(ColorOutline)
				surface.DrawOutlinedRect(0, 0, w, h, 1)

				--mp.Text(name, name_font, w / 2, 15, color_name, 1, 0)
				mp.Text(Price(v.price), price_font, w - 10, h - 75, color_text, 2, 0)
				mp.Text(Day(v.termin), price_font, 10, h - 75, color_panel, 0, 0)

				if icon then
					mp.Icon(w / 2 - 100, h / 2 - 100, 200, 200, icon, WHITE)
				end
			end

			local NameItem = vgui.Create("DLabel", ItemPanel)
			NameItem:Dock(TOP)
			NameItem:DockMargin(10, 10, 10, 10)
			NameItem:SetText(name)
			NameItem:SetTextColor(color_white)
			NameItem:SetFont(name_font)
			NameItem:SetWrap(true)
			NameItem:SetAutoStretchVertical(true)

			local model = getmodel(v)
			if model then
				local mdl = vgui.Create("DModelPanel", ItemPanel)
				mdl:SetPos(0, 0)
				mdl:SetSize(ItemPanel:GetWide(), ItemPanel:GetTall())
				mdl:SetModel(model)
				mdl:SetFOV(55)
				local mn, mx = mdl.Entity:GetRenderBounds()
				local size = 12
				size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
				size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
				size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
				mdl:SetCamPos(Vector(size, size, size))
				mdl:SetLookAt((mn + mx) * 0.5)
				mdl:SetMouseInputEnabled(false)
				function mdl:LayoutEntity(ent)
					return false
				end
			end

			local nameBuy = "Купить"

			if pl:HasPurchase(v.uid) then
				if v.category == "Подразделения" then
					nameBuy = mp.jobs[pl:Team()].jobid == v.uid and "Выбран" or "Выбрать"
				elseif v.category == "Привилегии" then
					nameBuy = pl:GetUserGroup() == v.uid and "Выбран" or "Выбрать"
				else
					nameBuy = "Куплен"
				end
			else
				nameBuy = has_activate and "Активировать" or "Купить"
			end

			local BuyBtn = vgui.Create("DButton", ItemPanel)
			BuyBtn:Dock(BOTTOM)
			BuyBtn:SetTall(50)
			BuyBtn:SetText(nameBuy)
			BuyBtn:SetTextColor(Color(0, 0, 0, 0))
			BuyBtn.Hover = 0
			BuyBtn.Paint = function(self, w, h)
				if self:IsHovered() then
					self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
				else
					self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
				end

				draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_panel, self.Hover))

				draw.SimpleText(self:GetText(), cat_font, w / 2, h / 2, ColorAlpha(color_text, 255 - self.Hover), 1,
					1)
				draw.SimpleText(self:GetText(), cat_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
			end

			BuyBtn.DoClick = function(self)
				local ITEM = IGS.GetItemByUID(v.uid)
				local price = ITEM.price

				if has_activate then
					IGS.BoolRequest(
						"Активация", "Желаете активировать " .. ITEM:Name() .. "?",
						function(yes)
							if yes then
								IGS.ProcessActivate(has_activate, function(ok)
									if not ok then return end

									if IsValid(CREATE_DONATE) then
										CREATE_DONATE:AlphaTo(0, 0.1, 0, function()
											CREATE_DONATE:Remove()
										end)
									end
								end)
							end
						end
					):ShowCloseButton(true)

					return
				end

				if pl:HasPurchase(v.uid) then
					if v.category == "Подразделения" then
						IGS.BoolRequest(
							"Выбор подразделения", "Желаете выбрать " .. ITEM:Name() .. "?",
							function(yes)
								if yes then
									net.Start("mp.donate.SetTeam")
									net.WriteString(tostring(v.uid))
									net.SendToServer()
								end
							end
						):ShowCloseButton(true)

						return
					end

					if v.category == "Привилегии" then
						IGS.BoolRequest(
							"Выбор привилегии", "Желаете выбрать " .. ITEM:Name() .. "?",
							function(yes)
								if yes then
									net.Start("mp.donate.SetUserGroup")
									net.WriteString(tostring(v.uid))
									net.SendToServer()
								end
							end
						):ShowCloseButton(true)

						return
					end

					mp.util.Notify(NOTIFY_ERROR, "Предмет уже куплен")
					return
				end

				if not IGS.CanAfford(pl, price) then
					local need = price - pl:IGSFunds()

					surface.PlaySound("ambient/voices/citizen_beaten1.wav")
					IGS.BoolRequest(
						"Недостаточно денег",
						("Вам не хватает %s для покупки %s.\nЖелаете мгновенно пополнить счет?"):format(PL_IGS(need),
							ITEM:Name()),
						function(yes)
							if yes then
								IGS.WIN.Deposit(need, true)
								surface.PlaySound("vo/npc/male01/yeah02.wav")
							end
						end
					):ShowCloseButton(true)
					if IsValid(CREATE_DONATE) then
						CREATE_DONATE:AlphaTo(0, 0.1, 0, function()
							CREATE_DONATE:Remove()
						end)
					end
					return
				end

				IGS.BoolRequest("Подтверждение покупки",
					'Подтверждаете покупку ' .. ITEM.name .. '?', function(t)
						if not t then return end
						purchaseIGS(ITEM)
					end):ShowCloseButton(true)

				if IsValid(CREATE_DONATE) then
					CREATE_DONATE:AlphaTo(0, 0.1, 0, function()
						CREATE_DONATE:Remove()
					end)
				end
			end

			List:DockPadding(0, 0, 0, 10)
			List:SizeToContents()
		end
	end
end

local function CreateDonateMenu()
	local scrw, scrh = ScrW(), ScrH()
	local ply = LocalPlayer()

	if IsValid(CREATE_DONATE) then
		CREATE_DONATE:Remove()
	end

	IGS.GetInventory(function(data)
		inventory = data

		local balance_w = 0
		local HelpMenu = vgui.Create("EditablePanel")
		CREATE_DONATE = HelpMenu
		HelpMenu:SetSize(scrw, scrh)
		HelpMenu:SetPos(0, 0)
		HelpMenu:MakePopup()
		HelpMenu:SetAlpha(0)
		HelpMenu:AlphaTo(255, 0.2, 0)
		HelpMenu.Paint = function(self, w, h)
			mp.BlurBG(self, 1)

			mp.Icon(w / 2 - 256, h / 2 - 256, 512, 512, mp.Material.LOGO, C_W_100)

			draw.RoundedBox(0, 0, 0, w, h, color_background)

			--draw.RoundedBox(0, 0, 0, w, 64, color_title)
			--draw.RoundedBox(0, 0, h - 64, w, 64, color_bottom)

			draw.RoundedBox(0, 0, 0, w, 64, color_title)
			draw.RoundedBox(0, 0, h - 64, w, 64, color_title)

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, 64, 1)
			surface.DrawOutlinedRect(0, h - 64, w, 64, 1)

			draw.SimpleText(title_text, title_font, 25, 32, mp.Color.WHITE, 0, 1)
			draw.SimpleText(welcome_text .. ply:Name(), welcome_font, w - 25, h - 32, color_panel, 2, 1)

			local current_balance = GetPlayerBalance()
			local balance_display = balance_text .. FormatBalance(current_balance)

			surface.SetFont(welcome_font)
			balance_w = surface.GetTextSize(balance_display)
			draw.SimpleText(balance_display, welcome_font, 25, h - 32, color_panel, 0, 1)
		end

		local Dealy = CurTime() + 0.8
		HelpMenu.Think = function(self, w, h)
			if input.IsKeyDown(KEY_F6) and Dealy < CurTime() then
				if IsValid(self) then
					self:AlphaTo(0, 0.2, 0, function()
						self:Remove()
					end)

					Dealy = CurTime() + 0.8

					surface.PlaySound(mp.Sound.ROLLUP_2)
				end
			end

			if IsValid(self) and not ply:Alive() then
				self:AlphaTo(0, 0.2, 0, function()
					self:Remove()
				end)

				Dealy = CurTime() + 0.8

				surface.PlaySound(mp.Sound.ROLLUP_2)
			end
		end

		local TopPanel = vgui.Create("Panel", HelpMenu)
		TopPanel:Dock(TOP)
		TopPanel:SetTall(64)
		TopPanel:DockMargin(250, 0, 15, 0)

		local BottomPanel = vgui.Create("Panel", HelpMenu)
		BottomPanel:Dock(BOTTOM)
		BottomPanel:SetTall(64)
		BottomPanel:DockMargin(0, 0, 0, 0)

		local BuyBtn = vgui.Create("DButton", BottomPanel)
		BuyBtn:SetPos(0, 0)
		BuyBtn:SetSize(150, 45)
		BuyBtn:SetText("Пополнить счёт")
		BuyBtn:SetTextColor(Color(0, 0, 0, 0))
		BuyBtn.Hover = 0
		BuyBtn.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_panel, self.Hover))

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			draw.SimpleText(self:GetText(), cat_font, w / 2, h / 2, ColorAlpha(color_text, 255 - self.Hover), 1,
				1)
			draw.SimpleText(self:GetText(), cat_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
		end

		function BuyBtn:Think()
			self:SetPos(50 + balance_w, 10)
		end

		BuyBtn.DoClick = function(self)
			IGS.WIN.Deposit()
		end

		local AddPromo = vgui.Create("Panel", BottomPanel)
		AddPromo:SetPos(0, 0)
		AddPromo:SetSize(200, 45)
		AddPromo.Paint = function(self, w, h)
			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end

		function AddPromo:Think()
			self:SetPos(60 + balance_w + BuyBtn:GetWide(), 10)
		end

		local code = vgui.Create("DTextEntry", AddPromo)
		code:Dock(FILL)
		code:DockMargin(5, 5, 5, 5)
		code:SetFont(search_font)
		code:SetValue("введите промокод")
		code:SetDrawLanguageID(false)
		code.Paint = function(self, w, h)
			--self:SetValue(pl:Name())
			--draw.RoundedBox(0, 0, 0, w, h, C_B_100)
			self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
		end

		function code:OnMousePressed()
			self:SetText("")
		end

		local ActivatePromo = vgui.Create("DButton", BottomPanel)
		ActivatePromo:SetPos(0, 0)
		ActivatePromo:SetSize(150, 45)
		ActivatePromo:SetText("Активировать")
		ActivatePromo:SetTextColor(Color(0, 0, 0, 0))
		ActivatePromo.Hover = 0
		ActivatePromo.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_panel, self.Hover))

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			draw.SimpleText(self:GetText(), cat_font, w / 2, h / 2, ColorAlpha(color_text, 255 - self.Hover), 1,
				1)
			draw.SimpleText(self:GetText(), cat_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
		end

		function ActivatePromo:Think()
			self:SetPos(AddPromo:GetX() + AddPromo:GetWide() + 10, 10)
		end

		ActivatePromo.DoClick = function(self)
			net.Start("mp.donate.SendPromo")
			net.WriteString(code:GetValue())
			net.SendToServer()

			CREATE_DONATE:AlphaTo(0, 0.2, 0)
			CREATE_DONATE:MoveTo(scrw * .5 - CREATE_DONATE:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
				CREATE_DONATE:Remove()
				CREATE_DONATE = nil
			end)

			surface.PlaySound(mp.Sound.CLICK_10)
		end

		local ClosePanel = vgui.Create("DButton", CREATE_DONATE)
		ClosePanel:SetSize(20, 20)
		ClosePanel:SetText("")
		ClosePanel.Hover = 0
		ClosePanel:SetPos(CREATE_DONATE:GetWide() - ClosePanel:GetWide() - 20, 22)
		ClosePanel.Paint = function(self, w, h)
			if self:IsHovered() then
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 100)
			end

			mp.Icon(0, 0, 20, 20, mp.Material.CLOSE, ColorAlpha(mp.Color.WHITE, self.Hover))
		end

		ClosePanel.OnCursorEntered = function()
			surface.PlaySound(mp.Sound.CLICK)
		end

		ClosePanel.DoClick = function(self)
			CREATE_DONATE:AlphaTo(0, 0.2, 0)
			CREATE_DONATE:MoveTo(scrw * .5 - CREATE_DONATE:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
				CREATE_DONATE:Remove()
				CREATE_DONATE = nil
			end)

			surface.PlaySound(mp.Sound.CLICK_10)
		end

		local Scroll = vgui.Create("DScrollPanel", HelpMenu)
		Scroll:Dock(FILL)
		Scroll:DockMargin(0, 0, 0, 0)
		Scroll.Hover = 0
		Scroll.VBar:SetWide(5)
		Scroll.Paint = function(self, w, h)
			local x, y = self:LocalCursorPos()
			local w, h = self:GetWide(), self:GetTall()

			if x < w and x > 0 and y < h and y > 0 then
				self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
			else
				self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
			end

			self.VBar:SetAlpha(self.Hover)
		end
		local sbar = Scroll:GetVBar()
		sbar:SetHideButtons(true)
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_background)
		end

		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_title)

			mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, color_text)
		end

		local sortCategory = { "Все предметы", "Оружие", "Подразделения", "Привилегии" }
		local category = {}
		category["Все предметы"] = {}
		for k, v in ipairs(IGS.GetItems()) do
			if not v.category then continue end

			category[v.category] = category[v.category] or {}

			table.insert(category[v.category], v)
			table.insert(category["Все предметы"], v)
		end

		for _, name in ipairs(sortCategory) do
			local tbl = category[name]

			surface.SetFont(goback_font)
			local x, y = surface.GetTextSize(name)

			local CatButton = vgui.Create("DButton", TopPanel)
			CatButton:Dock(LEFT)
			CatButton:SetWide(x + 10)
			CatButton:SetText("")
			CatButton:DockMargin(0, 5, 5, 5)
			CatButton.Hover = 0
			CatButton.Paint = function(self, w, h)
				if HoverCat == name then
					self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
				elseif self:IsHovered() then
					self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
				else
					self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
				end

				draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_panel, self.Hover))

				surface.SetDrawColor(ColorOutline)
				surface.DrawOutlinedRect(0, 0, w, h, 1)

				draw.SimpleText(name, cat_font, w / 2, h / 2, ColorAlpha(color_text, 255 - self.Hover), 1, 1)
				draw.SimpleText(name, cat_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE_TO, self.Hover), 1, 1)
			end

			CatButton.DoClick = function(self)
				HoverCat = name

				if tbl then
					CreatPanel(Scroll, tbl)
				end
			end
		end

		if HoverCat and category[HoverCat] then
			CreatPanel(Scroll, category[HoverCat])
		end
	end)
end
concommand.Add("mp.CreateDonateMenu", CreateDonateMenu)

local CreateDonate = 0
hook.Add("Think", "mp.CreateDonate", function()
	if input.IsKeyDown(KEY_F6) and CreateDonate < CurTime() and not IsValid(CREATE_DONATE) then
		RunConsoleCommand("mp.CreateDonateMenu")

		CreateDonate = CurTime() + 1.2
	end
end)
