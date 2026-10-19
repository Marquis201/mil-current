local Vector = Vector
local net = net
local hook = hook
local Angle = Angle
local timer = timer
local IsValid = IsValid
local util = util
local PLAYER = PLAYER
local mp = mp
local nw = nw

local NW = { "" }

for k, v in ipairs(NW) do
	util.AddNetworkString("Points." .. v)
end

local function UpdatePoints(steamid, amount, cback)
	local db = mysql.connect_config
	db:Query("UPDATE player_points SET bank=? WHERE steamid=?;", amount, tostring(steamid), cback)
end

local function UpdateFactionPoints(name, amount, cback)
	local db = mysql.connect_config

	db:Query("UPDATE faction_points SET bank=? WHERE name=?;", amount, tostring(name), cback)
end

function PLAYER:AddPoints(amount)
	if not amount then return end
	if not IsValid(self) then return end
	local total = self:GetPoints() + math.floor(amount)
	self:SetPoints(total)
end

function PLAYER:TakePoints(amount)
	if not amount then return end
	if not IsValid(self) then return end

	if ! self:CanAffordPoints(amount) then return end
	local total = self:GetPoints() + math.floor(-math.abs(amount))
	self:SetPoints(total)
end

function PLAYER:SetPoints(amount)
	if not amount then return end
	if not IsValid(self) then return end

	local steamid = self:SteamID64()
	local money = tonumber(amount)

	self:SetNetVar("Points", money)
	UpdatePoints(steamid, money)
end

function mp.Points:AddFactionPoints(name, amount)
	if not amount then return end
	if amount <= 0 or amount > 4294967295 then return end
	if not mp.faction[name] then return end

	local t = mp.Points:GetFactionPoints()
	t[name] = t[name] or 0

	local money = t[name]
	local total = money + math.floor(amount)

	t[name] = total

	nw.SetGlobal("FactionPoints", t)
	UpdateFactionPoints(name, total)
end

function mp.Points:TakeFactionPoints(name, amount)
	if not amount then return end
	if amount <= 0 or amount > 4294967295 then return end
	if not mp.faction[name] then return end

	local t = mp.Points:GetFactionPoints()
	t[name] = t[name] or 0

	if ! mp.Points:CanAffordFactionPoints(name, amount) then return end

	local money = t[name]
	local total = money + math.floor(-math.abs(amount))

	t[name] = total

	nw.SetGlobal("FactionPoints", t)
	UpdateFactionPoints(name, total)
end

function mp.Points:SetFactionPoints(name, amount)
	if not amount then return end
	if not mp.faction[name] then return end

	local t = mp.Points:GetFactionPoints()
	t[name] = t[name] or 0
	if amount <= 0 or amount > 4294967295 then return end

	t[name] = amount

	nw.SetGlobal("FactionPoints", t)
	UpdateFactionPoints(name, amount)
end

local function LoadData(pl)
	local db = mysql.connect_config
	local steamid = pl:SteamID64()

	db:Query("SELECT * FROM player_points WHERE steamid = ?;", steamid, function(data)
		if data[1] then
			local money = math.Clamp(tonumber(data[1].bank), 0, 4294967295)

			pl:SetNetVar("Points", money)
		else
			db:Query("INSERT INTO player_points(steamid, bank) VALUES(?, ?);", steamid, 0)
			pl:SetNetVar("Points", 0)
		end
	end)
end

hook.Add("PlayerInitialSpawn", "mp.PlayerInitialSpawn.Points", function(pl)
	timer.Simple(1, function()
		if IsValid(pl) then
			LoadData(pl)
		end
	end)
end)

hook.Add("InitPostEntity", "Points.CreateTable", function()
	local db = mysql.connect_config
	db:Query("CREATE TABLE IF NOT EXISTS faction_points (name VARCHAR(20), bank INT);")
	db:Query("CREATE TABLE IF NOT EXISTS player_points (steamid BIGINT(20), bank INT);")

	local t = {}
	for name, v in pairs(mp.faction) do
		db:Query("SELECT * FROM faction_points WHERE name = ?;", name, function(data)
			if not data[1] then
				db:Query("INSERT INTO faction_points(name, bank) VALUES(?, ?);", name, 0)
			end

			db:Query("SELECT * FROM faction_points;", name, function(d)
				for k, tbl in ipairs(d) do
					local money = math.Clamp(tonumber(tbl.bank), 0, 4294967295)

					t[tbl.name] = money
				end

				nw.SetGlobal("FactionPoints", t)
			end)
		end)
	end
end)

local function AddPlayerPoints(pl, cmd, args)
	if pl:IsAdmin() then
		local steamid = args[2]
		local target = player.GetBySteamID(steamid)

		if IsValid(target) then
			local amount = tonumber(args[3])

			target:AddPoints(amount)

			if target ~= pl then
				mp.util.Notify(pl, NOTIFY_GENERIC,
					pl:Name() .. "(" .. pl:SteamID() .. ")" .. " выдал вам " .. amount .. " очков!")
			end
			mp.util.Notify(pl, NOTIFY_GENERIC,
				"Вы выдали " .. amount .. " очков для " .. pl:Name() .. "(" .. pl:SteamID() .. ")")
		end
	end
end
mp.commands.add("addpoints", AddPlayerPoints)

local function TakePlayerPoints(pl, cmd, args)
	if pl:IsAdmin() then
		local steamid = args[2]
		local target = player.GetBySteamID(steamid)

		if IsValid(target) then
			local amount = tonumber(args[3])

			if ! target:CanAffordPoints(amount) then
				mp.util.Notify(pl, NOTIFY_ERROR,
					"У " .. target:Name() .. "(" .. target:SteamID() .. ")" .. " недостаточно очков!")
				return
			end

			target:TakePoints(amount)
			if target ~= pl then
				mp.util.Notify(target, NOTIFY_ERROR,
					pl:Name() .. "(" .. pl:SteamID() .. ")" .. " забрал у вас " .. amount .. " очков!")
			end
			mp.util.Notify(pl, NOTIFY_ERROR, "Вы забрали " .. amount .. " очков у " .. pl:Name() .. "(" .. pl:SteamID() .. ")")
		end
	end
end
mp.commands.add("takepoints", TakePlayerPoints)

local function TakeFactionPoints(pl, cmd, args)
	if pl:IsAdmin() then
		local name = args[2]
		if not mp.faction[name] then return end

		if name then
			local amount = tonumber(args[3])

			if ! mp.Points:CanAffordFactionPoints(name, amount) then
				mp.util.Notify(target, NOTIFY_ERROR,
					"У " .. target:Name() .. "(" .. target:SteamID() .. ")" .. " недостаточно очков!")
				return
			end

			mp.Points:TakeFactionPoints(name, amount)

			mp.util.Notify(pl, NOTIFY_ERROR,
				"Вы забрали у " .. mp.faction[name].title .. " " .. amount .. " очков")
		end
	end
end
mp.commands.add("takefactionpoints", TakeFactionPoints)

local function AddFactionPoints(pl, cmd, args)
	if pl:IsAdmin() then
		local name = args[2]
		if not mp.faction[name] then return end

		if name then
			local amount = tonumber(args[3])

			mp.Points:AddFactionPoints(name, amount)

			mp.util.Notify(pl, NOTIFY_GENERIC,
				"Вы выдали для " .. mp.faction[name].title .. " " .. amount .. " очков")
		end
	end
end
mp.commands.add("addfactionpoints", AddFactionPoints)
