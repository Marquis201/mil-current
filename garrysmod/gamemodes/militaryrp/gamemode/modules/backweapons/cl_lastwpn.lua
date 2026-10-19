--[[local localPlayer
local tableweapons = setmetatable({}, {__call = function(s,a,...)s[a] = {...}end})

-- RPG и гранатометы (если есть в TFA)
tableweapons('tfa_rpg7', "ValveBiped.Bip01_Spine1", Vector(1.5, 14, 7.5),  Angle(-90, 100, 0))
tableweapons('tfa_m79', "ValveBiped.Bip01_Spine1", Vector(0.7, -5, 8), Angle(0, -85, -5))
tableweapons('tfa_m32', "ValveBiped.Bip01_Spine1", Vector(1.5, 14, 6.5), Angle(-90, 100, 0))

-- Snipers
tableweapons('tfa_awp',  "ValveBiped.Bip01_Spine1", Vector(2.25, 14, -7),  Angle(0, 280, 0))
tableweapons('tfa_barrett',  "ValveBiped.Bip01_Spine1", Vector(1.75, 17, -7),  Angle(0, 280, 0))
tableweapons('tfa_kar98',   "ValveBiped.Bip01_Spine1", Vector(1.75, 16, -7),  Angle(0, 280, 0))
tableweapons('tfa_m24',   "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_m40a5',   "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_m82',  "ValveBiped.Bip01_Spine1", Vector(1.75, 17, -7),  Angle(0, 280, 0))
tableweapons('tfa_rem700',   "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_svd',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_sv98',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))

-- Assault Rifles
tableweapons('tfa_ak47',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_ak74',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_aks74u',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_ar15',  "ValveBiped.Bip01_Spine1", Vector(2.25, 13, -7),  Angle(0, 280, 0))
tableweapons('tfa_m4a1',  "ValveBiped.Bip01_Spine1", Vector(2.25, 13, -7),  Angle(0, 280, 0))
tableweapons('tfa_m16a4',  "ValveBiped.Bip01_Spine1", Vector(2.25, 13, -7),  Angle(0, 280, 0))
tableweapons('tfa_scar',  "ValveBiped.Bip01_Spine1", Vector(2.5, 12, -7),  Angle(0, 280, 0))
tableweapons('tfa_scarl',  "ValveBiped.Bip01_Spine1", Vector(2.5, 12, -7),  Angle(0, 280, 0))
tableweapons('tfa_scarh',  "ValveBiped.Bip01_Spine1", Vector(2.5, 12, -7),  Angle(0, 280, 0))
tableweapons('tfa_g36c',  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_hk416',  "ValveBiped.Bip01_Spine1", Vector(2.8, 13, -7),  Angle(0, 280, 0))
tableweapons('tfa_famas',  "ValveBiped.Bip01_Spine1", Vector(3, 10, -7), Angle(0, 280, 0))
tableweapons('tfa_aug',  "ValveBiped.Bip01_Spine1", Vector(2, 11, -7),  Angle(0, 280, 0))
tableweapons('tfa_galil',  "ValveBiped.Bip01_Spine1", Vector(1.75, 14, -6.25),  Angle(0, 280, 0), Vector(1.75, 14, 6),  Angle(180, 280, 0))

-- SMGs
tableweapons('tfa_mp5',  "ValveBiped.Bip01_Spine1", Vector(2, 14, -7),  Angle(0, 280, 0))
tableweapons('tfa_mp5k',  "ValveBiped.Bip01_Spine1", Vector(2, 14, -7),  Angle(0, 280, 0))
tableweapons('tfa_mp7',  "ValveBiped.Bip01_Spine1", Vector(2, 12, -6.25),  Angle(0, 280, 0), Vector(2, 12, 6),  Angle(180, 280, 0))
tableweapons('tfa_ump45',  "ValveBiped.Bip01_Spine1", Vector(2.5, 13, -7),  Angle(0, 280, 0))
tableweapons('tfa_vector',  "ValveBiped.Bip01_Spine1", Vector(2, 12, -6.25),  Angle(0, 280, 0), Vector(2, 12, 6),  Angle(180, 280, 0))
tableweapons('tfa_pp2000',  "ValveBiped.Bip01_Spine1", Vector(2, 12, -6.25),  Angle(0, 280, 0), Vector(2, 12, 6),  Angle(180, 280, 0))
tableweapons('tfa_ppsh41',  "ValveBiped.Bip01_Spine1", Vector(1.75, 16, -7),  Angle(0, 280, 0))
tableweapons('tfa_bizon',  "ValveBiped.Bip01_Spine1", Vector(1.75, 14, -7),  Angle(0, 280, 0))

-- LMGs
tableweapons('tfa_m249',  "ValveBiped.Bip01_Spine1", Vector(2.5, 12, -7),  Angle(0, 280, 0))
tableweapons('tfa_rpk',  "ValveBiped.Bip01_Spine1", Vector(2, 14, -7),  Angle(0, 280, 0))
tableweapons('tfa_pkm',  "ValveBiped.Bip01_Spine1", Vector(2, 13, -7),  Angle(0, 280, 0))
tableweapons('tfa_m60',  "ValveBiped.Bip01_Spine1", Vector(2, 13, -7),  Angle(0, 280, 0))

-- Shotguns
tableweapons('tfa_m3super90',  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_m1014',  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_rem870',  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_spas12',  "ValveBiped.Bip01_Spine1", Vector(1.5, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_saiga12',  "ValveBiped.Bip01_Spine1", Vector(1.75, 10, -5.25),  Angle(0, 280, 0), Vector(1.75, 10, 5),  Angle(180, 280, 0))
tableweapons('tfa_toz34',  "ValveBiped.Bip01_Spine1", Vector(2, 15, -6.25),  Angle(0, 280, 0), Vector(2, 15, 6),  Angle(180, 280, 0))

-- Двуствольное оружие
tableweapons('tfa_doublebarrel',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_winchester',  "ValveBiped.Bip01_Spine1", Vector(1.75, 16, -7),  Angle(0, 280, 0))

-- Специальные TFA оружия
tableweapons('tfa_an94',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_asval',  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons('tfa_vss',  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))

-- Добавьте здесь другие TFA оружия по аналогии

local MAX_DISTANCE = 2500 * 1000
local cache_models = {}

local function CreateModel(p, model, modelKey)
    if not IsValid(p) then return end
    
    if p[modelKey] and IsValid(p[modelKey]) and p[modelKey]:GetModel() ~= model then
        p[modelKey]:Remove()
        p[modelKey] = nil
    end
    
    if not p[modelKey] or not IsValid(p[modelKey]) then
        if not cache_models[model] then
            cache_models[model] = ClientsideModel(model)
            if IsValid(cache_models[model]) then
                cache_models[model]:SetNoDraw(true)
            end
        end
        p[modelKey] = cache_models[model]
    end
end

local function DrawWeaponOnBack(p, weaponClass, modelKey, isSecondSlot)
    local weaponData = tableweapons[weaponClass]
    if not weaponData then return false end
    
    -- Получаем информацию о TFA оружии
    local weaponTable = weapons.GetStored(weaponClass)
    if not weaponTable then return false end
    
    local model = weaponTable.WorldModel or weaponTable.ViewModel
    if not model then return false end
    
    CreateModel(p, model, modelKey)
    
    local boneName = weaponData[1]
    local posOffset = weaponData[2]
    local angOffset = weaponData[3]
    
    -- Для второго слота используем зеркальные координаты если заданы
    local secondPos, secondAng
    if isSecondSlot and weaponData[4] and weaponData[5] then
        secondPos = weaponData[4]
        secondAng = weaponData[5]
    end
    
    local boneIndex = p:LookupBone(boneName)
    if not boneIndex or boneIndex <= 0 then return false end
    
    local boneMatrix = p:GetBoneMatrix(boneIndex)
    if not boneMatrix then return false end
    
    local bonePos = boneMatrix:GetTranslation()
    local boneAng = boneMatrix:GetAngles()
    
    if not p[modelKey] or not IsValid(p[modelKey]) then return false end
    
    local Right = boneAng:Right()
    local Up = boneAng:Up()
    local Forward = boneAng:Forward()
    
    -- Применяем смещение для второго слота если есть
    local finalPos = posOffset
    local finalAng = angOffset
    if isSecondSlot and secondPos and secondAng then
        finalPos = secondPos
        finalAng = secondAng
    end
    
    boneAng:RotateAroundAxis(Right, finalAng[1])
    boneAng:RotateAroundAxis(Up, finalAng[2])
    boneAng:RotateAroundAxis(Forward, finalAng[3])
    
    bonePos = bonePos + finalPos[1] * Right
    bonePos = bonePos + finalPos[2] * Forward
    bonePos = bonePos + finalPos[3] * Up
    
    p[modelKey]:SetRenderOrigin(bonePos)
    p[modelKey]:SetRenderAngles(boneAng)
    p[modelKey]:DrawModel()
    
    -- Настройка bodygroups для TFA
    if p[modelKey].TFABodyGroups then
        for _, bg in ipairs(p[modelKey].TFABodyGroups) do
            p[modelKey]:SetBodygroup(bg.index, bg.value)
        end
    end
    
    return true
end

-- Функция для отрисовки пси-шлема (если нужно в TFA)
local psyHelmet = ClientsideModel('models/psihelem.mdl')
psyHelmet:SetNoDraw(true)

hook.Add("PostPlayerDraw", "TFA_BackWeapons", function(p)
    if not IsValid(p) or not p:Alive() then return end
    
    localPlayer = localPlayer or LocalPlayer()
    if not IsValid(localPlayer) then return end
    
    if localPlayer:GetPos():DistToSqr(p:GetPos()) > MAX_DISTANCE then return end
    
    -- Отрисовка пси-шлема (если есть в вашем модификации)
    if p:GetNetVar("AntiBrain") == true then
        local headBone = p:LookupBone('ValveBiped.Bip01_Head1')
        if headBone and headBone > 0 then
            local boneMatrix = p:GetBoneMatrix(headBone)
            if boneMatrix then
                local pos = boneMatrix:GetTranslation()
                local ang = boneMatrix:GetAngles()
                
                psyHelmet:SetModelScale(1.1, 0)
                ang:RotateAroundAxis(ang:Up(), 0)
                ang:RotateAroundAxis(ang:Forward(), -90)
                ang:RotateAroundAxis(ang:Right(), -90)
                pos = pos + (ang:Forward() * -1) + ang:Up() * -1 + ang:Right() * 1.5
                
                psyHelmet:SetRenderOrigin(pos)
                psyHelmet:SetRenderAngles(ang)
                psyHelmet:DrawModel()
            end
        end
    end
    
    -- Проверяем настройку отображения
    if GetConVar("tfa_backweapons_enabled"):GetInt() == 0 then return end
    
    -- Получаем данные об оружии на спине
    local c_wpn = p:GetNetVar("tfa_c_wpn")
    local m_wpn = p:GetNetVar("tfa_m_wpn")
    local c_wpn2 = p:GetNetVar("tfa_c_wpn2")
    local m_wpn2 = p:GetNetVar("tfa_m_wpn2")
    
    local activeWeapon = p:GetActiveWeapon()
    local activeClass = IsValid(activeWeapon) and activeWeapon:GetClass() or ""
    
    -- Проверяем находится ли игрок в LastStand (адаптируйте под вашу систему)
    local isInLastStand = false
    -- if YourLastStandSystem and YourLastStandSystem.IsPlayerInLastStand then
    --     isInLastStand = YourLastStandSystem.IsPlayerInLastStand(p)
    -- end
    
    -- Функция проверки наличия оружия с учетом LastStand
    local function HasWeaponCheck(ply, weaponClass)
        if isInLastStand then
            return ply:HasWeapon(weaponClass) or (c_wpn == weaponClass) or (c_wpn2 == weaponClass)
        else
            return ply:HasWeapon(weaponClass)
        end
    end
    
    -- Отрисовка первого оружия
    if c_wpn and m_wpn and tableweapons[c_wpn] and HasWeaponCheck(p, c_wpn) and activeClass ~= c_wpn then
        if not p.mdl or not IsValid(p.mdl) then
            p.mdl = ClientsideModel(m_wpn)
            if IsValid(p.mdl) then
                p.mdl:SetNoDraw(true)
            end
        end
        
        if IsValid(p.mdl) and p.mdl:GetModel() ~= m_wpn then
            p.mdl:SetModel(m_wpn)
        end
        
        DrawWeaponOnBack(p, c_wpn, "mdl", false)
    end
    
    -- Отрисовка второго оружия
    if c_wpn2 and m_wpn2 and tableweapons[c_wpn2] and HasWeaponCheck(p, c_wpn2) and activeClass ~= c_wpn2 then
        if not p.mdl2 or not IsValid(p.mdl2) then
            p.mdl2 = ClientsideModel(m_wpn2)
            if IsValid(p.mdl2) then
                p.mdl2:SetNoDraw(true)
            end
        end
        
        if IsValid(p.mdl2) and p.mdl2:GetModel() ~= m_wpn2 then
            p.mdl2:SetModel(m_wpn2)
        end
        
        DrawWeaponOnBack(p, c_wpn2, "mdl2", true)
    end
    
    -- Отрисовка RPG/M79 (если есть)
    if activeClass == "tfa_rpg7" and HasWeaponCheck(p, "tfa_m79") then
        DrawWeaponOnBack(p, "tfa_m79", "mdl_rpg", false)
    elseif activeClass == "tfa_m79" and HasWeaponCheck(p, "tfa_rpg7") then
        DrawWeaponOnBack(p, "tfa_rpg7", "mdl_rpg", false)
    elseif activeClass ~= "tfa_rpg7" and HasWeaponCheck(p, "tfa_rpg7") then
        DrawWeaponOnBack(p, "tfa_rpg7", "mdl_rpg", false)
    elseif activeClass ~= "tfa_m79" and HasWeaponCheck(p, "tfa_m79") then
        DrawWeaponOnBack(p, "tfa_m79", "mdl_rpg", false)
    end
end)

-- Очистка при удалении игрока
hook.Add("PlayerDisconnected", "TFA_CleanupModels", function(ply)
    if ply.mdl and IsValid(ply.mdl) then ply.mdl:Remove() end
    if ply.mdl2 and IsValid(ply.mdl2) then ply.mdl2:Remove() end
    if ply.mdl_rpg and IsValid(ply.mdl_rpg) then ply.mdl_rpg:Remove() end
end)

-- Консольная команда для перезагрузки позиций
concommand.Add("tfa_backweapons_reload", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    print("[TFA Back Weapons] Конфигурация перезагружена")
    -- Здесь можно добавить загрузку из файла
end)

-- Создание ConVar
CreateClientConVar("tfa_backweapons_enabled", "1", true, false, "Включить отображение оружия за спиной")]]