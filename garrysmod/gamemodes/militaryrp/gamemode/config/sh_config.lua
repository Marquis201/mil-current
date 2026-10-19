local Vector = Vector
local Color = Color
local mp = mp
local Material = Material
local Angle = Angle

local dir_special = "materials/military_play/tab/"

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

    CONFIG.flag_reward = 100                          -- награда за захват флага
    CONFIG.spawn_vehicle = 3                          -- время до спавна техники
    CONFIG.reswn_time = 60                            -- время до возраждения
    CONFIG.start_money = 100                          -- начальные деньги
    CONFIG.start_menu_pos = Vector(7931, -4307, 6287) -- начальная позиция для зашедшего игрока
    CONFIG.spawn_menu = {                             -- доступ к qmenu
        ["founder"] = true,
        ["curator"] = true,
        ["sudocurator"] = true,
        ["superadmin"] = true,
        ["sadmin"] = true,
        ["senioradmin"] = true,
        ["senioreventolog"] = true,
        ["admin-j"] = true,
        ["eventolog"] = true,
        ["helper"] = true
    }

    CONFIG.Limits = { -- Общие лимиты
        ["dynamite"]                         = 0,
        ["hoverballs"]                       = 0,
        ["turrets"]                          = 0,
        ["spawners"]                         = 0,
        ["emitters"]                         = 0,
        ["effects"]                          = 0,
        ["buttons"]                          = 10,
        ["ragdolls"]                         = 0,
        ["npcs"]                             = 10,
        ["lamps"]                            = 10,
        ["balloons"]                         = 4,
        ["lights"]                           = 4,
        ["props"]                            = 120,
        ["vehicles"]                         = 2,
        ["sents"]                            = 20,
        ["keypads"]                          = 10,
        ["textscreens"]                      = 4,
        ["cameras"]                          = 3,
        ["alydus_destructiblefortification"] = 60
    }

    CONFIG.NoLimits = {
        ["founder"] = true,
        ["curator"] = true
    }

    mp.config.LimitsGroup = { -- Лимиты для группы (суммируются с базовыми)
        ["sudocurator"] = {
            props = 1000
        },
        ["sadmin"] = {
            props = 1000
        },
        ["superadmin"] = {
            props = 1000
        },
        ["senioreventolog"] = {
            props = 3000,
            npcs = 30,
            vehicles = 5,
        },
        ["eventolog"] = {
            props = 1000,
            npcs = 30,
            vehicles = 5,
        },
        ["helper"] = {
            props = 300
        },
        ["cmd+"] = {
            props = 300
        },
        ["vip"] = {
            alydus_destructiblefortification = 5
        },
        ["user++"] = {
            props = 300
        }
    }

    CONFIG.whitelist = { -- полный доступ к вайт-листу по рангу
        ["founder"] = true,
        ["curator"] = true,
        ["sudocurator"] = true,
        ["sadmin"] = true,
        ["superadmin"] = true,
        ["senioradmin"] = true,
        ["senioreventolog"] = true,
        ["admin-j"] = true,
        ["eventolog"] = true,
        ["helper"] = true,
        ["cmd+"] = true,
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
        },

        ["razvedka"] = {
            name = "Набор разведчика",
            desc = [[Доступ к набор разведчика]],
            armor_take = {
                "realistic_hook"
            }
        },

        ["milpolice"] = {
            name = "Набор Военной Полиции",
            desc = [[Доступ к набору военной полиции]],
            armor_take = {
                "handcuffed", "arrest_baton", "unarrest_baton", "tfa_realistic_taser",
                "alydus_fortificationbuildertablet"
            }
        },
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
        ["curator"] = 2,
        ["sadmin"] = 2,
        ["helper"] = 2,
        ["senioreventolog"] = 2,
        ["eventolog"] = 2,
        ["vip"] = 2,
        ["STEAM_0:0:570454016"] = 3
    }

    CONFIG.advert_time = 2 -- время между сообщениями в чате
    CONFIG.advert = {      -- сообщения в чате
        {
            { Color(255, 25, 25), "[Military-Play]", Color(255, 255, 255), "Discord: ", Color(255, 255, 255), "https://discord.gg/m9MFYp2gDq" },
        },

        {
            { Color(255, 25, 25), "[Military-Play]", Color(255, 25, 25), "Используйте команды: ", Color(255, 255, 255), "/com /pass /rf /nato" },
        },

    }

    CONFIG.vehicle_info = { -- ттх для техники
        ["sw_gaz2330"] = {
            seats = 8,      -- количество мест
            --operator = false,  -- место стрелка (пулеметчика)
            --commander = false, -- место командира
            pweapon = "Без вооружения", -- основное оружие (название: ПУШКА 228)
            --sweapon = "", -- дополнительное оружие (название: ПУЛЕМЁТ 228)
            --tweapon = "", -- дополнительное оружие (название: РАКЕТНИЦА 228)
        },

        ["sw_hemtt_cargo"] = {
            seats = 2,
            pweapon = "Без вооружения",
        },

        ["sw_hemtt_fuel"] = {
            seats = 2,
            pweapon = "Без вооружения",
        },

        ["sw_hemtt_troop"] = {
            seats = 14,
            pweapon = "Без вооружения",
        },

        ["sw_kamaz5350"] = {
            seats = 17,
            pweapon = "Без вооружения",
        },

        ["sw_gaz2330_9m133"] = {
            pweapon = "10x ПТУР 9М133",
            seats = 8,
        },

        ["sw_gaz2330_ags30"] = {
            pweapon = "1x 30мм гранатомёт АГС-30",
            seats = 8,
        },

        ["sw_gaz2330_kord"] = {
            pweapon = "1x 12.7мм пулемёт Корд",
            seats = 8,
        },

        ["sw_gaz2330_kord_auto"] = {
            pweapon = "1x 12.7мм пулемёт Корд",
            seats = 8,
        },

        ["sw_gaz2330_pkm"] = {
            pweapon = "1x 7.62мм пулемёт ПКП",
            seats = 8,
        },

        ["sw_bmp2m"] = {
            seats = 8,
            pweapon = "30-мм автоматическая пушка 2А42",
            sweapon = "ПТРК «Корнет», 30-мм АГ-30, 7,62-мм ПКТМ",
            tweapon = "СУО",
        },

        ["sw_bmpt72"] = {
            seats = 3,
            pweapon = "2 x 30-мм автоматическая пушка 2А42",
            sweapon = "Атака-Т, ПКТМ",
            tweapon = "СУО",
        },

        ["sw_bmp3m"] = {
            seats = 8,
            pweapon = "30-мм автоматическая пушка 2А42",
            sweapon = "ПТРК «Корнет», 30-мм АГ-30, 7,62-мм ПКТМ",
            tweapon = "СУО",
        },

        ["lvs_wheeldrive_nonrp_t90m"] = {
            seats = 2,
            pweapon = "125-мм (2А46М-5)",
            sweapon = "7,62-мм пулемет ПКТМ",
            tweapon = "СУО",
        },

        ["sw_t90m"] = {
            seats = 2,
            pweapon = "125-мм (2А46М)",
            sweapon = "7,62-мм пулемет ПКТМ",
            tweapon = "СУО",
        },

        ["sw_t90m_arena"] = {
            seats = 2,
            pweapon = "125-мм (2A46M-5)",
            sweapon = "7,62-мм пулемет ПКТМ",
            tweapon = "СУО",
        },

        ["lvs_wheeldrive_hummer"] = {
            pweapon = "Без вооружения",
            seats = 4,
        },

        ["lvs_wheeldrive_hummer_m134"] = {
            pweapon = "Миниган M134",
            seats = 4,
        },

        ["lvs_wheeldrive_hummer_mk19"] = {
            pweapon = "Пулемёт MK19",
            seats = 4,
        },

        ["sw_matv"] = {
            seats = 4,
            pweapon = "1x 7мм пулемёт M240",
        },

        ["sw_matv_mk19"] = {
            seats = 4,
            pweapon = "1x 40мм гранатомёт MК19",
        },

        ["sw_matv_m2"] = {
            seats = 4,
            pweapon = "1x 12.7мм пулемёт M2",
        },

        ["sw_m3a3"] = {
            seats = 10,
            pweapon = "25-мм автоматическая пушка (M242 Bushmaster)",
            sweapon = "ПТРК (TOW-2)",
            tweapon = "СУО",
        },

        ["sw_eitan"] = {
            seats = 11,
            pweapon = "25-мм автоматическая пушка (M242 Bushmaster)",
            sweapon = "M2 Browning",
            tweapon = "СУО",
        },

        ["sw_puma"] = {
            seats = 11,
            pweapon = "30-мм автоматическая пушка",
            sweapon = "HK MG4",
            tweapon = "СУО",
        },

        ["lvs_wheeldrive_rp_dabrams_m1a1"] = {
            seats = 5,
            pweapon = "120-мм орудие (M256)",
            sweapon = "M2 Browning",
            tweapon = "СУО",
        },

        ["sw_leo2a6m"] = {
            seats = 4,
            pweapon = "120-мм орудие (M256)",
            sweapon = "MG3A1",
            tweapon = "СУО",
        },

        ["sw_leo2a4"] = {
            seats = 4,
            pweapon = "120-мм орудие (M256)",
            sweapon = "C6 GPMG",
            tweapon = "СУО",
        },

        ["sw_vdvbuggy"] = {
            seats = 3,
            pweapon = "7,62-мм пулемет ПКТМ",
        },

        ["sw_quadbike"] = {
            seats = 2,
            pweapon = "Без вооружения",
        },

        ["sw_uh60"] = {
            seats = 16,
            pweapon = "Без вооружения",
        },

    }

    CONFIG.vehicles = { -- разрешения техники
        ["sw_gaz2330"] = {
            [1] = {
                profession = { rifleman_rf = true, mehan_rf = true, gran_rf = true, sniper_rf = true, marksman_rf = true, mp_rf = true, med_rf = true, elite_sniper_rf = true, elite_rifleman_rf = true, elite_sso_rf = true },
            },
            modifications = { "sw_gaz2330", "sw_gaz2330_9m133", "sw_gaz2330_ags30", "sw_gaz2330_kord", "sw_gaz2330_kord_auto", "sw_gaz2330_pkm" },
            access = "voditel", -- это кастомный доступ, который берётся из access_list
        },

        ["sw_vdvbuggy"] = {
            [1] = {
                profession = { rifleman_rf = true, mehan_rf = true, gran_rf = true, sniper_rf = true, marksman_rf = true, mp_rf = true, med_rf = true, elite_sniper_rf = true, elite_rifleman_rf = true, elite_sso_rf = true },
            },
            access = "voditel",
        },

        ["sw_bmp2m"] = {
            [1] = {
                profession = { mehan_rf = true }
            },
            [2] = {
                profession = { mehan_rf = true, pull_rf = true }
            },
            [3] = {
                profession = { rifleman_rf = true, mehan_rf = true, gran_rf = true, sniper_rf = true, marksman_rf = true, mp_rf = true, med_rf = true, elite_sniper_rf = true, elite_rifleman_rf = true, elite_sso_rf = true }
            },
            access = "voditel",
        },

        ["sw_bmp3m"] = {
            [1] = {
                profession = { mehan_rf = true }
            },
            [2] = {
                profession = { mehan_rf = true, pull_rf = true }
            },
            [3] = {
                profession = { rifleman_rf = true, mehan_rf = true, gran_rf = true, sniper_rf = true, marksman_rf = true, mp_rf = true, med_rf = true, elite_sniper_rf = true, elite_rifleman_rf = true, elite_sso_rf = true }
            },
            access = "voditel",
        },

        ["lvs_wheeldrive_nonrp_t90m"] = {
            [1] = {
                profession = { mehan_rf = true }
            },
            [2] = {
                profession = { mehan_rf = true, pull_rf = true }
            },
            access = "voditel",
        },

        ["sw_t90m"] = {
            [1] = {
                profession = { mehan_rf = true }
            },
            [2] = {
                profession = { mehan_rf = true, pull_rf = true }
            },
            access = "voditel",
        },

        ["sw_t90m_arena"] = {
            [1] = {
                profession = { mehan_rf = true }
            },
            [2] = {
                profession = { mehan_rf = true, pull_rf = true }
            },
            access = "voditel",
        },

        ["lvs_wheeldrive_hummer"] = {
            [1] = {
                profession = { mechanic_nato = true, rifleman_nato = true, med_nato = true, pull_nato = true, gran_nato = true, sniper_nato = true, marksman_nato = true, mp_nato = true, elite_ranger_sniper_nato = true, elite_ranger_nato = true, elite_sso_nato = true, gsg9_nato = true, gsg9_nato_m249 = true, gsg9nato_gran = true, gsg9nato_med = true, gsg9nato_sniper = true, glav_nato = true }
            },
            modifications = { "lvs_wheeldrive_hummer", "lvs_wheeldrive_hummer_m134", "lvs_wheeldrive_hummer_m2", "lvs_wheeldrive_hummer_m240", "lvs_wheeldrive_hummer_mk19", "lvs_wheeldrive_hummer_tow" },
            access = "voditel",
        },

        ["sw_quadbike"] = {
            [1] = {
                profession = { mechanic_nato = true, rifleman_nato = true, med_nato = true, pull_nato = true, gran_nato = true, sniper_nato = true, marksman_nato = true, mp_nato = true, elite_ranger_sniper_nato = true, elite_ranger_nato = true, elite_sso_nato = true, gsg9_nato = true, gsg9_nato_m249 = true, gsg9nato_gran = true, gsg9nato_med = true, gsg9nato_sniper = true, glav_nato = true }
            },
            access = "voditel",
        },

        ["sw_m3a3n"] = {
            [1] = {
                profession = { mechanic_nato = true }
            },
            access = "voditel",
        },

        ["sw_eitan"] = {
            [1] = {
                profession = { mechanic_nato = true }
            },
            access = "voditel",
        },

        ["sw_puma"] = {
            [1] = {
                profession = { mechanic_nato = true }
            },
            access = "voditel",
        },

        ["sw_uh60"] = {
            [1] = {
                profession = { airsofter_nato = true }
            },
            access = "voditel",
        },

        ["lvs_wheeldrive_rp_dabrams_m1a1"] = {
            [1] = {
                profession = { mechanic_nato = true }
            },
            [2] = {
                profession = { mechanic_nato = true, pull_nato = true }
            },
            access = "voditel",
        },

        ["sw_leo2a4"] = {
            [1] = {
                profession = { mechanic_nato = true }
            },
            [2] = {
                profession = { mechanic_nato = true, pull_nato = true }
            },
            access = "voditel",
        },

        ["sw_leo2a6m"] = {
            [1] = {
                profession = { mechanic_nato = true }
            },
            [2] = {
                profession = { mechanic_nato = true, pull_nato = true }
            },
            access = "voditel",
        },

        ["sw_bmpt72"] = {
            [1] = {
                profession = { mehan_rf = true }
            },
            [2] = {
                profession = { mehan_rf = true }
            },
            access = "voditel",
        },

        ["sw_kamaz5350"] = {
            [1] = {
                profession = { rifleman_rf = true, mehan_rf = true, gran_rf = true, sniper_rf = true, marksman_rf = true, mp_rf = true, med_rf = true, elite_sniper_rf = true, elite_rifleman_rf = true, elite_sso_rf = true },
            },
            access = "voditel",
        },

        ["sw_hemtt_troop"] = {
            [1] = {
                profession = { mechanic_nato = true, mp_nato = true, elite_ranger_sniper_nato = true, elite_ranger_nato = true, elite_sso_nato = true }
            },
            modifications = { "sw_hemtt_troop", "sw_hemtt_fuel", "sw_hemtt_cargo" },
            access = "voditel",
        },
    }

    CONFIG.spawn_npcs = {
        ["tunnel"] = {
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(-10283, -1147, -295), ang = Angle(0, -121, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(-9695, -1458, -303),  ang = Angle(0, -78, 0) },
            { mdl = "models/props_c17/oildrum001.mdl",           class = "prop_physics",           pos = Vector(-8043, -1919, -244),  ang = Angle(0, 38, 0) },
            { mdl = "models/props_c17/oildrum001.mdl",           class = "prop_physics",           pos = Vector(-8843, -2970, -257),  ang = Angle(0, -46, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(-9731, -2873, -304),  ang = Angle(1, -22, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(-1059, -2560, -304),  ang = Angle(0, 10, 0) },

            { class = "super_pmc_bad",                           pos = Vector(-9707, 11307, -512), ang = Angle(8, -91, 0) },
            { class = "super_pmc_bad",                           pos = Vector(-9507, 11451, -512), ang = Angle(12, -25, 0) },
            { class = "super_pmc_bad",                           pos = Vector(-9615, 11584, -512), ang = Angle(16, -28, 0) },
            { class = "super_pmc_bad",                           pos = Vector(-9702, 11421, -512), ang = Angle(12, -32, 0) },
        },

        ["water"] = {

            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(1422, -12942, -511), ang = Angle(0, 7, 0) },
            { mdl = "models/props_c17/oildrum001.mdl",           class = "prop_physics",           pos = Vector(1395, -12877, -512), ang = Angle(0, 60, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(1188, -12764, -513), ang = Angle(2, 89, 0) },
            { mdl = "models/props_c17/oildrum001.mdl",           class = "prop_physics",           pos = Vector(981, -12752, -512),  ang = Angle(0, 69, 0) },
            { mdl = "models/props_c17/oildrum001.mdl",           class = "prop_physics",           pos = Vector(957, -12767, -511),  ang = Angle(0, 70, -1) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(885, -12760, -511),  ang = Angle(0, 91, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",           pos = Vector(631, -12857, -511),  ang = Angle(0, 143, 0) },

            { class = "super_pmc_bad",                           pos = Vector(890, -12799, -512),  ang = Angle(14, 90, 0) },
            { class = "super_pmc_bad",                           pos = Vector(1255, -12850, -512), ang = Angle(14, 63, 0) },
            { class = "super_pmc_bad",                           pos = Vector(1150, -13045, -512), ang = Angle(18, 110, 0) },
            { class = "super_pmc_bad",                           pos = Vector(457, -13112, -507),  ang = Angle(15, 29, 0) },

        },

        ["city"] = {
            { mdl = "models/props_c17/oildrum001.mdl",           class = "prop_physics",         pos = Vector(-9785, 13, -495),  ang = Angle(0, -33, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",         pos = Vector(-9855, -10, -495), ang = Angle(0, -81, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",         pos = Vector(-9756, 522, -495), ang = Angle(0, 23, 0) },
            { mdl = "models/props_c17/concrete_barrier001a.mdl", class = "prop_physics",         pos = Vector(-9893, 639, -496), ang = Angle(0, 67, 0) },

            { class = "super_pmc_bad",                           pos = Vector(2056, -4219, -408), ang = Angle(9, 58, 0) },
            { class = "super_pmc_bad",                           pos = Vector(2147, -4656, -431), ang = Angle(5, 4, 0) },
            { class = "super_pmc_bad",                           pos = Vector(2761, -4768, -455), ang = Angle(14, 93, 0) },
            { class = "super_pmc_bad",                           pos = Vector(1815, -4314, -434),  ang = Angle(15, -57, 0) },


        }
    }
end

do -- Фракция NATO
    mp.faction.nato = {}
    local NATO = mp.faction.nato

    NATO.title = "NATO"
    NATO.color = Color(69, 128, 197)
    NATO.logo = Material("military_play/character_system/icons/usa.png", "smooth")

    NATO.default_team = TEAM_CADET -- стандартная профессия
    NATO.default_rank = "Рекрут" -- страндартное звание
    NATO.jail_pos = { -- позиции тюрьмы
        Vector(11063, -714, -472),
        Vector(11044, -517, -472),
        Vector(11042, -317, -472)
    }

    NATO.spawn_pos = { -- позиции спавна
        Vector(12533, -2273, -296),
        Vector(12488, -2728, -285)
    }

    NATO.spawn_vehicle = {                    -- позиции спавна техники
        {
            pos = Vector(12582, -1778, -512), --12574, -1309, -504
            ang = Angle(0, -90, 0),
        },

        {
            pos = Vector(12875, -1794, -512), --12838, -1310, -504
            ang = Angle(0, -90, 0),
        },

        {
            pos = Vector(11289, -1593, -512), --12838, -1310, -504
            ang = Angle(0, -90, 0),
        },
        -- {
        --     pos = Vector(13076, -1312, -504),
        --     ang = Angle(0, -90, 0),
        -- },
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
            name = "Сержант НАТО",
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
            whitelist = true
        },

        {
            name = "Капитан НАТО",
            icon = Material("ranks_nato/11.png", "smooth"),
            whitelist = true
        },

        {
            name = "Майор НАТО",
            icon = Material("ranks_nato/12.png", "smooth"),
            whitelist = true,
            preset = true,

        },

        {
            name = "Подполковник НАТО",
            icon = Material("ranks_nato/13.png", "smooth"),
            whitelist = true,
            preset = true,

        },

        {
            name = "Полковник НАТО",
            icon = Material("ranks_nato/14.png", "smooth"),
            whitelist = true,
            preset = true,

        },
    }

    NATO.profession = { -- Специализации
        ["rifleman_nato"] = {
            name = "Стрелок",
            draw_weapon = "tfa_ins2_wpn_coltm4a1",
            weapons = { "tfa_ins2_wpn_coltm4a1", "tfa_fas2_ifak", "tfa_ins2_wpn_m45a1", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "shoot.png"),
            perk = "add_speed",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["med_nato"] = {
            name = "Медик",
            draw_weapon = "tfa_ins2_wpn_coltm4a1",
            weapons = { "tfa_ins2_wpn_coltm4a1", "revive_swep", "tfa_fas2_ifak", "tfa_ins2_wpn_m45a1", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "medic.png"),
            perk = "medkit_crate",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["pull_nato"] = {
            name = "Пулеметчик",
            draw_weapon = "tfa_ins2_wpn_m249saw",
            weapons = { "tfa_ins2_wpn_m249saw", "tfa_ins2_colt_m45", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "gunner.png"),
            perk = "ammo_crate",
            add_stats = {
                armor = 100,
                health = 100
            }
        },



        ["gran_nato"] = {
            name = "Гранатометчик",
            draw_weapon = "tfa_ins2_wpn_at4",
            weapons = { "tfa_ins2_wpn_at4", "tfa_ins2_wpn_coltm4a1", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "grenade.png"),
            perk = "place_mine",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["sniper_nato"] = {
            name = "Снайпер",
            draw_weapon = "tfa_ins2_wpn_m40a1",
            weapons = { "tfa_ins2_wpn_m40a1", "tfa_ins2_wpn_m1911colt", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "sniper.png"),
            perk = "place_bomb",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["marksman_nato"] = {
            name = "Марксмен",
            draw_weapon = "tfa_ins2_sr25_eft",
            weapons = { "tfa_ins2_sr25_eft", "tfa_ins2_wpn_m1911colt", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["mechanic_nato"] = {
            name = "Механик-водитель",
            draw_weapon = "tfa_ins2_mp7",
            weapons = { "tfa_ins2_mp7", "weapon_lvsrepair", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_ins2_pmtfa_ins2_wpn_m1911colt", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "mechanic.png"),
            perk = "repair_vehicle",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["airsofter_nato"] = {
            name = "Механик-пилот",
            draw_weapon = "tfa_ins2_mp7",
            weapons = { "tfa_ins2_mp7", "weapon_lvsrepair", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_ins2_pmtfa_ins2_wpn_m1911colt", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "mechanic.png"),
            perk = "repair_vehicle",
            add_stats = {
                armor = 100,
                health = 100
            }
        },
        -----------------------------------------------------------------------------------------
        ["elite_ranger_sniper_nato"] = {
            name = "RANGER | Снайпер",
            draw_weapon = "tfa_ins2_wpn_m40a1",
            weapons = { "tfa_ins2_wpn_m40a1", "tfa_ins2_wpn_m1911colt", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "sniper.png"),
            perk = "place_bomb",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_ranger_nato"] = {
            name = "RANGER | Штурмовик",
            draw_weapon = "tfa_m4tech",
            weapons = { "tfa_m4tech", "tfa_ins2_glock_19", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "shoot.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_ranger_at4_nato"] = {
            name = "RANGER | Гранатометчик",
            draw_weapon = "tfa_ins2_aug_a3",
            weapons = { "tfa_ins2_aug_a3", "tfa_ins2_wpn_at4", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "grenade.png"),
            perk = "place_mine",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_ranger_medic_nato"] = {
            name = "RANGER | Медик",
            draw_weapon = "tfa_ins2_aug_a3",
            weapons = { "tfa_ins2_aug_a3", "tfa_ins2_wpn_at4revive_swep", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "medic.png"),
            perk = "medkit_crate",
            add_stats = {
                armor = 150,
                health = 100
            }
        },
        ["glav_nato"] = {
            name = "Генеральный Секретарь",
            draw_weapon = "tfa_m4tech",
            weapons = { "tfa_m4tech", "tfa_ins2_usp_match", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "special.png"),
            perk = "armor_crate",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_sso_nato"] = {
            name = "DELTA | Спецназовец",
            draw_weapon = "tfa_m4tech",
            weapons = { "tfa_m4tech", "tfa_ins2_usp_match", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 200,
                health = 100
            }
        },
        -------------------------------------------------------GSG-9-------------------------------------------------------------------------
        ["gsg9_nato"] = {
            name = "KSK | Спецназовец",
            draw_weapon = "tfa_ins2_wpn_hkg36compact",
            weapons = { "tfa_ins2_wpn_hkg36compact", "tfa_ins2_usp_match", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["gsg9nato_sniper"] = {
            name = "KSK | Снайпер",
            draw_weapon = "tfa_ins2_warface_cheytac_m200",
            weapons = { "tfa_ins2_warface_cheytac_m200", "tfa_ins2_usp_match", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "sniper.png"),
            perk = "place_bomb",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["gsg9_nato_m249"] = {
            name = "KSK | Пулеметчик",
            draw_weapon = "tfa_ins2_wpn_m249saw",
            weapons = { "tfa_ins2_wpn_m249saw", "tfa_ins2_colt_m45", "tfa_m67" },
            icon = Material(dir_special .. "gunner.png"),
            perk = "ammo_crate",
            add_stats = {
                armor = 100,
                health = 100
            }
        },
        ["gsg9nato_gran"] = {
            name = "KSK | Гранатометчик",
            draw_weapon = "tfa_ins2_wpn_hkg36compact",
            weapons = { "tfa_ins2_wpn_hkg36compact", "tfa_ins2_wpn_at4", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "grenade.png"),
            perk = "place_mine",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["gsg9nato_med"] = {
            name = "KSK | Медик ",
            draw_weapon = "tfa_ins2_wpn_hkg36compact",
            weapons = { "tfa_ins2_wpn_hkg36compact", "revive_swep", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "medic.png"),
            perk = "medkit_crate",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ----------------------------------------------------BLACKWATCH---------------------------------------------------------------------

        ["black_nato"] = {
            name = "BlackWatch | Спецназовец",
            draw_weapon = "tfa_ins2_aug_a3",
            weapons = { "tfa_ins2_aug_a3", "tfa_ins2_usp_match", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 200,
                health = 100
            }
        },

        ["blacknato_sniper"] = {
            name = "BlackWatch | Снайпер",
            draw_weapon = "tfa_ins2_warface_cheytac_m200",
            weapons = { "tfa_ins2_warface_cheytac_m200", "tfa_ins2_usp_match", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "sniper.png"),
            perk = "place_bomb",
            add_stats = {
                armor = 200,
                health = 100
            }
        },

        ["black_nato_m249"] = {
            name = "BlackWatch | Пулеметчик",
            draw_weapon = "tfa_ins2_wpn_m249saw",
            weapons = { "tfa_ins2_wpn_m249saw", "tfa_ins2_colt_m45", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "gunner.png"),
            perk = "ammo_crate",
            add_stats = {
                armor = 100,
                health = 100
            }
        },
        ["blacknato_gran"] = {
            name = "BlackWatch | Гранатометчик",
            draw_weapon = "tfa_ins2_aug_a3",
            weapons = { "tfa_ins2_aug_a3", "tfa_ins2_wpn_at4", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "grenade.png"),
            perk = "place_mine",
            add_stats = {
                armor = 200,
                health = 100
            }
        },

        ["blacknato_med"] = {
            name = "BlackWatch | Медик ",
            draw_weapon = "tfa_inss2_hk_mp5a5",
            perk = "medkit_crate",
            weapons = { "tfa_inss2_hk_mp5a5", "revive_swep", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "medic.png"),
            add_stats = {
                armor = 200,
                health = 100
            }
        },



        ["sas_med"] = {
            name = "SAS | Оперативник (ДОНАТ) ",
            draw_weapon = "tfa_inss2_l85a2",
            weapons = { "tfa_inss2_l85a2", "tfa_ins2_panzerfaust3", "tfa_fas2_ifak", "tfa_m67", "tfa_ins2_kabar" },
            icon = Material(dir_special .. "shoot.png"),
            add_stats = {
                armor = 140,
                health = 100
            }
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
    RF.logo = Material("military_play/character_system/icons/russia.png", "smooth")

    RF.default_team = TEAM_CADETRF
    RF.default_rank = "Рядовой"
    RF.jail_pos = {
        Vector(-11377, -11252, -472),
        Vector(-11185, -11248, -472),
        Vector(-10990, -11242, -472)
    }

    RF.spawn_pos = {
        Vector(-12793, -9948, -336),
        Vector(-12790, -9722, -336),
        Vector(-12780, -9589, -336)
    }

    RF.spawn_vehicle = {
        {
            pos = Vector(-12947, -10747, -512), --12574, -1309, -504
            ang = Angle(0, 0, 0),
        },

        {
            pos = Vector(-12948, -11011, -512), --12838, -1310, -504
            ang = Angle(0, 0, 0),
        },

        {
            pos = Vector(-12945, -11265, -512), --12838, -1310, -504
            ang = Angle(0, 0, 0),
        },
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
            whitelist = true
        },

        {
            name = "Капитан",
            icon = Material("ranks/11.png", "smooth"),
            whitelist = true
        },

        {
            name = "Майор",
            icon = Material("ranks/12.png", "smooth"),
            whitelist = true,
            preset = true,

        },

        {
            name = "Подполковник",
            icon = Material("ranks/13.png", "smooth"),
            whitelist = true,
            preset = true,

        },

        {
            name = "Полковник",
            icon = Material("ranks/14.png", "smooth"),
            whitelist = true,
            preset = true,

        },
    }

    RF.profession = {
        ["rifleman_rf"] = {
            name = "Стрелок",
            draw_weapon = "tfa_ins2_ak103",
            weapons = { "tfa_ins2_ak103", "tfa_fas2_ifak", "tfa_ins2_pm", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "shoot.png"),
            perk = "add_speed",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["med_rf"] = {
            name = "Медик",
            draw_weapon = "tfa_ins2_ak103",
            weapons = { "tfa_ins2_ak103", "revive_swep", "tfa_fas2_ifak", "tfa_ins2_pm", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "medic.png"),
            perk = "medkit_crate",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["pull_rf"] = {
            name = "Пулеметчик",
            draw_weapon = "tfa_ins2_wpn_rpkalash",
            weapons = { "tfa_ins2_wpn_rpkalash", "tfa_fas2_ifak", "tfa_ins2_pm", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "gunner.png"),
            perk = "ammo_crate",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["mehan_rf"] = {
            name = "Механик-водитель",
            draw_weapon = "tfa_ins2_wpn_aks74ukor",
            weapons = { "tfa_ins2_wpn_aks74ukor", "weapon_lvsrepair", "tfa_fas2_ifak", "alydus_fortificationbuildertablet", "tfa_ins2_pm", "tfa_rgd5", "tfa_l4d2mw_knife" },
            model = "models/arma3/russia/soldier.mdl",
            perk = "repair_vehicle",
            icon = Material(dir_special .. "mechanic.png"),
            spawn = function(pl)
                pl:SetSkin(1)
            end,
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["gran_rf"] = {
            name = "Гранатометчик",
            draw_weapon = "tfa_ins2_wpn_aks74ukor",
            weapons = { "tfa_ins2_wpn_aks74ukor", "tfa_ins2_wpn_rpg7", "tfa_fas2_ifak", "tfa_ins2_pm", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "grenade.png"),
            perk = "place_mine",
            model = "models/arma3/russia/soldier.mdl",
            spawn = function(pl)
                pl:SetSkin(1)
                body(pl, { 0, 0, 6, 9, 5, 4 })
            end,
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["sniper_rf"] = {
            name = "Снайпер",
            draw_weapon = "tfa_ins2_warface_orsis_t5000",
            weapons = { "tfa_ins2_warface_orsis_t5000", "tfa_ins2_pm", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "sniper.png"),
            perk = "place_bomb",
            add_stats = {
                armor = 100,
                health = 100
            }
        },


        ["marksman_rf"] = {
            name = "Марксмен",
            draw_weapon = "tfa_eft_svd",
            weapons = { "tfa_eft_svd", "tfa_ins2_pm", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 100,
                health = 100
            }
        },

        ["elite_sniper_rf"] = {
            name = "VDV | Снайпер",
            draw_weapon = "tfa_ins2_warface_orsis_t5000",
            weapons = { "tfa_ins2_warface_orsis_t5000", "tfa_ins2_pm", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "sniper.png"),
            perk = "place_bomb",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_rifleman_rf"] = {
            name = "VDV | Штурмовик",
            draw_weapon = "tfa_ins2_wpn_ak74izh",
            weapons = { "tfa_ins2_wpn_ak74izh", "tfa_ins2_pm", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_gunner_rf"] = {
            name = "VDV | Пулеметчик",
            draw_weapon = "tfa_ins2_wpn_rpkalash",
            weapons = { "tfa_ins2_wpn_rpkalash", "tfa_ins2_pm", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "gunner.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_grenade_rf"] = {
            name = "VDV | Гранатометчик",
            draw_weapon = "tfa_ins2_wpn_rpkalash",
            weapons = { "tfa_ins2_wpn_rpkalash", "tfa_ins2_wpn_rpg7", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "grenade.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["glav_rf"] = {
            name = "Министерство Обороны",
            draw_weapon = "tfa_ins2_wpn_ak74izh",
            weapons = { "tfa_ins2_wpn_ak74izh", "tfa_ins2_pm", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "special.png"),
            perk = "armor_crate",
            add_stats = {
                armor = 150,
                health = 100
            }
        },


        ["fsb_oper"] = {
            name = "ФСБ | Оперативник",
            draw_weapon = "tfa_ins2_ak12",
            weapons = { "tfa_ins2_ak12", "tfa_ins2_pm", "alydus_fortificationbuildertablet", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["fsb_sniper"] = {
            name = "ФСБ | Снайпер",
            draw_weapon = "tfa_ins2_warface_orsis_t5000",
            weapons = { "tfa_ins2_warface_orsis_t5000", "tfa_ins2_pm", "alydus_fortificationbuildertablet", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "sniper.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["fsb_gunner"] = {
            name = "ФСБ | Пулеметчик",
            draw_weapon = "tfa_ins2_pkp",
            weapons = { "tfa_ins2_pkp", "tfa_ins2_pm", "alydus_fortificationbuildertablet", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },
        ["fsb_grenade"] = {
            name = "ФСБ | Гранатометчик",
            draw_weapon = "tfa_ins2_abakan",
            weapons = { "tfa_ins2_abakan", "tfa_ins2_wpn_rpg7", "alydus_fortificationbuildertablet", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "grenade.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 150,
                health = 100
            }
        },

        ["elite_sso_rf"] = {
            name = "ССО | Оперативник",
            draw_weapon = "tfa_at_ak_15",
            weapons = { "tfa_at_ak_15", "tfa_ins2_pm", "alydus_fortificationbuildertablet", "tfa_fas2_ifak", "tfa_rgd5", "tfa_l4d2mw_knife" },
            icon = Material(dir_special .. "special.png"),
            perk = "protect_damage",
            add_stats = {
                armor = 200,
                health = 100
            }
        },
    }

    for _, rank in ipairs(RF.ranks) do
        mp.ranks[rank.name] = rank
    end

    for id, profession in pairs(RF.profession) do
        mp.profession[id] = profession
    end
end
