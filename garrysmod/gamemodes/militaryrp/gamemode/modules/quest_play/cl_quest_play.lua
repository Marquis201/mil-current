local mp = mp
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
local LocalPlayer = LocalPlayer

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

local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)

local title_font = mp.font("20:DIN Pro Regular")
local quest_font = mp.font("18:DIN Pro Regular")
local text_font = mp.font("18:DIN Pro Regular")
local title_quest_font = mp.font("20:DIN Pro Bold")
local help_quest_font = mp.font("16:DIN Pro Regular")
local info_quest_font = mp.font("20:DIN Pro Medium")

do
    local function OpenMenu()
        local pl = LocalPlayer()
        if not pl then return end

        surface.PlaySound(mp.Sound.DEPLOY)

        local scrw, scrh = ScrW(), ScrH()

        local QualificationPanel = vgui.Create("EditablePanel")
        QualificationPanel:SetSize(840, 320)
        QualificationPanel:SetPos(scrw * .5 - QualificationPanel:GetWide() / 2, scrh)
        QualificationPanel:MoveTo(scrw * .5 - QualificationPanel:GetWide() / 2, scrh - QualificationPanel:GetTall(), 0.6,
            0, 0.2)
        QualificationPanel:MakePopup()
        QualificationPanel:SetAlpha(0)
        QualificationPanel:AlphaTo(255, 0.3, 0.1)
        QualificationPanel.Paint = function(self, w, h)
            mp.PanelBlur(self, 1)

            draw.RoundedBox(0, 0, 0, w, h, C_B_200)

            mp.Text(self.title, title_font, w / 2, 20, mp.Color.BASE, 1, 1)
        end

        local parent = vgui.Create("Panel", QualificationPanel)
        parent:Dock(FILL)
        parent:DockMargin(10, 40, 10, 10)
        function parent:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
        end

        local DataQuest = {}
        local id_quest = 0
        local count_score = 0

        local t = mp.QuestPlay.TestQualification

        parent.open_quest = function()
            parent:Clear()
            parent:AlphaTo(255, 0.2, 0)
            id_quest = id_quest + 1

            if id_quest > #t then
                net.Start("QuestPlay.QualificationSend")
                net.WriteUInt(table.Count(DataQuest), 8)
                for k, v in pairs(DataQuest) do
                    net.WriteUInt(k, 8)
                    net.WriteUInt(v, 8)
                end
                net.SendToServer()

                QualificationPanel:AlphaTo(0, 0.2, 0, function()
                    QualificationPanel:Remove()
                end)
                QualificationPanel:MoveTo(scrw * .5 - QualificationPanel:GetWide() / 2, scrh, 0.5, 0, 0.2)

                return
            end

            local data = t[id_quest]
            QualificationPanel.title = "Вопрос: " .. id_quest .. " из " .. #t

            local panel_quest = vgui.Create("Panel", parent)
            panel_quest:Dock(TOP)
            panel_quest:SetTall(32)
            panel_quest:DockMargin(5, 5, 5, 5)

            local panel_answer = vgui.Create("Panel", parent)
            panel_answer:Dock(BOTTOM)
            panel_answer:SetTall(200)
            panel_answer:DockMargin(0, 0, 0, 0)

            local tilte_text = vgui.Create("DLabel", panel_quest)
            tilte_text:Dock(TOP)
            tilte_text:DockMargin(5, 5, 5, 5)
            tilte_text:SetText("- " .. data.name)
            tilte_text:SetWrap(true)
            tilte_text:SetAutoStretchVertical(true)
            tilte_text:SetFont(quest_font)

            function panel_quest:PerformLayout()
                self:SetTall(math.Clamp(tilte_text:GetTall() + 10, 36, 999))
            end

            for k, v in ipairs(data.answer) do
                local panel_answer = vgui.Create("DButton", panel_answer)
                panel_answer:Dock(TOP)
                panel_answer:SetTall(32)
                panel_answer:DockMargin(10, 0, 10, 10)
                panel_answer:SetText("")
                function panel_answer:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

                    if self:IsHovered() then
                        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)
                    end

                    surface.SetDrawColor(ColorOutline)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)
                end

                function panel_answer:DoClick()
                    DataQuest[id_quest] = k

                    parent:AlphaTo(0, 0.2, 0, function()
                        parent.open_quest()
                    end)
                end

                local answer_text = vgui.Create("DLabel", panel_answer)
                answer_text:Dock(TOP)
                answer_text:DockMargin(5, 5, 5, 5)
                answer_text:SetText(k .. ". " .. v.name)
                answer_text:SetWrap(true)
                answer_text:SetAutoStretchVertical(true)
                answer_text:SetFont(text_font)

                function panel_answer:PerformLayout()
                    self:SetTall(math.Clamp(answer_text:GetTall() + 10, 32, 999))
                end
            end
        end

        parent.open_quest()
    end

    net.Receive("QuestPlay.QualificationMenu", function()
        OpenMenu()
    end)
