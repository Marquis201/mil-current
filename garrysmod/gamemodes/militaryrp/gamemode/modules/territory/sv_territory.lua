local util = util
local mp = mp
local hook = hook
local IsValid = IsValid
local CurTime = CurTime
local timer = timer
local nw = nw

local NW = { "StartTir", "StartCourse", "AddGPS", "DeleteGPS" }

for k, v in ipairs(NW) do
	util.AddNetworkString("mp.Territory." .. v)
end

local function hastir(pl)
	local data = nw.GetGlobal("mp.Tir") or {}
	return data and pl:GetFaction() and data[pl:GetFaction()] and data[pl:GetFaction()].steamid == pl:SteamID64()
end

local function checktir(pl)
	local data = nw.GetGlobal("mp.Tir") or {}
	return not data or not data[pl:GetFaction()]
end

local function GetTopPlayers()
	local db = mysql.connect_config
	db:Query("SELECT steamid, time FROM player_tir ORDER BY time ASC LIMIT 10;", function(data)
		if data and #data > 0 then
			nw.SetGlobal("mp.TirList", data)
		else
			print("Нет данных для отображения топа")
		end
	end)
end

function PLAYER:CompleteTir()
	local time = self:GetNetVar("mp.PlayerTir") and self:GetNetVar("mp.PlayerTir").time or false
	self:SetNetVar("mp.PlayerTir", nil)

	if not time then return end

	time = CurTime() - time

	local db = mysql.connect_config
	local steamid = self:SteamID64()

	hook.Call("OnPlayerTir", nil, self)

	db:Query("SELECT * FROM player_tir WHERE steamid = ?;", steamid, function(data)
		if data[1] then
			if tonumber(data[1].time) < time then return end

			hook.Call("OnPlayerTirRecord", nil, self)

			db:Query("UPDATE player_tir SET time=? WHERE steamid=?;", time, steamid, function()
				GetTopPlayers()
			end)
		else
			db:Query("INSERT INTO player_tir(steamid, time) VALUES(?, ?);", steamid, time, function()
				GetTopPlayers()
			end)
		end
	end)
end

net.Receive("mp.Territory.StartCourse", function(_, pl)
	--if not pl:IsSuperAdmin() then return end
	pl.NextCourseStart = pl.NextCourseStart or 0
	if pl.NextCourseStart > CurTime() then
		mp.util.Notify(pl, NOTIFY_ERROR,
			"Вы сможете начать через " .. math.Round(pl.NextCourseStart - CurTime()) .. " сек.")

		return
	end

	pl.NextCourseStart = CurTime() + 2

	local id = net.ReadString()

	if not mp.Territory.Table[id] then return end

	local data = mp.Territory.Table[id]
	local steamid64 = pl:SteamID64()

	if pl:GetNetVar("mp.PlayerCourse") then
		if pl:GetPos():Distance(data.finish) < 50 then
			pl:SetNetVar("mp.PlayerCourse", nil)
			mp.util.Notify(pl, NOTIFY_GENERIC, "Вы успешно прошли полосу!")
			timer.Remove("StopCourse." .. steamid64)

			hook.Call("OnPlayerObstacle", nil, pl)
		end
		return
	end
	if pl:GetNetVar("mp.PlayerTir") then return end

	pl:SetNetVar("mp.PlayerCourse", CurTime() + mp.Territory.CourseTime)

	timer.Create("StopCourse." .. steamid64, .5, mp.Territory.CourseTime, function()
		local valid = IsValid(pl)
		if timer.RepsLeft("StopCourse." .. steamid64) <= 0 then
			if valid and pl:GetNetVar("mp.PlayerCourse") then
				pl:SetNetVar("mp.PlayerCourse", nil)
				mp.util.Notify(pl, NOTIFY_ERROR, "Вы не успели в установленное время!")
			end
		end

		if valid and pl:GetNetVar("mp.PlayerCourse") then
			if not pl:Alive() then
				pl:SetNetVar("mp.PlayerCourse", nil)
				mp.util.Notify(pl, NOTIFY_ERROR, "Вы умерли!")
				timer.Remove("StopCourse." .. steamid64)
			end

			if not pl:InTerritory(data.pos.x, data.pos.y) and pl:GetPos():Distance(data.finish) > 50 then
				pl:SetNetVar("mp.PlayerCourse", nil)
				mp.util.Notify(pl, NOTIFY_ERROR, "Вы покинули зону!")
				timer.Remove("StopCourse." .. steamid64)
			end

			if pl:GetPos():Distance(data.finish) < 50 then
				pl:SetNetVar("mp.PlayerCourse", nil)
				mp.util.Notify(pl, NOTIFY_GENERIC, "Вы успешно прошли полосу!")
				timer.Remove("StopCourse." .. steamid64)

				hook.Call("OnPlayerObstacle", nil, pl)
			end
		else
			timer.Remove("StopCourse." .. steamid64)
		end
	end)
end)

