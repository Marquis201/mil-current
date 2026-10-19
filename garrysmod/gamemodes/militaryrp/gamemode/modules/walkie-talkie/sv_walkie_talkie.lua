local mp = mp

local nets = { "mp.SetKickRadio", "mp.DoChanel", "mp.SpeakerToggle", "mp.MicroToggle", "mp.AccessChanel",
    "mp.ChangeChannel", "mp.RadioMenu", "mp.PlaySound" }

for k, v in ipairs(nets) do
    util.AddNetworkString(v)
end

hook.Add("ShowTeam", "mp.Radio", function(pl)
    net.Start("mp.RadioMenu")
    net.WriteBit(true)
    net.Send(pl)
end)

function PLAYER:ChanelRadio(v)
    self:SetNWInt("ChanelRadio", v)
end

function PLAYER:SetRadioOwner(bool)
    self:SetNWBool("OwnerRadio", bool)
end

function PLAYER:SetRadioSpeak(bool)
    self:SetNWBool("SpeakRadio", bool)
end

function PLAYER:SetRadioMicro(bool)
    self:SetNWBool("MicroRadio", bool)
end

local function checkRadioChanel(ply, chanel)
    if ply:GetChanelRadio() == chanel then return end

    local playes = player.GetAll()
    if chanel == 0 then --[[net.Start("mp.DoChanel")
        net.WriteEntity(ply)
        net.WriteInt(5,11)
    net.Send(ply)]]
        ply:ChanelRadio(tonumber(chanel))
        mp.util.Notify(ply, NOTIFY_GENERIC, "Вы изменили канал рации на " .. chanel .. ".")
        ply:SetRadioOwner(false)
        return
    end

    local hasowner = false

    if #playes > 1 then
        for k, v in ipairs(playes) do
            if ply == v then continue end

            if chanel == v:GetChanelRadio() and ply ~= v then
                if v:GetRadioOwner() then
                    net.Start("mp.DoChanel")
                    net.WriteEntity(ply)
                    net.WriteInt(chanel, 11)
                    net.Send(v)
                    hasowner = true

                    return
                end
            end
        end
    end

    if not hasowner then
        ply:SetRadioOwner(true)
        ply:ChanelRadio(tonumber(chanel))
        mp.util.Notify(ply, NOTIFY_GENERIC, "Вы изменили канал рации на " .. chanel .. ".")
    end
end

net.Receive("mp.SpeakerToggle", function()
    local ply = net.ReadEntity()
    if ply:GetRadioSpeak() then
        ply:SetRadioSpeak(false)
    else
        ply:SetRadioSpeak(true)
    end

    local str = ! ply:GetRadioSpeak() and "выключили" or "включили"
    mp.util.Notify(ply, NOTIFY_GENERIC, "Вы " .. str .. " рацию.")
end)

net.Receive("mp.MicroToggle", function()
    local ply = net.ReadEntity()
    if ply:GetRadioMicro() then
        ply:SetRadioMicro(false)
    else
        ply:SetRadioMicro(true)
    end

    local str = ! ply:GetRadioMicro() and "выключили" or "включили"
    mp.util.Notify(ply, NOTIFY_GENERIC, "Вы " .. str .. " микрофон рации.")
end)

net.Receive("mp.AccessChanel", function()
    local ply = net.ReadEntity()
    local chanel = net.ReadInt(11)
    if ply:GetRadioOwner() then ply:SetRadioOwner(false) end
    ply:ChanelRadio(chanel)
    mp.util.Notify(ply, NOTIFY_GENERIC, "Сменил канал на:" .. chanel)
end)

net.Receive("mp.SetKickRadio", function()
    local ply = net.ReadEntity()
    ply:ChanelRadio(0)
    mp.util.Notify(ply, NOTIFY_ERROR, "Сменил канал на: 0")
end)

net.Receive("mp.ChangeChannel", function()
    local ply = net.ReadEntity()
    local chanel = net.ReadInt(11)
    checkRadioChanel(ply, chanel)
end)

hook.Add("PlayerInitialSpawn", "WalkieTalkie_PlayerInitialSpawn", function(ply)
    ply:SetRadioMicro(true)
    ply:SetRadioOwner(false)
    ply:SetRadioSpeak(true)
end)

