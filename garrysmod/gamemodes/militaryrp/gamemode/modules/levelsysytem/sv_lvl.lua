local t

/*util.AddNetworkString('AddPlayerEXP')
util.AddNetworkString('AddLevel')
util.AddNetworkString('CreateLlvMenu')

local mp = mp
local PLAYER = PLAYER

function PLAYER:SetLevel(intCount)
    --self:SavePlayerData('level', intCount)

    local db = mysql.connect_config
    db:Query(
        "UPDATE metahub_player_levelsystem SET level = ? WHERE steam_id = ?;",
        intCount,
        self:SteamID(),
        function(results)
        end,
        function(error)
            print("Ошибка при обновлении уровня:", error)
        end
    )

    self:SetNetVar('meta_level', intCount)
end

function PLAYER:AddLevel(intCount)
    if self:HasLevel(100) then return end

    intCount = self:GetLevel() + intCount
    self:SetLevel(intCount)

    net.Start('AddLevel')
    net.Send(self)
end

function PLAYER:SetExperience(intCount)
    -- self:SavePlayerData('experience', intCount)

    local db = mysql.connect_config
    db:Query(
        "UPDATE metahub_player_levelsystem SET experience = ? WHERE steam_id = ?;",
        intCount,
        self:SteamID(),
        function(results)
        end,
        function(error)
            print("Ошибка при обновлении опыта:", error)
        end
    )

    self:SetNetVar('meta_experience', intCount)
    self:isPassedLevel()
end

function PLAYER:AddExperience(intCount)
    --[[if self:HasLevel(100) then return end
    if not self:Alive() then return end

    self:SetExperience(math.Round(intCount + self:GetExperience()))]]
end

function PLAYER:isPassedLevel()
    if (self:GetExperience() >= self:GetNeedExperience()) then
        local Exp = self:GetExperience() - self:GetNeedExperience()

        self:AddLevel(1)
        self:SetExperience(Exp)
    end
end

local PercentExp = 0

local function PercentExpSystem(ply)
    if ply:HasLevel(mp.Perks[10].level) then
        PercentExp = mp.Perks[10].effect
    elseif ply:HasLevel(mp.Perks[9].level) then
        PercentExp = mp.Perks[9].effect
    elseif ply:HasLevel(mp.Perks[8].level) then
        PercentExp = mp.Perks[8].effect
    else
        PercentExp = 0
    end

    return PercentExp
end

function PLAYER:AddPlayerEXP(exp, kill)
    --[[if self:HasLevel(100) then return end
    PercentExpSystem(self)

    exp = exp + SetTI(exp, PercentExp)

    self:AddExperience(exp)

    net.Start('AddPlayerEXP')
    net.WriteInt(exp, 18)
    net.WriteBool(kill)
    net.Send(self)]]
end

--[[timer.Create("LevelTimer", 3600, 0, function()
    for _, pPlayer in ipairs(player.GetAll()) do
        if not IsValid(pPlayer) or not pPlayer:Alive() then continue end

        pPlayer:AddPlayerEXP(100, false)
    end
end)]]

hook.Add('OnNPCKilled', 'Levelsystem_OnNPCKilled', function(npc, attacker, inflictor)
    if attacker and attacker:IsPlayer() then
        --attacker:AddPlayerEXP(50, true)
    end
end)

hook.Add('PlayerDeath', 'Levelsystem_PlayerDeath', function(victim, inflictor, attacker)
    //if attacker and attacker:IsPlayer() and victim ~= attacker then
    //    attacker:AddPlayerEXP(100, true)
    //end
end)

hook.Add("EntityTakeDamage", "SetDamageEXP", function(ply, dmginfo)
    --[[local HP = ply:Health()
    local MaxHP = ply:GetMaxHealth()
    local exp = dmginfo:GetDamage()
    local Killer = dmginfo:GetAttacker()

    exp = math.Clamp(math.Round(exp), 0, MaxHP)

    if Killer ~= ply and exp > 0 then
        if ply:IsPlayer() or ply:IsNPC() then
            if Killer:IsPlayer() then
                Killer:AddPlayerEXP(exp, false)
            end
        end
    end]]
end)

hook.Add('ShowSpare2', 'CreateLvlMenu', function(ply)
    //net.Start('CreateLlvMenu')
    //net.Send(ply)
end)
*/