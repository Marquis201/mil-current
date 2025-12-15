local Vector = Vector
local Color = Color
local mp = mp
local Material = Material

local function body(pl, t)
    for k, v in ipairs(t) do
        pl:SetBodygroup(k - 1, v)
    end
end

mp.faction = {}
mp.profession = {}
mp.ranks = {}

do                          -- Настройки сервера
    local CONFIG = mp.config
    CONFIG.player_stats = { -- базовые настройки игрока
        runspeed = 275,
        walkspeed = 160,
        jumppower = 180,
        max_health = 100,
        start_health = 100,
    }

    CONFIG.arrest = {
        time = { min = 60, max = 3600 },
        reason = { min = 3, max = 120 }
    }

    CONFIG.reswn_time = 15                           -- время до возраждения
    CONFIG.start_money = 100                         -- начальные деньги
    CONFIG.start_menu_pos = Vector(-6615, 586, 1213) -- начальная позиция для зашедшего игрока
    CONFIG.spawn_menu = {                            -- доступ к qmenu
        ["founder"] = true,
        ["curator"] = true,
        ["sudocurator"] = true,
        ["sadmin"] = true,
        ["senioradmin"] = true,
        ["senioreventolog"] = true,
        ["admin"] = true,
        ["eventolog"] = true,
        ["helper"] = true
    }

    CONFIG.whitelist = { -- полный доступ к вайт-листу по рангу
        ["founder"] = true,
        ["curator"] = true,
        ["sudocurator"] = true,
        ["sadmin"] = true,
        ["senioradmin"] = true,
        ["senioreventolog"] = true,
        ["admin"] = true,
        ["eventolog"] = true,
        ["helper"] = true,
        ["user++"] = true
    }

    CONFIG.admin_weapons = { -- оружия при спавне админа
        "weapon_physgun",
        "gmod_tool"
    }

    CONFIG.skip_checker = { -- пропускать оружие при обыске
        ["weapon_physgun"] = true,
        ["gmod_tool"] = true,
        ["weapon_hands"] = true,
        ["handcuffs"] = true,
        ["hand"] = true,
    }

    CONFIG.access_list = { -- список разрешений игрока
        ["voditel"] = {
            name = "Наземный транспорт",
            desc = [[Доступ управления наземным транспортом]],
        },

        ["pilot"] = {
            name = "Воздушный транспорт",
            desc = [[Доступ управления воздушным транспортом]],
        }
    }

    CONFIG.jail_pos = { -- позиции тюрьмы
        Vector(11080, -729, -500),
        Vector(11083, -545, -500),
        Vector(11081, -328, -500)
    }

    CONFIG.start_jobs = { -- разрешенные начальные профессии для персонажа
        [TEAM_CADET] = true,
        [TEAM_CADETRF] = true
    }

    CONFIG.max_characters = { -- максимальное число персонажей
        ["user"] = 1,
        ["founder"] = 6,
    }
end

