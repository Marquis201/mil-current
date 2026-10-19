local NW = { "SetTeam", "SetUserGroup", "SendPromo" }

local mp = mp
local net = net
local hook = hook

for k, v in ipairs(NW) do
    util.AddNetworkString("mp.donate." .. v)
end

net.Receive("mp.donate.SetTeam", function(_, pl)
    local uid = net.ReadString()

    if not pl:HasPurchase(uid) then
        mp.util.Notify(pl, NOTIFY_ERROR, "Купите или активируйте предмет подразделения в F6!")
        return
    end

    local ITEM = IGS.GetItemByUID(uid)

    if not ITEM then
        mp.util.Notify(pl, NOTIFY_ERROR, "Предмет не найден!")

        return
    end

    if ITEM.category ~= "Подразделения" then
        mp.util.Notify(pl, NOTIFY_ERROR, "Выберите подразделение!")

        return
    end

    if mp.jobs[pl:Team()].jobid == uid then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подразделения уже выбрано!")

        return
    end

    if not mp.jobs_by_id[uid] then
        mp.util.Notify(pl, NOTIFY_ERROR, "Подразделения не найдено!")

        return
    end

    hook.Call("PlayerChangeTeam", nil, pl, mp.jobs_by_id[uid].index, true)
    mp.util.Notify(pl, NOTIFY_GENERIC, "Подразделения выбрано!")
end)

net.Receive("mp.donate.SetUserGroup", function(_, pl)
    local uid = net.ReadString()

    if not pl:HasPurchase(uid) then
        mp.util.Notify(pl, NOTIFY_ERROR, "Купите или активируйте предмет привилегии в F6!")
        return
    end

    local ITEM = IGS.GetItemByUID(uid)

    if not ITEM then
        mp.util.Notify(pl, NOTIFY_ERROR, "Предмет не найден!")

        return
    end

    if ITEM.category ~= "Привилегии" then
        mp.util.Notify(pl, NOTIFY_ERROR, "Выберите привилегию!")

        return
    end

    if mp.jobs[pl:Team()].jobid == uid then
        mp.util.Notify(pl, NOTIFY_ERROR, "Привилегия уже выбрано!")

        return
    end

    if not mp.jobs_by_id[uid] then
        mp.util.Notify(pl, NOTIFY_ERROR, "Привилегия не найдена!")

        return
    end

    mp.util.Notify(pl, NOTIFY_GENERIC, "Привилегия выбрана!")
end)

local function UpdatePromo(steamid, promo, activate, cback)
    local db = mysql.connect_config
    db:Query("UPDATE player_promocode SET activate=? WHERE steamid=? AND code = ?;", activate, promo, tostring(steamid),
        cback)
end

local function activatePromo(promo, pl)
    local t = mp.promocode[promo]
    if not t then return end

    local db = mysql.connect_config
    local steamid = pl:SteamID64()

    db:Query("SELECT * FROM player_promocode WHERE steamid = ?;", steamid, function(data)
        if data[1] then
            local activate = tonumber(data[1].activate or 0)

            if t.limit and activate >= t.limit then
                mp.util.Notify(pl, NOTIFY_ERROR, "Вы активировали промокод максимальное количество раз!")

                return
            end

            if t.add then
                t.add(pl)
            end

            UpdatePromo(steamid, promo, activate)

            mp.util.Notify(pl, NOTIFY_GENERIC, "Вы активировали промокод: " .. t.name)
        else
            db:Query("INSERT INTO player_promocode(steamid, code, activate) VALUES(?, ?, ?);", steamid, promo, 1)

            if t.add then
                t.add(pl)
            end

            mp.util.Notify(pl, NOTIFY_GENERIC, "Вы активировали промокод: " .. t.name)
        end
    end)
end

hook.Add("PlayerSay", "mp.PromoCode", function(pl, strMsg)
    strMsg = string.Explode(" ", strMsg)

    for k, v in pairs(mp.promocode) do
        if v.check and not v.check(pl) then continue end
        if "/" .. k == strMsg[1] then
            activatePromo(k, pl)
            return ""
        end
    end
end)

net.Receive("mp.donate.SendPromo", function(_, pl)
    local uid = net.ReadString()

    pl.NextActivatePromo = pl.NextActivatePromo or 0

    if pl.NextActivatePromo > CurTime() then return end

    pl.NextActivatePromo = CurTime() + 1

    if not mp.promocode[uid] then
        mp.util.Notify(pl, NOTIFY_ERROR, "Промокод не найден!")

        return
    end

    activatePromo(uid, pl)
end)

hook.Add("InitPostEntity", "mp.CreatePromoData", function()
    local db = mysql.connect_config
    db:Query(
        "CREATE TABLE IF NOT EXISTS player_promocode (steamid BIGINT(20) PRIMARY KEY, code VARCHAR(60), activate INT);")
end)

hook.Add("IGS.CanPlayerBuyItem", "igs.mp.CanPurchase", function(pl, ITEM)
    --return false, "Донат временно неработает!" -- ОТКЛЮЧЕНИЕ ПОКУПОК ДОНАТА
end)
