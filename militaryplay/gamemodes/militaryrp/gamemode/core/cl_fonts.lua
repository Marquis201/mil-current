local mp = mp
local surface = surface

mp.fonts = mp.fonts or {}

function mp.font(name)
	if mp.fonts[name] then return mp.fonts[name] end
	local font, size
	if isnumber(name) then
		font = 'Default'
		size = name
	elseif isstring(name) then
		local sizen, fontn = string.match(name, '(.*):(.*)')
		if sizen and fontn then
			size = tonumber(sizen) or 10
			font = fontn
		else
			mp.fonts[name] = name
			return mp.fonts[name]
		end
	end
	mp.fonts[name] = 'mp_font.' .. size .. '.' .. font
	surface.CreateFont(mp.fonts[name], {
		font = font,
		size = size,
		weight = 0,
		antialias = true,
		extended = true,
	})
	return mp.fonts[name]
end
