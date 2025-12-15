math.randomseed(os.time())
math.randomseed((os.time() * math.random(2)) + math.random(111111, 999999))

--[[---------------------------------------------------------
	Find an empty Vector
-----------------------------------------------------------]]
local Vector = Vector
local ents_FindInSphere = ents.FindInSphere
local util_PointContents = util.PointContents

local badpoints = {
	[CONTENTS_SOLID] = true,
	[CONTENTS_MOVEABLE] = true,
	[CONTENTS_LADDER] = true,
	[CONTENTS_PLAYERCLIP] = true,
	[CONTENTS_MONSTERCLIP] = true
}

local out = {}
local tr = {
	mins = Vector(-16, -16, 0),
	maxs = Vector(16, 16, 71),
	output = out
}

local function isempty(pos, area)
	if badpoints[util_PointContents(pos)] then
		return false
	end
	local entities = ents_FindInSphere(pos, area)
	for i = 1, #entities do
		if (entities[i]:GetClass() == "prop_physics") or (entities[i]:IsPlayer() and entities[i]:Alive()) then
			return false
		end
	end


	tr.start = pos
	tr.endpos = pos
	util.TraceHull(tr)
	if out.Hit then
		return false
	end

	return true
end

function util.FindEmptyPos(pos, area, steps)
	area = area or 35

	if isempty(pos, area) then
		return pos
	end

	for i = 1, (steps or 6) do
		local step = (i * 50)
		if isempty(Vector(pos.x + step, pos.y, pos.z), area) then
			pos.x = pos.x + step
			return pos
		elseif isempty(Vector(pos.x, pos.y + step, pos.z), area) then
			pos.y = pos.y + step
			return pos
		elseif isempty(Vector(pos.x, pos.y, pos.z + step), area) then
			pos.z = pos.z + step
			return pos
		end
	end

	return pos
end

function IsValid(object)
	if (not object) then
		return false
	end

	local isvalid = object.IsValid
	if (not isvalid) then
		return false
	end

	return isvalid(object)
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
local function GetTextSize(x)
	return x:len(), 1
end

local function PrintType(x)
	if (IsColor(x)) then
		return "Color"
	end
	if (TypeID(x) == TYPE_ENTITY) then
		if (x:IsPlayer()) then
			return "Player"
		end
		return "Entity"
	end
	return type(x)
end

local function FixTabs(x, width)
	local curw = GetTextSize(x)
	local ret = ""
	while (curw < width) do -- not using string.rep since linux
		x = x .. " "
		ret = ret .. " "
		curw = GetTextSize(x)
	end
	return ret
end

local typecol = {
	boolean = Color(0x98, 0x81, 0xF5),
	["function"] = Color(0x00, 0xC0, 0xB6),
	number = Color(0xF9, 0xD0, 0x8B),
	string = Color(0xF9, 0x8D, 0x81),
	table = Color(040, 175, 140),
	func = Color(0x82, 0xAF, 0xF9),
	etc = Color(0xF0, 0xF0, 0xF0),
	unk = Color(255, 255, 255),
	com = Color(0x00, 0xB0, 0x00)
}

local replacements = {
	["\n"] = "\\n",
	["\r"] = "\\r",
	["\v"] = "\\v",
	["\f"] = "\\f",
	["\x00"] = "\\x00",
	["\\"] = "\\\\",
	["'"] = "\\'"
}

local ConversionLookupTable = {
	string = function(obj, iscom)
		return {typecol.string, "'" .. obj:gsub(".", replacements) .. "'"} -- took from string.lua
	end,
	Vector = function(obj, iscom)
		return {
			typecol.func,
			"Vector",
			typecol.etc,
			"(",
			typecol.number,
			tostring(obj.x),
			typecol.etc,
			", ",
			typecol.number,
			tostring(obj.y),
			typecol.etc,
			", ",
			typecol.number,
			tostring(obj.z),
			typecol.etc,
			")"
		}
	end,
	Angle = function(obj, iscom)
		return {
			typecol.func,
			"Angle",
			typecol.etc,
			"(",
			typecol.number,
			tostring(obj.p),
			typecol.etc,
			", ",
			typecol.number,
			tostring(obj.y),
			typecol.etc,
			", ",
			typecol.number,
			tostring(obj.r),
			typecol.etc,
			")"
		}
	end,
	Color = function(obj, iscom)
		return {
			typecol.func,
			"Color",
			typecol.etc,
			"(",
			typecol.number,
			tostring(obj.r),
			typecol.etc,
			", ",
			typecol.number,
			tostring(obj.g),
			typecol.etc,
			", ",
			typecol.number,
			tostring(obj.b),
			typecol.etc,
			", ",
			typecol.number,
			tostring(obj.a),
			typecol.etc,
			")"
		}, true
	end,
	Player = function(obj, iscom)
		return {
			typecol.func,
			"Player",
			typecol.etc,
			"[",
			typecol.number,
			tostring(obj:UserID()),
			typecol.etc,
			"]",
			typecol.com,
			(iscom and "[" .. (obj:IsValid() and obj.Nick and obj:Nick() or "missing_nick") or "") .. "]"
		}, true
	end
}

