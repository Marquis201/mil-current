ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "UH-60"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Воздух"
ENT.Subcategory = "[НАТО]"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.HudColor = Color(0,255,0,150)
ENT.HudThirdPerson = true

ENT.MDL = "models/sw/avia/uh60/uh60.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1000
ENT.MaxHealthFuelTank = 150

ENT.MaxVelocity = 1500

ENT.ThrustUp = 1
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.05
ENT.ThrottleRateDown = 0.05

ENT.TurnRatePitch = 0.75
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 0.75

ENT.ForceLinearDampingMultiplier = 1.5

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.EngineSounds = {
	{
		sound = "sw/uh60/rotor_loop_close.wav",
		sound_int = "sw/uh60/int_engine.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 105,
		UseDoppler = true,
	},
	{
		sound = "sw/uh60/rotor_loop_dist.wav",
		sound_int = "sw/uh60/rotor_loop_int.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 105,
		UseDoppler = true,
	},
	{
		sound = "sw/vehicles/rotor_far.wav",
		sound_int = "",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 150,
		UseDoppler = true,
	},
}

ENT.Loadouts = 1

function ENT:OnSetupDataTables()
	self:AddDT( "Int", "Loadout" , { KeyName = "loadout",	Edit = { type = "Int",	order = 3, min = 0, max = self.Loadouts, category = "Weapons"} } )
	self:AddDT( "Entity", "GunnerRSeat" )
	self:AddDT( "Entity", "GunnerLSeat" )
	self:AddDT( "Entity", "FuelTank" )
	self:AddDT( "Bool", "Doors" )
	self:AddDT( "Bool", "MGR" )
	self:AddDT( "Bool", "MGL" )
end

function ENT:InitWeapons()
	local loadout = self:GetNWInt("Loadout")

	local flares = {}
	flares.Icon = Material("icons/flares.png")
	flares.Ammo = 128
	flares.Delay = 0.25
	flares.HeatRateUp = 1.5
	flares.HeatRateDown = 0.75
	flares.UseableByAI = false
	flares.Attack = function( ent )
		self:EmitSound("sw/misc/flr_"..math.random(1,3)..".wav")
		local projectile = ents.Create("sw_flare_v3")
		projectile:SetPos(self:LocalToWorld(Vector(-173.2,21.5,61.45)))
		projectile:SetAngles(self:LocalToWorldAngles(Angle(-math.random(110,125),-math.random(25,35),0)))
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter(projectile:GetForward()*1000)

		local projectile = ents.Create("sw_flare_v3")
		projectile:SetPos(self:LocalToWorld(Vector(-173.2,-21.5,61.45)))
		projectile:SetAngles(self:LocalToWorldAngles(Angle(-math.random(110,125),math.random(25,35),0)))
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter(projectile:GetForward()*1000)
		ent:TakeAmmo( 2 )	
	end
	self:AddWeapon( flares )

	local doors = {}
	doors.Icon = Material("icons/ramp.png")
	doors.UseableByAI = false
	doors.Ammo = -1
	doors.Delay = 0
	doors.HeatRateUp = 0
	doors.HeatRateDown = 1
	doors.StartAttack = function( ent )
		if ent:GetDoors() == false then
			ent:SetDoors(true)
		else
			ent:SetDoors(false)
		end
	end
	self:AddWeapon( doors )

	if loadout == 0 then
		local doors = {}
		doors.Icon = Material("icons/ramp.png")
		doors.UseableByAI = false
		doors.Ammo = -1
		doors.Delay = 0
		doors.HeatRateUp = 0
		doors.HeatRateDown = 1
		doors.StartAttack = function( ent )
			if self:GetMGR() == false then
				self:SetMGR(true)
			else
				self:SetMGR(false)
			end
		end
		self:AddWeapon( doors, 3 )

		
		local doors = {}
		doors.Icon = Material("icons/ramp.png")
		doors.UseableByAI = false
		doors.Ammo = -1
		doors.Delay = 0
		doors.HeatRateUp = 0
		doors.HeatRateDown = 1
		doors.StartAttack = function( ent )
			if self:GetMGL() == false then
				self:SetMGL(true)
			else
				self:SetMGL(false)
			end
		end
		self:AddWeapon( doors, 4 )
	else
		local mgr = {}
		mgr.Icon = Material("icons/mg3")
		mgr.Ammo = 1000
		mgr.Delay = 0.01
		mgr.HeatRateUp = 0.25
		mgr.HeatRateDown = 0.25
		mgr.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_r" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.EnableBallistics = true
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			self:ResetSequence("fire_r")
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		mgr.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGR ) then return end
			base.SNDTurretMGR:Play()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGRspin ) then return end
			base.SNDTurretMGRspin:Play()
		end
		mgr.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGR ) then return end
			base.SNDTurretMGR:Stop()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGRspin ) then return end
			base.SNDTurretMGRspin:Stop()
	
			if not IsValid( base ) or not IsValid( base.SNDTurretMGRstop ) then return end
			base.SNDTurretMGRstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		mgr.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_r" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
		end
		mgr.OnThink = function( ent, active )
			if not active or not self:GetMGR() then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = self:LookupAttachment( "muzzle_r" )
			local MG = self:GetAttachment( ID )
		
			if not MG then return end
			local trace = ent:GetEyeTrace()
			local _,Ang = WorldToLocal( Vector(0,0,0), (trace.HitPos - MG.Pos):GetNormalized():Angle(), Vector(0,0,0), self:LocalToWorldAngles( Angle(0,-90,0) ) )
			self:SetPoseParameter("pitch_r", -Ang.p )
			self:SetPoseParameter("yaw_r", -Ang.y )
		end
		mgr.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "muzzle_r" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos-Attachment.Ang:Forward()*55+Attachment.Ang:Up()*7
					view.angles = Attachment.Ang
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		self:AddWeapon( mgr, 3 )

		local mgl = {}
		mgl.Icon = Material("icons/mg3")
		mgl.Ammo = 1000
		mgl.Delay = 0.01
		mgl.HeatRateUp = 0.25
		mgl.HeatRateDown = 0.25
		mgl.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_l" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.EnableBallistics = true
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			self:ResetSequence("fire_l")
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		mgl.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGL ) then return end
			base.SNDTurretMGL:Play()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGLspin ) then return end
			base.SNDTurretMGLspin:Play()
		end
		mgl.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGL ) then return end
			base.SNDTurretMGL:Stop()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGLspin ) then return end
			base.SNDTurretMGLspin:Stop()
	
			if not IsValid( base ) or not IsValid( base.SNDTurretMGLstop ) then return end
			base.SNDTurretMGLstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		mgl.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_l" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
		end
		mgl.OnThink = function( ent, active )
			if not active or not self:GetMGR() then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = self:LookupAttachment( "muzzle_l" )
			local MG = self:GetAttachment( ID )
		
			if not MG then return end
			local trace = ent:GetEyeTrace()
			local _,Ang = WorldToLocal( Vector(0,0,0), (trace.HitPos - MG.Pos):GetNormalized():Angle(), Vector(0,0,0), self:LocalToWorldAngles( Angle(0,90,0) ) )
			self:SetPoseParameter("pitch_l", -Ang.p )
			self:SetPoseParameter("yaw_l", -Ang.y )
		end
		mgl.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "muzzle_l" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos-Attachment.Ang:Forward()*55+Attachment.Ang:Up()*7
					view.angles = Attachment.Ang
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		self:AddWeapon( mgl, 4 )
	end
end