local activeRadioUsers = {}

/*
local PresetList = {
    { id = 0,  name = "Нет эффекта" },
    { id = 1,  name = "Чистильщик" },
    { id = 2,  name = "Десемплинг" },
    { id = 3,  name = "Комбайн" },
    { id = 4,  name = "Дарт Вейдер" },
    { id = 5,  name = "Радио" },
    { id = 6,  name = "Робот" },
    { id = 7,  name = "Пришелец" },
    { id = 8,  name = "Овердрайв" },
    { id = 9,  name = "Дисторшн" },
    { id = 10, name = "Телефон" },
    { id = 11, name = "Мегафон" },
    { id = 12, name = "Бурундук" },
    { id = 13, name = "Замедление" },
    { id = 14, name = "Метрокоп" },
}
*/

hook.Add("PlayerCanHearPlayersVoice", "WalkieTalkie_RadioEffect", function(listener, talker)
    if not IsValid(listener) or not IsValid(talker) then return end
    if not listener:Alive() or not talker:Alive() then return end

    local channel_l = listener:GetChanelRadio()
    local channel_t = talker:GetChanelRadio()
    local listener_s = listener:GetRadioSpeak()
    local talker_m = talker:GetRadioMicro()

    local distSqr = listener:GetPos():DistToSqr(talker:GetPos())

    if distSqr <= 250000 then
        if activeRadioUsers[talker] then
            activeRadioUsers[talker] = nil
           -- eightbit.EnableEffect(talker:UserID(), 0)
        end
        return true, true
    end

    if talker_m and listener_s then
        local chan_t_num = tonumber(channel_t)
        local chan_l_num = tonumber(channel_l)

        if chan_t_num and chan_l_num and chan_t_num == chan_l_num and chan_t_num > 0 then
            if talker:IsSpeaking() then
                if not activeRadioUsers[talker] then
                    activeRadioUsers[talker] = true
                    --eightbit.EnableEffect(talker:UserID(), 5)
                end
            end
            return true
        end
    end

    if activeRadioUsers[talker] then
        activeRadioUsers[talker] = nil
       -- eightbit.EnableEffect(talker:UserID(), 0)
    end

    return false
end)

local function find_players_in_radio(radio) --if !talker_m and !talker_s and !listener_s then --    if channel_l and channel_t and channel_l == channel_t then --        return true --    end -- end
    local targets = {}
    for k, v in pairs(player.GetAll()) do
        local channel = v:GetChanelRadio()
        if channel and channel == radio then table.insert(targets, v) end
    end
    return targets
end

--[[local function send_group_message(ply, radio, text)
    if not radio or radio == 0 then
        mp.util.Notify(ply, NOTIFY_ERROR, "Вы не можете использовать групповой чат.")
        return
    end

    text = string.gsub(text, "/g", "", 1)
    ChatAddText(find_players_in_radio(radio), Color(105, 79, 255), "[Рация] ", ply, color_white, ": ", text)
end]]

local function send_gr_msg(ply, text)
    text = string.gsub(text, "/g", "", 1)
    if mp.jobs[ply:Team()].Type == TEAM_RF then
        for _, v in pairs(player.GetAll()) do
            if mp.jobs[v:Team()].Type == TEAM_RF then
                ChatAddText(color_white, "[", mp.jobs[ply:Team()].name, "]",
                    Color(105, 79, 255), "[Рация] ", ply, color_white, ": ", text)
            end
        end
    end
end

--hook.Add("PlayerSay", "WalkieTalkie_PlayerSay", function(ply, text, teamonly)

--end)

concommand.Add("PlaySound", function(ply, cmd, args)
    if not ply:IsAdmin() then return end
    if not args[1] then return end

    net.Start("mp.PlaySound")
    net.WriteString(tostring(args[1]))
    net.Broadcast()
end)

--[[hook.Add("PlayerSay", "WalkieTalkie_PlayerSay", function(ply, text, teamonly)
    local job = mp.jobs[ply:Team()]
    local args = string.Explode(" ", text)
    local radio = ply:GetChanelRadio()
    if args[1] == "/g" then
        send_group_message(ply, radio, text)
        return ""
    end

    if teamonly then
        send_group_message(ply, radio, text)
        return ""
    end
end)]]
