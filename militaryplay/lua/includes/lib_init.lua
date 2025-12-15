local blacklist = {
	["hook.lua"] = true,
}
local include_sv = (SERVER) and include or function()
	end
local include_cl = (SERVER) and AddCSLuaFile or include
local include_sh = function(path)
	include_sv(path)
	include_cl(path)
end

local files = file.Find("includes/lib/*.lua", "LUA")
for _, v in ipairs(files) do
	if not blacklist[v] then
		local path = "lib/" .. v
		include_sh(path)
	end
end

-- MsgC(Color(255, 0, 0), "Some libs from dash included.\n")
