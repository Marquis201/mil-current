local PLAYER = PLAYER
local Material = Material
local mp = mp

function PLAYER:GetLevel()
    return self:GetNetVar("meta_level") or 0
end

function PLAYER:GetExperience()
    return self:GetNetVar("meta_experience") or 0
end

function PLAYER:LevelToExperience(intLevel)
    return math.Round(((intLevel ^ 2) * 100))
end

function PLAYER:GetNeedExperience()
    return self:LevelToExperience(self:GetLevel())
end

function PLAYER:HasLevel(num)
    if not self:GetLevel() then return end

    return (tonumber(self:GetLevel()) >= num)
end

mp.Perks = {
    -- Крепкие кости --
    [1] = {
        name = "Крепкие кости I", -- название
        material = Material("perks/strong_bones.png"), -- иконка
        effect = 40, -- эффект от перка
        level = 22, -- уровень необходимый для перка
        exp = 20, -- Exp за наличия перка
        desc = [[Эффект: снижает вероятность перелома до 40%
При наличии перка снижается получаемый опыт за перелом до 20exp.]], -- описание
    },

    [2] = {
        name = "Крепкие кости II",
        material = Material("perks/strong_bones.png"),
        effect = 35,
        level = 44,
        exp = 15,
        desc = [[Эффект: снижает вероятность перелома до 35%
При наличии перка снижается получаемый опыт за перелом до 15exp.]],
    },

    [3] = {
        name = "Крепкие кости III",
        material = Material("perks/strong_bones.png"),
        effect = 30,
        level = 72,
        exp = 10,
        desc = [[Эффект: снижает вероятность перелома до 30%
При наличии перка снижается получаемый опыт за перелом до 10exp.]],
    },
    -- Густая кровь --
    [4] = {
        name = "Густая кровь I",
        material = Material("perks/thick_blood.png"),
        effect = 39,
        level = 18,
        exp = 1,
        desc = [[Эффект: снижает вероятность кровотечения до 75%
При налиции перка снижается получаемый опыт за кровотечение до 1exp]],
    },

    [5] = {
        name = "Густая кровь II",
        material = Material("perks/thick_blood.png"),
        effect = 65,
        level = 49,
        exp = 1,
        desc = [[Эффект: снижает вероятность кровотечения до 65%
При налиции перка снижается получаемый опыт за кровотечение до 1exp]],
    },

    [6] = {
        name = "Густая кровь III",
        material = Material("perks/thick_blood.png"),
        effect = 60,
        level = 69,
        exp = 1,
        desc = [[Эффект: снижает вероятность кровотечения до 60%
При налиции перка снижается получаемый опыт за кровотечение до 1exp]],
    },
    -- Родился в рубашке --
    [7] = {
        name = "Родился в рубашке",
        material = Material("perks/born_stars.png"),
        effect = 50,
        level = 75,
        exp = 50,
        desc = [[Эффект: восполняется в бою 50% здоровья с вероятностью 1%]],
    },
    -- Золотой ребёнок --
    [8] = {
        name = "Золотой ребёнок I",
        material = Material("perks/golden_child.png"),
        effect = 6,
        level = 55,
        exp = 50,
        desc = [[Эффект: увеличивает полученый exp на 6%]],
    },

    [9] = {
        name = "Золотой ребёнок II",
        material = Material("perks/golden_child.png"),
        effect = 18,
        level = 79,
        exp = 50,
        desc = [[Эффект: увеличивает полученый exp на 18%]],
    },

    [10] = {
        name = "Золотой ребёнок III",
        material = Material("perks/golden_child.png"),
        effect = 39,
        level = 89,
        exp = 50,
        desc = [[Эффект: увеличивает полученый exp на 39%]],
    },
    -- Стальные ноги --
    [11] = {
        name = "Стальные ноги I",
        material = Material("perks/steel_legs.png"),
        effect = 5,
        level = 12,
        exp = 15,
        desc = [[Эффект: увеличивает скорость бега на 5%
При налиции перка вы получаете 15 exp каждую минуту, если уровень стамины ниже 1/3]],
    },

    [12] = {
        name = "Стальные ноги II",
        material = Material("perks/steel_legs.png"),
        effect = 10,
        level = 25,
        exp = 10,
        desc = [[Эффект: увеличивает скорость бега на 10%
При налиции перка вы получаете 10 exp каждую минуту, если уровень стамины ниже 1/3]],
    },

    [13] = {
        name = "Стальные ноги III",
        material = Material("perks/steel_legs.png"),
        effect = 15,
        level = 62,
        exp = 5,
        desc = [[Эффект: увеличивает скорость бега на 15%
При налиции перка вы получаете 5 exp каждую минуту, если уровень стамины ниже 1/3]],
    },
    -- Твердая кожа --
    [14] = {
        name = "Твердая кожа I",
        material = Material("perks/hard_skin.png"),
        effect = 5,
        level = 35,
        exp = 10,
        desc = [[Эффект: снижает урон по конечностям на 5%]],
    },

    [15] = {
        name = "Твердая кожа II",
        material = Material("perks/hard_skin.png"),
        effect = 8,
        level = 65,
        exp = 10,
        desc = [[Эффект: снижает урон по конечностям на 8%]],
    },

    [16] = {
        name = "Твердая кожа III",
        material = Material("perks/hard_skin.png"),
        effect = 10,
        level = 82,
        exp = 10,
        desc = [[Эффект: снижает урон по конечностям на 10%]],
    },
    -- Второй шанс --
    [17] = {
        name = "Второй шанс I",
        material = Material("perks/second_chance.png"),
        effect = math.Round(mp.config.reswn_time * .8),
        level = 58,
        exp = 1,
        desc = [[Эффект: снижает время возрождения до ]] .. math.Round(mp.config.reswn_time * .8) .. [[ сек]],
    },

    [18] = {
        name = "Второй шанс II",
        material = Material("perks/second_chance.png"),
        effect = math.Round(mp.config.reswn_time * .6),
        level = 86,
        exp = 2,
        desc = [[Эффект: снижает время возрождения до ]] .. math.Round(mp.config.reswn_time * .6) .. [[ сек]],
    },

    [19] = {
        name = "Второй шанс III",
        material = Material("perks/second_chance.png"),
        effect = math.Round(mp.config.reswn_time * .5),
        level = 100,
        exp = 3,
        desc = [[Эффект: снижает время возрождения до ]] .. math.Round(mp.config.reswn_time * .5) .. [[ сек]],
    },
    -- Второе дыхание --
    [20] = {
        name = "Второе дыхание I",
        material = Material("perks/second_wind.png"),
        effect = 15,
        level = 8,
        exp = 0,
        desc = [[Эффект: увеличивается скорость восстановления выносливости на 15%]],
    },

    [21] = {
        name = "Второе дыхание II",
        material = Material("perks/second_wind.png"),
        effect = 20,
        level = 28,
        exp = 0,
        desc = [[Эффект: увеличивается скорость восстановления выносливости на 20%]],
    },

    [22] = {
        name = "Второе дыхание III",
        material = Material("perks/second_wind.png"),
        effect = 25,
        level = 52,
        exp = 0,
        desc = [[Эффект: увеличивается скорость восстановления выносливости на 25%]],
    },
    -- Бесконтактный мозг --
    [23] = {
        name = "Бесконтактный мозг I",
        material = Material("perks/contactless_brain.png"),
        effect = 6,
        level = 15,
        exp = 20,
        desc = [[Эффект: снижает вероятность получить контузию до 6%
При налиции перка вы получаете 20 exp за каждую контузию]],
    },

    [24] = {
        name = "Бесконтактный мозг II",
        material = Material("perks/contactless_brain.png"),
        effect = 5,
        level = 41,
        exp = 15,
        desc = [[Эффект: снижает вероятность получить контузию до 5%
При налиции перка вы получаете 15 exp за каждую контузию]],
    },

    [25] = {
        name = "Бесконтактный мозг III",
        material = Material("perks/contactless_brain.png"),
        effect = 4,
        level = 93,
        exp = 10,
        desc = [[Эффект: снижает вероятность получить контузию до 4%
При налиции перка вы получаете 10 exp за каждую контузию]],
    },
    -- Гемокоагуляция --
    [26] = {
        name = "Гемокоагуляция I",
        material = Material("perks/hemocoagulation.png"),
        effect = 10,
        level = 31,
        exp = 0,
        desc = [[Эффект: снижает время кровотечения на 10%]],
    },

    [27] = {
        name = "Гемокоагуляция II",
        material = Material("perks/hemocoagulation.png"),
        effect = 15,
        level = 60,
        exp = 0,
        desc = [[Эффект: снижает время кровотечения на 15%]],
    },

    [28] = {
        name = "Гемокоагуляция III",
        material = Material("perks/hemocoagulation.png"),
        effect = 20,
        level = 96,
        exp = 0,
        desc = [[Эффект: снижает время кровотечения на 20%]],
    },
}
