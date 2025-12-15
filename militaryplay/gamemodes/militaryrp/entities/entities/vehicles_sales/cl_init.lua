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

local t_font = mp.font("100:Gamestation Condensed")

function ENT:Draw()
    self:DrawModel()

    if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
        local Ang = LocalPlayer():GetAngles()

        Ang:RotateAroundAxis(Ang:Forward(), 90)
        Ang:RotateAroundAxis(Ang:Right(), 90)

        cam.Start3D2D(self:GetPos() + self:GetUp() * 45, Ang, 0.05)
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)
        mp.Text("Парк техники", t_font, 0, 0, ColorAlpha(mp.Color.WHITE, alpha), 1, 0)
        render.PopFilterMin()
        cam.End3D2D()
    end
end

local exit_text = "× Закрыть"
local title_text = "Парк техники"
local teams_text = "Экипаж:"
local driver_text = "Экипаж: водитель"
local operator_text = "Экипаж: водитель, оператор орудия"
local commander_text = "Экипаж: водитель, оператор орудия, командир"
local settings_text = "Основные характеристики"
local seats_text = "Вместимость"
local weapons_text = "Оружие"
local pweapon_text = "Основное: "
local sweapon_text = "Второстепенное: "
local cweapon_text = "Командирское: "
local return_text = "ВЕРНУТЬ"
local select_text = "ВЫБРАТЬ"

local goback_font = mp.font("30:Futura PT Light")
local title_font = mp.font("70:Futura PT Light")
local cat_font = mp.font("20:DIN Pro Regular")
local name_font = mp.font("25:Rostelecom Basis Light")
local number_font = mp.font("100:mr_ApexMk3MediumG")
local settings_font = mp.font("26:Rostelecom Basis Light")
local seats_font = mp.font("25:DIN Pro Regular")
local teams_font = mp.font("24:Futura PT Light")

local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)

local C_W_5 = ColorAlpha(mp.Color.WHITE, 5)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)

local C_GR_100 = ColorAlpha(mp.Color.GREEN, 100)
local C_BL_100 = ColorAlpha(mp.Color.YELLOW, 100)
local C_R_100 = ColorAlpha(mp.Color.RED, 100)

local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
local C_BS_100 = ColorAlpha(mp.Color.BASE, 100)


