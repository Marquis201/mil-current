local mp = mp

function PLAYER:CheckLimit(str)
	if mp.config.NoLimits[self:GetUserGroup()] then return true end

	local c = mp.config.Limits[str] or 0
	if mp.config.LimitsGroup[self:GetUserGroup()] and mp.config.LimitsGroup[self:GetUserGroup()][str] then
		c = c + mp.config.LimitsGroup[self:GetUserGroup()][str]
	end

	if (c < 0) then return true end
	if (self:GetCount(str) >= c) then
		self:LimitHit(str)
		return false
	end
	return true
end

function PLAYER:GetCount(str, minus)
	if (self._Counts and self._Counts[str]) then
		return self._Counts[str] - (minus or 0)
	end
	return 0
end

function PLAYER:AddCount(str, ent)
	if (SERVER) then
		if not self._Counts then
			self._Counts = {}
		end

		self._Counts[str] = (self._Counts[str] or 0) + 1

		local c = 0

		if mp.config.NoLimits[self:GetUserGroup()] then
			c = 99999
		else
			c = mp.config.Limits[str] and mp.config.Limits[str] or 0
			if mp.config.LimitsGroup[self:GetUserGroup()] and mp.config.LimitsGroup[self:GetUserGroup()][str] then
				c = c + mp.config.LimitsGroup[self:GetUserGroup()][str]
			end
		end

		mp.util.Notify(self, NOTIFY_GENERIC, str .. ": " .. self._Counts[str] .. " из " .. c)

		ent.OnRemoveCount = function() --CallOnRemove is broke
			if IsValid(self) and self._Counts and self._Counts[str] then
				self._Counts[str] = self._Counts[str] - 1
			end
		end
	end
end

function PLAYER:LimitHit(str)
	mp.util.Notify(self, NOTIFY_ERROR, "Вы достигли лимита: " .. str)
end

function PLAYER:AddCleanup(type, ent)
	cleanup.Add(self, type, ent)
end

function PLAYER:GetTool(mode)
	local wep = self:GetWeapon('gmod_tool')
	if (! wep || ! wep:IsValid()) then return nil end

	local tool = wep:GetToolObject(mode)
	if (! tool) then return nil end

	return tool
end

hook('EntityRemoved', function(ent)
	if ent.OnRemoveCount then ent.OnRemoveCount() end
end)
