AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/lockers001a.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)
    self.ProtalVector = false

    -- Wake the physics object up
    local phys = self.Entity:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:EnableMotion(false)
        phys:Wake()
    end
end

function ENT:AcceptInput(inputName, pl)
    pl.NextMenuWeapon = pl.NextMenuWeapon or 0
    if pl.NextMenuWeapon > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подождите " .. math.Round(pl.NextMenuWeapon - CurTime()) .. " сек.")
        return
    end

    pl.NextMenuWeapon = CurTime() + 1

    --if not mp.profession[pl:GetNetVar("meta_features")] then
    --    mp.util.Notify("red", pl, "Доступ закрыт!")
    --    return
    --end

    netstream.Start(pl, "Weapons_OpenMenu", nil)
end

local mp = mp
netstream.Hook("Weapons_ArmorTake", function(pl, data)
    local has = false
    local spec = pl:GetNetVar("meta_features")
    local next_armor = pl:GetNetVar("NextArmorTake") or 0

    if next_armor > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Ожидайте ещё: " .. math.Round(next_armor - CurTime()) .. " сек.")
        return
    end

    if spec and mp.profession[spec] and mp.profession[spec].add_stats then
        local stats = mp.profession[spec].add_stats

        if stats.health then
            pl:SetHealth(stats.health)
            pl:SetMaxHealth(stats.health)
        end

        if stats.armor then
            pl:SetMaxArmor(stats.armor)
            pl:SetArmor(stats.armor)
        end

        pl:SetNetVar("NextArmorTake", CurTime() + 120)
    end
end)

netstream.Hook("Weapons_Spawn", function(pl, data)
    pl.NextGiveWeapon = pl.NextGiveWeapon or 0
    if pl.NextGiveWeapon > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подождите " .. math.Round(pl.NextGiveWeapon - CurTime()) .. " сек.")
        return
    end

    pl.NextGiveWeapon = CurTime() + 2

    local weapon_class = data.class

    local has = false
    local PlyFeatures = pl:GetNetVar("meta_features")
    local WP

    if mp.profession[PlyFeatures] then
        for k, v in ipairs(mp.profession[PlyFeatures].weapons) do
            if v == weapon_class then
                has = true
                break
            end
        end
    end

    if pl:HasAccessTeam("milpolice") then
        for k, v in ipairs(mp.config.access_list["milpolice"].armor_take) do
            if v == weapon_class then
                has = true
                break
            end
        end
    end

    for k, v in ipairs(IGS.GetItems()) do
        if not v:GetMeta("weapons") or v:GetMeta("weapons") ~= weapon_class then continue end

        if pl:HasPurchase(v.uid) then
            has = true
            break
        end
    end

    if not has then return end

    pl:Give(weapon_class)

    hook.Call("OnPlayerWeapon", nil, pl)
end)

netstream.Hook("Weapons_SpawnAll", function(pl)
    pl.NextGiveWeapon = pl.NextGiveWeapon or 0
    if pl.NextGiveWeapon > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подождите " .. math.Round(pl.NextGiveWeapon - CurTime()) .. " сек.")
        return
    end

    pl.NextGiveWeapon = CurTime() + 3

    local PlyFeatures = pl:GetNetVar("meta_features")
    local WP = {}

    if mp.profession[PlyFeatures] then
        for k, v in ipairs(mp.profession[PlyFeatures].weapons) do
            WP[#WP + 1] = v
        end
    end

    if pl:HasAccessTeam("milpolice") then
        for k, v in ipairs(mp.config.access_list["milpolice"].armor_take) do
            WP[#WP + 1] = v
        end
    end

    for k, v in ipairs(IGS.GetItems()) do
        if not v:GetMeta("weapons") then continue end

        if pl:HasPurchase(v.uid) then
            WP[#WP + 1] = v:GetMeta("weapons")
        end
    end

    if not WP or #WP <= 0 then return end

    for k, v in ipairs(WP) do
        if not pl:HasWeapon(v) then
            pl:Give(v)
        end
    end

    hook.Call("OnPlayerWeapon", nil, pl)
end)

netstream.Hook("Weapons_ReturnAll", function(pl)
    pl.NextGiveWeapon = pl.NextGiveWeapon or 0
    if pl.NextGiveWeapon > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подождите " .. math.Round(pl.NextGiveWeapon - CurTime()) .. " сек.")
        return
    end

    pl.NextGiveWeapon = CurTime() + 2

    local PlyFeatures = pl:GetNetVar("meta_features")
    local WP = {}

    if mp.profession[PlyFeatures] then
        for k, v in ipairs(mp.profession[PlyFeatures].weapons) do
            WP[#WP + 1] = v
        end
    end

    if pl:HasAccessTeam("milpolice") then
        for k, v in ipairs(mp.config.access_list["milpolice"].armor_take) do
            WP[#WP + 1] = v
        end
    end

    for k, v in ipairs(IGS.GetItems()) do
        if not v:GetMeta("weapons") then continue end

        if pl:HasPurchase(v.uid) then
            WP[#WP + 1] = v:GetMeta("weapons")
        end
    end

    if not WP or #WP <= 0 then return end

    for k, v in ipairs(WP) do
        if pl:HasWeapon(v) then
            local weapon_class = v
            local Pammp = pl:GetWeapon(weapon_class):GetPrimaryAmmoType()
            local Sammp = pl:GetWeapon(weapon_class):GetSecondaryAmmoType()
            local GetPammo = pl:GetAmmoCount(Pammp)
            local GetSammo = pl:GetAmmoCount(Sammp)

            pl:RemoveAmmo(GetPammo, Pammp)
            pl:RemoveAmmo(GetSammo, Sammp)

            pl:StripWeapon(weapon_class)
        end
    end
end)

netstream.Hook("Weapons_Return", function(pl, data)
    pl.NextGiveWeapon = pl.NextGiveWeapon or 0
    if pl.NextGiveWeapon > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подождите " .. math.Round(pl.NextGiveWeapon - CurTime()) .. " сек.")
        return
    end

    pl.NextGiveWeapon = CurTime() + 2

    local weapon_class = data.class
    local Pammp = pl:GetWeapon(weapon_class):GetPrimaryAmmoType()
    local Sammp = pl:GetWeapon(weapon_class):GetSecondaryAmmoType()
    local GetPammo = pl:GetAmmoCount(Pammp)
    local GetSammo = pl:GetAmmoCount(Sammp)

    pl:RemoveAmmo(GetPammo, Pammp)
    pl:RemoveAmmo(GetSammo, Sammp)

    pl:StripWeapon(weapon_class)
end)
