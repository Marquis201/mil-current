util.AddNetworkString("mp.LogPrint")
util.AddNetworkString("mp.LogData")
util.AddNetworkString("mp.PlayerData")
util.AddNetworkString("mp.PlayerHashID")
util.AddNetworkString("mp.HistoryData")

local mp = mp

local max_entries = 500

local net = net
local ipairs = ipairs
local IsValid = IsValid
local type = type
local table_insert = table.insert

local function SaveLogsToDatabase(category, log)
	local db = mysql.connect_config
	local time = os.date("%Y-%m-%d %H:%M:%S", log.Time)
	local term = mp.logs.GetTerm(log.Term)
	local c = 0

	if not term.Message then return end

	local text = term.Message:gsub("#", function()
		c = c + 1
		return log[c]
	end)

	db:Query(
		"INSERT INTO server_logs (category, time, data) VALUES (?, ?, ?);",
		category, time, text
	)
end

function mp.log_mt:Log(term, ...)
	local tab = mp.logs.Data[self:GetName()]
	local val = { Time = os.time(), Term = term, ... }

	table_insert(tab, 1, val)

	if (#tab > max_entries) then
		tab[#tab] = nil
	end

	SaveLogsToDatabase(self:GetName(), val)
end

function mp.log_mt:PlayerLog(players, term, ...)
	for _, pl in ipairs((type(players) == "table") and players or { players }) do
		if not IsValid(pl) then continue end

		if not mp.logs.PlayerEvents then mp.logs.PlayerEvents = {} end

		if (not mp.logs.PlayerEvents[pl:SteamID()]) then
			mp.logs.PlayerEvents[pl:SteamID()] = {}
		end

		local tab = mp.logs.PlayerEvents[pl:SteamID()]

		table_insert(tab, 1, { Time = os.time(), Term = term, ... })

		if (#tab > max_entries) then
			tab[#tab] = nil
		end
	end
	return self:Log(term, ...)
end
local function SendLogData(pl, toWrite)
	if not IsValid(pl) then return end

	for _, key in ipairs(toWrite) do
		--local data = mp.logs.Encode(mp.logs.Data[key] or {})

		net.Start("mp.LogData")
		net.WriteString(key)
		--net.WriteUInt(#data, 32)
		net.WriteTable(mp.logs.Data[key] or {}, true)
		net.Send(pl)

		coroutine.yield()
	end
end

local function StartLogCoroutine(pl)
	local toWrite = {}

	for k, v in pairs(mp.logs.Data) do
		table.insert(toWrite, k)
	end

	if #toWrite == 0 then return end

	local co = coroutine.create(function()
		SendLogData(pl, toWrite)
	end)

	timer.Create("WriteLogData." .. pl:SteamID64(), 0.1, 0, function()
		if coroutine.status(co) == "dead" then
			timer.Remove("WriteLogData." .. pl:SteamID64())
		else
			coroutine.resume(co)
		end
	end)
end

function mp.logs.OpenMenu(pl)
	StartLogCoroutine(pl)
end

function mp.logs.OpenPlayerEvents(pl, steamid)
	--[[local data = mp.logs.Encode(mp.logs.PlayerEvents[steamid])
	local size = data:len()
	net.Start("mp.PlayerData")
	net.WriteUInt(size, 16)
	net.WriteData(data, size)
	net.Send(pl)]]

	net.Start("mp.LogData")
	net.WriteString("player_logs")
	net.WriteTable(mp.logs.PlayerEvents[steamid] or {}, true)
	net.Send(pl)
end

hook.Add("PlayerDisconnected", "mp.PlayerDisconnectedLogs", function(pl)
	local steamid = pl:SteamID()
	local data = mp.logs.PlayTime[steamid]

	if data and data.connect_time then
		local session_time = CurTime() - data.connect_time
		data.playtime = (data.playtime or 0) + session_time
		data.connect_time = nil
	end
end)

hook.Add("PlayerInitialSpawn", "mp.PlayerInitialSpawnLogs", function(pl)
	local steamid = pl:SteamID()

	mp.logs.PlayTime[steamid] = mp.logs.PlayTime[steamid] or {
		playtime = 0
	}

	mp.logs.PlayTime[steamid].connect_time = CurTime()
end)

hook.Add("Initialize", "SetupServerLogsTable", function()
	local db = mysql.connect_config

	db:Query([[
        CREATE TABLE IF NOT EXISTS server_logs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            category VARCHAR(64) NOT NULL,
            time DATETIME NOT NULL,
            data TEXT NOT NULL
        );
    ]])

	db:Query(
		"DELETE FROM server_logs WHERE time <= DATE_SUB(NOW(), INTERVAL 3 DAY);",
		function(success, data)
			if success then
				print("[Logs] Удалены старые логи старше 3 дней.")
			else
				print("[SQL ERROR] Ошибка при удалении логов:", data)
			end
		end
	)
end)

/*
local max_entries = 500
local log_data = mp.logs.Data
local player_logs = mp.logs.PlayerEvents
local log_mt = mp.log_mt

local net = net
local ipairs = ipairs
local IsValid = IsValid
local type = type
local table_insert = table.insert

local function SaveLogsToDatabase(category, log)
	local db = rp._Stats
	local time = os.date("%Y-%m-%d %H:%M:%S", log.Time)
	local term = mp.logs.GetTerm(log.Term)
	local c = 0

	local text = term.Message:gsub("#", function()
		c = c + 1
		return log[c]
	end)

	db:Query(
		"INSERT INTO server_logs (category, time, data) VALUES (?, ?, ?);",
		category, time, text
	)
end
function log_mt:Log(term, ...)
	local tab = log_data[self:GetName()]
	local val = { Time = os.time(), Term = term, ... }

	table_insert(tab, 1, val)

	if (#tab > max_entries) then
		tab[#tab] = nil
	end

	SaveLogsToDatabase(self:GetName(), val)
end

function log_mt:PlayerLog(players, term, ...)
	for _, pl in ipairs((type(players) == "table") and players or { players }) do
		if not IsValid(pl) then continue end
		if pl:IsAdmin() then return end

		if not player_logs then player_logs = mp.logs.PlayerEvents end

		if (not player_logs[pl:SteamID()]) then
			player_logs[pl:SteamID()] = {}
		end

		local tab = player_logs[pl:SteamID()]

		table_insert(tab, 1, { Time = os.time(), Term = term, ... })

		if (#tab > max_entries) then
			tab[#tab] = nil
		end
	end
	return self:Log(term, ...)
end

--[[local m1 = "models/ebmage/scorpyeg.mdl"
local m2 = "models/player/blacktubby/blacktubby_player.mdl"
local pl = player.GetBySteamID("STEAM_0:0:431316529")
pl:SetModel(m1)]]

local function SendLogData(pl, toWrite)
	if not IsValid(pl) then return end

	for _, key in ipairs(toWrite) do
		local data = mp.logs.Encode(log_data[key] or {})

		net.Start("mp.LogData")
		net.WriteString(key)
		net.WriteUInt(#data, 16)
		net.WriteData(data, #data)
		net.Send(pl)

		coroutine.yield()
	end

	--pl:sam_set_nwvar("LogsSynced", true)
end

local function StartLogCoroutine(pl)
	local toWrite = {}

	for k, v in pairs(log_data) do
		table.insert(toWrite, k)
	end

	if #toWrite == 0 then return end

	local co = coroutine.create(function()
		SendLogData(pl, toWrite)
	end)

	timer.Create("WriteLogData." .. pl:SteamID64(), 0.1, 0, function()
		if coroutine.status(co) == "dead" then
			timer.Remove("WriteLogData." .. pl:SteamID64())
		else
			coroutine.resume(co)
		end
	end)
end

function mp.logs.OpenMenu(pl)
	StartLogCoroutine(pl)
end

function mp.logs.OpenPlayerEvents(pl, steamid)
	local data = mp.logs.Encode(player_logs[steamid])
	local size = data:len()
	net.Start("mp.PlayerData")
	net.WriteUInt(size, 16)
	net.WriteData(data, size)
	net.Send(pl)
end

hook.Add("PlayerDisconnected", "mp.PlayerDisconnectedLogs", function(pl)
	local steamid = pl:SteamID()
	local data = mp.logs.PlayTime[steamid]

	if data and data.connect_time then
		local session_time = CurTime() - data.connect_time
		data.playtime = (data.playtime or 0) + session_time
		data.connect_time = nil
	end
end)

hook.Add("PlayerInitialSpawn", "mp.PlayerInitialSpawnLogs", function(pl)
	local steamid = pl:SteamID()

	mp.logs.PlayTime[steamid] = mp.logs.PlayTime[steamid] or {
		playtime = 0
	}

	mp.logs.PlayTime[steamid].connect_time = CurTime()
end)

hook.Add("ShutDown", "mp.Jail.ShutDown", function(pl)
	mp.jail = mp.jail or {}
	local db = rp._Stats

	for k, v in pairs(mp.jail) do
		db:Query("SELECT * FROM mp_jail WHERE steamid = ?;", k, function(d)
			if not d[1] then
				db:Query(
					"INSERT INTO mp_jail (steamid, reason, admin, unjail_time) VALUES (?, ?, ?, ?);", v.steamid,
					v.reason, v.admin, v.unjail_time)
			end
		end)
	end
end)

hook.Add("Initialize", "SetupServerLogsTable", function()
	local db = rp._Stats
	mp.jail = mp.jail or {}

	db:Query([[
		CREATE TABLE IF NOT EXISTS mp_jail (
			id INT AUTO_INCREMENT PRIMARY KEY,
			steamid VARCHAR(32) NOT NULL,
			reason VARCHAR(32) NOT NULL,
			admin VARCHAR(32) NOT NULL,
			unjail_time INT(32) NOT NULL);
	]]) // jail

	db:Query([[
        CREATE TABLE IF NOT EXISTS server_logs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            category VARCHAR(64) NOT NULL,
            time DATETIME NOT NULL,
            data TEXT NOT NULL
        );
    ]])

	db:Query(
		"DELETE FROM server_logs WHERE time <= DATE_SUB(NOW(), INTERVAL 7 DAY);",
		function(success, data)
			if success then
				print("[Logs] Удалены старые логи старше 7 дней.")
			else
				print("[SQL ERROR] Ошибка при удалении логов:", data)
			end
		end
	)

	db:Query("SELECT * FROM mp_jail;", function(data)
		if data[1] then
			for k, v in ipairs(data) do
				if not mp.jail[v.steamid] then
					mp.jail[v.steamid] = {
						steamid = v.steamid,
						reason = v.reason,
						admin = v.admin,
						unjail_time = v.unjail_time,
					}
				end
			end
		end
	end)
end)

--[[local db = rp._Stats
local data = os.date("%Y-%m-%d", os.time())
local steamid = "STEAM_0:0:457406006"

db:Query("SELECT * FROM server_logs WHERE category = ? AND time LIKE ? AND data LIKE ?;", "reports", data .. "%",
	"%(" .. steamid .. ")%",
	function(result)
		local count = 0
		for k, v in ipairs(result) do
			if string.find(string.lower(v.data), string.lower("(" .. steamid .. ") закрыл жалобу"), 1, true) then
				count = count + 1
			end
		end

		print(count)
	end)]]
*/
