local net = net
local nw = nw
local mp = mp

PLAYER.OldName = PLAYER.OldName or PLAYER.Name

local PLAYER = PLAYER

function PLAYER:isHandcuffed()
	return self:GetNetVar("isHandcuffed") or false
end

function PLAYER:isCarry()
	return self:GetNetVar("isCarry")
end

function PLAYER:isCarried()
	return self:GetNetVar("isCarried")
end

function PLAYER:IsNATO()
	local TEAM = self:Team()
	local faction = (mp.jobs[TEAM] and mp.jobs[TEAM].faction) and mp.jobs[TEAM].faction or false

	return faction and faction == "nato" or false
end

function PLAYER:IsRF()
	local TEAM = self:Team()
	local faction = (mp.jobs[TEAM] and mp.jobs[TEAM].faction) and mp.jobs[TEAM].faction or false

	return faction and faction == "rf" or false
end

function PLAYER:GetFaction()
	local TEAM = self:Team()
	local faction = (mp.jobs[TEAM] and mp.jobs[TEAM].faction) and mp.jobs[TEAM].faction or false

	return faction
end

function PLAYER:Name()
	local rpname = self:Nick()
	if self:GetNetVar("rpname") then
		rpname = self:GetNetVar("rpname")
	end

	return rpname
end

function PLAYER:FeatureName()
	local name
	local p = self:GetNetVar("meta_features")

	if p then
		name = mp.profession[p] and mp.profession[p].name
	end

	return name or "Отсутствует"
end

function PLAYER:GetRPID()
	return self:GetNetVar("meta_rpid") or 0
end

function PLAYER:NameWithSteamID()
	local name = self:Name() or self:OldName()
	return name .. "(" .. self:SteamID() .. ")"
end

function PLAYER:GetMoney()
	return self:GetNetVar("meta_money") or 0
end

function PLAYER:GetAccessTeam()
	return self:GetNetVar("meta_access") or {}
end

function PLAYER:isEnoughMoney(intCount)
	return tonumber(self:GetMoney()) >= tonumber(intCount)
end

function GM:PlayerShouldTaunt(pl, actid) return true end

function GM:CanTool(pl, trace, mode) return pl:IsAdmin() end

hook.Add("ShouldCollide", "SpawnPoints_ShouldCollide", function(ent1, ent2)
	if IsValid(ent1) and IsValid(ent2) then
		if (ent1:IsPlayer() and ent2:GetClass() == "spawn_point") or (ent2:IsPlayer() and ent1:GetClass() == "spawn_point") then
			return false
		end

		if ent1:GetClass() == "prop_ragdoll" or ent2:GetClass() == "prop_ragdoll" then
			return false
		end
	end

	return true
end)

function SetTI(n1, n2)
	return math.Round((n1 / 100) * n2)
end

-- LocalPlayer
nw.Register("meta_vehicles")
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetLocalPlayer()

nw.Register("GetPlayerKidnapper")
	:Write(net.WriteEntity)
	:Read(net.ReadEntity)
	:SetLocalPlayer()

-- Player
nw.Register("isHandcuffed")
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register("isCarry")
	:Write(net.WritePlayer)
	:Read(net.ReadPlayer)
	:SetPlayer()

nw.Register("isCarried")
	:Write(net.WritePlayer)
	:Read(net.ReadPlayer)
	:SetPlayer()

nw.Register("ActionPoint")
	:Write(net.WriteUInt, 8)
	:Read(net.ReadUInt, 8)
	:SetPlayer()

nw.Register("Arrested")
	:Write(function(t)
		net.WriteFloat(t.time)
		net.WriteString(t.reason)
		net.WriteEntity(t.actor)
	end)
	:Read(function()
		local t = {
			time = net.ReadFloat(),
			reason = net.ReadString(),
			actor = net.ReadEntity()
		}

		return t
	end)
	:SetPlayer()

nw.Register("GetPlayerHandcuffed")
	:Write(net.WriteEntity)
	:Read(net.ReadEntity)
	:SetPlayer()

nw.Register("meta_money")
	:Write(net.WriteInt, 32)
	:Read(net.ReadInt, 32)
	:SetPlayer()

nw.Register("meta_rank")
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register("meta_features")
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register("rpname")
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register("meta_character")
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register("meta_level")
	:Write(net.WriteInt, 32)
	:Read(net.ReadInt, 32)
	:SetPlayer()

nw.Register("meta_experience")
	:Write(net.WriteInt, 32)
	:Read(net.ReadInt, 32)
	:SetPlayer()

nw.Register("meta_rpid")
	:Write(net.WriteUInt, 16)
	:Read(net.ReadUInt, 16)
	:SetPlayer()

nw.Register("meta_playerid")
	:Write(net.WriteUInt, 16)
	:Read(net.ReadUInt, 16)
	:SetPlayer()

nw.Register("meta_access")
	:Write(function(t)
		net.WriteUInt(table.Count(t), 8)
		for k, v in pairs(t) do
			if not mp.config.access_list[k] then continue end
			net.WriteString(k)
			net.WriteBool(v)
		end
	end)
	:Read(function()
		local t = {}
		for i = 1, net.ReadUInt(8) do
			t[net.ReadString()] = net.ReadBool()
		end
		return t
	end)
	:SetPlayer()

-- Global

-- Entity
