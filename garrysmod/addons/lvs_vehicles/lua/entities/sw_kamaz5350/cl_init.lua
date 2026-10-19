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
	self:CreateBonePoseParameter( "hatch_t", 1, Angle(0,0,0), Angle(0,0,-165), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "door_l", 2, Angle(0,0,0), Angle(0,-90,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "door_r", 3, Angle(0,0,0), Angle(0,90,0), Vector(0,0,0), Vector(0,0,0) )
    self:CreateBonePoseParameter( "hatch_r", 4, Angle(0,0,0), Angle(-170,0,0), Vector(0,0,0), Vector(0,0,0) )
end
function ENT:Think()
	if not self:IsInitialized() then return end

	BaseClass.Think( self )

	self:TireSoundThink()

	if isfunction( self.UpdatePoseParameters ) then
		self:CalcPoseParameters()
	else
		self:SetPoseParameter( "steer", self:GetSteer() /  self:GetMaxSteerAngle() )
		self:InvalidateBoneCache()
	end
end