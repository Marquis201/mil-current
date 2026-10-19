local Vector = Vector
local net = net
local hook = hook
local mp = mp
local nw = nw
local PLAYER = PLAYER
local IsValid = IsValid
local CurTime = CurTime
local timer = timer

mp.QuestPlay = mp.QuestPlay or {}
mp.QuestPlay.List = {}
mp.QuestPlay.Contract = mp.QuestPlay.Contract or {}
mp.QuestPlay.CashContract = mp.QuestPlay.CashContract or {}
mp.QuestPlay.DealyContract = mp.QuestPlay.DealyContract or {}
mp.QuestPlay.ActiveSolo = mp.QuestPlay.ActiveSolo or {}

mp.QuestPlay.DealyContractTime = 3600

mp.QuestPlay.ScoreQualification = {
    [3] = {
        name = "«Диверсант-самоучка» / Непригоден",
        desc = [[Вы представляете угрозу для сослуживцев. Рекомендовано отправить на перевоспитание]]
    },
    [4] = {
        name = "«Молодой боец» / Условно годен",
        desc =
        [[Рвение есть, ума мало. Будете чистить картошку и бегать в первые атаки, пока не научитесь мыслить тактически. Допуск к секретным документам ограничен]]
    },
    [6] = {
        name = "«Опытный сержант» / Годен.",
        desc =
        [[Вы адекватны, знаете устав и не подведете в бою. Именно из таких получается костяк сервера. Добро пожаловать в элиту]]
    },
    [10] = {
        name = "«Элитный спецназ» / Эталон",
        desc = [[Таким можно доверить командование взводом и слепую зону за спиной]]
    }
}

