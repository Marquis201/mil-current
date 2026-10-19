local tonumber 		= tonumber
local string_format = string.format
local string_match 	= string.match
local bit_band		= bit.band
local bit_rshift 	= bit.rshift
local Lerp 			= Lerp

local COLOR = {}
COLOR.__index = COLOR

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]

debug.getregistry().Color = COLOR

--[[---------------------------------------------------------
	To easily create a color table
-----------------------------------------------------------]]
function Color( r, g, b, a )

	a = a or 255
	return setmetatable( { r = math.min( tonumber(r), 255 ), g =  math.min( tonumber(g), 255 ), b =  math.min( tonumber(b), 255 ), a =  math.min( tonumber(a), 255 ) }, COLOR )

end

--[[---------------------------------------------------------
	Change the alpha of a color
-----------------------------------------------------------]]
function ColorAlpha( c, a )

	return Color( c.r, c.g, c.b, a )

end

--[[---------------------------------------------------------
	Checks if the given varible is a color object
-----------------------------------------------------------]]
function IsColor( obj )

	return getmetatable(obj) == COLOR

end


--[[---------------------------------------------------------
	Returns color as a string
-----------------------------------------------------------]]
function COLOR:__tostring()

	return string.format( "%d %d %d %d", self.r, self.g, self.b, self.a )

end

--[[---------------------------------------------------------
	Compares two colors
-----------------------------------------------------------]]
function COLOR:__eq( c )

	return self.r == c.r and self.g == c.g and self.b == c.b and self.a == c.a

end

--[[---------------------------------------------------------
	Converts a color to HSL color space
-----------------------------------------------------------]]
function COLOR:ToHSL()

	return ColorToHSL( self )

end

--[[---------------------------------------------------------
	Converts a color to HSV
-----------------------------------------------------------]]
function COLOR:ToHSV()

	return ColorToHSV( self )

end

--[[---------------------------------------------------------
	Converts color to vector - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToVector()

	return Vector( self.r / 255, self.g / 255, self.b / 255 )

end

--[[---------------------------------------------------------
	Unpacks the color into four variables
-----------------------------------------------------------]]
function COLOR:Unpack()

	return self.r, self.g, self.b, self.a

end

function COLOR:SetUnpacked( r, g, b, a )

	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255

end

function COLOR:ToTable()

	return { self.r, self.g, self.b, self.a }

end

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
	self.r, self.g, self.b, self.a = bit_band(bit_rshift(num, 16), 0xFF), bit_band(bit_rshift(num, 8), 0xFF), bit_band(num, 0xFF), bit_band(bit_rshift(num, 24), 0xFF)
end

function COLOR:ToEncodedRGBA()
	return ((self.a * 0x100 + self.r) * 0x100 + self.g) * 0x100 + self.b
end

function COLOR:LerpC(fraction, from, to)
	self.r, self.g, self.b = Lerp(fraction, from.r, to.r), Lerp(fraction, from.g, to.g), Lerp(fraction, from.b, to.b)
end

function COLOR:Lerp(target_clr, frac)
	return Color( Lerp( frac, self.r, target_clr.r ), Lerp( frac, self.g, target_clr.g ), Lerp( frac, self.b, target_clr.b ), Lerp( frac, self.a, target_clr.a ) )
end

function COLOR:IsLight()
	local _, _, l = ColorToHSL(self)
	return l >= .5
end

function COLOR:InverseLight(color, snap)
	color = color or color_white
	local _, _, l = ColorToHSL(self)
	local h, s, _ = ColorToHSL(color)

	return HSLToColor(h, s, snap and math.Round(1 - l) or (1 - l))
end