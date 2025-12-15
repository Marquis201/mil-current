ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "BMP-1P"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - БМП"

ENT.VehicleCategory = "БМП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/bmp1/bmp1p.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1500

ENT.SteerSpeed = 5
ENT.SteerReturnSpeed = 5

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 650
ENT.MaxVelocityReverse = 200

ENT.EngineCurve = 0.1
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 40

ENT.EngineSounds = {
	{
		sound = "sw/bmp1/bmp_engine_idle.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "sw/bmp1/bmp_engine_mid.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 90,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(38,-43,57.7),
		ang = Angle(-90,0,0)
	},
	{
		pos = Vector(38,-43,57.7),
		ang = Angle(-90,0,0)
	},
	{
		pos = Vector(38,-43,57.7),
		ang = Angle(-90,0,0)
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-98.4,0.1,56.4), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Bool", "TurretDestroyed" )
	self:AddDT( "Bool", "UseHighExplosive" )
	self:AddDT( "Bool", "Hatch" )
end

function ENT:InitWeapons()
	local pkt = {}
	pkt.Icon = Material("icons/pkt")
	pkt.Ammo = 2000
	pkt.Delay = 0.08
	pkt.HeatRateUp = 0
	pkt.HeatRateDown = 0
	pkt.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle_coax" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 1300
		bullet.HullSize = 0
		bullet.EnableBallistics = true
		bullet.Damage	= 35
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)

		ent:TakeAmmo( 1 )
	end
	pkt.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Play()
	end
	pkt.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Stop()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGStop ) then return end
		base.SNDTurretMGStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	pkt.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 30
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -4, 30 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )
		
		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	pkt.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local Crosshair = tr.HitPos:ToScreen() 
		base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
		base:LVSPaintHitMarker( Crosshair )

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a28_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a28_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end			
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat )
				end
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
			end
		end

		local ID = self:LookupAttachment( "turret" )
		local Turret = self:GetAttachment( ID )
		local X = ScrW()/2
		local Y = ScrH()/2
		local body_mat = Material( "models/sw/shared/ui/traverse_body" )
		local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
		local view_mat = Material( "models/sw/shared/ui/traverse_view" )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( body_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
		surface.SetMaterial( turret_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
	end
	pkt.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				view.drawviewer = true
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, angles, fov, pod )
		end
	end
	self:AddWeapon( pkt, 2 )

	local grom = {}
	grom.Icon = true
	grom.Ammo = 40
	grom.Delay = 7.5
	grom.HeatRateUp = 1
	grom.HeatRateDown = 0.175
	grom.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread = Vector(0,0,0)
		bullet.EnableBallistics = true

		if self:GetUseHighExplosive() then
			bullet.Force	= 250
			bullet.HullSize = 7
			bullet.Damage	= 800
			bullet.SplashDamage = 800
			bullet.SplashDamageRadius = 400
			bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
			bullet.SplashDamageType = DMG_BLAST
			bullet.Velocity = 10000
		else
			bullet.Force	= 15000
			bullet.HullSize 	= 0
			bullet.Damage	= 3000
			bullet.Velocity = 10000
		end

		bullet.TracerName = "lvs_tracer_cannon"
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("ins_weapon_rpg_frontblast",Attachment.Pos-Attachment.Ang:Forward()*25,Attachment.Ang,nil)
		util.ScreenShake( Attachment.Pos, 3, 20, 1, 500, true, nil )

		local PhysObj = self:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -Attachment.Ang:Forward() * 1000, Attachment.Pos )
		end
		
		if not IsValid( self.SNDTurret ) then return end
		self:ResetSequence("fire")
		self.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		timer.Simple(2,function() 
			if IsValid(self) then
				if not IsValid( self.SNDRld ) then return end
				self.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
			end
		end)

		ent:TakeAmmo( 1 )
	end
	grom.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ply = ent:GetDriver()
		if IsValid( ply ) then
			local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )
			if ent._oldSwitchType ~= SwitchType then
				ent._oldSwitchType = SwitchType
	
				if SwitchType then			
					if SwitchType then			
						self:SetUseHighExplosive( not self:GetUseHighExplosive() )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )
						timer.Simple(2,function() 
							if IsValid(self) then
								if not IsValid( self.SNDRld ) then return end
								self.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
							end
						end)
					end
				end
			end
		end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 30
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -4, 30 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	grom.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local Crosshair = tr.HitPos:ToScreen() 
		if self:GetUseHighExplosive() then
			base:PaintCrosshairSquare( Crosshair, COLOR_WHITE )
		else
			base:PaintCrosshairOuter( Crosshair, COLOR_WHITE )
		end
		base:LVSPaintHitMarker( Crosshair )
	
		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a28_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a28_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end			
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat )
				end
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
			end
		end

		local ID = self:LookupAttachment( "turret" )
		local Turret = self:GetAttachment( ID )
		local X = ScrW()/2
		local Y = ScrH()/2
		local body_mat = Material( "models/sw/shared/ui/traverse_body" )
		local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
		local view_mat = Material( "models/sw/shared/ui/traverse_view" )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( body_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
		surface.SetMaterial( turret_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
	end
	grom.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				view.drawviewer = true
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, angles, fov, pod )
		end
	end
	self:AddWeapon( grom, 2 )
	
	local konkurs = {}
	konkurs.Icon = Material("icons/kornet")
	konkurs.Ammo = 3
	konkurs.Delay = 10
	konkurs.HeatRateUp = 0
	konkurs.HeatRateDown = 0.1
	konkurs.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local APitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("atgm_pitch"), -Angles.p, 30*FrameTime() ), -5, 10 )
		local AYaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("atgm_yaw"),  Angles.y, 30*FrameTime() ), -37, 15 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("atgm_yaw", AYaw )
		base:SetPoseParameter("atgm_pitch", APitch )
	end
	konkurs.Attack = function( ent )
		local ID = self:LookupAttachment("muzzle_atgm")
		local Muzzle = self:GetAttachment(ID)
	
		if not Muzzle then return end

		self:EmitSound("SW_9K111_TRIGGER")
		self:EmitSound("SW_9K111_PRELAUNCH")

		timer.Simple(0.15,function()
			if IsValid(self) then
				self:EmitSound("SW_9K111_CAP")
				timer.Simple(0.5,function()
					if IsValid(self) then
						self:EmitSound("sw/rocket/tank_rocket_shot_"..math.random(1,3)..".wav")
				
						local Driver = ent:GetDriver()
						local TargetDir = Muzzle.Ang:Forward()
						local tr = util.TraceLine( {
							start = Muzzle.Pos,
							endpos = (Muzzle.Pos + TargetDir  * 999999),
							filter = ent
						} )
						local projectile = ents.Create("sw_rocket_9m113_v3")
						projectile:SetPos(Muzzle.Pos+Muzzle.Ang:Forward()*50)
						projectile:SetAngles(Muzzle.Ang+Angle(0,0,90))
						projectile:Spawn()
						projectile:Activate()
						projectile:Launch()
						projectile.Armed = true
						projectile.Launcher = self
						projectile.GuidanceActive = true
						projectile.LaserGuided = true
						projectile.LaserCode = "muzzle_atgm"
						projectile.target = tr.Entity
						projectile.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
						projectile:SetTracerScale(5)
						
						local Wire = constraint.Rope(self,projectile,0,0,Vector(-8.5,-12,89.8),Vector(0,0,0),20000,0,0.1,0.1)
						self:SetNWEntity("Wire",Wire)
						self:SetNWEntity("Missile",projectile)

						ParticleEffect("ins_weapon_rpg_frontblast",Muzzle.Pos,Muzzle.Ang,self)
				
						ent:TakeAmmo( 1 )	
					end
				end)
			end
		end)
	end
	konkurs.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_atgm" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local Crosshair = tr.HitPos:ToScreen() 
		base:PaintCrosshairOuter( Crosshair, COLOR_WHITE )
		base:LVSPaintHitMarker( Crosshair )

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/17" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
		
				local Missile = self:GetNWEntity("Missile")
				if IsValid(Missile) then
					local X = ScrW()
					local Y = ScrH()
					surface.SetDrawColor( Color(255,0,0,255) )
					surface.DrawLine(X*0.5,Y*0.465,X*0.5,Y*0.075)
					surface.DrawLine(X*0.5,Y*0.915,X*0.5,Y*0.535)
					surface.DrawLine(X*0.48,Y*0.5,X*0.27,Y*0.5)
					surface.DrawLine(X*0.73,Y*0.5,X*0.52,Y*0.5)
					surface.DrawLine(X*0.55,Y*0.525,X*0.55,Y*0.475)
					surface.DrawLine(X*0.475,Y*0.415,X*0.475,Y*0.45)
					surface.DrawLine(X*0.465,Y*0.4325,X*0.485,Y*0.4325)
				end
			end
		end
	end
	konkurs.OnSelect = function( ent )
		self:SetHatch(true)
	end
	konkurs.OnDeselect = function( ent )
		self:SetHatch(false)
	end
	konkurs.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

				local ID = self:LookupAttachment( "view_atgm" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				view.drawviewer = true
				return view	
			else
				local ID = self:LookupAttachment( "turret" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos-Attachment.Ang:Right()*5+Attachment.Ang:Up()*35-Attachment.Ang:Forward()*5
				view.fov = 90
				view.drawviewer = true
				return view	
			end
		else
			local ID = self:LookupAttachment( "muzzle_atgm" )
			local Attachment = self:GetAttachment( ID )
			return self:LVSCalcView( ply, Attachment.Pos+Attachment.Ang:Up()*15+Attachment.Ang:Right()*20, angles, fov, pod )
		end
	end
	self:AddWeapon( konkurs, 2 )

	local smoke = {}
	smoke.Icon = Material("icons/smoke_launcher")
	smoke.Ammo = 6
	smoke.Delay = 0.5
	smoke.HeatRateUp = 0
	smoke.HeatRateDown = 0
	smoke.Attack = function( ent )
		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 6 then
			ent._MuzzleID = 1
		end

		local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )

		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		if not IsValid( self.SNDSmoke1 ) then return end
		self.SNDSmoke1:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Pos )
		grenade:SetAngles( Muzzle.Ang )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 
		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(1,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)

		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 6 then
			ent._MuzzleID = 1
		end

		local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )

		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		if not IsValid( self.SNDSmoke1 ) then return end
		self.SNDSmoke1:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Pos )
		grenade:SetAngles( Muzzle.Ang+Angle(math.random(-3,3),math.random(-3,3),math.random(-3,3)) )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 
		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(1,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)
	end
	smoke.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 30
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -4, 30 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )
		
		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	smoke.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local Crosshair = tr.HitPos:ToScreen() 
		if self:GetUseHighExplosive() then
			base:PaintCrosshairSquare( Crosshair, COLOR_WHITE )
		else
			base:PaintCrosshairOuter( Crosshair, COLOR_WHITE )
		end
		base:LVSPaintHitMarker( Crosshair )
	
		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a28_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a28_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat )
				end
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
			end
		end
		local ID = self:LookupAttachment( "turret" )
		local Turret = self:GetAttachment( ID )
		local X = ScrW()/2
		local Y = ScrH()/2
		local body_mat = Material( "models/sw/shared/ui/traverse_body" )
		local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
		local view_mat = Material( "models/sw/shared/ui/traverse_view" )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( body_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
		surface.SetMaterial( turret_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
	end
	smoke.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				view.drawviewer = true
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = 90
				view.drawviewer = true
				return view	
			end
		else
			local ID = self:LookupAttachment( "muzzle" )
			local Attachment = self:GetAttachment( ID )
			return self:LVSCalcView( ply, Attachment.Pos+Attachment.Ang:Up()*25+Attachment.Ang:Right()*40, angles, fov, pod )
		end
	end
	self:AddWeapon( smoke, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local Crosshair = tr.HitPos:ToScreen() 
		if self:GetUseHighExplosive() then
			base:PaintCrosshairSquare( Crosshair, COLOR_WHITE )
		else
			base:PaintCrosshairOuter( Crosshair, COLOR_WHITE )
		end
		base:LVSPaintHitMarker( Crosshair )

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a28_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a28_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat )
				end
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
			end
		end

		local ID = self:LookupAttachment( "turret" )
		local Turret = self:GetAttachment( ID )
		local X = ScrW()/2
		local Y = ScrH()/2
		local body_mat = Material( "models/sw/shared/ui/traverse_body" )
		local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
		local view_mat = Material( "models/sw/shared/ui/traverse_view" )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( body_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
		surface.SetMaterial( turret_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				view.drawviewer = true
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = 90
				view.drawviewer = true
				return view	
			end
		else
			local ID = self:LookupAttachment( "turret" )
			local Attachment = self:GetAttachment( ID )
			return self:LVSCalcView( ply, Attachment.Pos, angles, fov, pod )
		end
	end
	self:AddWeapon( weapon, 2 )
end

sound.Add( 	{
	name = "SW_9K111_TRIGGER",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 85,
	sound = "sw/bmp1/trigger.wav"
} )
sound.Add( 	{
	name = "SW_9K111_CAP",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 85,
	sound = "sw/bmp1/cap.wav"
} )
sound.Add( 	{
	name = "SW_9K111_PRELAUNCH",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "sw/bmp1/prelaunch.wav"
} )