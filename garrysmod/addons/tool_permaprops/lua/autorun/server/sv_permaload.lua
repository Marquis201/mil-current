/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
*/
PermaProps = PermaProps || {}


local S, _ = file.Find("permaprops/sv_*.lua", "LUA")

local H, _ = file.Find("permaprops/sh_*.lua", "LUA")

local C, _ = file.Find("permaprops/cl_*.lua", "LUA")

for z = 1, #S do
	local x = S[z]
	include("permaprops/".. x)
end


for z = 1, #H do
	local x = H[z]
	AddCSLuaFile("permaprops/".. x)
	include("permaprops/".. x)
end

for z = 1, #C do
	local x = C[z]
	AddCSLuaFile("permaprops/".. x)
end

print("[Tools]", 'PermaProps загружен.')