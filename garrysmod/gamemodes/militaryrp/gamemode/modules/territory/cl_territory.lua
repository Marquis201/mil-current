local mp = mp
local nw = nw
local PLAYER = PLAYER
local ColorAlpha = ColorAlpha
local Vector = Vector
local Angle = Angle
local IsValid = IsValid
local ENTITY = ENTITY
local net = net

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
local C_W_100 = mp.Color.BASE
local C_B_100 = ColorAlpha(mp.Color.BASE_TO, 150)

concommand.Add("showzone", function(pl, cmd, args)
    if pl:IsAdmin() then
        pl.ShowTerritory = ! pl.ShowTerritory

        if pl.ShowTerritory then
            hook.Add("PostDrawTranslucentRenderables", "Territory.ShowZone", function(bDepth, bSkybox)
                if (bSkybox) then return end
                local scrw, scrh = ScrW(), ScrH()
                if not pl.ShowTerritory then return end

                for k, v in pairs(mp.Territory.Table) do
                    --local pos = (v.pos.x + v.pos.y) / 2
                    -- local dist = pos:Distance(pl:GetPos())

                    if pl.ShowTerritory then
                        render.SetColorMaterial()
                        cam.IgnoreZ(true)
                        render.DrawBox(Vector(0, 0, 0), Angle(0, 0, 0), v.pos.x, v.pos.y, color_white_50)
                        cam.IgnoreZ(false)
                    end
                end
            end)
        else
            hook.Remove("PostDrawTranslucentRenderables", "Territory.ShowZone")
        end
    end
end)

local MarkIcon = {}
local dist_text = "м"
local percent_text = " %"

local text_font = mp.font("20:Futura PT Medium")
local gps_font = mp.font("22:DIN Pro Regular")

local function DrawPosInfo(icon, pos, text, control)
    local d = math.floor(LocalPlayer():GetPos():Distance(pos) / 10)
    pos = pos:ToScreen()
    local x, y = math.Clamp(pos.x, 0, ScrW() - 32), math.Clamp(pos.y, 0, ScrH() - 32)

    if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
        local addY = 35

        draw.SimpleText(text, gps_font, x + 1, y + 1, mp.Color.BASE_TO, 1, 0)
        draw.SimpleText(text, gps_font, x, y, color_white, 1, 0)

        local data = mp.faction[control]
        local c_text = data and data.title or control or "Нейтральная"
        local c_color = data and data.color or color_white_50
        local c_logo = data and data.logo or nil

        if c_logo then
            mp.Icon(x - 12, y + addY - 12, 24, 24, c_logo, mp.Color.WHITE)
        else
            draw.SimpleText(c_text, text_font, x + 1, y + addY + 1, mp.Color.BASE_TO, 1, 1)
            draw.SimpleText(c_text, text_font, x, y + addY, c_color, 1, 1)
        end

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