do -- Фракция NATO
    mp.faction.nato = {}
    local NATO = mp.faction.nato

    NATO.title = "NATO"
    NATO.color = Color(69, 128, 197)

    NATO.default_team = TEAM_CADET -- стандартная профессия
    NATO.default_rank = "Рекрут" -- страндартное звание
    NATO.jail_pos = { -- позиции тюрьмы
        Vector(11080, -729, -500),
        Vector(11083, -545, -500),
        Vector(11081, -328, -500)
    }

    NATO.spawn_pos = { -- позиции спавна
        Vector(12543, -2774, -336),
        Vector(12559, -2243, -336)
    }

    NATO.whitelist = { -- Вайт-лист
        [TEAM_CADET] = {
            jobs = {   -- Разрешенные работы
                [TEAM_CADET] = true
            },
            open_menu = true -- Меню вайт-листа
        },
        [TEAM_INFYNATO] = {},
        [TEAM_TANKNATO] = {},
        [TEAM_RANGERS] = {},
        [TEAM_DELTA] = {},
        [TEAM_MPNATO] = {},
        [TEAM_AIRNATO] = {},
    }

    NATO.ranks = { -- ранги
        {
            name = "Рекрут",
            icon = Material("ranks_nato/1.png", "smooth"), -- иконка
            jobs = {},                                     -- доступные профессии {TEAM_PMC]}
            profession = {},                               -- доступные специализации {"voditel_pmc", "strelok"}
            weapons = {},                                  -- дополнительное оружие {ak47, ak74}
            spawn = function(pl)                           -- дополнительные функции при спавне
            end
        },

        {
            name = "Рядовой Первого класса",
            icon = Material("ranks_nato/2.png", "smooth"),
        },

        {
            name = "Капрал",
            icon = Material("ranks_nato/3.png", "smooth"),
        },

        {
            name = "Сержант",
            icon = Material("ranks_nato/4.png", "smooth"),
        },

        {
            name = "Штаб-сержант",
            icon = Material("ranks_nato/5.png", "smooth"),
        },

        {
            name = "Сержант Первого класса",
            icon = Material("ranks_nato/6.png", "smooth"),
        },

        {
            name = "Мастер-сержант",
            icon = Material("ranks_nato/7.png", "smooth"),
        },

        {
            name = "Первый сержант",
            icon = Material("ranks_nato/8.png", "smooth"),
        },

        {
            name = "Сержант-майор",
            icon = Material("ranks_nato/9.png", "smooth"),
        },

        {
            name = "Второй лейтенант",
            icon = Material("ranks_nato/10.png", "smooth"),
        },

        {
            name = "Первый лейтенант",
            icon = Material("ranks_nato/10.png", "smooth"),
        },

        {
            name = "Капитан",
            icon = Material("ranks_nato/11.png", "smooth"),
        },

        {
            name = "Майор",
            icon = Material("ranks_nato/12.png", "smooth"),
        },

        {
            name = "Подполковник",
            icon = Material("ranks_nato/13.png", "smooth"),
        },

        {
            name = "Полковник",
            icon = Material("ranks_nato/14.png", "smooth"),
        },
    }

    NATO.profession = { -- Специализации
        ["rifleman_nato"] = {
            name = "Стрелок",
            weapons = { "tfa_ins2_wpn_coltm4a1", "tfa_fas2_ifak" },
        },

        ["pull_nato"] = {
            name = "Пулеметчик",
            weapons = { "tfa_ins2_wpn_m249saw", "tfa_ins2_colt_m45" },
        },

        ["gran_nato"] = {
            name = "Гранатометчик",
            weapons = { "tfa_ins2_wpn_at4", "tfa_ins2_wpn_coltm4a1", "tfa_fas2_ifak" },
        },

        ["sniper_nato"] = {
            name = "Снайпер",
            weapons = { "tfa_ins2_wpn_m40a1", "tfa_ins2_wpn_berettam9", "tfa_fas2_ifak", "realistic_hook" },
            model = "models/jessev92/player/military/cod4_sniper.mdl",
        },

        ["elite_sniper_nato"] = {
            name = "Элитный Снайпер",
            weapons = { "tfa_ins2_ax50_upver", "tfa_ins2_wpn_berettam9", "tfa_fas2_ifak", "realistic_hook" },
        },

        ["elite_ranger_nato"] = {
            name = "Элитный Штурмовик",
            weapons = { "tfa_ins2_mk18", "tfa_ins2_glock_19", "tfa_fas2_ifak", "realistic_hook" },
        },

        ["elite_sso_nato"] = {
            name = "Спецназ",
            weapons = { "tfa_m4tech", "tfa_ins2_usp_match", "tfa_fas2_ifak", "realistic_hook", "alydus_fortificationbuildertablet" },
        },

        ["marksman_nato"] = {
            name = "Марксмен",
            weapons = { "tfa_ins2_sr25_eft", "tfa_ins2_wpn_berettam9", "tfa_fas2_ifak" },
            model = "models/jessev92/player/military/cod4_sniper.mdl",
        },

        ["mechanic"] = {
            name = "Механик-водитель",
            weapons = { "tfa_ins2_wpn_hkump45", "weapon_lvsrepair", "tfa_fas2_ifak", "alydus_fortificationbuildertablet" },
        },

        ["mp_nato"] = {
            name = "Военный полицейский",
            weapons = { "tfa_ins2_wpn_coltm4a1", "tfa_ins2_glock_19", "tfa_fas2_ifak", "handcuffs", "unarrest_baton", "arrest_baton", "alydus_fortificationbuildertablet" },
        },
    }

    for _, rank in ipairs(NATO.ranks) do
        mp.ranks[rank.name] = rank
    end

    for id, profession in pairs(NATO.profession) do
        mp.profession[id] = profession
    end
end

