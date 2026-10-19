
ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "MI-24A"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Воздух"
ENT.Subcategory = "[РФ]"

ENT.HudThirdPerson = false

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/avia/mi24a/mi24a.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1000
ENT.MaxHealthFuelTank = 150

ENT.MaxVelocity = 1600

ENT.ThrustUp = 1
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.05
ENT.ThrottleRateDown = 0.05

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.ForceLinearDampingMultiplier = 1.5

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.EngineSounds = {
	{
		sound = "sw/mi24a/rotor_loop_close.wav",
		sound_int = "sw/mi24a/int_engine.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 125,
		UseDoppler = true,
	},
	{
		sound = "sw/mi24a/rotor_loop_dist.wav",
		sound_int = "sw/mi24a/rotor_loop_int.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 125,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "FuelTank" )
end
function ENT:InitWeapons()
	local s5 = {}
	s5.Icon = Material("lvs/weapons/missile.png")
	s5.Ammo = 128
	s5.Delay = 0.15
	s5.HeatRateUp = 0
	s5.HeatRateDown = 0
	s5.Attack = function( ent )
		local fS = {
			Vector(-6.25,-71.3,28.55),
			Vector(-6.25,-94.9,23),
		}
		self.NumSec = self.NumSec and self.NumSec + 1 or 1
		if self.NumSec > 2 then self.NumSec = 1 end
		local Pos = self:LocalToWorld(fS[self.NumSec])
		ParticleEffect("ins_weapon_rpg_frontblast",Pos,self:GetAngles(),self)

		local projectile = ents.Create("sw_rocket_s5kp_v3")
		projectile:SetPos(Pos)
		projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
		projectile:Spawn()
		projectile:Activate()
		projectile.Armed = true
		projectile:Launch()
		projectile.RocketTrail = "rockettrail"
		projectile.BlastRadius = projectile.ExplosionRadius*2
		projectile.FragCount = 0
		projectile.FragRadius = 0
		projectile.Launcher = self
		constraint.NoCollide(self,projectile,0,0)
		constraint.NoCollide(projectile,self,0,0)
		constraint.NoCollide(self:GetNWEntity("WheelC"),projectile,0,0)
		constraint.NoCollide(projectile,self:GetNWEntity("WheelC"),0,0)
		constraint.NoCollide(self:GetNWEntity("WheelR"),projectile,0,0)
		constraint.NoCollide(projectile,self:GetNWEntity("WheelR"),0,0)
		constraint.NoCollide(self:GetNWEntity("WheelL"),projectile,0,0)
		constraint.NoCollide(projectile,self:GetNWEntity("WheelL"),0,0)

		if not IsValid( self.SNDRktR ) then return end
		self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local fS2 = {
			Vector(-6.25,70.4,34.5),
			Vector(-6.25,93.95,31),
		}
		self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
		if self.NumSec2 > 2 then self.NumSec2 = 1 end
		local Pos2 = self:LocalToWorld(fS2[self.NumSec2])
		ParticleEffect("ins_weapon_rpg_frontblast",Pos2,self:GetAngles(),self)

		local projectile = ents.Create("sw_rocket_s5kp_v3")
		projectile:SetPos(Pos2)
		projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
		projectile:Spawn()
		projectile:Activate()
		projectile.Armed = true
		projectile:Launch()
		projectile.RocketTrail = "rockettrail"
		projectile.BlastRadius = projectile.ExplosionRadius*2
		projectile.FragCount = 0
		projectile.FragRadius = 0
		projectile.Launcher = self
		constraint.NoCollide(self,projectile,0,0)
		constraint.NoCollide(projectile,self,0,0)
		constraint.NoCollide(self:GetNWEntity("WheelC"),projectile,0,0)
		constraint.NoCollide(projectile,self:GetNWEntity("WheelC"),0,0)
		constraint.NoCollide(self:GetNWEntity("WheelR"),projectile,0,0)
		constraint.NoCollide(projectile,self:GetNWEntity("WheelR"),0,0)
		constraint.NoCollide(self:GetNWEntity("WheelL"),projectile,0,0)
		constraint.NoCollide(projectile,self:GetNWEntity("WheelL"),0,0)

		if not IsValid( self.SNDRktL ) then return end
		self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		ent:TakeAmmo( 2 )	
	end
	s5.HudPaint = function( ent, X, Y, ply )
		if self:GetEngineActive() then
			local color_red = Color(255,255,255,255)
			local HudTargets = {}
			local Grav = physenv.GetGravity()
			local FT = RealFrameTime()
			local Pos = self:GetPos()+self:GetUp()*50
			local Vel = self:GetAngles():Forward()*3750
			cam.Start3D()
			local Iteration = 0
			while Iteration < 1000 do
				Iteration = Iteration + 1
			
				Vel = Vel + Grav * FT
			
				local StartPos = Pos
				local EndPos = Pos + Vel * FT
			
				local trace = util.TraceLine( {
					start = StartPos,
					endpos = EndPos,
					mask = MASK_SOLID_BRUSHONLY,
				} )
	
				Pos = EndPos
			
				if trace.Hit then
					break
				end
			end
			cam.End3D()	
			local TargetPos = Pos:ToScreen()
			surface.DrawCircle( TargetPos.x, TargetPos.y, 1.5 , color_red )
			surface.SetDrawColor(255,255,255,255)

			surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
			surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
			surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
			surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
		end
	end	
	self:AddWeapon( s5 )

	local a127 = {}
	a127.Icon = Material("lvs/weapons/hmg.png")
	a127.Ammo = 900
	a127.Delay = 0.05
	a127.HeatRateUp = 0.1
	a127.HeatRateDown = 0.1
	a127.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.EnableBallistics = true
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 3400
		bullet.HullSize = 15
		bullet.Damage	= 60
		bullet.Velocity = 40000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
		util.ScreenShake( Attachment.Pos, 0.5, 5, 1, 150, true, nil )

		ent:TakeAmmo( 1 )
	end
	a127.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Play()
	end
	a127.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Stop()
	end
	a127.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), Angles.p, 90*FrameTime() ), -0, 40 )
		local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), -Angles.y, 90*FrameTime() ), -30, 30 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	a127.HudPaint = function( ent, X, Y, ply )
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
		base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
		base:LVSPaintHitMarker( Crosshair )
	end
	self:AddWeapon( a127, 2 )

	local atgm = {}
	atgm.Icon = Material("lvs/weapons/missile.png")
	atgm.Ammo = 4
	atgm.Delay = 0.25
	atgm.HeatRateUp = 0
	atgm.HeatRateDown = 0
	atgm.UseableByAI = false
	atgm.Attack = function( ent )
		if IsValid(self:GetNWEntity("Missile")) then return end
		local ammo = ent:GetAmmo()
		ent:TakeAmmo( 1 )
		if istable( self.Missiles ) then
			if not IsValid( self.SNDMsl ) then return end
			self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local ID = self:LookupAttachment( "muzzle" )
			local Attachment = self:GetAttachment( ID )
			local Driver = ent:GetDriver()
			local TargetDir = Attachment.Ang:Forward()
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = (Attachment.Pos + TargetDir  * 999999),
				filter = ent
			} )

			local oldmis = self.Missiles[ammo]
			table.remove(self.Missiles,ammo + 1)
			if !IsValid(oldmis) then return end
			local mis = ents.Create("sw_rocket_9m17m_v3")
			mis:SetPos(oldmis:GetPos())
			mis:SetAngles(oldmis:GetAngles())
			mis:Spawn()
			mis:Activate()
			mis:SetTracerScale(10)
			mis:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
			mis:GetPhysicsObject():AddVelocity(mis:GetForward()*1000)

			mis:SetCollisionGroup(1)
			constraint.NoCollide(self,mis,0,0)
			constraint.NoCollide(mis,self,0,0)
			timer.Simple(0.5,function()
				if IsValid(mis) then
					mis:SetCollisionGroup(0)
				end
			end)
	
			timer.Simple(0.25,function()
				if IsValid(mis) then
					mis:Launch()
					mis.Armed = true
					mis.Launcher = self
					mis.GuidanceActive = true
					mis.LaserGuided = true
					mis.LaserCode = "muzzle"
					mis.target = tr.Entity
					mis.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
					self:SetNWEntity("Missile",mis)
					oldmis:Remove()
				end
			end)
		end
	end
	atgm.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), Angles.p, 90*FrameTime() ), -0, 40 )
		local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), -Angles.y, 90*FrameTime() ), -30, 30 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	atgm.HudPaint = function( ent, X, Y, ply )
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
		base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
		base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
		base:LVSPaintHitMarker( Crosshair )
	end
	self:AddWeapon( atgm, 2 )
