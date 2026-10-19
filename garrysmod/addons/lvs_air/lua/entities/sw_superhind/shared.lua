
ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "MI-24 Super Hind Mk.III"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Воздух"
ENT.Subcategory = "[РФ]"

ENT.HudThirdPerson = true
ENT.HudColor = Color(0,255,0,150)

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/avia/superhind/superhind.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1000
ENT.MaxHealthFuelTank = 150

ENT.MaxVelocity = 1800

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

ENT.Pylons = {
	Vector(-54.2,-77,67),
	Vector(-54.2,77,67),
	Vector(-54.2,-104.6,62),
	Vector(-54.2,104.6,62),
	Vector(-54.2,-142,63.15),
	Vector(-54.2,142,63.15),
}
ENT.Loadouts = 12

local DefMats = {}
local DefClrs = {}
local ColorTab = 
{
	[ "$pp_colour_addr" ] 		= -.3,
	[ "$pp_colour_addg" ] 		= -.4,
	[ "$pp_colour_addb" ] 		= -.4,
	[ "$pp_colour_brightness" ] 	= .1,
	[ "$pp_colour_contrast" ] 	= 1,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0,
}	
local colBlack = Color( 0, 0, 0, 255 )
local pairs = pairs
local string = string
local render = render
local DoXRay = false
local function XRayMat()
	for k,v in pairs( ents.GetAll() ) do					
		if string.sub( (v:GetModel() or "" ), -3) == "mdl" then						
			local r = v:GetColor().r
			local g = v:GetColor().g
			local b = v:GetColor().b
			local a = v:GetColor().a
			if (a > 0) then								
				local entmat = v:GetMaterial()					
				if v:IsNPC() or v:IsPlayer() then								
					if not (r == 255 and g == 255 and b == 255 and a == 255) then
						DefClrs[ v ] = Color( r, g, b, a )
						v:SetColor(Color(255,255,255,255))
					end									
					if entmat ~= "xray/living" then
						DefMats[ v ] = entmat
						v:SetMaterial( "xray/living" )
					end
					
				else
					if not (r == 255 and g == 255 and b == 255 and a == 255) then
						DefClrs[ v ] = Color( r, g, b, a )
						v:SetColor(Color(255,255,255,255))
					end									
					if entmat ~= "xray/prop" then
						DefMats[ v ] = entmat
						v:SetMaterial( "xray/living" )
					end					
				end
			end							
		end					
	end							
end		
local function XRayFX() 
	DrawColorModify( ColorTab ) 
	DrawBloom(0,1,1,1,0,0,0,0,0 )
	DrawMotionBlur(FrameTime() * 50, 0.5, 0.05)
	DrawBokehDOF( 0.15, 1, 12 )
end

