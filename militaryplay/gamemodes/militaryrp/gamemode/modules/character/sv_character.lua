local mp = mp
local netstream = netstream
local hook = hook

netstream.Hook("NewPlayerCharacter", function(pl, data)
    if not (IsValid(pl)) then return end

    local character_name = string.sub(data.name, 1, 30)
    local rpid = math.random(1, 9) .. math.random(1, 9) .. math.random(1, 9) .. math.random(1, 9)
    local start_team = mp.config.start_jobs[data.start_team] and data.start_team or TEAM_CADET
    local faction = mp.jobs[start_team].faction
    local data_faction = mp.faction[faction]

    local db = mysql.connect_config
    db:Query("SELECT * FROM `metahub_player_data` WHERE steam_id = ?;", pl:SteamID(),
        function(player_data)
            if player_data and player_data[1] then
                local characters = pl.Characters or {}
                local job = mp.jobs[start_team]
                local default_rank = data_faction.default_rank
                local model = istable(job.model) and table.Random(job.model) or job.model

                local char = {
                    player_id = player_data[1].id,
                    rpid = rpid,
                    team_id = job.jobid,
                    character_name = character_name,
                }

                pl:SetNetVar("meta_money", tonumber(player_data[1].money))
                pl:SetNetVar("meta_vehicles", util.JSONToTable(player_data[1].vehicles or "{}"))

                local max_characters = mp.config.max_characters[pl:GetUserGroup()] or 1
                if #characters <= max_characters then
                    db:Query(
                        "INSERT INTO `metahub_characters`(player_id, rpid, c_rank, features, team_id, character_name, model, data) VALUES(?, ?, ?, ?, ?, ?, ?, ?);",
                        char.player_id,
                        char.rpid,
                        default_rank,
                        "",
                        char.team_id,
                        char.character_name,
                        model,
                        "[]",
                        function()
                            db:Query(
                                "SELECT LAST_INSERT_ID() as character_id;",
                                function(selectResults)
                                    if selectResults and selectResults[1] and selectResults[1].character_id then
                                        local character_id = selectResults[1].character_id

                                        pl.Characters = characters or {}
                                        char.character_id = character_id
                                        char.rpid = rpid
                                        char.c_rank = default_rank
                                        char.features = ""
                                        char.team_index = start_team
                                        char.model = model
                                        char.data = "[]"
                                        table.insert(pl.Characters, char)

                                        pl:RequestCharacters(function(t, player_data)
                                            netstream.Start(pl, "OpenCharacterMenu", { characters = t })
                                            pl.Characters = t
                                        end)
                                    else
                                        print("Не удалось получить character_id")
                                    end
                                end,
                                function(error)
                                    print("Ошибка при получении character_id:", error)
                                end
                            )
                        end,
                        function(error)
                            print("Ошибка при создании персонажа:", error)
                        end
                    )
                end
            else
                db:Query(
                    "INSERT INTO `metahub_player_data`(steam_id, community_id, player, money, vehicles) VALUES(?, ?, ?, ?, ?);",
                    pl:SteamID(),
                    pl:SteamID64(),
                    pl:OldName(),
                    mp.config.start_money,
                    "{}",
                    function(results)
                        pl:SetNetVar("meta_money", mp.config.start_money)
                        pl:SetNetVar("meta_vehicles", util.JSONToTable("{}"))
                    end,
                    function(error)
                        print("Ошибка при создании записи игрока:", error)
                    end
                )
            end
        end,
        function(error)
            print("Ошибка при поиске игрока:", error)
        end
    )
end)

netstream.Hook("RemovePlayerCharacter", function(pl, data)
    if not (IsValid(pl)) then return end
    local can_remove = true

    if pl:GetNetVar("meta_character") == data.character_id then
        pl:RequestCharacters(function(characters, player_data)
            netstream.Start(pl, "OpenCharacterMenu",
                { characters = characters, err = "Вы не можете удалить этого персонажа играя за него." })
        end)
        return
    end

    local character_id = data.character_id
    for k, char in pairs(pl.Characters) do
        if char.character_id == 1 then
            if char.team_id == "cadet_dolbaeb" then
                netstream.Start(pl, "OpenCharacterMenu",
                    { characters = pl.Characters, err = "Вы не можете удалить этого персонажа." })
                can_remove = false
            end
            break
        end
    end
    if can_remove ~= false then
        local db = mysql.connect_config
        db:Query(
            "DELETE FROM `metahub_characters` WHERE character_id = ?;",
            character_id,
            function(results)
                pl:RequestCharacters(function(characters, player_data)
                    netstream.Start(pl, "OpenCharacterMenu", { characters = characters })
                    pl.Characters = characters
                end)
            end,
            function(error)
                print("Ошибка при удалении персонажа:", error)
            end
        )
    end
end)