net.Receive("mp.Territory.StartTir", function(_, pl)
	--if not pl:IsSuperAdmin() then return end
	pl.NextTirStart = pl.NextTirStart or 0
	if pl.NextTirStart > CurTime() then
		mp.util.Notify(pl, NOTIFY_ERROR, "Вы сможете начать через " .. math.Round(pl.NextTirStart - CurTime()) .. " сек.")

		return
	end

	pl.NextTirStart = CurTime() + 2

	local id = net.ReadString()

	if not mp.Territory.Table[id] then return end

	local data = mp.Territory.Table[id]
	local steamid64 = pl:SteamID64()

	if pl:InTerritory(data.pos.x, data.pos.y) and data.tir and data.control and pl:GetFaction() and pl:GetFaction() == data.control and checktir(pl) then
		if pl:GetNetVar("mp.PlayerTir") then return end
		if pl:GetNetVar("mp.PlayerCourse") then return end

		local t = nw.GetGlobal("mp.Tir") or {}

		t[pl:GetFaction()] = {
			steamid = steamid64,
			id = id
		}

		pl:SetNetVar("mp.PlayerTir", {
			time = CurTime(),
			id = id,
		})
		nw.SetGlobal("mp.Tir", t)

		local count = 0

		for k, v in pairs(mp.Territory.Tir) do
			if v.tir_id == id then
				count = count + 1
				v.tir_weapon = data.wep
				v.active_tir = pl
				v.complete_tir = false
				v:ResetSequence("up")
				timer.Remove("UPEft." .. v:EntIndex())
			end
		end

		pl.tir_count = count

		pl:Give(data.wep)
		pl:SelectWeapon(data.wep)
		pl.tir_weapon = data.wep

		mp.util.Notify(pl, NOTIFY_HINT, "Поразите все мишени менее чем за " .. (mp.Territory.TirTime / 60) .. " мин.")

		timer.Create("StopTir." .. steamid64, 1, mp.Territory.TirTime, function()
			local valid = IsValid(pl)
			if timer.RepsLeft("StopTir." .. steamid64) <= 0 then
				if valid and pl:GetNetVar("mp.PlayerTir") then
					pl:SetNetVar("mp.PlayerTir", nil)
					mp.util.Notify(pl, NOTIFY_ERROR, "Вы не успели в установленное время!")

					if pl.tir_weapon then
						pl:StripWeapon(pl.tir_weapon)
					end

					if hastir(pl) then
						nw.SetGlobal("mp.Tir", nil)
					end
				end
			end

			if valid and pl:GetNetVar("mp.PlayerTir") then
				local data2 = mp.Territory.Table[id]

				if not pl:Alive() then
					pl:SetNetVar("mp.PlayerTir", nil)
					mp.util.Notify(pl, NOTIFY_ERROR, "Вы умерли!")
					timer.Remove("StopTir." .. steamid64)

					if IsValid(nw.GetGlobal("mp.Tir")) and nw.GetGlobal("mp.Tir") == pl then
						nw.SetGlobal("mp.Tir", nil)
					end
				end

				if not pl:InTerritory(data2.tir.x, data2.tir.y) then
					pl:SetNetVar("mp.PlayerTir", nil)
					mp.util.Notify(pl, NOTIFY_ERROR, "Вы покинули зону!")
					timer.Remove("StopTir." .. steamid64)

					if pl.tir_weapon then
						pl:StripWeapon(pl.tir_weapon)
					end

					if hastir(pl) then
						nw.SetGlobal("mp.Tir", nil)
					end
				end
			else
				timer.Remove("StopTir." .. steamid64)
			end
		end)
	end
end)

hook.Add("PlayerDisconnected", "mp.Tir.PlayerDisconnected", function(pl)
	if hastir(pl) then
		local t = nw.GetGlobal("mp.Tir") or {}

		t[pl:GetFaction()] = nil

		nw.SetGlobal("mp.Tir", t)
	end
end)

hook.Add("InitPostEntity", "mp.Tir.CreateTable", function()
	local db = mysql.connect_config
	db:Query("CREATE TABLE IF NOT EXISTS player_tir (steamid VARCHAR(64) PRIMARY KEY, time FLOAT);")

	GetTopPlayers()

	for key, val in pairs(mp.Territory.Table) do
		if val.tir then
			for k, v in ipairs(ents.FindByClass("sent_eft_popper")) do
				if v:InTerritory(val.pos.x, val.pos.y) then
					mp.Territory.Tir[v:EntIndex()] = v
					v.tir_id = key
				end
			end
		end
	end
end)

hook.Add("PostCleanupMap", "mp.Tir.PostCleanupMap", function()
	GetTopPlayers()

	for key, val in pairs(mp.Territory.Table) do
		if val.tir then
			for k, v in ipairs(ents.FindByClass("sent_eft_popper")) do
				if v:InTerritory(val.pos.x, val.pos.y) then
					mp.Territory.Tir[v:EntIndex()] = v
					v.tir_id = key
				end
			end
		end
	end
end)

hook.Add("PlayerSwitchWeapon", "mp.Tir.WeaponSwitch", function(pl, oldWeapon, newWeapon)
	if pl:GetNetVar("mp.PlayerTir") and pl.tir_weapon and newWeapon:GetClass() ~= pl.tir_weapon then
		return true
	end
end)
