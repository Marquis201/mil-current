include("shared.lua")
include("cl_reflectorsight.lua")
DEFINE_BASECLASS( "lvs_base_helicopter" )

--Collimator
ENT.ReflectorSight = true
ENT.ReflectorSightPos = Vector(92,0,84)
ENT.ReflectorSightColor = Color(255,150,0,255)
ENT.ReflectorSightColorBG = Color(0,0,0,0)
ENT.ReflectorSightMaterial = Material("models/sw/shared/reticles/collimator/27")
ENT.ReflectorSightMaterialRes = 256
ENT.ReflectorSightHeight = 6
ENT.ReflectorSightWidth = 2.5

--Doors
function ENT:OnSpawn()
	self:CreateBonePoseParameter( "door_r", 2, Angle(0,0,0), Angle(-90,0,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "door_l", 3, Angle(0,0,0), Angle(90,0,0), Vector(0,0,0), Vector(0,0,0) )
end

--Fuel hud
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

--Main hud
function ENT:LVSHudPaint( X, Y, ply )
	if not self:LVSPreHudPaint( X, Y, ply ) then return end

	if ply ~= self:GetDriver() then return end

	local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
	local HitPilot = self:GetEyeTrace().HitPos:ToScreen()

	local pod = ply:GetVehicle()

	if self.Hud then
		if not pod:GetThirdPersonMode() then
			self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
		end
	end

	if self.HudThirdPerson then
		if pod:GetThirdPersonMode() then
			self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
		end
	end

	self:PaintCrosshairCenter( HitPlane, self.HudColor )
	self:PaintCrosshairOuter( HitPilot, self.HudColor )

	if ply:lvsMouseAim() and not ply:lvsKeyDown( "FREELOOK" ) then
		self:LVSHudPaintMouseAim( HitPlane, HitPilot, self.HudColor )
	end

		if self:IsDrawingReflectorSight() then
		self:DrawReflectorSight( HitPlane )

		if ply:lvsMouseAim() then
			local LineVisible = false

			if not ply:lvsKeyDown( "FREELOOK" ) then
				LineVisible = self:LVSHudPaintMouseAim( HitPlane, HitPilot )
			end

			if LineVisible then
				self:PaintCrosshairOuter( HitPilot )
			end
		end

		self:LVSPaintHitMarker( HitPilot )

		return
	end

	self:LVSPaintHitMarker( HitPilot )
end
function ENT:LVSHudPaintMouseAim( HitPlane, HitPilot )
	local Sub = Vector(HitPilot.x,HitPilot.y,0) - Vector(HitPlane.x,HitPlane.y,0)
	local Len = Sub:Length()
	local Dir = Sub:GetNormalized()

	surface.SetDrawColor( 255, 255, 255, 100 )
	if Len > 20 then
		surface.DrawLine( HitPlane.x + Dir.x * 5, HitPlane.y + Dir.y * 5, HitPilot.x - Dir.x * 20, HitPilot.y- Dir.y * 20 )

		-- shadow
		surface.SetDrawColor( 0, 0, 0, 50 )
		surface.DrawLine( HitPlane.x + Dir.x * 5 + 1, HitPlane.y + Dir.y * 5 + 1, HitPilot.x - Dir.x * 20+ 1, HitPilot.y- Dir.y * 20 + 1 )
	end
end

--Loadouts and anims
function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.25 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-81,0,81) ) )
			effectdata:SetNormal( self:GetUp() )
			effectdata:SetMagnitude( math.Rand(0.5,1.5) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_exhaust_fire", effectdata )
	end

	if self:GetLoadout() == 2 then
		self:SetBodygroup(4,1)
	else
		self:SetBodygroup(4,0)
	end
	if self:GetLoadout() <= 3 then
		self:SetBodygroup(3,0)
	else
		self:SetBodygroup(3,1)
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
	if loadout >= 1 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",loadout)
			self:RemoveWeapon(1)
			self:RemoveWeapon(2)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout

	local FT = RealFrameTime()
	self:AnimRotor(FT)
	self:DamageFX(FT)
end
function ENT:AnimRotor( frametime )
	local RPM = self:GetThrottle() * 5000
	self.RPM = self.RPM and (self.RPM + RPM * frametime * 0.5) or 0

	self:ManipulateBoneAngles( 10, Angle(0,self.RPM,0) )
	self:ManipulateBoneAngles( 11, Angle(0,0,self.RPM) )
	self:InvalidateBoneCache()
end