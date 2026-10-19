include("shared.lua")
include("cl_attached_playermodels.lua")
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
	self:CreateBonePoseParameter( "door_l", 3, Angle(0,0,0), Angle(0,-90,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "door_r", 2, Angle(0,0,0), Angle(0,90,0), Vector(0,0,0), Vector(0,0,0) )
end
function ENT:Think()
	if not self:IsInitialized() then return end

	BaseClass.Think( self )

	self:TireSoundThink()

	if isfunction( self.UpdatePoseParameters ) then
		self:CalcPoseParameters()
	else
		self:SetPoseParameter( "steer", -self:GetSteer() /  self:GetMaxSteerAngle() )
		self:InvalidateBoneCache()
	end
end

function ENT:RemoveWeapon( PodID )
	if not PodID or PodID <= 1 then
		PodID = 1
	end
	
	if not self.WEAPONS[ PodID ] then
		self.WEAPONS[ PodID ] = {}
	end

	self.WEAPONS[ PodID ] = {}
end
function ENT:OnFrame()
	local loadout = self:GetNWInt("Loadout")
	if loadout == 1 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",1)
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:InitWeapons()
		end
	elseif loadout == 2 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",2)
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:InitWeapons()
		end
	elseif loadout == 3 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",3)
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:InitWeapons()
		end
	elseif loadout == 4 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",4)
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:InitWeapons()
		end
	elseif loadout == 5 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",5)
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:InitWeapons()
		end
	elseif loadout == 6 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",6)
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout
end