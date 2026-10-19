local PLAYER = PLAYER
local mysql = mysql
local mp = mp
local Vector = Vector
local table_Random = table.Random
local IsValid = IsValid
local GM = GM

function PLAYER:SavePlayerData(name, value, is_money)
    if is_money and (value < 0 or value >= 1 / 0) then return end

    local dp = mysql.connect_config
    dp:Query("UPDATE metahub_player_data SET " .. name .. " = ? WHERE steam_id = ?;", value, self:SteamID())
end

function PLAYER:SetSaveBodyGroup()
    if self:GetSaveBodygroup() and self:GetSaveBodygroup()[self:GetModel()] then
        local t = self:GetSaveBodygroup()[self:GetModel()]

        if t.skin then
            self:SetSkin(tonumber(t.skin))
        end

        if t.bodygroup then
            for id, typ in pairs(t.bodygroup) do
                if not tonumber(id) or not tonumber(typ) then continue end

                self:SetBodygroup(tonumber(id), tonumber(typ))
            end
        end
    end
end

function PLAYER:UpdateSaveBodygroup(t)
    self:SetNetVar("save_bodygroup", t or {})

    file.Write("save_body/" .. self:SteamID64() .. ".json", util.TableToJSON(t or {}))
end

function PLAYER:ChangeRPID(new)
    if not self.is_load_char then return end

    local t = self:Team()
    local char_id = self:GetNetVar("meta_character")

    if not char_id then return end
    if t == TEAM_CONNECTING or t == TEAM_SPECTATOR or t == TEAM_UNASSIGNED then return end

    self:SetNetVar("meta_rpid", new)
    local dp = mysql.connect_config
    dp:Query("UPDATE metahub_characters SET rpid = ? WHERE character_id = ?;", new, char_id)
end

function PLAYER:ChangeNickname(new)
    if not self.is_load_char then return end

    local t = self:Team()
    local char_id = self:GetNetVar("meta_character")

    if not char_id then return end
    if t == TEAM_CONNECTING or t == TEAM_SPECTATOR or t == TEAM_UNASSIGNED then return end

    local character_name = string.sub(new, 1, 30)
    local dp = mysql.connect_config

    self:SetNetVar("rpname", character_name)
    dp:Query("UPDATE metahub_characters SET character_name = ? WHERE character_id = ?;", character_name, char_id)
end

function PLAYER:CharacterByID(character_id)
    for i, char in pairs(self.Characters) do
        if char.character_id == character_id then
            return char
        end
    end

    return false
end

function PLAYER:SetMoney(intCount)
    self:SavePlayerData("money", intCount, true)
    self:SetNetVar("meta_money", intCount)
end

function PLAYER:AddMoney(intCount)
    self:SetMoney(self:GetMoney() + intCount)
end

function PLAYER:RequestCharacters(func)
    local dp = mysql.connect_config

    dp:Query("SELECT * FROM metahub_player_data WHERE steam_id = ?;", self:SteamID(), function(player_data)
        if player_data[1] then
            local d = player_data[1]
            self:SetNetVar("meta_playerid", d.id)

            dp:Query("SELECT * FROM metahub_characters WHERE player_id = ?;", d.id, function(t)
                local characters = t or {}

                for i, char in ipairs(characters) do
                    if not mp.jobs_by_id[char.team_id] then continue end
                    local data_table = util.JSONToTable(char.data or "[]") or {}

                    characters[i].team_index = mp.jobs_by_id[char.team_id].index
                    characters[i].data = data_table
                end

                if func then func(characters, d) end
                return characters, d
            end)
        else
            return false
        end
    end)
end

function PLAYER:LoadCharacter(func, character_id)
   -- local steamid = self:SteamID()

    local char = self:CharacterByID(character_id)

    if char then
        self.is_load_char = true
        self:SetNetVar("rpname", char.name)
        -- self:SetCurrentSkillHooks()

        self:SetTeam(char.team_index)
        self:Spawn()

        mp.QuestPlay:UpdateQuest(self)

        if func then func(char) end
    else
        self:ConCommand("retry")
    end
end

function PLAYER:IsNoclip()
    return self.NoclipPlayer
end

function mp.util.isEmpty(vector, ignore)
    ignore = ignore or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
            b = false
            break
        end
    end

    return a and b
end

function mp.util.findEmptyPos(pos, ignore, distance, step, area)
    if mp.util.isEmpty(pos, ignore) and mp.util.isEmpty(pos + area, ignore) then
        return pos
    end

    for j = step, distance, step do
        for i = -1, 1, 2 do
            local k = j * i

            if mp.util.isEmpty(pos + Vector(k, 0, 0), ignore) and mp.util.isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
                return pos + Vector(k, 0, 0)
            end

            if mp.util.isEmpty(pos + Vector(0, k, 0), ignore) and mp.util.isEmpty(pos + Vector(0, k, 0) + area, ignore) then
                return pos + Vector(0, k, 0)
            end

            if mp.util.isEmpty(pos + Vector(0, 0, k), ignore) and mp.util.isEmpty(pos + Vector(0, 0, k) + area, ignore) then
                return pos + Vector(0, 0, k)
            end
        end
    end

    return pos
end

