

if not system.IsLinux() then
	return
end

local function f_Channels(f)
	f:Seek(22)
	local bytes = {}
	for i = 1, 2 do
		bytes[i] = f:ReadByte(1)
	end
	local num = bit.lshift(bytes[2], 8) + bit.lshift(bytes[1], 0)
	return num
end

local function f_SampleDepth(f)
	f:Seek(34)
	local bytes = {}
	for i = 1, 2 do
		bytes[i] = f:ReadByte(1)
	end
	local num = bit.lshift(bytes[2], 8) + bit.lshift(bytes[1], 0)
	return num
end

local function f_SampleRate(f)
	f:Seek(24)
	local bytes = {}
	for i = 1, 4 do
		bytes[i] = f:ReadByte(1)
	end
	local num = bit.lshift(bytes[4], 24) + bit.lshift(bytes[3], 16) + bit.lshift(bytes[2], 8) + bit.lshift(bytes[1], 0)
	return num
end

local function f_Duration(f)
	return (f:Size() - 44) / (f_SampleDepth(f) / 8 * f_SampleRate(f) * f_Channels(f))
end

local function isWav(f)
	f:Seek(8)
	return f:Read(4) == "WAVE"
end

_SoundDuration = _SoundDuration or SoundDuration
SoundDuration = function(str)
	local f = file.Open("sound/" .. str, "rb", "GAME")
	if not f then
		return 0
	end

	local ret
	if isWav(f) then
		ret = f_Duration(f)
	else
		ret = _SoundDuration(str)
	end
	f:Close()
	return ret
end
