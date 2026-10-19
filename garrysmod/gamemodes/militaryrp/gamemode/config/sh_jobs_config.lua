local mp = mp
local Color = Color
local Vector = Vector

local function body(pl, t)
    for k, v in ipairs(t) do
        pl:SetBodygroup(k - 1, v)
    end
end

local salary = {
    soldier = 50, // обычный солдат
    zam_cmd = 75, // заместитель командира
    cmd = 100, // командир
    special = 150 // специальные бойцы
}

mp.jobs = {}

--[[

NATOJOB

]]


TEAM_CADET = mp.util.addjob("Призывник NATO", {
    color = Color(69, 128, 197),
    model = {
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl",
        "models/player/group01/male_04.mdl",
        "models/player/group01/male_05.mdl",
        "models/player/group01/male_06.mdl",
        "models/player/group01/male_07.mdl",
        "models/player/group01/male_08.mdl",
        "models/player/group01/male_09.mdl"
    },
    weapons = { "weapon_hands" },
    jobid = "cadet_dolbaeb2",
    max = 128,
    faction = "nato",
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 })
    end,
    spawn_pos = {
        Vector(12704, -2719, -472),
        Vector(12811, -2665, -472),
        Vector(12715, -2559, -472),
        Vector(12798, -2487, -472),
        Vector(12710, -2407, -472),
        Vector(12798, -2302, -472),
        Vector(12710, -2221, -472)
    }
})