function ENT:OnSetupDataTables()
	self:AddDT( "Int", "Loadout" , { KeyName = "loadout",	Edit = { type = "Int",	order = 3, min = 1, max = self.Loadouts, category = "Weapons"} } )

	self:AddDT( "Bool", "FLIR" )
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "FuelTank" )

	self:AddDT( "Entity", "ClosestEnt" )
	self:AddDT( "Float", "ClosestDist" )
	self:AddDT( "Bool", "IsLocked" )
	self:AddDT( "Int", "LockTimer" )
	self:AddDT( "Int", "SeekerAngle" )
	self:AddDT( "Int", "SeekerDist" )
	self:SetIsLocked( false )
	self:SetClosestDist(0)
	self:SetClosestEnt(nil)
	hook.Add( "LVS.PlayerLeaveVehicle", "ExitFLIR", function( ply, veh )
		if veh == self then
			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
	end )
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
		projectile:SetPos(self:LocalToWorld(Vector(-100,35,115)))
		projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-3,3),90,math.Rand(-3,3)))
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter((self:LocalToWorldAngles(Angle(0,math.Rand(85,90),0))):Forward()*math.Rand(800,1000))

		local projectile = ents.Create("sw_flare_v3")
		projectile:SetPos(self:LocalToWorld(Vector(-100,-35,115)))
		projectile:SetAngles(self:GetAngles()-Angle(math.Rand(-3,3),90,math.Rand(-3,3)))
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter((self:LocalToWorldAngles(Angle(0,-math.Rand(85,90),0))):Forward()*math.Rand(800,1000))
		ent:TakeAmmo( 2 )	
	end
	self:AddWeapon( flares )

	if loadout == 1 then
		local ffar = {}
		ffar.Icon = Material("lvs/weapons/missile.png")
		ffar.Ammo = 76
		ffar.Delay = 0.15
		ffar.HeatRateUp = 0
		ffar.HeatRateDown = 0
		ffar.Attack = function( ent )

			local fS = {
				Vector(-34.2,77,57),
				Vector(-34.2,104.6,52),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			local fS2 = {
				Vector(-34.2,-77,57),
				Vector(-34.2,-104.6,52),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec2]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS2[self.NumSec2]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s8ko_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		ffar.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = self:GetAngles():Forward()*4100
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( ffar )
	elseif loadout == 2 then
		local zuni = {}
		zuni.Icon = Material("lvs/weapons/missile.png")
		zuni.Ammo = 16
		zuni.Delay = 0.5
		zuni.HeatRateUp = 0
		zuni.HeatRateDown = 0
		zuni.Attack = function( ent )

			local fS = {
				Vector(-34.2,77,57),
				Vector(-34.2,104.6,52),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			local fS2 = {
				Vector(-34.2,-77,57),
				Vector(-34.2,-104.6,52),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec2]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS2[self.NumSec2]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		zuni.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = self:GetAngles():Forward()*4100
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( zuni )
	elseif loadout == 3 then
		local gpu2a = {}
		gpu2a.Icon = Material("lvs/weapons/hmg.png")
		gpu2a.Ammo = 1200
		gpu2a.Delay = 0.04
		gpu2a.HeatRateUp = 0.25
		gpu2a.HeatRateDown = 0.25
		gpu2a.Attack = function( ent )
			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(15,-77,56))
			bullet.Dir 	= self:GetForward()
			bullet.Spread 	= Vector(0.018,0.018,0.018)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 5100
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(15,-77,56)),self:GetAngles(),nil)

			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(15,77,56))
			bullet.Dir 	= self:GetForward()
			bullet.Spread 	= Vector(0.018,0.018,0.018)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 5100
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(15,77,56)),self:GetAngles(),nil)

			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(15,-104.6,51))
			bullet.Dir 	= self:GetForward()
			bullet.Spread 	= Vector(0.018,0.018,0.018)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 5100
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(15,-104.6,51)),self:GetAngles(),nil)

			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(15,104.6,51))
			bullet.Dir 	= self:GetForward()
			bullet.Spread 	= Vector(0.018,0.018,0.018)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 5100
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(15,104.6,51)),self:GetAngles(),nil)
	
			ent:TakeAmmo( 4 )
		end
		gpu2a.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDGPU ) then return end
			base.SNDGPU:Play()
		end
		gpu2a.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDGPU ) then return end
			base.SNDGPU:Stop()
		end
		self:AddWeapon( gpu2a )
	elseif loadout == 4 then
		local ffar = {}
		ffar.Icon = Material("lvs/weapons/missile.png")
		ffar.Ammo = 38
		ffar.Delay = 0.15
		ffar.HeatRateUp = 0
		ffar.HeatRateDown = 0
		ffar.Attack = function( ent )
			local Pos = self:LocalToWorld(Vector(-34.2,77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",Pos,self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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

			local Pos2 = self:LocalToWorld(Vector(-34.2,-77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",Pos,self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s8ko_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		ffar.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = self:GetAngles():Forward()*4100
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( ffar )

		local aim9 = {}
		aim9.Icon = Material("lvs/weapons/missile.png")
		aim9.Ammo = 2
		aim9.Delay = 0.25
		aim9.HeatRateUp = 0
		aim9.HeatRateDown = 0.5
		aim9.Attack = function( ent )
			if self:GetIsLocked() and IsValid(self:GetClosestEnt()) then
				local ammo = ent:GetAmmo()
				ent:TakeAmmo( 1 )
				if istable( self.AAMs ) then
					local oldmis = self.AAMs[ammo]
					table.remove(self.AAMs,ammo + 1)
					if !IsValid(oldmis) then return end
					
					local projectile = ents.Create("sw_base_rocket_v3")
					projectile.Model = "models/sw/usa/missiles/aam/aim9l.mdl"
					projectile.RocketTrail = "Med_mis_thrust"
					projectile.RocketBurnoutTrail = "Med_mis_burnout"
					projectile.MaxVelocity = 850
					projectile.Agility = 125
					projectile.FuelBurnoutTime = 10
					projectile.ExplosionDamage = 4500
					projectile.ExplosionRadius = 150
					projectile.BlastRadius = 300
					projectile.FragDamage = 450
					projectile.FragRadius = 450
					projectile.FragCount =	500
					projectile.IRunstable = true
					projectile.SeekerCone = 35
					projectile:SetPos(oldmis:GetPos())
					projectile:SetAngles(oldmis:GetAngles())
					projectile:Spawn()
					projectile:Activate()
					projectile:GetPhysicsObject():AddVelocity(projectile:GetForward()*1500)
					projectile:SetCollisionGroup(10)
					constraint.NoCollide(self,projectile,0,0)
					constraint.NoCollide(projectile,self,0,0)
			
					if not IsValid( self.SNDMsl ) then return end
					self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					
					projectile:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
	
					projectile.target = self:GetClosestEnt()
					projectile.targetOffset = projectile.target:WorldToLocal(projectile.target:GetPos())
					projectile.calcTarget = function(r)
						if !IsValid(r.target) then
							return r:GetPos() + r:GetForward()
						else
							return r.target:LocalToWorld(r.targetOffset)
						end
					end
					self:SetIsLocked(false)
					self:SetClosestEnt(NULL)
	
					timer.Simple(0.5,function()
						if IsValid(projectile) then
							projectile:SetCollisionGroup(0)
							projectile:Launch()
							projectile:SetRadioFuze(true)
							projectile:SetRadioFuzeRadius(250)
							projectile.Armed = true
							projectile.Launcher = self
							projectile.GuidanceActive = true
						end
					end)
					oldmis:Remove()
					if self.TrackSND then
						self.TrackSND:Stop()
					end
					if self.LockSND then
						self.LockSND:Stop()
					end
					ent:SetHeat(1)
				end
			end
		end
		aim9.OnThink = function( ent, active )
			if active then
				self:Seeker()
			end
		end
		aim9.OnSelect = function( ent )
			self:SetSeekerDist(20000)
			self:SetSeekerAngle(10)
			self:SetLockTimer(1)
		end
		aim9.HudPaint = function( ent, X, Y, ply )
			local startpos = self:GetPos()
	
			local tr = util.TraceLine( {
				start = startpos,
				endpos = startpos + self:GetAimVector():Angle():Forward() * 500000,
				filter = self:GetCrosshairFilterEnts()
			} )
			local Crosshair = tr.HitPos:ToScreen() 
	
			if self:GetIsLocked() then
				self.LockCol = Color( 255, 0, 0, 255 )
			else
				self.LockCol = Color( 255, 255, 255, 255 )
			end
		
			local Alpha = self.LockCol.a / 255
			local Shadow = Color( 0, 0, 0, 80 * Alpha )
		
			if IsValid(self:GetClosestEnt()) then
				local TarPos = self:GetClosestEnt():GetPos():ToScreen()
	
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( TarPos.x, TarPos.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)+1, Shadow )
			else
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)+1, Shadow )
			end
	
			surface.DrawCircle( Crosshair.x,Crosshair.y, (self:GetSeekerAngle()*16)-1, Shadow )
			surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*16, self.LockCol )
			surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*16)+1, Shadow )
		end
		self:AddWeapon( aim9 )
	elseif loadout == 5 then
		local zuni = {}
		zuni.Icon = Material("lvs/weapons/missile.png")
		zuni.Ammo = 8
		zuni.Delay = 0.5
		zuni.HeatRateUp = 0
		zuni.HeatRateDown = 0
		zuni.Attack = function( ent )
			local Pos = self:LocalToWorld(Vector(-34.2,77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Pos),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			local Pos2 = self:LocalToWorld(Vector(-34.2,-77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Pos2),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		zuni.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = self:GetAngles():Forward()*4100
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( zuni )

		local aim9 = {}
		aim9.Icon = Material("lvs/weapons/missile.png")
		aim9.Ammo = 2
		aim9.Delay = 0.25
		aim9.HeatRateUp = 0
		aim9.HeatRateDown = 0.5
		aim9.Attack = function( ent )
			if self:GetIsLocked() and IsValid(self:GetClosestEnt()) then
				local ammo = ent:GetAmmo()
				ent:TakeAmmo( 1 )
				if istable( self.AAMs ) then
					local oldmis = self.AAMs[ammo]
					table.remove(self.AAMs,ammo + 1)
					if !IsValid(oldmis) then return end
					
					local projectile = ents.Create("sw_base_rocket_v3")
					projectile.Model = "models/sw/usa/missiles/aam/aim9l.mdl"
					projectile.RocketTrail = "Med_mis_thrust"
					projectile.RocketBurnoutTrail = "Med_mis_burnout"
					projectile.MaxVelocity = 850
					projectile.Agility = 125
					projectile.FuelBurnoutTime = 10
					projectile.ExplosionDamage = 4500
					projectile.ExplosionRadius = 150
					projectile.BlastRadius = 300
					projectile.FragDamage = 450
					projectile.FragRadius = 450
					projectile.FragCount =	500
					projectile.IRunstable = true
					projectile.SeekerCone = 35
					projectile:SetPos(oldmis:GetPos())
					projectile:SetAngles(oldmis:GetAngles())
					projectile:Spawn()
					projectile:Activate()
					projectile:GetPhysicsObject():AddVelocity(projectile:GetForward()*1500)
					projectile:SetCollisionGroup(10)
					constraint.NoCollide(self,projectile,0,0)
					constraint.NoCollide(projectile,self,0,0)
			
					if not IsValid( self.SNDMsl ) then return end
					self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					
					projectile:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
	
					projectile.target = self:GetClosestEnt()
					projectile.targetOffset = projectile.target:WorldToLocal(projectile.target:GetPos())
					projectile.calcTarget = function(r)
						if !IsValid(r.target) then
							return r:GetPos() + r:GetForward()
						else
							return r.target:LocalToWorld(r.targetOffset)
						end
					end
					self:SetIsLocked(false)
					self:SetClosestEnt(NULL)
	
					timer.Simple(0.5,function()
						if IsValid(projectile) then
							projectile:SetCollisionGroup(0)
							projectile:Launch()
							projectile:SetRadioFuze(true)
							projectile:SetRadioFuzeRadius(250)
							projectile.Armed = true
							projectile.Launcher = self
							projectile.GuidanceActive = true
						end
					end)
					oldmis:Remove()
					if self.TrackSND then
						self.TrackSND:Stop()
					end
					if self.LockSND then
						self.LockSND:Stop()
					end
					ent:SetHeat(1)
				end
			end
		end
		aim9.OnThink = function( ent, active )
			if active then
				self:Seeker()
			end
		end
		aim9.OnSelect = function( ent )
			self:SetSeekerDist(20000)
			self:SetSeekerAngle(10)
			self:SetLockTimer(1)
		end
		aim9.HudPaint = function( ent, X, Y, ply )
			local startpos = self:GetPos()
	
			local tr = util.TraceLine( {
				start = startpos,
				endpos = startpos + self:GetAimVector():Angle():Forward() * 500000,
				filter = self:GetCrosshairFilterEnts()
			} )
			local Crosshair = tr.HitPos:ToScreen() 
	
			if self:GetIsLocked() then
				self.LockCol = Color( 255, 0, 0, 255 )
			else
				self.LockCol = Color( 255, 255, 255, 255 )
			end
		
			local Alpha = self.LockCol.a / 255
			local Shadow = Color( 0, 0, 0, 80 * Alpha )
		
			if IsValid(self:GetClosestEnt()) then
				local TarPos = self:GetClosestEnt():GetPos():ToScreen()
	
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( TarPos.x, TarPos.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)+1, Shadow )
			else
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)+1, Shadow )
			end
	
			surface.DrawCircle( Crosshair.x,Crosshair.y, (self:GetSeekerAngle()*16)-1, Shadow )
			surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*16, self.LockCol )
			surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*16)+1, Shadow )
		end
		self:AddWeapon( aim9 )
	elseif loadout == 6 then
		local gpu2a = {}
		gpu2a.Icon = Material("lvs/weapons/hmg.png")
		gpu2a.Ammo = 600
		gpu2a.Delay = 0.04
		gpu2a.HeatRateUp = 0.25
		gpu2a.HeatRateDown = 0.25
		gpu2a.Attack = function( ent )
			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(15,-77,56))
			bullet.Dir 	= self:GetForward()
			bullet.Spread 	= Vector(0.018,0.018,0.018)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 5100
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(15,-77,56)),self:GetAngles(),nil)

			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(15,77,56))
			bullet.Dir 	= self:GetForward()
			bullet.Spread 	= Vector(0.018,0.018,0.018)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 5100
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(15,77,56)),self:GetAngles(),nil)
	
			ent:TakeAmmo( 2 )
		end
		gpu2a.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDGPU ) then return end
			base.SNDGPU:Play()
		end
		gpu2a.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDGPU ) then return end
			base.SNDGPU:Stop()
		end
		self:AddWeapon( gpu2a )

		local aim9 = {}
		aim9.Icon = Material("lvs/weapons/missile.png")
		aim9.Ammo = 2
		aim9.Delay = 0.25
		aim9.HeatRateUp = 0
		aim9.HeatRateDown = 0.5
		aim9.Attack = function( ent )
			if self:GetIsLocked() and IsValid(self:GetClosestEnt()) then
				local ammo = ent:GetAmmo()
				ent:TakeAmmo( 1 )
				if istable( self.AAMs ) then
					local oldmis = self.AAMs[ammo]
					table.remove(self.AAMs,ammo + 1)
					if !IsValid(oldmis) then return end
					
					local projectile = ents.Create("sw_base_rocket_v3")
					projectile.Model = "models/sw/usa/missiles/aam/aim9l.mdl"
					projectile.RocketTrail = "Med_mis_thrust"
					projectile.RocketBurnoutTrail = "Med_mis_burnout"
					projectile.MaxVelocity = 850
					projectile.Agility = 125
					projectile.FuelBurnoutTime = 10
					projectile.ExplosionDamage = 4500
					projectile.ExplosionRadius = 150
					projectile.BlastRadius = 300
					projectile.FragDamage = 450
					projectile.FragRadius = 450
					projectile.FragCount =	500
					projectile.IRunstable = true
					projectile.SeekerCone = 35
					projectile:SetPos(oldmis:GetPos())
					projectile:SetAngles(oldmis:GetAngles())
					projectile:Spawn()
					projectile:Activate()
					projectile:GetPhysicsObject():AddVelocity(projectile:GetForward()*1500)
					projectile:SetCollisionGroup(10)
					constraint.NoCollide(self,projectile,0,0)
					constraint.NoCollide(projectile,self,0,0)
			
					if not IsValid( self.SNDMsl ) then return end
					self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					
					projectile:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
	
					projectile.target = self:GetClosestEnt()
					projectile.targetOffset = projectile.target:WorldToLocal(projectile.target:GetPos())
					projectile.calcTarget = function(r)
						if !IsValid(r.target) then
							return r:GetPos() + r:GetForward()
						else
							return r.target:LocalToWorld(r.targetOffset)
						end
					end
					self:SetIsLocked(false)
					self:SetClosestEnt(NULL)
	
					timer.Simple(0.5,function()
						if IsValid(projectile) then
							projectile:SetCollisionGroup(0)
							projectile:Launch()
							projectile:SetRadioFuze(true)
							projectile:SetRadioFuzeRadius(250)
							projectile.Armed = true
							projectile.Launcher = self
							projectile.GuidanceActive = true
						end
					end)
					oldmis:Remove()
					if self.TrackSND then
						self.TrackSND:Stop()
					end
					if self.LockSND then
						self.LockSND:Stop()
					end
					ent:SetHeat(1)
				end
			end
		end
		aim9.OnThink = function( ent, active )
			if active then
				self:Seeker()
			end
		end
		aim9.OnSelect = function( ent )
			self:SetSeekerDist(20000)
			self:SetSeekerAngle(10)
			self:SetLockTimer(1)
		end
		aim9.HudPaint = function( ent, X, Y, ply )
			local startpos = self:GetPos()
	
			local tr = util.TraceLine( {
				start = startpos,
				endpos = startpos + self:GetAimVector():Angle():Forward() * 500000,
				filter = self:GetCrosshairFilterEnts()
			} )
			local Crosshair = tr.HitPos:ToScreen() 
	
			if self:GetIsLocked() then
				self.LockCol = Color( 255, 0, 0, 255 )
			else
				self.LockCol = Color( 255, 255, 255, 255 )
			end
		
			local Alpha = self.LockCol.a / 255
			local Shadow = Color( 0, 0, 0, 80 * Alpha )
		
			if IsValid(self:GetClosestEnt()) then
				local TarPos = self:GetClosestEnt():GetPos():ToScreen()
	
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( TarPos.x, TarPos.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)+1, Shadow )
			else
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)+1, Shadow )
			end
	
			surface.DrawCircle( Crosshair.x,Crosshair.y, (self:GetSeekerAngle()*16)-1, Shadow )
			surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*16, self.LockCol )
			surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*16)+1, Shadow )
		end
		self:AddWeapon( aim9 )
	elseif loadout == 7 then
		local s8 = {}
		s8.Icon = Material("lvs/weapons/missile.png")
		s8.Ammo = 80
		s8.Delay = 0.15
		s8.HeatRateUp = 0
		s8.HeatRateDown = 0
		s8.Attack = function( ent )

			local fS = {
				Vector(-34.2,77,57),
				Vector(-34.2,104.6,52),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s8ko_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			local fS2 = {
				Vector(-34.2,-77,57),
				Vector(-34.2,-104.6,52),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec2]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS2[self.NumSec2]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s8ko_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		s8.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( s8 )
	elseif loadout == 8 then
		local s13 = {}
		s13.Icon = Material("lvs/weapons/missile.png")
		s13.Ammo = 20
		s13.Delay = 0.5
		s13.HeatRateUp = 0
		s13.HeatRateDown = 0
		s13.Attack = function( ent )

			local fS = {
				Vector(-34.2,77,57),
				Vector(-34.2,104.6,52),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s13of_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			local fS2 = {
				Vector(-34.2,-77,57),
				Vector(-34.2,-104.6,52),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec2]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS2[self.NumSec2]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s13of_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		s13.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = self:GetAngles():Forward()*3500
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( s13 )
	elseif loadout == 9 then
		local upk23 = {}
		upk23.Icon = Material("lvs/weapons/hmg.png")
		upk23.Ammo = 1000
		upk23.Delay = 0.01
		upk23.HeatRateUp = 0
		upk23.HeatRateDown = 0
		upk23.Attack = function( ent )
	
			local fS = {
				Vector(-1,-79,61),
				Vector(-1,-75,61),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec])
			ParticleEffect("muzzleflash_m590_3rd",Pos,self:GetAngles(),nil)
			util.ScreenShake( Pos, 1, 10, 1, 350, true, nil )

			local bullet = {}
			bullet.Src = Pos
			bullet.Dir = self:GetForward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 500
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			local fS2 = {
				Vector(-1,79,61),
				Vector(-1,75,61),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec2])
			ParticleEffect("muzzleflash_m590_3rd",Pos2,self:GetAngles(),nil)
			util.ScreenShake( Pos2, 1, 10, 1, 350, true, nil )

			local bullet = {}
			bullet.Src = Pos2
			bullet.Dir = self:GetForward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 500
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )

			local fS3 = {
				Vector(-1,-106.6,56),
				Vector(-1,-102.6,56),
			}
			self.NumSec3 = self.NumSec3 and self.NumSec3 + 1 or 1
			if self.NumSec3 > 2 then self.NumSec3 = 1 end
			local Pos3 = self:LocalToWorld(fS3[self.NumSec3])
			ParticleEffect("muzzleflash_m590_3rd",Pos3,self:GetAngles(),nil)
			util.ScreenShake( Pos3, 1, 10, 1, 350, true, nil )

			local bullet = {}
			bullet.Src = Pos3
			bullet.Dir = self:GetForward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 500
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			local fS4 = {
				Vector(-1,106.6,56),
				Vector(-1,102.6,56),
			}
			self.NumSec4 = self.NumSec4 and self.NumSec4 + 1 or 1
			if self.NumSec4 > 2 then self.NumSec4 = 1 end
			local Pos4 = self:LocalToWorld(fS4[self.NumSec4])
			ParticleEffect("muzzleflash_m590_3rd",Pos4,self:GetAngles(),nil)
			util.ScreenShake( Pos4, 1, 10, 1, 350, true, nil )

			local bullet = {}
			bullet.Src = Pos4
			bullet.Dir = self:GetForward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 500
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ent:TakeAmmo( 4 )	
		end
		upk23.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDUpk ) then return end
			base.SNDUpk:Play()
		end
		upk23.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDUpk ) then return end
			base.SNDUpk:Stop()
	
			if not IsValid( base.SNDUpkStop ) then return end
			base.SNDUpkStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		self:AddWeapon( upk23 )
	elseif loadout == 10 then
		local s8 = {}
		s8.Icon = Material("lvs/weapons/missile.png")
		s8.Ammo = 40
		s8.Delay = 0.15
		s8.HeatRateUp = 0
		s8.HeatRateDown = 0
		s8.Attack = function( ent )
			local Pos = self:LocalToWorld(Vector(-34.2,77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(-34.2,77,57)),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s8ko_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			local Pos2 = self:LocalToWorld(Vector(-34.2,-77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(-34.2,-77,57)),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s8ko_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles()+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		s8.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( s8 )

		local r60 = {}
		r60.Icon = Material("lvs/weapons/missile.png")
		r60.Ammo = 4
		r60.Delay = 0.5
		r60.HeatRateUp = 0
		r60.HeatRateDown = 0.2
		r60.Attack = function( ent )
			if self:GetIsLocked() and IsValid(self:GetClosestEnt()) then
				local ammo = ent:GetAmmo()
				ent:TakeAmmo( 1 )
				if istable( self.Missiles ) then
					local oldmis = self.Missiles[ammo]
					table.remove(self.Missiles,ammo + 1)
					if !IsValid(oldmis) then return end
					if not IsValid( self.SNDMsl ) then return end
					self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					
					local projectile = ents.Create("sw_base_rocket_v3")
					projectile.Model = "models/sw/rus/missiles/aam/r60.mdl"
					projectile.RocketTrail = "Med_mis_thrust"
					projectile.RocketBurnoutTrail = "Med_mis_burnout"
					projectile.MaxVelocity = 850
					projectile.Agility = 100
					projectile.FuelBurnoutTime = 8
					projectile.ExplosionDamage = 3500
					projectile.ExplosionRadius = 250
					projectile.BlastRadius = 500
					projectile.FragDamage = 350
					projectile.FragRadius = 750
					projectile.FragCount =	500
					projectile.IRunstable = true
					projectile.SeekerCone = 35
					projectile:SetPos(oldmis:GetPos())
					projectile:SetAngles(oldmis:GetAngles())
					projectile:Spawn()
					projectile:Activate()
					projectile:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
					projectile:GetPhysicsObject():AddVelocity(projectile:GetForward()*1000)

					constraint.NoCollide(self,projectile,0,0)
					constraint.NoCollide(projectile,self,0,0)
					constraint.NoCollide(self:GetNWEntity("WheelC"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelC"),0,0)
					constraint.NoCollide(self:GetNWEntity("WheelR"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelR"),0,0)
					constraint.NoCollide(self:GetNWEntity("WheelL"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelL"),0,0)

					timer.Simple(0.5,function()
						if IsValid(projectile) then
							projectile:Launch()
							projectile:SetRadioFuze(true)
							projectile:SetRadioFuzeRadius(250)
							projectile.Armed = true
							projectile.Launcher = self
							projectile.GuidanceActive = true
							projectile.target = self:GetClosestEnt()
							projectile.targetOffset = projectile.target:WorldToLocal(projectile.target:GetPos())
							projectile.calcTarget = function(r)
								if !IsValid(r.target) then
									return r:GetPos() + r:GetForward()
								else
									return r.target:LocalToWorld(r.targetOffset)
								end
							end
							self:SetIsLocked(false)
						end
					end)
					oldmis:Remove()
					if self.TrackSND then
						self.TrackSND:Stop()
					end
					if self.LockSND then
						self.LockSND:Stop()
					end
					ent:SetHeat(1)
				end
			end
		end
		r60.OnThink = function( ent, active )
			if active then
				self:Seeker()
			end
		end
		r60.HudPaint = function( ent, X, Y, ply )
			local startpos = self:GetPos()+self:GetUp()*50+self:GetForward()*150
	
			local tr = util.TraceLine( {
				start = startpos,
				endpos = startpos + self:GetAimVector():Angle():Forward() * 500000,
				filter = self:GetCrosshairFilterEnts()
			} )
			local Crosshair = tr.HitPos:ToScreen() 
	
			if self:GetIsLocked() then
				self.LockCol = Color( 255, 0, 0, 255 )
			else
				self.LockCol = Color( 255, 255, 255, 255 )
			end
		
			local Alpha = self.LockCol.a / 255
			local Shadow = Color( 0, 0, 0, 80 * Alpha )
		
			if IsValid(self:GetClosestEnt()) then
				local TarPos = self:GetClosestEnt():GetPos():ToScreen()
	
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( TarPos.x, TarPos.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)+1, Shadow )
			else
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)+1, Shadow )
			end
	
			surface.DrawCircle( Crosshair.x,Crosshair.y, (self:GetSeekerAngle()*16)-1, Shadow )
			surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*16, self.LockCol )
			surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*16)+1, Shadow )
	
			self:LVSPaintHitMarker( Crosshair )
		end
		self:AddWeapon( r60 )
	elseif loadout == 11 then
		local s13 = {}
		s13.Icon = Material("lvs/weapons/missile.png")
		s13.Ammo = 10
		s13.Delay = 0.5
		s13.HeatRateUp = 0
		s13.HeatRateDown = 0
		s13.Attack = function( ent )
			local Pos = self:LocalToWorld(Vector(-34.2,77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(-34.2,77,57)),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s13of_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			local Pos2 = self:LocalToWorld(Vector(-34.2,-77,57)+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(-34.2,-77,57)),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_s13of_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
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
	
			ent:TakeAmmo( 2 )	
		end
		s13.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = self:GetAngles():Forward()*3500
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
				surface.SetDrawColor(0,255,0,255)

				surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
				surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
				surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )
			end
		end	
		self:AddWeapon( s13 )

		local r60 = {}
		r60.Icon = Material("lvs/weapons/missile.png")
		r60.Ammo = 4
		r60.Delay = 0.5
		r60.HeatRateUp = 0
		r60.HeatRateDown = 0.2
		r60.Attack = function( ent )
			if self:GetIsLocked() and IsValid(self:GetClosestEnt()) then
				local ammo = ent:GetAmmo()
				ent:TakeAmmo( 1 )
				if istable( self.Missiles ) then
					local oldmis = self.Missiles[ammo]
					table.remove(self.Missiles,ammo + 1)
					if !IsValid(oldmis) then return end
					if not IsValid( self.SNDMsl ) then return end
					self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					
					local projectile = ents.Create("sw_base_rocket_v3")
					projectile.Model = "models/sw/rus/missiles/aam/r60.mdl"
					projectile.RocketTrail = "Med_mis_thrust"
					projectile.RocketBurnoutTrail = "Med_mis_burnout"
					projectile.MaxVelocity = 850
					projectile.Agility = 100
					projectile.FuelBurnoutTime = 8
					projectile.ExplosionDamage = 3500
					projectile.ExplosionRadius = 250
					projectile.BlastRadius = 500
					projectile.FragDamage = 350
					projectile.FragRadius = 750
					projectile.FragCount =	500
					projectile.IRunstable = true
					projectile.SeekerCone = 35
					projectile:SetPos(oldmis:GetPos())
					projectile:SetAngles(oldmis:GetAngles())
					projectile:Spawn()
					projectile:Activate()
					projectile:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
					projectile:GetPhysicsObject():AddVelocity(projectile:GetForward()*1000)

					constraint.NoCollide(self,projectile,0,0)
					constraint.NoCollide(projectile,self,0,0)
					constraint.NoCollide(self:GetNWEntity("WheelC"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelC"),0,0)
					constraint.NoCollide(self:GetNWEntity("WheelR"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelR"),0,0)
					constraint.NoCollide(self:GetNWEntity("WheelL"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelL"),0,0)

					timer.Simple(0.5,function()
						if IsValid(projectile) then
							projectile:Launch()
							projectile:SetRadioFuze(true)
							projectile:SetRadioFuzeRadius(250)
							projectile.Armed = true
							projectile.Launcher = self
							projectile.GuidanceActive = true
							projectile.target = self:GetClosestEnt()
							projectile.targetOffset = projectile.target:WorldToLocal(projectile.target:GetPos())
							projectile.calcTarget = function(r)
								if !IsValid(r.target) then
									return r:GetPos() + r:GetForward()
								else
									return r.target:LocalToWorld(r.targetOffset)
								end
							end
							self:SetIsLocked(false)
						end
					end)
					oldmis:Remove()
					if self.TrackSND then
						self.TrackSND:Stop()
					end
					if self.LockSND then
						self.LockSND:Stop()
					end
					ent:SetHeat(1)
				end
			end
		end
		r60.OnThink = function( ent, active )
			if active then
				self:Seeker()
			end
		end
		r60.HudPaint = function( ent, X, Y, ply )
			local startpos = self:GetPos()+self:GetUp()*50+self:GetForward()*150
	
			local tr = util.TraceLine( {
				start = startpos,
				endpos = startpos + self:GetAimVector():Angle():Forward() * 500000,
				filter = self:GetCrosshairFilterEnts()
			} )
			local Crosshair = tr.HitPos:ToScreen() 
	
			if self:GetIsLocked() then
				self.LockCol = Color( 255, 0, 0, 255 )
			else
				self.LockCol = Color( 255, 255, 255, 255 )
			end
		
			local Alpha = self.LockCol.a / 255
			local Shadow = Color( 0, 0, 0, 80 * Alpha )
		
			if IsValid(self:GetClosestEnt()) then
				local TarPos = self:GetClosestEnt():GetPos():ToScreen()
	
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( TarPos.x, TarPos.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)+1, Shadow )
			else
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)+1, Shadow )
			end
	
			surface.DrawCircle( Crosshair.x,Crosshair.y, (self:GetSeekerAngle()*16)-1, Shadow )
			surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*16, self.LockCol )
			surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*16)+1, Shadow )
	
			self:LVSPaintHitMarker( Crosshair )
		end
		self:AddWeapon( r60 )
	elseif loadout == 12 then
		local upk23 = {}
		upk23.Icon = Material("lvs/weapons/hmg.png")
		upk23.Ammo = 500
		upk23.Delay = 0.01
		upk23.HeatRateUp = 0
		upk23.HeatRateDown = 0
		upk23.Attack = function( ent )
	
			local fS = {
				Vector(-1,-79,61),
				Vector(-1,-75,61),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec])
			ParticleEffect("muzzleflash_m590_3rd",Pos,self:GetAngles(),nil)
			util.ScreenShake( Pos, 1, 10, 1, 350, true, nil )

			local bullet = {}
			bullet.Src = Pos
			bullet.Dir = self:GetForward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 500
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			local fS2 = {
				Vector(-1,79,61),
				Vector(-1,75,61),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec2])
			ParticleEffect("muzzleflash_m590_3rd",Pos2,self:GetAngles(),nil)
			util.ScreenShake( Pos2, 1, 10, 1, 350, true, nil )

			local bullet = {}
			bullet.Src = Pos2
			bullet.Dir = self:GetForward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 500
			bullet.HullSize 	= 23
			bullet.Damage	= 85
			bullet.SplashDamage = 25
			bullet.SplashDamageRadius = 70
			bullet.Velocity = 31666
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ent:TakeAmmo( 2 )	
		end
		upk23.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDUpk ) then return end
			base.SNDUpk:Play()
		end
		upk23.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDUpk ) then return end
			base.SNDUpk:Stop()
	
			if not IsValid( base.SNDUpkStop ) then return end
			base.SNDUpkStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		self:AddWeapon( upk23 )

		local r60 = {}
		r60.Icon = Material("lvs/weapons/missile.png")
		r60.Ammo = 4
		r60.Delay = 0.5
		r60.HeatRateUp = 0
		r60.HeatRateDown = 0.2
		r60.Attack = function( ent )
			if self:GetIsLocked() and IsValid(self:GetClosestEnt()) then
				local ammo = ent:GetAmmo()
				ent:TakeAmmo( 1 )
				if istable( self.Missiles ) then
					local oldmis = self.Missiles[ammo]
					table.remove(self.Missiles,ammo + 1)
					if !IsValid(oldmis) then return end
					if not IsValid( self.SNDMsl ) then return end
					self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					
					local projectile = ents.Create("sw_base_rocket_v3")
					projectile.Model = "models/sw/rus/missiles/aam/r60.mdl"
					projectile.RocketTrail = "Med_mis_thrust"
					projectile.RocketBurnoutTrail = "Med_mis_burnout"
					projectile.MaxVelocity = 850
					projectile.Agility = 100
					projectile.FuelBurnoutTime = 8
					projectile.ExplosionDamage = 3500
					projectile.ExplosionRadius = 250
					projectile.BlastRadius = 500
					projectile.FragDamage = 350
					projectile.FragRadius = 750
					projectile.FragCount =	500
					projectile.IRunstable = true
					projectile.SeekerCone = 35
					projectile:SetPos(oldmis:GetPos())
					projectile:SetAngles(oldmis:GetAngles())
					projectile:Spawn()
					projectile:Activate()
					projectile:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
					projectile:GetPhysicsObject():AddVelocity(projectile:GetForward()*1000)

					constraint.NoCollide(self,projectile,0,0)
					constraint.NoCollide(projectile,self,0,0)
					constraint.NoCollide(self:GetNWEntity("WheelC"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelC"),0,0)
					constraint.NoCollide(self:GetNWEntity("WheelR"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelR"),0,0)
					constraint.NoCollide(self:GetNWEntity("WheelL"),projectile,0,0)
					constraint.NoCollide(projectile,self:GetNWEntity("WheelL"),0,0)

					timer.Simple(0.5,function()
						if IsValid(projectile) then
							projectile:Launch()
							projectile:SetRadioFuze(true)
							projectile:SetRadioFuzeRadius(250)
							projectile.Armed = true
							projectile.Launcher = self
							projectile.GuidanceActive = true
							projectile.target = self:GetClosestEnt()
							projectile.targetOffset = projectile.target:WorldToLocal(projectile.target:GetPos())
							projectile.calcTarget = function(r)
								if !IsValid(r.target) then
									return r:GetPos() + r:GetForward()
								else
									return r.target:LocalToWorld(r.targetOffset)
								end
							end
							self:SetIsLocked(false)
						end
					end)
					oldmis:Remove()
					if self.TrackSND then
						self.TrackSND:Stop()
					end
					if self.LockSND then
						self.LockSND:Stop()
					end
					ent:SetHeat(1)
				end
			end
		end
		r60.OnThink = function( ent, active )
			if active then
				self:Seeker()
			end
		end
		r60.HudPaint = function( ent, X, Y, ply )
			local startpos = self:GetPos()+self:GetUp()*50+self:GetForward()*150
	
			local tr = util.TraceLine( {
				start = startpos,
				endpos = startpos + self:GetAimVector():Angle():Forward() * 500000,
				filter = self:GetCrosshairFilterEnts()
			} )
			local Crosshair = tr.HitPos:ToScreen() 
	
			if self:GetIsLocked() then
				self.LockCol = Color( 255, 0, 0, 255 )
			else
				self.LockCol = Color( 255, 255, 255, 255 )
			end
		
			local Alpha = self.LockCol.a / 255
			local Shadow = Color( 0, 0, 0, 80 * Alpha )
		
			if IsValid(self:GetClosestEnt()) then
				local TarPos = self:GetClosestEnt():GetPos():ToScreen()
	
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( TarPos.x, TarPos.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( TarPos.x, TarPos.y, (self:GetSeekerAngle()*2)+1, Shadow )
			else
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)-1, Shadow )
				surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*2, self.LockCol )
				surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*2)+1, Shadow )
			end
	
			surface.DrawCircle( Crosshair.x,Crosshair.y, (self:GetSeekerAngle()*16)-1, Shadow )
			surface.DrawCircle( Crosshair.x, Crosshair.y, self:GetSeekerAngle()*16, self.LockCol )
			surface.DrawCircle( Crosshair.x, Crosshair.y, (self:GetSeekerAngle()*16)+1, Shadow )
	
			self:LVSPaintHitMarker( Crosshair )
		end
		self:AddWeapon( r60 )
	end

	local flir = {}
	flir.Icon = Material("lvs/weapons/light.png")
	flir.Ammo = -1
	flir.Delay = 0
	flir.HeatRateUp = 0
	flir.HeatRateDown = 0
	flir.UseableByAI = false
	flir.StartAttack = function( ent )
		if self:GetFLIR() then
			self:SetFLIR(false)
			self:EmitSound("sw/misc/switch_off.mp3")
			self:EmitSound("sw/misc/nv_off.wav")
		else
			self:SetFLIR(true)
			self:EmitSound("sw/misc/switch_on.mp3")
			self:EmitSound("sw/misc/nv_on.wav")			
		end
	end
	flir.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
		local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -105, 105 )
		local CPitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
		local CYaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_yaw"), Angles.y, 120*FrameTime() ), -105, 105 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
		base:SetPoseParameter("cam_yaw", CYaw )
		base:SetPoseParameter("cam_pitch", CPitch )
	end
	flir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "view" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/avia/mi35/camera" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW()*1.1, ScrH(), 0 )

				trtab = {}
				trtab.start = Attachment.Pos
				trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-"
				else
					range = range.."м"
				end
				surface.SetTextColor( 2, 92, 35, 255 )
				surface.SetTextPos( (ScrW()*0.45), (ScrH()/4.025) )
				surface.SetFont("SUPERHIND_SPD")
				surface.DrawText( "дист: "..range )

				local kmh = math.Round(self:GetVelocity():Length() * 0.09144,0)
				surface.SetTextColor( 2, 92, 35, 255 )
				surface.SetTextPos( (ScrW()*0.3425), (ScrH()/4.025) )
				surface.SetFont("SUPERHIND_SPD")
				surface.DrawText( kmh )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() then	
							hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
							hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
					
							DoXRay = true
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end				
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end
							DefMats = {}
							DefClrs = {}
						end
					else
						hook.Remove( "RenderScene", "XRay_ApplyMats" )
						hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
						DoXRay = false
						for ent,mat in pairs( DefMats ) do
							if ent:IsValid() then
								ent:SetMaterial( mat )
							end
						end			
						for ent,clr in pairs( DefClrs ) do
							if ent:IsValid() then
								ent:SetRenderMode(RENDERMODE_TRANSALPHA)
								ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
							end
						end			
						DefMats = {}
						DefClrs = {}
					end
				end
			else
				local Crosshair = tr.HitPos:ToScreen() 
				base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
				base:LVSPaintHitMarker( Crosshair )			

				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
		else
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
			
			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
	end
	flir.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				view.drawviewer = true
				return view	
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
		end
	end
	self:AddWeapon( flir, 2 )

	local f20 = {}
	f20.Icon = Material("lvs/weapons/hmg.png")
	f20.Ammo = 840
	f20.Delay = 0.08
	f20.HeatRateUp = 0.1
	f20.HeatRateDown = 0.1
	f20.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.EnableBallistics = true
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 5100
		bullet.HullSize 	= 23
		bullet.Damage	= 85
		bullet.SplashDamage = 25
		bullet.SplashDamageRadius = 70
		bullet.Velocity = 24000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
		util.ScreenShake( Attachment.Pos, 0.15, 1, 1, 350, true, nil )

		ent:TakeAmmo( 1 )
	end
	f20.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Play()
	end
	f20.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Stop()
		
		if not IsValid( base.SNDTurretStop ) then return end
		base.SNDTurretStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	f20.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
		local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -105, 105 )
		local CPitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
		local CYaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_yaw"), Angles.y, 120*FrameTime() ), -105, 105 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
		base:SetPoseParameter("cam_yaw", CYaw )
		base:SetPoseParameter("cam_pitch", CPitch )
	end
	f20.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "view" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/avia/mi35/camera" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW()*1.1, ScrH(), 0 )

				trtab = {}
				trtab.start = Attachment.Pos
				trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-"
				else
					range = range.."м"
				end
				surface.SetTextColor( 2, 92, 35, 255 )
				surface.SetTextPos( (ScrW()*0.45), (ScrH()/4.025) )
				surface.SetFont("SUPERHIND_SPD")
				surface.DrawText( "дист: "..range )

				local kmh = math.Round(self:GetVelocity():Length() * 0.09144,0)
				surface.SetTextColor( 2, 92, 35, 255 )
				surface.SetTextPos( (ScrW()*0.3425), (ScrH()/4.025) )
				surface.SetFont("SUPERHIND_SPD")
				surface.DrawText( kmh )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() then	
							hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
							hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
					
							DoXRay = true
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end				
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end
							DefMats = {}
							DefClrs = {}
						end
					else
						hook.Remove( "RenderScene", "XRay_ApplyMats" )
						hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
						DoXRay = false
						for ent,mat in pairs( DefMats ) do
							if ent:IsValid() then
								ent:SetMaterial( mat )
							end
						end			
						for ent,clr in pairs( DefClrs ) do
							if ent:IsValid() then
								ent:SetRenderMode(RENDERMODE_TRANSALPHA)
								ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
							end
						end			
						DefMats = {}
						DefClrs = {}
					end
				end
			else
				local Crosshair = tr.HitPos:ToScreen() 
				base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
				base:LVSPaintHitMarker( Crosshair )			

				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
		else
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
			
			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
	end
	f20.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				view.drawviewer = true
				return view	
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
		end
	end
	self:AddWeapon( f20, 2 )

	if loadout >= 1 and loadout <= 6 then
		local atgm = {}
		atgm.Icon = Material("lvs/weapons/missile.png")
		atgm.Ammo = 8
		atgm.Delay = 0.25
		atgm.HeatRateUp = 0
		atgm.HeatRateDown = 0
		atgm.UseableByAI = false
		atgm.Attack = function( ent )
			if ent:GetAI() or IsValid(self:GetNWEntity("Missile")) then return end
			local ammo = ent:GetAmmo()
			ent:TakeAmmo( 1 )
			if istable( self.AGMs ) then
	
				if not IsValid( self.SNDMsl ) then return end
				self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local Driver = ent:GetDriver()
				local TargetDir = Attachment.Ang:Forward()
				local tr = util.TraceLine( {
					start = Attachment.Pos,
					endpos = (Attachment.Pos + TargetDir  * 999999),
					filter = ent
				} )
	
				local oldmis = self.AGMs[ammo]
				table.remove(self.AGMs,ammo + 1)
				if !IsValid(oldmis) then return end
				local mis = ents.Create("sw_rocket_zt6_v3")
				mis:SetPos(oldmis:GetPos())
				mis:SetAngles(oldmis:GetAngles())
				mis:Spawn()
				mis:Activate()
				mis:Launch()
				mis.Armed = true
				mis.DiveHeight = 1000
				mis.Launcher = self
				mis.GuidanceActive = true
				mis.LaserGuided = true
				mis.LaserCode = "view"
				mis.target = tr.Entity
				mis.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
				self:SetNWEntity("Missile",mis)
				oldmis:Remove()
			end
		end
		atgm.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
			local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -105, 105 )
			local CPitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
			local CYaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_yaw"), Angles.y, 120*FrameTime() ), -105, 105 )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
			base:SetPoseParameter("cam_yaw", CYaw )
			base:SetPoseParameter("cam_pitch", CPitch )
		end
		atgm.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "view" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/avia/mi35/camera" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW()*1.1, ScrH(), 0 )
	
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."м"
					end
					surface.SetTextColor( 2, 92, 35, 255 )
					surface.SetTextPos( (ScrW()*0.45), (ScrH()/4.025) )
					surface.SetFont("SUPERHIND_SPD")
					surface.DrawText( "дист: "..range )
	
					local kmh = math.Round(self:GetVelocity():Length() * 0.09144,0)
					surface.SetTextColor( 2, 92, 35, 255 )
					surface.SetTextPos( (ScrW()*0.3425), (ScrH()/4.025) )
					surface.SetFont("SUPERHIND_SPD")
					surface.DrawText( kmh )
	
					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							if self:GetFLIR() then	
								hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
								hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
						
								DoXRay = true
							else
								hook.Remove( "RenderScene", "XRay_ApplyMats" )
								hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
								DoXRay = false
								for ent,mat in pairs( DefMats ) do
									if ent:IsValid() then
										ent:SetMaterial( mat )
									end
								end				
								for ent,clr in pairs( DefClrs ) do
									if ent:IsValid() then
										ent:SetRenderMode(RENDERMODE_TRANSALPHA)
										ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
									end
								end
								DefMats = {}
								DefClrs = {}
							end
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end			
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefMats = {}
							DefClrs = {}
						end
					end
				else
					local Crosshair = tr.HitPos:ToScreen() 
					base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
					base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
					base:LVSPaintHitMarker( Crosshair )			
	
					hook.Remove( "RenderScene", "XRay_ApplyMats" )
					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoXRay = false
					for ent,mat in pairs( DefMats ) do
						if ent:IsValid() then
							ent:SetMaterial( mat )
						end
					end			
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end			
					DefMats = {}
					DefClrs = {}
				end
			else
				local Crosshair = tr.HitPos:ToScreen() 
				base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
				base:LVSPaintHitMarker( Crosshair )
				
				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
		end
		atgm.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoom
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
			end
		end
		self:AddWeapon( atgm, 2 )
	elseif loadout >= 7 and loadout <= 12 then
		local atgm = {}
		atgm.Icon = Material("lvs/weapons/missile.png")
		atgm.Ammo = 8
		atgm.Delay = 0.25
		atgm.HeatRateUp = 0
		atgm.HeatRateDown = 0
		atgm.UseableByAI = false
		atgm.Attack = function( ent )
			if IsValid(self:GetNWEntity("Missile")) then return end
			local ammo = ent:GetAmmo()
			if not IsValid( self.SNDMsl ) then return end
			self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			local fS = {
				Vector(-54.2,-142,60.15),
				Vector(-54.2,142,60.15),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec])
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)
	
			local ID = self:LookupAttachment( "view" )
			local Attachment = self:GetAttachment( ID )
			local Driver = ent:GetDriver()
			local TargetDir = Attachment.Ang:Forward()
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = (Attachment.Pos + TargetDir  * 999999),
				filter = ent
			} )
	
			local mis = ents.Create("sw_rocket_9m123_v3")
			mis:SetPos(Pos)
			mis:SetAngles(self:GetAngles()+Angle(0,0,90))
			mis:Spawn()
			mis:Activate()
			mis:SetTracerScale(10)
			mis:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
			mis:GetPhysicsObject():AddVelocity(mis:GetForward()*1000)
	
			constraint.NoCollide(self,mis,0,0)
			constraint.NoCollide(mis,self,0,0)
			constraint.NoCollide(self:GetNWEntity("WheelC"),mis,0,0)
			constraint.NoCollide(mis,self:GetNWEntity("WheelC"),0,0)
			constraint.NoCollide(self:GetNWEntity("WheelR"),mis,0,0)
			constraint.NoCollide(mis,self:GetNWEntity("WheelR"),0,0)
			constraint.NoCollide(self:GetNWEntity("WheelL"),mis,0,0)
			constraint.NoCollide(mis,self:GetNWEntity("WheelL"),0,0)
	
			timer.Simple(0.25,function()
				if IsValid(mis) then
					mis:Launch()
					mis.Armed = true
					mis.Launcher = self
					mis.GuidanceActive = true
					mis.LaserGuided = true
					mis.LaserCode = "view"
					mis.target = tr.Entity
					mis.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
					self:SetNWEntity("Missile",mis)
				end
			end)
			ent:TakeAmmo( 1 )
		end
		atgm.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
			local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -105, 105 )
			local CPitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_pitch"), -Angles.p, 120*FrameTime() ), -65, 20 )
			local CYaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_yaw"), Angles.y, 120*FrameTime() ), -105, 105 )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
			base:SetPoseParameter("cam_yaw", CYaw )
			base:SetPoseParameter("cam_pitch", CPitch )
		end
		atgm.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "view" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/avia/mi35/camera" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW()*1.1, ScrH(), 0 )
	
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."м"
					end
					surface.SetTextColor( 2, 92, 35, 255 )
					surface.SetTextPos( (ScrW()*0.45), (ScrH()/4.025) )
					surface.SetFont("SUPERHIND_SPD")
					surface.DrawText( "дист: "..range )
	
					local kmh = math.Round(self:GetVelocity():Length() * 0.09144,0)
					surface.SetTextColor( 2, 92, 35, 255 )
					surface.SetTextPos( (ScrW()*0.3425), (ScrH()/4.025) )
					surface.SetFont("SUPERHIND_SPD")
					surface.DrawText( kmh )
	
					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							if self:GetFLIR() then	
								hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
								hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
						
								DoXRay = true
							else
								hook.Remove( "RenderScene", "XRay_ApplyMats" )
								hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
								DoXRay = false
								for ent,mat in pairs( DefMats ) do
									if ent:IsValid() then
										ent:SetMaterial( mat )
									end
								end				
								for ent,clr in pairs( DefClrs ) do
									if ent:IsValid() then
										ent:SetRenderMode(RENDERMODE_TRANSALPHA)
										ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
									end
								end
								DefMats = {}
								DefClrs = {}
							end
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end			
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefMats = {}
							DefClrs = {}
						end
					end
				else
					local Crosshair = tr.HitPos:ToScreen() 
					base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
					base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
					base:LVSPaintHitMarker( Crosshair )			
	
					hook.Remove( "RenderScene", "XRay_ApplyMats" )
					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoXRay = false
					for ent,mat in pairs( DefMats ) do
						if ent:IsValid() then
							ent:SetMaterial( mat )
						end
					end			
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end			
					DefMats = {}
					DefClrs = {}
				end
			else
				local Crosshair = tr.HitPos:ToScreen() 
				base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
				base:LVSPaintHitMarker( Crosshair )
				
				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
		end
		atgm.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoom
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
			end
		end
		self:AddWeapon( atgm, 2 )
	end
end
function ENT:OnRemoved()
	hook.Remove( "RenderScene", "XRay_ApplyMats" )
	hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
	DoXRay = false
	for ent,mat in pairs( DefMats ) do
		if ent:IsValid() then
			ent:SetMaterial( mat )
		end
	end			
	for ent,clr in pairs( DefClrs ) do
		if ent:IsValid() then
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
		end
	end			
	DefMats = {}
	DefClrs = {}
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