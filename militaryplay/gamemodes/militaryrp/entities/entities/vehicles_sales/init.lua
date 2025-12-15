AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/lockers001a.mdl")

    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHullSizeNormal()
    self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
    self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage(dmginfo)
    return
end

function ENT:AcceptInput(inputName, user)
    local t, f = user:Team(), user:GetNetVar("meta_features")
    if not user:GetAccessTeam()["voditel"] and not user:GetAccessTeam()["pilot"] then
        mp.util.Notify("red", user, "Доступ закрыт!")
        return
    end

    netstream.Start(user, "VehiclesSales_OpenMenu", nil)
end

netstream.Hook("VehiclesSales_ReturnVehicle", function(pPlayer, data)
    local class = data.class
    local Simp = "gmod_sent_vehicle_fphysics_base" -- Simp рили сука

    for k, e in pairs(ents.FindByClass(Simp)) do
        if e == class then
            e:Remove()
        end
    end
end)

netstream.Hook("VehiclesSales_BuyVehicle", function(pPlayer, data)
    local t, f = pPlayer:Team(), pPlayer:GetNetVar("meta_features")

    if not ((t == TEAM_7 or t == TEAM_104) and (f and (f["land"] or f["air"]))) then return end

    local class = data.class
    local vehicle = false

    local trace = pPlayer:GetEyeTrace()
    local target = trace.Entity

    if target:GetClass() ~= "vehicles_sales" then return end

    local features = pPlayer:GetNetVar("meta_features")
    for feature, data in pairs(VEHICLES_FEATURES) do
        for cl, veh in pairs(data) do
            if cl == class then
                if features[feature] then
                    vehicle = veh
                else
                    mp.util.Notify("red", pPlayer, "Вам не доступна эта техника.")
                    return -- break
                end
                break
            end
        end
    end

    if vehicle and pPlayer:PS_GetPoints() >= vehicle.price then
        local tbl = pPlayer:GetNetVar("meta_vehicles")
        tbl[class] = true

        pPlayer:SavePlayerData("vehicles", util.TableToJSON(tbl), false)
        pPlayer:SetNetVar("meta_vehicles", tbl, NETWORK_PROTOCOL_PUBLIC)

        pPlayer:PS_TakePoints(vehicle.price)
    else
        mp.util.Notify("red", pPlayer, "У вас не хватает денег.")
    end
end)

netstream.Hook("VehiclesSales_SpawnVehicle", function(pPlayer, data)
    local vehicle_class = data.class
    local point = data.point

    local anger = Angle(0, 0, 0)

    local veh = simfphys.SpawnVehicleSimple(vehicle_class, point, anger)
    pPlayer:SetNWEntity("Owner", veh)
end)
