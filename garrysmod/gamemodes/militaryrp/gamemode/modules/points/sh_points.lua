local Vector = Vector
local net = net
local hook = hook
local mp = mp
local nw = nw
local PLAYER = PLAYER

mp.Points = mp.Points or {}

function mp.Points:GetNATOPoints()
    return mp.Points:GetFactionPoints()["nato"] and mp.Points:GetFactionPoints()["nato"] or 0
end

function mp.Points:GetRFPoints()
    return mp.Points:GetFactionPoints()["rf"] and mp.Points:GetFactionPoints()["rf"] or 0
end

function mp.Points:GetFactionPoints()
    return nw.GetGlobal("FactionPoints") or {}
end

function mp.Points:CanAffordFactionPoints(name, amount)
    local money = mp.Points:GetFactionPoints()[name] or 0

    return money >= amount and true or false
end

function PLAYER:GetPoints()
    return self:GetNetVar("Points") or 0
end

function PLAYER:CanAffordPoints(amount)
    return self:GetPoints() >= amount and true or false
end

function mp.FormatMoney(num)
    return "€" .. string.Comma(num, ".")
end

nw.Register "Points":Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetPlayer()
nw.Register "FactionPoints"
    :Write(function(t)
        for k, v in pairs(t) do
            net.WriteString(k)
            net.WriteUInt(v, 32)
        end
    end)
    :Read(function()
        local t = {}
        local count = table.Count(mp.faction)
        for i = 1, count do
            t[net.ReadString()] = net.ReadUInt(32)
        end
    end)
    :SetGlobal()
