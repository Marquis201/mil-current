
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "T-90M"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Танки"

ENT.VehicleCategory = "Танки"
ENT.VehicleSubCategory = "Средние"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/t90m/t90m_nakidka.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 5000

ENT.DSArmorIgnoreForce = 4000
ENT.CannonArmorPenetration = 580 * 100 - 4000

ENT.ProjectileVelocityCoaxial = 30000
ENT.ProjectileVelocityHighExplosive = 13000
ENT.ProjectileVelocityArmorPiercing = 16000
ENT.ProjectileVelocityHEAT = 13000
ENT.ProjectileVelocityATGM = 500000

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 170

ENT.EngineCurve = 0
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 7
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 35

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "sw/t90m/engine_idle.wav",
		sound_int = "sw/t90m/engine_idle_int.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "sw/t90m/engine.wav",
		sound_int = "sw/t90m/engine_int.wav",
		Volume = 1,
		Pitch = 30,
		PitchMul = 100,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{pos = Vector(-80.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-80.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-80.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-84.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-84.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-84.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-88.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-88.2,82,57.7),ang = Angle(20,90,0),},
	{pos = Vector(-88.2,82,57.7),ang = Angle(20,90,0),},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(134.2,36,53.25), colorA = 150 },
			{ pos = Vector(134.2,-36,53.25), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(134.2,36,53.25), colorA = 150 },
			{ pos = Vector(134.2,-36,53.25), colorA = 150 },	
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(134.2,36,53.25), colorA = 150 },
			{ pos = Vector(134.2,-36,53.25), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(134.2,36,53.25), colorA = 150 },
			{ pos = Vector(134.2,-36,53.25), colorA = 150 },	
		},
	},
	{
		Trigger = "brake",
		Sprites = {
			{ pos = Vector(-168.2,43.17,59.3), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-153.4,-57.17,57.83), colorG = 0, colorB = 0, colorA = 150 },
		}
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
	DrawMotionBlur(FrameTime() * 50, 0.5, 0.05)
	DrawBokehDOF( 0.15, 1, 12 )
end
function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "CommanderSeat" )
	self:AddDT( "Int", "ShellType" )
	self:AddDT( "Bool", "FLIR" )
	self:AddDT( "Bool", "COMFLIR" )
	self:AddDT( "Bool", "Hatch" )
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
function ENT:GunnerInRange( Dir )
	return self:AngleBetweenNormal( self:GetForward(), Dir ) < 30
