local mp = mp

mp.paint = {}

local ColorAlpha = ColorAlpha
local surface = surface
local draw = draw
local Lerp = Lerp
local FrameTime = FrameTime
local IsValid = IsValid

local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_B_100 = ColorAlpha(mp.Color.BASE, 100)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_B_T_100 = ColorAlpha(mp.Color.BASE_TO, 100)

local title_font = mp.font("20:DIN Pro Regular")
local btn_font = mp.font("20:Futura PT Medium")

function mp.paint:Main(s, w, h)
    mp.PanelBlur(s, 4)

    draw.RoundedBox(0, 0, 0, w, h, C_B_200)
    draw.RoundedBox(0, 0, 0, w, 40, mp.Color.BASE_TO)

    mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_D, C_B_25)
    mp.Icon(0, 0, w, 40, mp.Material.GRADIENT_L, C_B_10)
    mp.Icon(0, 40, w, 10, mp.Material.GRADIENT_U, C_B_150)

    if s.TitleText then
        mp.Text(s.TitleText, title_font, w / 2, 20, mp.Color.BASE, 1, 1)
    end
end

function mp.paint:Button(s, w, h)
    s.Hover = s.Hover or 0

    if s:IsHovered() then
        s.Hover = Lerp(FrameTime() * 15, s.Hover, 255)
    else
        s.Hover = Lerp(FrameTime() * 10, s.Hover, 0)
    end

    draw.RoundedBox(0, 0, 0, w, h, C_B_T_100)

    mp.Icon(0, 1, w, h - 1, mp.Material.GRADIENT_D, C_B_10)

    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, s.Hover))

    if s.TitleText then
        mp.Text(s.TitleText, btn_font, w / 2, h / 2, mp.Color.BASE, 1, 1)
        mp.Text(s.TitleText, btn_font, w / 2, h / 2, ColorAlpha(mp.Color.BLACK, s.Hover), 1, 1)
    end
end

function mp.paint:CloseButton(s)
    local pnl = vgui.Create("DButton", s)
    pnl:SetSize(20, 20)
    pnl:SetText("")
    pnl.Hover = 0
    pnl:SetPos(s:GetWide() - pnl:GetWide() - 15, 10)
    pnl.Paint = function(self, w, h)
        if self:IsHovered() then
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 200)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 75)
        end

        mp.Icon(0, 0, 20, 20, mp.Material.CLOSE, ColorAlpha(mp.Color.BASE, self.Hover))
    end

    pnl.OnCursorEntered = function()
        surface.PlaySound(mp.Sound.CLICK)
    end

    pnl.DoClick = function()
        if IsValid(s) then
            s:AlphaTo(0, 0.2, 0, function()
                s:Remove()
            end)

            surface.PlaySound(mp.Sound.CLICK_10)
        end
    end
end