mp.QuestPlay.TestQualification = {
    {
        name =
        "Вы заступили в наряд на кухню (чистить картошку). Неожиданно вы видите, как сослуживец (игрок) ворует тушенку со склада. Ваши действия?",
        answer = {
            {
                name = "Потребую долю, иначе доложу командиру",
                score = 0.5,
            },
            {
                name = "Промолчу и буду чистить дальше, меня это не касается",
                score = 0,
            },
            {
                name = "Дам в табло (ударю лопатой по голове) и отниму тушенку",
                score = 0,
            },
            {
                name = "Доложу по инстанции командиру взвода, так как воровство подрывает боеспособность",
                score = 1,
            },
        }
    },

    {
        name =
        "Вас отправили в разведку в тыл врага. Ваш напарник провалился в окоп и сломал ногу. До линии фронта 500 метров, а у вас приказ — наблюдение. Что выберете?",
        answer = {
            {
                name = "Оставлю напарника, приказ важнее. Сам погибай, а товарища выручай? Нет, не слышал",
                score = 0,
            },
            {
                name = "Начну кричать <Помогите!> на весь лес, чтобы его спасли",
                score = 0,
            },
            {
                name =
                "Окажу первую помощь, спрячу в воронке, а после выполнения задания вернусь за ним (отмечу на карте для медиков)",
                score = 1,
            },
            {
                name = "Пристрелю, чтобы не мучился и не выдал нас криками",
                score = 0,
            },
        }
    },

    {
        name =
        "Вы нашли связанного врага. Он предлагает вам взятку игровой валютой, если вы его отпустите. Что сделаете?",
        answer = {
            {
                name = "Возьму деньги и убью, чтобы не сдал",
                score = 0,
            },
            {
                name = "Отпущу за деньги, мне они нужнее",
                score = 0,
            },
            {
                name = "Доставлю в штаб для допроса, как положено по уставу",
                score = 1,
            },
            {
                name = "Устрою самосуд прямо на месте",
                score = 0,
            },
        }
    },

    {
        name = "Что для вас означает понятие Ролевая игра?",
        answer = {
            {
                name = "Это когда можно бегать и стрелять во всё, что движется",
                score = 0,
            },
            {
                name = "Это когда я строю из себя крутого спецназовца и не подчиняюсь никому",
                score = 0.5,
            },
            {
                name =
                "Это когда я отыгрываю роль солдата, соблюдаю субординацию и реагирую на события согласно обстоятельствам",
                score = 0,
            },
            {
                name = "Это скучно, я пришел просто пострелять",
                score = 0,
            },
        }
    },

    {
        name =
        "Ваш командир отделения отдал приказ, который кажется вам глупым и ведущим к гибели отряда. Ваши действия?",
        answer = {
            {
                name = "Открыто пошлю командира и сделаю по-своему",
                score = 0,
            },
            {
                name = "Потребую объяснений перед строем, унизив его авторитет",
                score = 0.5,
            },
            {
                name =
                "Выполню приказ, но в частном порядке после задания напишу рапорт вышестоящему командованию с анализом ошибок",
                score = 0,
            },
            {
                name = "Забью на приказ и уйду в рейд на другую часть карты",
                score = 0,
            },
        }
    },

    {
        name = "Вы заметили, что игрок из вашей команды использует чита. Ваша реакция?",
        answer = {
            {
                name = "Круто! Дай ссылочку",
                score = 0,
            },
            {
                name = "Промолчу, мне все равно",
                score = 0,
            },
            {
                name = "Начну орать в голосовой чат, что он мудак, и попытаюсь закидать его гранатами",
                score = 0.5,
            },
            {
                name = "Сделаю скриншот/видео и отправлю в дискорд сервера администрации",
                score = 1,
            },
        }
    },

    {
        name = "Противник взял вашу базу и вешает флаг. Вы погибли и возродились на респавне. Что будете делать?",
        answer = {
            {
                name = "Побегу в одиночку с голыми руками отбивать базу, крича 'Ура!'",
                score = 0,
            },
            {
                name =
                "Подожду 5 минут, пока соберется группа хотя бы из 3-х человек, скоординирую атаку в чате, и только потом пойду",
                score = 1,
            },
            {
                name =
                "Переоденусь в гражданскую одежду (если есть) и попытаюсь втереться к ним в доверие, чтобы зарезать со спины",
                score = 0.5,
            },
            {
                name = "Пойду на другую базу, мне все равно",
                score = 0,
            },
        }
    },

    {
        name = "Как вы относитесь к RDM (массовое убийство без причины)?",
        answer = {
            {
                name = "Это правило для слабаков. Кого хочу, того и убиваю",
                score = 0,
            },
            {
                name = "Если меня кто-то толкнул — это уже считается нападением, я имею право убить",
                score = 0.5,
            },
            {
                name = "Правило важное. Если не уверен, что игрок — враг (нет оружия/форма неясна), стрелять нельзя",
                score = 1,
            },
            {
                name = "RDM? Я вообще правила не читал, а что там написано?",
                score = 0,
            },
        }
    },

    {
        name =
        "К вам подбегает вражеский игрок, садится в ваш танк и пытается уехать. Вы находитесь снаружи. Ваши действия?",
        answer = {
            {
                name = "Кину гранату в танк, чтобы уничтожить и технику, и врага",
                score = 0.5,
            },
            {
                name = "Начну стучать прикладом по броне и кричать",
                score = 0,
            },
            {
                name = "Быстро запрыгну на броню и попытаюсь заглянуть в люк, чтобы застрелить угонщика",
                score = 1,
            },
            {
                name = "Буду бежать за танком и стрелять в воздух, надеясь, что он остановится",
                score = 0,
            },
        }
    },

    {
        name = "Закончилось топливо, закончились патроны, сервер скоро перезагрузится. Ваши действия?",
        answer = {
            {
                name = "Пойду в разнос, убью всех, кто попадется под руку (даже своих), ведь всё равно вайп",
                score = 0,
            },
            {
                name =
                "Сяду у костра на базе и буду травить армейские байки в голосовой чат с сослуживцами до отключения",
                score = 1,
            },
            {
                name = "Покину сервер сразу, чтобы не терять время",
                score = 0.5,
            },
            {
                name = "Буду бегать по карте и мешать игре других, пока меня не выкинет",
                score = 0,
            },
        }
    },
}

local function addQuest(id, t)
    mp.QuestPlay.List[id] = t
    mp.QuestPlay.List[id].id = id

    if SERVER then
        if t.hooks then
            for k, v in pairs(t.hooks) do
                hook.Add(k, "QuestPlay." .. id .. "." .. k, v)
            end
        end
    end

    return id
end

-- START PLAY

