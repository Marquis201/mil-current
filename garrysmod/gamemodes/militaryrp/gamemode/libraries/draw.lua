local blur = Material("pp/blurscreen", "noclamp")
local render = render
local mp = mp
local ColorAlpha = ColorAlpha
local draw = draw
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime
local netstream = netstream
local Angle, Vector = Angle, Vector
local Color = Color
local vgui = vgui
local ScrW, ScrH = ScrW, ScrH

local round = math.Round

function mp.Wide(w, max)
	max = max or 1920

	return round(w / max * ScrW())
end

function mp.Tall(h, max)
	max = max or 1080

	return round(h / max * ScrH())
end

local function charWrap(text, pxWidth)
	local total = 0

	text = text:gsub(".", function(char)
		total = total + surface.GetTextSize(char)

		if total >= pxWidth then
			total = 0
			return "\n" .. char
		end

		return char
	end)

	return text, total
end

function draw.textWrap(text, font, pxWidth)
	local total = 0

	surface.SetFont(font)

	local spaceSize = surface.GetTextSize(' ')
	text = text:gsub("(%s?[%S]+)", function(word)
		local char = string.sub(word, 1, 1)
		if char == "\n" or char == "\t" then
			total = 0
		end

		local wordlen = surface.GetTextSize(word)
		total = total + wordlen

		-- Wrap around when the max width is reached
		if wordlen >= pxWidth then -- Split the word if the word is too big
			local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
			total = splitPoint
			return splitWord
		elseif total < pxWidth then
			return word
		end

		-- Split before the word
		if char == ' ' then
			total = wordlen - spaceSize
			return '\n' .. string.sub(word, 2)
		end

		total = wordlen
		return '\n' .. word
	end)

	return text
end

function draw.Arc(center, startang, endang, radius, roughness, thickness, color)
	draw.NoTexture()
	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	local segs, p = roughness, {}
	for i2 = 0, segs do
		p[i2] = -i2 / segs * (math.pi / 180) * endang - (startang / 57.3)
	end
	for i2 = 1, segs do
		if endang <= 90 then
			segs = segs / 2
		elseif endang <= 180 then
			segs = segs / 4
		elseif endang <= 270 then
			segs = segs / 6
		else
			segs = segs
		end
		local r1, r2 = radius, math.max(radius - thickness, 0)
		local v1, v2 = p[i2 - 1], p[i2]
		local c1, c2 = math.cos(v1), math.cos(v2)
		local s1, s2 = math.sin(v1), math.sin(v2)
		surface.DrawPoly {
			{ x = center.x + c1 * r2, y = center.y - s1 * r2 },
			{ x = center.x + c1 * r1, y = center.y - s1 * r1 },
			{ x = center.x + c2 * r1, y = center.y - s2 * r1 },
			{ x = center.x + c2 * r2, y = center.y - s2 * r2 },
		}
	end
end

function mp.BoxBlurHUD(cornerRadius, x, y, w, h, size_blur, alpha)
	local scrW, scrH = ScrW(), ScrH()
	local Fraction = 1

	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)
	draw.NoTexture()
	render.UpdateScreenEffectTexture()
	surface.SetDrawColor(color_white)
	draw.DrawRoundedRect(cornerRadius, x, y, w, h, color_white)
	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blur)
	for i = 0.33, size_blur, 0.33 do
		blur:SetFloat("$blur", Fraction * size_blur * (size_blur * .05))
		blur:Recompute()

		if (render) then render.UpdateScreenEffectTexture() end
		render.SetScissorRect(x, y, x + w, y + h, true)
		surface.DrawTexturedRect(0, 0, scrW, scrH)
		render.SetScissorRect(0, 0, 0, 0, false)
	end
	render.SetStencilEnable(false)
	render.ClearStencil()
end

