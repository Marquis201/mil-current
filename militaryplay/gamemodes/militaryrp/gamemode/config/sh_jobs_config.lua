local mp = mp
local Color = Color

local function body(pl, t)
    for k, v in ipairs(t) do
        pl:SetBodygroup(k - 1, v)
    end
end

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
    weapons = {},
    jobid = "cadet_dolbaeb2",
    max = 128,
    faction = "nato",
    stats = {
        maxhealth = 100,
        maxarmor = 100,
    },
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 })
    end,
})

TEAM_INFYNATO = mp.util.addjob("1-й Пехотный Батальон", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = {},
    jobid = "infynato",
    max = 128,
    faction = "nato",
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_TANKNATO = mp.util.addjob("56-й Бронетанковый Полк", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = {},
    jobid = "tanknato",
    max = 128,
    faction = "nato",
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_RANGERS = mp.util.addjob("75-й Полк Рейнджеров США", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = {},
    jobid = "rangersnato",
    max = 128,
    faction = "nato",
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_DELTA = mp.util.addjob("Отряд Cпециального Назначения 'Дельта'", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = {},
    jobid = "deltanato",
    max = 128,
    faction = "nato",
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_MPNATO = mp.util.addjob("18-е Отделение Военной Полиции", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = {},
    jobid = "mpnato",
    max = 128,
    faction = "nato",
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 19, 0, 0, 0, 0 })
    end,
})

TEAM_AIRNATO = mp.util.addjob("160-й авиационный полк", {
    color = Color(69, 128, 197),
    model = "models/arma3/nato/soldier.mdl",
    weapons = {},
    jobid = "airnato",
    max = 128,
    faction = "nato",
    spawn = function(pl)
        pl:SetSkin(5)
        body(pl, { 0, 0, 12, 0, 0, 0, 0 })
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
    weapons = {},
    jobid = "cadet_dolbaeb",
    max = 128,
    faction = "rf",
    spawn = function(pl)
        pl:SetSkin(1)
    end,
})

TEAM_INFYRF = mp.util.addjob("3-я Мотострелковая Бригада", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = {},
    jobid = "infyrf",
    max = 128,
    faction = "rf",
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_TANKRF = mp.util.addjob("68-й Гвардейский Танковый Полк", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = {},
    jobid = "tankrf",
    max = 128,
    faction = "rf",
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_VDVRF = mp.util.addjob("31-й Десантно-штурмовой Батальон", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = {"tfa_ins2_wpn_ak74izh", "tfa_smc_mp443", "tfa_fas2_ifak"},
    jobid = "vdvrf",
    max = 128,
    faction = "rf",
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 3, 0, 0, 0, 0 })
    end,
})

TEAM_SSORF = mp.util.addjob("Оперативная группа ССО 'Вихрь'", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = {"tfa_inss_asval", "tfa_smc_mp443", "tfa_fas2_ifak"},
    jobid = "ssorf",
    max = 128,
    faction = "rf",
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 6, 0, 0, 0, 0 })
    end,
})

TEAM_MPRF = mp.util.addjob("5-е Отделение Военной Полиции", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = {"tfa_ins2_akm", "tfa_smc_mp443", "tfa_fas2_ifak"},
    jobid = "mprf",
    max = 128,
    faction = "rf",
    spawn = function(pl)
        pl:SetSkin(1)
        body(pl, { 0, 0, 22, 0, 0, 0, 0 })
    end,
})

TEAM_AIRRF = mp.util.addjob("5-й Авиационный Полк", {
    color = Color(153, 0, 0),
    model = "models/arma3/russia/soldier.mdl",
    weapons = {"tfa_ins2_wpn_aks74ukor", "tfa_fas2_ifak"},
    jobid = "airrf",
    max = 128,
    faction = "rf",
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
    weapons = {},
    jobid = "civ",
    max = 128,
    admin = 0,
})

TEAM_PMC = mp.util.addjob("PMC 'Astral'", {
    color = Color(61, 61, 61),
    model = {
        "models/player/group01/female_01.mdl",
    },
    weapons = {},
    jobid = "pmc",
    max = 128,
    admin = 0,
})

--[[

ADMINJOB

]]

TEAM_OVERWATCH = mp.util.addjob("Администратор", {
    color = Color(157, 123, 235),
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
    weapons = { "weapon_physgun", "gmod_tool" },
    jobid = "admin",
    max = 64,
    notarget = true,
})

mp.jobs_by_id = {}

for k, v in pairs(mp.jobs) do
    mp.jobs_by_id[v.jobid] = v
end
