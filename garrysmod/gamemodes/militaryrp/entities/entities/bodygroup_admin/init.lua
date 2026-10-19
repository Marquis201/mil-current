AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString('bodygroup')

local file = file

--if not file.Exists("save_body/bodygroup.json", "DATA") then
--file.Write("save_body/bodygroup.jso", util.TableToJSON(data))
--end

file.CreateDir("save_body")


function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(5)
    local phys = self:GetPhysicsObject()
    if not phys:IsValid() then
        self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        phys = self:GetPhysicsObject()
    end
    phys:Wake()
end

function ENT:Think()
end

function ENT:Use(p)
    if self:GetNWInt("CD" .. p:AccountID()) > CurTime() then return end
    p:SetNWEntity('BG', self)
    net.Start('bodygroup')
    net.Send(p)
    self:SetNWInt("CD" .. p:AccountID(), CurTime() + .5)
end

net.Receivers.bodygroup = function(_, pl)
    pl.NextBodyGroup = pl.NextBodyGroup or 0
    if pl.NextBodyGroup > CurTime() then return end

    pl.NextBodyGroup = CurTime() + 1

    local bit = net.ReadBit() == 0
    local id = net.ReadUInt(7)

    local t = pl:GetSaveBodygroup()
    local mdl = pl:GetModel()

    t[mdl] = t[mdl] or {}
    id = tostring(id)

    if bit then
        local typ = net.ReadUInt(7)
        local ent = pl:GetNWEntity("BG")
        if ! IsValid(ent) then return end
        if ent:GetClass() ~= 'bodygroup' then return end
        if pl:GetPos():DistToSqr(ent:GetPos()) > 23000 then return end

        typ = tostring(typ)

        t[mdl].bodygroup = t[mdl].bodygroup or {}
        t[mdl].bodygroup[id] = typ

        pl:SetBodygroup(id, typ)
        pl:UpdateSaveBodygroup(t)
    else
        t[mdl].skin = id

        pl:SetSkin(id)
        pl:UpdateSaveBodygroup(t)
    end
end

hook.Add("PlayerInitialSpawn", "mp.PlayerInitialSpawn.Body", function(pl)
    timer.Simple(.1, function()
        if IsValid(pl) then
            if not file.Exists("save_body/" .. pl:SteamID64() .. ".json", "DATA") then
                file.Write("save_body/" .. pl:SteamID64() .. ".json", "")

                pl:SetNetVar("save_bodygroup", {})
            else
                local t = file.Read("save_body/" .. pl:SteamID64() .. ".json", "DATA")

                t = util.JSONToTable(t, true, true)

                pl:SetNetVar("save_bodygroup", t)
            end
        end
    end)
end)