TEAM_INFYNATO = mp.util.addjob("1-й Пехотный Батальон", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "infynato",
    max = 128,
    faction = "nato",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVINFYNATO = mp.util.addjob("Командир 1-й Пехотного Батальон", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glainfynato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVINFYNATO = mp.util.addjob("Заместитель Командира 1-й Пехотного Батальон", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglainfynato",
    max = 128,
    faction = "nato",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})


TEAM_GLAVTANKNATO = mp.util.addjob("Командир 56-й Бронетанкового Полк", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavtanknato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVTANKNATO = mp.util.addjob("Заместитель Командира 56-й Бронетанкового Полк", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavtanknato",
    max = 128,
    faction = "nato",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_TANKNATO = mp.util.addjob("56-й Бронетанковый Полк", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "tanknato",
    max = 128,
    faction = "nato",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVRANGERS = mp.util.addjob("Командир 75-й Полк Рейнджеров США", {
    color = Color(69, 128, 197),
    model = "models/notart/us pararescue 2.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavrangersnato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVRANGERS = mp.util.addjob("Заместитель Командира 75-й Полк Рейнджеров США", {
    color = Color(69, 128, 197),
    model = "models/notart/us pararescue 2.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavrangersnato",
    max = 128,
    faction = "nato",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_RANGERS = mp.util.addjob("75-й Полк Рейнджеров США", {
    color = Color(69, 128, 197),
    model = "models/notart/us pararescue 2.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "rangersnato",
    max = 128,
    faction = "nato",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_DELTA = mp.util.addjob("Отряд Cпециального Назначения 'Дельта'", {
    color = Color(69, 128, 197),
    model = "models/eft/bosses/black_division.mdl", --models/jwk987/cod/ghost/Merrick.mdl
    weapons = { "weapon_hands", "keys" },
    jobid = "deltanato",
    max = 128,
    faction = "nato",
    salary = salary.special,
})


TEAM_GLAVGS9 = mp.util.addjob("Командир Спецназа KSK", {
    color = Color(69, 128, 197),
    model = "models/voidn/ksk/ksk-6_pm.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavgsgnato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVGS9 = mp.util.addjob("Заместитель Командира Спецназа KSK", {
    color = Color(69, 128, 197),
    model = "models/voidn/ksk/ksk-6_pm.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavgsgnato",
    max = 128,
    faction = "nato",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_GSG9 = mp.util.addjob("Спецназ KSK", {
    color = Color(69, 128, 197),
    model = "models/voidn/ksk/ksk-6_pm.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "gs9nato",
    max = 128,
    faction = "nato",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVBLACK = mp.util.addjob("Командир ЧВК BlackWatch", {
    color = Color(69, 128, 197),
    model = "models/player/suno/spyper/us_assault.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavblacknato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVBLACK = mp.util.addjob("Заместитель Командира ЧВК BlackWatch", {
    color = Color(69, 128, 197),
    model = "models/player/suno/spyper/us_assault.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavblacknato",
    max = 128,
    faction = "nato",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_BLACK = mp.util.addjob("ЧВК BlackWatch", {
    color = Color(69, 128, 197),
    model = "models/player/suno/spyper/us_support.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "blacknato",
    max = 128,
    faction = "nato",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVMPNATO = mp.util.addjob("Командир 18-е Отделения Военной Полиции", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavmpnato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVMPNATO = mp.util.addjob("Заместитель Командира 18-е Отделения Военной Полиции", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavmpnato",
    max = 128,
    faction = "nato",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_MPNATO = mp.util.addjob("18-е Отделение Военной Полиции", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "mpnato",
    max = 128,
    faction = "nato",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVNATO = mp.util.addjob("Председатель Военного Комитета НАТО", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavnato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVNATO = mp.util.addjob("Заместитель Председатель Военного Комитета НАТО", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavnato",
    max = 128,
    faction = "nato",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVAIRNATO = mp.util.addjob("Командир 160-й авиационного полка", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavairnato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 12, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVAIRNATO = mp.util.addjob("Командир 160-й авиационного полка", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavairnato",
    max = 128,
    faction = "nato",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 12, 0, 0, 0, 0 })
    end,
})

TEAM_AIRNATO = mp.util.addjob("160-й авиационный полк", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "airnato",
    max = 128,
    faction = "nato",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 12, 0, 0, 0, 0 })
    end,
})



TEAM_SASDONATEBELKA = mp.util.addjob("SAS Оперативник [DONATE]", {
    color = Color(69, 128, 197),
    model = "models/motoess/sas/sas-1.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "sasdonatebelka",
    max = 128,
    faction = "nato",
    salary = salary.special,
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

--[[

RFJOB

]]

TEAM_CADETRF = mp.util.addjob("Призывник РФ", {
    color = Color(200, 25, 25),
    model = {
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl",
        "models/player/group01/male_04.mdl",
        "models/player/group01/male_05.mdl",
        "models/player/group01/male_06.mdl",
        "models/player/group01/male_07.mdl",
        "models/player/group01/male_08.mdl",
        "models/player/group01/male_09.mdl",
    },
    weapons = { "weapon_hands" },
    jobid = "cadet_dolbaeb",
    max = 128,
    faction = "rf",
    spawn = function(pl)
        pl:SetSkin(1)
    end,
    spawn_pos = {
        Vector(-13054, -9689, -472),
        Vector(-12951, -9693, -472),
        Vector(-12954, -9763, -472),
        Vector(-13060, -9777, -472),
        Vector(-13064, -9885, -472),
        Vector(-12957, -9918, -472),
        Vector(-12962, -10016, -472),
        Vector(-13030, -10113, -472),
    }
})

TEAM_INFYRF = mp.util.addjob("3-я Мотострелковая Бригада", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "infyrf",
    max = 128,
    faction = "rf",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVINFYRF = mp.util.addjob("Командир 3-я Мотострелковой Бригады", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavinfyrf",
    max = 128,
    faction = "rf",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVTANKRF = mp.util.addjob("Командир 68-й Гвардейского Танковый Полка", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavtankrf",
    max = 128,
    faction = "rf",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVTANKRF = mp.util.addjob("Заместитель Командира 68-й Гвардейского Танковый Полка", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavtankrf",
    max = 128,
    faction = "rf",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_TANKRF = mp.util.addjob("68-й Гвардейский Танковый Полк", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "tankrf",
    max = 128,
    faction = "rf",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVVDVRF = mp.util.addjob("Командир 31-й Десантно-штурмового Батальона", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavvdvrf",
    max = 128,
    faction = "rf",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVVDVRF = mp.util.addjob("Заместитель Командира 31-й Десантно-штурмового Батальона", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavvdvrf",
    max = 128,
    faction = "rf",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_VDVRF = mp.util.addjob("31-й Десантно-штурмовой Батальон", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "vdvrf",
    max = 128,
    faction = "rf",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVFSB = mp.util.addjob("Командир Отряда 'ФСБ'", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/fsb_oper.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavfsb",
    max = 128,
    faction = "rf",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVFSB = mp.util.addjob("Заместитель Командира Отряда 'ФСБ'", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/fsb_oper.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavfsb",
    max = 128,
    faction = "rf",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})


TEAM_FSBOPER = mp.util.addjob("Оперативник 'ФСБ'", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/fsb_oper.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "fsboper",
    max = 128,
    faction = "rf",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_SSORF = mp.util.addjob("Оперативная группа ССО 'Вихрь'", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl", -- "models/notart/jtf ii.mdl" будет заменена
    weapons = { "weapon_hands", "keys" },
    jobid = "ssorf",
    max = 128,
    faction = "rf",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 6, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVMPRF = mp.util.addjob("Командир 5-е Отделения Военной Полиции", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavmprf",
    max = 128,
    faction = "rf",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 22, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVMPRF = mp.util.addjob("Заместитель Командира 5-е Отделения Военной Полиции", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavmprf",
    max = 128,
    faction = "rf",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 22, 0, 0, 0, 0 })
    end,
})

TEAM_MPRF = mp.util.addjob("5-е Отделение Военной Полиции", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "mprf",
    max = 128,
    faction = "rf",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 22, 0, 0, 0, 0 })
    end,
})



TEAM_GLAVRF = mp.util.addjob("Главное Управления Войсками РФ", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "mprf",
    max = 128,
    faction = "rf",
    salary = salary.special,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 22, 0, 0, 0, 0 })
    end,
})

TEAM_GLAVAIRRF = mp.util.addjob("Командир 5-й Авиационный Полка", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "glavairrf",
    max = 128,
    faction = "rf",
    salary = salary.cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_ZAMGLAVAIRRF = mp.util.addjob("Заместитель Командира 5-й Авиационный Полка", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "zamglavairrf",
    max = 128,
    faction = "rf",
    salary = salary.zam_cmd,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_AIRRF = mp.util.addjob("5-й Авиационный Полк", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = { "weapon_hands", "keys" },
    jobid = "airrf",
    max = 128,
    faction = "rf",
    salary = salary.soldier,
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

--[[

EVENTJOB

]]

TEAM_CIV = mp.util.addjob("Гражданский", {
    color = Color(134, 236, 206),
    model = {
        "models/player/group01/female_01.mdl",
        "models/player/group01/female_02.mdl",
        "models/player/group01/female_03.mdl",
        "models/player/group01/female_04.mdl",
        "models/player/group01/female_05.mdl",
        "models/player/group01/female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl",
        "models/player/group01/male_04.mdl",
        "models/player/group01/male_05.mdl",
        "models/player/group01/male_06.mdl",
        "models/player/group01/male_07.mdl",
        "models/player/group01/male_08.mdl",
        "models/player/group01/male_09.mdl",
    },
    weapons = { "weapon_hands" },
    jobid = "civ",
    max = 128,
    admin = 0,
    spawn_pos = {
        Vector(-11608, -1814, -372),
        Vector(-11614, -1682, -365),
        Vector(-11609, -1531, -362),
        Vector(-11442, -1536, -360),
        Vector(-11447, -1687, -360),
        Vector(-11434, -1864, -360),
        Vector(-11276, -1837, -360)
    }
})

TEAM_PMC = mp.util.addjob("PMC 'Astral'", {
    color = Color(61, 61, 61),
    model = {
        "models/pmc/pmc_1/pmc_pm.mdl",
    },
    weapons = { "weapon_hands" },
    jobid = "pmc",
    salary = salary.special,
    max = 128,
    admin = 0,
})

--[[

ADMINJOB

]]

TEAM_OVERWATCH = mp.util.addjob("Администратор", {
    color = Color(157, 123, 235),
    model = {
        "models/pmc/pmc_7/super_pm.mdl",
    },
    weapons = { "weapon_physgun", "gmod_tool" },
    jobid = "admin",
    max = 64,
    notarget = true,
    spawn_pos = {
        Vector(6267, -4709, 6160),
        Vector(6285, -4880, 6160),
        Vector(6285, -4974, 6160)
    }
})

mp.jobs_by_id = {}

for k, v in pairs(mp.jobs) do
    mp.jobs_by_id[v.jobid] = v
end