function mp.Icon(x, y, w, h, Mat, tblColor)
	surface.SetMaterial(Mat)
	surface.SetDrawColor(tblColor or color_white)
	surface.DrawTexturedRect(x, y, w, h)
end

function mp.Text(text, font, w, h, color, xalign, yalign)
	draw.SimpleText(text, font, w, h, color, xalign, yalign)
end

function mp.PanelBlur(panel, amount)
	--[[local Fraction = 1
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 0.33, 1, 0.33 do
		blur:SetFloat('$blur', Fraction * amount * i)
		blur:Recompute()
		if (render) then render.UpdateScreenEffectTexture() end
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end]]

	local x, y = panel:LocalToScreen(0, 0)
	local mat = paint.blur.getBlurMaterial()
	local scrW, scrH = ScrW(), ScrH()
	local w, h = panel:GetSize()

	paint.roundedBoxes.roundedBox(0, x, y, w, h, ColorAlpha(color_white, panel:GetAlpha()), mat, x / scrW,
		y / scrH,
		(x + w) / scrW, (y + h) / scrH)
end

function mp.BoxBlur(x, y, w, h, layers, density, alpha)
	local scrW, scrH = ScrW(), ScrH()
	local Fraction = 1

	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blur)

	for i = 0.33, layers, 0.33 do
		blur:SetFloat('$blur', Fraction * 5 * (i / layers) * density)
		blur:Recompute()

		if (render) then render.UpdateScreenEffectTexture() end
		render.SetScissorRect(x, y, x + w, y + h, true)
		surface.DrawTexturedRect(0, 0, scrW, scrH)
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

function draw.DrawCircle(x, y, radius, angle_start, angle_end, color)
	local poly  = {}
	angle_start = angle_start or 0
	angle_end   = angle_end or 360

	poly[1]     = { x = x, y = y }
	for i = math.min(angle_start, angle_end), math.max(angle_start, angle_end) do
		local a = math.rad(i)
		if angle_start < 0 then
			poly[#poly + 1] = { x = x + math.cos(a) * radius, y = y + math.sin(a) * radius }
		else
			poly[#poly + 1] = { x = x - math.cos(a) * radius, y = y - math.sin(a) * radius }
		end
	end
	poly[#poly + 1] = { x = x, y = y }

	draw.NoTexture()
	surface.SetDrawColor(color or color_white)
	surface.DrawPoly(poly)

	return poly
end

function draw.DrawRoundedRect(corner_radius, x, y, w, h, color)
	draw.NoTexture()
	surface.SetDrawColor(color or color_white)

	surface.DrawRect(x + corner_radius, y, w - corner_radius * 2, h)
	surface.DrawRect(x, y + corner_radius, corner_radius, h - corner_radius * 2)
	surface.DrawRect(x + w - corner_radius, y + corner_radius, corner_radius, h - corner_radius * 2)

	draw.DrawCircle(x + corner_radius, y + corner_radius, corner_radius, -180, -90, color)
	draw.DrawCircle(x + w - corner_radius, y + corner_radius, corner_radius, -90, 0, color)
	draw.DrawCircle(x + corner_radius, y + h - corner_radius, corner_radius, -270, -180, color)
	draw.DrawCircle(x + w - corner_radius, y + h - corner_radius, corner_radius, 270, 180, color)
end

function mp.Pattern(cornerRadius, x, y, w, h, x1, y2, w2, h2, material, color)
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.SetStencilFailOperation(STENCIL_REPLACE)

	draw.NoTexture()
	draw.DrawRoundedRect(cornerRadius, x, y, w, h, color_white)

	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)

	surface.SetDrawColor(color)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x1 - 1, y2 - 1, w2, h2)

	render.SetStencilEnable(false)
end

function mp.UIBlurBox(panel, cornerRadius, x, y, w, h, size_blur)
	local scrW, scrH = ScrW(), ScrH()
	local scrX, scrY = panel:LocalToScreen(0, 0)
	local Fraction = 1

	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)
	draw.NoTexture()
	render.UpdateScreenEffectTexture()
	surface.SetDrawColor(Color(255, 255, 255, 255))
	draw.DrawRoundedRect(cornerRadius, x, y, w, h, color_white)
	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 0.33, size_blur, 0.33 do
		blur:SetFloat("$blur", Fraction * size_blur * (size_blur * .05))
		blur:Recompute()

		if (render) then render.UpdateScreenEffectTexture() end
		surface.DrawTexturedRect(scrX * -1, scrY * -1, scrW, scrH)
	end
	render.SetStencilEnable(false)
	render.ClearStencil()
