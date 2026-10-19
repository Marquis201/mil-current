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

local goback_font = mp.font("30:Futura PT Light")
local small_font = mp.font("16:Futura PT Light")
local n_font2 = mp.font("18:DIN Pro Regular")
local search_font = mp.font("20:DIN Pro Regular")
local text_font = mp.font("22:DIN Pro Regular")

local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_W_100 = ColorAlpha(mp.Color.BASE, 100)
local C_B_100 = ColorAlpha(mp.Color.BASE_TO, 100)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)

local exit_text = "× Закрыть"
local title_text_preset = "Пресеты"
local title_text_body = "Бодигруппы"

local complex_off = Vector(0, 0, 20)
local simple_off = Vector(0, 0, 55)

local ang = Angle(0, 90, 90)
local pos

local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
local ColorClose = ColorAlpha(mp.Color.RED, 50)

local title_font
local LerpPos, LerpAlpha = 0, 0

function ENT:Draw()
    title_font = title_font or mp.font("75:Futura PT Book")

    local pl = LocalPlayer()
    local dist = pl:GetPos():Distance(self:GetPos())

    self:DrawModel()

    local bone = self:LookupBone("ValveBiped.Bip01_Head1")
    if bone then
        pos = self:GetBonePosition(bone) + complex_off
    else
        pos = self:GetPos() + simple_off
    end

    ang.y = (pl:EyeAngles().y - 90)

    LerpAlpha = Lerp(FrameTime() * 5, LerpAlpha, (dist > 300) and 0 or 300)
    LerpPos = Lerp(FrameTime() * 4, LerpPos, (dist > 300) and 150 or 0)

    if LerpAlpha <= 1 then return end

    surface.SetFont(title_font)
    local tw, th = surface.GetTextSize(self.PrintName)

    tw = tw + 50
    th = th + 30

    cam.Start3D2D(pos, ang, 0.05)

    draw.RoundedBox(0, -tw / 2, LerpPos, tw, th, ColorAlpha(ColorBackground_100, LerpAlpha / 2))

    surface.SetDrawColor(ColorAlpha(ColorOutline, LerpAlpha / 2))
    surface.DrawOutlinedRect(-tw / 2, LerpPos, tw, th, 3)

    draw.SimpleText(self.PrintName, title_font, 0, th / 2 + LerpPos, ColorAlpha(mp.Color.BASE, LerpAlpha), 1, 1)

    cam.End3D2D()
end