do
    do
        local QUEST = {
            id = "start_qualification",
            name = "Поговорите с инструктором, чтобы пройти тестирование",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "КМБ",
        }

        QUEST.check = function(pl)
            return mp.config.start_jobs[pl:Team()] and not mp.QuestPlay:HasQuest(pl, QUEST.id)
        end

        QUEST.hooks = {
            ["OnQualificationComplete"] = function(pl)
                if mp.QuestPlay:HasQuest(pl, QUEST.id) then return end

                QUEST.complete(pl)
            end
        }

        QUEST.complete = function(pl)
            mp.QuestPlay:CompleteQuest(pl, QUEST.id)
        end

        addQuest(QUEST.id, QUEST)
    end

    do
        local QUEST = {
            id = "stat_obstacle",
            name = "Пройдите полосу препятствий",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "КМБ",
        }

        QUEST.check = function(pl)
            return mp.config.start_jobs[pl:Team()] and not mp.QuestPlay:HasQuest(pl, QUEST.id) and
                mp.QuestPlay:HasQuest(pl, "start_qualification")
        end

        QUEST.hooks = {
            ["OnPlayerObstacle"] = function(pl)
                if mp.QuestPlay:HasQuest(pl, QUEST.id) then return end

                QUEST.complete(pl)
            end
        }

        QUEST.complete = function(pl)
            mp.QuestPlay:CompleteQuest(pl, QUEST.id)
        end

        addQuest(QUEST.id, QUEST)
    end

    do
        local QUEST = {
            id = "stat_tir",
            name = "Сдайте норматив на стрельбище",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "КМБ",
        }

        QUEST.check = function(pl)
            return mp.config.start_jobs[pl:Team()] and not mp.QuestPlay:HasQuest(pl, QUEST.id) and
                mp.QuestPlay:HasQuest(pl, "stat_obstacle")
        end

        QUEST.hooks = {
            ["OnPlayerTir"] = function(pl)
                if mp.QuestPlay:HasQuest(pl, QUEST.id) then return end

                QUEST.complete(pl)
            end
        }

        QUEST.complete = function(pl)
            mp.QuestPlay:CompleteQuest(pl, QUEST.id)
        end

        addQuest(QUEST.id, QUEST)
    end

    do
        local QUEST = {
            id = "stat_clothes",
            name = "Получите комплект формы на складе",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "КМБ",
        }

        QUEST.check = function(pl)
            return mp.config.start_jobs[pl:Team()] and not mp.QuestPlay:HasQuest(pl, QUEST.id) and
                mp.QuestPlay:HasQuest(pl, "stat_tir")
        end

        QUEST.hooks = {
            ["OnPlayerClothes"] = function(pl)
                if mp.QuestPlay:HasQuest(pl, QUEST.id) then return end

                QUEST.complete(pl)
            end
        }

        QUEST.complete = function(pl)
            mp.QuestPlay:CompleteQuest(pl, QUEST.id)
        end

        addQuest(QUEST.id, QUEST)
    end

    do
        local QUEST = {
            id = "stat_weapon",
            name = "Получите боевой комплект в КХО",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "КМБ",
        }

        QUEST.check = function(pl)
            return not mp.QuestPlay:HasQuest(pl, QUEST.id) and mp.QuestPlay:HasQuest(pl, "stat_clothes")
        end

        QUEST.hooks = {
            ["OnPlayerWeapon"] = function(pl)
                if mp.QuestPlay:HasQuest(pl, QUEST.id) then return end

                QUEST.complete(pl)
            end
        }

        QUEST.complete = function(pl)
            mp.QuestPlay:CompleteQuest(pl, QUEST.id)
        end

        addQuest(QUEST.id, QUEST)
    end
end

-- КОНТРАКТЫ

