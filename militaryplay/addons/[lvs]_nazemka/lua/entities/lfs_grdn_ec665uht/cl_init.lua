--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if not self.GunnerCamRTMat then return end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetForward(), 1)
	ang:RotateAroundAxis(self:GetUp(), 270)
	ang:RotateAroundAxis(self:GetRight(), 90)

	cam.Start3D2D(self:LocalToWorld(Vector(1.73,0.09443,0.75741)*40), ang, 0.0148)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(self.GunnerCamRTMat)
		surface.DrawTexturedRect(0, 0, 512, 512)
	cam.End3D2D()
end

function ENT:Think()
	self:AnimCabin()
	self:AnimLandingGear()
	self:AnimRotor()
	self:AnimFins()
	
	self:CheckEngineState()
	
	self:ExhaustFX()
	self:DamageFX()

	if not self.GunnerCamRT then self.GunnerCamRT = GetRenderTarget("EC665_RT_" .. self:EntIndex(), 512, 512) end

	local att = self:GetAttachment(self:LookupAttachment("cam_point"))
	render.PushRenderTarget( self.GunnerCamRT )
		cam.Start3D()
			render.RenderView( {
				origin = att.Pos,
				angles = att.Ang,
				x = 0,
				y = 0,
				w = 512,
				h = 512,
				fov = self:GetAimZoom(),
				drawviewmodel = false,
			})
		cam.End3D()
		cam.Start2D()
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( 512/2-1, 230, 2, 20 )
			surface.DrawRect( 512/2-1, 262, 2, 20 )
			surface.DrawRect( 230, 512/2-1, 20, 2 )
			surface.DrawRect( 262, 512/2-1, 20, 2 )
		cam.End2D()
	render.PopRenderTarget()

	self.GunnerCamRTMat = CreateMaterial("EC665_RTMAT_" .. self:EntIndex(), "UnlitTwoTexture", {
		["$basetexture"] = self.GunnerCamRT:GetName(),
		['$translucent'] = 1,
		['%tooltexture'] = "dev/dev_monitor",
		["$texture2"] = "dev/dev_scanline",
		['$ignorez'] = 0,
		['$vertexcolor'] = 1,
		['$nolod'] = 1,
		['Proxies'] = {
			['TextureScroll'] = {
				['texturescrollvar'] = '$texture2transform',
				['texturescrollrate'] = 0.3,
				['texturescrollangle'] = 270,
			}
		}
	})

end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return view
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	if self:GetGunner() == ply and self:GetGunnerFocus() == true then
		view.origin = self:LocalToWorld(Vector(1.5,0,0.675)*40)
		view.angles = self:LocalToWorldAngles(Angle(3,0,0))
		view.fov = 60
	end
	return view
end

