AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("mp.ContractBombOpen")

function ENT:Initialize()
    self:SetModel("models/sw/rus/bombs/fab500m46.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(5)
    local physobj = self:GetPhysicsObject()
    if IsValid(physobj) then
        physobj:Wake()
        physobj:EnableMotion(false)
    end
end

function ENT:Think()
end

function ENT:Use(pl)
    --if not self.contract_bomb or not self.contract_player or self.contract_player ~= pl or not ent.contract_code then return end

    net.Start("mp.ContractBombOpen")
    net.Send(pl)
end

net.Receive("mp.ContractBombOpen", function(_, pl)
    local code = net.ReadInt(32)
    local ent = pl:GetEyeTrace().Entity

    if not ent or ent:GetClass() ~= "contract_bomb" or ent:GetPos():Distance(pl:GetPos()) > 100 then
        mp.util.Notify(pl, NOTIFY_ERROR, "Нужно смотреть на бомбу!")
        return
    end

    if not ent.contract_bomb or not ent.contract_player or ent.contract_player ~= pl or not ent.contract_code then
        return
    end

    if code ~= ent.contract_code then
        mp.util.Notify(pl, NOTIFY_ERROR, "Пароль не подходит, прощайте! ))))")

        timer.Adjust("Contract." .. pl:SteamID64() .. "." .. "contract_bomb", 1, 1)

        timer.Simple(2, function()
            local pos = ent:GetPos()

            if IsValid(ent) then
                ent:Remove()
            end

            local bomd = ents.Create("sw_bomb_fab500m46_v3")
            bomd:SetPos(pos)
            bomd:SetAngles(Angle(0, math.random(0, 180), 0))
            bomd:Spawn()
            bomd:Activate()
            bomd.Exploded = true
            bomd.Armed = true
            bomd:Explode(pos)
        end)
        return
    end

    mp.util.Notify(pl, NOTIFY_HINT, "Бомба обезврежена")

    hook.Call("OnDefuseBomb", nil, pl)

    if IsValid(ent) then
        ent:Remove()
    end
end)