end

function mp.BlurBG(panel, amount)
	--[[local Fraction = 1

	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	local wasEnabled = DisableClipping(true)

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 0.33, 2, 0.33 do
		blur:SetFloat("$blur", Fraction * amount * i)
		blur:Recompute()
		if (render) then render.UpdateScreenEffectTexture() end
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end

	DisableClipping(wasEnabled)]]
	local x, y = panel:LocalToScreen(0, 0)
	local mat = paint.blur.getBlurMaterial()
	local scrW, scrH = ScrW(), ScrH()

	paint.roundedBoxes.roundedBox(0, x, y, scrW, scrH, ColorAlpha(color_white, panel:GetAlpha()), mat, x / scrW, y / scrH,
		(x + scrW) / scrW, (y + scrH) / scrH)
end

local font

function mp.ToolTip(parent, text, color)
	if IsValid(TOOL_TIP) then TOOL_TIP:Remove() end

	local col = ColorAlpha(color, 15)
	font = font or mp.font('20:Montserrat Light')

	local ToolTip = vgui.Create("DLabel")
	TOOL_TIP = ToolTip
	TOOL_TIP:SetText('')
	TOOL_TIP:SetFont(font)
	TOOL_TIP:SetContentAlignment(5)
	TOOL_TIP:SetWrap(true)

	surface.SetFont(font)
	local tw, th = surface.GetTextSize(text)

	--TOOL_TIP:SetPos(ScrW()*.5-tw*.5+16, ScrH()-y)
	TOOL_TIP:SetSize(tw + 10, th + 6)
	TOOL_TIP:SetAlpha(0)
	TOOL_TIP:AlphaTo(255, 0.5, 0)
	TOOL_TIP.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE_TO)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, col)
		mp.Icon(0, 0, w / 2, h, mp.Material.GRADIENT_L, col)

		mp.Text(text, font, 5, h * .5, mp.Color.WHITE, 0, 1)
	end

	parent.OnCursorExited = function()
		if IsValid(TOOL_TIP) then
			TOOL_TIP:AlphaTo(0, 0.2, 0, function()
				TOOL_TIP:Remove()
			end)
		end

		if not IsValid(parent) then
			if IsValid(TOOL_TIP) then
				TOOL_TIP:AlphaTo(0, 0.2, 0, function()
					TOOL_TIP:Remove()
				end)
			end
		end
	end

	local pos_cursor = input.GetCursorPos()

	TOOL_TIP.Hover = pos_cursor
	function TOOL_TIP:Think()
		local sx, sy = self:CursorPos()
		local x, y = input.GetCursorPos()

		self.Hover = Lerp(FrameTime() * 10, self.Hover, x)

		if not self:IsHovered() then
			self:AlphaTo(0, 0.2, 5, function()
				self:Remove()
			end)
		end

		if not IsValid(parent) then
			if IsValid(self) then
				self:AlphaTo(0, 0.2, 0, function()
					self:Remove()
				end)
			end
			return
		end


		local lockX = math.Clamp(self.Hover + 28, 0, ScrW() - self:GetWide())
		local lockY = math.Clamp(y - 28, 0, ScrH() - self:GetTall())

		self:SetPos(lockX, lockY)
		self:MakePopup()
	end
end
