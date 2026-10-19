local mp = mp
local util = util
local net = net
local hook = hook
local timer = timer
local player = player
local IsValid = IsValid

local nw = { "job", "rank", "profession", "model", "access", "update_menu", "player_panel", "character_menu",
    "change_character" }
for k, v in ipairs(nw) do
    util.AddNetworkString("mp.whitelist." .. v)
end

mp.whitelist = mp.whitelist or {}

local function sendUpdate(pl)
    timer.Create("mp.whitelist.UpdateMenu." .. pl:SteamID(), 1, 1, function()
        if IsValid(pl) then
            net.Start("mp.whitelist.update_menu")
            net.Send(pl)
        end
    end)
end

local list_command = {
    ["job"] = function(_, pl)
        local db = mysql.connect_config

        local target = net.ReadEntity()
        local team_index = net.ReadUInt(8)
        local time = net.ReadUInt(32)

        local job = mp.jobs[team_index]
        if not job then return end
        if team_index == target:Team() then return end

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end
        if not pl:CanGiveTeam(team_index) then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")
            return
        end

        local steamid = target:SteamID()
        local oldTeam = target:Team()
        local oldModel = target:GetModel()
        local player_id = target:GetNetVar("meta_playerid")
        local character_id = target:GetNetVar("meta_character")

        timer.Remove("mp.whitelist.job." .. steamid)

        if time > 0 then
            timer.Create("mp.whitelist.job." .. steamid, time * 60, 1, function()
                local p = player.GetBySteamID(steamid)

                if IsValid(p) then
                    mp.util.Notify(p, NOTIFY_GENERIC, "Время пребывания на текущей работе истекло!")
                    hook.Call("PlayerChangeTeam", nil, p, oldTeam, true)
                else
                    db:Query(
                        "UPDATE metahub_characters SET team_id = ?, model = ? WHERE player_id = ? AND character_id = ?;",
                        job.jobid,
                        oldModel,
                        player_id,
                        character_id)
                end
            end)
        end

        mp.util.Notify(pl, NOTIFY_GENERIC,
            target:Name() .. " была изменена работа на " .. job.Name .. (time > 0 and " (" .. time .. " мин.)" or ""))
        hook.Call("PlayerChangeTeam", nil, target, team_index, true)
        target:Spawn()

        sendUpdate(pl)

        hook.Call("PlayerWhiteListJob", nil, pl, target, job.Name, time)
    end,

    ["rank"] = function(_, pl)
        local db = mysql.connect_config

        local target = net.ReadEntity()
        local rank_index = net.ReadUInt(8)
        local time = net.ReadUInt(32)

        local faction = mp.faction[target:GetFaction()]
        if not faction or not faction.ranks[rank_index] then return end
        if faction.ranks[rank_index].name == target:GetNetVar("meta_rank") then return end

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        local steamid = target:SteamID()
        local oldRank = target:GetNetVar("meta_rank")
        local player_id = target:GetNetVar("meta_playerid")
        local character_id = target:GetNetVar("meta_character")

        timer.Remove("mp.whitelist.rank." .. steamid)

        if time > 0 then
            timer.Create("mp.whitelist.rank." .. steamid, time * 60, 1, function()
                local p = player.GetBySteamID(steamid)

                if IsValid(p) then
                    mp.util.Notify(p, NOTIFY_GENERIC, "Время пребывания на текущем звании истекло!")
                    p:SetNetVar("meta_rank", oldRank)
                end

                db:Query(
                    "UPDATE metahub_characters SET c_rank = ? WHERE player_id = ? AND character_id = ?;",
                    oldRank,
                    player_id,
                    character_id)
            end)
        end

        local rank = faction.ranks[rank_index].name

        target:SetNetVar("meta_rank", rank)
        mp.util.Notify(pl, NOTIFY_GENERIC,
            target:Name() .. " было изменено звание на " .. rank .. (time > 0 and " (" .. time .. " мин.)" or ""))
        db:Query(
            "UPDATE metahub_characters SET c_rank = ? WHERE player_id = ? AND character_id = ?;",
            rank,
            player_id,
            character_id)

        sendUpdate(pl)

        hook.Call("PlayerWhiteListRank", nil, pl, target, faction.ranks[rank_index].name, time)
    end,

    ["profession"] = function(_, pl)
        local db = mysql.connect_config

        local target = net.ReadEntity()
        local profession_index = net.ReadString()
        local time = net.ReadUInt(32)

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end
        if profession_index ~= "Снять специальность" then
            local faction = mp.faction[target:GetFaction()]
            if not faction or not faction.profession[profession_index] then return end
            if faction.profession[profession_index].name == target:GetNetVar("meta_features") then return end

            local steamid = target:SteamID()
            local oldProfession = target:GetNetVar("meta_features")
            local player_id = target:GetNetVar("meta_playerid")
            local character_id = target:GetNetVar("meta_character")

            timer.Remove("mp.whitelist.profession." .. steamid)

            if time > 0 then
                timer.Create("mp.whitelist.profession." .. steamid, time * 60, 1, function()
                    local p = player.GetBySteamID(steamid)

                    if IsValid(p) then
                        mp.util.Notify(p, NOTIFY_GENERIC, "Время пребывания на текущей специальности истекло!")
                        p:SetNetVar("meta_features", oldProfession)
                    end

                    db:Query(
                        "UPDATE metahub_characters SET features = ? WHERE player_id = ? AND character_id = ?;",
                        oldProfession,
                        player_id,
                        character_id)
                end)
            end

            local profession = faction.profession[profession_index].name

            target:SetNetVar("meta_features", profession_index)
            mp.util.Notify(pl, NOTIFY_GENERIC,
                target:Name() ..
                " была изменена специальность на " .. profession .. (time > 0 and " (" .. time .. " мин.)" or ""))
            db:Query(
                "UPDATE metahub_characters SET features = ? WHERE player_id = ? AND character_id = ?;",
                profession_index,
                player_id,
                character_id)

            sendUpdate(pl)

            pl:Spawn()

            hook.Call("PlayerWhiteListProfession", nil, pl, target, profession, time)
        else
            local steamid = target:SteamID()
            local oldProfession = target:GetNetVar("meta_features")
            local player_id = target:GetNetVar("meta_playerid")
            local character_id = target:GetNetVar("meta_character")

            timer.Remove("mp.whitelist.profession." .. steamid)

            if time > 0 then
                timer.Create("mp.whitelist.profession." .. steamid, time * 60, 1, function()
                    local p = player.GetBySteamID(steamid)

                    if IsValid(p) then
                        mp.util.Notify(p, NOTIFY_GENERIC, "Время пребывания на текущей специальности истекло!")
                        p:SetNetVar("meta_features", oldProfession)
                    end

                    db:Query(
                        "UPDATE metahub_characters SET features = ? WHERE player_id = ? AND character_id = ?;",
                        oldProfession,
                        player_id,
                        character_id)
                end)
            end

            target:SetNetVar("meta_features", nil)
            mp.util.Notify(pl, NOTIFY_GENERIC,
                target:Name() ..
                " была cнята специальность " .. (time > 0 and " (" .. time .. " мин.)" or ""))
            db:Query(
                "UPDATE metahub_characters SET features = ? WHERE player_id = ? AND character_id = ?;",
                "",
                player_id,
                character_id)

            sendUpdate(pl)

            hook.Call("PlayerWhiteListProfession", nil, pl, target, "Снять специальность", time)
        end
    end,

    ["model"] = function(_, pl)
        local db = mysql.connect_config

        local target = net.ReadEntity()
        local model_index = net.ReadString()

        local models = target:GetJobModel() or {}

        if not istable(models) then
            models = { models }
        end

        local mdlT
        if target:GetNetVar("meta_features") and mp.profession[target:GetNetVar("meta_features")] then
            mdlT = mp.profession[target:GetNetVar("meta_features")].model
            if mdlT then
                if not istable(mdlT) then
                    mdlT = { mdlT }
                end
            end
        end

        if mdlT then
            table.Add(models, mdlT)
        end

        local has = false
        for k, v in ipairs(models) do
            if v == model_index then
                has = true
                break
            end
        end

        if not has or model_index == target:GetModel() then return end

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        local player_id = target:GetNetVar("meta_playerid")
        local character_id = target:GetNetVar("meta_character")

        target:SetModel(model_index)
        mp.util.Notify(pl, NOTIFY_GENERIC, target:Name() .. " была изменена модель")
        db:Query(
            "UPDATE metahub_characters SET model = ? WHERE player_id = ? AND character_id = ?;",
            model_index,
            player_id,
            character_id)

        hook.Call("PlayerWhiteListModel", nil, pl, target, model_index)
    end,

    ["access"] = function(_, pl)
        local db = mysql.connect_config

        local target = net.ReadEntity()
        local access_table = net.ReadTable()

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        local has = true

        for k, v in pairs(access_table) do
            if not mp.config.access_list[k] then
                has = false
                break
            end

            if not v then
                access_table[k] = nil
            end
        end

        if not has then return end

        local player_id = target:GetNetVar("meta_playerid")
        local character_id = target:GetNetVar("meta_character")

        target:SetNetVar("meta_access", access_table)
        mp.util.Notify(pl, NOTIFY_GENERIC, target:Name() .. " были изменены разрешения")
        db:Query(
            "UPDATE metahub_characters SET data = ? WHERE player_id = ? AND character_id = ?;",
            util.TableToJSON(access_table),
            player_id,
            character_id)

        sendUpdate(pl)

        hook.Call("PlayerWhiteListAccess", nil, pl, target)
    end,
}