local max = math.Clamp(1 / (1920 / ScrW()), .8, 1)
net.Receive("mp.bodygroup_team", function()
    if not LocalPlayer():Alive() then return end

    if IsValid(BODY_BACKGROUND) then
        BODY_BACKGROUND:AlphaTo(0, 0.3, 0, function()
            BODY_BACKGROUND:Remove()
        end)

        surface.PlaySound(mp.Sound.DEPLOY_2)

        return
    end

    local scrw, scrh = ScrW(), ScrH()
    local pl = LocalPlayer()

    local faction = pl:GetFaction()

    if not faction then return end

    local dataFaction = mp.faction[faction]

    if not dataFaction then return end

    local rank = pl:GetNetVar("meta_rank")
    local access = false

    if rank and mp.ranks[rank] and mp.ranks[rank].preset then
        access = true
    end

    local Preset = nw.GetGlobal("mp.BodyPresets") or {}

    local models = {}
    local SelectBody = {}
    local SelectSkin = 1
    local SelectPreset

    local CreateBodyGroup

    for k, v in pairs(dataFaction.profession) do
        if v.model then
            models[#models + 1] = {
                name = v.name,
                model = v.model,
                profession = true
            }
        end
    end

    for k, v in pairs(mp.jobs) do
        if v.faction and v.faction == faction and not istable(v.model) then
            models[#models + 1] = {
                name = v.Name,
                model = v.model,
                job = true
            }
        end
    end

    local SelectModel

    local BodyBackground = vgui.Create("EditablePanel")
    BODY_BACKGROUND = BodyBackground
    BodyBackground:SetSize(scrw, scrh)
    BodyBackground:SetPos(0, 0)
    BodyBackground:MakePopup()
    BodyBackground:SetAlpha(0)
    BodyBackground:AlphaTo(255, 0.5, 0)
    BodyBackground.Paint = function(self, w, h)
        mp.BlurBG(self, 2)

        draw.RoundedBox(0, 0, 0, w, h, C_B_200)
    end

    local Dealy = CurTime() + 0.5
    BodyBackground.Think = function(self, w, h)
        if Dealy > CurTime() then return end

        if input.IsKeyDown(KEY_F1) then
            if IsValid(self) then
                self:AlphaTo(0, 0.2, 0, function()
                    self:Remove()
                end)

                surface.PlaySound(mp.Sound.ROLLUP_2)
            end
        end

        if IsValid(self) and not pl:Alive() then
            self:AlphaTo(0, 0.2, 0, function()
                self:Remove()
            end)

            surface.PlaySound(mp.Sound.ROLLUP_2)
        end
    end

    local MainPanel = vgui.Create("Panel", BodyBackground)
    MainPanel:Dock(FILL)
    MainPanel:DockMargin(50, 50, 50, 20)

    local ChooseModel = vgui.Create("DModelPanel", MainPanel)
    ChooseModel:Dock(FILL)
    ChooseModel:SetFOV(scrh / 20)
    ChooseModel:SetModel(pl:GetModel())
    ChooseModel:DockMargin(20, 0, 20, 0)
    ChooseModel.Angles = Angle(0, 75, 0)
    ChooseModel:SetCamPos(Vector(0, 100, 50))
    ChooseModel:SetDirectionalLight(BOX_RIGHT, mp.Color.WHITE)
    ChooseModel:SetDirectionalLight(BOX_BACK, mp.Color.WHITE)
    ChooseModel:SetDirectionalLight(BOX_FRONT, mp.Color.BLACK)

    for k, v in pairs(pl:GetBodyGroups()) do
        ChooseModel:GetEntity():SetBodygroup(v.id, pl:GetBodygroup(v.id))
    end

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

    local PresetPanel = vgui.Create("Panel", MainPanel)
    PresetPanel:Dock(LEFT)
    PresetPanel:SetWide(BodyBackground:GetWide() / 5)

    function PresetPanel:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

        surface.SetDrawColor(ColorOutline)
        surface.DrawOutlinedRect(0, 0, w, h, 1)

        draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

        mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
        mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
        mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

        mp.Text(title_text_preset, search_font, w / 2, 20, mp.Color.BASE, 1, 1)
    end

    local PresetScroll = vgui.Create("DScrollPanel", PresetPanel)
    PresetScroll:Dock(FILL)
    PresetScroll.Hover = 0
    PresetScroll.VBar:SetWide(5)
    PresetScroll:DockMargin(10, 40, 10, 0)

    local sbar = PresetScroll:GetVBar()
    sbar:SetHideButtons(true)

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, C_B_100)
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
    end

    function PresetScroll:Paint(w, h)
        local x, y = self:LocalCursorPos()
        local w, h = self:GetWide(), self:GetTall()

        if x < w and x > 0 and y < h and y > 0 then
            self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
        end

        self.VBar:SetAlpha(self.Hover)
    end

    local panelModels
    local AddPreset
    if access then
        AddPreset = vgui.Create("DButton", PresetScroll)
        AddPreset:Dock(TOP)
        AddPreset:SetTall(32)
        AddPreset:DockMargin(0, 10, 0, 0)
        AddPreset:SetText("+ Добавить пресет")
        AddPreset:SetColor(Color(0, 0, 0, 0))
        AddPreset.Hover = 0
        AddPreset.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

            surface.SetDrawColor(ColorAlpha(mp.Color.BLUE, 50))
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            surface.SetDrawColor(ColorAlpha(mp.Color.WHITE, self.Hover / 2))
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BLUE, 255 - self.Hover), 1,
                1)
            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
        end

        AddPreset.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end
    end

    for k, v in ipairs(Preset) do
        if not v.faction or v.faction ~= faction then continue end
        if pl:GetModel() ~= v.model and not access then continue end

        local ButtonPreset = vgui.Create("DButton", PresetScroll)
        ButtonPreset:Dock(TOP)
        ButtonPreset:SetTall(32)
        ButtonPreset:DockMargin(0, 10, 0, 0)
        ButtonPreset:SetText(v.name)
        ButtonPreset:SetColor(Color(0, 0, 0, 0))
        ButtonPreset.Hover = 0
        ButtonPreset.Paint = function(self, w, h)
            if self:IsHovered() or SelectPreset == k then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

            surface.SetDrawColor(ColorAlpha(mp.Color.BASE, 50))
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            surface.SetDrawColor(ColorAlpha(mp.Color.WHITE, self.Hover / 2))
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
                1)
            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
        end

        ButtonPreset.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        ButtonPreset.DoClick = function(self)
            ChooseModel:SetModel(v.model)
            ChooseModel:GetEntity():SetSkin(v.skin)

            for key, val in pairs(v.body) do
                ChooseModel:GetEntity():SetBodygroup(key, val)
            end

            SelectPreset = k
            SelectBody = v.body
            SelectSkin = v.skin

            CreateBodyGroup()
        end
    end

    if access then
        AddPreset.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)

            SelectModel = 1
            ChooseModel:SetModel(models[SelectModel].model)

            SelectBody = {}
            SelectSkin = 1
            SelectPreset = nil

            CreateBodyGroup()

            if not IsValid(panelModels) then
                panelModels = vgui.Create("Panel", MainPanel)
                panelModels:Dock(BOTTOM)
                panelModels:DockMargin(20, 0, 20, 0)
                panelModels:SetTall(44)
                function panelModels:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

                    draw.SimpleText(models[SelectModel].name, search_font, w / 2, h / 2, color_white, 1, 1)
                end

                local AddModel = vgui.Create("DButton", panelModels)
                AddModel:Dock(RIGHT)
                AddModel:SetWide(32)
                AddModel:DockMargin(5, 5, 5, 5)
                AddModel:SetText("▶")
                AddModel:SetColor(Color(0, 0, 0, 0))
                AddModel.Hover = 0
                AddModel.Paint = function(self, w, h)
                    if self:IsHovered() then
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                    else
                        self.Hover = Lerp(FrameTime() * 5, self.Hover, 100)
                    end

                    draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

                    surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
                    surface.DrawOutlinedRect(0, 0, w, h, 1)

                    draw.SimpleText(self:GetText(), search_font, w / 2, h / 2,
                        ColorAlpha(mp.Color.WHITE, 255 - self.Hover),
                        1,
                        1)
                    draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1,
                        1)
                end

                AddModel.OnCursorEntered = function()
                    surface.PlaySound(mp.Sound.HOVER)
                end

                AddModel.DoClick = function(self)
                    surface.PlaySound(mp.Sound.CLICK_2)

                    SelectModel = SelectModel + 1

                    if SelectModel > #models then
                        SelectModel = 1
                    end

                    ChooseModel:SetModel(models[SelectModel].model)

                    CreateBodyGroup()
                end

                local TakeModel = vgui.Create("DButton", panelModels)
                TakeModel:Dock(LEFT)
                TakeModel:SetWide(32)
                TakeModel:DockMargin(5, 5, 5, 5)
                TakeModel:SetText("◀")
                TakeModel:SetColor(Color(0, 0, 0, 0))
                TakeModel.Hover = 0
                TakeModel.Paint = function(self, w, h)
                    if self:IsHovered() then
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                    else
                        self.Hover = Lerp(FrameTime() * 5, self.Hover, 100)
                    end

                    draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

                    surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
                    surface.DrawOutlinedRect(0, 0, w, h, 1)

                    draw.SimpleText(self:GetText(), search_font, w / 2, h / 2,
                        ColorAlpha(mp.Color.WHITE, 255 - self.Hover),
                        1,
                        1)
                    draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1,
                        1)
                end

                TakeModel.OnCursorEntered = function()
                    surface.PlaySound(mp.Sound.HOVER)
                end

                TakeModel.DoClick = function(self)
                    surface.PlaySound(mp.Sound.CLICK_2)

                    SelectModel = SelectModel - 1

                    if SelectModel <= 0 then
                        SelectModel = #models
                    end

                    ChooseModel:SetModel(models[SelectModel].model)

                    CreateBodyGroup()
                end
            end
        end
    end

    local BodyPanel = vgui.Create("Panel", MainPanel)
    BodyPanel:Dock(RIGHT)
    BodyPanel:SetWide(BodyBackground:GetWide() / 5)

    function BodyPanel:Paint(w, h)
        if not access then return end
        draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

        surface.SetDrawColor(ColorOutline)
        surface.DrawOutlinedRect(0, 0, w, h, 1)

        draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

        mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
        mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
        mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

        mp.Text(title_text_body, search_font, w / 2, 20, mp.Color.BASE, 1, 1)
    end

    local PresetBottom = vgui.Create("Panel", PresetPanel)
    PresetBottom:Dock(BOTTOM)
    PresetBottom:SetTall(44)
    PresetBottom:DockMargin(10, 10, 10, 10)

    CreateBodyGroup = function()
        BodyPanel:Clear()
        PresetBottom:Clear()

        if SelectPreset then
            if IsValid(panelModels) then
                panelModels:Remove()
            end

            local PresetBtn = vgui.Create("DButton", PresetBottom)
            PresetBtn:Dock(FILL)
            PresetBtn:DockMargin(0, 0, 0, 0)
            PresetBtn:SetText("")
            PresetBtn.Hover = 0
            PresetBtn.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
                mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
                mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

                surface.SetDrawColor(ColorOutline)
                surface.DrawOutlinedRect(0, 0, w, h, 1)

                draw.SimpleText("Выбрать", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
                    1)
                draw.SimpleText("Выбрать", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
            end

            PresetBtn.DoClick = function(self)
                net.Start("mp.bodygroup_team")
                net.WriteString("SelectPreset")
                net.WriteUInt(SelectPreset, 8)
                net.SendToServer()

                if IsValid(BodyBackground) then
                    BodyBackground:AlphaTo(0, 0.2, 0, function()
                        BodyBackground:Remove()
                    end)

                    surface.PlaySound(mp.Sound.ROLLUP_2)
                end
            end

            if access then
                local PresetDelete = vgui.Create("DButton", PresetBottom)
                PresetDelete:Dock(LEFT)
                PresetDelete:SetWide(44)
                PresetDelete:DockMargin(0, 0, 5, 0)
                PresetDelete:SetText("")
                PresetDelete.Hover = 0
                PresetDelete.Paint = function(self, w, h)
                    if self:IsHovered() then
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                    else
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
                    end

                    draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
                    mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
                    mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
                    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

                    surface.SetDrawColor(ColorAlpha(ColorClose, 50))
                    surface.DrawOutlinedRect(0, 0, w, h, 1)

                    draw.SimpleText("X", n_font2, w / 2, h / 2, ColorAlpha(ColorClose, 255 - self.Hover), 1,
                        1)
                    draw.SimpleText("X", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
                end

                PresetDelete.DoClick = function(self)
                    local randomid = math.random(111111, 999999)
                    Derma_StringRequest(
                        "Удаление",
                        "Если вы хотите удалить пресет, то введите: " .. randomid,
                        "",
                        function(text)
                            if not text or tonumber(text) ~= randomid then
                                mp.util.Notify(NOTIFY_ERROR, "Номер не совпал!")

                                if IsValid(BodyBackground) then
                                    BodyBackground:AlphaTo(0, 0.2, 0, function()
                                        BodyBackground:Remove()
                                    end)

                                    surface.PlaySound(mp.Sound.ROLLUP_2)
                                end

                                return
                            end

                            net.Start("mp.bodygroup_team")
                            net.WriteString("DeletePrest")
                            net.WriteUInt(SelectPreset, 8)
                            net.SendToServer()

                            if IsValid(BodyBackground) then
                                BodyBackground:AlphaTo(0, 0.2, 0, function()
                                    BodyBackground:Remove()
                                end)

                                surface.PlaySound(mp.Sound.ROLLUP_2)
                            end
                        end,
                        function(text) end
                    )
                end
            end
        end

        if not access then return end

        local BodyScroll = vgui.Create("DScrollPanel", BodyPanel)
        BodyScroll:Dock(FILL)
        BodyScroll.Hover = 0
        BodyScroll.VBar:SetWide(5)

        local sbar = BodyScroll:GetVBar()
        sbar:SetHideButtons(true)

        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
        end

        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
        end

        function BodyScroll:Paint(w, h)
            local x, y = self:LocalCursorPos()
            local w, h = self:GetWide(), self:GetTall()

            if x < w and x > 0 and y < h and y > 0 then
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end

            self.VBar:SetAlpha(self.Hover)
        end

        local SaveBtn = vgui.Create("DButton", BodyPanel)
        SaveBtn:Dock(BOTTOM)
        SaveBtn:SetTall(44)
        SaveBtn:DockMargin(10, 10, 10, 10)
        SaveBtn:SetText("")
        SaveBtn.Hover = 0
        SaveBtn.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText("Сохранить", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
                1)
            draw.SimpleText("Сохранить", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
        end

        SaveBtn.DoClick = function(self)
            if not SelectPreset and SelectModel then
                Derma_StringRequest(
                    "Сохранение",
                    "Укажите название нового пресета для " .. models[SelectModel].name,
                    "от 8 до 32 символов",
                    function(text)
                        local len = utf8.len(text)

                        if len > 32 then
                            mp.util.Notify(NOTIFY_ERROR,
                                "Максимальная длина названия " .. 32 .. " символа!")

                            if IsValid(BodyBackground) then
                                BodyBackground:AlphaTo(0, 0.2, 0, function()
                                    BodyBackground:Remove()
                                end)

                                surface.PlaySound(mp.Sound.ROLLUP_2)
                            end

                            return
                        elseif len < 8 then
                            mp.util.Notify(NOTIFY_ERROR, "Минимальная длина названия " .. 8 .. " символов!")

                            if IsValid(BodyBackground) then
                                BodyBackground:AlphaTo(0, 0.2, 0, function()
                                    BodyBackground:Remove()
                                end)

                                surface.PlaySound(mp.Sound.ROLLUP_2)
                            end

                            return
                        end

                        local t = {
                            name = text,
                            faction = faction,
                            model = models[SelectModel].model,
                            skin = ChooseModel.Entity:GetSkin(),
                            body = SelectBody
                        }

                        net.Start("mp.bodygroup_team")
                        net.WriteString("AddPreset")
                        net.WriteString(t.name)
                        net.WriteString(t.faction)
                        net.WriteString(t.model)
                        net.WriteUInt(t.skin or 0, 8)
                        net.WriteUInt(table.Count(t.body), 8)
                        for k, v in pairs(t.body) do
                            net.WriteUInt(k, 8)
                            net.WriteUInt(v, 8)
                        end
                        net.SendToServer()

                        if IsValid(BodyBackground) then
                            BodyBackground:AlphaTo(0, 0.2, 0, function()
                                BodyBackground:Remove()
                            end)

                            surface.PlaySound(mp.Sound.ROLLUP_2)
                        end
                    end,
                    function(text) end
                )
            else
                if not Preset[SelectPreset] then return end

                Derma_StringRequest(
                    "Изменение",
                    "Укажите новое название, если необходимо!",
                    Preset[SelectPreset].name,
                    function(text)
                        local len = utf8.len(text)

                        if len > 32 then
                            mp.util.Notify(NOTIFY_ERROR,
                                "Максимальная длина названия " .. 32 .. " символа!")

                            if IsValid(BodyBackground) then
                                BodyBackground:AlphaTo(0, 0.2, 0, function()
                                    BodyBackground:Remove()
                                end)

                                surface.PlaySound(mp.Sound.ROLLUP_2)
                            end

                            return
                        elseif len < 8 then
                            mp.util.Notify(NOTIFY_ERROR, "Минимальная длина названия " .. 8 .. " символов!")

                            if IsValid(BodyBackground) then
                                BodyBackground:AlphaTo(0, 0.2, 0, function()
                                    BodyBackground:Remove()
                                end)

                                surface.PlaySound(mp.Sound.ROLLUP_2)
                            end

                            return
                        end

                        local t = {
                            skin = ChooseModel.Entity:GetSkin(),
                            body = SelectBody
                        }

                        net.Start("mp.bodygroup_team")
                        net.WriteString("ChangePreset")
                        net.WriteUInt(SelectPreset, 8)
                        net.WriteString(text)
                        net.WriteUInt(t.skin or 0, 8)
                        net.WriteUInt(table.Count(t.body), 8)
                        for k, v in pairs(t.body) do
                            net.WriteUInt(k, 8)
                            net.WriteUInt(v, 8)
                        end
                        net.SendToServer()

                        if IsValid(BodyBackground) then
                            BodyBackground:AlphaTo(0, 0.2, 0, function()
                                BodyBackground:Remove()
                            end)

                            surface.PlaySound(mp.Sound.ROLLUP_2)
                        end
                    end,
                    function(text) end
                )
            end
        end

        local skinCount = ChooseModel.Entity:SkinCount()
        SelectSkin = ChooseModel.Entity:GetSkin()

        local skincount = vgui.Create("DLabel", BodyScroll)
        skincount:Dock(TOP)
        skincount:SetText("Скины: " .. skinCount)
        skincount:SetFont(text_font)
        skincount:DockMargin(10, 50, 10, 0)
        skincount:SetContentAlignment(5)

        local panelSkin = vgui.Create("Panel", BodyScroll)
        panelSkin:Dock(TOP)
        panelSkin:DockMargin(10, 5, 10, 0)
        panelSkin:SetTall(44)
        function panelSkin:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)
        end

        local skinEntry = vgui.Create("DTextEntry", panelSkin)
        skinEntry:Dock(FILL)
        skinEntry:DockMargin(5, 5, 5, 5)
        skinEntry:SetPaintBorderEnabled(true)
        skinEntry:SetFont(search_font)
        skinEntry:SetVisible(true)
        skinEntry:SetAllowNonAsciiCharacters(true)
        skinEntry:SetText(SelectSkin)
        skinEntry:SetNumeric(true)
        skinEntry.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
        end

        skinEntry.OnChange = function(s)
            local val = tonumber(s:GetValue() or 0)

            if not val then return end
            if val > skinCount then
                s:SetText(skinCount)

                SelectSkin = skinCount
                ChooseModel.Entity:SetSkin(SelectSkin)

                return
            end

            if val <= 0 then
                s:SetText(1)
                SelectSkin = 1
                ChooseModel.Entity:SetSkin(SelectSkin)

                return
            end

            SelectSkin = val
            ChooseModel.Entity:SetSkin(SelectSkin)
        end

        local AddSkin = vgui.Create("DButton", panelSkin)
        AddSkin:Dock(RIGHT)
        AddSkin:SetWide(32)
        AddSkin:DockMargin(5, 5, 5, 5)
        AddSkin:SetText("▶")
        AddSkin:SetColor(Color(0, 0, 0, 0))
        AddSkin.Hover = 0
        AddSkin.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 100)
            end

            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

            surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1,
                1)
            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
        end

        AddSkin.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        AddSkin.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)

            SelectSkin = SelectSkin + 1

            if SelectSkin > skinCount then
                SelectSkin = skinCount
            end

            skinEntry:SetText(SelectSkin)
            ChooseModel.Entity:SetSkin(SelectSkin)
        end

        local TakeSkin = vgui.Create("DButton", panelSkin)
        TakeSkin:Dock(LEFT)
        TakeSkin:SetWide(32)
        TakeSkin:DockMargin(5, 5, 5, 5)
        TakeSkin:SetText("◀")
        TakeSkin:SetColor(Color(0, 0, 0, 0))
        TakeSkin.Hover = 0
        TakeSkin.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 100)
            end

            draw.RoundedBox(0, 0, 0, w, h, C_B_100)
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

            surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover), 1,
                1)
            draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
        end

        TakeSkin.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.HOVER)
        end

        TakeSkin.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)

            SelectSkin = SelectSkin - 1

            if SelectSkin < 1 then
                SelectSkin = 1
            end

            skinEntry:SetText(SelectSkin)
            ChooseModel.Entity:SetSkin(SelectSkin)
        end

        for k, v in pairs(ChooseModel.Entity:GetBodyGroups()) do
            SelectBody[v.id] = ChooseModel.Entity:GetBodygroup(v.id)

            local bodygroupTitle = vgui.Create("DLabel", BodyScroll)
            bodygroupTitle:Dock(TOP)
            bodygroupTitle:SetText(v.name .. ": " .. v.num)
            bodygroupTitle:SetFont(text_font)
            bodygroupTitle:DockMargin(10, 10, 10, 0)
            bodygroupTitle:SetContentAlignment(5)

            local bodygroupPanel = vgui.Create("Panel", BodyScroll)
            bodygroupPanel:Dock(TOP)
            bodygroupPanel:DockMargin(10, 5, 10, 0)
            bodygroupPanel:SetTall(44)
            function bodygroupPanel:Paint(w, h)
                draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)
            end

            local bodyEntry = vgui.Create("DTextEntry", bodygroupPanel)
            bodyEntry:Dock(FILL)
            bodyEntry:DockMargin(5, 5, 5, 5)
            bodyEntry:SetPaintBorderEnabled(true)
            bodyEntry:SetFont(search_font)
            bodyEntry:SetVisible(true)
            bodyEntry:SetAllowNonAsciiCharacters(true)
            bodyEntry:SetText(SelectBody[v.id])
            bodyEntry:SetNumeric(true)
            bodyEntry.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                self:DrawTextEntryText(mp.Color.BASE, mp.Color.BASE_TO, mp.Color.WHITE)
            end

            bodyEntry.OnChange = function(s)
                local val = s:GetValue() or 0
                val = tonumber(val)

                if not val then return end
                if val > v.num then
                    s:SetText(v.num)

                    SelectBody[v.id] = v.num
                    ChooseModel.Entity:SetBodygroup(v.id, SelectBody[v.id])

                    return
                end

                if val <= 0 then
                    s:SetText(0)

                    SelectBody[v.id] = 0
                    ChooseModel.Entity:SetBodygroup(v.id, SelectBody[v.id])

                    return
                end

                SelectBody[v.id] = val
                ChooseModel.Entity:SetBodygroup(v.id, SelectBody[v.id])
            end

            local AddBody = vgui.Create("DButton", bodygroupPanel)
            AddBody:Dock(RIGHT)
            AddBody:SetWide(32)
            AddBody:DockMargin(5, 5, 5, 5)
            AddBody:SetText("▶")
            AddBody:SetColor(Color(0, 0, 0, 0))
            AddBody.Hover = 0
            AddBody.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 100)
                end

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

                surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
                surface.DrawOutlinedRect(0, 0, w, h, 1)

                draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover),
                    1,
                    1)
                draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
            end

            AddBody.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            AddBody.DoClick = function(self)
                surface.PlaySound(mp.Sound.CLICK_2)

                SelectBody[v.id] = SelectBody[v.id] + 1

                if SelectBody[v.id] > v.num then
                    SelectBody[v.id] = v.num
                end

                bodyEntry:SetText(SelectBody[v.id])
                ChooseModel.Entity:SetBodygroup(v.id, SelectBody[v.id])
            end

            local TakeBody = vgui.Create("DButton", bodygroupPanel)
            TakeBody:Dock(LEFT)
            TakeBody:SetWide(32)
            TakeBody:DockMargin(5, 5, 5, 5)
            TakeBody:SetText("◀")
            TakeBody:SetColor(Color(0, 0, 0, 0))
            TakeBody.Hover = 0
            TakeBody.Paint = function(self, w, h)
                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 100)
                end

                draw.RoundedBox(0, 0, 0, w, h, C_B_100)
                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

                surface.SetDrawColor(ColorAlpha(mp.Color.BASE, self.Hover / 2))
                surface.DrawOutlinedRect(0, 0, w, h, 1)

                draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, 255 - self.Hover),
                    1,
                    1)
                draw.SimpleText(self:GetText(), search_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, self.Hover), 1, 1)
            end

            TakeBody.OnCursorEntered = function()
                surface.PlaySound(mp.Sound.HOVER)
            end

            TakeBody.DoClick = function(self)
                surface.PlaySound(mp.Sound.CLICK_2)

                SelectBody[v.id] = SelectBody[v.id] - 1

                if SelectBody[v.id] < 0 then
                    SelectBody[v.id] = 0
                end

                bodyEntry:SetText(SelectBody[v.id])
                ChooseModel.Entity:SetBodygroup(v.id, SelectBody[v.id])
            end
        end
    end

    local BottomPanel = vgui.Create("Panel", BodyBackground)
    BottomPanel:Dock(BOTTOM)
    BottomPanel:SetTall(42)
    BottomPanel:DockMargin(50, 20, 50, 20)

    local ExitBtn = vgui.Create("DButton", BottomPanel)
    ExitBtn:Dock(LEFT)
    ExitBtn:SetWide(125)
    ExitBtn:DockMargin(0, 0, 0, 0)
    ExitBtn:SetText("")
    ExitBtn.Hover = 0
    ExitBtn.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
        end

        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

        surface.SetDrawColor(self:IsHovered() and ColorOutline or ColorClose)
        surface.DrawOutlinedRect(0, 0, w, h, 1)

        draw.SimpleText("F1 | Закрыть", n_font2, w / 2, h / 2, ColorAlpha(ColorClose, 150 - self.Hover), 1,
            1)
        draw.SimpleText("F1 | Закрыть", n_font2, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
    end

    ExitBtn.DoClick = function(self)
        if IsValid(BodyBackground) then
            BodyBackground:AlphaTo(0, 0.2, 0, function()
                BodyBackground:Remove()
            end)

            surface.PlaySound(mp.Sound.ROLLUP_2)
        end
    end
end)
