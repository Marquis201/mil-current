local tonumber 		= tonumber
local string_format = string.format
local string_match 	= string.match
local bit_band		= bit.band
local bit_rshift 	= bit.rshift
local Lerp 			= Lerp

local _R = debug.getregistry()
local COLOR = _R.Color

function Color(r, g, b, a)
	return setmetatable({
		r = tonumber(r) or 255,
		g = tonumber(g) or 255,
		b = tonumber(b) or 255,
		a = tonumber(a) or 255
	}, COLOR)
end

function COLOR:Copy()
	return Color(self.r, self.g, self.b, self.a)
end

function COLOR:Unpack()
	return self.r, self.g, self.b, self.a
end

function COLOR:SetHex(hex)
	local r, g, b = string_match(hex, '#(..)(..)(..)')
	self.r, self.g, self.b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

function COLOR:ToHex()
	return string_format('#%02X%02X%02X', self.r, self.g, self.b)
end

function COLOR:SetEncodedRGB(num)
	self.r, self.g, self.b = bit_band(bit_rshift(num, 16), 0xFF), bit_band(bit_rshift(num, 8), 0xFF), bit_band(num, 0xFF)
end

function COLOR:ToEncodedRGB()
	return (self.r * 0x100 + self.g) * 0x100 + self.b
end

function COLOR:SetEncodedRGBA(num)
	self.r, self.g, self.b, self.a = bit_band(rshift(num, 16), 0xFF), bit_band(rshift(num, 8), 0xFF), bit_band(num, 0xFF), bit_band(rshift(num, 24), 0xFF)
end

function COLOR:ToEncodedRGBA()
	return ((self.a * 0x100 + self.r) * 0x100 + self.g) * 0x100 + self.b
end

function COLOR:Lerp(fraction, from, to)
	self.r, self.g, self.b = Lerp(fraction, from.r, to.r), Lerp(fraction, from.g, to.g), Lerp(fraction, from.b, to.b), Lerp(fraction, from.a, to.a)
end

function COLOR:darken(amt)
	return Color(
		math.Clamp(self.r - amt, 0, 255),
		math.Clamp(self.g - amt, 0, 255),
		math.Clamp(self.b - amt, 0, 255),
		self.a
	)
end

function COLOR:lighten(amt)
	return Color(
		math.Clamp(self.r + amt, 0, 255),
		math.Clamp(self.g + amt, 0, 255),
		math.Clamp(self.b + amt, 0, 255),
		self.a
	)
end

function util.HexToColor(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function util.ColorToHex(color)
	local hexadecimal = '#'

	for key = 1, #color do
	    local value = color[key] 
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'
		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end

local old_color = Color
function Color(r, g, b, a)
	if isstring(r) then
		if r:sub(1, 1) == "#" then
			return util.HexToColor(r)
		else
			return Color(255, 255, 255)
		end
	else
		return old_color(r, g, b, a)
	end
end