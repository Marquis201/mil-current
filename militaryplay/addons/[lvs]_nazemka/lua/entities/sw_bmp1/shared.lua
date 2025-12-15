ENT.Base = "lvs_tank_wheeldrive"
ENT.PrintName = "BMP-1"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - БМП"

ENT.VehicleCategory = "БМП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/bmp1/bmp1.mdl"

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

	local malyutka = {}
	malyutka.Icon = Material("icons/kornet")
	malyutka.Ammo = 3
	malyutka.Delay = 10
	malyutka.HeatRateUp = 0
	malyutka.HeatRateDown = 0.1
	malyutka.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if IsValid(self:GetNWEntity("Missile")) then
			if IsValid(ent:GetDriver()) then
				if ent:GetDriver():lvsKeyDown("CAR_STEER_LEFT") then 
					base:SetPoseParameter("yaw", base:GetPoseParameter("yaw")+0.15 )
				elseif ent:GetDriver():lvsKeyDown("CAR_STEER_RIGHT") then 
					base:SetPoseParameter("yaw", base:GetPoseParameter("yaw")-0.15 )
				elseif ent:GetDriver():lvsKeyDown("CAR_THROTTLE") then 
					base:SetPoseParameter("pitch", base:GetPoseParameter("pitch")+0.15 )
				elseif ent:GetDriver():lvsKeyDown("CAR_BRAKE") then 
					base:SetPoseParameter("pitch", base:GetPoseParameter("pitch")-0.15 )
				end
			end
		else
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
	end
	malyutka.Attack = function( ent )
		local ID = self:LookupAttachment("muzzle_atgm")
		local Muzzle = self:GetAttachment(ID)
	
		if not Muzzle then return end

		if IsValid(self) then
			if not IsValid( self.SNDMis ) then return end
			self.SNDMis:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			local Driver = ent:GetDriver()
			local TargetDir = Muzzle.Ang:Forward()
			local tr = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = (Muzzle.Pos + TargetDir  * 999999),
				filter = ent
			} )
			local projectile = ents.Create("sw_rocket_9m14_v3")
			projectile:SetPos(Muzzle.Pos)
			projectile:SetAngles(Muzzle.Ang)
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.Armed = true
			projectile.Launcher = self
			projectile.GuidanceActive = true
			projectile.LaserGuided = true
			projectile.LaserCode = "view"
			projectile.target = tr.Entity
			projectile.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
			projectile:SetTracerScale(5)
			
			local Wire = constraint.Rope(self,projectile,0,0,Vector(15,0,70),Vector(0,0,0),30000,0,0.5,0.1)
			self:SetNWEntity("Wire",Wire)
			self:SetNWEntity("Missile",projectile)

			ParticleEffect("ins_weapon_rpg_frontblast",Muzzle.Pos,Muzzle.Ang,self)
	
			ent:TakeAmmo( 1 )	
		end
	end
	malyutka.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "view" )
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
	malyutka.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				if not IsValid(self:GetNWEntity("Missile")) then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0
				end

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
	self:AddWeapon( malyutka, 2 )

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
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, angles, fov, pod )
		end
	end
	self:AddWeapon( weapon, 2 )
end