local function DebugFixToStringColored(obj, iscom)
	local type = PrintType(obj)
	if (ConversionLookupTable[type]) then
		return ConversionLookupTable[type](obj, iscom)
	end
	if (not typecol[type]) then
		return {typecol.unk, "(" .. type .. ") " .. tostring(obj)}
	else
		return {typecol[type], tostring(obj)}
	end
end

local function DebugFixToString(obj, iscom)
	local ret = ""
	local rets, osc = DebugFixToStringColored(obj, iscom)
	for i = 2, #rets, 2 do
		ret = ret .. rets[i]
	end
	return ret
end

function PrintTable(tbl, spaces, done)
	local buffer = {}
	local rbuf = {}
	local maxwidth = 0
	local spaces = spaces or 0
	local done = done or {}
	done[tbl] = true
	for key, val in pairs(tbl) do
		rbuf[#rbuf + 1] = key
		buffer[#buffer + 1] = "[" .. DebugFixToString(key) .. "] "
		maxwidth = math.max(GetTextSize(buffer[#buffer]), maxwidth)
	end
	local str = string.rep(" ", spaces)
	if (spaces == 0) then
		MsgN("\n")
	end
	if #buffer > 0 then
		MsgC(typecol.etc, "{\n")
		local tabbed = str .. string.rep(" ", 4)

		for i = 1, #buffer do
			local overridesc = false
			local key = rbuf[i]
			local value = tbl[key]
			MsgC(typecol.etc, tabbed .. "[")
			MsgC(unpack((DebugFixToStringColored(key))))
			MsgC(typecol.etc, "] " .. FixTabs(buffer[i], maxwidth), typecol.etc, "= ")
			if (type(value) == "table" and not IsColor(value) and not done[value]) then
				PrintTable(tbl[key], spaces + 4, done)
			else
				local args, osc = DebugFixToStringColored(value, true)
				overridesc = osc
				MsgC(unpack(args))
			end
			if (not overridesc) then
				MsgC(typecol.etc, ",")
			end
			MsgN ""
		end
		MsgC(typecol.etc, str .. "}")
	else
		MsgC(typecol.etc, "{")
		MsgC(typecol.etc, "}")
	end
	if (spaces == 0) then
		MsgN ""
	end
end

if CLIENT then
	local SetFont = surface.SetFont
	local GetTextSize = surface.GetTextSize

	local font = "TargetID"
	local cache =
		setmetatable(
		{},
		{
			__mode = "k"
		}
	)

	timer.Create(
		"surface.ClearFontCache",
		1800,
		0,
		function()
			for i = 1, #cache do
				cache[i] = nil
			end
		end
	)

	function surface.SetFont(_font)
		font = _font
		return SetFont(_font)
	end

	function surface.GetTextSize(text)
		if (not cache[font]) then
			cache[font] = {}
		end
		if (not cache[font][text]) then
			local w, h = GetTextSize(text)
			cache[font][text] = {
				[1] = w,
				[2] = h
			}
			return w, h
		end
		return cache[font][text][1], cache[font][text][2]
	end

	function util.GetTextSize(text, font)
		if not font then
			font = "Default"
		end
		surface.SetFont(font)
		local w, h = surface.GetTextSize(text)
		return w, h
	end

	--1 символ - 8 пикселей(в среднем)
	function util.PixelsToSymbols(pixels)
		if pixels <= 8 then
			return 8
		end
		return math.ceil(pixels / 8)
	end
end

function util.SecondsToClock(seconds)
	seconds = tonumber(seconds)
	if seconds <= 0 then
		return "00:00:00"
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
		return hours .. ":" .. mins .. ":" .. secs
	end
end

function class(obj)
	local new = {}
	obj.__index = obj
	setmetatable(new, obj)
	return new
end