include("shared.lua")
include("sh_turret.lua")
include("cl_optics.lua")
include("cl_tankview.lua")
include("cl_attached_playermodels.lua")
LVS:AddHudEditor( "Fuel", ScrW() - 680, ScrH() - 85,  220, 75, 220, 75, "Fuel", 
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintFuelText then return end

		vehicle:LVSHudPaintFuelText( X, Y, W, H, ScrX, ScrY, ply )
	end
)
function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:SetPoseParameter( "steer", steer )
end
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
	self:CreateBonePoseParameter( "door", 8, Angle(0,0,0), Angle(0,0,120), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_driver", 5, Angle(0,0,0), Angle(0,0,70), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_gunner", 6, Angle(0,0,0), Angle(0,0,100), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_commander", 7, Angle(0,0,0), Angle(0,0,110), Vector(0,0,0), Vector(0,0,0) )
end