local meta = meta
local FindMetaTable = FindMetaTable
local SERVER = SERVER

local include_sv = (SERVER) and include or function() end
local include_cl = (SERVER) and AddCSLuaFile or include
local include_sh = function(f)
	include_sv(f)
	include_cl(f)
end

PLAYER = FindMetaTable "Player"
ENTITY = FindMetaTable "Entity"
VECTOR = FindMetaTable "Vector"

local function include_load(fileName, strState)
	if ((strState == "server" or string.find(fileName, "sv_")) and SERVER) then
		include_sv(fileName)
	elseif (strState == "shared" or string.find(fileName, "sh_")) then
		include_sh(fileName)
	elseif (strState == "client" or string.find(fileName, "cl_")) then
		include_cl(fileName)
	end
end

local function include_dir(directory, re)
	local fol = GM.FolderName .. "/gamemode/" .. directory .. "/"

	for k, v in ipairs(file.Find(fol .. "*", "LUA")) do
		local fileName = directory .. "/" .. v
		include_load(fileName)
	end

	if re == true then
		local _, folders = file.Find(fol .. "*", "LUA")
		if folders then
			for _, f in ipairs(folders) do
				include_dir(directory .. "/" .. f)
			end
		end
	end
end

local libraries_isload

if ! libraries_isload then
	include_sh "libraries/pon.lua"
	include_sh "libraries/netstream.lua"
	include_sh "libraries/nw.lua"
	include_cl "libraries/draw.lua"

	libraries_isload = true
end

--	dir

include_dir("core/sandbox", true)
include_dir("core/derma", false)
include_dir("core", false)

--	sh

include_sh "config/sh_jobs_config.lua"
include_sh "config/sh_config.lua"
include_sh "core/sh_player.lua"
include_sh "core/sh_playerclass.lua"

--	sv

include_sv "config/sv_mysql_config.lua"
include_sv "core/sv_player.lua"

--	cl

include_cl "core/cl_core.lua"

hook.Run("PreLoadModules")

include_dir("modules", true)

hook.Run("OnLoadModules")
