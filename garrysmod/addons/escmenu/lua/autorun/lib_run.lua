oseanlib = oseanlib or {}

function oseanlib.ConsoleMsg(text)
	MsgC(Color(255, 0, 255), 'oseanLIB ~ ')
	MsgC(Color(200, 200, 200), text .. '\n')
end

local function fileMsg(text)
	oseanlib.ConsoleMsg('Загрузка директории: ' .. text)
end

function oseanlib.loadCL(path)
	if (CLIENT) then
		include(path)
	end

	if (SERVER) then
		AddCSLuaFile(path)
	end
end

function oseanlib.loadSV(path)
	if (SERVER) then
		include(path)
	end
end

function oseanlib.loadSH(path)
	oseanlib.loadSV(path)
	oseanlib.loadCL(path)
end

function oseanlib.LoadFolder(path, text)
	path = path .. '/'
	local sh_find = file.Find(path .. 'sh_*.lua', 'LUA')
	local cl_find = file.Find(path .. 'cl_*.lua', 'LUA')
	local sv_find = file.Find(path .. 'sv_*.lua', 'LUA')

	if SERVER then fileMsg(path) end

	for _, file in pairs(sh_find) do
		local full_path = path .. file
		oseanlib.loadSH(full_path)
	end

	for _, file in pairs(cl_find) do
		local full_path = path .. file
		oseanlib.loadCL(full_path)
	end

	for _, file in pairs(sv_find) do
		local full_path = path .. file
		oseanlib.loadSV(full_path)
	end

end

oseanlib.LoadFolder('osuilib')
oseanlib.LoadFolder('osui')
oseanlib.LoadFolder('osvgui')
oseanlib.LoadFolder('oslibs')