include("shared.lua")

local ColorAlpha = ColorAlpha
local Color = Color
local mp = mp
local draw = draw
local Lerp = Lerp
local FrameTime = FrameTime
local vgui = vgui
local Vector, Angle = Vector, Angle
local IsValid = IsValid
local net = net
local surface = surface
local Material = Material

local title_font = mp.font('20:Futura PT Medium')
local goback_font = mp.font('30:Futura PT Light')
local small_font = mp.font('16:Futura PT Light')

local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_B_25 = ColorAlpha(mp.Color.BASE, 25)

local exit_text = '× Закрыть'

function ENT:Draw()
    self:DrawModel()
end

local bg_mat = Material("stalker/scoreboard/ui_obvodka_menu.png")
local icon_button = Material('stalker/hud/ui_button_main.png')
local icon_button_press = Material('stalker/hud/ui_button_main2.png')

local function BuildPanel(p, txt, c, id, mdl, bip)
    if txt == 'FaceProtection' then return end
    p.dl = p:Add("DLabel")
    p.dl:Dock(TOP)
    p.dl:SetText(txt)
    p.dl:SetFont(title_font)
    p.dl:DockMargin(0, 10, 0, 5)

    local List = p:Add("DIconLayout")
    List:Dock(TOP)
    List:SetSpaceY(5)
    List:SetSpaceX(5)

    for z = 0, c do
        local ListItem = List:Add("DButton")
        ListItem:SetSize(48, 48)
        ListItem:SetText('')
        ListItem.DoClick = function(s)
            mdl:SetBodygroup(id, z)
            net.Start('bodygroup')
            net.WriteBit(0)
            net.WriteUInt(id, 7)
            net.WriteUInt(z, 7)
            net.SendToServer()
            s.i = 0
        end
        ListItem.i = 0
        ListItem.Hover = 0
        ListItem.Paint = function(self, w, h)
            if LocalPlayer():GetBodygroup(id) == z then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            elseif self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, 255 - self.Hover))
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)

            draw.SimpleText(z, title_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
            draw.SimpleText(z, title_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, self.Hover), 1, 1)

            surface.SetDrawColor(C_W_25)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end
    end
end

-- Функция для отображения панели сохранений
local function ShowSavesPanel(parent)
    local savesFrame = vgui.Create("DFrame", parent)
    savesFrame:SetSize(400, 500)
    savesFrame:SetTitle("")
    savesFrame:SetDraggable(false)
    savesFrame:ShowCloseButton(false)
    savesFrame:Center()
    savesFrame:MakePopup()

    savesFrame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40, 240))
        draw.RoundedBox(8, 1, 1, w - 2, h - 2, Color(60, 60, 60, 255))

        draw.SimpleText("Сохраненные бодигруппы", title_font, w / 2, 20, color_white, TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER)
    end

    local closeBtn = savesFrame:Add("DButton")
    closeBtn:SetSize(30, 30)
    closeBtn:SetPos(365, 5)
    closeBtn:SetText("×")
    closeBtn:SetFont(goback_font)
    closeBtn:SetTextColor(color_white)
    closeBtn.DoClick = function() savesFrame:Remove() end
    closeBtn.Paint = function() end

    local savesList = savesFrame:Add("DScrollPanel")
    savesList:Dock(FILL)
    savesList:DockMargin(10, 50, 10, 10)

    local saveNameEntry = savesFrame:Add("DTextEntry")
    saveNameEntry:Dock(BOTTOM)
    saveNameEntry:DockMargin(10, 5, 10, 10)
    saveNameEntry:SetPlaceholderText("Название сохранения")

    local saveBtn = savesFrame:Add("DButton")
    saveBtn:Dock(BOTTOM)
    saveBtn:DockMargin(10, 0, 10, 5)
    saveBtn:SetText("Сохранить текущие")
    saveBtn:SetTall(30)
    saveBtn.DoClick = function()
        local name = saveNameEntry:GetValue()
        if name ~= "" then
            net.Start("bodygroup_save")
            net.WriteString(name)
            net.SendToServer()
            savesFrame:Remove()
        end
    end

    -- Запрашиваем список сохранений
   --[[ net.Start("bodygroup_list")
    net.SendToServer()

    net.Receive("bodygroup_list", function()
        local count = net.ReadUInt(8)

        for i = 1, count do
            local name = net.ReadString()
            local timestamp = net.ReadUInt(32)
            local timeStr = os.date("%d.%m.%Y %H:%M", timestamp)

            local savePanel = savesList:Add("DPanel")
            savePanel:Dock(TOP)
            savePanel:DockMargin(0, 0, 0, 5)
            savePanel:SetTall(40)

            savePanel.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(80, 80, 80, 255))
                draw.SimpleText(name, small_font, 10, h / 2 - 8, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(timeStr, small_font, 10, h / 2 + 8, Color(200, 200, 200), TEXT_ALIGN_LEFT,
                    TEXT_ALIGN_CENTER)
            end

            local loadBtn = savePanel:Add("DButton")
            loadBtn:SetSize(60, 25)
            loadBtn:SetPos(320, 7)
            loadBtn:SetText("Загрузить")
            loadBtn:SetFont(small_font)
            loadBtn.DoClick = function()
                net.Start("bodygroup_load")
                net.WriteString(name)
                net.SendToServer()
                savesFrame:Remove()
            end

            local deleteBtn = savePanel:Add("DButton")
            deleteBtn:SetSize(60, 25)
            deleteBtn:SetPos(250, 7)
            deleteBtn:SetText("Удалить")
            deleteBtn:SetFont(small_font)
            deleteBtn.DoClick = function()
                net.Start("bodygroup_delete")
                net.WriteString(name)
                net.SendToServer()
                savePanel:Remove()
            end
        end

        if count == 0 then
            local noSaves = savesList:Add("DLabel")
            noSaves:Dock(TOP)
            noSaves:SetText("Нет сохраненных бодигрупп")
            noSaves:SetFont(small_font)
            noSaves:SetTextColor(Color(150, 150, 150))
            noSaves:SetContentAlignment(5)
            noSaves:SetTall(50)
        end
    end)]]
