function ENTITY:IsProp()
	return (self:GetClass() == 'prop_physics') or false
end

function ENTITY:CPPIGetOwner()
	return self:GetNetVar("IsOwner") or false
end