function GM:PlayerSelectSpawn(pl)
    local tm = pl:Team()
    local POS
    local faction = (pl:GetFaction() and mp.faction[pl:GetFaction()]) and mp.faction[pl:GetFaction()] or {}
    local job_spawn = (mp.jobs[tm] and mp.jobs[tm].spawn_pos) and mp.jobs[tm].spawn_pos or nil

    if tm == 0 or tm == 1001 then
        pl:SetNoDraw(true)
        POS = mp.config.start_menu_pos
    elseif not pl:IsNoclip() then
        pl:SetNoDraw(false)
    end

    local spawner_table = {}

    if job_spawn then
        spawner_table = job_spawn
    else
        local spawner = ents.FindByClass("base_gmodentity")
        for k, v in ipairs(spawner) do
            if v:GetNW2String("faction_name") or v:GetNW2Int("faction_jobs") then
                if v:GetNW2String("faction_name") == pl:GetFaction() then
                    spawner_table[#spawner_table + 1] = v:GetPos()
                end

                if v:GetNW2Int("faction_jobs") == pl:Team() then
                    spawner_table[#spawner_table + 1] = v:GetPos()
                end
            end
        end
    end

    if #spawner_table > 0 then
        POS = table_Random(spawner_table)
    elseif faction.spawn_pos then
        POS = table_Random(faction.spawn_pos)
    end

    if pl:GetNetVar("Arrested") then
        if pl:IsNATO() then
            POS = table_Random(faction.jail_pos)
        elseif pl:IsRF() then
            POS = table_Random(faction.jail_pos)
        else
            POS = table_Random(mp.config.jail_pos)
        end
    end

    if not POS then
        local spawn = table_Random(ents.FindByClass("info_player_start"))

        if spawn and spawn.GetPos then
            POS = spawn:GetPos()
        else
            POS = pl:GetPos()
        end
    end


    POS = mp.util.findEmptyPos(POS, { pl }, 600, 30, Vector(16, 16, 64))

    return spawn, POS
end

function GM:PlayerCanHearPlayersVoice(listener, talker)

end

function GM:PlayerCanSeePlayersChat(text, bTeam, listener, talker)
    if not IsValid(listener) or not IsValid(talker) then return end
    if listener:GetPos():Distance(talker:GetPos()) > 300 then return false end
    return true
end

function GM:PlayerInitialSpawn(pl)
end

local addStats = {
    maxhealth = function(pl, num)
        pl:SetMaxHealth(num)
    end,
    maxarmor = function(pl, num)
        pl:SetMaxArmor(num)
    end
}

hook.Add("PlayerChangeTeam", "mp.SpawnTeam", function(pl, t, force)
    local team = mp.jobs[t]

    if not (team) then return false end
    if team.admin and not pl:IsAdmin() and not force then return false end

    if team.stats then
        for k, v in pairs(team.stats) do
            if addStats[k] then
                addStats[k](pl, v)
            end
        end
    end

    local features = pl:GetNetVar("meta_features")
    local faction = team.faction
    local rank = pl:GetNetVar("meta_rank")

    if faction and mp.faction[faction] and mp.faction[faction].ranks then
        local faction_data = mp.faction[faction]

        do
            local has = false

            for k, v in ipairs(faction_data.ranks) do
                if rank == v.name then
                    has = true
                    break
                end
            end

            if not has then
                pl:SetNetVar("meta_rank", faction_data.ranks[1].name)
                rank = faction_data.ranks[1].name
            end
        end


        if features and features ~= "Отсутствует" then
            local has = faction_data.profession[features] and true or false

            if not has then
                features = ""
                pl:SetNetVar("meta_features", nil)
            end
        end
    end

    local rank_weapons = {}

    if rank then
        rank_weapons = (mp.ranks[rank] and mp.ranks[rank].weapons) and mp.ranks[rank].weapons or
            {}
    end

    pl:StripWeapons()

    for i = 1, #rank_weapons do
        if pl:HasWeapon(rank_weapons[i]) then continue end
        pl:Give(rank_weapons[i])
    end

    if team.weapons then
        for i = 1, #team.weapons do
            if pl:HasWeapon(team.weapons[i]) then continue end
            pl:Give(team.weapons[i])
        end
    end

    if pl:IsAdmin() then
        for k, v in ipairs(mp.config.admin_weapons) do
            if pl:HasWeapon(v) then continue end
            pl:Give(v)
        end
    end

    local profession = mp.profession[features]
    local model = pl:GetModel()

    if profession and profession.model then
        if istable(profession.model) then
            model = profession.model[math.random(1, #profession.model)]
            pl:SetModel(model)
        else
            model = profession.model
            pl:SetModel(profession.model)
        end

        if profession.spawn then
            profession.spawn(pl)
        end
    elseif team.model then
        if istable(team.model) then
            model = table.Random(team.model)
            pl:SetModel(model)
        else
            model = team.model
            pl:SetModel(model)
        end

        if pl and team.spawn then
            team.spawn(pl)
        end
    end

    local player_id = pl:GetNetVar("meta_playerid")
    local character_id = pl:GetNetVar("meta_character")
    local db = mysql.connect_config
    db:Query("UPDATE metahub_characters SET team_id = ?, model = ? WHERE player_id = ? AND character_id = ?;",
        team.jobid,
        model,
        player_id,
        character_id)

    pl:SetTeam(t)

    mp.QuestPlay:UpdateQuest(pl)

    return true
end)
