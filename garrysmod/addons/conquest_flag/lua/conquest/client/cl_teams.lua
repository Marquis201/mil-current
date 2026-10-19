Conquest.TeamManager = Conquest.TeamManager or {}
Conquest.TeamManager.cache = Conquest.TeamManager.cache or {}
Conquest.TeamManager.QuickCache = Conquest.TeamManager.QuickCache or {}

local function ClearConquestQuickCache(index)
    for k,v in pairs(Conquest.TeamManager.QuickCache) do
        if (v == index) then
            Conquest.TeamManager.QuickCache[k] = nil
        end
    end
end


net.Receive("conquest.team.sync", function()
    local len = net.ReadUInt( 16 )
    local compressedString = net.ReadData( len )
    local largestring = util.Decompress( compressedString )

    if (largestring) then
        Conquest.TeamManager.cache = util.JSONToTable(largestring)
    end

    local cache = net.ReadTable()
    // Build quick cache
    if (cache) then
        Conquest.TeamManager.QuickCache = cache or {}
    end

end)


net.Receive("conquest.team.add", function()
    local name = net.ReadString()
    local data = net.ReadTable()
    local cache = net.ReadTable()

    if (name and data) then
        Conquest.TeamManager.cache[name] = data
    end

    if (cache) then
        Conquest.TeamManager.QuickCache = cache or {}
    end

end)

net.Receive("conquest.team.remove", function()
    local name = net.ReadString()

    if (name) then
        if (Conquest.TeamManager.cache[name]) then
            
            // clear quick cache
            for k,v in pairs(Conquest.TeamManager.cache[name].teams) do

                Conquest.TeamManager.QuickCache[k] = nil
            end

            Conquest.TeamManager.cache[name] = nil
        end
    end
end)

net.Receive("conquest.team.edit", function()
    local oldName = net.ReadString()
    local newName = net.ReadString()
    local newTeamData = net.ReadTable()
    local tQuickCache = net.ReadTable()

    if (oldName and newName) then
        if (Conquest.TeamManager.cache[oldName]) then
            Conquest.TeamManager.cache[oldName] = nil
        end

        Conquest.TeamManager.cache[newName] = newTeamData
    end

    if (tQuickCache) then
        
        Conquest.TeamManager.QuickCache = tQuickCache or {}
    end
end)