AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("mp.bodygroup_team")

local file = file

file.CreateDir("body_team")
if not file.Exists("body_team/bodygroup_team.json", "DATA") then
    file.Write("body_team/bodygroup_team.json", util.TableToJSON({}))
end

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

function ENT:Use(pl)
    pl.NextBodyGroupMenu = pl.NextBodyGroupMenu or 0
    if pl.NextBodyGroupMenu > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подождите " .. math.Round(pl.NextBodyGroupMenu - CurTime()) .. " сек.")
        return
    end

    pl.NextBodyGroupMenu = CurTime() + 2

    net.Start("mp.bodygroup_team")
    net.Send(pl)
end

net.Receive("mp.bodygroup_team", function(_, pl)
    pl.NextBodyGroup = pl.NextBodyGroup or 0
    if pl.NextBodyGroup > CurTime() then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подождите " .. math.Round(pl.NextBodyGroup - CurTime()) .. " сек.")
        return
    end

    pl.NextBodyGroup = CurTime() + 3

    local rank = pl:GetNetVar("meta_rank")
    local access = false

    if rank and mp.ranks[rank] and mp.ranks[rank].preset then
        access = true
    end

    local type = net.ReadString()

    if type == "AddPreset" and access then
        local t = {
            name = net.ReadString(),
            faction = net.ReadString(),
            model = net.ReadString(),
            skin = net.ReadUInt(8),
            body = {}
        }

        if not t.faction or not pl:GetFaction() or t.faction ~= pl:GetFaction() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Это не доступно!")

            return
        end

        for i = 1, net.ReadUInt(8) do
            t.body[net.ReadUInt(8)] = net.ReadUInt(8)
        end

        local Preset = nw.GetGlobal("mp.BodyPresets") or {}

        table.insert(Preset, 1, t)

        nw.SetGlobal("mp.BodyPresets", Preset)

        file.Write("body_team/bodygroup_team.json", util.TableToJSON(Preset or {}, true))

        mp.util.Notify(pl, NOTIFY_GENERIC, "Пресет создан!")
    elseif type == "ChangePreset" and access then
        local Preset = nw.GetGlobal("mp.BodyPresets") or {}
        local id = net.ReadUInt(8)

        if not Preset[id] then
            mp.util.Notify(pl, NOTIFY_ERROR, "Пресет не найден!")

            return
        end

        if not Preset[id].faction or not pl:GetFaction() or Preset[id].faction ~= pl:GetFaction() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Это не доступно!")

            return
        end

        local t = {
            name = net.ReadString(),
            skin = net.ReadUInt(8),
            body = {}
        }

        for i = 1, net.ReadUInt(8) do
            t.body[net.ReadUInt(8)] = net.ReadUInt(8)
        end

        Preset[id].name = t.name
        Preset[id].skin = t.skin
        Preset[id].body = t.body

        nw.SetGlobal("mp.BodyPresets", Preset)

        file.Write("body_team/bodygroup_team.json", util.TableToJSON(Preset or {}, true))

        mp.util.Notify(pl, NOTIFY_GENERIC, "Пресет изменём!")
    elseif type == "SelectPreset" then
        local Preset = nw.GetGlobal("mp.BodyPresets") or {}
        local id = net.ReadUInt(8)

        if not Preset[id] then
            mp.util.Notify(pl, NOTIFY_ERROR, "Пресет не найден!")

            return
        end

        if not Preset[id].faction or not pl:GetFaction() or Preset[id].faction ~= pl:GetFaction() or Preset[id].model ~= pl:GetModel() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Это не доступно!")

            return
        end

        local t = pl:GetSaveBodygroup()
        local mdl = pl:GetModel()

        t[mdl] = t[mdl] or {}
        t[mdl].skin = Preset[id].skin

        pl:SetSkin(Preset[id].skin)

        t[mdl].bodygroup = t[mdl].bodygroup or {}

        for k, v in pairs(Preset[id].body) do
            t[mdl].bodygroup[k] = v
            pl:SetBodygroup(k, v)
        end

        pl:UpdateSaveBodygroup(t)

        mp.util.Notify(pl, NOTIFY_HINT, "Пресет выбран!")
    elseif type == "DeletePrest" and access then
        local Preset = nw.GetGlobal("mp.BodyPresets") or {}
        local id = net.ReadUInt(8)

        if not Preset[id] then
            mp.util.Notify(pl, NOTIFY_ERROR, "Пресет не найден!")

            return
        end

        if not Preset[id].faction or not pl:GetFaction() or Preset[id].faction ~= pl:GetFaction() then
            mp.util.Notify(pl, NOTIFY_ERROR, "Это не доступно!")

            return
        end

        table.remove(Preset, id)

        nw.SetGlobal("mp.BodyPresets", Preset)

        file.Write("body_team/bodygroup_team.json", util.TableToJSON(Preset or {}, true))

        mp.util.Notify(pl, NOTIFY_GENERIC, "Пресет удалён!")
    end
end)

hook.Add("InitPostEntity", "mp.InitBodyPreset", function()
    local t = file.Read("body_team/bodygroup_team.json", "DATA")

    t = util.JSONToTable(t, true, true)

    nw.SetGlobal("mp.BodyPresets", t or {})
end)