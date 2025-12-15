local mp = mp
local util = util
local net = net
local hook = hook
local timer = timer
local player = player
local IsValid = IsValid

local nw = { "job", "rank", "profession", "model", "access", "update_menu" }
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
            mp.util.Notify("red", pl, "Нет доступа!")

            return
        end
        if not pl:CanGiveTeam(team_index) then
            mp.util.Notify("red", pl, "Нет доступа!")
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
                    mp.util.Notify("green", p, "Время пребывания на текущей работе истекло!")
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

        mp.util.Notify("green", pl,
            target:Name() .. " была изменена работа на " .. job.Name .. (time > 0 and " (" .. time .. " мин.)" or ""))
        hook.Call("PlayerChangeTeam", nil, target, team_index, true)

        sendUpdate(pl)
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
            mp.util.Notify("red", pl, "Нет доступа!")

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
                    mp.util.Notify("green", p, "Время пребывания на текущем звании истекло!")
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
        mp.util.Notify("green", pl,
            target:Name() .. " было изменено звание на " .. rank .. (time > 0 and " (" .. time .. " мин.)" or ""))
        db:Query(
            "UPDATE metahub_characters SET c_rank = ? WHERE player_id = ? AND character_id = ?;",
            rank,
            player_id,
            character_id)

        sendUpdate(pl)
    end,

    ["profession"] = function(_, pl)
        local db = mysql.connect_config

        local target = net.ReadEntity()
        local profession_index = net.ReadString()
        local time = net.ReadUInt(32)

        local faction = mp.faction[target:GetFaction()]
        if not faction or not faction.profession[profession_index] then return end
        if faction.profession[profession_index].name == target:GetNetVar("meta_features") then return end

        if not pl:CanUseWhitelist() then
            mp.util.Notify("red", pl, "Нет доступа!")

            return
        end

        local steamid = target:SteamID()
        local oldProfession = target:GetNetVar("meta_features")
        local player_id = target:GetNetVar("meta_playerid")
        local character_id = target:GetNetVar("meta_character")

        timer.Remove("mp.whitelist.profession." .. steamid)

        if time > 0 then
            timer.Create("mp.whitelist.profession." .. steamid, time * 60, 1, function()
                local p = player.GetBySteamID(steamid)

                if IsValid(p) then
                    mp.util.Notify("green", p, "Время пребывания на текущей специальности истекло!")
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
        mp.util.Notify("green", pl,
            target:Name() .. " было изменено звание на " .. profession .. (time > 0 and " (" .. time .. " мин.)" or ""))
        db:Query(
            "UPDATE metahub_characters SET features = ? WHERE player_id = ? AND character_id = ?;",
            profession_index,
            player_id,
            character_id)

        sendUpdate(pl)
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
            mp.util.Notify("red", pl, "Нет доступа!")

            return
        end

        local player_id = target:GetNetVar("meta_playerid")
        local character_id = target:GetNetVar("meta_character")

        target:SetModel(model_index)
        mp.util.Notify("green", pl, target:Name() .. " была изменена модель")
        db:Query(
            "UPDATE metahub_characters SET model = ? WHERE player_id = ? AND character_id = ?;",
            model_index,
            player_id,
            character_id)
    end,

    ["access"] = function(_, pl)
        local db = mysql.connect_config

        local target = net.ReadEntity()
        local access_table = net.ReadTable()

        if not pl:CanUseWhitelist() then
            mp.util.Notify("red", pl, "Нет доступа!")

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
        mp.util.Notify("green", pl, target:Name() .. " были изменены разрешения")
        db:Query(
            "UPDATE metahub_characters SET data = ? WHERE player_id = ? AND character_id = ?;",
            util.TableToJSON(access_table),
            player_id,
            character_id)

        sendUpdate(pl)
    end,
}

for k, v in pairs(list_command) do
    net.Receive("mp.whitelist." .. k, v)
end
