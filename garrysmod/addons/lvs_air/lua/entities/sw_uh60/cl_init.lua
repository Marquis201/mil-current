include("shared.lua")

function ENT:OnSpawn()
	self:CreateBonePoseParameter( "door_r", 17, Angle(0,0,0), Angle(0,90,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "door_l", 18, Angle(0,0,0), Angle(0,-90,0), Vector(0,0,0), Vector(0,0,0) )
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

	self:PaintCrosshairCenter( HitPlane )
	self:PaintCrosshairOuter( HitPilot )

	if ply:lvsMouseAim() and not ply:lvsKeyDown( "FREELOOK" ) then
		self:LVSHudPaintMouseAim( HitPlane, HitPilot )
	end

	self:LVSPaintHitMarker( HitPilot )
end

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.25 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-85,-47,115) ) )
			effectdata:SetNormal( self:GetUp() )
			effectdata:SetMagnitude( math.Rand(0.5,1.5) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_exhaust_fire", effectdata )
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-85,47,115) ) )
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
	if loadout == 0 then
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",loadout)
			self:RemoveWeapon(1)
			self:RemoveWeapon(2)
			self:RemoveWeapon(3)
			self:RemoveWeapon(4)
			self:InitWeapons()
		end
	else
		if not (self.OldLoadout == loadout) then
			self:SetNWInt("Loadout",loadout)
			self:RemoveWeapon(1)
			self:RemoveWeapon(2)
			self:RemoveWeapon(3)
			self:RemoveWeapon(4)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout
	local FT = RealFrameTime()

	self:AnimRotor(FT)
	self:DamageFX(FT)
	self:AnimControlSurfaces( FT )	
end

function ENT:AnimRotor(frametime)
	local RPM = self:GetThrottle() * 2500
	self.RPM = self.RPM and (self.RPM + RPM * frametime * 0.5) or 0

	self:ManipulateBoneAngles( 9, Angle(0,self.RPM,0) )
	self:ManipulateBoneAngles( 10, Angle(self.RPM,0,0) )
	self:InvalidateBoneCache()
end
function ENT:AnimControlSurfaces( frametime )
	local FT = frametime * 10

	local Steer = self:GetSteer()
	local Pitch = -Steer.y * 30
	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self:ManipulateBoneAngles( 21, Angle( 0,0,self.smPitch) )

	local HatchOn = self:GetDoors()
	local HatchVal = HatchOn and 1 or 0
	self.HatchOpen = self.HatchOpen and self.HatchOpen + math.Clamp(HatchVal - self.HatchOpen,-frametime*0.65,frametime*0.65) or 0

	self:ManipulateBonePosition( 15, Vector( 0,-self.HatchOpen*75,0) )
	self:ManipulateBonePosition( 16, Vector( 0,-self.HatchOpen*75,0) )

	local MGROn = self:GetMGR()
	local MGRVal = MGROn and 1 or 0
	self.MGROpen = self.MGROpen and self.MGROpen + math.Clamp(MGRVal - self.MGROpen,-frametime*0.65,frametime*0.65) or 0
	self.MGROpen1 = self.MGROpen1 and self.MGROpen1 + math.Clamp((self:GetMGR() and 0 or 1) - self.MGROpen1,-frametime*0.65,frametime*0.65) or 0

	self:ManipulateBonePosition( 11, Vector( 0,self.MGROpen*15,0) )
	self:ManipulateBonePosition( 12, Vector( 0,self.MGROpen*15,0) )

	local MGLOn = self:GetMGL()
	local MGLVal = MGLOn and 1 or 0
	self.MGLOpen = self.MGLOpen and self.MGLOpen + math.Clamp(MGLVal - self.MGLOpen,-frametime*0.65,frametime*0.65) or 0
	self.MGLOpen1 = self.MGLOpen1 and self.MGLOpen1 + math.Clamp((self:GetMGL() and 0 or 1) - self.MGLOpen1,-frametime*0.65,frametime*0.65) or 0

	self:ManipulateBonePosition( 13, Vector( 0,self.MGLOpen*15,0) )
	self:ManipulateBonePosition( 14, Vector( 0,self.MGLOpen*15,0) )
end