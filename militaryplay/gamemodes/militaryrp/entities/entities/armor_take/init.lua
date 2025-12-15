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

function ENT:AcceptInput(inputName, pPlayer)
    if ((self.nextUse or 0) >= CurTime()) then
        return
    end

    if not mp.profession[pPlayer:GetNetVar("meta_features")] then
        mp.util.Notify("red", pPlayer, "Доступ закрыт!")
        return
    end

    self.nextUse = CurTime() + 1

    netstream.Start(pPlayer, "Weapons_OpenMenu", nil)
end

netstream.Hook("Weapons_Spawn", function(pPlayer, data)
    local weapon_class = data.class

    pPlayer:Give(weapon_class)
end)

netstream.Hook("Weapons_Return", function(pPlayer, data)
    local weapon_class = data.class
    local Pammp = pPlayer:GetWeapon(weapon_class):GetPrimaryAmmoType()
    local Sammp = pPlayer:GetWeapon(weapon_class):GetSecondaryAmmoType()
    local GetPammo = pPlayer:GetAmmoCount(Pammp)
    local GetSammo = pPlayer:GetAmmoCount(Sammp)

    pPlayer:RemoveAmmo(GetPammo, Pammp)
    pPlayer:RemoveAmmo(GetSammo, Sammp)

    pPlayer:StripWeapon(weapon_class)
end)
