local mp = mp
function PLAYER:CanUseWhitelist()
    local whitelist = self:GetFaction() and mp.faction[self:GetFaction()] and mp.faction[self:GetFaction()].whitelist and
        mp.faction[self:GetFaction()].whitelist[self:Team()] or false

    return mp.config.whitelist[self:GetUserGroup()] or (whitelist and whitelist.open_menu)
end

function PLAYER:CanGiveTeam(tm)
    if not self:CanUseWhitelist() and not self:IsAdmin() then
        return false
    end

    if mp.config.whitelist[self:GetUserGroup()] then
        return true
    end

    local whitelist = self:GetFaction() and mp.faction[self:GetFaction()] and mp.faction[self:GetFaction()].whitelist and
        mp.faction[self:GetFaction()].whitelist[self:Team()] or false

    if not whitelist or not whitelist.jobs or not whitelist.jobs[tm] then
        return false
    end

    return true
end

if not CLIENT then return end

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
local list_font = mp.font("16:DIN Pro Regular")
local button_font = mp.font("20:Futura PT Medium")
local info_fonts = mp.font("18:DIN Pro Regular")
local name_font = mp.font("25:Futura PT Light")
local choose_font = mp.font("20:mr_ApexMk3MediumG")
local frags_font = mp.font("20:mr_ApexMk3ExtraLightG")
local name_server_font = mp.font("70:Futura PT Light")
local time_font = mp.font("25:Futura PT Light")

