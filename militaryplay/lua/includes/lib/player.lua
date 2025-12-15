local PLAYER, ENTITY = FindMetaTable 'Player', FindMetaTable 'Entity'
local GetTable = ENTITY.GetTable

-- meta
function PLAYER:__index(key)
	return PLAYER[key] or ENTITY[key] or GetTable(self)[key]
end

function PLAYER:Timer(name, time, reps, callback, failure)
	name = self:SteamID64() .. '-' .. name
	timer.Create(name, time, reps, function()
		if IsValid(self) then
			callback(self)
		else
			timer.Remove(name)

			if failure then
				failure()
			end
		end
	end)
end

function PLAYER:TimerRemove(name)
	name = self:SteamID64() .. '-' .. name
	timer.Remove(name)
end

function player.inRange(position, range)
	range = range ^ 2

	local output = {}

	for _, ply in ipairs(player.GetAll()) do
		if ply:GetPos():DistToSqr(position) <= range then
			table.insert(output, ply)
		end
	end

	return output
end

function player.GetBySteamID(steamid)
	steamid = steamid:upper()

	for _, ply in ipairs(player.GetAll()) do
		if steamid == ply:SteamID() then return ply end
	end

	return false
end

function player.GetBySteamID64(steamid)
	steamid = tostring(steamid)

	for _, ply in ipairs(player.GetAll()) do
		if steamid == ply:SteamID64() then return ply end
	end

	return false
end

function player.GetByUniqueID(id)
	for _, ply in ipairs(player.GetAll()) do
		if id == ply:UniqueID() then return ply end
	end

	return false
end


local telequeue = {}
local setpos = ENTITY.SetPos
function PLAYER:SetPos(pos)
	telequeue[self] = pos
end

hook.Add('FinishMove', 'SetPos.FinishMove', function(pl)
	if telequeue[pl] then
		setpos(pl, telequeue[pl])
		telequeue[pl] = nil
		return true
	end
end)