include("shared.lua")
include("sh_tracks.lua")
function ENT:OnSpawn()
	self:CreateBonePoseParameter( "hatch_driver", 36, Angle(0,0,0), Angle(-90,0,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_gunner", 37, Angle(0,0,0), Angle(0,0,-90), Vector(0,0,0), Vector(0,0,0) )
end
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
function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "sw/kurganets25/engine_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "sw/kurganets25/engine_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end

function ENT:OnFrame()
	self:AnimFins()
end
function ENT:AnimFins()
	local FT = RealFrameTime()
	local RampVal = self:GetHatch() and 1 or 0
	self.AnimRamp = self.AnimRamp and self.AnimRamp + math.Clamp(RampVal - self.AnimRamp,-FT,FT) or 0
	self:ManipulateBoneAngles( 56, Angle( 0,0,self.AnimRamp*115) ) 
end