function mp.TeamsMenu(pl)
    if not pl then return end
    if not LocalPlayer():CanUseWhitelist() then return end

    if IsValid(TEAMS_PANEL) then
        TEAMS_PANEL:AlphaTo(0, 0.1, 0, function()
            TEAMS_PANEL:Remove()
            TEAMS_PANEL = nil
        end)

        surface.PlaySound(mp.Sound.DEPLOY_2)
    end

    surface.PlaySound(mp.Sound.DEPLOY)

    local scrw, scrh = ScrW(), ScrH()
    local name = pl:Name()
    local timeJob = 0

    local addrank, getrank

    local TeamsPanel = vgui.Create("EditablePanel")
    TEAMS_PANEL = TeamsPanel
    TEAMS_PANEL:SetSize(840, 540)
    TEAMS_PANEL:SetPos(scrw * .5 - TEAMS_PANEL:GetWide() / 2, scrh / 2)
    TEAMS_PANEL:MoveTo(scrw * .5 - TEAMS_PANEL:GetWide() / 2, scrh * .5 - TEAMS_PANEL:GetTall() / 2, 0.5, 0.1, 0.1)
    TEAMS_PANEL:MakePopup()
    TEAMS_PANEL:SetAlpha(0)
    TEAMS_PANEL:AlphaTo(255, 0.3, 0.1)
    TEAMS_PANEL.Paint = function(self, w, h)
        mp.PanelBlur(self, 4)

        draw.RoundedBox(0, 0, 0, w, h, C_B_200)
        draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

        mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
        mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
        mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

        mp.Text(title_text .. name, search_font, w / 2, 20, mp.Color.BASE, 1, 1)
    end

    local ClosePanel = vgui.Create("DButton", TEAMS_PANEL)
    CLOSE_PANEL = ClosePanel
    CLOSE_PANEL:SetSize(20, 20)
    CLOSE_PANEL:SetText("")
    CLOSE_PANEL.Hover = 0
    CLOSE_PANEL:SetPos(TEAMS_PANEL:GetWide() - CLOSE_PANEL:GetWide() - 15, 10)
    CLOSE_PANEL.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 75)
        end

        mp.Icon(0, 0, 20, 20, mp.Material.CLOSE, ColorAlpha(mp.Color.BASE, self.Hover))
    end

    CLOSE_PANEL.OnCursorEntered = function()
        surface.PlaySound(mp.Sound.CLICK)
    end

    CLOSE_PANEL.DoClick = function(self)
        TEAMS_PANEL:AlphaTo(0, 0.2, 0)
        TEAMS_PANEL:MoveTo(scrw * .5 - TEAMS_PANEL:GetWide() / 2, scrh / 2, 0.1, 0.1, 0.9, function()
            TEAMS_PANEL:Remove()
            TEAMS_PANEL = nil
        end)

        surface.PlaySound(mp.Sound.CLICK_10)
    end

    local ChooseModel = vgui.Create("DModelPanel", TEAMS_PANEL)
    ChooseModel:Dock(LEFT)
    ChooseModel:SetWide(TEAMS_PANEL:GetWide() / 2.2)
    ChooseModel:SetFOV(22)
    ChooseModel:SetModel(pl:GetModel())
    ChooseModel:DockMargin(0, 40, 0, 0)
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
        ent:SetPos(Vector(0, 0, -12))

        if ent:GetModel() ~= pl:GetModel() then
            self:SetModel(pl:GetModel())
        end
    end

    local infoPanel = vgui.Create("DScrollPanel", TEAMS_PANEL)
    infoPanel:Dock(FILL)
    infoPanel:DockMargin(0, 40, 10, 10)
    infoPanel.Hover = 0
    infoPanel.VBar:SetWide(5)
    infoPanel.Paint = function(self, w, h)
        local x, y = self:LocalCursorPos()
        local w, h = self:GetWide(), self:GetTall()

        if x < w and x > 0 and y < h and y > 0 then
            self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
        end

        self.VBar:SetAlpha(self.Hover)
    end
    local sbar = infoPanel:GetVBar()
    sbar:SetHideButtons(true)

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, C_B_100)
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
    end

    TEAMS_PANEL.CreateInfo = function()
        infoPanel:Clear()
        infoPanel:SetAlpha(0)
        infoPanel:AlphaTo(255, 0.2, 0)

        local titleId = vgui.Create("DLabel", infoPanel)
        titleId:Dock(TOP)
        titleId:SetSize(0, 28)
        titleId:DockMargin(0, 0, 5, 0)
        titleId:SetText("Номер ID:")
        titleId:SetFont(info_fonts)
        titleId:SetColor(mp.Color.WHITE)

        local _id = vgui.Create("DTextEntry", infoPanel)
        _id:Dock(TOP)
        _id:SetSize(0, 24)
        _id:DockMargin(0, 0, 5, 0)
        _id:SetFont(search_font)
        _id:SetValue(pl:GetRPID())
        _id:SetEditable(false)
        _id.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
        end

        local titleName = vgui.Create("DLabel", infoPanel)
        titleName:Dock(TOP)
        titleName:SetSize(0, 28)
        titleName:DockMargin(0, 0, 5, 0)
        titleName:SetText("Фамилия:")
        titleName:SetFont(info_fonts)
        titleName:SetColor(mp.Color.WHITE)

        local _name = vgui.Create("DTextEntry", infoPanel)
        _name:Dock(TOP)
        _name:SetSize(0, 24)
        _name:DockMargin(0, 0, 5, 0)
        _name:SetFont(search_font)
        _name:SetValue(pl:Name())
        _name:SetEditable(false)
        _name.Paint = function(self, w, h)
            self:SetValue(pl:Name())
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
        end

        local SetName = vgui.Create("DButton", infoPanel)
        SetName:Dock(TOP)
        SetName:SetSize(0, 32)
        SetName:DockMargin(0, 5, TEAMS_PANEL:GetWide() / 3.5, 0)
        SetName:SetText("Изменить имя")
        SetName:SetColor(Color(0, 0, 0, 0))
        SetName.Hover = 0
        SetName.Paint = function(self, w, h)
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

        SetName.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        SetName.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)

            Derma_StringRequest(
                "Изменить имя",
                "Укажите новое имя для игрока " .. pl:Name(),
                "",
                function(text)
                    if not text then return end

                    RunConsoleCommand("mp", "name", pl:SteamID(), text)
                end,
                function(text) end
            )
        end

        local titileJob = vgui.Create("DLabel", infoPanel)
        titileJob:Dock(TOP)
        titileJob:SetSize(0, 28)
        titileJob:DockMargin(0, 0, 5, 0)
        titileJob:SetText("Профессия:")
        titileJob:SetFont(info_fonts)
        titileJob:SetColor(mp.Color.WHITE)

        local jPanel = vgui.Create("DComboBox", infoPanel)
        jPanel:SetAutoStretchVertical(false)
        jPanel:SetSortItems(false)
        jPanel:Dock(TOP)
        jPanel:SetSize(0, 24)
        jPanel:DockMargin(0, 0, 5, 0)
        jPanel:SetTextColor(mp.Color.WHITE)
        jPanel:SetTextColor(Color(0, 0, 0, 0))

        local indexData = {}
        for _, r in ipairs(mp.jobs) do
            local index = jPanel:AddChoice(r.Name)
            indexData[index] = _
        end

        jPanel:SetValue(pl:GetJobName())

        jPanel.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        local selectJob

        jPanel.OnSelect = function(panel, index, value)
            selectJob = indexData[index]
        end

        jPanel.Hover = 0
        jPanel.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 1, w, h - 2, C_B_100)
            draw.RoundedBox(0, 0, 1, w, h - 2, ColorAlpha(mp.Color.BASE, self.Hover))

            mp.Text(self:GetText(), list_font, math.Round(self.Hover / 25 + 5), h / 2,
                self:IsHovered() and mp.Color.BASE_TO or mp.Color.BASE, 0, 1)
            mp.Text("⯆", list_font, w - 5, h / 2, self:IsHovered() and mp.Color.BASE_TO or mp.Color.WHITE, 2, 1)
        end
        jPanel.DoClick = function(self)
            if (self:IsMenuOpen()) then
                return self:CloseMenu()
            end

            self:OpenMenu()

            self.Menu.Paint = function(panel, w, h) end

            for i = 1, self.Menu:ChildCount() do
                local pnl = self.Menu:GetChild(i)
                pnl:SetAlpha(0)
                pnl:AlphaTo(255, 0.3, 0.1)
                pnl.Hover = 0
                pnl.Paint = function(self, w, h)
                    if self:IsHovered() then
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                    else
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                    end

                    draw.RoundedBox(0, 0, 1, w, h - 2, color_black)
                    draw.RoundedBox(0, 0, 1, w, h - 2, ColorAlpha(mp.Color.BASE, self.Hover))

                    mp.Text(self:GetText(), list_font, math.Round(self.Hover / 25 + 5), h / 2,
                        self:IsHovered() and mp.Color.BASE_TO or mp.Color.WHITE, 0, 1)
                end

                pnl.OnCursorEntered = function()
                    surface.PlaySound(mp.Sound.HOVER)
                end

                pnl:SetTextColor(Color(0, 0, 0, 0))
            end

            surface.PlaySound(mp.Sound.CLICK_7)
        end

        jPanel.DropButton:SetText("")
        jPanel.DropButton.Paint = function(panel, w, h) end

        local SetJob = vgui.Create("DButton", infoPanel)
        SetJob:Dock(TOP)
        SetJob:SetSize(0, 32)
        SetJob:DockMargin(0, 5, TEAMS_PANEL:GetWide() / 3.5, 0)
        SetJob:SetText("Изменить профессию")
        SetJob:SetColor(Color(0, 0, 0, 0))
        SetJob.Hover = 0
        SetJob.Paint = function(self, w, h)
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

        SetJob.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        SetJob.DoClick = function(self)
            if not selectJob or selectJob == pl:Team() then return end

            surface.PlaySound(mp.Sound.CLICK_2)

            net.Start("mp.whitelist.job")
            net.WriteEntity(pl)
            net.WriteUInt(selectJob, 8)
            net.WriteUInt(timeJob or 0, 32)
            net.SendToServer()
        end

        if pl:GetNetVar("meta_rank") and pl:GetFaction() and mp.faction[pl:GetFaction()] and mp.faction[pl:GetFaction()].ranks then
            local tRank = vgui.Create("DLabel", infoPanel)
            tRank:Dock(TOP)
            tRank:SetSize(0, 28)
            tRank:DockMargin(0, 0, 5, 0)
            tRank:SetText("Звание:")
            tRank:SetFont(info_fonts)
            tRank:SetColor(mp.Color.WHITE)

            function tRank:Think()
                if addrank and getrank and addrank ~= getrank then
                    self:SetText("Звание:" .. (addrank > getrank and " повышение звания" or " понижения звания"))
                else
                    self:SetText("Звание:")
                end
            end

            local rPanel = vgui.Create("DComboBox", infoPanel)
            rPanel:SetAutoStretchVertical(false)
            rPanel:SetSortItems(false)
            rPanel:Dock(TOP)
            rPanel:SetSize(0, 24)
            rPanel:DockMargin(0, 0, 5, 0)
            rPanel:SetTextColor(mp.Color.WHITE)
            rPanel:SetTextColor(Color(0, 0, 0, 0))

            local selectRank
            local indexData = {}
            for _, r in ipairs(mp.faction[pl:GetFaction()].ranks) do
                local index = rPanel:AddChoice(r.name)
                indexData[index] = _

                if r.name == pl:GetNetVar("meta_rank") then
                    getrank = _
                end
            end

            rPanel:SetValue(pl:GetNetVar("meta_rank"))

            rPanel.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            rPanel.OnSelect = function(panel, index, value)
                --refact_model(tonumber(LIST_P_TEAMS:GetSelected()[1]:GetColumnText(1)), rPanel:GetValue())
                addrank = index
                selectRank = indexData[index]
            end

            rPanel.Hover = 0
            rPanel.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 1, w, h - 2, C_B_100)
                draw.RoundedBox(0, 0, 1, w, h - 2, ColorAlpha(mp.Color.BASE, self.Hover))

                mp.Text(self:GetText(), list_font, math.Round(self.Hover / 25 + 5), h / 2,
                    self:IsHovered() and mp.Color.BASE_TO or mp.Color.BASE, 0, 1)
                mp.Text("⯆", list_font, w - 5, h / 2, self:IsHovered() and mp.Color.BASE_TO or mp.Color.WHITE, 2, 1)
            end
            rPanel.DoClick = function(self)
                if (self:IsMenuOpen()) then
                    return self:CloseMenu()
                end

                self:OpenMenu()

                self.Menu.Paint = function(panel, w, h) end

                for i = 1, self.Menu:ChildCount() do
                    local pnl = self.Menu:GetChild(i)
                    pnl:SetAlpha(0)
                    pnl:AlphaTo(255, 0.3, 0.1)
                    pnl.Hover = 0
                    pnl.Paint = function(self, w, h)
                        if self:IsHovered() then
                            self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                        else
                            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                        end

                        draw.RoundedBox(0, 0, 1, w, h - 2, color_black)
                        draw.RoundedBox(0, 0, 1, w, h - 2, ColorAlpha(mp.Color.BASE, self.Hover))

                        mp.Text(self:GetText(), list_font, math.Round(self.Hover / 25 + 5), h / 2,
                            self:IsHovered() and mp.Color.BASE_TO or mp.Color.WHITE, 0, 1)
                    end

                    pnl.OnCursorEntered = function()
                        surface.PlaySound(mp.Sound.HOVER)
                    end

                    pnl:SetTextColor(Color(0, 0, 0, 0))
                end

                surface.PlaySound(mp.Sound.CLICK_7)
            end

            rPanel.DropButton:SetText("")
            rPanel.DropButton.Paint = function(panel, w, h) end

            local SetRank = vgui.Create("DButton", infoPanel)
            SetRank:Dock(TOP)
            SetRank:SetSize(0, 32)
            SetRank:DockMargin(0, 5, TEAMS_PANEL:GetWide() / 3.5, 0)
            SetRank:SetText("Изменить звание")
            SetRank:SetColor(Color(0, 0, 0, 0))
            SetRank.Hover = 0
            SetRank.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

                surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
                surface.DrawOutlinedRect(0, 0, w, h, 1)

                draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1,
                    1)
                draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
            end

            SetRank.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            SetRank.DoClick = function(self)
                if not selectRank or selectRank == pl:GetNetVar("meta_rank") then return end
                surface.PlaySound(mp.Sound.CLICK_2)

                net.Start("mp.whitelist.rank")
                net.WriteEntity(pl)
                net.WriteUInt(selectRank, 8)
                net.WriteUInt(timeJob or 0, 32)
                net.SendToServer()
            end
        end

        if pl:GetFaction() and mp.faction[pl:GetFaction()] and mp.faction[pl:GetFaction()].profession then
            local titleProfession = vgui.Create("DLabel", infoPanel)
            titleProfession:Dock(TOP)
            titleProfession:SetSize(0, 28)
            titleProfession:DockMargin(0, 0, 5, 0)
            titleProfession:SetText("Специальность:")
            titleProfession:SetFont(info_fonts)
            titleProfession:SetColor(mp.Color.WHITE)

            local pPanel = vgui.Create("DComboBox", infoPanel)
            pPanel:SetAutoStretchVertical(false)
            pPanel:SetSortItems(false)
            pPanel:Dock(TOP)
            pPanel:SetSize(0, 24)
            pPanel:DockMargin(0, 0, 5, 0)
            pPanel:SetTextColor(mp.Color.WHITE)
            pPanel:SetTextColor(Color(0, 0, 0, 0))

            local indexData = {}
            local selectProfession
            for _, r in SortedPairs(mp.faction[pl:GetFaction()].profession) do
                local index = pPanel:AddChoice(r.name)
                indexData[index] = _
            end

            pPanel:SetValue(pl:FeatureName())

            pPanel.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            pPanel.OnSelect = function(panel, index, value)
                selectProfession = indexData[index]
            end

            pPanel.Hover = 0
            pPanel.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 1, w, h - 2, C_B_100)
                draw.RoundedBox(0, 0, 1, w, h - 2, ColorAlpha(mp.Color.BASE, self.Hover))

                mp.Text(self:GetText(), list_font, math.Round(self.Hover / 25 + 5), h / 2,
                    self:IsHovered() and mp.Color.BASE_TO or mp.Color.BASE, 0, 1)
                mp.Text("⯆", list_font, w - 5, h / 2, self:IsHovered() and mp.Color.BASE_TO or mp.Color.WHITE, 2, 1)
            end
            pPanel.DoClick = function(self)
                if (self:IsMenuOpen()) then
                    return self:CloseMenu()
                end

                self:OpenMenu()

                self.Menu.Paint = function(panel, w, h) end

                for i = 1, self.Menu:ChildCount() do
                    local pnl = self.Menu:GetChild(i)
                    pnl:SetAlpha(0)
                    pnl:AlphaTo(255, 0.3, 0.1)
                    pnl.Hover = 0
                    pnl.Paint = function(self, w, h)
                        if self:IsHovered() then
                            self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                        else
                            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                        end

                        draw.RoundedBox(0, 0, 1, w, h - 2, color_black)
                        draw.RoundedBox(0, 0, 1, w, h - 2, ColorAlpha(mp.Color.BASE, self.Hover))

                        mp.Text(self:GetText(), list_font, math.Round(self.Hover / 25 + 5), h / 2,
                            self:IsHovered() and mp.Color.BASE_TO or mp.Color.WHITE, 0, 1)
                    end

                    pnl.OnCursorEntered = function()
                        surface.PlaySound(mp.Sound.HOVER)
                    end

                    pnl:SetTextColor(Color(0, 0, 0, 0))
                end

                surface.PlaySound(mp.Sound.CLICK_7)
            end

            pPanel.DropButton:SetText("")
            pPanel.DropButton.Paint = function(panel, w, h) end

            local SetProfession = vgui.Create("DButton", infoPanel)
            SetProfession:Dock(TOP)
            SetProfession:SetSize(0, 32)
            SetProfession:DockMargin(0, 5, TEAMS_PANEL:GetWide() / 3.5, 0)
            SetProfession:SetText("Изменить специальность")
            SetProfession:SetColor(Color(0, 0, 0, 0))
            SetProfession.Hover = 0
            SetProfession.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

                surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
                surface.DrawOutlinedRect(0, 0, w, h, 1)

                draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1,
                    1)
                draw.SimpleText(self:GetText(), info_fonts, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
            end

            SetProfession.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            SetProfession.DoClick = function(self)
                if not selectProfession or selectProfession == pl:GetNetVar("meta_features") then return end
                surface.PlaySound(mp.Sound.CLICK_2)
                net.Start("mp.whitelist.profession")
                net.WriteEntity(pl)
                net.WriteString(selectProfession)
                net.WriteUInt(timeJob or 0, 32)
                net.SendToServer()
            end
        end

        local titileModel = vgui.Create("DLabel", infoPanel)
        titileModel:Dock(TOP)
        titileModel:SetSize(0, 28)
        titileModel:DockMargin(0, 0, 5, 0)
        titileModel:SetText("Игровая модель:")
        titileModel:SetFont(info_fonts)
        titileModel:SetColor(mp.Color.WHITE)

        local List = infoPanel:Add("DIconLayout")
        List:Dock(TOP)
        List:SetSpaceY(5)
        List:SetSpaceX(5)
        List:DockMargin(0, 5, 5, 0)

        local models = pl:GetJobModel()

        if not istable(models) then
            models = { models }
        end

        local mdlT
        if pl:GetNetVar("meta_features") and mp.profession[pl:GetNetVar("meta_features")] then
            mdlT = mp.profession[pl:GetNetVar("meta_features")].model
            if mdlT then
                if not istable(mdlT) then
                    mdlT = { mdlT }
                end
            end
        end

        if mdlT then
            table.Add(models, mdlT)
        end

        local selected_model = pl:GetModel()
        for k, v in ipairs(models) do
            local listModel = List:Add("Panel")
            listModel:SetSize(64, 64)

            local mdl = vgui.Create('ModelImage', listModel)
            mdl:Dock(FILL)
            mdl:DockMargin(5, 5, 5, 5)
            mdl:SetModel(v)

            local selectModel = vgui.Create("DButton", listModel)
            selectModel:SetSize(64, 64)
            selectModel:SetText("")
            selectModel.Hover = 0
            selectModel.Paint = function(self, w, h)
                if self:IsHovered() or (selected_model and selected_model == v) then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 50))

                surface.SetDrawColor(ColorAlpha(
                    selected_model and selected_model == v and mp.Color.WHITE or mp.Color.BASE,
                    self.Hover))
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end

            selectModel.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            selectModel.DoClick = function(self)
                surface.PlaySound(mp.Sound.CLICK_2)
                selected_model = v
            end
        end

        local SetModel = vgui.Create("DButton", infoPanel)
        SetModel:Dock(TOP)
        SetModel:SetSize(0, 32)
        SetModel:DockMargin(0, 5, TEAMS_PANEL:GetWide() / 3.5, 0)
        SetModel:SetText("Изменить модель")
        SetModel:SetColor(Color(0, 0, 0, 0))
        SetModel.Hover = 0
        SetModel.Paint = function(self, w, h)
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

        SetModel.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        SetModel.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)
            net.Start("mp.whitelist.model")
            net.WriteEntity(pl)
            net.WriteString(selected_model)
            net.SendToServer()
        end

        local titleAccess = vgui.Create("DLabel", infoPanel)
        titleAccess:Dock(TOP)
        titleAccess:SetSize(0, 28)
        titleAccess:DockMargin(0, 0, 5, 0)
        titleAccess:SetText("Список разрешений:")
        titleAccess:SetFont(info_fonts)
        titleAccess:SetColor(mp.Color.WHITE)

        local accessPanel = vgui.Create("DScrollPanel", infoPanel)
        accessPanel:Dock(TOP)
        accessPanel:SetTall(200)
        accessPanel:DockMargin(0, 5, 5, 0)
        accessPanel.Hover = 0
        accessPanel.VBar:SetWide(5)
        accessPanel.Paint = function(self, w, h)
            local x, y = self:LocalCursorPos()
            local w, h = self:GetWide(), self:GetTall()

            if x < w and x > 0 and y < h and y > 0 then
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end

            self.VBar:SetAlpha(self.Hover)

            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
        end
        local sbar = accessPanel:GetVBar()
        sbar:SetHideButtons(true)

        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
        end

        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
        end

        local list_access = {}
        local pl_access = pl:GetAccessTeam()

        for k, v in pairs(mp.config.access_list) do
            list_access[k] = pl_access[k] or false
            local accessItem = vgui.Create("DButton", accessPanel)
            accessItem:Dock(TOP)
            accessItem:SetSize(0, 24)
            accessItem:DockMargin(5, 5, 5, 0)
            accessItem:SetText(v.name)
            accessItem:SetColor(Color(0, 0, 0, 0))
            accessItem.Hover = 0
            accessItem.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

                surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
                surface.DrawOutlinedRect(0, 0, w, h, 1)

                surface.SetDrawColor(C_W_100)
                surface.DrawOutlinedRect(4, 4, h - 8, h - 8, 1)

                if list_access[k] then
                    draw.RoundedBox(0, 6, 6, h - 12, h - 12, C_W_200)
                end

                draw.SimpleText(self:GetText(), list_font, h + 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 0,
                    1)
                draw.SimpleText(self:GetText(), list_font, h + 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 0, 1)
            end

            accessItem.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            accessItem.DoClick = function(self)
                surface.PlaySound(mp.Sound.CLICK_2)

                list_access[k] = ! list_access[k]
            end
        end

        local SetAccess = vgui.Create("DButton", infoPanel)
        SetAccess:Dock(TOP)
        SetAccess:SetSize(0, 32)
        SetAccess:DockMargin(0, 5, TEAMS_PANEL:GetWide() / 3.5, 0)
        SetAccess:SetText("Изменить разрешения")
        SetAccess:SetColor(Color(0, 0, 0, 0))
        SetAccess.Hover = 0
        SetAccess.Paint = function(self, w, h)
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

        SetAccess.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        SetAccess.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)

            net.Start("mp.whitelist.access")
            net.WriteEntity(pl)
            net.WriteTable(list_access)
            net.SendToServer()
        end

        local checkTime = vgui.Create("DButton", infoPanel)
        checkTime:Dock(TOP)
        checkTime:SetSize(0, 32)
        checkTime:DockMargin(0, 10, TEAMS_PANEL:GetWide() / 3.2, 0)
        checkTime:SetText("Временно")
        checkTime:SetColor(Color(0, 0, 0, 0))
        checkTime.Hover = 0
        checkTime.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

            surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            surface.SetDrawColor(C_W_100)
            surface.DrawOutlinedRect(5, 5, h - 10, h - 10, 1)

            if timeJob > 0 then
                draw.RoundedBox(0, 8, 8, h - 16, h - 16, C_W_200)
            end

            draw.SimpleText((timeJob > 0 and self:GetText() .. ": " .. timeJob .. " мин." or self:GetText()), list_font,
                h + 2, h / 2,
                ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 0,
                1)
            draw.SimpleText((timeJob > 0 and self:GetText() .. ": " .. timeJob .. " мин." or self:GetText()), list_font,
                h + 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 0, 1)
        end

        checkTime.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        checkTime.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)

            Derma_StringRequest(
                "Временные изменения",
                "Если хотите удалить, чтобы последующие изменения возвращались к исходным, укажите время в минутах или введи 0, чтобы отключить.",
                "",
                function(text)
                    local time = tonumber(text) or 0

                    timeJob = time
                end,
                function(text) end
            )
        end
    end

    TEAMS_PANEL.CreateInfo()
end

net.Receive("mp.whitelist.update_menu", function()
    if IsValid(TEAMS_PANEL) then
        TEAMS_PANEL.CreateInfo()
    end
end)
