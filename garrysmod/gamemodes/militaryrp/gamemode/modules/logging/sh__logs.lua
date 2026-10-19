local mp             = mp

mp.logs              = mp.logs or {}

mp.logs.PlayTime     = mp.logs.PlayTime or {}
mp.logs.Data         = mp.logs.Data or {}
mp.logs.Terms        = mp.logs.Terms or {}
mp.logs.Logs         = mp.logs.Logs or {}
mp.logs.PlayerEvents = mp.logs.PlayerEvents or {}

mp.log_mt            = mp.log_mt or {}
mp.log_mt.__index    = mp.log_mt

local log_mt         = mp.log_mt

function mp.logs.Create(name)
	local l              = setmetatable({
		Name = name,
	}, mp.log_mt)

	mp.logs.Logs[l.Name] = l
	mp.logs.Data[l.Name] = mp.logs.Data[l.Name] or {}
	return l
end

function mp.logs.AddTerm(name, message, copy)
	mp.logs.Terms[name] = {
		Name = name,
		Message = message,
		Copy = copy
	}
end

function mp.logs.GetTerm(id)
	return mp.logs.Terms[id]
end

function mp.logs.Get(name)
	return mp.logs.Logs[name]
end

function mp.logs.Encode(data)
	return util.Compress(pon.encode(data))
end

function mp.logs.Decode(data)
	return pon.decode(util.Decompress(data))
end

function log_mt:Hook(name, callback)
	if (SERVER) then
		hook.Add(name, "mp.logs." .. name, function(...)
			callback(self, ...)
		end)
	end

	return self
end

function log_mt:GetName()
	return self.Name
end

if SERVER then
	local function Logs(pl, cmd, args)
		if not pl:IsAdmin() then return end

		mp.logs.OpenMenu(pl)
	end

	mp.commands.add("logs", Logs)
end

/*
mp.logs              = mp.logs or {}

mp.logs.PlayTime     = mp.logs.PlayTime or {}
mp.logs.Data         = mp.logs.Data or {}
mp.logs.Terms        = mp.logs.Terms or {}
mp.logs.Logs         = mp.logs.Logs or {}
mp.logs.PlayerEvents = mp.logs.PlayerEvents or {}

mp.log_mt            = mp.log_mt or {}
mp.log_mt.__index    = mp.log_mt

local log_mt         = mp.log_mt

function mp.logs.Create(name)
	local l              = setmetatable({
		Name = name,
	}, mp.log_mt)

	mp.logs.Logs[l.Name] = l
	mp.logs.Data[l.Name] = {}
	return l
end

function mp.logs.AddTerm(name, message, copy)
	mp.logs.Terms[name] = {
		Name = name,
		Message = message,
		Copy = copy
	}
end

function mp.logs.GetTerm(id)
	return mp.logs.Terms[id]
end

function mp.logs.Get(name)
	return mp.logs.Logs[name]
end

function mp.logs.Encode(data)
	return util.Compress(pon.encode(data))
end

function mp.logs.Decode(data)
	return pon.decode(util.Decompress(data))
end

function log_mt:Hook(name, callback)
	if (SERVER) then
		hook.Add(name, "mp.logs." .. name, function(...)
			callback(self, ...)
		end)
	end

	return self
end

function log_mt:GetName()
	return self.Name
end

-- Commands
--[[local command, language = mp.command, mp.language

command.set_category("Logs")

command.new("logs")
	:SetPermission("logs", "admin")
	:OnExecute(function(pl)
		mp.logs.OpenMenu(pl)
	end)
	:End()

command.new("historylogs")
	:SetPermission("logs")
	:AddArg("text", { hint = "category" })
	:AddArg("text", { hint = "data" })
	:OnExecute(function(pl, category, data)
		local db = rp._Stats

		db:Query(
			"SELECT * FROM server_logs WHERE category = ? AND time LIKE ?;",
			category, data .. "%",
			function(result)
				local _data = mp.logs.Encode(result or {})

				net.Start("mp.HistoryData")
				net.WriteUInt(#_data, 16)
				net.WriteData(_data, #_data)
				net.Send(pl)
			end
		)
	end)
	:End()

command.new("info")
	:SetPermission("logs")
	:AddArg("text", { hint = "steamid" })
	:OnExecute(function(pl, steamid)
		local db = rp._Stats
		local data = os.date("%Y-%m-%d", os.time())

		if not mp.logs.PlayTime[steamid] then
			mp.logs.PlayTime[steamid] = {
				connect = CurTime(),
				playtime = pl:TimeConnected()
			}
		end

		local target = player.GetBySteamID(steamid)

		if not IsValid(target) then
			rp.Notify(pl, NOTIFY_ERROR, "Игрок не найден на сервере!")
			return
		end

		db:Query(
			"SELECT * FROM server_logs WHERE category = ? AND time LIKE ? AND data LIKE ?;",
			"reports", data .. "%", "%(" .. steamid .. ")%",
			function(result)
				local count = 0
				for k, v in ipairs(result) do
					if string.find(string.lower(v.data), string.lower("(" .. steamid .. ") закрыл жалобу"), 1, true) then
						count = count + 1
					end
				end

				local PlayerData = mp.logs.PlayTime[steamid] or {}
				local playtime = PlayerData.playtime or 0
				if PlayerData.connect_time then
					playtime = playtime + (CurTime() - PlayerData.connect_time)
				end

				local time = string.FormattedTime(playtime)

				mp.player.add_text(pl, color_white, "[SERVER]", color_white, target:Name(),
					color_white, " (", Color(240, 170, 80), target:GetUserGroup(), color_white, ") ", color_white,
					" (",
					Color(240, 170, 80), steamid, color_white, ") ",
					color_white, " Разобранных жалоб: ", Color(240, 170, 80), tostring(count),
					color_white, " (", Color(240, 170, 80), data, color_white, ")", color_white, " Время на сервере: ",
					Color(240, 170, 80), time.h .. "ч." .. time.m .. "м.")
			end
		)
	end)
	:End()

command.new("playerevents")
	:Aliases("pe")
	:SetPermission("playerevents", "admin")
	:AddArg("text", { hint = "steamid" })
	:OnExecute(function(pl, steamid)
		if not mp.logs.PlayerEvents[steamid] then
			rp.Notify(pl, NOTIFY_ERROR, "Игрок не найден")
			return
		end
		mp.logs.OpenPlayerEvents(pl, steamid)
	end)
	:End()
]]*/
