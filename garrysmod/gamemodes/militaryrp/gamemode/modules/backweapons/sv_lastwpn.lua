--[[-- Список оружия, которое НЕ должно быть на спине
local excludeWeapons = {
    -- Пистолеты TFA
    ['tfa_colt_1911'] = true,
    ['tfa_glock'] = true,
    ['tfa_deagle'] = true,
    ['tfa_fiveseven'] = true,
    ['tfa_m1911'] = true,
    ['tfa_m9'] = true,
    ['tfa_m92'] = true,
    ['tfa_p226'] = true,
    ['tfa_usp'] = true,
    ['tfa_revolver'] = true,
    ['tfa_mateba'] = true,
    
    -- Маленькое оружие
    ['tfa_mac10'] = true,
    ['tfa_mp9'] = true,
    ['tfa_scorpion'] = true,
    ['tfa_tec9'] = true,
    ['tfa_uzi'] = true,
    
    -- Гранаты и взрывчатка
    ['tfa_grenade'] = true,
    ['tfa_smoke'] = true,
    ['tfa_flash'] = true,
    ['tfa_molotov'] = true,
    
    -- Ножи и холодное оружие
    ['tfa_knife'] = true,
    ['tfa_bayonet'] = true,
    ['tfa_katana'] = true,
    ['tfa_machete'] = true,
}

-- Список оружия, которое всегда должно быть на спине (даже если активно)
local alwaysOnBack = {
    ['tfa_rpg7'] = true,
    ['tfa_m79'] = true,
    ['tfa_m32'] = true,
}

-- Функция проверки, можно ли положить оружие на спину
local function CanPutOnBack(weapon)
    if not IsValid(weapon) then return false end
    
    local class = weapon:GetClass()
    
    -- Исключаем оружие из списка исключений
    if excludeWeapons[class] then return false end
    
    -- Проверяем holdtype для TFA
    local holdtype = weapon:GetHoldType()
    if holdtype == "pistol" or holdtype == "revolver" or holdtype == "melee" or holdtype == "knife" then
        return false
    end
    
    -- Проверяем, является ли оружие TFA оружием
    if not string.StartWith(class, "tfa_") then
        return false
    end
    
    -- Проверяем категорию оружия (если есть в TFA)
    local weaponTable = weapons.GetStored(class)
    if weaponTable and weaponTable.Category then
        local category = string.lower(weaponTable.Category)
        if string.find(category, "pistol") or string.find(category, "melee") then
            return false
        end
    end
    
    return true
end

hook.Add("PlayerSwitchWeapon", "TFA_BackWeapons_Switch", function(ply, oldWeapon, newWeapon)
    if not IsValid(oldWeapon) or not IsValid(newWeapon) then return end
    
    -- Проверяем анимацию (если есть ваша система)
    if ply:GetNetVar("Anim") then return end
    
    local oldClass = oldWeapon:GetClass()
    local newClass = newWeapon:GetClass()
    
    -- Очищаем слот если взяли оружие с него
    if newClass == ply:GetNetVar("tfa_c_wpn") then
        ply:SetNetVar("tfa_c_wpn", "")
        ply:SetNetVar("tfa_m_wpn", "")
        return
    end
    
    if newClass == ply:GetNetVar("tfa_c_wpn2") then
        ply:SetNetVar("tfa_c_wpn2", "")
        ply:SetNetVar("tfa_m_wpn2", "")
        return
    end
    
    -- Проверяем можно ли положить оружие на спину
    if not CanPutOnBack(oldWeapon) then return end
    
    -- Проверяем не находится ли уже это оружие на спине
    if oldClass == ply:GetNetVar("tfa_c_wpn") or oldClass == ply:GetNetVar("tfa_c_wpn2") then
        return
    end
    
    -- Проверяем специальное оружие (гранатометы)
    if alwaysOnBack[oldClass] then
        -- Для RPG/M79 используем специальную логику
        ply:SetNetVar("tfa_special_weapon", oldClass)
        ply:SetNetVar("tfa_special_model", oldWeapon:GetModel())
        return
    end
    
    -- Чередуем слоты
    local toggle = ply:GetNetVar("tfa_slot_toggle") or 0
    if toggle == 0 then
        ply:SetNetVar("tfa_c_wpn", oldClass)
        ply:SetNetVar("tfa_m_wpn", oldWeapon:GetModel())
        ply:SetNetVar("tfa_slot_toggle", 1)
    else
        ply:SetNetVar("tfa_c_wpn2", oldClass)
        ply:SetNetVar("tfa_m_wpn2", oldWeapon:GetModel())
        ply:SetNetVar("tfa_slot_toggle", 0)
    end
    
    -- Синхронизируем attachments для TFA
    if oldWeapon.Attachments and oldWeapon.GetStat then
        local attachments = {}
        for k, v in pairs(oldWeapon.Attachments) do
            if v.installed then
                attachments[k] = true
            end
        end
        ply:SetNetVar("tfa_attachments_" .. oldClass, attachments)
    end
end)

-- Очистка при смерти
hook.Add("PlayerDeath", "TFA_BackWeapons_ClearOnDeath", function(ply)
    ply:SetNetVar("tfa_c_wpn", "")
    ply:SetNetVar("tfa_m_wpn", "")
    ply:SetNetVar("tfa_c_wpn2", "")
    ply:SetNetVar("tfa_m_wpn2", "")
    ply:SetNetVar("tfa_special_weapon", "")
    ply:SetNetVar("tfa_special_model", "")
    ply:SetNetVar("tfa_slot_toggle", 0)
end)

-- Очистка при разоружении
hook.Add("PlayerLoadout", "TFA_BackWeapons_ClearLoadout", function(ply)
    ply:SetNetVar("tfa_c_wpn", "")
    ply:SetNetVar("tfa_m_wpn", "")
    ply:SetNetVar("tfa_c_wpn2", "")
    ply:SetNetVar("tfa_m_wpn2", "")
    ply:SetNetVar("tfa_special_weapon", "")
    ply:SetNetVar("tfa_special_model", "")
    ply:SetNetVar("tfa_slot_toggle", 0)
end)

-- Сетевые переменные
util.AddNetworkString("tfa_backweapons_update")
util.AddNetworkString("tfa_backweapons_clear")

-- Функции для ручного управления
local function ClearBackWeapons(ply)
    ply:SetNetVar("tfa_c_wpn", "")
    ply:SetNetVar("tfa_m_wpn", "")
    ply:SetNetVar("tfa_c_wpn2", "")
    ply:SetNetVar("tfa_m_wpn2", "")
    ply:SetNetVar("tfa_special_weapon", "")
    ply:SetNetVar("tfa_special_model", "")
    ply:SetNetVar("tfa_slot_toggle", 0)
    
    net.Start("tfa_backweapons_clear")
    net.Send(ply)
    
    return true
end

local function ForceWeaponOnBack(ply, weaponClass)
    local weapon = ply:GetWeapon(weaponClass)
    if not IsValid(weapon) then
        ply:ChatPrint("У вас нет этого оружия!")
        return false
    end
    
    if not CanPutOnBack(weapon) then
        ply:ChatPrint("Это оружие нельзя положить на спину!")
        return false
    end
    
    local toggle = ply:GetNetVar("tfa_slot_toggle") or 0
    if toggle == 0 then
        ply:SetNetVar("tfa_c_wpn", weaponClass)
        ply:SetNetVar("tfa_m_wpn", weapon:GetModel())
        ply:SetNetVar("tfa_slot_toggle", 1)
    else
        ply:SetNetVar("tfa_c_wpn2", weaponClass)
        ply:SetNetVar("tfa_m_wpn2", weapon:GetModel())
        ply:SetNetVar("tfa_slot_toggle", 0)
    end
    
    ply:ChatPrint("Оружие " .. weaponClass .. " помещено на спину")
    return true
end

-- Консольные команды
concommand.Add("tfa_back_clear", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    ClearBackWeapons(ply)
    ply:ChatPrint("Оружие со спины убрано")
end)

concommand.Add("tfa_back_put", function(ply, cmd, args)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if #args < 1 then
        ply:ChatPrint("Использование: tfa_back_put <classname>")
        return
    end
    
    ForceWeaponOnBack(ply, args[1])
end)

-- Автоматическая конфигурация при загрузке оружия
hook.Add("WeaponEquip", "TFA_AutoConfigureBackWeapon", function(weapon, ply)
    if not IsValid(weapon) or not IsValid(ply) then return end
    if not string.StartWith(weapon:GetClass(), "tfa_") then return end
    
    -- Автоматически добавляем позиции для нового TFA оружия
    local class = weapon:GetClass()
    if not tableweapons[class] then
        -- Здесь можно добавить автоматическую генерацию позиций
        -- или загрузку из конфигурационного файла
    end
end)

print("[TFA Back Weapons] Система оружия за спиной загружена для TFA Base")]]