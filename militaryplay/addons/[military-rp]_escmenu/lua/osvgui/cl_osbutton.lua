local BUTTON = {}

BUTTON.Click = nil

function BUTTON:Init()
	self:SetContentAlignment(5)

	self:SetTall(24)
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( "hand" )
	self.SizeFont = self:GetTall() - 4
	self.Text = 'Button'

	self.Cooldown = 0
	self.NextClick = 0

	self.Disabled = false

	self.Color = Color(0, 165, 80)
	self.HoverColor = Color(0, 219, 106)
	self.TextColor = Color(255, 255, 255)
	self.TextColorHover = Color(225, 225, 225)
	self.Alpha = 0

	self.drawBG = true
end

function BUTTON:SetDisabled(bool)
	self.Disabled = bool
end

function BUTTON:GetDisabled()
	return self.Disabled
end

function BUTTON:SetCooldown(amt)
	self.Cooldown = amt
end

function BUTTON:GetCooldown()

	local c = math.floor(self.NextClick - CurTime())
	local cd = math.Clamp(c, 0, self.Cooldown)

	return cd
end

function BUTTON:SetText(text)
	if not isstring(text) then return end
	
	self.Text = text
end

function BUTTON:SetSizeFont(num)
	self.SizeFont = num
end

function BUTTON:GetSizeFont()
	return self.SizeFont
end

function BUTTON:SetColorText(color, color2)
	self.TextColor = color
	if color2 then
		self.TextColorHover = color2
	end
end

function BUTTON:GetColorText()
	return self.TextColor, self.TextColorHover
end

function BUTTON:SetDrawBackground(boolean)
	self.drawBG = boolean
end

function BUTTON:IsDrawBackground()
	return self.drawBG
end


function BUTTON:OnMousePressed()

	if self.NextClick > CurTime() then return end

	if self.Cooldown > 0 then
		self.NextClick = CurTime() + self.Cooldown
	end

	if self.Disabled == true then return end

	if self.Click ~= nil then
		self.Click(self)
	end
end

vgui.Register('oseanButton', BUTTON, 'Panel')