do -- Фракция РФ
    mp.faction.rf = {}
    local RF = mp.faction.rf

    RF.title = "РФ"
    RF.color = Color(200, 25, 25)

    RF.default_team = TEAM_CADETRF
    RF.default_rank = "Рядовой"
    RF.jail_pos = {
        Vector(-11024, -11259, -472),
        Vector(-11195, -11211, -472),
        Vector(-11404, -11222, -472),
    }

    RF.spawn_pos = {
        Vector(-12764, -9017, -336),
        Vector(-12349, -8943, -336)
    }

    RF.whitelist = {
        [TEAM_CADETRF] = {},
        [TEAM_INFYRF] = {},
        [TEAM_TANKRF] = {},
        [TEAM_VDVRF] = {},
        [TEAM_SSORF] = {},
        [TEAM_MPRF] = {},
        [TEAM_AIRRF] = {},
    }

    RF.ranks = {
        {
            name = "Рядовой",
            icon = Material("ranks/1.png", "smooth"),
        },

        {
            name = "Ефрейтор",
            icon = Material("ranks/2.png", "smooth"),
        },

        {
            name = "Младший Сержант",
            icon = Material("ranks/3.png", "smooth"),
        },

        {
            name = "Сержант",
            icon = Material("ranks/4.png", "smooth"),
        },

        {
            name = "Старший Сержант",
            icon = Material("ranks/5.png", "smooth"),
        },

        {
            name = "Старшина",
            icon = Material("ranks/6.png", "smooth"),
        },

        {
            name = "Прапорщик",
            icon = Material("ranks/7.png", "smooth"),
        },

        {
            name = "Старший Прапорщик",
            icon = Material("ranks/8.png", "smooth"),
        },

        {
            name = "Лейтенант",
            icon = Material("ranks/9.png", "smooth"),
        },

        {
            name = "Старший Лейтенант",
            icon = Material("ranks/10.png", "smooth"),
        },

        {
            name = "Капитан",
            icon = Material("ranks/11.png", "smooth"),
        },

        {
            name = "Майор",
            icon = Material("ranks/12.png", "smooth"),
        },

        {
            name = "Подполковник",
            icon = Material("ranks/13.png", "smooth"),
        },

        {
            name = "Полковник",
            icon = Material("ranks/14.png", "smooth"),
        },
    }

    RF.profession = {
        ["rifleman_rf"] = {
            name = "Стрелок",
            weapons = { "tfa_ins2_ak103", "tfa_fas2_ifak" },
        },

        ["pull_rf"] = {
            name = "Пулеметчик",
            weapons = { "tfa_ins2_wpn_rpkalash", "tfa_fas2_ifak" },
        },

        ["mehan_rf"] = {
            name = "Механик-водитель",
            weapons = { "tfa_ins2_wpn_aks74ukor", "weapon_lvsrepair", "tfa_fas2_ifak", "alydus_fortificationbuildertablet" },
            model = "models/arma3/russia/soldier.mdl",
            spawn = function(pl)
                pl:SetSkin(1)
            end,
        },

        ["gran_rf"] = {
            name = "Гранатометчик",
            weapons = { "tfa_ins2_wpn_aks74ukor", "tfa_ins2_wpn_rpg7", "tfa_fas2_ifak" },
            model = "models/arma3/russia/soldier.mdl",
            spawn = function(pl)
                pl:SetSkin(1)
                body(pl, { 0, 0, 6, 9, 5, 4 })
            end,
        },

        ["sniper_rf"] = {
            name = "Снайпер",
            weapons = { "tfa_ins2_warface_orsis_t5000", "tfa_smc_mp443", "realistic_hook" },
        },

        ["marksman_rf"] = {
            name = "Марксмен",
            weapons = { "tfa_eft_svd", "tfa_smc_mp443", "realistic_hook" },
        },

        ["mp_rf"] = {
            name = "Военный Полицейский",
            weapons = { "tfa_ins2_akm", "tfa_smc_mp443", "tfa_fas2_ifak", "arrest_baton", "unarrest_baton", "handcuffs", "realistic_hook", "alydus_fortificationbuildertablet" },
            spawn = function(pl)
                pl:SetSkin(1)
                body(pl, { 0, 0, 22, 0, 0, 0, 0 })
            end,
        },

        ["elite_sniper_rf"] = {
            name = "Элитный Снайпер",
            weapons = { "tfa_ins2_warface_orsis_t5000", "tfa_ins2_wpn_makarovpistol", "realistic_hook" },
        },

        ["elite_rifleman_rf"] = {
            name = "Элитный Штурмовик",
            weapons = { "tfa_ins2_wpn_ak74izh", "tfa_smc_mp443", "tfa_fas2_ifak", "realistic_hook" },
        },

        ["elite_sso_rf"] = {
            name = "Спецназ",
            weapons = { "tfa_inss_asval", "tfa_smc_mp443", "tfa_fas2_ifak", "realistic_hook", "alydus_fortificationbuildertablet" },
        },
    }

    for _, rank in ipairs(RF.ranks) do
        mp.ranks[rank.name] = rank
    end

    for id, profession in pairs(RF.profession) do
        mp.profession[id] = profession
    end
end