end

do
    local function OpenMenu()
        local pl = LocalPlayer()
        if not pl then return end

        surface.PlaySound(mp.Sound.DEPLOY)

        local scrw, scrh = ScrW(), ScrH()

        local ContractMenu = vgui.Create("EditablePanel")
        ContractMenu:SetSize(840, 400)
        ContractMenu:SetPos(scrw * .5 - ContractMenu:GetWide() / 2, scrh)
        ContractMenu:MoveTo(scrw * .5 - ContractMenu:GetWide() / 2, scrh / 2 - ContractMenu:GetTall() / 2, 0.6, 0, 0.3)
        ContractMenu:MakePopup()
        ContractMenu:SetAlpha(0)
        ContractMenu:AlphaTo(255, 0.3, 0.1)
        ContractMenu.title = "Контракты"
        ContractMenu.Paint = function(self, w, h)
            mp.PanelBlur(self, 1)
            draw.RoundedBox(0, 0, 0, w, h, C_B_200)
            draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

            mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
            mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
            mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

            surface.SetDrawColor(C_B_25)
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            mp.Text(self.title, title_font, w / 2, 20, mp.Color.BASE, 1, 1)
        end

        local ClosePanel = vgui.Create("DButton", ContractMenu)
        ClosePanel:SetSize(20, 20)
        ClosePanel:SetText("")
        ClosePanel.Hover = 0
        ClosePanel:SetPos(ContractMenu:GetWide() - ClosePanel:GetWide() - 15, 10)
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
            ContractMenu:AlphaTo(0, 0.2, 0, function()
                ContractMenu:Remove()
            end)
            ContractMenu:MoveTo(scrw * .5 - ContractMenu:GetWide() / 2, scrh, 0.1, 0.1, 0.9)

            surface.PlaySound(mp.Sound.CLICK_10)
        end

        local list = vgui.Create("DScrollPanel", ContractMenu)
        list:Dock(LEFT)
        list:SetWide(300)
        list:DockMargin(10, 50, 10, 10)
        list.Hover = 0
        list.VBar:SetWide(5)
        list.Paint = function(self, w, h)
            local x2, y2 = self:LocalCursorPos()

            if x2 < w and x2 > 0 and y2 < h and y2 > 0 then
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, C_B_100)

            self.VBar:SetAlpha(self.Hover)
        end
        local sbar = list:GetVBar()
        sbar:SetHideButtons(true)

        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
        end

        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
        end

        local SelectQuest
        local info_quest = vgui.Create("Panel", ContractMenu)
        info_quest:Dock(FILL)
        info_quest:SetWide(300)
        info_quest:DockMargin(0, 50, 10, 10)
        function info_quest:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
        end

        function info_quest:Open(id)
            if not mp.QuestPlay.List[id] then return end
            info_quest:Clear()
            info_quest:SetAlpha(0)
            info_quest:AlphaTo(255, 0.2, 0)

            local data = mp.QuestPlay.List[id]

            local TitleQuest = vgui.Create("DLabel", info_quest)
            TitleQuest:Dock(TOP)
            TitleQuest:DockMargin(10, 10, 10, 0)
            TitleQuest:SetText(data.name)
            TitleQuest:SetWrap(true)
            TitleQuest:SetAutoStretchVertical(true)
            TitleQuest:SetFont(title_quest_font)

            local HelpQuest = vgui.Create("DLabel", info_quest)
            HelpQuest:Dock(TOP)
            HelpQuest:DockMargin(10, 0, 10, 10)
            HelpQuest:SetText(data.help .. (data.solo and "\n\n* контракт расчитан на 1 игрока сервера. Не выходите из сервера во время выполнения!" or ""))
            HelpQuest:SetWrap(true)
            HelpQuest:SetAutoStretchVertical(true)
            HelpQuest:SetFont(help_quest_font)
            HelpQuest:SetColor(C_W_100)

            function info_quest:Paint(w, h)
                local pos = HelpQuest:GetY() + HelpQuest:GetTall() + 10

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                draw.RoundedBox(0, HelpQuest:GetX(), pos, w - 20, 1, ColorOutline)

                mp.Text("Стоимость", text_font, 10, pos + 5, C_W_100, 0, 0)
                mp.Text("Награда", text_font, w / 2, pos + 5, C_W_100, 0, 0)
                mp.Text("Время", text_font, w - 10, pos + 5, C_W_100, 2, 0)
                mp.Text(mp.FormatMoney(data.price * data.reward), info_quest_font, w / 2, pos + 25, C_W_200, 0, 0)
                mp.Text(mp.FormatMoney(data.price), info_quest_font, 10, pos + 25, C_W_200, 0, 0)
                mp.Text(string.FormattedTime(data.time, "%02i:%02i"), info_quest_font, w - 10, pos + 25, C_W_200, 2, 0)
            end

            local StartQuest = vgui.Create("DButton", info_quest)
            StartQuest:Dock(BOTTOM)
            StartQuest:SetTall(42)
            StartQuest:DockMargin(150, 10, 150, 10)
            StartQuest:SetText("")
            StartQuest.Hover = 0
            StartQuest.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                end

                local canQuest = pl:CanAffordPoints(data.price)

                draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
                mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
                mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
                draw.RoundedBox(0, 0, 0, w, h, canQuest and ColorAlpha(mp.Color.BASE, self.Hover) or C_R_25)

                surface.SetDrawColor(canQuest and ColorOutline or C_R_25)
                surface.DrawOutlinedRect(0, 0, w, h, 1)

                draw.SimpleText(canQuest and "Начать" or "Недостаточно средств", info_quest_font, w / 2, h / 2,
                    ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
                    1)
                draw.SimpleText(canQuest and "Начать" or "Недостаточно средств", info_quest_font, w / 2, h / 2,
                    ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
            end

            StartQuest.DoClick = function(s)
                if mp.QuestPlay:HasContract(pl, data.id) then return end
                net.Start("QuestPlay.StartContract")
                net.WriteString(data.id)
                net.SendToServer()
            end
        end

        local id = 0
        for k, v in pairs(mp.QuestPlay.List) do
            if not v.retry or v.category ~= "Контракт" then continue end
            if mp.QuestPlay:HasContract(pl, v.id) then continue end

            if not SelectQuest then SelectQuest = k end

            id = id + 1

            local panel_quest = vgui.Create("DButton", list)
            panel_quest:Dock(TOP)
            panel_quest:SetTall(32)
            panel_quest:DockMargin(10, 10, 10, 0)
            panel_quest:SetText("")
            panel_quest.Hover = 0
            function panel_quest:Paint(w, h)
                self.Hover = Lerp(FrameTime() * 5, self.Hover, (self:IsHovered() or SelectQuest == k) and 100 or 0)

                draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

                surface.SetDrawColor(ColorOutline)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end

            function panel_quest:DoClick()
                SelectQuest = k
                info_quest:Open(k)
            end

            local quest_text = vgui.Create("DLabel", panel_quest)
            quest_text:Dock(TOP)
            quest_text:DockMargin(5, 5, 5, 5)
            quest_text:SetText(id .. ". " .. v.name)
            quest_text:SetWrap(true)
            quest_text:SetAutoStretchVertical(true)
            quest_text:SetFont(text_font)

            function panel_quest:PerformLayout()
                self:SetTall(math.Clamp(quest_text:GetTall() + 10, 32, 999))
            end
        end

        if SelectQuest then
            info_quest:Open(SelectQuest)
        end
    end

    net.Receive("QuestPlay.ContractMenu", function()
        OpenMenu()
    end)
end
