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

local NW = { "QualificationMenu", "QualificationSend", "UpdateQuest", "ContractMenu", "StartContract" }

for k, v in ipairs(NW) do
	util.AddNetworkString("QuestPlay." .. v)
end

net.Receive("QuestPlay.StartContract", function(_, pl)
	local id = net.ReadString()
	local data = mp.QuestPlay.List[id]
	local steamid = pl:SteamID64()

	if not data or not data.retry or mp.QuestPlay:HasContract(pl, data.id) or not pl:GetFaction() then return end
	if data.solo and mp.QuestPlay.ActiveSolo[id] and IsValid(player.GetBySteamID64(mp.QuestPlay.ActiveSolo[id])) and mp.QuestPlay.DealyContract[steamid] and mp.QuestPlay.DealyContract[steamid][id] then
		mp.util.Notify(pl, NOTIFY_ERROR, "Контракт занял другой игрок!")
		return
	end

	mp.QuestPlay:StartContract(pl, id)
end)

net.Receive("QuestPlay.QualificationSend", function(_, pl)
	if pl:GetNetVar("QuestPlay.Qualification") then return end
	if mp.QuestPlay:HasQuest(pl, "start_qualification") then return end

	local t = {}
	local count_score = 0

	for i = 1, net.ReadUInt(8) do
		t[net.ReadUInt(8)] = net.ReadUInt(8)
	end

	for k, v in ipairs(mp.QuestPlay.TestQualification) do
		if t[k] then
			for i = 1, #v.answer do
				if t[k] == i then
					count_score = count_score + v.answer[i].score
				end
			end
		end
	end

	pl:SetNetVar("QuestPlay.Qualification", count_score)

	mp.QuestPlay:UpdateQuest(pl)

	local db = mysql.connect_config
	db:Query("INSERT INTO player_qualification(steamid, score) VALUES(?, ?);", pl:SteamID64(), count_score)

	hook.Call("OnQualificationComplete", nil, pl)

	pl:Give("keys")
	pl:SelectWeapon("keys")

	mp.util.Notify(pl, NOTIFY_HINT, "Вы прошли тестирование! Ваша оценка: " .. count_score)

	timer.Simple(1, function()
		if IsValid(pl) then
			mp.util.Notify(pl, NOTIFY_HINT, "Вы можете открывать двери ключами (селектор оружия)", 5)
		end
	end)
end)

function mp.QuestPlay:UpdateQuest(pl)
	net.Start("QuestPlay.UpdateQuest")
	net.Send(pl)
end

function mp.QuestPlay:ContractComplete(pl, id)
	local data = mp.QuestPlay.List[id]
	if not data then return end

	local t = pl:GetNetVar("QuestPlay.ListContract") or {}
	t[id] = nil
	pl:SetNetVar("QuestPlay.ListContract", t)

	pl:AddPoints(data.price * data.reward)

	local steamid = pl:SteamID64()
	local cashContract = mp.QuestPlay.Contract[steamid] and mp.QuestPlay.Contract[steamid][id]

	mp.QuestPlay.DealyContract[steamid] = mp.QuestPlay.DealyContract[steamid] or {}
	mp.QuestPlay.DealyContract[steamid][id] = CurTime() + mp.QuestPlay.DealyContractTime

	if mp.QuestPlay.ActiveSolo[id] then
		mp.QuestPlay.ActiveSolo[id] = nil
	end

	if cashContract then
		mp.QuestPlay.Contract[steamid][id] = nil

		if data.pos and cashContract.pos then
			net.Start("mp.Territory.DeleteGPS")
			net.WriteString(id)
			net.Send(pl)
		end
	end

	timer.Remove("Contract." .. steamid .. "." .. id)

	mp.util.Notify(pl, NOTIFY_HINT, "Вы успешно выполнили контракт '" .. data.name .. "'!", 10)
end

