ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "AH-1W"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Воздух"
ENT.Subcategory = "[НАТО]"


ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.HudColor = Color(0,255,0,150)
ENT.HudThirdPerson = true

ENT.MDL = "models/sw/avia/ah1w/ah1w.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1000
ENT.MaxHealthFuelTank = 150

ENT.MaxVelocity = 1500

ENT.ThrustUp = 1
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.05
ENT.ThrottleRateDown = 0.05

ENT.TurnRatePitch = 0.95
ENT.TurnRateYaw = 0.95
ENT.TurnRateRoll = 0.95

ENT.ForceLinearDampingMultiplier = 1.5

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.EngineSounds = {
	{
		sound = "sw/ah1/engine.wav",
		sound_int = "sw/ah1/int_engine.wav",
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
		sound = "",
		sound_int = "sw/ah1/rotor_loop_int.wav",
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
	DrawSobel( 0.25 )
	DrawMotionBlur(FrameTime() * 30, 0.5, 0.05)
	DrawBokehDOF( 0.75, 1, 5 )
end

--Pylons
ENT.Pylons = {
	Vector(6.5,54,43),
	Vector(6.5,-54,43),
	Vector(7.75,30.25,36.25),
	Vector(7.75,-30.25,36.25),
}
ENT.Loadouts = 10

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
	flares.Ammo = 64
	flares.Delay = 0.25
	flares.HeatRateUp = 1.5
	flares.HeatRateDown = 0.75
	flares.UseableByAI = false
	flares.Attack = function( ent )
		self:EmitSound("sw/misc/flr_"..math.random(1,3)..".wav")
		local projectile = ents.Create("sw_flare_v3")
		projectile:SetPos(self:LocalToWorld(Vector(14,57,50)))
		projectile:SetAngles(self:GetAngles())
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter(projectile:GetRight()*-1000)

		local projectile = ents.Create("sw_flare_v3")
		projectile:SetPos(self:LocalToWorld(Vector(14,-57,50)))
		projectile:SetAngles(self:GetAngles())
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter(projectile:GetRight()*1000)
		ent:TakeAmmo( 2 )	
	end
	self:AddWeapon( flares )

	if loadout == 1 then
		local ffar = {}
		ffar.Icon = Material("lvs/weapons/missile.png")
		ffar.Ammo = 76
		ffar.Delay = 0.1
		ffar.HeatRateUp = 0
		ffar.HeatRateDown = 0
		ffar.Attack = function( ent )
			local fS = {
				Vector(41.5,-54,43),
				Vector(42.75,-30.25,36.25),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local fS2 = {
				Vector(41.5,54,43),
				Vector(42.75,30.25,36.25),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS2[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)

			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		ffar.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Angle = self:GetAngles()+Angle(-5,0,0)
				local Vel = Angle:Forward()*4000
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
		local ffar = {}
		ffar.Icon = Material("lvs/weapons/missile.png")
		ffar.Ammo = 38
		ffar.Delay = 0.1
		ffar.HeatRateUp = 0
		ffar.HeatRateDown = 0
		ffar.Attack = function( ent )
			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,-30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,-30.25,36.25)),self:GetAngles(),self)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,30.25,36.25)),self:GetAngles(),self)
			
			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		ffar.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Angle = self:GetAngles()+Angle(-5,0,0)
				local Vel = Angle:Forward()*4000
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
				if istable( self.Missiles ) then
					local oldmis = self.Missiles[ammo]
					table.remove(self.Missiles,ammo + 1)
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
				endpos = startpos + self:GetForward() * 500000,
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
	elseif loadout == 3 then
		local ffar = {}
		ffar.Icon = Material("lvs/weapons/missile.png")
		ffar.Ammo = 38
		ffar.Delay = 0.1
		ffar.HeatRateUp = 0
		ffar.HeatRateDown = 0
		ffar.Attack = function( ent )
			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,-30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,-30.25,36.25)),self:GetAngles(),self)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,30.25,36.25)),self:GetAngles(),self)
			
			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		ffar.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Angle = self:GetAngles()+Angle(-5,0,0)
				local Vel = Angle:Forward()*4000
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
		
		local gpu2a = {}
		gpu2a.Icon = Material("lvs/weapons/hmg.png")
		gpu2a.Ammo = 600
		gpu2a.Delay = 0.04
		gpu2a.HeatRateUp = 0.35
		gpu2a.HeatRateDown = 0.35
		gpu2a.Attack = function( ent )
			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(70.8,-54,40.9))
			bullet.Dir 	= self:LocalToWorldAngles(Angle(-5,0,0)):Forward()
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
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(70.8,-54,40.9)),self:GetAngles(),nil)

			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(70.8,54,40.9))
			bullet.Dir 	= self:LocalToWorldAngles(Angle(-5,0,0)):Forward()
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
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(70.8,54,40.9)),self:GetAngles(),nil)
	
			ent:TakeAmmo( 2 )
		end
		gpu2a.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDPodR ) then return end
			base.SNDPodR:Play()
			if not IsValid( base ) or not IsValid( base.SNDPodL ) then return end
			base.SNDPodL:Play()
		end
		gpu2a.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDPodR ) then return end
			base.SNDPodR:Stop()
			if not IsValid( base ) or not IsValid( base.SNDPodL ) then return end
			base.SNDPodL:Stop()
		end
		self:AddWeapon( gpu2a )
	elseif loadout == 4 or loadout == 5 then
		local ffar = {}
		ffar.Icon = Material("lvs/weapons/missile.png")
		ffar.Ammo = 38
		ffar.Delay = 0.1
		ffar.HeatRateUp = 0
		ffar.HeatRateDown = 0
		ffar.Attack = function( ent )
			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,-30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,-30.25,36.25)),self:GetAngles(),self)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,-30.25,36.25)),self:GetAngles(),self)
			
			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		ffar.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Pos = self:GetPos()+self:GetUp()*50
				local Angle = self:GetAngles()+Angle(-5,0,0)
				local Vel = Angle:Forward()*4000
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
	elseif loadout == 6 then
		local zuni = {}
		zuni.Icon = Material("lvs/weapons/missile.png")
		zuni.Ammo = 16
		zuni.Delay = 0.35
		zuni.HeatRateUp = 0
		zuni.HeatRateDown = 0
		zuni.Attack = function( ent )
			local fS = {
				Vector(41.5,-54,43),
				Vector(42.75,-30.25,36.25),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local fS2 = {
				Vector(16.5,54,33),
				Vector(42.75,30.25,36.25),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS2[self.NumSec]),self:GetAngles(),self)
	
			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)

			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		zuni.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Ang = self:GetAngles()+Angle(-5,0,0)
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = Ang:Forward()*4000
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
	elseif loadout == 7 then
		local zuni = {}
		zuni.Icon = Material("lvs/weapons/missile.png")
		zuni.Ammo = 8
		zuni.Delay = 0.35
		zuni.HeatRateUp = 0
		zuni.HeatRateDown = 0
		zuni.Attack = function( ent )
			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,-30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,-30.25,36.25)),self:GetAngles(),self)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,30.25,36.25)),self:GetAngles(),self)
			
			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		zuni.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Ang = self:GetAngles()+Angle(-5,0,0)
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = Ang:Forward()*4000
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
				if istable( self.Missiles ) then
					local oldmis = self.Missiles[ammo]
					table.remove(self.Missiles,ammo + 1)
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
				endpos = startpos + self:GetForward() * 500000,
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
	elseif loadout == 8 then
		local zuni = {}
		zuni.Icon = Material("lvs/weapons/missile.png")
		zuni.Ammo = 8
		zuni.Delay = 0.35
		zuni.HeatRateUp = 0
		zuni.HeatRateDown = 0
		zuni.Attack = function( ent )
			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,-30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,-30.25,36.25)),self:GetAngles(),self)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,30.25,36.25)),self:GetAngles(),self)
			
			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		zuni.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Ang = self:GetAngles()+Angle(-5,0,0)
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = Ang:Forward()*4000
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
		
		local gpu2a = {}
		gpu2a.Icon = Material("lvs/weapons/hmg.png")
		gpu2a.Ammo = 600
		gpu2a.Delay = 0.04
		gpu2a.HeatRateUp = 0.35
		gpu2a.HeatRateDown = 0.35
		gpu2a.Attack = function( ent )
			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(70.8,-54,40.9))
			bullet.Dir 	= self:LocalToWorldAngles(Angle(-5,0,0)):Forward()
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
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(70.8,-54,40.9)),self:GetAngles(),nil)

			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(70.8,54,40.9))
			bullet.Dir 	= self:LocalToWorldAngles(Angle(-5,0,0)):Forward()
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
	
			ParticleEffect("muzzleflash_m590_3rd",self:LocalToWorld(Vector(70.8,54,40.9)),self:GetAngles(),nil)
	
			ent:TakeAmmo( 2 )
		end
		gpu2a.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDPodR ) then return end
			base.SNDPodR:Play()
			if not IsValid( base ) or not IsValid( base.SNDPodL ) then return end
			base.SNDPodL:Play()
		end
		gpu2a.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDPodR ) then return end
			base.SNDPodR:Stop()
			if not IsValid( base ) or not IsValid( base.SNDPodL ) then return end
			base.SNDPodL:Stop()
		end
		self:AddWeapon( gpu2a )
	elseif loadout == 9 or loadout == 10 then
		local zuni = {}
		zuni.Icon = Material("lvs/weapons/missile.png")
		zuni.Ammo = 8
		zuni.Delay = 0.35
		zuni.HeatRateUp = 0
		zuni.HeatRateDown = 0
		zuni.Attack = function( ent )
			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,-30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,-30.25,36.25)),self:GetAngles(),self)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local projectile = ents.Create("sw_rocket_zuni_v3")
			projectile:SetPos(self:LocalToWorld(Vector(42.75,30.25,36.25)+Vector(0,math.Rand(-7,7),math.Rand(-7,7))))
			projectile:SetAngles(self:GetAngles()+Angle(-5,0,0))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(Vector(42.75,30.25,36.25)),self:GetAngles(),self)
			
			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		zuni.HudPaint = function( ent, X, Y, ply )
			if self:GetEngineActive() then
				local color_red = Color(0,255,0,255)
				local HudTargets = {}
				local Grav = physenv.GetGravity()
				local FT = RealFrameTime()
				local Ang = self:GetAngles()+Angle(-5,0,0)
				local Pos = self:GetPos()+self:GetUp()*50
				local Vel = Ang:Forward()*4000
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
	end

	local flir = {}
	flir.Icon = Material("icons/flir.png")
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

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 15 )
		local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
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
		local Crosshair = tr.HitPos:ToScreen() 

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				trtab = {}
				trtab.start = Attachment.Pos
				trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-"
				else
					range = range.."m"
				end
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
				surface.SetFont("sw_digital")
				surface.DrawText( "Range: "..range )

				surface.SetTextColor( 255, 255, 255,255 )
				surface.SetTextPos( (X*0.165), (Y/2) )
				surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
				surface.SetTextPos( (X*0.165), (Y/2) + 16)
				surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
				surface.SetTextPos( (X*0.165), (Y/2) + 32)
				surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))

				local startpos =  Attachment.Pos
				local TracePlane = util.TraceLine( {
					start = startpos,
					endpos = (startpos + Attachment.Ang:Forward() * 90000),
				} )
				local HitPlane = TracePlane.HitPos:ToScreen()
				
				local ang = Attachment.Ang.y
				local ComAngSN = 0.55 * math.sin(math.rad(ang))
				local ComAngCN = 1 * math.cos(math.rad(ang))
				local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
				local ComAngCE = 1 * math.cos(math.rad(ang-270))
				local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
				local ComAngCW = 1 * math.cos(math.rad(ang-90))
				local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
				local ComAngCS = 1 * math.cos(math.rad(ang-180))

				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
				surface.DrawText( "N" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
				surface.DrawText( "E" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
				surface.DrawText( "W" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
				surface.DrawText( "S" )  

				local zoom_mat = Material( "models/sw/shared/sights/camera" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )
					
				base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
				base:LVSPaintHitMarker( Crosshair )

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
				local tr = util.TraceLine( {
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
					filter = ent:GetVehicle():GetCrosshairFilterEnts()
				} )
				local HitPilot = tr.HitPos:ToScreen()
				local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
				if not ent:GetDriverSeat():GetThirdPersonMode() then
					self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
					base:PaintCrosshairCenter( HitPilot, self.HudColor )
				else
					self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
					base:PaintCrosshairCenter( HitPlane, self.HudColor )
				end
				base:PaintCrosshairSquare( Crosshair, self.HudColor )
				base:PaintCrosshairCenter( Crosshair, self.HudColor )
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
			local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
				filter = ent:GetVehicle():GetCrosshairFilterEnts()
			} )
			local HitPilot = tr.HitPos:ToScreen()
			local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
				base:PaintCrosshairCenter( HitPilot, self.HudColor )
			else
				self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
				base:PaintCrosshairCenter( HitPlane, self.HudColor )
			end
			base:PaintCrosshairSquare( Crosshair, self.HudColor )
			base:PaintCrosshairCenter( Crosshair, self.HudColor )
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

	local m197 = {}
	m197.Icon = Material("lvs/weapons/hmg.png")
	m197.Ammo = 750
	m197.Delay = 0.04
	m197.HeatRateUp = 0.35
	m197.HeatRateDown = 0.35
	m197.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.018,0.018,0.018)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 5100
		bullet.HullSize 	= 23
		bullet.EnableBallistics = true
		bullet.Damage	= 85
		bullet.SplashDamage = 25
		bullet.SplashDamageRadius = 70
		bullet.Velocity = 20600
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )
		
		ParticleEffect("muzzleflash_m590_3rd",Attachment.Pos,Attachment.Ang,nil)
		util.ScreenShake( Attachment.Pos, 0.5, 3, 0.5, 150, true, nil )

		self:ResetSequence("fire")

		ent:TakeAmmo( 1 )
	end
	m197.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Play()
	end
	m197.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Stop()
	end
	m197.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 15 )
		local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	m197.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
		local Attachment = base:GetAttachment( ID )
		local ID2 = base:LookupAttachment( "view" )
		local Attachment2 = base:GetAttachment( ID2 )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local tr2 = util.TraceLine( {
			start = Attachment2.Pos,
			endpos = Attachment2.Pos + Attachment2.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local Crosshair = tr.HitPos:ToScreen() 
		local Crosshair2 = tr2.HitPos:ToScreen() 

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				trtab = {}
				trtab.start = Attachment2.Pos
				trtab.endpos = (Attachment2.Pos + Attachment2.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-"
				else
					range = range.."m"
				end
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
				surface.SetFont("sw_digital")
				surface.DrawText( "Range: "..range )

				surface.SetTextColor( 255, 255, 255,255 )
				surface.SetTextPos( (X*0.165), (Y/2) )
				surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
				surface.SetTextPos( (X*0.165), (Y/2) + 16)
				surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
				surface.SetTextPos( (X*0.165), (Y/2) + 32)
				surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))

				local startpos =  Attachment2.Pos
				local TracePlane = util.TraceLine( {
					start = startpos,
					endpos = (startpos + Attachment2.Ang:Forward() * 90000),
				} )
				local HitPlane = TracePlane.HitPos:ToScreen()
				
				local ang = Attachment2.Ang.y
				local ComAngSN = 0.55 * math.sin(math.rad(ang))
				local ComAngCN = 1 * math.cos(math.rad(ang))
				local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
				local ComAngCE = 1 * math.cos(math.rad(ang-270))
				local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
				local ComAngCW = 1 * math.cos(math.rad(ang-90))
				local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
				local ComAngCS = 1 * math.cos(math.rad(ang-180))

				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
				surface.DrawText( "N" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
				surface.DrawText( "E" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
				surface.DrawText( "W" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
				surface.DrawText( "S" )  
				
				local zoom_mat = Material( "models/sw/shared/sights/camera" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )
				base:PaintCrosshairSquare( Crosshair2, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair2, Color(255,255,255,255) )

				base:PaintCrosshairOuter( Crosshair, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
				base:LVSPaintHitMarker( Crosshair )

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
				local tr = util.TraceLine( {
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
					filter = ent:GetVehicle():GetCrosshairFilterEnts()
				} )
				local HitPilot = tr.HitPos:ToScreen()
				local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
				if not ent:GetDriverSeat():GetThirdPersonMode() then
					self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
					base:PaintCrosshairCenter( HitPilot, self.HudColor )
				else
					self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
					base:PaintCrosshairCenter( HitPlane, self.HudColor )
				end
				base:PaintCrosshairOuter( Crosshair, self.HudColor )
				base:PaintCrosshairCenter( Crosshair, self.HudColor )
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
			local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
				filter = ent:GetVehicle():GetCrosshairFilterEnts()
			} )
			local HitPilot = tr.HitPos:ToScreen()
			local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
				base:PaintCrosshairCenter( HitPilot, self.HudColor )
			else
				self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
				base:PaintCrosshairCenter( HitPlane, self.HudColor )
			end
			base:PaintCrosshairOuter( Crosshair, self.HudColor )
			base:PaintCrosshairCenter( Crosshair, self.HudColor )
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
	m197.CalcView = function( ent, ply, pos, angles, fov, pod )
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
	self:AddWeapon( m197, 2 )

	if loadout == 4 or loadout == 9 then
		local bgm71 = {}
		bgm71.Icon = Material("icons/bgm71")
		bgm71.Ammo = 8
		bgm71.Delay = 1
		bgm71.HeatRateUp = 0.5
		bgm71.HeatRateDown = 0.15
		bgm71.Attack = function( ent )
			if IsValid(self:GetNWEntity("Missile")) then return end
	
			local fS = {
				Vector(16.5,54,33),
				Vector(16.5,-54,33),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec])
			ParticleEffect("ins_weapon_rpg_frontblast",Pos,self:GetAngles(),self)

			local ID = self:LookupAttachment( "view" )
			local Sight = self:GetAttachment( ID )
			local Driver = ent:GetDriver()
			local TargetDir = Sight.Ang:Forward()
			local tr = util.TraceLine( {
				start = Sight.Pos,
				endpos = (Sight.Pos + TargetDir  * 999999),
				filter = ent:GetVehicle():GetCrosshairFilterEnts()
			} )
			local projectile = ents.Create("sw_rocket_bgm71_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles())
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.WireGuided = true
			projectile.Armed = true
			projectile.Launcher = self
			projectile.GuidanceActive = true
			projectile.LaserGuided = true
			projectile.LaserCode = "view"
			projectile.RocketTrail = "rockettrail"
			projectile.target = tr.Entity
			projectile.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
			projectile:SetTracerScale(5)
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			
			if not IsValid( self.SNDMsl ) then return end
			self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
			
			self:SetNWEntity("Missile",projectile)
	
			ParticleEffect("ins_weapon_rpg_frontblast",Pos,self:GetAngles(),self)
	
			ent:TakeAmmo( 1 )	
		end
		bgm71.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 15 )
			local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		bgm71.HudPaint = function( ent, X, Y, ply )
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
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."m"
					end
					surface.SetTextColor( 255, 255, 255, 255 )
					surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
					surface.SetFont("sw_digital")
					surface.DrawText( "Range: "..range )
	
					surface.SetTextColor( 255, 255, 255,255 )
					surface.SetTextPos( (X*0.165), (Y/2) )
					surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
					surface.SetTextPos( (X*0.165), (Y/2) + 16)
					surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
					surface.SetTextPos( (X*0.165), (Y/2) + 32)
					surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))
	
					local startpos =  Attachment.Pos
					local TracePlane = util.TraceLine( {
						start = startpos,
						endpos = (startpos + Attachment.Ang:Forward() * 90000),
					} )
					local HitPlane = TracePlane.HitPos:ToScreen()
					
					local ang = Attachment.Ang.y
					local ComAngSN = 0.55 * math.sin(math.rad(ang))
					local ComAngCN = 1 * math.cos(math.rad(ang))
					local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
					local ComAngCE = 1 * math.cos(math.rad(ang-270))
					local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
					local ComAngCW = 1 * math.cos(math.rad(ang-90))
					local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
					local ComAngCS = 1 * math.cos(math.rad(ang-180))
	
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
					surface.DrawText( "N" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
					surface.DrawText( "E" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
					surface.DrawText( "W" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
					surface.DrawText( "S" )  
	
					local zoom_mat = Material( "models/sw/shared/sights/camera" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )
						
					base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
					base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
					base:LVSPaintHitMarker( Crosshair )
	
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
					local tr = util.TraceLine( {
						start = ply:EyePos(),
						endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
						filter = ent:GetVehicle():GetCrosshairFilterEnts()
					} )
					local HitPilot = tr.HitPos:ToScreen()
					local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
					if not ent:GetDriverSeat():GetThirdPersonMode() then
						self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
						base:PaintCrosshairCenter( HitPilot, self.HudColor )
					else
						self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
						base:PaintCrosshairCenter( HitPlane, self.HudColor )
					end
					base:PaintCrosshairSquare( Crosshair, self.HudColor )
					base:PaintCrosshairCenter( Crosshair, self.HudColor )
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
				local tr = util.TraceLine( {
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
					filter = ent:GetVehicle():GetCrosshairFilterEnts()
				} )
				local HitPilot = tr.HitPos:ToScreen()
				local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
				if not ent:GetDriverSeat():GetThirdPersonMode() then
					self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
					base:PaintCrosshairCenter( HitPilot, self.HudColor )
				else
					self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
					base:PaintCrosshairCenter( HitPlane, self.HudColor )
				end
				base:PaintCrosshairSquare( Crosshair, self.HudColor )
				base:PaintCrosshairCenter( Crosshair, self.HudColor )
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
		bgm71.CalcView = function( ent, ply, pos, angles, fov, pod )
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
		self:AddWeapon( bgm71, 2 )
	elseif loadout == 5 or loadout == 10 then
		local agm114 = {}
		agm114.Icon = Material("lvs/weapons/missile.png")
		agm114.Ammo = 8
		agm114.Delay = 0.25
		agm114.HeatRateUp = 0
		agm114.HeatRateDown = 0
		agm114.Attack = function( ent )
			if ent:GetAI() or IsValid(self:GetNWEntity("Missile")) then return end
			local ammo = ent:GetAmmo()
			ent:TakeAmmo( 1 )
			if istable( self.Missiles ) then
	
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local Driver = ent:GetDriver()
				local TargetDir = Attachment.Ang:Forward()
				local tr = util.TraceLine( {
					start = Attachment.Pos,
					endpos = (Attachment.Pos + TargetDir  * 999999),
					filter = ent:GetVehicle():GetCrosshairFilterEnts()
				} )
	
				local oldmis = self.Missiles[ammo]
				table.remove(self.Missiles,ammo + 1)
				if !IsValid(oldmis) then return end
				local mis = ents.Create("sw_rocket_agm114_v3")
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
				mis.RocketTrail = "rockettrail"
				mis.target = tr.Entity
				mis.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
				self:SetNWEntity("Missile",mis)
				constraint.NoCollide(self,mis,0,0)
				constraint.NoCollide(mis,self,0,0)

				
				if not IsValid( self.SNDMsl ) then return end
				self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
				
				oldmis:Remove()
			end
		end
		agm114.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 15 )
			local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		agm114.HudPaint = function( ent, X, Y, ply )
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
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."m"
					end
					surface.SetTextColor( 255, 255, 255, 255 )
					surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
					surface.SetFont("sw_digital")
					surface.DrawText( "Range: "..range )
	
					surface.SetTextColor( 255, 255, 255,255 )
					surface.SetTextPos( (X*0.165), (Y/2) )
					surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
					surface.SetTextPos( (X*0.165), (Y/2) + 16)
					surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
					surface.SetTextPos( (X*0.165), (Y/2) + 32)
					surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))
	
					local startpos =  Attachment.Pos
					local TracePlane = util.TraceLine( {
						start = startpos,
						endpos = (startpos + Attachment.Ang:Forward() * 90000),
					} )
					local HitPlane = TracePlane.HitPos:ToScreen()
					
					local ang = Attachment.Ang.y
					local ComAngSN = 0.55 * math.sin(math.rad(ang))
					local ComAngCN = 1 * math.cos(math.rad(ang))
					local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
					local ComAngCE = 1 * math.cos(math.rad(ang-270))
					local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
					local ComAngCW = 1 * math.cos(math.rad(ang-90))
					local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
					local ComAngCS = 1 * math.cos(math.rad(ang-180))
	
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
					surface.DrawText( "N" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
					surface.DrawText( "E" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
					surface.DrawText( "W" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
					surface.DrawText( "S" )  
	
					local zoom_mat = Material( "models/sw/shared/sights/camera" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )
						
					base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
					base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
					base:LVSPaintHitMarker( Crosshair )
	
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
					local tr = util.TraceLine( {
						start = ply:EyePos(),
						endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
						filter = ent:GetVehicle():GetCrosshairFilterEnts()
					} )
					local HitPilot = tr.HitPos:ToScreen()
					local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
					if not ent:GetDriverSeat():GetThirdPersonMode() then
						self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
						base:PaintCrosshairCenter( HitPilot, self.HudColor )
					else
						self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
						base:PaintCrosshairCenter( HitPlane, self.HudColor )
					end
					base:PaintCrosshairSquare( Crosshair, self.HudColor )
					base:PaintCrosshairCenter( Crosshair, self.HudColor )
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
				local tr = util.TraceLine( {
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
					filter = ent:GetVehicle():GetCrosshairFilterEnts()
				} )
				local HitPilot = tr.HitPos:ToScreen()
				local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
				if not ent:GetDriverSeat():GetThirdPersonMode() then
					self:PaintHeliFlightInfo( X, Y, ply, HitPilot )
					base:PaintCrosshairCenter( HitPilot, self.HudColor )
				else
					self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
					base:PaintCrosshairCenter( HitPlane, self.HudColor )
				end
				base:PaintCrosshairSquare( Crosshair, self.HudColor )
				base:PaintCrosshairCenter( Crosshair, self.HudColor )
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
		agm114.CalcView = function( ent, ply, pos, angles, fov, pod )
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
		self:AddWeapon( agm114, 2 )
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