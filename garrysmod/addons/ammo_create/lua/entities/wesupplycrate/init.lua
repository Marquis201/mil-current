AddCSLuaFile("cl_init.lua") -- Send clientside file
AddCSLuaFile("shared.lua")  -- Send shared file
include("shared.lua")       -- Include shared file

-- Глобальная таблица для отслеживания выдачи гранат (для всех ящиков)
local GlobalGrenadePickups = {}

function wblsupplyaddammo(ply, weaponclass, addclipcount, issecondary)
    if not IsValid(ply) or not ply:IsPlayer() then return false end
    if not weaponclass or type(weaponclass) ~= "string" then return false end
    addclipcount = tonumber(addclipcount) or 1
    issecondary = tobool(issecondary)

    local weapon = nil
    for _, wep in ipairs(ply:GetWeapons()) do
        if wep:GetClass() == weaponclass then
            weapon = wep
            break
        end
    end

    if not IsValid(weapon) then
        return false
    end

    if not issecondary then
        -- Primary ammo
        local maxClip1 = weapon:GetMaxClip1()
        local ammoType = weapon:GetPrimaryAmmoType()
        if ammoType == -1 then return false end -- no ammo type for melee, etc.

        local currentReserve = ply:GetAmmoCount(ammoType)

        if maxClip1 and maxClip1 > 0 then
            ply:SetAmmo(currentReserve + (maxClip1 * addclipcount), ammoType)
        else
            local addAmount
            if currentReserve < 10 then
                addAmount = 1 * addclipcount
            else
                addAmount = math.floor(currentReserve * (0.1 * addclipcount))
                if addAmount < 1 then addAmount = 1 * addclipcount end
            end
            if addAmount > 150 then 
                addAmount = 150
            end
            ply:SetAmmo(currentReserve + addAmount, ammoType)
        end

    else
        -- Secondary ammo
        local maxClip2 = weapon:GetMaxClip2()
        local ammoType = weapon:GetSecondaryAmmoType()
        if ammoType == -1 then return false end

        local currentReserve = ply:GetAmmoCount(ammoType)

        if maxClip2 and maxClip2 > 0 then
            ply:SetAmmo(currentReserve + (maxClip2 * addclipcount), ammoType)
        else
            local addAmount
            if currentReserve < 10 then
                addAmount = 1 * addclipcount
            else
                addAmount = math.floor(currentReserve * (0.1 * addclipcount))
                if addAmount < 1 then addAmount = 1 * addclipcount end
            end
            if addAmount > 150 then 
                addAmount = 150
            end
            ply:SetAmmo(currentReserve + addAmount, ammoType)
        end
    end

    return true
end

function ENT:Initialize()
    self:SetModel("models/items/ammocrate_smg1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)        -- Make it solid
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)             -- So +USE works

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)            -- Freeze the entity in place
    end
end

util.AddNetworkString("wbl_ammo_crate_cooldown")
util.AddNetworkString("wbl_grenade_limit_update")

-- Список ограниченных гранат
local LIMITED_GRENADES = {
    ["tfa_f1"] = true,
    ["tfa_m67"] = true,
    ["tfa_rgd5"] = true
}

local MAX_GRENADE_PICKUPS = 2 -- Максимальное количество получений гранат всего