do
    local panel_pos_rf = Vector(-12785, -7400, -410)
    local panel_pos_nato = Vector(13182, -5084, -410)
    local panel_ang_rf = Angle(0, 90, 90)
    local panel_ang_nato = Angle(0, -90, 90)
    local alpha = 0
    local LerpAlpha = 0

    local top_font = mp.font("40:Futura PT Medium")
    local player_font = mp.font("30:Futura PT Book")

    local tilte_text = "Топ игроков"

    hook.Add("PostDrawTranslucentRenderables", "3d.TirList", function(bDepth, bSkybox)
        if (bSkybox) then return end
        local pl = LocalPlayer()
        local w, h = 700, 700

        local data = mp.Territory.Table["base_rf"]
        local rf = pl:InTerritory(data.pos.x, data.pos.y)
        local pos = rf and panel_pos_rf or panel_pos_nato
        local ang = rf and panel_ang_rf or panel_ang_nato

        local dist = pos:Distance(pl:GetPos())

        LerpAlpha = Lerp(.1, LerpAlpha, alpha)

        if dist > 500 then
            alpha = 0
        else
            alpha = 255
        end

        if LerpAlpha <= 1 then return end
        if _DRAWCAMERA then return end

        cam.Start3D2D(pos, ang, .1)
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(C_B_100, LerpAlpha / 1.5))
        draw.RoundedBox(0, 0, 0, w, 60, ColorAlpha(C_B_100, LerpAlpha / 1.5))
        draw.RoundedBox(0, 1, 60, w - 2, 2, ColorAlpha(mp.Color.BASE, LerpAlpha))
        mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.BASE_TO, LerpAlpha / 1.5))
        surface.SetDrawColor(ColorAlpha(mp.Color.BASE, LerpAlpha))
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText(tilte_text, top_font, w / 2, 10, ColorAlpha(mp.Color.WHITE, LerpAlpha / 1.2), 1, 0)

        for i = 1, 10 do
            local text = i .. ". "
            local color = mp.Color.BASE

            if i == 1 then
                text = "★ "
                color = mp.Color.YELLOW
            elseif i == 2 then
                text = "☆ "
                color = mp.Color.WHITE
            elseif i == 3 then
                text = "☆ "
                color = mp.Color.ORANGE
            end

            draw.RoundedBox(0, 10, 70 + i * 45 - 40, w - 20, 40, ColorAlpha(C_B_100, LerpAlpha / 1.2))
            surface.SetDrawColor(ColorAlpha(color, LerpAlpha / 4))
            surface.DrawOutlinedRect(10, 70 + i * 45 - 40, w - 20, 40, 2)

            local data2 = nw.GetGlobal("mp.TirList") or {}
            if data2[i] then
                local steamid = data2[i].steamid

                draw.SimpleText(text .. steamid, player_font, 20, 70 + i * 45 - 20,
                    ColorAlpha(color, LerpAlpha / 1.2), 0, 1)

                draw.SimpleText(string.FormattedTime(data2[i].time, "%02i:%02i:%02i"), player_font, w - 20,
                    70 + i * 45 - 20,
                    ColorAlpha(color, LerpAlpha / 1.2), 2, 1)
            else
                draw.SimpleText(text, player_font, 20, 70 + i * 45 - 20,
                    ColorAlpha(color, LerpAlpha / 1.2), 0, 1)
            end
        end

        cam.End3D2D()
    end)
end

