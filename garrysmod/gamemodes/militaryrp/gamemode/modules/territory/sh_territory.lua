local mp = mp
local nw = nw
local PLAYER = PLAYER
local ColorAlpha = ColorAlpha
local Vector = Vector
local Angle = Angle
local IsValid = IsValid
local ENTITY = ENTITY
local net = net

mp.Territory = mp.Territory or {}
mp.Territory.Table = {}
mp.Territory.GPS = {}
mp.Territory.CustomGPS = mp.Territory.CustomGPS or {}
mp.Territory.Tir = {}
mp.Territory.TirButton = 100 // F9
mp.Territory.TirTime = 180

mp.Territory.CourseButton = 100 // F9
mp.Territory.CourseTime = 60

local function addTerritory(id, t)
    if t.tir and SERVER then
        for k, v in ipairs(ents.FindByClass("sent_eft_popper")) do
            if v:InTerritory(t.pos.x, t.pos.y) then
                mp.Territory.Tir[v:EntIndex()] = v
                v.tir_id = id
            end
        end
    end

    t.id = id

    mp.Territory.Table[id] = t
end

local function addGPS(id, t)
    t.id = id

    mp.Territory.GPS[id] = t
end

do -- GPS
    addGPS("delete", {
        name = "Удалить все точки",
        pos = Vector(0, 0, 0),
    })

    -- RF

    addGPS("base_rf", {
        name = "База",
        control = "rf",
        pos = Vector(-12190, -10365, -512),
    })

    addGPS("tir_rf", {
        name = "Стрельбище",
        control = "rf",
        pos = Vector(-12515, -7416, -512),
    })

    addGPS("enter_rf", {
        name = "КПП",
        control = "rf",
        pos = Vector(-10938, -12483, -512),
    })

    addGPS("rf_vehicle", {
        name = "Парк техники",
        control = "rf",
        pos = Vector(-13631, -11055, -497),
    })

    addGPS("rf_jail", {
        name = "Изолятор",
        control = "rf",
        pos = Vector(-11394, -10945, -472),
    })

    addGPS("rf_weapons", {
        name = "КХО",
        control = "rf",
        pos = Vector(-12076, -12055, -472),
    })

    addGPS("rf_command", {
        name = "Штаб",
        control = "rf",
        pos = Vector(-12821, -9838, -472),
    })

    addGPS("rf_medic", {
        name = "Санчасть",
        control = "rf",
        pos = Vector(-11237, -8490, -472),
    })

    addGPS("rf_store", {
        name = "Склад",
        control = "rf",
        pos = Vector(-10976, -7507, -472),
    })

    addGPS("rf_run", {
        name = "Полоса препятствий",
        control = "rf",
        pos = Vector(-12500, -8253, -388),
    })

    addGPS("rf_train", {
        name = "Инструктор",
        control = "rf",
        pos = Vector(-12978, -10208, -472),
    })

    -- NATO

    addGPS("nato_train", {
        name = "Инструктор",
        control = "nato",
        pos = Vector(12742, -2180, -472),
    })

    addGPS("nato_base", {
        name = "База",
        control = "nato",
        pos = Vector(12028, -3155, -115),
    })

    addGPS("nato_command", {
        name = "Штаб",
        control = "nato",
        pos = Vector(12577, -2441, -472),
    })

    addGPS("nato_tir", {
        name = "Стрельбище",
        control = "nato",
        pos = Vector(12919, -5060, -512),
    })

    addGPS("nato_run", {
        name = "Полоса препятствий",
        control = "nato",
        pos = Vector(12809, -4047, -384),
    })

    addGPS("nato_weapons", {
        name = "КХО",
        control = "nato",
        pos = Vector(11656, -3789, -472),
    })

    addGPS("nato_medic", {
        name = "Санчасть",
        control = "nato",
        pos = Vector(10295, -5622, -472),
    })

    addGPS("nato_store", {
        name = "Склад",
        control = "nato",
        pos = Vector(11614, -4971, -460),
    })

    addGPS("nato_vehicle", {
        name = "Парк техники",
        control = "nato",
        pos = Vector(12862, -1287, -504),
    })

    addGPS("nato_jail", {
        name = "Изолятор",
        control = "nato",
        pos = Vector(10874, -738, -472),
    })

    addGPS("nato_enter", {
        name = "КПП",
        control = "nato",
        pos = Vector(10606, -2278, -512),
    })
