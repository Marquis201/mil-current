local mp = mp

nw.Register("mp.Properties"):Write(net.WriteTable):Read(net.ReadTable):SetGlobal()
nw.Register("mp.Doors"):Write(net.WriteTable):Read(net.ReadTable):SetGlobal()
nw.Register("mp.DoorIsLocked"):Write(net.WriteBool):Read(net.ReadBool)
nw.Register("mp.DoorsGroup"):Write(net.WriteTable):Read(net.ReadTable):SetGlobal()

mp.properties = mp.properties or {}

local door_classes = {
	["func_door_rotating"] = true,
	["prop_door_rotating"] = true,
	["func_movelinear"]    = true,
	["prop_dynamic"]       = false,
	["func_door"]          = true,
}

function ENTITY:IsDoor()
	if not IsValid(self) then return false end

	return door_classes[self:GetClass()]
end

function ENTITY:GetPropertyTable()
	local _properties = nw.GetGlobal("mp.Properties")
	if not _properties then return end

	local doors = nw.GetGlobal("mp.Doors")
	if not doors then return end

	return _properties[doors[self:EntIndex()]]
end

function ENTITY:DoorState()
	local st = self:GetSaveTable()
	return st.m_eDoorState
end

function ENTITY:IsProperty()
	return self:GetPropertyTable() and true or false
end

function ENTITY:GetPropertyClose()
	return self:GetNetVar("mp.DoorIsLocked") and true or false
end

function ENTITY:GetPropertyName()
	return self:GetPropertyTable().name
end

function ENTITY:GetPropertyCost()
	return self:GetPropertyTable().cost
end

function ENTITY:IsPropertyOwned()
	return (self:IsProperty() and self:GetPropertyTable().owner) and true or false
end

function ENTITY:IsPropertyGangOwned()
	return self:GetPropertyTable().gang or false
end

function ENTITY:GetPropertyCoowners()
	return self:GetPropertyTable().coowners or {}
end

function ENTITY:GetPropertyOwner()
	return self:GetPropertyTable().owner
end

function ENTITY:IsPropertyGroupOwned()
	return (self:IsProperty() and self:GetPropertyTable().group) and true or false
end

function ENTITY:GetPropertyGroupName()
	return self:GetPropertyTable().group
end

function ENTITY:GetPropertyGroupColor()
	return mp.properties.GetGroup()[self:GetPropertyGroupName()].col
end

function ENTITY:GetPropertyGroupTeams()
	return mp.properties.GetGroup()[self:GetPropertyGroupName()].teams
end

function PLAYER:IsOwnsProperty(ent)
	return ent:GetPropertyOwner() == self
end

function PLAYER:IsCoownsProperty(ent)
	return ent:GetPropertyCoowners()[self]
end

function mp.properties.GetGroup()
	return nw.GetGlobal("mp.DoorsGroup") or {}
end

function mp.addDoorGroup(name, col, faction)
	local groups = mp.properties.GetGroup()

	groups[name] = {}
	groups[name].col = col
	groups[name].teams = groups[name].teams or {}

	for k, v in pairs(mp.jobs) do
		if v.faction and v.faction == faction then
			groups[name].teams[k] = true
		end
	end

	nw.SetGlobal("mp.DoorsGroup", groups)
end
