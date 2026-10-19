include("shared.lua")

SWEP.PrintName = "Наручники"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

local mp = mp
local ColorAlpha = ColorAlpha
local surface = surface
local draw = draw
local net = net

local SetClipboardText = SetClipboardText
local Color = Color
local vgui = vgui
local Lerp = Lerp
local FrameTime = FrameTime
local Vector, Angle = Vector, Angle

local btn_font = mp.font("22:Futura PT Medium")

local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
local C_B_T_150 = ColorAlpha(mp.Color.BASE_TO, 150)

local text_help = "Нажмите [Е] для взаимодействия"


local btn = {
    {
        name = function(pl)
            return (not pl:isCarried()) and "Вести за собой" or "Прекратить вести"
        end,
        func = function(pl)
            net.Start("mp.HandCuff.Carry")
            net.SendToServer()
        end
    },

    {
        name = function(pl)
            return "Осмотреть документы"
        end,
        func = function(pl)
            net.Start("mp.HandCuff.ShowInfo")
            net.SendToServer()
        end
    },

    {
        name = function(pl)
            return "Обыскать"
        end,
        func = function(pl)
            net.Start("mp.HandCuff.Checker")
            net.SendToServer()
        end
    }
}

local fr
local function OpenMenu(pl)
    if IsValid(fr) then
        fr:Remove()
    end

    local scrw, scrh = ScrW(), ScrH()

    fr = vgui.Create("EditablePanel")
    fr:MakePopup()
    fr:SetSize(360, 180)
    fr:SetPos(scrw / 2 - fr:GetWide() / 2, scrh / 2 - fr:GetTall() / 2)
    fr:SetAlpha(0)
    fr:AlphaTo(255, 0.25, 0)
    fr.TitleText = "Управление: " .. pl:Name()
    function fr:Paint(w, h)
        mp.paint:Main(self, w, h)
    end

    mp.paint:CloseButton(fr)

    local parent = vgui.Create("Panel", fr)
    parent:Dock(FILL)
    parent:DockMargin(0, 40, 0, 0)

    for k, v in ipairs(btn) do
        local BtnPanel = vgui.Create("DButton", parent)
        BtnPanel:Dock(TOP)
        BtnPanel:SetTall(40)
        BtnPanel:DockMargin(5, 5, 5, 0)
        BtnPanel:SetText("")
        BtnPanel:SetVisible(true)
        BtnPanel.Paint = function(self, w, h)
            BtnPanel.TitleText = v.name(pl)
            mp.paint:Button(self, w, h)
        end

        BtnPanel.OnCursorEntered = function()
            surface.PlaySound(mp.Sound.CLICK)
        end

        BtnPanel.DoClick = function(self)
            surface.PlaySound(mp.Sound.CLICK_2)

            v.func(pl)

            fr:AlphaTo(0, 0.2, 0, function()
                fr:Remove()
            end)
        end
    end
end

local cd = 0
function SWEP:DrawHUD()
    local lp = self.Owner
    local pl = lp:GetEyeTrace().Entity

    local w, h = ScrW(), ScrH()

    if not pl:IsPlayer() or not pl:isHandcuffed() or pl:GetPos():Distance(lp:GetPos()) > 150 then return end

    surface.SetFont(btn_font)
    local t_w, t_h = surface.GetTextSize(text_help)

    t_w, t_h = t_w + 15, t_h + 10

    draw.RoundedBox(0, w / 2 - t_w / 2, h / 2 - t_h / 2, t_w, t_h, C_B_150)

    mp.Icon(w / 2 - t_w / 2, h / 2 - t_h / 2, t_w, t_h, mp.Material.GRADIENT_D, C_B_T_150)

    mp.Text(text_help, btn_font, w / 2, h / 2, mp.Color.BASE, 1, 1)

    if input.IsKeyDown(KEY_E) and cd < CurTime() then
        OpenMenu(pl)
        cd = CurTime() + 1
    end
end