netstream.Hook("VehiclesSales_OpenMenu", function(data)
    if not LocalPlayer():Alive() then return end

    local TableNumber = {}
    local ply = LocalPlayer()
    local f = ply:GetNetVar("meta_features")

    if IsValid(VEH_BACKGROUND) then
        VEH_BACKGROUND:AlphaTo(0, 0.3, 0, function()
            VEH_BACKGROUND:Remove()
        end)

        surface.PlaySound(mp.Sound.DEPLOY_2)

        return
    end

    local scrw, scrh = ScrW(), ScrH()

    local VehBackground = vgui.Create("DFrame")
    VEH_BACKGROUND = VehBackground
    VEH_BACKGROUND:SetTitle("")
    VEH_BACKGROUND:SetSize(scrw, scrh)
    VEH_BACKGROUND:SetPos(0, 0)
    VEH_BACKGROUND:MakePopup()
    VEH_BACKGROUND:ShowCloseButton(false)
    VEH_BACKGROUND:SetVisible(true)
    VEH_BACKGROUND:SetDraggable(false)
    VEH_BACKGROUND:SetAlpha(0)
    VEH_BACKGROUND:AlphaTo(255, 0.5, 0)
    VEH_BACKGROUND.Paint = function(self, w, h)
        mp.BlurBG(self, 2)

        draw.RoundedBox(0, 0, 0, w, h, C_B_200)
    end

    local GoExit = vgui.Create("DButton", VEH_BACKGROUND)
    GO_EXIT = GoExit
    GO_EXIT:SetSize(100, 30)
    GO_EXIT:SetPos(10, 10)
    GO_EXIT:SetText("")
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
        VEH_BACKGROUND:AlphaTo(0, 0.1, 0, function()
            VEH_BACKGROUND:Remove()
        end)
    end

    local VehHat = vgui.Create("DPanel", VEH_BACKGROUND)
    VEH_HAT = VehHat
    VEH_HAT:SetSize(1024, 720)
    VEH_HAT:SetPos(scrw / 2 - 512, scrh / 2 - 360)
    VEH_HAT.Paint = function(self, w, h)
        mp.Text(title_text, title_font, w / 2, 2, mp.Color.WHITE, 1, 0)
    end

    local VehScroll = vgui.Create("DScrollPanel", VEH_HAT)
    VEH_SCROLL = VehScroll
    VEH_SCROLL:SetSize(1024, 620)
    VEH_SCROLL:SetPos(0, 100)
    VEH_SCROLL.Hover = 0
    VEH_SCROLL.VBar:SetWide(5)
    VEH_SCROLL.Paint = function(self, w, h)
        local x, y = self:LocalCursorPos()
        local w, h = self:GetWide(), self:GetTall()

        if x < w and x > 0 and y < h and y > 0 then
            self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
        else
            self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
        end

        self.VBar:SetAlpha(self.Hover)
    end
    local sbar = VEH_SCROLL:GetVBar()
    sbar:SetHideButtons(true)

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, C_B_100)
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
    end

    for veh, val in SortedPairs(mp.vehicle[f]) do
        table.insert(TableNumber, veh)

        local Veh = list.Get("simfphys_vehicles")[veh]
        if not Veh then continue end
        local VehName = Veh.Name
        local VehModel = Veh.Model
        local VehCategory = Veh.Category
        local number = "0" .. table.KeyFromValue(TableNumber, veh)

        local BtnVehicle = vgui.Create("DPanel", VEH_SCROLL)
        BTN_VEHICLE = BtnVehicle
        BTN_VEHICLE:Dock(TOP)
        BTN_VEHICLE:SetTall(256)
        BTN_VEHICLE:DockMargin(0, 0, 5, 8)
        BTN_VEHICLE:SetText("")
        BTN_VEHICLE:IsVisible()
        BTN_VEHICLE.Hover = 0
        BTN_VEHICLE.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
            draw.RoundedBox(0, 0, 0, 1, h, C_W_25)
            draw.RoundedBox(0, w - 1, 0, 1, h, C_W_25)

            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
            mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)

            mp.Icon(0, 0, w / 2, 1, mp.Material.GRADIENT_L, C_W_25)
            mp.Icon(0, h - 1, w / 2, 1, mp.Material.GRADIENT_L, C_W_25)
            mp.Icon(w / 2, 0, w / 2, 1, mp.Material.GRADIENT_R, C_W_25)
            mp.Icon(w / 2, h - 1, w / 2, 1, mp.Material.GRADIENT_R, C_W_25)

            mp.Text(VehName, name_font, 20, 25, mp.Color.ORANGE, 0, 1)
            mp.Text(VehCategory, cat_font, 20, 45, mp.Color.BASE, 0, 1)
            mp.Text(number, number_font, 25, h / 2, C_W_5, 0, 1)

            mp.Text(settings_text, settings_font, w / 1.5, 25, C_W_25, 0, 1)
            mp.Text(seats_text, seats_font, w / 2, 47, C_W_100, 0, 1)

            if val.driver then
                teams_text = driver_text
            end

            if val.operator then
                teams_text = operator_text
            end

            if val.commander then
                teams_text = commander_text
            end

            mp.Text(teams_text, teams_font, w / 2, h / 2 - 23, C_BL_100, 0, 1)

            if val.pweapon then
                mp.Text(weapons_text, seats_font, w / 2, h / 2, C_W_100, 0, 0)
                mp.Text(pweapon_text .. val.pweapon, teams_font, w / 2, h / 2 + 23, C_BS_100, 0, 0)

                if val.sweapon then
                    mp.Text(sweapon_text .. val.sweapon, teams_font, w / 2, h / 2 + 43, C_BS_100, 0, 0)
                end

                if val.tweapon then
                    mp.Text(cweapon_text .. val.tweapon, teams_font, w / 2, h / 2 + 63, C_BS_100, 0, 0)
                end
            end

            for i = 1, val.seats do
                mp.Icon(-28 + w / 2 + i * 28, 66, 24, 24, mp.Material.SEATS, C_B_200)
            end
        end

        local DModel = vgui.Create("DModelPanel", BTN_VEHICLE)
        D_MODEL = DModel
        D_MODEL:SetModel(VehModel)
        D_MODEL:SetPos(1, 0)
        D_MODEL:SetSize(512, 256)
        D_MODEL:SetFOV(90)
        D_MODEL.Angles = Angle(0, 50, 0)
        D_MODEL:SetCamPos(Vector(150, 150, 90))
        function D_MODEL:LayoutEntity(ent)
            ent:SetPos(Vector(-60, 25, 0))
        end

        local CreateVeh = vgui.Create("DButton", BTN_VEHICLE)
        CREATE_VEH = CreateVeh
        CREATE_VEH:SetSize(128, 32)
        CREATE_VEH:SetPos(10, BTN_VEHICLE:GetTall() - 42)
        CREATE_VEH:SetText("")
        CREATE_VEH:SetVisible(true)
        CREATE_VEH.Hover = 0
        CREATE_VEH.Paint = function(self, w, h)
            local Owner = ply:GetNWEntity("Owner")

            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 25)
            else
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

            if Owner != NULL and Owner:GetSpawn_List() == veh then
                mp.Text(return_text, cat_font, w / 2, h / 2, C_GR_100, 1, 1)
                surface.SetDrawColor(C_GR_100)
            elseif Owner != NULL and Owner:GetSpawn_List() != veh then
                mp.Text(select_text, cat_font, w / 2, h / 2, C_R_100, 1, 1)
                surface.SetDrawColor(C_R_100)
            else
                mp.Text(select_text, cat_font, w / 2, h / 2, C_W_100, 1, 1)
                surface.SetDrawColor(C_W_100)
            end

            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        CREATE_VEH.DoClick = function(self)
            local Owner = ply:GetNWEntity("Owner")

            if Owner != NULL and Owner:GetSpawn_List() == veh then
                netstream.Start("VehiclesSales_ReturnVehicle", { class = Owner })
            elseif Owner == NULL then
                local SpawnPoint = table.Random(mp.VEHICLES_SPAWNPOINT[f])

                netstream.Start("VehiclesSales_SpawnVehicle", { class = veh, point = SpawnPoint })
            end
        end
    end
end)
