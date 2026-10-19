util.AddNetworkString("echat.Message")

--if from = nil then message from server
--to can be {ply, ply2, ply3 ...}

function echat:SendParsedMessageToPlayer(from, to, parsed_text, actual_text)
    local from_player = (IsValid(from) and from.IsPlayer) and from:IsPlayer()

    net.Start("echat.Message")
    net.WriteBool(from_player) --message from player
    if from_player then
        net.WriteEntity(from)
    end
    local tbl = {
        ["parsed"] = parsed_text,
        ["text"] = actual_text

    }
    esclib:NetWriteCompressedTable(tbl) --parsed result
    net.Send(to)
end

function echat:SendMessageToPlayer(from, to, string_to_send)
    if not string_to_send or not isstring(string_to_send) then return end --nothing to send
    local parsed = echat:ParseText(string_to_send, from)                  --we need to parse it on server because there is checks for different parsers
    if not parsed or not istable(parsed) then return end                  --nothing to send

    echat:SendParsedMessageToPlayer(from, to, parsed, string_to_send)
end

function echat:AddText(to, ...)
    local final_str = echat:FinalParse(...)
    echat:SendMessageToPlayer(nil, to, final_str)
end

local badWords = {
    "discord",
    "discord.gg",
    "https",
    ".com",
    ".ru",
    ".su",
    "vk.com",
    "t.me",
    "urbanichka",
    "убраничка",
    "www.youtube",
}

-- Проверка на привилегию founder через ServerGuard
local function HasFounderPrivilege(ply)
    if not IsValid(ply) then return false end
    -- Проверяем наличие привилегии founder (замените "founder" на точное название привилегии в вашей админке)
    if ply:IsAdmin() then return true end -- опционально: админы тоже могут обходить
    if serverguard and serverguard.Player and serverguard.Player.HasPrivilege then
        return serverguard.Player.HasPrivilege(ply, "founder")
    end
    return false
end

local function filterMessage(ply, text)
    -- Если игрок имеет привилегию founder, пропускаем сообщение без фильтрации
    if HasFounderPrivilege(ply) then
        return true
    end
    
    for _, word in ipairs(badWords) do
        if string.find(string.lower(text), word) then
            return false
        end
    end

    return true
end

--Recieve message from player
local function RecieveMessage(len, ply)
    if not IsValid(ply) then return end
    
    local is_team = net.ReadBool() -- is team chat
    local text = esclib:NetReadCompressedTable()["text"]
    if not text then return end

    text = hook.Run("PlayerSay", ply, text, is_team)
    if not text or text == "" then return end
    if not isstring(text) then return end

    -- Фильтр сообщений (ссылки и спам) с проверкой на founder
    if not filterMessage(ply, text) then
        serverguard.Notify(ply, SERVERGUARD.NOTIFY.RED, "Ссылки и спам запрещены!")
        return
    end

    ply.NextPlayerSay = ply.NextPlayerSay or 0

    -- Задержка между сообщениями: если игрок не founder - проверяем
    if not HasFounderPrivilege(ply) then
        if ply.NextPlayerSay > CurTime() then
            return
        end
        ply.NextPlayerSay = CurTime() + 2
    end

    local players = player.GetHumans()
    local recievers = {}
    for _, v in ipairs(players) do
        if not IsValid(v) then continue end
        if is_team then
            if (v:Team() == ply:Team()) then
                if hook.Run("PlayerCanSeePlayersChat", text, true, v, ply) ~= false then
                    table.insert(recievers, v)
                end
            end
        else
            if hook.Run("PlayerCanSeePlayersChat", text, false, v, ply) ~= false then
                table.insert(recievers, v)
            end
        end
    end

    local tags = ""
    if is_team then
        tags = echat:FinalParse(team.GetColor(ply:Team()), "[TEAM] ", ply, color_white, ": ")
    else
        tags = echat:FinalParse(ply, color_white, ": ")
    end

    local parsed_tags = echat:ParseText(tags)         --we dont need to parse tags from server
    local parsed_message = echat:ParseText(text, ply) --parse message with checks
    local result = table.Add(parsed_tags, parsed_message)

    echat:SendParsedMessageToPlayer(ply, recievers, result, text)
end
net.Receive("echat.Message", RecieveMessage)