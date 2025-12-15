if CLIENT then
	function string:ExplodeBySize(size)
		local tbl = Stack()
		local strLen = utf8.len(self)
		for i = 1, strLen, size do
			tbl:Push(self:utf8sub(i, i + size - 1))
		end
		return tbl
	end

	local surface_SetFont = surface.SetFont
	local surface_GetTextSize = surface.GetTextSize
	local string_Explode = string.Explode
	local ipairs = ipairs

	function string.Wrap(font, text, width)
		surface_SetFont(font)

		local sw = surface_GetTextSize(" ")
		local ret = {}

		local w = 0
		local s = ""

		local t = string_Explode("\n", text)
		for i = 1, #t do
			local t2 = string_Explode(" ", t[i], false)
			for i2 = 1, #t2 do
				local neww = surface_GetTextSize(t2[i2])

				if (w + neww >= width) then
					ret[#ret + 1] = s
					w = neww + sw
					s = t2[i2] .. " "
				else
					s = s .. t2[i2] .. " "
					w = w + neww + sw
				end
			end
			ret[#ret + 1] = s
			w = 0
			s = ""
		end

		if (s ~= "") then
			ret[#ret + 1] = s
		end

		return ret
	end
end

-- Faster implementation
local totable = string.ToTable
local string_sub = string.sub
local string_find = string.find
local string_len = string.len
function string.Explode(separator, str, withpattern)
	if (separator == '') then return totable(str) end

	if withpattern == nil then
		withpattern = false
	end

	local ret = {}
	local current_pos = 1

	for i = 1, string_len(str) do
		local start_pos, end_pos = string_find(str, separator, current_pos, not withpattern)
		if not start_pos then break end
		ret[i] = string_sub(str, current_pos, start_pos - 1)
		current_pos = end_pos + 1
	end

	ret[#ret + 1] = string_sub(str, current_pos)

	return ret
end