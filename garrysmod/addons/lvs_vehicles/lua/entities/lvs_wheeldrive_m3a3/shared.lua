ENT.Base = "lvs_tank_wheeldrive"
ENT.PrintName = "M3A3 Bradley"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - БМП"

ENT.VehicleCategory = "БМП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/m3a3/m3a3.mdl"
ENT.MDL_DESTROYED = "models/diggercars/m3a3/dead.mdl"

ENT.GibModels = {
	"models/diggercars/m3a3/turret.mdl",
}

ENT.AITEAM = 2

ENT.MaxHealth = 1000

--damage system
ENT.DSArmorIgnoreForce = 1500
ENT.CannonArmorPenetration = 8100
ENT.CannonArmorPenetration1km = 5600
ENT.PlateArmor = 2000
ENT.DoublePlateArmor = 4500
ENT.BaseArmor = 500
ENT.TurretArmor = 4500
ENT.TracksArmor = 6500

ENT.ProjectileVelocityArmorPiercing = 30000

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 450
ENT.MaxVelocityReverse = 150

ENT.EngineCurve = 0.1
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/sherman/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/sherman/eng_loop.wav",
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
		pos = Vector(39.55,-54.35,79.87),
		ang = Angle(180,90,0)
	},
	{
		pos = Vector(38.55,-54.35,79.87),
		ang = Angle(180,90,0)
	},
	{
		pos = Vector(40.55,-54.35,79.87),
		ang = Angle(180,90,0)
	},
}

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mc.png")
	weapon.Ammo = 1500
	weapon.Delay = 0.25
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.2
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_autocannon"
		bullet.Force	= ent.CannonArmorPenetration
		bullet.Force1km	= ent.CannonArmorPenetration1km
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 100
		bullet.Velocity = ent.ProjectileVelocityArmorPiercing
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 10000, bullet.Src )
		end

		ent:TakeAmmo( 1 )

		ent:PlayAnimation( "fire" )

		if not IsValid( ent.SNDTurret ) then return end

		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()
	
		if not IsValid( base ) then return end

		local pod = base:GetDriverSeat()

		if not base:GetAI() and (not IsValid( pod ) or not IsValid( pod:GetDriver() )) then return end

		local Ang = base:WorldToLocalAngles( ent:GetAimVector():Angle() ) - Angle(0,base:GetTurretYaw(),0)
		Ang:Normalize()
		
		base:SetPoseParameter("comm_yaw", Ang.y )
		base:SetPoseParameter("comm_pitch", -Ang.p )
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/vehicles/222/cannon_overheat.wav")
	end
	weapon.HudPaint = function( ent, X, Y, ply )
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

			base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not base.GetUseHighExplosive then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
	end
	self:AddWeapon( weapon )


	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 2500
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.1
	weapon.HeatRateDown = 0.20
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_mg" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Force	= 80
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		if not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		if not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Stop()
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
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

			base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not base.GetUseHighExplosive then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
	end
	self:AddWeapon( weapon )



	local weapon = {}
	weapon.Icon = Material("lvs/weapons/missile.png")
	weapon.Ammo = 12
	weapon.Delay = 0.5
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0.07
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or IsValid( base._LastProjectile ) then return end

		local T = CurTime()
		local ReloadTime = 13

		base._swapMissile = not base._swapMissile

		local MuzzleID = base._swapMissile and 1 or 2

		if MuzzleID == 2 then
			ent:SetHeat( 1 )
			ent:SetOverheated( true )
			ent:SetNextAttack( T + ReloadTime )

			timer.Simple(ReloadTime, function()
				if not IsValid( base ) then return end

				base:SetBodygroup(1, 0)
				base:EmitSound("vehicles/tank_readyfire1.wav")
			end)
		end

		base:SetBodygroup(1, MuzzleID)

		local ID = base:LookupAttachment( "muzzzle_m"..MuzzleID )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local Driver = self:GetDriver()

		local projectile = ents.Create( "lvs_missile" )
		projectile:SetPos( Muzzle.Pos )

		projectile:SetAngles( Muzzle.Ang )
		projectile:SetParent( base )
		projectile:Spawn()
		projectile:Activate()
		projectile:SetDamage( 500 )
		projectile:SetRadius( 100 )
		projectile:SetForce( 80000 )
		projectile:SetAttacker( IsValid( Driver ) and Driver or self )
		projectile:SetEntityFilter( base:GetCrosshairFilterEnts() )
		projectile:SetTurnSpeed( 0.5 )
		projectile:Enable()
		projectile:EmitSound( "lvs/vehicles/m3a3/tow.wav", 125 )
		projectile.Master = base

		projectile.GetTarget = function( missile ) return missile end
		projectile.GetTargetPos = function( missile )
			local Master = missile.Master

			if not IsValid( Master ) then
				return missile:LocalToWorld( Vector(100,0,0) )
			end

			return Master._ProjectileTargetPos
		end

		base._LastProjectile = projectile

		ent:TakeAmmo()
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment(  "muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local trace = util.TraceLine( {
			start = Muzzle.Pos,
			endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
			filter = base:GetCrosshairFilterEnts()
		} )

		base._ProjectileTargetPos = trace.HitPos
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment(  "muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()

		if not IsValid( base.Rockets ) or not IsValid( base ) then return end

		base.Rockets:Open()
		base:TurretUpdateBallistics( 999999999999999999999999, "muzzle" )
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()

		if not IsValid( base.Rockets ) or not IsValid( base ) then return end

		base.Rockets:Close()
	end
	weapon.HudPaint = function( ent, X, Y, ply )
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

			base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	self:AddWeapon( weapon )


	-- smoke
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/smoke_launcher.png")
	weapon.Ammo = 4
	weapon.Delay = 1
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.05
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		ent:TakeAmmo( 1 )

		local ID1 = base:LookupAttachment( "smoke_r" )
		local ID2 = base:LookupAttachment( "smoke_l" )

		local Muzzle1 = base:GetAttachment( ID1 )
		local Muzzle2 = base:GetAttachment( ID2 )

		if not Muzzle1 or not Muzzle2 then return end

		local Up = self:GetForward()

		ent:EmitSound("lvs/smokegrenade.wav")

		local Ang1 = Muzzle1.Ang
		Ang1:RotateAroundAxis( Up, 20 )
		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Muzzle1.Pos )
		grenade:SetAngles( Ang1 )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Ang1:Up() * 800 ) 

		local Ang2 = Muzzle2.Ang
		Ang2:RotateAroundAxis( Up, -20 )
		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Muzzle2.Pos )
		grenade:SetAngles( Ang2 )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Ang2:Up() * 800 ) 
	end
	weapon.HudPaint = function( ent, X, Y, ply )
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

			base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not base.GetUseHighExplosive then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
	end
	self:AddWeapon( weapon )

	-- smoke
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/smoke_generator.png")
	weapon.Ammo = 3
	weapon.Delay = 1
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.05
	weapon.Attack = function( ent )
		ent:TakeAmmo( 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( ent:LocalToWorld( Vector(-101.51,-16.35,45.82) ) )
		grenade:SetAngles( ent:GetAngles() )
		grenade:SetParent( ent )
		grenade:Spawn()
		grenade:Activate()
		grenade:Enable()
		grenade:SetColor( Color(0,0,0,0) )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
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

			base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not base.GetUseHighExplosive then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
	end
	self:AddWeapon( weapon )


	-- turret rotation disabler
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent, old, new  )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( false )
		end
		ent:TurretUpdateBallistics( ent.ProjectileVelocityArmorPiercing, "muzzle" )
	end
	weapon.OnDeselect = function( ent, old, new  )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( true )
		end
	end
	weapon.HudPaint = function( ent, X, Y, ply )
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

			base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end

	self:AddWeapon( weapon )



end

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(109.82,46.29,64.25), colorB = 200, colorA = 150, },
			{ pos = Vector(109.82,-48.43,64.25), colorB = 200, colorA = 150, },
		},
		ProjectedTextures = {
			{ pos = Vector(109.82,46.29,64.25), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(109.82,-48.43,64.25), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(109.82,46.29,64.25), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(109.82,-48.43,64.25), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main+high",
		SubMaterialID = 5,
		SubMaterialBrightness = 1,
		Sprites = {
			{ pos = Vector(109.82,46.29,64.25), colorB = 200, colorA = 150 },
			{ pos = Vector(109.82,-48.43,64.25), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 4,
		SubMaterialBrightness = 1,
		Sprites = {
			{ pos = Vector(-128.47,39.2,72.06), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-128.47,-39.2,72.06), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 3,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(110.82,-54.53,68.44), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 2,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(110.55,52.3,68.32), colorG = 100, colorB = 0, colorA = 50 },
		},
	},
}