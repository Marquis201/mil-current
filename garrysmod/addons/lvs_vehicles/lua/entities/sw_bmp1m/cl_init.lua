include("shared.lua")
include("sh_tracks.lua")
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
	self:CreateBonePoseParameter( "hatch_driver", 49, Angle(0,0,0), Angle(0,-90,0), Vector(0,0,0), Vector(0,0,3) )
	self:CreateBonePoseParameter( "hatch_commander", 50, Angle(0,0,0), Angle(0,0,-90), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_gunner", 47, Angle(0,0,0), Angle(0,0,-90), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_pass_r1", 51, Angle(0,0,0), Angle(-90,0,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_pass_l1", 52, Angle(0,0,0), Angle(90,0,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_pass_r2", 55, Angle(0,0,0), Angle(0,90,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch_pass_l2", 56, Angle(0,0,0), Angle(0,-90,0), Vector(0,0,0), Vector(0,0,0) )
end
local switch = Material("lvs/weapons/change_ammo.png")
local AP = Material("icons/30mm_ap")
local Cannon = Material("icons/30mm_he")
function ENT:DrawWeaponIcon( PodID, ID, x, y, width, height, IsSelected, IconColor )
	if ID == 3 then
		local Icon = self:GetUseHighExplosive() and Cannon or AP

		surface.SetMaterial( Icon )
		surface.DrawTexturedRect( x, y, width, height )
	
		local ply = LocalPlayer()
	
		if not IsValid( ply ) then return end

		surface.SetMaterial( switch )
		surface.DrawTexturedRect( x + width + 5, y + 7, 24, 24 )
	
		local buttonCode = ply:lvsGetControls()[ "CAR_SWAP_AMMO" ]
	
		if not buttonCode then return end
	
		local KeyName = input.GetKeyName( buttonCode )
	
		if not KeyName then return end
	
		draw.DrawText( KeyName, "DermaDefault", x + width + 17, y + height * 0.5 + 7, Color(0,0,0,IconColor.a), TEXT_ALIGN_CENTER )
	end
end
function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/sherman/engine_start.wav", 75, 100,  LVS.EngineVolume )
	end
end