end

local max = math.Clamp(1 / (1920 / ScrW()), .8, 1)
net.Receivers.bodygroup = function()
    if not LocalPlayer():Alive() then return end

    if IsValid(BODY_BACKGROUND) then
        BODY_BACKGROUND:AlphaTo(0, 0.3, 0, function()
            BODY_BACKGROUND:Remove()
        end)

        surface.PlaySound(mp.Sound.DEPLOY_2)

        return
    end

    local scrw, scrh = ScrW(), ScrH()
    local ply = LocalPlayer()

    local BodyBackground = vgui.Create('EditablePanel')
    BODY_BACKGROUND = BodyBackground
    BODY_BACKGROUND:SetSize(scrw, scrh)
    BODY_BACKGROUND:SetPos(0, 0)
    BODY_BACKGROUND:MakePopup()
    BODY_BACKGROUND:SetAlpha(0)
    BODY_BACKGROUND:AlphaTo(255, 0.5, 0)
    BODY_BACKGROUND.Paint = function(self, w, h)
        mp.BlurBG(self, 2)

        draw.RoundedBox(0, 0, 0, w, h, C_B_200)
    end

    local GoExit = vgui.Create("DButton", BODY_BACKGROUND)
    GO_EXIT = GoExit
    GO_EXIT:SetSize(100, 30)
    GO_EXIT:SetPos(10, 10)
    GO_EXIT:SetText('')
    GO_EXIT.Hover = 0
    GO_EXIT.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
        end

        draw.SimpleText(exit_text, goback_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1, 1)
        draw.SimpleText(exit_text, goback_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
    end

    GO_EXIT.DoClick = function(self)
        BODY_BACKGROUND:AlphaTo(0, 0.1, 0, function()
            BODY_BACKGROUND:Remove()
        end)
    end

    -- Кнопка управления сохранениями
    --[[local SavesButton = vgui.Create("DButton", BODY_BACKGROUND)
    SavesButton:SetSize(150, 30)
    SavesButton:SetPos(scrw - 160, 10)
    SavesButton:SetText("Сохранения")
    SavesButton:SetFont(small_font)
    SavesButton.DoClick = function()
        ShowSavesPanel(BODY_BACKGROUND)
    end

    SavesButton:SetColor(Color(0, 0, 0, 0))
    SavesButton.Hover = 0
    SavesButton.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
        end

        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, 125))
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

        draw.SimpleText(self:GetText(), title_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
        draw.SimpleText(self:GetText(), title_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, self.Hover), 1, 1)

        surface.SetDrawColor(C_W_25)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end]]

    BODY_BACKGROUND.Char = BODY_BACKGROUND:Add("DModelPanel")
    BODY_BACKGROUND.Char:Dock(LEFT)
    BODY_BACKGROUND.Char:DockMargin(50, 50, 50, 50)
    BODY_BACKGROUND.Char:SetWide(scrw * .5)
    BODY_BACKGROUND.Char:SetFOV(65)
    BODY_BACKGROUND.Char:SetModel(LocalPlayer():GetModel())
    BODY_BACKGROUND.Char.Angles = Angle(0, 75, 0)
    BODY_BACKGROUND.Char:SetDirectionalLight(BOX_RIGHT, color_white)
    BODY_BACKGROUND.Char:SetDirectionalLight(BOX_BACK, color_white)
    BODY_BACKGROUND.Char:SetDirectionalLight(BOX_FRONT, color_white)

    for k, v in pairs(ply:GetBodyGroups()) do
        BODY_BACKGROUND.Char:GetEntity():SetBodygroup(v.id, ply:GetBodygroup(v.id))
    end

    function BODY_BACKGROUND.Char:DragMousePress()
        self.PressX, self.PressY = input.GetCursorPos()
        self.Pressed = true
    end

    function BODY_BACKGROUND.Char:DragMouseRelease()
        self.Pressed = false
    end

    BODY_BACKGROUND.Char.Hover = 0
    function BODY_BACKGROUND.Char:LayoutEntity(ent)
        ent:SetSkin(ply:GetSkin())

        if (self.bAnimated) then self:RunAnimation() end

        local mx, my = input.GetCursorPos()

        if (self.Pressed) then
            self.Hover = Lerp(FrameTime() * 2, self.Hover, (self.PressX or mx) - mx)
            self.Angles = self.Angles - Angle(0, self.Hover, 0)
            self.PressX, self.PressY = input.GetCursorPos()
        else
            self.Hover = Lerp(FrameTime() * 4, self.Hover, 0)
            self.Angles = self.Angles - Angle(0, self.Hover, 0)
            self.PressX, self.PressY = input.GetCursorPos()
        end

        ent:SetAngles(self.Angles)
        ent:SetPos(Vector(0, 0, 0))
    end

    BODY_BACKGROUND.Bodygroups = BODY_BACKGROUND:Add("DScrollPanel")
    BODY_BACKGROUND.Bodygroups:DockMargin(0, 100, 50, 100)
    BODY_BACKGROUND.Bodygroups:Dock(RIGHT)
    BODY_BACKGROUND.Bodygroups:SetSize(BODY_BACKGROUND:GetWide() * .5, 0)
    BODY_BACKGROUND.Bodygroups.VBar:SetWide(5)

    local sbar = BODY_BACKGROUND.Bodygroups:GetVBar()
    sbar:SetHideButtons(true)

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, C_B_100)
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
    end

    local skincount = BODY_BACKGROUND.Bodygroups:Add("DLabel")
    skincount:Dock(TOP)
    skincount:SetText('Скины:')
    skincount:SetFont(title_font)
    skincount:DockMargin(0, 10, 0, 5)

    local List = BODY_BACKGROUND.Bodygroups:Add("DIconLayout")
    List:Dock(TOP)
    List:SetSpaceY(5)
    List:SetSpaceX(5)

    for z = 0, ply:SkinCount() do
        local ListItem = List:Add("DButton")
        ListItem:SetSize(48, 48)
        ListItem:SetText('')
        ListItem.DoClick = function(s)
            BODY_BACKGROUND.Char:SetSkin(z)
            net.Start('bodygroup')
            net.WriteBit(1)
            net.WriteUInt(z, 7)
            net.SendToServer()
            s.i = 0
        end
        ListItem.i = 0
        ListItem.Hover = 0
        ListItem.Paint = function(self, w, h)
            if ply:GetSkin() == z then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            elseif self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BLACK, 255 - self.Hover))
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)

            draw.SimpleText(z, title_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
            draw.SimpleText(z, title_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, self.Hover), 1, 1)

            surface.SetDrawColor(C_W_25)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end
    end
    for z = 0, ply:GetNumBodyGroups() - 1 do
        if (ply:GetBodygroupCount(z) <= 1) then continue end
        BuildPanel(BODY_BACKGROUND.Bodygroups, ply:GetBodygroupName(z), ply:GetBodygroupCount(z) - 1, z,
            BODY_BACKGROUND.Char:GetEntity())
    end
end
