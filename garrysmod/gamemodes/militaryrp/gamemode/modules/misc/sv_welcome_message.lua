local Color = Color
--[[hook.Add("PlayerDataLoaded", "rp.PlayerDataLoaded.WelcomeMessage", function(ply, data)
    if data.last_seen and data.last_seen ~= 0 then
        rp.chat.send_message_all(Color(80,251,80),"● ", Color(255,255,255), data.name .." зашел на сервер! (Последний раз заходил " .. os.date( "%d.%m.%Y - %H:%M" , data.last_seen ) .. ")")
    else
        rp.chat.send_message_all(Color(80,251,80),"● ", Color(255,255,255), data.name .." зашел на сервер впервые!")
    end
end)]]