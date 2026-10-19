local mp = mp

util.AddNetworkString("mp.perks.Active")

local function hasPerk(pl)
    local features = pl:GetNetVar("meta_features")
    if not features or not mp.profession[features] or not mp.profession[features].perk then return false end

    return mp.profession[features].perk
end

local function activePerk(pl)
    if pl.sg_jail or not pl:Alive() then return end

    local id = hasPerk(pl)

    if not id or not mp.perks.list[id] then return end
    local data = mp.perks.list[id]

    if not data then return end

    local perk = pl:GetNetVar("mp.Perks") or {}
    local cd = CurTime()

    if perk.delay and perk.delay > cd then
        return
    end

    local duration = data.duration and (cd + data.duration) or 0

    local t = {
        id = id,
        delay = cd + data.delay + (data.duration or 0),
        duration = duration
    }

    local has = true
    if data.active then
        has = data.active(pl)
    end

    if not has then return end

    pl:SetNetVar("mp.Perks", t)

    mp.util.Notify(pl, NOTIFY_HINT, "Вы активировали перк: " .. data.name)
end

net.Receive("mp.perks.Active", function(_, pl)
    pl.NextActivePerk = pl.NextActivePerk or 0
    if pl.NextActivePerk > CurTime() then return end

    pl.NextActivePerk = CurTime() + 2

    activePerk(pl)
end)

hook.Add("PlayerSpawn", "mp.perks.Spawn", function(pl)
    local perk = hasPerk(pl)
    if not perk or pl.sg_jail then
        pl:SetNetVar("mp.Perks", nil)
        return
    end

    local data = mp.perks.list[perk]

    if not data then return end

    local timer = data.delay + CurTime()

    if pl:IsRoot() then
        timer = 0
    end

    pl:SetNetVar("mp.Perks", {
        id = perk,
        delay = timer,
        duration = 0
    })
end)

hook.Add("PlayerButtonDown", "mp.perks.Active", function(pl, button)
    if button == KEY_F4 then
        pl.NextActivePerk = pl.NextActivePerk or 0
        if pl.NextActivePerk > CurTime() then return end

        pl.NextActivePerk = CurTime() + 2

        activePerk(pl)
    end
end)
