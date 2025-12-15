local LerpEXP, GetExp, CoutEXP = 0, 0, 0
local Timer = 100
local mp = mp
local Color = Color
local net = net
local ColorAlpha = ColorAlpha
local Lerp = Lerp
local vgui = vgui
local draw = draw
local surface = surface

local backgroundColor = Color(35, 35, 35)

local dmg_indicator = "〔   〕"
local plus_text = "+"
local exp_text = "+exp "
local level_text = "Новый уровень: "
local slash = "|"

local damage_font = mp.font("25:mr_ApexMk3MediumG")
local exp_font = mp.font("25:Futura PT Medium")
local exp_text_font = mp.font("30:mr_ApexMk3MediumG")
local level_font = mp.font("30:Futura PT Light")
local LvlNumFont = mp.font("35:Gobold CYR-LAT")
local ExpNumFont = mp.font("18:DIN Pro Regular")
local NameFont = mp.font("25:Futura PT Light")
local descFont = mp.font("16:Montserrat Light")

net.Receive("AddPlayerEXP", function()
    local scrw, scrh = ScrW(), ScrH()
    local exp = net.ReadInt(18)
    local kill = net.ReadBool()

    local color = mp.Color.WHITE

    if kill then
        CoutEXP = CoutEXP + 1
    end

    GetExp = GetExp + exp
    Timer = 100

    if not LocalPlayer():Alive() then return end
    if IsValid(HIT_EFFECT) then HIT_EFFECT:Remove() end

    local HitEffect = vgui.Create("DPanel")
    HIT_EFFECT = HitEffect
    HIT_EFFECT:SetSize(48, 32)
    HIT_EFFECT:Center()
    HIT_EFFECT:SetAlpha(0)
    HIT_EFFECT:AlphaTo(255, 0.2, 0)
    HIT_EFFECT.Paint = function(self, w, h)
        if not LocalPlayer():Alive() then self:Remove() end

        Timer = Timer - 1

        if Timer <= 50 then
            self:AlphaTo(0, 0.2, 0, function()
                self:Remove()
            end)
        end

        if kill then
            color = mp.Color.RED
        end

        mp.Text(dmg_indicator, damage_font, w / 2, h / 2, ColorAlpha(color, 50), 1, 1)
    end

    if IsValid(EXP_PANEL) then EXP_PANEL:Remove() end

    local ChoosePanel = vgui.Create("DPanel")
    EXP_PANEL = ChoosePanel
    EXP_PANEL:SetSize(128, 72)
    EXP_PANEL:SetPos(scrw - 256, scrh / 2 - 64)
    EXP_PANEL.Paint = function(self, w, h)
        LerpEXP = Lerp(FrameTime() * 5, LerpEXP, GetExp)

        if CoutEXP > 0 then
            mp.Icon(w / 2, 45, 16, 16, mp.Material.DEATH, mp.Color.WHITE)
            mp.Text(plus_text .. CoutEXP, exp_font, w / 2 - 5, 41, ColorAlpha(mp.Color.RED, 150), 2, 0)
        end

        mp.Text(exp_text .. math.Round(LerpEXP), exp_text_font, w / 2, 5, ColorAlpha(mp.Color.YELLOW, 150), 1, 0)
    end

    timer.Create("RefreshEXP", 5, 1, function()
        EXP_PANEL:AlphaTo(0, 0.4, 0)
        EXP_PANEL:MoveTo(scrw - 256, scrh / 2, 0.4, 0.1, 1, function()
            GetExp = 0
            CoutEXP = 0
        end)
    end)
end)

net.Receive("AddLevel", function()
    if IsValid(NEW_LEVEL) then NEW_LEVEL:Remove() end

    local NewLevel = vgui.Create("DPanel")
    NEW_LEVEL = NewLevel
    NEW_LEVEL:SetSize(224, 50)
    NEW_LEVEL:SetPos(ScrW() / 2 - 128, 50)
    NEW_LEVEL:SetAlpha(0)
    NEW_LEVEL:AlphaTo(255, 1, 0)
    NEW_LEVEL.Paint = function(self, w, h)
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.BLACK, 150))
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, ColorAlpha(mp.Color.BLACK, 125))

        mp.Icon(0, 0, w, 1, mp.Material.GRADIENT_R, ColorAlpha(mp.Color.BASE, 150))
        mp.Icon(w - 1, 0, 1, h, mp.Material.GRADIENT_U, ColorAlpha(mp.Color.BASE, 150))
        mp.Icon(0, h - 1, w, 1, mp.Material.GRADIENT_L, ColorAlpha(mp.Color.BASE, 150))
        mp.Icon(0, 0, 1, h, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.BASE, 150))

        mp.Text(level_text .. LocalPlayer():GetLevel(), level_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255), 1, 1)
    end

    timer.Create("RemoveNewLVL", 10, 1, function()
        NEW_LEVEL:AlphaTo(0, 0.8, 0, function()
            NEW_LEVEL:Remove()
        end)
    end)