local HUDStaticColor, HUDDynColor, HUDDangerColor = Color(50,255,50,255), Color(25,255,25,255), Color(190, 25, 25, 255)
function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	local w, h = ScrW(), ScrH()
	local Orientation = self:GetAngles().z
	local CollectiveColor = Throttle <= 100 and Color(50,255,50,255) or Color(0,180,0,255)

	draw.SimpleText( "COL", "GRDN_HELISTAHUD", w/2-500, h/2-90, HUDStaticColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	draw.SimpleText( Throttle.."%" , "GRDN_HELIDYNHUD", w/2-490, h/2-90, CollectiveColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
	draw.SimpleText( "RPM", "GRDN_HELISTAHUD", w/2-500, h/2-60, HUDStaticColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	draw.SimpleText( math.Round(self:GetRPM(),0).."rpm" , "GRDN_HELIDYNHUD", w/2-490, h/2-60, HUDDynColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	draw.SimpleText( "IAS", "GRDN_HELISTAHUD", w/2-500, h/2-30, HUDStaticColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	draw.SimpleText( speed.."km/h", "GRDN_HELIDYNHUD", w/2-490, h/2-30, HUDDynColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	draw.SimpleText( "ALT", "GRDN_HELISTAHUD", w/2-500, h/2, HUDStaticColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	draw.SimpleText( alt.."m" , "GRDN_HELIDYNHUD", w/2-490, h/2, HUDDynColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	if self:GetMaxAmmoPrimary() > -1 then
		draw.SimpleText( "CNN", "GRDN_HELISTAHUD", w/2-500, h/2+30, HUDStaticColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( AmmoPrimary, "GRDN_HELIDYNHUD", w/2-490, h/2+30, HUDDynColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	if self:GetMaxAmmoSecondary() > -1 then
		draw.SimpleText( "POD", "GRDN_HELISTAHUD", w/2-500, h/2+60, HUDStaticColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( AmmoSecondary, "GRDN_HELIDYNHUD", w/2-490, h/2+60, HUDDynColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
end

function ENT:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, FREELOOK )
	surface.SetDrawColor( HUDDynColor:Unpack() )
	if Len > 40 then
		local FailStart = LFS_TIME_NOTIFY > CurTime()
		if FailStart then
			surface.SetDrawColor( HUDDangerColor.r, HUDDangerColor.g, HUDDangerColor.b, math.abs( math.cos( CurTime() * 10 ) ) * 255 )
		end
		
		if not FREELOOK or FailStart then
			surface.DrawLine( (self.HitDelay and self.HitDelay.x or HitPlane.x) + Dir.x * 5, (self.HitDelay and self.HitDelay.y or HitPlane.y) + Dir.y * 5, HitPilot.x - Dir.x * 40, HitPilot.y- Dir.y * 40 )
			
			-- shadow
			surface.SetDrawColor( 0, 0, 0, 50 )
			surface.DrawLine( HitPlane.x + Dir.x * 10 + 1, HitPlane.y + Dir.y * 10 + 1, HitPilot.x - Dir.x * 40+ 1, HitPilot.y- Dir.y * 40 + 1 )
		end
	end
end

function ENT:LFSHudPaintCrosshair( HitPlane, HitPilot )
	local Speed = FrameTime() * 20
	self.HitDelay = self.HitDelay and LerpVector(Speed, self.HitDelay, Vector(HitPlane.x, HitPlane.y, 0)) or Vector(HitPlane.x, HitPlane.y, 0)
	surface.SetDrawColor( HUDStaticColor:Unpack() )
	simfphys.LFS.DrawCircle( self.HitDelay.x, self.HitDelay.y, 5 )
	simfphys.LFS.DrawCircle( HitPlane.x, HitPlane.y, 25 )
	simfphys.LFS.DrawCircle( HitPilot.x, HitPilot.y, 40 )

	local markerPos = self:GetMarker():ToScreen()
	surface.SetDrawColor( 255, 50, 0, 240 )
	simfphys.LFS.DrawCircle(markerPos.x, markerPos.y, 10)
	surface.SetDrawColor( 255, 240, 0, 240 )
	simfphys.LFS.DrawCircle(markerPos.x, markerPos.y, 15)
	
	-- shadow
	surface.SetDrawColor( 0, 0, 0, 80)
	simfphys.LFS.DrawCircle( self.HitDelay.x + 1, self.HitDelay.y + 1, 5 )
	simfphys.LFS.DrawCircle( HitPlane.x + 1, HitPlane.y + 1, 25 )
	simfphys.LFS.DrawCircle( HitPilot.x + 1, HitPilot.y + 1, 40 )

	self:LFSPaintHitMarker( HitPlane )
end

hook.Add("HUDPaint", "LFS_GRDN.EC665_GUNNER_PAINT", function()
	local ply, seat = LocalPlayer(), LocalPlayer():GetVehicle()
	if ply:InVehicle() then
		local heli = seat:GetParent()
		if IsValid(heli) and heli:GetClass() == "lfs_grdn_ec665" and heli:GetGunner() == LocalPlayer() then
			local markerPos = heli:GetMarker():ToScreen()
			surface.SetDrawColor( 255, 50, 0, 240 )
			simfphys.LFS.DrawCircle(markerPos.x, markerPos.y, 10)
		end
	end
end)

function ENT:LFSPaintHitMarker( scr )
	-- local aV = math.sin( math.rad( math.sin( math.rad( math.max(((self:GetHitMarker() - CurTime()) / 0.15) * 90,0) ) ) * 90 ) )
	-- if aV > 0.01 then
	-- 	local Start = 15 + (1 - aV ^ 2) * 40
	-- 	local dst = 10

	-- 	surface.SetDrawColor( 255, 255, 0, 255 )
	-- 	surface.DrawLine( scr.x + Start, scr.y + Start, scr.x + Start, scr.y + Start - dst )
	-- 	surface.DrawLine( scr.x + Start, scr.y + Start, scr.x + Start - dst, scr.y + Start )

	-- 	surface.DrawLine( scr.x + Start, scr.y - Start, scr.x + Start, scr.y - Start + dst )
	-- 	surface.DrawLine( scr.x + Start, scr.y - Start, scr.x + Start - dst, scr.y - Start )

	-- 	surface.DrawLine( scr.x - Start, scr.y + Start, scr.x - Start, scr.y + Start - dst )
	-- 	surface.DrawLine( scr.x - Start, scr.y + Start, scr.x - Start + dst, scr.y + Start )

	-- 	surface.DrawLine( scr.x - Start, scr.y - Start, scr.x - Start, scr.y - Start + dst )
	-- 	surface.DrawLine( scr.x - Start, scr.y - Start, scr.x - Start + dst, scr.y - Start )
	-- end

	-- local aV = math.sin( math.rad( math.sin( math.rad( math.max(((self:GetKillMarker() - CurTime()) / 0.2) * 90,0) ) ) * 90 ) )
	-- if aV > 0.01 then
	-- 	surface.SetDrawColor( 255, 255, 255, 15 * (aV ^ 4) )
	-- 	surface.DrawRect( 0, 0, ScrW(), ScrH() )

	-- 	local Start = 10 + aV * 40
	-- 	local End = 20 + aV * 45
	-- 	surface.SetDrawColor( 255, 0, 0, 255 )
	-- 	surface.DrawLine( scr.x + Start, scr.y + Start, scr.x + End, scr.y + End )
	-- 	surface.DrawLine( scr.x - Start, scr.y + Start, scr.x - End, scr.y + End ) 
	-- 	surface.DrawLine( scr.x + Start, scr.y - Start, scr.x + End, scr.y - End )
	-- 	surface.DrawLine( scr.x - Start, scr.y - Start, scr.x - End, scr.y - End ) 

	-- 	draw.NoTexture()
	-- 	surface.DrawTexturedRectRotated( scr.x + Start, scr.y + Start, 5, 20, 45 )
	-- 	surface.DrawTexturedRectRotated( scr.x - Start, scr.y + Start, 20, 5, 45 )
	-- 	surface.DrawTexturedRectRotated(  scr.x + Start, scr.y - Start, 20, 5, 45 )
	-- 	surface.DrawTexturedRectRotated( scr.x - Start, scr.y - Start, 5, 20, 45 )
	-- end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local THR = RPM / self:GetLimitRPM()

	local Low = 1000
	local Mid = 2000
	
	-- if self.RPM1 then
	-- 	self.RPM1:ChangePitch( math.Clamp( math.min(RPM / self:GetIdleRPM(),1) * 100+ Doppler + THR * 20,0,255) )
	-- 	self.RPM1:ChangeVolume( math.Clamp(THR,0.8,1) )
	-- end
	
	if self.RPM1 then
		self.RPM1:ChangePitch( math.Clamp(100 + Pitch * 20 + Doppler,0,255) )
		self.RPM1:ChangeVolume( RPM < Low and 1 or 0, 1.5 )
	end
	
	if self.RPM2 then
		self.RPM2:ChangePitch(  math.Clamp(80 + Pitch * 50 + Doppler,0,255) )
		self.RPM2:ChangeVolume( (RPM >= Low and RPM < Mid) and 1 or 0, 1.5 )
	end
	
	if self.RPM3 then
		self.RPM3:ChangePitch(  math.Clamp(80 + Pitch * 50 + Doppler,0,255) )
		self.RPM3:ChangeVolume( RPM >= Mid and 1 or 0, 1.5 )
	end
	rotor_pitch = math.Clamp(80 + Pitch * 20 + Doppler,0,255)
	if self.ROTOR1 then
		self.ROTOR1:ChangePitch( rotor_pitch )
		self.ROTOR1:ChangeVolume( RPM >= 300 and 1 or 0, 1.5 )
	end
	
	if self.ROTOR2 then
		self.ROTOR2:ChangePitch( rotor_pitch )
		self.ROTOR2:ChangeVolume( RPM >= 1200 and 1 or 0, 1.5 )
	end
	
	if self.ROTOR3 then
		self.ROTOR3:ChangePitch( rotor_pitch )
		self.ROTOR3:ChangeVolume( RPM >= 300 and 1 or 0, 1.5 )
	end

	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  50 + Pitch * 60, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.RPM1 = CreateSound( self, "LFS_GRDN_ENGHELI_RPM1" )
		self.RPM1:PlayEx(0,0)

		self.RPM2 = CreateSound( self, "LFS_GRDN_ENGHELI_RPM2" )
		self.RPM2:PlayEx(0,0)

		self.RPM3 = CreateSound( self, "LFS_GRDN_ENGHELI_RPM3" )
		self.RPM3:PlayEx(0,0)

		self.ROTOR1 = CreateSound( self, "LFS_GRDN_ENGHELI_ROTOR1" )
		self.ROTOR1:PlayEx(0,0)

		self.ROTOR2 = CreateSound( self, "LFS_GRDN_ENGHELI_ROTOR2" )
		self.ROTOR2:PlayEx(0,0)

		self.ROTOR3 = CreateSound( self, "LFS_GRDN_ENGHELI_ROTOR3" )
		self.ROTOR3:PlayEx(0,0)

		self.DIST = CreateSound( self, "LFS_GRDN_ENGHELI_DIST")
		self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.RPM1 then
		self.RPM1:Stop()
	end
	if self.RPM2 then
		self.RPM2:Stop()
	end
	if self.RPM3 then
		self.RPM3:Stop()
	end
	if self.ROTOR1 then
		self.ROTOR1:Stop()
	end
	if self.ROTOR2 then
		self.ROTOR2:Stop()
	end
	if self.ROTOR3 then
		self.ROTOR3:Stop()
	end
	if self.DIST then
		self.DIST:Stop()
	end
end

-- function ENT:AnimFins()
-- 	self.sm_pp_rudder = self.sm_pp_rudder and (self.sm_pp_rudder + ((self:GetRotRoll() + self:GetRotYaw()) * 100 - self.sm_pp_rudder) * FrameTime() * 10) or 0
-- 	self:SetPoseParameter("rudder", self.sm_pp_rudder)
-- 	self:InvalidateBoneCache() 
-- end

function ENT:AnimRotor()
	local RotorBlown = self:GetRotorDestroyed()

	if RotorBlown ~= self.wasRotorBlown then
		self.wasRotorBlown = RotorBlown
		
		if RotorBlown then
			self:DrawShadow( false ) 
		end
	end
	
	if RotorBlown then
		local normal = -self:LocalToWorldAngles( Angle(15,0,0) ):Up()
		local position = normal:Dot( self:LocalToWorld( Vector(0,0,45) ) )
		self:SetRenderClipPlaneEnabled( true )
		self:SetRenderClipPlane( normal, position )
	end
	
	local RPM = math.min(self:GetRPM() * 5,self:GetMaxRPM())
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * 0.5) or 0
	
	local Rot1 = Angle( -self.RPM,0,0)
	Rot1:Normalize()
	
	self:ManipulateBoneAngles( self:LookupBone("rotor_main"), Rot1 )
	
	self:ManipulateBoneAngles( self:LookupBone("rotor_rear"), Rot1 )
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (40 *  self:GetLGear() - self.SMLG) * FrameTime() * 8 or 0
	self.SMRG = self.SMRG and self.SMRG + (40 *  self:GetRGear() - self.SMRG) * FrameTime() * 8 or 0
end

function ENT:AnimCabin()
	local active = self:GetEngineActive()
	local pilot = self:GetDriver():IsValid()
	local gunner = self:GetGunner():IsValid()
	local PilotDoor = (active or pilot) and 0 or 1
	local GunnerDoor = (active or gunner) and 0 or 1
	local TVal = bOn and 0 or 1
	local Speed = FrameTime() * 8
	local Pitch = self:GetRotPitch()
	local Yaw = self:GetRotYaw()
	local Roll = -self:GetRotRoll()
	local Altitude = self:GetPos().z

	local Thrust = self:GetRPM() / self.LimitRPM
	self.PDOpen = self.PDOpen and self.PDOpen + math.Clamp(PilotDoor - self.PDOpen,-Speed,Speed) or 0
	self.GDOpen = self.GDOpen and self.GDOpen + math.Clamp(GunnerDoor - self.GDOpen,-Speed,Speed) or 0
	
	self:ManipulateBoneAngles(self:LookupBone("blister2"), Angle(-self.GDOpen * 90, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("blister1"), Angle(self.PDOpen * 90, 0, 0))

	self:ManipulateBoneAngles(self:LookupBone("stick_pitch1"), Angle(Pitch * 30, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("stick_pitch2"), Angle(Pitch * 30, 0, 0))

	self:ManipulateBoneAngles(self:LookupBone("stick_roll1"), Angle(-Roll * 30, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("stick_roll2"), Angle(-Roll * 30, 0, 0))

	self:ManipulateBoneAngles(self:LookupBone("collective1"), Angle(Thrust * 20, 0, 0))
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.05 + (1 - THR) / 10
		
		local Pos = {
			Vector(-79.8802,0.267764,22.8025)
		}
		
		for _, v in pairs(Pos) do 
			if math.random(0,1) == 1 then
				local effectdata = EffectData()
					effectdata:SetOrigin( self:LocalToWorld(v) )
					effectdata:SetAngles( Angle(-90,-20,0) )
					effectdata:SetMagnitude( math.Clamp(THR*100,20,100) ) 
					effectdata:SetEntity( self )
				util.Effect( "lfs_blacksmoke", effectdata )
			end
		end
	end
end