end
function ENT:InitWeapons()
	local smokegen = {}
	smokegen.Icon = Material("icons/smoke_generator")
	smokegen.UseableByAI = false
	smokegen.Ammo = 3
	smokegen.Delay = 1
	smokegen.HeatRateUp = 1
	smokegen.HeatRateDown = 0.05
	smokegen.Attack = function( ent )
		ent:TakeAmmo( 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( ent:LocalToWorld( Vector(-150,29,60) ) )
		grenade:SetAngles( ent:GetAngles() )
		grenade:SetParent( ent )
		grenade:Spawn()
		grenade:Activate()
		grenade:Enable()
		grenade:SetColor( Color(0,0,0,0) )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( ent:LocalToWorld( Vector(-150,-7.5,60) ) )
		grenade:SetAngles( ent:GetAngles() )
		grenade:SetParent( ent )
		grenade:Spawn()
		grenade:Activate()
		grenade:Enable()
		grenade:SetColor( Color(0,0,0,0) )
	end
	self:AddWeapon( smokegen )

	local flir = {}
	flir.Icon = Material("lvs/weapons/light.png")
	flir.Ammo = -1
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
	flir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 
			
			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	flir.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle_coax" )
	end
	self:AddWeapon( flir, 2 )

	local pkt = {}
	pkt.Icon = Material("icons/pkt")
	pkt.Ammo = 2000
	pkt.Clip = 250
	pkt.Delay = 0.08
	pkt.ReloadSpeed = 5
	pkt.OnReload = function( ent )
		local base = ent:GetVehicle()
		base.SNDMGRldInt:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	pkt.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle_coax" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 10
		bullet.HullSize = 0
		bullet.EnableBallistics = true
		bullet.Damage	= 35
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)

		ent:TakeAmmo( 1 )
	end
	pkt.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 
			
			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	pkt.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Play()
	end
	pkt.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Stop()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGstop ) then return end
		base.SNDTurretMGstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	pkt.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle_coax" )
	end
	self:AddWeapon( pkt, 2 )

	local cannon = {}
	cannon.Icon = true
	cannon.Ammo = 40
	cannon.Delay = 7
	cannon.HeatRateUp = 1
	cannon.HeatRateDown = 0.2
	cannon.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		if self:GetShellType() == 0 then
			local bullet = {}
			bullet.Src 	= Muzzle.Pos
			bullet.Dir 	= Muzzle.Ang:Forward()
			bullet.Spread = Vector(0,0,0)
			bullet.Force	= self.CannonArmorPenetration
			bullet.HullSize = 0
			bullet.EnableBallistics = true
			bullet.Damage	= 2250
			bullet.Velocity = 16000
			bullet.TracerName = "lvs_tracer_cannon_improved"
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
		elseif self:GetShellType() == 1 then
			local bullet = {}
			bullet.Src 	= Muzzle.Pos
			bullet.Dir 	= Muzzle.Ang:Forward()
			bullet.Spread = Vector(0,0,0)
			bullet.Force	= 51000
			bullet.HullSize 	= 0
			bullet.EnableBallistics = true
			bullet.Damage	= 2500
			bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
			bullet.Velocity = 13000
			bullet.TracerName = "lvs_tracer_cannon_improved"
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
		elseif self:GetShellType() == 2 then
			local bullet = {}
			bullet.Src 	= Muzzle.Pos
			bullet.Dir 	= Muzzle.Ang:Forward()
			bullet.Spread = Vector(0,0,0)
			bullet.Force	= 200
			bullet.HullSize 	= 0
			bullet.EnableBallistics = true
			bullet.Damage	= 2500
			bullet.SplashDamage = 750
			bullet.SplashDamageRadius = 120
			bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
			bullet.SplashDamageType = DMG_BLAST
			bullet.Velocity = 13000		
			bullet.TracerName = "lvs_tracer_cannon_improved"
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
		elseif self:GetShellType() == 3 then
			local ID = self:LookupAttachment( "view" )
			local Attachment = self:GetAttachment( ID )
			local Driver = ent:GetDriver()
			local TargetDir = Attachment.Ang:Forward()
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = (Attachment.Pos + TargetDir  * 999999),
				filter = ent
			} )
			local projectile = ents.Create("sw_rocket_9m119_v3")
			projectile:SetPos(Muzzle.Pos)
			projectile:SetAngles(Muzzle.Ang)
			projectile:Spawn()
			projectile:Activate()
			self:SetNWEntity("Missile",projectile)
			projectile:GetPhysicsObject():SetVelocity(projectile:GetForward()*5000)
			timer.Simple(0.25,function() 
				if IsValid(self) and IsValid(projectile) then
					projectile:Launch()
					projectile.Armed = true
					projectile.Launcher = self
					projectile.GuidanceActive = true
					projectile.LaserGuided = true
					projectile.LaserCode = "view"
					projectile.target = tr.Entity
					projectile.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
					projectile:SetTracerScale(5)
				end
			end)
		end

		ParticleEffect("gred_arti_muzzle_blast_alt",Muzzle.Pos,Muzzle.Ang,nil)
		util.ScreenShake( Muzzle.Pos, 1, 10, 1, 350, true, nil )

		local PhysObj = self:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -Muzzle.Ang:Forward() * 150000, Muzzle.Pos )
		end
		
		self:ResetSequence( "fire" )

		ent:TakeAmmo( 1 )
			
		if not IsValid( self.SNDTurret ) then return end
		self.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		if not IsValid( self.SNDTurretRld ) then return end
		self.SNDTurretRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		timer.Simple(1.5,function()
			if IsValid(self) then
				self:ResetSequence("ejection")
			end
		end)
		timer.Simple(2, function() 
			if IsValid(self) then
				local ID = self:LookupAttachment( "turret" )
				local Turret = self:GetAttachment( ID )
				
				local Shell = ents.Create( "lvs_item_shell" )
				
				if not IsValid( Shell ) then return end
				Shell.MDL = "models/sw/shared/shell.mdl"
				Shell:SetPos( Turret.Pos + Turret.Ang:Up()*30 - Turret.Ang:Forward()*33 )
				Shell:SetAngles( Turret.Ang )
				Shell:SetModelScale(1)
				Shell:Spawn()
				Shell:Activate()
				Shell:SetOwner( self )
				
				local PhysObj = Shell:GetPhysicsObject()
				
				if not IsValid( PhysObj ) then return end
				
				PhysObj:SetVelocityInstantaneous( Shell:GetUp() * 250 + Shell:GetForward() * -250 )
				PhysObj:SetAngleVelocityInstantaneous( Vector(-840,-240,20) )
			end
		end)
	end
	cannon.OnThink = function( ent )
		local base = ent:GetVehicle()
		local ply = ent:GetDriver()
		if IsValid( ply ) then
			local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )
			if ent._oldSwitchType ~= SwitchType then
				ent._oldSwitchType = SwitchType
	
				if SwitchType then			
					if self:GetShellType() == 0 then
						self:SetShellType( 1 )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )
						if not IsValid( self.SNDTurretRld ) then return end
						self.SNDTurretRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
						base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
					elseif self:GetShellType() == 1 then
						self:SetShellType( 2 )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )
						if not IsValid( self.SNDTurretRld ) then return end
						self.SNDTurretRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
						base:TurretUpdateBallistics( base.ProjectileVelocityHEAT, "muzzle" )
					elseif self:GetShellType() == 2 then
						self:SetShellType( 3 )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )
						if not IsValid( self.SNDTurretRld ) then return end
						self.SNDTurretRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
						base:TurretUpdateBallistics( base.ProjectileVelocityHighExplosive, "muzzle" )
					elseif self:GetShellType() == 3 then
						self:SetShellType( 0 )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )
						if not IsValid( self.SNDTurretRld ) then return end
						self.SNDTurretRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
						base:TurretUpdateBallistics( base.ProjectileVelocityATGM, "muzzle" )
					end
				end
			end
		end
	end
	cannon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			if base:GetShellType() == 0 then
				base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
				base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			elseif base:GetShellType() == 1 then
				base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
			elseif base:GetShellType() == 2 then
				base:PaintCrosshairSquare( MuzzlePos2D, COLOR_WHITE )
			elseif base:GetShellType() == 3 then
				base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			end

			base:LVSPaintHitMarker( MuzzlePos2D )
		end

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	cannon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if base:GetShellType() == 0 then
			base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
		elseif base:GetShellType() == 1 then
			base:TurretUpdateBallistics( base.ProjectileVelocityHEAT, "muzzle" )
		elseif base:GetShellType() == 2 then
			base:TurretUpdateBallistics( base.ProjectileVelocityHighExplosive, "muzzle" )
		elseif base:GetShellType() == 3 then
			base:TurretUpdateBallistics( base.ProjectileVelocityATGM, "muzzle" )
		end
	end
	self:AddWeapon( cannon, 2 )
	
	local smoke = {}
	smoke.Icon = Material("icons/smoke_launcher")
	smoke.Ammo = 12
	smoke.Delay = 0.5
	smoke.UseableByAI = false
	smoke.Attack = function( ent )
		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 2 then
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
		grenade:GetPhysicsObject():AddVelocity( Muzzle.Ang:Up() * 250 ) 

		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(0.75,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)

		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 2 then
			ent._MuzzleID = 1
		end

		local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )

		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		if not IsValid( self.SNDSmoke2 ) then return end
		self.SNDSmoke2:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Pos )
		grenade:SetAngles( Muzzle.Ang )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 
		grenade:GetPhysicsObject():AddVelocity( Muzzle.Ang:Up() * 250 ) 

		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(0.75,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)
	end
	smoke.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 
			
			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	smoke.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle_coax" )
	end
	self:AddWeapon( smoke, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.UseableByAI = false
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 
			
			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( false )
		end
		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle" )
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon, 2 )

	local comflir = {}
	comflir.Icon = Material("lvs/weapons/light.png")
	comflir.Ammo = -1
	comflir.Delay = 0
	comflir.HeatRateUp = 0
	comflir.HeatRateDown = 0
	comflir.UseableByAI = false
	comflir.StartAttack = function( ent )
		if self:GetCOMFLIR() then
			self:SetCOMFLIR(false)
			self:EmitSound("sw/misc/switch_off.mp3")
			self:EmitSound("sw/misc/nv_off.wav")
		else
			self:SetCOMFLIR(true)
			self:EmitSound("sw/misc/switch_on.mp3")
			self:EmitSound("sw/misc/nv_on.wav")			
		end
	end
	comflir.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 80
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local YawC = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 50*FrameTime() )

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("mg_pitch"), -Angles.p, AimRate*FrameTime() ), -10, 45 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("mg_yaw"), Angles.y-YawC, AimRate*FrameTime() )
		
		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("mg_yaw", Yaw )
		base:SetPoseParameter("mg_pitch", Pitch )
	end
	comflir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_mg" )
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
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				local zoom_mat_night = Material( "models/sw/shared/sights/new/sight_sosnau_night" )
				local noise_mat = Material( "models/sw/shared/noise" )
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( noise_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
		
				surface.SetMaterial( zoom_mat_night ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
		
				--weapon status
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/1.55, Y*1.5, X/6.4, Y/10.8)
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/1.55, Y*1.5)
				surface.DrawText("ОЖД")
		
				--weapon type
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/0.83, Y*1.5, X/6.4, Y/10.8)
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/0.83, Y*1.5)
				surface.DrawText("КОРД")
		
				--shell type
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/1.21, Y*1.5, X/6.4, Y/10.8)
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/1.21, Y*1.5)
				surface.DrawText("БР")
		
				--rangefinder
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/0.98, Y*1.5, X/6.4, Y/10.8)
				
				local ID2 = self:LookupAttachment( "view_mg" )
				local Sight = self:GetAttachment( ID2 )
				trtab = {}
				trtab.start = Sight.Pos
				trtab.endpos = (Sight.Pos + Sight.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-----"
				else
					range = range
				end
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/0.98, Y*1.5)
				surface.DrawText(range)

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetCOMFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	comflir.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view_mg" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view_mg" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = ply:EyeAngles()
				view.fov = 90
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	comflir.OnSelect = function( ent )
		self:SetHatch(false)
	end
	self:AddWeapon( comflir, 3 )

	local kord = {}
	kord.Icon = Material("icons/nsvt")
	kord.Ammo = 300
	kord.Delay = 0.1
	kord.HeatRateUp = 0.1
	kord.HeatRateDown = 0.1
	kord.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle_mg" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 3400
		bullet.HullSize = 1
		bullet.EnableBallistics = true
		bullet.Damage	= 60
		bullet.Velocity = 40000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)

		ent:TakeAmmo( 1 )
	end
	kord.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretRWS ) then return end
		base.SNDTurretRWS:Play()
	end
	kord.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretRWS ) then return end
		base:EmitSound("sw/t90m/kord_lastshot.wav")
		base.SNDTurretRWS:Stop()
	end
	kord.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 80
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local YawC = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 50*FrameTime() )

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("mg_pitch"), -Angles.p, AimRate*FrameTime() ), -10, 45 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("mg_yaw"), Angles.y-YawC, AimRate*FrameTime() )
		
		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("mg_yaw", Yaw )
		base:SetPoseParameter("mg_pitch", Pitch )
	end
	kord.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_mg" )
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
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				local zoom_mat_night = Material( "models/sw/shared/sights/new/sight_sosnau_night" )
				local WeaponReady = IsValid(self:GetCommanderSeat():GetDriver()) and self:GetCommanderSeat():GetDriver():lvsGetWeaponHandler():GetNWOverheated() == false
				local noise_mat = Material( "models/sw/shared/noise" )
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( noise_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
		
				surface.SetMaterial( zoom_mat_night ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
		
				--weapon status
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/1.55, Y*1.5, X/6.4, Y/10.8)
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/1.55, Y*1.5)
				if WeaponReady then
					surface.DrawText("ГОТ")
				else
					surface.DrawText("ОЖД")
				end	
		
				--weapon type
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/0.83, Y*1.5, X/6.4, Y/10.8)
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/0.83, Y*1.5)
				surface.DrawText("КОРД")
		
				--shell type
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/1.21, Y*1.5, X/6.4, Y/10.8)
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/1.21, Y*1.5)
				surface.DrawText("БР")
		
				--rangefinder
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(X/0.98, Y*1.5, X/6.4, Y/10.8)
				
				local ID2 = self:LookupAttachment( "view_mg" )
				local Sight = self:GetAttachment( ID2 )
				trtab = {}
				trtab.start = Sight.Pos
				trtab.endpos = (Sight.Pos + Sight.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-----"
				else
					range = range
				end
		
				surface.SetFont("T90M_SIGHT_NIGHT")
				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(X/0.98, Y*1.5)
				surface.DrawText(range)

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetCOMFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	kord.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view_mg" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view_mg" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = ply:EyeAngles()
				view.fov = 90
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	kord.OnSelect = function( ent )
		self:SetHatch(false)
	end
	self:AddWeapon( kord, 3 )

	local weapon = {}
	weapon.Icon = Material("icons/binocular.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_russian" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
			end
		end

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
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

				local ID = self:LookupAttachment( "turret" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos-Attachment.Ang:Forward()*15+Attachment.Ang:Right()*35+Attachment.Ang:Up()*80
				view.angles = ply:EyeAngles()
				view.fov = self.curZoomCom
				return view	
			else
				local ID = self:LookupAttachment( "turret" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos-Attachment.Ang:Forward()*15+Attachment.Ang:Right()*35+Attachment.Ang:Up()*80
				view.angles = ply:EyeAngles()
				view.fov = 90
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	weapon.OnSelect = function( ent )
		self:SetHatch(true)
	end
	self:AddWeapon( weapon, 3 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_mg" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_t90m_kord" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )

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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.7) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetCOMFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view_mg" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view_mg" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = ply:EyeAngles()
				view.fov = 90
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	weapon.OnSelect = function( ent )
		self:SetHatch(false)
	end
	self:AddWeapon( weapon, 3 )
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