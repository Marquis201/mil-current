AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString('bodygroup')

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

net.Receivers.bodygroup = function(_,p)
    local bit = net.ReadBit() == 0
    local id = net.ReadUInt(7)
    if bit then
        local typ = net.ReadUInt(7)
        local ent = p:GetNWEntity("BG")
        if !IsValid(ent) then return end
        if ent:GetClass() ~= 'bodygroup' then return end
        if p:GetPos():DistToSqr(ent:GetPos()) > 23000 then return end

        p:SetBodygroup(id,typ)
    else
        p:SetSkin(id)
    end
end