for k, v in pairs(list_command) do
    net.Receive("mp.whitelist." .. k, v)
end

local function OpenPlayerList(pl, cmd, args)
    if not pl:IsSuperAdmin() then return end

    pl.NextOpenWhiteList = pl.NextOpenWhiteList or 0
    if pl.NextOpenWhiteList > CurTime() then return end

    pl.NextOpenWhiteList = CurTime() + 2

    local db = mysql.connect_config
    db:Query("SELECT * FROM `metahub_player_data`;", function(d)
        net.Start("mp.whitelist.player_panel")
        net.WriteTable(d, true)
        net.Send(pl)
    end)
end

mp.commands.add("playermenu", OpenPlayerList)

local function OpenCharacterList(pl, cmd, args)
    if not pl:IsSuperAdmin() then return end
    if not args[2] then return end

    local player_id = args[2]

    local db = mysql.connect_config
    db:Query("SELECT * FROM `metahub_characters` WHERE player_id = ?;", player_id, function(d)
        net.Start("mp.whitelist.character_menu")
        net.WriteTable(d, true)
        net.Send(pl)
    end)
end

mp.commands.add("playercharacter", OpenCharacterList)

local id_character = {
    ["team_id"] = function(_, pl)
        local db = mysql.connect_config

        local player_id = net.ReadString()
        local character_id = net.ReadString()
        local team_id = net.ReadString()

        local job = mp.jobs_by_id[team_id]
        if not job then return end

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        if not pl:CanGiveTeam(mp.jobs_by_id[team_id].index) then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")
            return
        end

        local model = mp.jobs_by_id[team_id].model

        if istable(model) then
            model = mp.jobs_by_id[team_id].model[math.random(1, #mp.jobs_by_id[team_id].model)]
        end

        db:Query("UPDATE metahub_characters SET team_id = ?, model = ? WHERE player_id = ? AND character_id = ?;",
            team_id, model, player_id, character_id)

        mp.util.Notify(pl, NOTIFY_GENERIC, "Работа была изменена на " .. mp.jobs_by_id[team_id].Name)
    end,

    ["character_name"] = function(_, pl)
        local db = mysql.connect_config

        local player_id = net.ReadString()
        local character_id = net.ReadString()
        local name = net.ReadString()

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        db:Query("UPDATE metahub_characters SET character_name = ? WHERE player_id = ? AND character_id = ?;", name,
            player_id, character_id)

        mp.util.Notify(pl, NOTIFY_GENERIC, "Имя было изменено на " .. name)
    end,

    ["c_rank"] = function(_, pl)
        local db = mysql.connect_config

        local player_id = net.ReadString()
        local character_id = net.ReadString()
        local rank_index = net.ReadUInt(8)
        local team_id = net.ReadString()

        local faction = mp.jobs_by_id[team_id] and mp.jobs_by_id[team_id].faction or false

        if not faction or not mp.faction[faction] or not mp.faction[faction].ranks[rank_index] then return end

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        local rank = mp.faction[faction].ranks[rank_index].name

        db:Query("UPDATE metahub_characters SET c_rank = ? WHERE player_id = ? AND character_id = ?;", rank,
            player_id, character_id)

        mp.util.Notify(pl, NOTIFY_GENERIC, "Ранг был изменен на " .. rank)
    end,

    ["features"] = function(_, pl)
        local db = mysql.connect_config

        local player_id = net.ReadString()
        local character_id = net.ReadString()
        local profession_index = net.ReadString()

        if not mp.profession[profession_index] then return end
        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        db:Query("UPDATE metahub_characters SET features = ? WHERE player_id = ? AND character_id = ?;", profession_index,
            player_id, character_id)

        mp.util.Notify(pl, NOTIFY_GENERIC, "Специальность была изменена на " .. mp.profession[profession_index].name)
    end,

    ["model"] = function(_, pl)
        local db = mysql.connect_config

        local player_id = net.ReadString()
        local character_id = net.ReadString()
        local team_id = net.ReadString()
        local profession_index = net.ReadString()
        local model_index = net.ReadString()

        local models = mp.jobs_by_id[team_id] and mp.jobs_by_id[team_id].model or {}

        if not istable(models) then
            models = { models }
        end

        local mdlT
        if profession_index and mp.profession[profession_index] then
            mdlT = mp.profession[profession_index].model
            if mdlT then
                if not istable(mdlT) then
                    mdlT = { mdlT }
                end
            end
        end

        if mdlT then
            table.Add(models, mdlT)
        end

        local has = false
        for k, v in ipairs(models) do
            if v == model_index then
                has = true
                break
            end
        end

        if not has then return end

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        db:Query("UPDATE metahub_characters SET model = ? WHERE player_id = ? AND character_id = ?;", model_index,
            player_id, character_id)

        mp.util.Notify(pl, NOTIFY_GENERIC, "Модель была изменена на " .. model_index)
    end,

    ["data"] = function(_, pl)
        local db = mysql.connect_config

        local player_id = net.ReadString()
        local character_id = net.ReadString()
        local access_table = net.ReadTable()

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        local has = true

        for k, v in pairs(access_table) do
            if not mp.config.access_list[k] then
                has = false
                break
            end

            if not v then
                access_table[k] = nil
            end
        end

        if not has then return end

        db:Query("UPDATE metahub_characters SET data = ? WHERE player_id = ? AND character_id = ?;",
            util.TableToJSON(access_table),
            player_id, character_id)

        mp.util.Notify(pl, NOTIFY_GENERIC, "Разрешения были изменены")
    end,

    ["delete"] = function(_, pl)
        local player_id = net.ReadString()
        local character_id = net.ReadString()

        if not pl:CanUseWhitelist() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Нет доступа!")

            return
        end

        local db = mysql.connect_config
        db:Query("SELECT * FROM `metahub_characters` WHERE player_id = ? AND character_id = ?;", player_id,
            character_id, function(d)
                if d[1] then
                    db:Query("DELETE FROM `metahub_characters` WHERE player_id = ? AND character_id = ?;", player_id,
                        character_id)

                    mp.util.Notify(pl, NOTIFY_GENERIC, "Персонаж полностью удален")
                else
                    mp.util.Notify(pl, NOTIFY_ERROR, "Персонаж не найден!")
                end
            end)
    end
}

net.Receive("mp.whitelist.change_character", function(_, pl)
    if not pl:IsSuperAdmin() then return end

    local id = net.ReadString()

    if not id_character[id] then return end

    id_character[id](_, pl)
end)
