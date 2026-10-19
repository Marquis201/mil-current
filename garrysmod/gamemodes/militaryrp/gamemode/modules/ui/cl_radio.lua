local owner_text = "Руководитель"
local chanel_text = "Канал: "
local online_text = "Онлайн: "
local setchanel_text = "➤"

local mp = mp
local ColorAlpha = ColorAlpha
local Color = Color
local vgui = vgui
local draw = draw
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime

local name_font = mp.font("20:DIN Pro Regular")
local status_font = mp.font("18:Montserrat Light")
local chanel_font = mp.font("18:DIN Pro Regular")

local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)
local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_W_15 = ColorAlpha(mp.Color.WHITE, 15)
local C_BS_25 = ColorAlpha(mp.Color.BASE, 15)
local C_BS_10 = ColorAlpha(mp.Color.BASE, 15)


local function RadioMenu()
    if not LocalPlayer():Alive() then return end

    local scrw, scrh = ScrW(), ScrH()
    local ply = LocalPlayer()
    local radio = ply:GetChanelRadio()
    local micro
    local speak
    local online = 0

    if IsValid(RADIO_PANEL) then
        RADIO_PANEL:AlphaTo(0, 0.1, 0, function()
            RADIO_PANEL:Remove()
        end)

        surface.PlaySound(mp.Sound.DEPLOY_2)

        return false
    end

    surface.PlaySound(mp.Sound.DEPLOY)

    local RadioPanel = vgui.Create("EditablePanel")
    RADIO_PANEL = RadioPanel
    RADIO_PANEL:SetSize(240, 240)
    RADIO_PANEL:SetPos(-240, scrh / 3)
    RADIO_PANEL:MoveTo(10, scrh / 3, 0.5, 0.1, 0.2)
    RADIO_PANEL:MakePopup()
    RADIO_PANEL:SetAlpha(0)
    RADIO_PANEL:AlphaTo(255, 0.3, 0.1)
    RADIO_PANEL.Paint = function(self, w, h)
        mp.PanelBlur(self, 1)

        draw.RoundedBox(0, 0, 0, w, h, C_B_200)
    end

    RADIO_PANEL.Think = function(self, w, h)
        if IsValid(RADIO_PANEL) and not ply:Alive() then
            RADIO_PANEL:AlphaTo(0, 0.2, 0, function()
                RADIO_PANEL:Remove()
            end)

            surface.PlaySound(mp.Sound.DEPLOY_2)
        end
    end

    RADIO_PANEL.OnKeyCodePressed = function()
        if input.IsKeyDown(KEY_F2) then
            RADIO_PANEL:AlphaTo(0, 0.2, 0)
            RADIO_PANEL:MoveTo(-240, scrh / 3, 0.15, 0.1, 0.9, function()
                RADIO_PANEL:Remove()
                RADIO_PANEL = nil
            end)

            surface.PlaySound(mp.Sound.DEPLOY_2)
        end
    end

    local RadioScroll = vgui.Create("DScrollPanel", RADIO_PANEL)
    RADIO_SCROLL = RadioScroll
    RADIO_SCROLL:Dock(FILL)
    RADIO_SCROLL:DockMargin(5, 45, 2, 2)
    RADIO_SCROLL.Hover = 0
    RADIO_SCROLL.VBar:SetWide(5)
    RADIO_SCROLL.Paint = function(self, w, h)
        local x, y = self:LocalCursorPos()
        local w, h = self:GetWide(), self:GetTall()

        if x < w and x > 0 and y < h and y > 0 then
            self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
        end

        self.VBar:SetAlpha(self.Hover)
    end
    local sbar = RADIO_SCROLL:GetVBar()
    sbar:SetHideButtons(true)
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, C_B_100)
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
    end

    for k, v in pairs(player.GetAll()) do
        if radio ~= v:GetChanelRadio() then continue end
        if radio == 0 then continue end

        online = k

        local t = v:Team()
        local team_color = team.GetColor(t)
        local team_name = team.GetName(t)
        local name = v:Name()

        local C_T_20 = ColorAlpha(team_color, 20)

        if IsValid(v) then
            local RadioPlayer = vgui.Create("DLabel", RADIO_SCROLL)
            RADIO_PLAYER = RadioPlayer
            RADIO_PLAYER:Dock(TOP)
            RADIO_PLAYER:SetSize(0, 40)
            RADIO_PLAYER:DockMargin(0, 10, 5, -5)
            RADIO_PLAYER:SetText("")
            RADIO_PLAYER:IsVisible()
            RADIO_PLAYER.Hover = 0
            RADIO_PLAYER.Paint = function(self, w, h)
                local x, y = self:LocalCursorPos()

                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 50)
                else
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)

                if v ~= ply and ply:GetRadioOwner() then
                    mp.Icon(w / 2 - 10, h / 2 - 10, 20, 20, mp.Material.CLOSE, ColorAlpha(mp.Color.RED, self.Hover))
                end
                mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_T_20)

                if v:GetRadioOwner() then
                    mp.Text(name, name_font, 8, 2, team_color, 0, 0)
                    mp.Text(owner_text, status_font, 8, h / 2 + 8, mp.Color.WHITE, 8, 1)
                else
                    mp.Text(name, name_font, 8, h / 2, team_color, 0, 1)
                end

                if ! v:GetRadioMicro() then
                    micro = mp.Color.RED
                else
                    micro = mp.Color.WHITE
                end

                if ! v:GetRadioSpeak() then
                    speak = mp.Color.RED
                else
                    speak = mp.Color.WHITE
                end

                mp.Icon(w - 44, h / 2 - 8, 16, 16, mp.Material.SPEAK, ColorAlpha(speak, 150))
                mp.Icon(w - 24, h / 2 - 8, 16, 16, mp.Material.MICRO, ColorAlpha(micro, 150))
                mp.Icon(0, -1, w, h + 2, mp.Material.OUTLINE, C_W_15)
            end

            RADIO_PLAYER.Alpha = 0
            function RADIO_PLAYER:Think()
                local posx, posy = RADIO_SCROLL:GetChildPosition(self)

                if posy < -15 then
                    self.Alpha = Lerp(FrameTime() * 10, self.Alpha, 0)
                elseif posy > 165 then
                    self.Alpha = Lerp(FrameTime() * 10, self.Alpha, 0)
                else
                    self.Alpha = Lerp(FrameTime() * 10, self.Alpha, 255)
                end

                self:SetAlpha(self.Alpha)
            end

            RADIO_PLAYER.OnCursorEntered = function(self)
                surface.PlaySound(mp.Sound.HOVER_6)

                if ! ply:GetRadioOwner() then return end
                if v == ply then return end
                if not IsValid(v) then return end

                mp.ToolTip(self, "ПКМ: исключить", mp.Color.RED)
            end

            RADIO_PLAYER:SetMouseInputEnabled(true)

            function RADIO_PLAYER:DoClick()
                if ! ply:GetRadioOwner() then return end
                if v == ply then return end
                if not IsValid(v) then return end

                net.Start("mp.SetKickRadio")
                net.WriteEntity(v)
                net.SendToServer()

                surface.PlaySound(mp.Sound.CLICK_7)
            end
        end
    end

    local RadioHat = vgui.Create("DPanel", RADIO_PANEL)
    RADIO_HAT = RadioHat
    RADIO_HAT:SetSize(240, 60)
    RADIO_HAT:SetPos(0, 0)
    RADIO_HAT.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h - 10, mp.Color.BASE_TO)

        mp.Icon(0, h - 10, w, 10, mp.Material.GRADIENT_U, C_B_150)
        mp.Icon(0, 0, w, h - 10, mp.Material.GRADIENT_D, C_BS_25)
        mp.Icon(0, 0, w, h - 10, mp.Material.GRADIENT_L, C_BS_10)

        mp.Text(chanel_text .. radio, chanel_font, 8, 8, mp.Color.WHITE, 0, 0)
        mp.Text(online_text .. online, chanel_font, 8, 24, mp.Color.RADIO, 0, 0)
        mp.Text(setchanel_text, chanel_font, w / 1.5, h / 2 - 5, mp.Color.RADIO, 0, 1)
    end

    local RadioWang = vgui.Create("DNumberWang", RADIO_HAT)
    RADIO_WANG = RadioWang
    RADIO_WANG:SetSize(46, 30)
    RADIO_WANG:SetPos(RADIO_PANEL:GetWide() - 55, 10)
    RADIO_WANG:SetPaintBorderEnabled(true)
    RADIO_WANG:SetFont(mp.font("25:DIN Pro Regular"))
    RADIO_WANG:SetValue(0)
    RADIO_WANG:SetMax(999)
    RADIO_WANG:SetMin(0)
    RADIO_WANG:HideWang()

    --RADIO_WANG.OnCursorEntered = function(s)
    --    mp.ToolTip(s, "Укажите частоту (от 1 до 999, 0 - отключить)", mp.Color.BASE)
    --    surface.PlaySound(mp.Sound.HOVER)
    -- end

    RADIO_WANG.Paint = function(self, w, h)
        if self:GetValue() > 999 then
            self:SetValue(999)
        elseif self:GetValue() < 0 then
            self:SetValue(0)
        end

        surface.SetDrawColor(255, 168, 87, TimedCos(0.5, 100, -50, CurTime()))
        surface.DrawLine(0, h - 1, w, h - 1)

        self:DrawTextEntryText(mp.Color.WHITE, mp.Color.BASE_TO, mp.Color.WHITE)
    end

    local SaveRadio = vgui.Create("DButton", RADIO_HAT)
    SAVE_RADIO = SaveRadio
    SAVE_RADIO:SetSize(42, 42)
    SAVE_RADIO:SetText("")
    SAVE_RADIO:SetPos(RADIO_HAT:GetWide() / 2 - 21, 4)
    SAVE_RADIO.Color = 0
    SAVE_RADIO.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Color = Lerp(FrameTime() * 15, self.Color, 0)
        else
            self.Color = Lerp(FrameTime() * 15, self.Color, 255)
        end

        draw.RoundedBox(h / 2, 0, 0, w, h, ColorAlpha(mp.Color.BASE_TO, self.Color))
        draw.RoundedBox(h / 2, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, 255 - self.Color))

        mp.Icon(w / 2 - 16, h / 2 - 16, 32, 32, mp.Material.RADIO, ColorAlpha(mp.Color.WHITE, self.Color))
        mp.Icon(w / 2 - 16, h / 2 - 16, 32, 32, mp.Material.RADIO, ColorAlpha(mp.Color.BLACK, 255 - self.Color))
    end

    SAVE_RADIO.OnCursorEntered = function(s)
        mp.ToolTip(s, "Применить частоту", mp.Color.BASE)
        surface.PlaySound(mp.Sound.HOVER)
    end

    SAVE_RADIO.DoClick = function(self)
        local chanel = RADIO_WANG:GetValue()

        net.Start("mp.ChangeChannel")
        net.WriteEntity(ply)
        net.WriteInt(chanel, 11)
        net.SendToServer()

        surface.PlaySound(mp.Sound.CLICK_6)

        RadioMenu()
    end
