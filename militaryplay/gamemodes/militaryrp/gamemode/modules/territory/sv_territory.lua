local util = util
local mp = mp
local hook = hook
local IsValid = IsValid
local CurTime = CurTime
local timer = timer

local nw = { "" }

for k, v in ipairs(nw) do
	util.AddNetworkString("mp.Territory." .. v)
end
