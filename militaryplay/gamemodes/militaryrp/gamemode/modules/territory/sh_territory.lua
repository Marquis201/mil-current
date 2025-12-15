local mp = mp
local nw = nw
local PLAYER = PLAYER
local ColorAlpha = ColorAlpha
local Vector = Vector
local Angle = Angle
local IsValid = IsValid

mp.Territory = mp.Territory or {}
mp.Territory.Table = {}

local function addTerritory(id, t)
    mp.Territory.Table[id] = t
end

addTerritory("base_rf", {
    name = "База РФ",
    control = "rf",
    icon = nil,
    pos = { x = Vector(-10207, -5703, -550), y = Vector(-14678, -14625, 738) }
})

addTerritory("base_oil", {
    name = "Нефтяное хранилище",
    control = "nil",
    icon = nil,
    pos = { x = Vector(-2955, -5550, -550), y = Vector(-4451, -7514, 246) }
})

addTerritory("base_nato", {
    name = "База NATO",
    control = "nato",
    icon = nil,
    pos = { x = Vector(9460, -7522, -550), y = Vector(14723, -40, 202) }
})

function PLAYER:InTerritory(p1, p2)
    if not IsValid(self) then return false end
    return self:GetPos():WithinAABox(p1, p2)
end

if CLIENT then
    local Color = Color
    local concommand = concommand
    local hook = hook
    local render = render
    local cam = cam
    local LocalPlayer = LocalPlayer
    local ScrW, ScrH = ScrW, ScrH
    local surface = surface
    local color_white = color_white
    local draw = draw
    local Material = Material

    local color_white_50 = Color(255, 255, 255, 100)

    concommand.Add("showzone", function(pl, cmd, args)
        if pl:IsAdmin() then
            pl.ShowTerritory = ! pl.ShowTerritory
        end
    end)

    local MarkIcon = {}
    local dist_text = "м"
    local percent_text = " %"

    local text_font = mp.font("20:Futura PT Medium")
    local gps_font = mp.font("30:Futura PT Book")

    local function DrawPosInfo(icon, pos, text, control)
        local d = math.floor(LocalPlayer():GetPos():Distance(pos) / 10)
        pos = pos:ToScreen()
        local x, y = math.Clamp(pos.x, 0, ScrW() - 32), math.Clamp(pos.y, 0, ScrH() - 32)


        if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
            local addY = 35

            draw.SimpleText(text, gps_font, x + 1, y + 1, mp.Color.BASE_TO, 1, 0)
            draw.SimpleText(text, gps_font, x, y, color_white, 1, 0)

            local c_text = mp.faction[control] and mp.faction[control].title or "Нейтральная"
            local c_color = mp.faction[control] and mp.faction[control].color or color_white_50
            draw.SimpleText(c_text, text_font, x + 1, y + addY + 1, mp.Color.BASE_TO, 1, 1)
            draw.SimpleText(c_text, text_font, x, y + addY, c_color, 1, 1)

            addY = addY + 20

            draw.SimpleText(d .. dist_text, text_font, x + 1, y + addY + 1, mp.Color.BASE_TO, 1, 1)
            draw.SimpleText(d .. dist_text, text_font, x, y + addY, mp.Color.PURPLE, 1, 1)
        end

        if icon then
            MarkIcon[icon] = MarkIcon[icon] or Material(icon, "smooth")

            surface.SetDrawColor(color_white)
            surface.SetMaterial(MarkIcon[icon])
            surface.DrawTexturedRect(x, y, 32, 32)
        end
    end

    hook.Add("PostDrawTranslucentRenderables", "Territory.ShowZone", function(bDepth, bSkybox)
        if (bSkybox) then return end
        local pl = LocalPlayer()
        local scrw, scrh = ScrW(), ScrH()

        for k, v in pairs(mp.Territory.Table) do
            local pos  = (v.pos.x + v.pos.y) / 2
            local dist = pos:Distance(pl:GetPos())

            if pl.ShowTerritory then
                render.SetColorMaterial()
                cam.IgnoreZ(true)
                render.DrawBox(Vector(0, 0, 0), Angle(0, 0, 0), v.pos.x, v.pos.y, color_white_50)
                cam.IgnoreZ(false)
            end

            cam.Start2D()
            if dist < 10000 and not pl:InTerritory(v.pos.x, v.pos.y) then
                DrawPosInfo(v.icon, pos, v.name, v.control)
            end
            cam.End2D()

            local Ang = Angle(0, 0, 0)
            local minPos = v.pos.x
            local maxPos = v.pos.y
            local zoneWidth = math.abs(maxPos.x - minPos.x)
            local zoneHeight = math.abs(maxPos.y - minPos.y)
            local zoneDepth = math.abs(maxPos.z - minPos.z)
            local c_color = mp.faction[v.control] and ColorAlpha(mp.faction[v.control].color, 100) or color_white_50

            Ang:RotateAroundAxis(Ang:Right(), 90)

            pos.x = pos.x - zoneWidth / 2

            cam.Start3D2D(pos, Ang, 1)
            mp.Icon(-zoneDepth / 2, -zoneHeight / 2, 100, zoneHeight, mp.Material.GRADIENT_L,
                c_color)

            cam.End3D2D()

            Ang:RotateAroundAxis(Ang:Forward(), 90)

            pos.y = pos.y - zoneHeight / 2

            cam.Start3D2D(pos, Ang, 1)
            mp.Icon(-zoneDepth / 2, 0, 100, zoneWidth, mp.Material.GRADIENT_L,
                c_color)

            cam.End3D2D()

            Ang:RotateAroundAxis(Ang:Forward(), 90)

            pos.x = pos.x + zoneWidth

            cam.Start3D2D(pos, Ang, 1)
            mp.Icon(-zoneDepth / 2, 0, 100, zoneHeight, mp.Material.GRADIENT_L,
                c_color)

            cam.End3D2D()

            Ang:RotateAroundAxis(Ang:Forward(), 90)

            pos.y = pos.y + zoneHeight

            cam.Start3D2D(pos, Ang, 1)
            mp.Icon(-zoneDepth / 2, 0, 100, zoneWidth, mp.Material.GRADIENT_L,
                c_color)

            cam.End3D2D()
        end
    end)
end
