include("shared.lua")
include("cl_reflectorsight.lua")

ENT.ReflectorSight = true
ENT.ReflectorSightPos = Vector(158,1,101.5)
ENT.ReflectorSightColor = Color(255,150,0,255)
ENT.ReflectorSightColorBG = Color(0,0,0,0)
ENT.ReflectorSightMaterial = Material("models/sw/shared/reticles/collimator/4")
ENT.ReflectorSightMaterialRes = 192
ENT.ReflectorSightHeight = 6.75
ENT.ReflectorSightWidth = 4

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

function ENT:LVSHudPaint( X, Y, ply )
	if not self:LVSPreHudPaint( X, Y, ply ) then return end

	if ply ~= self:GetDriver() then return end

	local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
	local HitPilot = self:GetEyeTrace().HitPos:ToScreen()

	local pod = ply:GetVehicle()

	if self.Hud then
		if not pod:GetThirdPersonMode() then
			self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
		end
	end

	if self.HudThirdPerson then
		if pod:GetThirdPersonMode() then
			self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
		end
	end

	self:PaintCrosshairCenter( HitPlane )
	self:PaintCrosshairOuter( HitPilot )

	if ply:lvsMouseAim() and not ply:lvsKeyDown( "FREELOOK" ) then
		self:LVSHudPaintMouseAim( HitPlane, HitPilot )
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

function ENT:OnSpawn()
	local THE_FONT = {
		font = "Verdana",
		extended = false,
		size = 35,
		weight = 2000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = true,
	}
	surface.CreateFont( "MI35_SPD", THE_FONT )

	self:CreateBonePoseParameter( "cockpit_1", 8, Angle(0,0,0), Angle(-60,0,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "cockpit_2", 9, Angle(0,0,0), Angle(90,0,0), Vector(0,0,0), Vector(0,0,0) )
end

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.25 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-8,-55.3,135) ) )
			effectdata:SetNormal( self:GetUp() )
			effectdata:SetMagnitude( math.Rand(0.5,1.5) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_exhaust_fire", effectdata )

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-8,55.3,135) ) )
			effectdata:SetNormal( self:GetUp() )
			effectdata:SetMagnitude( math.Rand(0.5,1.5) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_exhaust_fire", effectdata )
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
	self:AnimControlSurfaces( FT )
end

function ENT:AnimRotor( frametime )
	local RPM = self:GetThrottle() * 2500
	self.RPM = self.RPM and (self.RPM + RPM * frametime * 0.5) or 0

	self:ManipulateBoneAngles( 15, Angle(0,0,self.RPM) )
	self:ManipulateBoneAngles( 16, Angle(0,self.RPM,0) )
	self:InvalidateBoneCache()
end

function ENT:AnimControlSurfaces( frametime )
	local FT = frametime * 10

	local Steer = self:GetSteer()

	local Pitch = -Steer.y * 30
	local Yaw = -Steer.z * 20
	local Roll = math.Clamp(-Steer.x * 60,-30,30)

	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	self.smRoll = self.smRoll and self.smRoll + (Roll - self.smRoll) * FT or 0

	self:ManipulateBoneAngles( 14, Angle( self.smPitch,0,0) )
end