end

net.Receive("mp.RadioMenu", function()
    RadioMenu()
end)

net.Receive("mp.DoChanel", function()
    local ply = net.ReadEntity()
    local chanel = net.ReadInt(11)
    local scrw, scrh = ScrW(), ScrH()
    local radio = ply:GetChanelRadio()
    local access = true
    local name = ply:GetName()

    local message_text = "Запрашивает связи"
    local enter_text = "Принять"
    local close_text = "Отказать"

    local name_font = mp.font("22:Montserrat Light")
    local text_font = mp.font("20:Montserrat Light")
    local button_font = mp.font("20:Futura PT Medium")

    local C_BS_15 = ColorAlpha(mp.Color.BASE, 15)
    local C_W_50 = ColorAlpha(mp.Color.WHITE, 50)
    local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
    local C_G_25 = ColorAlpha(mp.Color.GREEN, 25)
    local C_G_10 = ColorAlpha(mp.Color.GREEN, 10)
    local C_R_25 = ColorAlpha(mp.Color.RED, 25)
    local C_R_10 = ColorAlpha(mp.Color.RED, 10)

    if IsValid(RADIO_MESSAGE) then
        RADIO_MESSAGE:AlphaTo(0, 0.1, 0, function()
            RADIO_MESSAGE:Remove()
        end)

        surface.PlaySound(mp.Sound.DEPLOY_2)

        return false
    end

    surface.PlaySound(mp.Sound.DEPLOY)

    local RadioMessage = vgui.Create("EditablePanel")
    RADIO_MESSAGE = RadioMessage
    RADIO_MESSAGE:SetSize(250, 100)
    RADIO_MESSAGE:SetPos(scrw, scrh / 3)
    RADIO_MESSAGE:MoveTo(scrw - 260, scrh / 3, 0.5, 0.1, 0.1)
    RADIO_MESSAGE:MakePopup()
    RADIO_MESSAGE:SetAlpha(0)
    RADIO_MESSAGE:AlphaTo(255, 0.3, 0.1)
    RADIO_MESSAGE.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE_TO)

        mp.Icon(0, h / 2, w, h / 2, mp.Material.GRADIENT_D, C_BS_15)
        mp.Icon(w / 2, 0, w / 2, h, mp.Material.GRADIENT_R, C_BS_15)
        mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_50)
        mp.Icon(0, h - 1, w, 1, mp.Material.GRADIENT_C, C_W_50)

        mp.Text(name, name_font, w / 2, 5, mp.Color.RADIO, 1, 0)
        mp.Text(message_text, text_font, w / 2, 25, mp.Color.WHITE, 1, 0)
    end

    RADIO_MESSAGE.Think = function(self, w, h)
        if IsValid(RADIO_MESSAGE) and not ply:Alive() then
            RADIO_MESSAGE:AlphaTo(0, 0.2, 0, function()
                RADIO_MESSAGE:Remove()
            end)

            surface.PlaySound(mp.Sound.DEPLOY_2)
        end
    end

    local AccessTrue = vgui.Create("DButton", RADIO_MESSAGE)
    ACCESS_TRUE = AccessTrue
    ACCESS_TRUE:SetSize(90, 35)
    ACCESS_TRUE:SetText("")
    ACCESS_TRUE:SetPos(RADIO_MESSAGE:GetWide() / 2 - 90, RADIO_MESSAGE:GetTall() - 45)
    ACCESS_TRUE.Hover = 0
    ACCESS_TRUE.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
        end

        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE_TO, 255 - self.Hover))
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, self.Hover))

        draw.SimpleText(enter_text, button_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
        draw.SimpleText(enter_text, button_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)

        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_G_25)
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, C_G_10)

        mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_25)
        mp.Icon(0, h - 1, w, 1, mp.Material.GRADIENT_C, C_W_25)
    end

    ACCESS_TRUE.OnCursorEntered = function()
        surface.PlaySound(mp.Sound.HOVER)
    end

    ACCESS_TRUE.DoClick = function(self)
        net.Start("mp.AccessChanel")
        net.WriteEntity(ply)
        net.WriteInt(chanel, 11)
        net.SendToServer()

        RADIO_MESSAGE:AlphaTo(0, 0.2, 0)
        RADIO_MESSAGE:MoveTo(scrw, scrh / 3, 0.15, 0.1, 0.9, function()
            RADIO_MESSAGE:Remove()
            RADIO_MESSAGE = nil
        end)

        surface.PlaySound(mp.Sound.CLICK_2)
    end

    local AccessFalse = vgui.Create("DButton", RADIO_MESSAGE)
    ACCESS_FALSE = AccessFalse
    ACCESS_FALSE:SetSize(90, 35)
    ACCESS_FALSE:SetText("")
    ACCESS_FALSE:SetPos(RADIO_MESSAGE:GetWide() / 2 + 5, RADIO_MESSAGE:GetTall() - 45)
    ACCESS_FALSE.Hover = 0
    ACCESS_FALSE.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
        end

        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE_TO, 255 - self.Hover))
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, self.Hover))

        draw.SimpleText(close_text, button_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
        draw.SimpleText(close_text, button_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)

        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_R_25)
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, C_R_10)

        mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_C, C_W_25)
        mp.Icon(0, h - 1, w, 1, mp.Material.GRADIENT_C, C_W_25)
    end

    ACCESS_TRUE.OnCursorEntered = function()
        surface.PlaySound(mp.Sound.HOVER)
    end

    ACCESS_FALSE.DoClick = function(self)
        RADIO_MESSAGE:AlphaTo(0, 0.2, 0)
        RADIO_MESSAGE:MoveTo(scrw, scrh / 3, 0.15, 0.1, 0.9, function()
            RADIO_MESSAGE:Remove()
            RADIO_MESSAGE = nil
        end)

        surface.PlaySound(mp.Sound.CLICK_2)
    end
end)
