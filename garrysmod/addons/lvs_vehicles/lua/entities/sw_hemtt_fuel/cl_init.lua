include("shared.lua")
DEFINE_BASECLASS( "lvs_base_wheeldrive" )
LVS:AddHudEditor( "Fuel", ScrW() - 680, ScrH() - 85,  220, 75, 220, 75, "Fuel", 
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintFuelText then return end

		vehicle:LVSHudPaintFuelText( X, Y, W, H, ScrX, ScrY, ply )
	end
)
function ENT:LVSHudPaintFuelText( X, Y, W, H, ScrX, ScrY, ply )
	local Fuel = self:GetFuelTank():GetFuel()
	local Col = Fuel <= 1 and color_white or Color(0,0,0,255)
	local hX = X + W - H * 0.5
	local hY = Y + H * 0.25 + H * 0.25

	surface.SetMaterial( Material( "icons/fuel.png" ) )
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawTexturedRectRotated( hX + 4, hY + 1, H * 0.4, H * 0.4, 0 )
	surface.SetDrawColor( color_white )
	surface.DrawTexturedRectRotated( hX + 2, hY - 1, H * 0.4, H * 0.4, 0 )

	self:LVSDrawCircle( hX, hY, H * 0.35, Fuel )
	draw.DrawText( math.Round(self:GetFuelTank():GetFuel() * 100,1).."%", "LVS_FONT_HUD_LARGE", X + 57, Y + 20, color_white, TEXT_ALIGN_LEFT )
end
function ENT:OnSpawn()
	self:CreateBonePoseParameter( "door_r", 2, Angle(0,0,0), Angle(0,90,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "door_l", 3, Angle(0,0,0), Angle(0,-90,0), Vector(0,0,0), Vector(0,0,0) )
end
function ENT:Think()
	if not self:IsInitialized() then return end

	BaseClass.Think( self )

	self:TireSoundThink()
	self:SetBodygroup(2,1)
	if isfunction( self.UpdatePoseParameters ) then
		self:CalcPoseParameters()
	else
		self:SetPoseParameter( "steer", -self:GetSteer() /  self:GetMaxSteerAngle() )
		self:InvalidateBoneCache()
	end
end

function ENT:Draw( flags )
	if self:PreDraw( flags ) then
		if self.lvsLegacyDraw then
			self:DrawModel() -- ugly, but required in order to fix old addons. Refract wont work on these.
		else
			self:DrawModel( flags )
		end
	end

	self:PostDraw( flags )

	self:DrawHose()
end

local function bezier(p0, p1, p2, p3, t)
	local e = p0 + t * (p1 - p0)
	local f = p1 + t * (p2 - p1)
	local g = p2 + t * (p3 - p2)

	local h = e + t * (f - e)
	local i = f + t * (g - f)

	local p = h + t * (i - h)

	return p
end
function ENT:DrawHose()
	local ID = self:LookupAttachment("hose")
	local Attachment = self:GetAttachment( ID )

	local pos = Attachment.Pos
	local ang = Attachment.Ang
	local ply = self:GetUser()

	local startPos = pos
	local p2 = pos
	local p3
	local endPos

	if IsValid( ply ) then
		local id = ply:LookupAttachment("anim_attachment_rh")
		local attachment = ply:GetAttachment( id )

		if not attachment then return end

		endPos = (attachment.Pos + attachment.Ang:Forward() * -3 + attachment.Ang:Right() * 2 + attachment.Ang:Up() * -3.5)
		p3 = endPos + attachment.Ang:Right() * 5 - attachment.Ang:Up() * 20
	else
		p3 = pos
		endPos = pos
	end

	render.StartBeam( 15 )
	render.SetMaterial( Material( "cable/cable2" ) )
	for i = 0,15 do
		local pos = bezier(startPos, p2, p3, endPos, i / 14)
		local Col = (render.GetLightColor( pos ) * 0.8 + Vector(0.2,0.2,0.2)) * 255
		render.AddBeam( pos, 1, 0, Color(Col.r,Col.g,Col.b,255) )
	end
	render.EndBeam()
end