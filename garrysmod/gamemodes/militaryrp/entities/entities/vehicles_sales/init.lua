AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local mp = mp

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

function ENT:OnTakeDamage(dmginfo)
    return
end

function ENT:AcceptInput(inputName, user)
    local t, f = user:Team(), user:GetNetVar("meta_features")
    if not user:GetAccessTeam()["voditel"] and not user:GetAccessTeam()["pilot"] then
        mp.util.Notify(user, NOTIFY_ERROR, "Доступ закрыт!")
        return
    end

    netstream.Start(user, "VehiclesSales_OpenMenu", nil)
end

netstream.Hook("VehiclesSales_ReturnVehicle", function(pl, data)
    local veh = pl:GetNWEntity("OwnerVehicle")
    if IsValid(veh) and veh:GetClass() == data.class then
        veh:Remove()
    end
end)

netstream.Hook("VehiclesSales_SpawnVehicle", function(pl, data)
    pl.CDSpawnVehicle = pl.CDSpawnVehicle or 0

    if pl.CDSpawnVehicle > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Ожидайте ещё " .. math.Round(pl.CDSpawnVehicle - CurTime()) .. "сек. !")

        return
    end

    local vehicle_class = data.class
    local pos, ang
    local faction = pl:GetFaction()

    if IsValid(pl:GetNWEntity("OwnerVehicle")) then
        mp.util.Notify(pl, NOTIFY_ERROR, "У вас уже есть техника!")
        return
    end

    if not faction then
        mp.util.Notify(pl, NOTIFY_ERROR, "Вы не состоите в фракции!")
        return
    end

    if not pl:GetAccessTeam()["voditel"] then
        mp.util.Notify(pl, NOTIFY_ERROR, "Доступ запрещен!")

        return
    end

    local has = mp.config.vehicle_info[vehicle_class]

    if not has then
        mp.util.Notify(pl, NOTIFY_ERROR, "Эта техника запрещена!")

        return
    end

    if mp.faction[faction] and mp.faction[faction].spawn_vehicle then
        for k, v in ipairs(mp.faction[faction].spawn_vehicle) do
            local has = false

            local all = ents.FindInSphere(v.pos, 100)
            for i = 1, #all do
                if all[1] then
                    has = true
                    break
                end
            end

            if has then
                continue
            else
                pos, ang = v.pos, v.ang
                break
            end
        end
    end

    if not pos then
        mp.util.Notify(pl, NOTIFY_ERROR, "Освободите область для вызова техники!")
        return
    end

    local ent = ents.Create(vehicle_class)

    pos.z = pos.z + ent.SpawnNormalOffset

    ent:CPPISetOwner(pl)
    ent:StoreCPPI(pl)
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:Spawn()
    ent:Activate()

    pl:SetNWEntity("OwnerVehicle", ent)

    undo.Create("SENT")
    undo.SetPlayer(pl)
    undo.AddEntity(ent)
    if (vehicle_class) then
        undo.SetCustomUndoText("Undone " .. vehicle_class)
    end
    undo.Finish("Scripted Entity (" .. tostring(vehicle_class) .. ")")

    pl:AddCleanup("sents", ent)

    pl.CDSpawnVehicle = CurTime() + mp.config.spawn_vehicle
end)