function mp.QuestPlay:StartContract(pl, id)
	local data = mp.QuestPlay.List[id]
	if not data then return end

	if ! pl:CanAffordPoints(data.price) then
		mp.util.Notify(pl, NOTIFY_ERROR, "Недостаточно средств!")
		return
	end

	local steamid = pl:SteamID64()

	if mp.QuestPlay.DealyContract[steamid] and mp.QuestPlay.DealyContract[steamid][id] and mp.QuestPlay.DealyContract[steamid][id] > CurTime() then
		local cd = mp.QuestPlay.DealyContract[steamid][id] - CurTime()

		cd = math.floor(cd / 60)

		mp.util.Notify(pl, NOTIFY_ERROR, "Контракт будет доступен через " .. cd .. " мин.")

		return
	end

	if data.start then
		data.start(pl)
	end

	mp.QuestPlay.Contract = mp.QuestPlay.Contract or {}
	mp.QuestPlay.Contract[steamid] = mp.QuestPlay.Contract[steamid] or {}

	local t_contract = { time = CurTime() + data.time, count = 0, faction = pl:GetFaction() }

	if data.pos and pl.ContractPos then
		t_contract.pos = pl.ContractPos
	end

	mp.QuestPlay.Contract[steamid][id] = t_contract

	local t = pl:GetNetVar("QuestPlay.ListContract") or {}
	t[id] = t_contract
	pl:SetNetVar("QuestPlay.ListContract", t)

	pl:TakePoints(data.price)

	mp.QuestPlay:UpdateQuest(pl)

	mp.util.Notify(pl, NOTIFY_HINT, "Вы приступили к выполнению контракта!")

	if data.solo then
		mp.QuestPlay.ActiveSolo[data.id] = pl:SteamID64()
	end

	timer.Create("Contract." .. steamid .. "." .. id, data.time, 1, function()
		pl = player.GetBySteamID64(steamid)

		local cashContract = mp.QuestPlay.Contract[steamid] and mp.QuestPlay.Contract[steamid][id]

		if IsValid(pl) then
			t = pl:GetNetVar("QuestPlay.ListContract") or {}

			if t[id] then
				t[id] = nil
				pl:SetNetVar("QuestPlay.ListContract", t)

				mp.util.Notify(pl, NOTIFY_ERROR, "Время выполнения контракта '" .. data.name .. "' истекло!", 10)

				mp.QuestPlay:UpdateQuest(pl)
			end

			if mp.QuestPlay.ActiveSolo[id] then
				mp.QuestPlay.ActiveSolo[id] = nil
			end

			if data.solo then
				mp.QuestPlay.DealyContract[steamid] = mp.QuestPlay.DealyContract[steamid] or {}
				mp.QuestPlay.DealyContract[steamid][id] = CurTime() + mp.QuestPlay.DealyContractTime
			end

			if data.pos and cashContract and cashContract.pos then
				net.Start("mp.Territory.DeleteGPS")
				net.WriteString(id)
				net.Send(pl)
			end
		end

		if cashContract then
			mp.QuestPlay.Contract[steamid][id] = nil
		end
	end)
end

function mp.QuestPlay:CompleteQuest(pl, id)
	local db = mysql.connect_config
	local t = pl:GetNetVar("QuestPlay.List") or {}

	t[id] = true
	pl:SetNetVar("QuestPlay.List", t)

	db:Query("UPDATE player_quest SET list=? WHERE steamid=?;", util.TableToJSON(t), pl:SteamID64())
end

local function LoadData(pl)
	local db = mysql.connect_config
	local steamid = pl:SteamID64()

	if mp.QuestPlay.Contract and mp.QuestPlay.Contract[steamid] then
		local t = {}
		local has = false

		for k, v in pairs(mp.QuestPlay.Contract[steamid]) do
			local data = mp.QuestPlay.List[k]

			if not data then continue end
			if not v.faction or not pl:GetFaction() or v.faction ~= pl:GetFaction() then
				if v.pos then
					net.Start("mp.Territory.DeleteGPS")
					net.WriteString(k)
					net.Send(pl)
				end

				continue
			end

			if data.solo and mp.QuestPlay.ActiveSolo[k] and mp.QuestPlay.ActiveSolo[k] == steamid then
				mp.QuestPlay.Contract[steamid][k] = nil
				mp.QuestPlay.ActiveSolo[k] = nil

				mp.QuestPlay.DealyContract[steamid] = mp.QuestPlay.DealyContract[steamid] or {}
				mp.QuestPlay.DealyContract[steamid][k] = CurTime() + mp.QuestPlay.DealyContractTime
				continue
			end

			if timer.Exists("Contract." .. steamid .. "." .. k) then
				t[k] = {
					time = v.time,
					count = v.count
				}

				if v.pos then
					pl.ContractPos = v.pos

					net.Start("mp.Territory.AddGPS")
					net.WriteString(k)
					net.WriteString(data.name)
					net.WriteString(v.faction)
					net.WriteVector(v.pos)
					net.Send(pl)
				end

				has = true
			end
		end

		pl:SetNetVar("QuestPlay.ListContract", t)
	end

	db:Query("SELECT * FROM player_quest WHERE steamid=?;", steamid, function(data)
		if data[1] then
			local list = util.JSONToTable(data[1].list)

			pl:SetNetVar("QuestPlay.List", list)

			mp.QuestPlay:UpdateQuest(pl)
		else
			db:Query("INSERT INTO player_quest(steamid, list) VALUES(?, ?);", steamid, "{}")
		end

		db:Query("SELECT * FROM player_qualification WHERE steamid=?;", steamid, function(data2)
			if data2[1] then
				pl:SetNetVar("QuestPlay.Qualification", tonumber(data2[1].score))

				if mp.config.start_jobs[pl:Team()] then
					pl:Give("keys")
				end
			end
		end)
	end)

	mp.QuestPlay:UpdateQuest(pl)
end

hook.Add("PlayerSelectCharacter", "mp.PlayerSelectCharacter.QuestPlay", function(pl)
	if IsValid(pl) then
		LoadData(pl)
	end
end)

hook.Add("PlayerLoadout", "mp.PlayerLoadout.QuestPlay", function(pl)
	if mp.config.start_jobs[pl:Team()] and pl:GetNetVar("QuestPlay.Qualification") then
		pl:Give("keys")
	end
end)

hook.Add("InitPostEntity", "QuestPlay.CreateTable", function()
	local db = mysql.connect_config
	db:Query("CREATE TABLE IF NOT EXISTS player_quest (steamid VARCHAR(20) PRIMARY KEY, list TEXT);")
	db:Query("CREATE TABLE IF NOT EXISTS player_qualification (steamid VARCHAR(20) PRIMARY KEY, score FLOAT);")
end)
