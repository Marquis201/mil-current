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
local left_text = "<"
local right_text = ">"

local goback_font = mp.font("30:Futura PT Light")
local title_font = mp.font("70:Futura PT Light")
local cat_font = mp.font("20:DIN Pro Regular")
local name_font = mp.font("25:Futura PT Book")
local number_font = mp.font("100:mr_ApexMk3MediumG")
local settings_font = mp.font("26:Futura PT Light")
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
    local profession = ply:GetNetVar("meta_features")

    if IsValid(VEH_BACKGROUND) then
        VEH_BACKGROUND:Remove()
    end

    if not profession then return end

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

    local VehHat = vgui.Create("DPanel", VEH_BACKGROUND)
    VEH_HAT = VehHat
    VEH_HAT:SetSize(1024, 720)
    VEH_HAT:SetPos(scrw / 2 - 512, scrh / 2 - 360)
    VEH_HAT.Paint = function(self, w, h)
        mp.Text(title_text, title_font, w / 2, 2, mp.Color.WHITE, 1, 0)
    end


    local GoExit = vgui.Create("DButton", VEH_BACKGROUND)
    GO_EXIT = GoExit
    GO_EXIT:SetSize(100, 30)
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
    GO_EXIT:SetPos(VehHat:GetX(), VehHat:GetY())

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

    local number = 0
    for veh, val in pairs(mp.config.vehicles) do
        table.insert(TableNumber, veh)
        local Veh = scripted_ents.Get(veh)
        if not Veh then continue end

        if not val[1] or not val[1].profession or not val[1].profession[profession] then continue end

        local VehName = Veh.PrintName
        local VehModel = Veh.MDL
        local VehCategory = Veh.Category
        local parameter = mp.config.vehicle_info[veh]
        local selectVeh = 1

        number = number + 1

        local BtnVehicle = vgui.Create("DPanel", VEH_SCROLL)
        BTN_VEHICLE = BtnVehicle
        BTN_VEHICLE:Dock(TOP)
        BTN_VEHICLE:SetTall(256)
        BTN_VEHICLE:DockMargin(0, 0, 5, 8)
        BTN_VEHICLE:SetText("")
        BTN_VEHICLE:IsVisible()
        BTN_VEHICLE.Hover = 0
        BTN_VEHICLE.id = number
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

            mp.Text(VehName, name_font, 15, 20, mp.Color.WHITE, 0, 1)
            mp.Text(VehCategory, cat_font, 15, 40, mp.Color.BASE, 0, 1)
            mp.Text( "0" .. self.id, number_font, 25, h / 2, C_W_5, 0, 1)

            mp.Text(settings_text, settings_font, w / 1.5, 25, C_W_25, 0, 1)
            mp.Text(seats_text, seats_font, w / 2, 47, C_W_100, 0, 1)


            teams_text = driver_text


            if parameter.operator then
                teams_text = operator_text
            end

            if parameter.commander then
                teams_text = commander_text
            end

            mp.Text(teams_text, teams_font, w / 2, h / 2 - 23, C_BL_100, 0, 1)

            if parameter.pweapon then
                mp.Text(weapons_text, seats_font, w / 2, h / 2, C_W_100, 0, 0)
                mp.Text(pweapon_text .. parameter.pweapon, teams_font, w / 2, h / 2 + 23, C_BS_100, 0, 0)

                if parameter.sweapon then
                    mp.Text(sweapon_text .. parameter.sweapon, teams_font, w / 2, h / 2 + 43, C_BS_100, 0, 0)
                end

                if parameter.tweapon then
                    mp.Text(cweapon_text .. parameter.tweapon, teams_font, w / 2, h / 2 + 63, C_BS_100, 0, 0)
                end
            end

            if not parameter.seats then return end
            for i = 1, parameter.seats do
                mp.Icon(-28 + w / 2 + i * 28, 66, 24, 24, mp.Material.SEATS, C_B_200)
            end
        end

        local DModel = vgui.Create("DModelPanel", BTN_VEHICLE)
        DModel:SetModel(VehModel)
        DModel:SetPos(1, 0)
        DModel:SetSize(512, 256)
        DModel:SetFOV(90)
        DModel.Angles = Angle(0, 50, 0)
        DModel:SetCamPos(Vector(150, 150, 90))
        function DModel:LayoutEntity(ent)
            ent:SetPos(Vector(-60, 25, 0))
        end

        if val.modifications then
            local SelectLeft = vgui.Create("DButton", BTN_VEHICLE)
            SelectLeft:SetSize(32, 32)
            SelectLeft:SetPos(10, BTN_VEHICLE:GetTall() - 42)
            SelectLeft:SetText("")
            SelectLeft:SetVisible(true)
            SelectLeft.Hover = 0
            SelectLeft.Paint = function(self, w, h)
                local Owner = ply:GetNWEntity("OwnerVehicle")

                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 25)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))


                mp.Text(left_text, cat_font, w / 2, h / 2, C_W_100, 1, 1)
                surface.SetDrawColor(C_W_100)


                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end

            SelectLeft.DoClick = function(self)
                selectVeh = selectVeh - 1

                if selectVeh <= 0 then
                    selectVeh = #val.modifications
                end

                local veh2 = val.modifications[selectVeh]
                local Veh2 = scripted_ents.Get(veh2)

                if Veh.MDL then
                    VehName = Veh2.PrintName
                    VehModel = Veh2.MDL
                    VehCategory = Veh2.Category
                    parameter = mp.config.vehicle_info[veh2] or {}

                    DModel:SetModel(VehModel)
                end
            end

            local SelectRight = vgui.Create("DButton", BTN_VEHICLE)
            SelectRight:SetSize(32, 32)
            SelectRight:SetPos(10 + 36 + 128 + 4, BTN_VEHICLE:GetTall() - 42)
            SelectRight:SetText("")
            SelectRight:SetVisible(true)
            SelectRight.Hover = 0
            SelectRight.Paint = function(self, w, h)
                local Owner = ply:GetNWEntity("OwnerVehicle")

                if self:IsHovered() then
                    self.Hover = Lerp(FrameTime() * 10, self.Hover, 25)
                else
                    self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
                end

                draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))


                mp.Text(right_text, cat_font, w / 2, h / 2, C_W_100, 1, 1)
                surface.SetDrawColor(C_W_100)


                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end

            SelectRight.DoClick = function(self)
                selectVeh = selectVeh + 1

                if selectVeh > #val.modifications then
                    selectVeh = 1
                end

                local veh2 = val.modifications[selectVeh]
                local Veh2 = scripted_ents.Get(veh2)

                if Veh.MDL then
                    VehName = Veh2.PrintName
                    VehModel = Veh2.MDL
                    VehCategory = Veh2.Category
                    parameter = mp.config.vehicle_info[veh2] or {}

                    DModel:SetModel(VehModel)
                end
            end
        end

        local CreateVeh = vgui.Create("DButton", BTN_VEHICLE)
        CreateVeh:SetSize(128, 32)
        CreateVeh:SetPos(10 + (val.modifications and 36 or 0), BTN_VEHICLE:GetTall() - 42)
        CreateVeh:SetText("")
        CreateVeh:SetVisible(true)
        CreateVeh.Hover = 0
        CreateVeh.Paint = function(self, w, h)
            local Owner = ply:GetNWEntity("OwnerVehicle")

            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 25)
            else
                self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
            end

            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))

            local class = veh
            if val.modifications then
                class = val.modifications[selectVeh]
            end

            if IsValid(Owner) and Owner:GetClass() == class then
                mp.Text(return_text, cat_font, w / 2, h / 2, C_GR_100, 1, 1)
                surface.SetDrawColor(C_GR_100)
            elseif IsValid(Owner) and Owner:GetClass() ~= class then
                mp.Text(select_text, cat_font, w / 2, h / 2, C_R_100, 1, 1)
                surface.SetDrawColor(C_R_100)
            else
                mp.Text(select_text, cat_font, w / 2, h / 2, C_W_100, 1, 1)
                surface.SetDrawColor(C_W_100)
            end

            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        CreateVeh.DoClick = function(self)
            local Owner = ply:GetNWEntity("OwnerVehicle")
            local class = veh
            if val.modifications then
                class = val.modifications[selectVeh]
            end

            if IsValid(Owner) and Owner:GetClass() == class then
                netstream.Start("VehiclesSales_ReturnVehicle", { class = Owner:GetClass() })
            elseif not IsValid(Owner) then
                netstream.Start("VehiclesSales_SpawnVehicle", { class = class })
            end
        end
    end
end)