end

do -- TERRITORY
    addTerritory("rf_course", {
        name = "Полоса препятствий РФ",
        primary = true,
        control = "rf",
        pos = { x = Vector(-12074, -8670, -512), y = Vector(-12850, -7603, -166) },
        course = true,
        start = Vector(-12107, -7753, -512),
        finish = Vector(-12217, -8595, -512),
    })

    addTerritory("base_rf", {
        name = "База РФ",
        control = "rf",
        pos = { x = Vector(-9844, -5099, -550), y = Vector(-14079, -13445, 205) }
    })

    addTerritory("tir_rf", {
        name = "Стрельбище РФ",
        primary = true,
        control = "rf",
        pos = { x = Vector(-12146, -7554, -512), y = Vector(-12841, -5022, -404) },
        tir = { x = Vector(-12146, -7554, -512), y = Vector(-12800, -7098, -384) },
        wep = "tfa_ins2_pm"
    })

    addTerritory("base_nato", {
        name = "База НАТО",
        control = "nato",
        pos = { x = Vector(9460, -7522, -550), y = Vector(14723, -40, 202) }
    })

    addTerritory("nato_tir", {
        name = "Стрельбище NATO",
        primary = true,
        control = "nato",
        pos = { x = Vector(12560, -4924, -512), y = Vector(13189, -7433, -384) },
        tir = { x = Vector(12544, -4924, -512), y = Vector(13221, -5368, -384) },
        wep = "tfa_ins2_m9"
    })

    addTerritory("nato_course", {
        name = "Полоса препятствий NATO",
        primary = true,
        control = "nato",
        pos = { x = Vector(12425, -3820, -512), y = Vector(13249, -4873, -166) },
        course = true,
        start = Vector(12478, -4725, -512),
        finish = Vector(12620, -3948, -512),
    })
end

function ENTITY:InTerritory(p1, p2)
    if not IsValid(self) then return false end
    return self:GetPos():WithinAABox(p1, p2)
end

nw.Register("mp.Tir")
    :Write(function(t)
        for k, v in pairs(mp.faction) do
            if t[k] then
                net.WriteString(k)
                net.WriteString(t[k].steamid)
                net.WriteString(t[k].id)
            end
        end
    end)
    :Read(function()
        local t = {}

        for k, v in pairs(mp.faction) do
            t[net.ReadString()] = {
                steamid = net.ReadString(),
                id = net.ReadString(),
            }
        end

        return t
    end)
    :SetGlobal()

nw.Register("mp.PlayerCourse")
    :Write(net.WriteFloat)
    :Read(net.ReadFloat)
    :SetLocalPlayer()

nw.Register("mp.PlayerTir")
    :Write(function(t)
        net.WriteFloat(t.time)
        net.WriteString(t.id)
    end)
    :Read(function()
        local t = {
            time = net.ReadFloat(),
            id = net.ReadString()
        }
        return t
    end)
    :SetLocalPlayer()

nw.Register("mp.TirList")
    :Write(function(t)
        net.WriteUInt(#t, 8)
        for k, v in ipairs(t) do
            net.WriteString(v.steamid)
            net.WriteFloat(v.time)
        end
    end)
    :Read(function()
        local t = {}

        for i = 1, net.ReadUInt(8) do
            t[i] = {
                steamid = net.ReadString(),
                time = net.ReadFloat()
            }
        end

        for k, v in ipairs(t) do
            http.Fetch(
                'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=4F21A9510DF8F7CB1D0FE1970392ECFA&steamids=' ..
                v.steamid,
                function(body, length, headers, code)

                    print(body)
                    if not util.JSONToTable(body) then return end
                    local name = util.JSONToTable(body)['response']['players'][1].personaname

                    t[k].steamid = name
                end,

                function(message)
                end,

                {
                    ['accept-encoding'] = 'gzip, deflate',
                    ['accept-language'] = 'fr'
                }
            )
        end

        return t
    end)
    :SetGlobal()