end

--Gear stuff
function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Vector", "Steer" )
	self:AddDT( "Vector", "AIAimVector" )
	self:AddDT( "Float", "Throttle" )
	self:AddDT( "Float", "NWThrust" )
	self:AddDT( "Float", "LandingGear" )
	
	if SERVER then
		self:SetLandingGear( 1 )
	end
end
function ENT:PlayerDirectInput( ply, cmd )
	local Pod = self:GetDriverSeat()

	local Delta = FrameTime()

	local KeyLeft = ply:lvsKeyDown( "-ROLL_HELI" )
	local KeyRight = ply:lvsKeyDown( "+ROLL_HELI" )
	local KeyPitchUp = ply:lvsKeyDown( "+PITCH_HELI" )
	local KeyPitchDown = ply:lvsKeyDown( "-PITCH_HELI" )
	local KeyRollRight = ply:lvsKeyDown( "+YAW_HELI" )
	local KeyRollLeft = ply:lvsKeyDown( "-YAW_HELI" )

	local MouseX = cmd:GetMouseX()
	local MouseY = cmd:GetMouseY()

	if ply:lvsKeyDown( "FREELOOK" ) and not Pod:GetThirdPersonMode() then
		MouseX = 0
		MouseY = 0
	else
		ply:SetEyeAngles( Angle(0,90,0) )
	end

	local SensX, SensY, ReturnDelta = ply:lvsMouseSensitivity()

	if KeyPitchDown then MouseY = (10 / SensY) * ReturnDelta end
	if KeyPitchUp then MouseY = -(10 / SensY) * ReturnDelta end
	if KeyRollRight or KeyRollLeft then
		local NewX = (KeyRollRight and 10 or 0) - (KeyRollLeft and 10 or 0)

		MouseX = (NewX / SensX) * ReturnDelta
	end

	local Input = Vector( MouseX * 0.4 * SensX, MouseY * SensY, 0 )

	local Cur = self:GetSteer()

	local Rate = Delta * 3 * ReturnDelta

	local New = Vector(Cur.x, Cur.y, 0) - Vector( math.Clamp(Cur.x * Delta * 5 * ReturnDelta,-Rate,Rate), math.Clamp(Cur.y * Delta * 5 * ReturnDelta,-Rate,Rate), 0)

	local Target = New + Input * Delta * 0.8

	local Fx = math.Clamp( Target.x, -1, 1 )
	local Fy = math.Clamp( Target.y, -1, 1 )

	local TargetFz = (KeyLeft and 1 or 0) - (KeyRight and 1 or 0)
	local Fz = Cur.z + math.Clamp(TargetFz - Cur.z,-Rate * 3,Rate * 3)

	local F = Cur + (Vector( Fx, Fy, Fz ) - Cur) * math.min(Delta * 100,1)

	self:SetSteer( F )

	if CLIENT then return end

	if ply:lvsKeyDown( "HELI_HOVER" ) then
		self:CalcHover( ply:lvsKeyDown( "-YAW_HELI" ), ply:lvsKeyDown( "+YAW_HELI" ), KeyPitchUp, KeyPitchDown, ply:lvsKeyDown( "+THRUST_HELI" ), ply:lvsKeyDown( "-THRUST_HELI" ) )

		self.ResetSteer = true

	else
		if self.ResetSteer then
			self.ResetSteer = nil

			self:SetSteer( Vector(0,0,0) )
		end

		self:CalcThrust( ply:lvsKeyDown( "+THRUST_HELI" ), ply:lvsKeyDown( "-THRUST_HELI" ) )
	end
end
function ENT:StartCommand( ply, cmd )
	if self:GetDriver() ~= ply then return end

	if SERVER then
		local KeyJump = ply:lvsKeyDown( "VSPEC" )

		if self._lvsOldKeyJump ~= KeyJump then
			self._lvsOldKeyJump = KeyJump

			if KeyJump then
				self:ToggleVehicleSpecific()
				self:ToggleLandingGear()
				self:PhysWake()
			end
		end
	end

	if not ply:lvsMouseAim() then
		self:PlayerDirectInput( ply, cmd )
	end
end