netstream.Hook("SpawnPlayerCharacter", function(pl, data)
    --if not pl:Alive() then return end

    if not IsValid(pl) then return end
    local character_id = data.character_id

    if not (character_id) then return end
    if not (pl:CharacterByID(character_id)) then return end

    if pl:GetNetVar("Arrested") then
        return
    end

    pl:LoadCharacter(function(char)
        hook.Run("PlayerLoadout", pl)

        pl:SetNetVar("meta_character", character_id)
        pl:SetNetVar("meta_rank", char.c_rank)

        --local data = istable(char.data) and char.data or util.JSONToTable(char.data)
        pl:SetNetVar("meta_features", char.features)
        pl:SetNetVar("meta_rpid", char.rpid)
        pl:SetNetVar("rpname", char.character_name)
        -- pl:SetNetVar("meta_data", data)

        if char.data then
            pl:SetNetVar("meta_access", char.data)
        end

        pl:Spawn()
    end, character_id)

    local db = mysql.connect_config
    db:Query(
        "SELECT * FROM `metahub_player_levelsystem` WHERE steam_id = ?;",
        pl:SteamID(),
        function(data)
            local level, experience

            if data and data[1] then
                level, experience = data[1].level, data[1].experience
            else
                level, experience = 1, 0

                db:Query(
                    "INSERT INTO `metahub_player_levelsystem`(steam_id, level, experience) VALUES(?, ?, ?);",
                    pl:SteamID(),
                    level,
                    experience,
                    function(results)
                        -- Успешно добавлено
                    end,
                    function(error)
                        print("Ошибка при создании записи уровня:", error)
                    end
                )
            end

            pl:SetNetVar("meta_level", level)
            pl:SetNetVar("meta_experience", experience)
        end,
        function(error)
            print("Ошибка при получении данных уровня:", error)
        end
    )
end)

hook.Add("PlayerInitialSpawn", "Characters_PlayerInitialSpawn", function(pl)
    if pl:IsBot() then
        pl:SetTeam(TEAM_CIV)
        pl:SetNetVar("meta_money", mp.config.start_money)
        pl:SetNetVar("meta_vehicles", {})
        pl:SetNetVar("meta_playerid", pl:EntIndex())
        hook.Run("PlayerLoadout", pl)

        pl:SetNetVar("meta_character", 1)

        pl:SetNetVar("meta_rpid", math.random(1111, 9999) + pl:EntIndex())
        pl:SetNetVar("rpname", pl:Name())

        pl:Spawn()
        return
    end

    local db = mysql.connect_config
    db:Query(
        "SELECT * FROM `metahub_player_data` WHERE steam_id = ?;",
        pl:SteamID(),
        function(player_data)
            if player_data and player_data[1] then
                pl:SetNetVar("meta_money", tonumber(player_data[1].money))
                pl:SetNetVar("meta_vehicles", util.JSONToTable(player_data[1].vehicles or "{}"))

                pl:RequestCharacters(function(characters, player_data)
                    netstream.Start(pl, "OpenInitCharacterMenu", { characters = characters })
                    pl.Characters = characters
                end)
            else
                db:Query(
                    "INSERT INTO `metahub_player_data`(steam_id, community_id, player, money, vehicles) VALUES(?, ?, ?, ?, ?);",
                    pl:SteamID(),
                    pl:SteamID64(),
                    pl:OldName(),
                    mp.config.start_money,
                    "{}",
                    function(results)
                        pl:SetNetVar("meta_money", mp.config.start_money)
                        pl:SetNetVar("meta_vehicles", util.JSONToTable("{}"))

                        pl:RequestCharacters(function(characters, player_data)
                            netstream.Start(pl, "OpenInitCharacterMenu", { characters = characters })
                            pl.Characters = characters
                        end)
                    end,
                    function(error)
                        print("Ошибка при создании записи игрока:", error)
                    end
                )
            end
        end,
        function(error)
            print("Ошибка при получении данных игрока:", error)
        end
    )
end)

concommand.Add("character_menu", function(pl)
    if pl:IsAdmin() then
        pl:RequestCharacters(function(characters, player_data)
            netstream.Start(pl, "OpenInitCharacterMenu", { characters = characters })
            pl.Characters = characters
        end)
    end
end)
