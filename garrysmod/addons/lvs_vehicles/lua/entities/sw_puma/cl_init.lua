include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("cl_optics.lua")
include("cl_tankview.lua")
function ENT:OnSpawn()
	self:CreateBonePoseParameter( "hatch_driver", 49, Angle(0,0,0), Angle(0,0,0), Vector(0,0,0), Vector(-20,0,0) )
	self:CreateBonePoseParameter( "hatch_gunner", 50, Angle(0,0,0), Angle(0,0,0), Vector(0,0,0), Vector(20,13,0) )
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

local switch = Material("lvs/weapons/change_ammo.png")
local AP = Material("icons/30mm_ap")
local HE = Material("icons/30mm_he")
function ENT:DrawWeaponIcon( PodID, ID, x, y, width, height, IsSelected, IconColor )
	if ID == 3 then
		if self:GetUseHighExplosive() then
			surface.SetMaterial( HE )
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
		else
			surface.SetMaterial( AP )
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
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/sherman/engine_start.wav", 75, 100,  LVS.EngineVolume )
	end
end

function ENT:OnFrame()
	self:AnimFins()
end
function ENT:AnimFins()
	local FT = RealFrameTime()
	local RampVal = self:GetRamp() and 1 or 0
	self.AnimRamp = self.AnimRamp and self.AnimRamp + math.Clamp(RampVal - self.AnimRamp,-FT,FT) or 0
	self:ManipulateBoneAngles( 51, Angle( 0,0,self.AnimRamp*90) ) 
end