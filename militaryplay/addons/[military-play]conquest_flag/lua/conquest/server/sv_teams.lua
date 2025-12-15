
Conquest.TeamManager = Conquest.TeamManager or {}
Conquest.TeamManager.cache = Conquest.TeamManager.cache or {}

// Caches each team index to a team name
// This should be calls extremely faster, but use more memory. You win some, lose some.
Conquest.TeamManager.QuickCache = Conquest.TeamManager.QuickCache or {}

util.AddNetworkString("conquest.team.add")
util.AddNetworkString("conquest.team.remove")
util.AddNetworkString("conquest.team.edit")
util.AddNetworkString("conquest.team.sync")
util.AddNetworkString("conquest.team.remove_all")

net.Receive("conquest.team.add", function(len, pPlayer)
    if (!Conquest.Config.canEdit(pPlayer)) then return end

    local tblTeams = net.ReadTable()
    local teamName = net.ReadString()
    local teamColor = net.ReadColor()

    if (tblTeams) then

        Conquest.TeamManager.CreateNew(pPlayer, teamName, tblTeams, teamColor)

    end

end)

net.Receive("conquest.team.edit", function(len, pPlayer)
    if (!Conquest.Config.canEdit(pPlayer)) then return end

    local strOldName = net.ReadString()
    local strNewName = net.ReadString()
    local tTeamData = net.ReadTable()
    local tColorData = net.ReadColor()

    if (strNewName and tTeamData) then

        Conquest.TeamManager.EditTeam(pPlayer, strNewName, tTeamData, tColorData, strOldName)

    end

end)

net.Receive("conquest.team.remove", function(len, pPlayer)
    if (!Conquest.Config.canEdit(pPlayer)) then return end

    local teamName = net.ReadString()

    if (teamName) then

        Conquest.TeamManager.RemoveAt(pPlayer, teamName)

    end

end)

local function ClearConquestQuickCache(index)
    for k,v in pairs(Conquest.TeamManager.QuickCache) do
        if (v == index) then
            Conquest.TeamManager.QuickCache[k] = nil
        end
    end
end

function Conquest.TeamManager.RemoveAt(pPlayer, teamName)
    if (!Conquest.Config.canEdit(pPlayer)) then return end

    if (Conquest.TeamManager.cache[teamName]) then

        for k,v in pairs(Conquest.TeamManager.cache[teamName].teams) do

            Conquest.TeamManager.QuickCache[k] = nil

        end

        Conquest.TeamManager.cache[teamName] = nil

        net.Start("conquest.team.remove")
            net.WriteString(teamName)
        net.Broadcast()

        Conquest.TeamManager.Save()

        pPlayer:PrintMessage(HUD_PRINTTALK, "[Conquest] Team deleted successfully.")
        print("[Conquest] Team deleted successfully.")

    end

end

function Conquest.TeamManager.EditTeam(pPlayer, sTeamName, tblTeams, clrTeamColor, strOldTeamName)
    if (!Conquest.Config.canEdit(pPlayer)) then return end

    local tTeam = Conquest.TeamManager.cache[strOldTeamName]

    if (tTeam) then
        Conquest.TeamManager.cache[strOldTeamName] = nil

        Conquest.TeamManager.cache[sTeamName] = {teams = tblTeams, color = clrTeamColor}

        ClearConquestQuickCache(sTeamName)
        // Build team cache
        for index, teams in pairs(tblTeams) do
            Conquest.TeamManager.QuickCache[index] = sTeamName
        end

        net.Start("conquest.team.edit")
            net.WriteString(strOldTeamName)
            net.WriteString(sTeamName)
            net.WriteTable(Conquest.TeamManager.cache[sTeamName])
            net.WriteTable(Conquest.TeamManager.QuickCache)
        net.Broadcast()

        pPlayer:PrintMessage(HUD_PRINTTALK, "[Conquest] Team editted successfully.")
        print("[Conquest] Editted team successfully.")

        Conquest.TeamManager.Save()
    end


end

function Conquest.TeamManager.CreateNew(pPlayer, name, tblTeams, teamclr)
    if (!Conquest.Config.canEdit(pPlayer)) then return end

    Conquest.TeamManager.cache[name] = {teams = tblTeams, color = teamclr}

    ClearConquestQuickCache(sTeamName)
    // Build team cache
    for index, teams in pairs(tblTeams) do
        Conquest.TeamManager.QuickCache[index] = name
    end

    net.Start("conquest.team.add")
        net.WriteString(name)
        net.WriteTable(Conquest.TeamManager.cache[name])
        net.WriteTable(Conquest.TeamManager.QuickCache)
    net.Broadcast()

    pPlayer:PrintMessage(HUD_PRINTTALK, "[Conquest] Team added successfully.")

    Conquest.TeamManager.Save()
end

function Conquest.TeamManager.Save()
    file.CreateDir("conquest")
    file.Write("conquest/conquest_teams.txt", util.TableToJSON(Conquest.TeamManager.cache or {}))

    print("[Conquest] Saved custom teams.")

    return true
end

function Conquest.TeamManager.Load()
    if file.Exists("conquest/conquest_teams.txt", "DATA") then
        
        local ourTeams = file.Read("conquest/conquest_teams.txt", "DATA")

        if (ourTeams) then

            local decodded_teams = util.JSONToTable(ourTeams)

            Conquest.TeamManager.cache = decodded_teams or {}
            
            // Cache the teams to make calling faster serverside
            for k,v in pairs(Conquest.TeamManager.cache) do

                for index, teams in pairs(v.teams) do

                    Conquest.TeamManager.QuickCache[index] = k

                end

            end

        else

            Conquest.TeamManager.cache = {}
            Conquest.TeamManager.QuickCache = {}

        end

    end

end

hook.Add("PostGamemodeLoaded", "conquest.team.LoadTeamsFirst", function()

    timer.Simple(0.1, function()

        Conquest.TeamManager.Load()

    end)

end)

hook.Add("PlayerInitialSpawn", "conquest.team.SyncPlayer", function(pPlayer)
    timer.Simple(1, function()
        local compression = util.TableToJSON(Conquest.TeamManager.cache or {})
        local compressedString = util.Compress( compression )
        local len = #compressedString

        if IsValid(pPlayer) then
            net.Start("conquest.team.sync")
                net.WriteUInt( len, 16 )
                net.WriteData( compressedString, len )
                net.WriteTable(Conquest.TeamManager.QuickCache or {})
            net.Send(pPlayer)
        end
    end)

end)