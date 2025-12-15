include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply )
	if ply == self:GetDriver() and self.CustomViewPoint then
		view.origin = self:LocalToWorld(self.CustomViewPoint and self.CustomViewPoint or Vector(0, 0, 0))
		return view
	elseif (ply == self:GetGunnerSeat():GetDriver()) then
		if self:GetIsGunnerAiming() then
			view.origin = self:LocalToWorld(Vector(93.5016, 0, -75.3228))
		end
	end
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return view
end

function ENT:LFSHudPaint( X, Y, data ) -- driver only
	local y = 135
	local message = "M197 Front: " .. self:GetTurretAmmo() .. " | " .. math.Round(self:GetTurretAmmo()/self.MaxTurretAmmo*100, 1) .. "%"
	draw.SimpleText( message, "LFS_FONT", 10, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	local frontMuzzle1 = self:GetAttachment(1)

	local pos, ang = frontMuzzle1.Pos, frontMuzzle1.Ang
	local hitPos = util.QuickTrace(pos, ang:Forward()*50000, self).HitPos:ToScreen()
	surface.SetDrawColor( 50, 255, 0, 240 )
	simfphys.LFS.DrawCircle(hitPos.x, hitPos.y, 10)
end

function ENT:LFSHudPaintPassenger( X, Y, ply )
	local frontMuzzle1 = self:GetAttachment(1)

	local message = "M197: " .. self:GetTurretAmmo() .. " | " .. math.Round(self:GetTurretAmmo()/self.MaxTurretAmmo*100, 1) .. "%"
	draw.SimpleText( message, "LFS_FONT", 10, y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	local pos, ang = frontMuzzle1.Pos, frontMuzzle1.Ang
	local hitPos = util.QuickTrace(pos, ang:Forward()*50000, self).HitPos:ToScreen()
	surface.SetDrawColor( 255, 255, 255, 240 )
	simfphys.LFS.DrawCircle(ScrW()/2, ScrH()/2, 20)
	surface.SetDrawColor( 50, 255, 0, 240 )
	simfphys.LFS.DrawCircle(hitPos.x, hitPos.y, 10)
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
	
	self:ManipulateBoneAngles( self:LookupBone("rotor_main"), -Rot1 )
	
	self:ManipulateBoneAngles( self:LookupBone("rotor_rear"), Rot1 )
end

function ENT:AnimCabin()
	local active = self:GetEngineActive()
	local pilot = self:GetDriver():IsValid()
	local gunner = self:GetGunner():IsValid()
	local PilotDoor = (active or pilot) and 0 or 1
	local GunnerDoor = (active or gunner) and 0 or 1
	local TVal = bOn and 0 or 1
	local Speed = FrameTime() * 4
	local Pitch = self:GetRotPitch()
	local Yaw = self:GetRotYaw()
	local Roll = -self:GetRotRoll()
	local Altitude = self:GetPos().z

	local Thrust = self:GetRPM() / self.LimitRPM
	self.PDOpen = self.PDOpen and self.PDOpen + math.Clamp(PilotDoor - self.PDOpen,-Speed,Speed) or 0
	self.GDOpen = self.GDOpen and self.GDOpen + math.Clamp(GunnerDoor - self.GDOpen,-Speed,Speed) or 0
	
	self:ManipulateBoneAngles(self:LookupBone("blister2"), Angle(self.PDOpen * 70, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("blister1"), Angle(-self.GDOpen * 70, 0, 0))

	self:ManipulateBoneAngles(self:LookupBone("stick_pitch1"), Angle(-Pitch * 30, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("stick_pitch2"), Angle(-Pitch * 30, 0, 0))

	self:ManipulateBoneAngles(self:LookupBone("stick_roll1"), Angle(-Roll * 30, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("stick_roll2"), Angle(-Roll * 30, 0, 0))
	
	self:ManipulateBoneAngles(self:LookupBone("pedal_left1"), Angle(Yaw * 5, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("pedal_left2"), Angle(Yaw * 5, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("pedal_right1"), Angle(Yaw * 5, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("pedal_right2"), Angle(Yaw * 5, 0, 0))

	self:ManipulateBoneAngles(self:LookupBone("collective1"), Angle(Thrust * 30, 0, 0))
	self:ManipulateBoneAngles(self:LookupBone("collective2"), Angle(Thrust * 30, 0, 0))
end

function ENT:AnimLandingGear()
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