end)

net.Receive("CreateLlvMenu", function()
    local scrw, scrh = ScrW(), ScrH()
    local ply = LocalPlayer()
    local Lvl = ply:GetLevel()
    local Exp = ply:GetExperience()
    local MaxExp = ply:GetNeedExperience()
    local Start = CurTime() + Lvl

    if LEVEL_PANEL then LEVEL_PANEL:Remove() end

    local LevelPanel = vgui.Create("EditablePanel")
    LEVEL_PANEL = LevelPanel
    LEVEL_PANEL:SetSize(scrw, 300)
    LEVEL_PANEL:SetPos(0, scrh - 300)
    LEVEL_PANEL:MakePopup()
    LEVEL_PANEL:SetAlpha(0)
    LEVEL_PANEL:AlphaTo(255, 0.3, 0.1)
    LEVEL_PANEL.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, backgroundColor)
    end

    LEVEL_PANEL.Think = function(self, w, h)
        if IsValid(LEVEL_PANEL) and not ply:Alive() then
            LEVEL_PANEL:AlphaTo(0, 0.25, 0, function()
                LEVEL_PANEL:Remove()
            end)
        end
    end

    LEVEL_PANEL.OnKeyCodePressed = function()
        if input.IsKeyDown(KEY_F4) then
            LEVEL_PANEL:AlphaTo(0, 0.25, 0, function()
                LEVEL_PANEL:Remove()
            end)
        end
    end

    local HScroll = vgui.Create("HorizontalScrollPanel", LEVEL_PANEL)
    H_SCROLL = HScroll
    H_SCROLL:Dock(FILL)
    H_SCROLL:SetTall(LEVEL_PANEL:GetTall())
    H_SCROLL:DockMargin(0, 0, 0, 0)
    H_SCROLL.Hover = 0

    function H_SCROLL.Scrollbar:OnMouseWheeled(delta)
        if not H_SCROLL.Scrollbar:IsVisible() then return false end

        Start = 0

        return H_SCROLL.Scrollbar:AddScroll(delta * -2)
    end

    local PERKS = PERKS or {}
    local MaterialLine = nil
    local ColorLine = nil
    local ColorTab = nil
    local ColorText = nil
    local ColorDesc = nil
    local PerkName = nil
    local LvlNum = nil

    local key
    for i = 1, 100 do
        for k = 1, #mp.Perks do
            if i == mp.Perks[k].level then
                key = k

                table.insert(PERKS, mp.Perks[k])
            end
        end

        if ! istable(PERKS[i]) then
            table.insert(PERKS, i)
        end
    end

    for k, v in ipairs(PERKS) do
        local Perks = vgui.Create("DLabel", H_SCROLL)
        Perks:SetText("")
        Perks:Dock(LEFT)
        Perks:SetWide(225)
        Perks:DockMargin(5, 5, 5, 5)
        Perks.Paint = function(self, w, h)
            local EXP = ply:GetExperience()
            local MaxEXP = ply:GetNeedExperience()

            EXP = math.Round(EXP * (w / MaxEXP))

            if istable(v) then
                if k == Lvl then
                    ColorLine = ColorAlpha(mp.Color.WHITE, 25)
                    ColorTab = ColorAlpha(mp.Color.ORANGE, 3)
                    ColorText = ColorAlpha(mp.Color.WHITE, 255)
                    ColorDesc = ColorAlpha(mp.Color.WHITE, 125)
                    MaterialLine = mp.Material.OPEN_PERKS
                    LvlNum = "▸  " .. k .. "  ◂"
                elseif k < Lvl then
                    ColorLine = ColorAlpha(mp.Color.BLUE, 125)
                    ColorTab = ColorAlpha(mp.Color.BLUE, 3)
                    ColorText = ColorAlpha(mp.Color.WHITE, 255)
                    ColorDesc = ColorAlpha(mp.Color.WHITE, 125)
                    MaterialLine = mp.Material.ADD_PERKS
                    LvlNum = k .. " ◂"
                else
                    ColorLine = ColorAlpha(mp.Color.WHITE, 25)
                    ColorTab = ColorAlpha(mp.Color.BASE_TO, 125)
                    ColorText = ColorAlpha(mp.Color.WHITE, 50)
                    ColorDesc = ColorAlpha(mp.Color.WHITE, 35)
                    MaterialLine = mp.Material.CLOSE_PERKS
                    LvlNum = "▹ " .. k
                end
            else
                if k == Lvl then
                    ColorLine = ColorAlpha(mp.Color.WHITE, 25)
                    ColorTab = ColorAlpha(mp.Color.ORANGE, 3)
                    ColorText = ColorAlpha(mp.Color.WHITE, 255)
                    ColorDesc = ColorAlpha(mp.Color.WHITE, 125)
                    MaterialLine = mp.Material.OPEN_PERKS
                    LvlNum = "▸  " .. k .. "  ◂"
                elseif k < Lvl then
                    ColorLine = ColorAlpha(mp.Color.GREEN, 125)
                    ColorTab = ColorAlpha(mp.Color.GREEN, 3)
                    ColorText = ColorAlpha(mp.Color.WHITE, 255)
                    ColorDesc = ColorAlpha(mp.Color.WHITE, 125)
                    MaterialLine = mp.Material.SKIP_PERKS
                    LvlNum = k .. " ◂"
                else
                    ColorLine = ColorAlpha(mp.Color.WHITE, 25)
                    ColorTab = ColorAlpha(mp.Color.BASE_TO, 125)
                    ColorText = ColorAlpha(mp.Color.WHITE, 50)
                    ColorDesc = ColorAlpha(mp.Color.WHITE, 35)
                    MaterialLine = mp.Material.CLOSE_PERKS
                    LvlNum = "▹ " .. k
                end
            end

            mp.Icon(5, 5, 220, 295, mp.Material.BACKGROUND_PERKS, mp.Color.BASE_TO)
            mp.Icon(0, 0, 76, 76, MaterialLine, mp.Color.WHITE)

            --mp.Icon( -100, -5, w+200, h, mp.Material.GRADIENT_C, ColorAlpha(ColorTab, 10) )

            draw.RoundedBox(0, 5, h - 4, w, 4, ColorLine)

            if k <= Lvl and not istable(v) then
                mp.Icon(w / 2 - 57, h / 3, 114, 136, mp.Material.UNLOCK, ColorAlpha(mp.Color.WHITE, 5))
            elseif k > Lvl and not istable(v) then
                mp.Icon(w / 2 - 57, h / 3, 114, 136, mp.Material.LOCK, ColorAlpha(mp.Color.WHITE, 25))
            end

            mp.Text(k, LvlNumFont, 20, 8, mp.Color.BLACK, 1, 0)

            if k == Lvl then
                mp.Text(Exp .. slash .. MaxExp, ExpNumFont, w / 2, h - 25, ColorAlpha(mp.Color.WHITE, 75), 1, 0)
                draw.RoundedBox(0, 5, h - 4, EXP - 5, 4, mp.Color.ORANGE)
            end

            if istable(v) then
                mp.Text(v.name, NameFont, w / 2, h / 2.1, color_white, 1, 0)
                mp.Icon(w / 2 - 38.5, 25, 77, 95, v.material, color_white)

                if v.desc then
                    local DescriptionTab = vgui.Create("DLabel", self)
                    DESCTRIPTION_TAB = DescriptionTab
                    DESCTRIPTION_TAB:SetSize(210, 240)
                    DESCTRIPTION_TAB:SetPos(10, self:GetTall() / 2 + 25)
                    DESCTRIPTION_TAB:SetFont(descFont)
                    DESCTRIPTION_TAB:SetVisible(true)
                    DESCTRIPTION_TAB:SetText(textWrap(v.desc, descFont, 210))
                    DESCTRIPTION_TAB:SetContentAlignment(5)
                    DESCTRIPTION_TAB:SetAutoStretchVertical(true)
                    DESCTRIPTION_TAB:SetTextColor(ColorDesc)
                    DESCTRIPTION_TAB.Paint = function(self, w, h)
                        if IsValid(self) then self:Remove() end
                    end
                end
            end
        end

        Perks.Think = function()
            local x, y = H_SCROLL.CanvasPanel:GetChildPosition(Perks)
            if k == Lvl and Start >= CurTime() then
                H_SCROLL.Hover = Lerp(FrameTime() * 2, H_SCROLL.Hover, x)

                if Start >= CurTime() then
                    H_SCROLL.Scrollbar:SetScroll(math.Round(H_SCROLL.Hover))
                end
            end
        end

        H_SCROLL:AddItem(Perks)
    end

    local LShadow = vgui.Create("DPanel", LEVEL_PANEL)
    L_SHADOW = LShadow
    L_SHADOW:SetSize(25, LEVEL_PANEL:GetTall())
    L_SHADOW:SetPos(0, 0)
    L_SHADOW.Paint = function(self, w, h)
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_L, ColorAlpha(mp.Color.BLACK, 255))
    end

    local RShadow = vgui.Create("DPanel", LEVEL_PANEL)
    R_SHADOW = RShadow
    R_SHADOW:SetSize(25, LEVEL_PANEL:GetTall())
    R_SHADOW:SetPos(LEVEL_PANEL:GetWide() - 25, 0)
    R_SHADOW.Paint = function(self, w, h)
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, ColorAlpha(mp.Color.BLACK, 255))
    end
end)
