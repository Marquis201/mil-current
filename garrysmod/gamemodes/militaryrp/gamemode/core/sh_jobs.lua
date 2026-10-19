local indexnum = 0
local mp = mp

function mp.util.addjob(strName, tblTeam)
	indexnum = indexnum + 1

	team.SetUp(indexnum, strName, tblTeam.Color)

	tblTeam.index = indexnum
	tblTeam.Name = strName or ''
	table.insert(mp.jobs, indexnum, tblTeam)

	local models = tblTeam.WorldModel

	if SERVER and models then
		if istable(models) then
			for k, v in pairs(models) do
				util.PrecacheModel(v)
			end
		else
			util.PrecacheModel(models)
		end
	end

	return indexnum
end

function FindJob(index)
	return mp.jobs[index] or false
end

function FindJobByID(strID)
	for _, tblJob in pairs(mp.jobs) do
		if tblJob.jobID == strID then
			return tblJob
		end
	end
end

function PLAYER:GetJobName()
	return  mp.jobs[self:Team()] and mp.jobs[self:Team()].Name or "Неизвестно"
end

function PLAYER:GetJobColor()
	return mp.jobs[self:Team()] and mp.jobs[self:Team()].color or WHITE
end

function PLAYER:GetJobModel()
	return mp.jobs[self:Team()] and mp.jobs[self:Team()].model or self:GetModel()
end

function PLAYER:CanChangeJob(t)
	local TEAM = self:Team()
	local faction = (mp.jobs[TEAM] and mp.jobs[TEAM].faction) and mp.jobs[TEAM].faction or false

	if not faction then return false end

	local data = mp.faction[faction]

	if not data then return false end

	if data.whitelist and data.whitelist[TEAM] and data.whitelist[TEAM].jobs then
		if not data.whitelist[TEAM].jobs[t] then
			return false
		end
	else
		return false
	end

	return true
end

function mp.util.GetNato()
	local t = {}
	local all = player.GetAll()

	for k, v in ipairs(all) do
		if v:GetFaction() and v:GetFaction() == "nato" then
			t[#t + 1] = v
		end
	end

	return t
end

function mp.util.GetRF()
	local t = {}
	local all = player.GetAll()

	for k, v in ipairs(all) do
		if v:GetFaction() and v:GetFaction() == "rf" then
			t[#t + 1] = v
		end
	end

	return t
end