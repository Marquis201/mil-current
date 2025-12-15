local PLAYER = PLAYER
local mp = mp
local GAMEMODE = GAMEMODE
local hook = hook

util.AddNetworkString("mp.ArrestMenu")

function PLAYER:Arrest(time, reason, actor)
    if not self:GetNetVar("Arrested") then
        time = math.Clamp(time or mp.config.arrest.time.min, mp.config.arrest.time.min, mp.config.arrest.time.max)

        self:StripWeapons()
        self:StripAmmo()

        local t = {
            time = CurTime() + time,
            reason = reason or "Причина не указана",
            actor = actor
        }

        self:SetNetVar("Arrested", t)

        local spawn, pos = hook.Call("PlayerSelectSpawn", GAMEMODE, self)
        hook.Call("PlayerArrestPlayer", GAMEMODE, self)

        self:SetPos(pos)

        timer.Create("Arrested_" .. self:SteamID64(), time, 1, function()
            if IsValid(self) then
                self:UnArrest()
            end
        end)
    end
end

function PLAYER:UnArrest(actor)
    self:SetNetVar("Arrested", nil)
    self:Spawn()
    hook.Call("PlayerLoadout", GAMEMODE, self)
    hook.Call("PlayerUnArrested", GAMEMODE, self)
    timer.Remove("Arrested_" .. self:SteamID64())
end

net.Receive("mp.ArrestMenu", function(_, pl)
    local wep = pl:GetActiveWeapon()

    if not IsValid(wep) or wep:GetClass() ~= "arrest_baton" then return end

    local reason = net.ReadString()
    local time = net.ReadUInt(32)
    local target = net.ReadEntity()

    if not IsValid(target) then return end
    if target:IsArrested() then return end
    if target:GetPos():Distance(pl:GetPos()) > 500 then return end
    if pl:GetFaction() and target:GetFaction() and target:GetFaction() ~= pl:GetFaction() and pl:IsAdmin() then
        mp.util.Notify("red", pl, "Нельзя арестовывать игроков из чужой стороны!")

        return
    end

    local len = utf8.len(reason)

    if len > mp.config.arrest.reason.max then
        mp.util.Notify("red", pl, "Максимальная длина причина " .. mp.config.arrest.reason.max .. " символов!")
        return
    elseif len < mp.config.arrest.reason.min then
        mp.util.Notify("red", pl, "Минимальная длина причина " .. mp.config.arrest.reason.min .. " символов!")
        return
    end

    target:Arrest(time, reason, pl)
end)