do
    do
        local QUEST = {
            id = "contract_kill",
            name = "Убейте 3х игроков противоположной команды",
            help = "Убийства засчитываются из личного боевого оружия и разных игроков",
            category = "Контракт",
            retry = true,
            price = 300,
            reward = 3,
            time = 3200,
            count = 3,
        }

        QUEST.hooks = {
            ["PlayerDeath"] = function(pl, inflictor, attacker)
                if not IsValid(attacker) or not attacker:IsPlayer() or not inflictor.SpawnWeapons then return end

                local t = attacker:GetNetVar("QuestPlay.ListContract") or {}
                local data = t[QUEST.id]

                if not data or data.time < CurTime() then return end

                mp.QuestPlay.CashContract[attacker:SteamID()] = mp.QuestPlay.CashContract[attacker:SteamID()] or {}
                mp.QuestPlay.CashContract[attacker:SteamID()][QUEST.id] = mp.QuestPlay.CashContract[attacker:SteamID()]
                    [QUEST.id] or {}

                local tPlayer = mp.QuestPlay.CashContract[attacker:SteamID()][QUEST.id]

                if tPlayer[pl:SteamID()] then
                    return
                end

                tPlayer[pl:SteamID()] = true

                data.count = data.count + 1

                if data.count >= QUEST.count then
                    mp.QuestPlay:ContractComplete(attacker, QUEST.id)
                    mp.QuestPlay.CashContract[attacker:SteamID()][QUEST.id] = {}
                else
                    attacker:SetNetVar("QuestPlay.ListContract", t)
                end
            end
        }


        addQuest(QUEST.id, QUEST)
    end

    do
        local QUEST = {
            id = "contract_flag",
            name = "Захватите 1 флаг",
            help = "Можно захватывать вражеский или нейтральный флаг. Находиться нужно рядом в момент захвата",
            category = "Контракт",
            retry = true,
            price = 200,
            reward = 2.5,
            time = 2700,
        }

        QUEST.hooks = {
            ["Conquest_FlagCaptured"] = function(owner, name)
                local flag

                for k, v in pairs(Conquest.cache) do
                    if v.owner == owner and v.name == name then
                        flag = v

                        break
                    end
                end

                if not flag or not IsValid(flag.flagent) then return end

                local players = ents.FindInSphere(flag.flagent:GetPos(), flag.radius)

                for k, pl in ipairs(players) do
                    if IsValid(pl) and pl:IsPlayer() and pl:Alive() and Conquest.TeamManager.QuickCache[pl:Team()] and Conquest.TeamManager.QuickCache[pl:Team()] == owner then
                        local t = pl:GetNetVar("QuestPlay.ListContract") or {}
                        local data = t[QUEST.id]

                        if not data or data.time < CurTime() then continue end

                        mp.QuestPlay:ContractComplete(pl, QUEST.id)
                    end
                end
            end
        }

        addQuest(QUEST.id, QUEST)
    end

    do
        local QUEST = {
            id = "contract_tir",
            name = "Побейте личный рекорд в тире",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "Контракт",
            retry = true,
            price = 100,
            reward = 2,
            time = 900,
        }

        QUEST.hooks = {
            ["OnPlayerTirRecord"] = function(pl)
                if not IsValid(pl) or not pl:IsPlayer() then return end

                local t = pl:GetNetVar("QuestPlay.ListContract") or {}
                local data = t[QUEST.id]

                if not data or data.time < CurTime() then return end

                mp.QuestPlay:ContractComplete(pl, QUEST.id)
            end
        }

        addQuest(QUEST.id, QUEST)
    end

    do
        local function createTopSecret(pl, pos, time)
            local all = ents.FindByClass("base_gmodentity")

            for k, v in ipairs(all) do
                if IsValid(v) and v.top_secret then
                    v:Remove()
                end
            end

            local ent = ents.Create("base_gmodentity")
            ent:SetModel("models/props_junk/cardboard_box004a.mdl")
            ent:SetPos(pos)
            ent:SetAngles(Angle(0, math.random(0, 180), 0))
            ent.top_secret = true
            ent.contract_player = pl
            ent:Spawn()

            ent:SetSolid(SOLID_OBB)
            ent:PhysicsInit(SOLID_OBB)
            ent:SetMoveType(MOVETYPE_FLYGRAVITY)
            ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            ent:DropToFloor()

            local physobj = ent:GetPhysicsObject()
            if IsValid(physobj) then
                physobj:Wake()
                physobj:EnableMotion(false)
            end

            timer.Create("RemoveTopSecret." .. ent:EntIndex(), time, 1, function()
                if IsValid(ent) then
                    ent:Remove()
                end
            end)
        end

        local QUEST = {
            id = "contract_document",
            name = "Получите секретные сведения противника",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "Контракт",
            retry = true,
            solo = true,
            price = 500,
            reward = 3,
            time = 1800,

            pos = {
                rf = { Vector(11311, -7204, -500), Vector(10693, -187, -500), Vector(11375, -4584, -500) },
                nato = { Vector(-13825, -11530, -485), Vector(-10600, -8122, -500), Vector(-11671, -13191, -485) }
            },

            endpos = {
                rf = Vector(-12859, -10542, -500),
                nato = Vector(12750, -1963, -500)
            }
        }

        QUEST.hooks = {
            ["PlayerDeath"] = function(pl, inflictor, attacker)
                if pl.HasTopSecret and timer.Exists("Contract." .. pl:SteamID64() .. "." .. QUEST.id) then
                    local pos = pl:GetPos()

                    createTopSecret(pl, pos, timer.TimeLeft("Contract." .. pl:SteamID64() .. "." .. QUEST.id))

                    net.Start("mp.Territory.AddGPS")
                    net.WriteString(QUEST.id)
                    net.WriteString("Секретные документы")
                    net.WriteString(pl:GetFaction())
                    net.WriteVector(pos)
                    net.Send(pl)
                end
            end,

            ["KeyPress"] = function(pl, key)
                pl.NextCheckTopSecret = pl.NextCheckTopSecret or 0

                if key and pl.HasTopSecret and timer.Exists("Contract." .. pl:SteamID64() .. "." .. QUEST.id) and pl.NextCheckTopSecret < CurTime() and pl.EndPosTopSecret then
                    if pl:GetPos():Distance(pl.EndPosTopSecret) < 300 then
                        local t = pl:GetNetVar("QuestPlay.ListContract") or {}
                        local data = t[QUEST.id]

                        if not data or data.time < CurTime() then return end

                        mp.QuestPlay:ContractComplete(pl, QUEST.id)
                    end

                    pl.NextCheckTopSecret = CurTime() + 2
                end

                if key == IN_USE then
                    local ent = pl:GetEyeTrace().Entity
                    if not IsValid(ent) or not ent.top_secret or not ent.contract_player or not IsValid(ent.contract_player) or ent.contract_player:SteamID() ~= pl:SteamID() then return end
                    if pl:GetPos():Distance(ent:GetPos()) > 100 then return end
                    if not pl:Alive() then return end

                    ent:Remove()

                    pl.HasTopSecret = true

                    mp.util.Notify(pl, NOTIFY_HINT, "Документы получены, отнесите их в обозначенную точку!")

                    local pos = QUEST.endpos[pl:GetFaction()]

                    pl.EndPosTopSecret = pos

                    net.Start("mp.Territory.AddGPS")
                    net.WriteString(QUEST.id)
                    net.WriteString("Секретные документы")
                    net.WriteString(pl:GetFaction())
                    net.WriteVector(pos)
                    net.Send(pl)
                end
            end,
        }

        QUEST.start = function(pl)
            local pos = QUEST.pos[pl:GetFaction()][math.random(1, #QUEST.pos[pl:GetFaction()])]

            createTopSecret(pl, pos, QUEST.time)

            net.Start("mp.Territory.AddGPS")
            net.WriteString(QUEST.id)
            net.WriteString("Секретные документы")
            net.WriteString(pl:GetFaction())
            net.WriteVector(pos)
            net.Send(pl)

            pl.HasTopSecret = nil
        end

        addQuest(QUEST.id, QUEST)
    end

    do
        local QUEST = {
            id = "contract_run",
            name = "Доберитесь до указанной точки",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "Контракт",
            retry = true,
            price = 100,
            reward = 2.5,
            time = 300,
            pos = {
                rf = { Vector(2627, 11519, -512), Vector(9375, 7428, -472), Vector(2972, -4002, -80), Vector(2108, 725, 812) },
                nato = { Vector(-5352, 6191, 1035), Vector(-12638, 717, -116), Vector(-7895, -1219, -96), Vector(-9130, -5006, 44) }
            },
        }

        QUEST.hooks = {
            ["KeyPress"] = function(pl, key)
                pl.NextCheckRunContract = pl.NextCheckRunContract or 0

                if key and pl.ContractPos and timer.Exists("Contract." .. pl:SteamID64() .. "." .. QUEST.id) and pl.NextCheckRunContract < CurTime() then
                    if pl:GetPos():Distance(pl.ContractPos) < 300 then
                        local t = pl:GetNetVar("QuestPlay.ListContract") or {}
                        local data = t[QUEST.id]

                        if not data or data.time < CurTime() then return end

                        mp.QuestPlay:ContractComplete(pl, QUEST.id)
                    end

                    pl.NextCheckRunContract = CurTime() + 2
                end
            end,
        }

        QUEST.start = function(pl)
            local pos = QUEST.pos[pl:GetFaction()][math.random(1, #QUEST.pos[pl:GetFaction()])]

            net.Start("mp.Territory.AddGPS")
            net.WriteString(QUEST.id)
            net.WriteString(QUEST.name)
            net.WriteString(pl:GetFaction())
            net.WriteVector(pos)
            net.Send(pl)

            pl.ContractPos = pos
        end

        addQuest(QUEST.id, QUEST)
    end

    do
        local function createBomb(pl, pos, time)
            local all = ents.FindByClass("contract_bomb")

            for k, v in ipairs(all) do
                if IsValid(v) and v.contract_bomb then
                    v:Remove()
                end
            end

            local code = math.random(111111, 999999)

            local ent = ents.Create("contract_bomb")
            ent:SetPos(pos)
            ent:SetAngles(Angle(0, math.random(0, 180), 0))
            ent.contract_bomb = true
            ent.contract_player = pl
            ent.contract_code = code
            ent:Spawn()

            mp.util.Notify(pl, NOTIFY_GENERIC, "Запомните этот код: " .. code, 10)

            timer.Create("RemoveTopSecret." .. ent:EntIndex(), time, 1, function()
                if IsValid(ent) then
                    ent:Remove()

                    local bomd = ents.Create("sw_bomb_fab500m46_v3")
                    bomd:SetPos(pos)
                    bomd:SetAngles(Angle(0, math.random(0, 180), 0))
                    bomd:Spawn()
                    bomd:Activate()
                    bomd.Exploded = true
                    bomd.Armed = true
                    bomd:Explode(pos)
                end
            end)
        end

        local QUEST = {
            id = "contract_bomb",
            name = "Обезвредьте бомбу на указанной точке",
            help = "Местоположение можно узнать в 'С-меню'",
            category = "Контракт",
            retry = true,
            solo = true,
            price = 350,
            reward = 2,
            time = 900,
            pos = {
                rf = { Vector(-2988, -6583, -506), Vector(-11224, -1495, -349), Vector(11783, 6471, -495) },
                nato = { Vector(-1748, 3229, -501), Vector(-9427, -2163, -345), Vector(77, 10024, -490) }
            },
        }

        QUEST.hooks = {
            ["OnDefuseBomb"] = function(pl, key)
                if not IsValid(pl) or not pl:IsPlayer() then return end

                if timer.Exists("Contract." .. pl:SteamID64() .. "." .. QUEST.id) then
                    local t = pl:GetNetVar("QuestPlay.ListContract") or {}
                    local data = t[QUEST.id]

                    if not data or data.time < CurTime() then return end

                    mp.QuestPlay:ContractComplete(pl, QUEST.id)
                end
            end,
        }

        QUEST.start = function(pl)
            local pos = QUEST.pos[pl:GetFaction()][math.random(1, #QUEST.pos[pl:GetFaction()])]

            createBomb(pl, pos, QUEST.time)

            net.Start("mp.Territory.AddGPS")
            net.WriteString(QUEST.id)
            net.WriteString("Обезвредить бомбу")
            net.WriteString(pl:GetFaction())
            net.WriteVector(pos)
            net.Send(pl)

            pl.HasTopSecret = nil
        end

        addQuest(QUEST.id, QUEST)
    end


    --[[do
        local QUEST = {
            id = "contract_npc",
            name = "Уничтожьте вражескую группу в указаной точке",
            help =
            "Задание провалено: если вы умрете или цели будут убиты другим игроком. Местоположение можно узнать в 'С-меню'",
            category = "Контракт",
            retry = true,
            solo = true,
            price = 1750,
            reward = 2,
            time = 1800,
        }

        QUEST.hooks = {

        }

        addQuest(QUEST.id, QUEST)
    end]]
end

function mp.QuestPlay:HasQuest(pl, id)
    local t = pl:GetNetVar("QuestPlay.List") or {}
    return t[id]
end

function mp.QuestPlay:HasContract(pl, id)
    local t = pl:GetNetVar("QuestPlay.ListContract") or {}
    return t[id]
end

nw.Register("QuestPlay.Qualification"):Write(net.WriteFloat):Read(net.ReadFloat):SetPlayer()
nw.Register("QuestPlay.List")
    :Write(function(t)
        net.WriteUInt(table.Count(t), 8)
        for k, v in pairs(t) do
            net.WriteString(k)
        end
    end)
    :Read(function()
        local t = {}

        for i = 1, net.ReadUInt(8) do
            t[net.ReadString()] = true
        end

        return t
    end)
    :SetLocalPlayer()

nw.Register("QuestPlay.ListContract")
    :Write(function(t)
        net.WriteUInt(table.Count(t), 8)
        for k, v in pairs(t) do
            net.WriteString(k)
            net.WriteFloat(v.time)
            net.WriteUInt(v.count, 16)
        end
    end)
    :Read(function()
        local t = {}

        for i = 1, net.ReadUInt(8) do
            t[net.ReadString()] = {
                time = net.ReadFloat(),
                count = net.ReadUInt(16)
            }
        end

        return t
    end)
    :SetLocalPlayer()
