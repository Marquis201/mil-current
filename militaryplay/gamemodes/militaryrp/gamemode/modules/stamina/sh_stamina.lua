function PLAYER:GetAP()
	return self:GetNetVar('ActionPoint') or 0
end

function PLAYER:GetMaxAP()
	return 100
end