do
    local alpha = 0
    local LerpAlpha = 0
    local LerpX = ScrW()
    local posX = ScrW()
    local data

    hook.Add("HUDPaint", "Territory.HUDPaint", function()
        local text_tir = "Чтобы начать, нажмите " .. input.GetKeyName(mp.Territory.TirButton)
        local text_exittir = "чтобы завершить покиньте зону"

        local text_course = "Подойдите к старту полосы"
        local text_start = "Чтобы начать, нажмите " .. input.GetKeyName(mp.Territory.CourseButton)
        local text_exitcourse = "Чтобы завершить, нажмите " .. input.GetKeyName(mp.Territory.CourseButton)

        local pl = LocalPlayer()
        local scrw, scrh = ScrW(), ScrH()
        local y = scrh / 2.5
        if _DRAWCAMERA then return end

        LerpX = Lerp(.03, LerpX, posX)
        LerpAlpha = Lerp(.02, LerpAlpha, alpha)

        if data then
            if pl:InTerritory(data.pos.x, data.pos.y) then
                posX = scrw - 25
            else
                posX = scrw * 1.2
            end

            if LerpX < scrw then
                alpha = 255
            else
                alpha = 0
            end

            if LerpAlpha <= 5 then
                data = nil
                return
            end

            surface.SetFont(gps_font)
            local w, h = surface.GetTextSize(data.name)

            w, h = w + 30, h + 5

            draw.RoundedBox(0, LerpX - w - 10, y - h / 2, w, h + 3, ColorAlpha(C_B_100, LerpAlpha * .7))

            draw.RoundedBox(0, LerpX - w - 10, y - h / 2, 5, h + 3, ColorAlpha(C_W_100, LerpAlpha))
            mp.Icon(LerpX - w - 5, y - h / 2, w - 10, h + 3, mp.Material.GRADIENT_L,
                ColorAlpha(C_W_100, LerpAlpha * .5))
            mp.Icon(LerpX - w - 5, y + h / 2 + 2, w - 10, 1, mp.Material.GRADIENT_L,
                ColorAlpha(C_W_100, LerpAlpha))
            mp.Icon(LerpX - w - 5, y - h / 2, w - 10, 1, mp.Material.GRADIENT_L, ColorAlpha(C_W_100, LerpAlpha))

            draw.SimpleText(data.name, gps_font, LerpX - 24, y + 1, ColorAlpha(mp.Color.BASE_TO, LerpAlpha), 2, 1)
            draw.SimpleText(data.name, gps_font, LerpX - 25, y, ColorAlpha(mp.Color.WHITE, LerpAlpha), 2, 1)

            --if not pl:IsSuperAdmin() then return end

            if data.course and pl:GetFaction() and pl:GetFaction() == data.control then
                local course = pl:GetNetVar("mp.PlayerCourse")

                if not course then
                    DrawPosInfo(nil, data.start, "Начала полосы", data.control)

                    local text = pl:GetPos():Distance(data.start) < 50 and text_start or text_course

                    surface.SetFont(text_font)
                    local w2, h2 = surface.GetTextSize(text)

                    w2, h2 = w2 + 30, h2 + 10

                    draw.RoundedBox(0, LerpX / 2 - w2 / 2, scrh / 10, w2, h2, ColorAlpha(C_B_100, LerpAlpha / 1.5))
                    mp.Icon(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, mp.Material.GRADIENT_D,
                        ColorAlpha(mp.Color.BASE, LerpAlpha / 7))

                    surface.SetDrawColor(ColorAlpha(mp.Color.BASE, LerpAlpha / 5))
                    surface.DrawOutlinedRect(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, 1)

                    draw.SimpleText(text, text_font, LerpX / 2, scrh / 10 + h2 / 2,
                        ColorAlpha(mp.Color.WHITE, LerpAlpha),
                        1, 1)

                    pl.NextCourse = pl.NextCourse or 0
                    if pl.NextCourse < CurTime() and input.IsKeyDown(mp.Territory.CourseButton) then
                        net.Start("mp.Territory.StartCourse")
                        net.WriteString(data.id)
                        net.SendToServer()

                        pl.NextCourse = CurTime() + 1
                    end
                else
                    DrawPosInfo(nil, data.finish, "Финиш полосы", data.control)

                    if pl:GetPos():Distance(data.finish) < 50 then
                        surface.SetFont(text_font)
                        local w2, h2 = surface.GetTextSize(text_exitcourse)

                        w2, h2 = w2 + 30, h2 + 10

                        draw.RoundedBox(0, LerpX / 2 - w2 / 2, scrh / 10, w2, h2,
                            ColorAlpha(C_B_100, LerpAlpha / 1.5))
                        mp.Icon(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, mp.Material.GRADIENT_D,
                            ColorAlpha(mp.Color.BASE, LerpAlpha / 7))

                        surface.SetDrawColor(ColorAlpha(mp.Color.BASE, LerpAlpha / 5))
                        surface.DrawOutlinedRect(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, 1)

                        draw.SimpleText(text_exitcourse, text_font, LerpX / 2, scrh / 10 + h2 / 2,
                            ColorAlpha(mp.Color.WHITE, LerpAlpha),
                            1, 1)
                    else
                        local text = string.FormattedTime(course - CurTime(), "%02i:%02i:%02i")

                        surface.SetFont(text_font)
                        local w2, h2 = surface.GetTextSize(text)

                        w2, h2 = w2 + 30, h2 + 10

                        draw.RoundedBox(0, LerpX / 2 - w2 / 2, scrh / 10, w2, h2,
                            ColorAlpha(C_B_100, LerpAlpha / 1.5))
                        mp.Icon(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, mp.Material.GRADIENT_D,
                            ColorAlpha(mp.Color.BASE, LerpAlpha / 7))

                        surface.SetDrawColor(ColorAlpha(mp.Color.BASE, LerpAlpha / 5))
                        surface.DrawOutlinedRect(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, 1)

                        draw.SimpleText(text, text_font, LerpX / 2, scrh / 10 + h2 / 2,
                            ColorAlpha(mp.Color.WHITE, LerpAlpha),
                            1, 1)
                    end
                end
            end

            if data.tir and data.control and pl:GetFaction() and pl:GetFaction() == data.control then
                local tid_data = nw.GetGlobal("mp.Tir")

                if pl:InTerritory(data.tir.x, data.tir.y) and (not tid_data or not tid_data[pl:GetFaction()]) then
                    surface.SetFont(text_font)
                    local w2, h2 = surface.GetTextSize(text_tir)

                    w2, h2 = w2 + 30, h2 + 10

                    draw.RoundedBox(0, LerpX / 2 - w2 / 2, scrh / 10, w2, h2, ColorAlpha(C_B_100, LerpAlpha / 1.5))
                    mp.Icon(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, mp.Material.GRADIENT_D,
                        ColorAlpha(mp.Color.BASE, LerpAlpha / 7))

                    surface.SetDrawColor(ColorAlpha(mp.Color.BASE, LerpAlpha / 5))
                    surface.DrawOutlinedRect(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, 1)

                    draw.SimpleText(text_tir, text_font, LerpX / 2, scrh / 10 + h2 / 2,
                        ColorAlpha(mp.Color.WHITE, LerpAlpha),
                        1, 1)

                    pl.NextTir = pl.NextTir or 0
                    if pl.NextTir < CurTime() and input.IsKeyDown(mp.Territory.TirButton) then
                        net.Start("mp.Territory.StartTir")
                        net.WriteString(data.id)
                        net.SendToServer()

                        pl.NextTir = CurTime() + 1
                    end
                elseif tid_data and pl:GetNetVar("mp.PlayerTir") then
                    local player_data = pl:GetNetVar("mp.PlayerTir")
                    local text = string.FormattedTime(-player_data.time + CurTime(), "%02i:%02i:%02i")

                    surface.SetFont(text_font)
                    local w2, h2 = surface.GetTextSize(text)

                    w2, h2 = w2 + 30, h2 + 10

                    draw.RoundedBox(0, LerpX / 2 - w2 / 2, scrh / 10, w2, h2, ColorAlpha(C_B_100, LerpAlpha / 1.5))
                    mp.Icon(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, mp.Material.GRADIENT_D,
                        ColorAlpha(mp.Color.BASE, LerpAlpha / 7))

                    surface.SetDrawColor(ColorAlpha(mp.Color.BASE, LerpAlpha / 5))
                    surface.DrawOutlinedRect(LerpX / 2 - w2 / 2, scrh / 10, w2, h2, 1)

                    draw.SimpleText(text, text_font, LerpX / 2, scrh / 10 + h2 / 2,
                        ColorAlpha(mp.Color.WHITE, LerpAlpha),
                        1, 1)
                end
            end
        end

        for k, v in pairs(mp.Territory.Table) do
            if not pl:InTerritory(v.pos.x, v.pos.y) then continue end

            if data and data.primary and not v.primary then
                continue
            end

            data = v

            --if data then
            -- break
            --end
        end

        if pl.GPSCash then
            for k, v in pairs(pl.GPSCash) do
                local t = mp.Territory.GPS[k] or mp.Territory.CustomGPS[k]
                if not t then continue end

                if pl:Alive() and pl:GetPos():Distance(t.pos) < 300 then
                    pl.GPSCash[k] = nil

                    mp.util.Notify(NOTIFY_GENERIC, "Вы прибыли в точку назначения")
                end

                cam.Start2D()
                DrawPosInfo(t.icon, t.pos, t.name, t.control)
                cam.End2D()
            end
        end
    end)
end

net.Receive("mp.Territory.DeleteGPS", function()
    local pl = LocalPlayer()
    local id = net.ReadString()

    mp.Territory.CustomGPS[id] = nil

    pl.GPSCash = pl.GPSCash or {}
    pl.GPSCash[id] = nil
end)

net.Receive("mp.Territory.AddGPS", function()
    local pl = LocalPlayer()
    local id = net.ReadString()
    local name = net.ReadString()
    local control = net.ReadString()
    local pos = net.ReadVector()

    mp.Territory.CustomGPS[id] = {
        name = name,
        control = control,
        pos = pos,
    }

    pl.GPSCash = pl.GPSCash or {}
    pl.GPSCash[id] = true
end)