function ENT:Use(activator, caller)
    if not (IsValid(activator) and activator:IsPlayer()) then return end

    -- Per-player cooldown table
    self.PlayerCooldowns = self.PlayerCooldowns or {}
    local curTime = CurTime()
    local cooldown = 30

    if self.PlayerCooldowns[activator] and self.PlayerCooldowns[activator] > curTime then return end

    -- Проверка ограничения на гранаты
    local weapon = activator:GetActiveWeapon()
    if IsValid(weapon) then
        local weaponClass = weapon:GetClass()
        
        -- Если это ограниченная граната
        if LIMITED_GRENADES[weaponClass] then
            local steamID = activator:SteamID()
            GlobalGrenadePickups[steamID] = GlobalGrenadePickups[steamID] or {}
            
            local totalPickups = GlobalGrenadePickups[steamID][weaponClass] or 0
            
            if totalPickups >= MAX_GRENADE_PICKUPS then
                -- Отправляем сообщение игроку
                activator:EmitSound("buttons/blip1.wav", 20, 100) -- Звук отказа
                return
            end
            
            -- Увеличиваем глобальный счётчик получений
            GlobalGrenadePickups[steamID][weaponClass] = totalPickups + 1
            
            -- Показываем игроку сколько раз он ещё может взять
            local remaining = MAX_GRENADE_PICKUPS - (totalPickups + 1)
            if remaining > 0 then
            end
            
            -- Отправляем обновление клиенту
            net.Start("wbl_grenade_limit_update")
            net.WriteString(weaponClass)
            net.WriteInt(remaining, 8)
            net.Send(activator)
        end
    end

    -- Set next use for this player
    self.PlayerCooldowns[activator] = curTime + cooldown

    self:HandleInteraction(activator)

    -- Play crate open sound
    self:EmitSound("items/ammocrate_open.wav", 75, 100)

    -- Give ammo
    if IsValid(weapon) then
        if wblsupplyaddammo(activator, weapon:GetClass(), 1, false) then
            activator:EmitSound("items/ammo_pickup.wav", 75, 100)
        end
        if wblsupplyaddammo(activator, weapon:GetClass(), 1, true) then
            activator:EmitSound("items/ammo_pickup.wav", 75, 100)
        end
    end

    -- Send cooldown to this client only
    net.Start("wbl_ammo_crate_cooldown")
    net.WriteEntity(self)
    net.WriteFloat(self.PlayerCooldowns[activator])
    net.Send(activator)
end

function ENT:HandleInteraction(ply)
    local seqName = "Open"
    local seq = self:LookupSequence(seqName)
    
    if seq then
        local duration = self:SequenceDuration(seq)
        local startTime = CurTime()
        local freezeTime = 0.25       -- seconds to hold at last frame
        local phase = "forward"       -- can be "forward", "frozen", "backward"
        
        self:ResetSequence(seq)
        self:SetPlaybackRate(0)
        self:SetCycle(0)

        timer.Create("ENT_InteractionSmooth"..self:EntIndex(), 0.01, 0, function()
            if not IsValid(self) then
                timer.Remove("ENT_InteractionSmooth"..self:EntIndex())
                return
            end

            local elapsed = CurTime() - startTime

            if phase == "forward" then
                local fraction = math.min(elapsed / duration, 1)
                self:SetCycle(fraction)

                if fraction >= 1 then
                    phase = "frozen"
                    startTime = CurTime() -- reset time for freeze
                end

            elseif phase == "frozen" then
                if elapsed >= freezeTime then
                    phase = "backward"
                    startTime = CurTime() -- reset time for reverse
                end

            elseif phase == "backward" then
                local fraction = math.max(1 - (elapsed / duration), 0)
                self:SetCycle(fraction)

                if fraction <= 0 then
                    self:SetCycle(0)
                    timer.Remove("ENT_InteractionSmooth"..self:EntIndex())
                end
            end
        end)
    end
end

-- Очистка таймера при удалении энтити
function ENT:OnRemove()
    timer.Remove("ENT_InteractionSmooth"..self:EntIndex())
end

-- Функция для сброса ограничений (можно вызвать при необходимости)
function ResetGrenadeLimits(ply)
    if IsValid(ply) and ply:IsPlayer() then
        local steamID = ply:SteamID()
        GlobalGrenadePickups[steamID] = nil
    end
end

-- Команда для сброса ограничений (опционально)
concommand.Add("reset_grenade_limits", function(ply)
    if IsValid(ply) and ply:IsPlayer() then
        ResetGrenadeLimits(ply)
    end
end)

-- Сброс при смерти игрока (опционально)
hook.Add("PlayerDeath", "ResetGrenadeLimitsOnDeath", function(ply)
    if IsValid(ply) and ply:IsPlayer() then
        local steamID = ply:SteamID()
        GlobalGrenadePickups[steamID] = nil
    end
end)