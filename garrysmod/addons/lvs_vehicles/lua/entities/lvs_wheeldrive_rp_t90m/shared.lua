
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "T-90M"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[MP/LVS] - РП Танки"

ENT.VehicleCategory = "Танки"
ENT.VehicleSubCategory = "РП Средние"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/t90m/t90m.mdl"
ENT.MDL_DESTROYED = "models/diggercars/t90m/t90m_dead.mdl"

ENT.AITEAM = 1

ENT.MaxHealth = 2500

--damage system
ENT.DSArmorIgnoreForce = 3000
ENT.CannonArmorPenetration = 58000
ENT.CannonArmorPenetration1km = 53200
ENT.FrontArmor = 25000
ENT.SideArmor = 5000
ENT.TurretArmor = 20500
ENT.TurretBottomArmor = 17000
ENT.TurretBaseArmor = 3000
ENT.UpperArmor = 100
ENT.RearArmor = 1500

ENT.ProjectileVelocityCoaxial = 15000
ENT.ProjectileVelocityHighExplosive = 16000
ENT.ProjectileVelocityArmorPiercing = 30000

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.MaxVelocity = 650
ENT.MaxVelocityReverse = 150

ENT.EngineCurve = 0.1
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/t72b/t72b_low.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/t72b/t72b_idle.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/t72b/t72b_idle.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{pos = Vector(-70,79,47),ang = Angle(20,90,0),},
	{pos = Vector(-74,79,47),ang = Angle(20,90,0),},
	{pos = Vector(-78,79,47),ang = Angle(20,90,0),},
	{pos = Vector(-83,79,47),ang = Angle(20,90,0),},
	{pos = Vector(-70,79,47),ang = Angle(20,90,0),},
	{pos = Vector(-74,79,47),ang = Angle(20,90,0),},
	{pos = Vector(-78,79,47),ang = Angle(20,90,0),},
	{pos = Vector(-83,79,47),ang = Angle(20,90,0),},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "MGSeat" )
	self:AddDT( "Bool", "UseHighExplosive" )
	self:AddDT( "Bool", "Hatch" )
end

function ENT:InitWeapons()

	local COLOR_WHITE = Color(255,255,255,255)


	-- smoke
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/smoke_generator.png")
	weapon.Ammo = 3
	weapon.Delay = 1
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.05
	weapon.UseableByAI = false
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
	self:AddWeapon( weapon )

	-- driver hatch open
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/binoculars.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.DriverHatch ) then return end
		if not IsValid( base ) then return end
		base.DriverHatch:Open()
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.DriverHatch ) then return end
		if not IsValid( base ) then return end
		base.DriverHatch:Close()
	end

	self:AddWeapon( weapon )


	self:AddGunnerWeapons()
end

function ENT:GunnerInRange( Dir )
	return self:AngleBetweenNormal( self:GetForward(), Dir ) < 180
end

function ENT:AddGunnerWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)



	local weapon = {}
	weapon.Icon = true
	weapon.Ammo = 60
	weapon.Delay = 3.4
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.11

	weapon.OnThink = function( ent )
		local base = ent:GetVehicle()
		local ply = ent:GetDriver()
		if ent:GetSelectedWeapon() ~= 1 then return end
		if not IsValid( ply ) then return end

		local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )

		if ent._oldSwitchType ~= SwitchType then
			ent._oldSwitchType = SwitchType

			if SwitchType then
				base:SetUseHighExplosive( not base:GetUseHighExplosive() )
				base:DoReloadSequence( 0 )
				ent:SetHeat( 1 )
				ent:SetOverheated( true )

				if base:GetUseHighExplosive() then
					base:TurretUpdateBallistics( base.ProjectileVelocityHighExplosive )
				else
					base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing )
				end

			end
		end
	end

	weapon.Attack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		local ID = base:LookupAttachment( "muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread = Vector(0,0,0)
		bullet.EnableBallistics = true

		if base:GetUseHighExplosive() then
			bullet.Force	= 500
			bullet.HullSize 	= 15
			bullet.Damage	= 250
			bullet.SplashDamage = 1000
			bullet.SplashDamageRadius = 250
			bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
			bullet.SplashDamageType = DMG_BLAST
			bullet.Velocity = base.ProjectileVelocityHighExplosive
		else
			bullet.Force	= base.CannonArmorPenetration
			bullet.Force1km	= base.CannonArmorPenetration1km
			bullet.HullSize 	= 0
			bullet.Damage	= 1250
			bullet.Velocity = base.ProjectileVelocityArmorPiercing
		end

		bullet.TracerName = "lvs_tracer_cannon"
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		local PhysObj = base:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 150000, bullet.Src )
		end

		ent:TakeAmmo( 1 )

		base:PlayAnimation( "shot" )
		base:DoReloadSequence( 1 )

		if not IsValid( base.SNDTurret ) then return end

		base.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + base:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

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

			if base:GetUseHighExplosive() then
				base:PaintCrosshairSquare( MuzzlePos2D, COLOR_WHITE )
			else
				base:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
			end

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not base.GetUseHighExplosive then return end

		if base:GetUseHighExplosive() then
			base:TurretUpdateBallistics( base.ProjectileVelocityHighExplosive, "muzzle" )
		else
			base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
		end
	end
	self:AddWeapon( weapon, 2 )






	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 6000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.EnableBallistics = true
		bullet.Force	= 500
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = base.ProjectileVelocityCoaxial
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

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local Start = Muzzle.Pos

			local traceTurret = util.TraceLine( {
				start = Start,
				endpos = Start + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle_coax" )
	end
	self:AddWeapon( weapon, 2 )


	local weapon = {}
	weapon.Icon = Material("lvs/weapons/smoke_launcher.png")
	weapon.Ammo = 3
	weapon.Delay = 1
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.05
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		ent:TakeAmmo( 1 )

		local ID1 = base:LookupAttachment( "muzzle_smoke_right" )
		local ID2 = base:LookupAttachment( "muzzle_smoke_left" )

		local Muzzle1 = base:GetAttachment( ID1 )
		local Muzzle2 = base:GetAttachment( ID2 )

		if not Muzzle1 or not Muzzle2 then return end

		local Up = self:GetForward()

		ent:EmitSound("lvs/smokegrenade.wav")

		local Ang1 = Muzzle1.Ang
		Ang1:RotateAroundAxis( Up, -5 )
		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Muzzle1.Pos )
		grenade:SetAngles( Ang1 )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Ang1:Forward() * 1000 ) 

		local Ang2 = Muzzle2.Ang
		Ang2:RotateAroundAxis( Up, 5 )
		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Muzzle2.Pos )
		grenade:SetAngles( Ang2 )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Ang2:Forward() * 1000 ) 
	end

	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local Start = Muzzle.Pos

			local traceTurret = util.TraceLine( {
				start = Start,
				endpos = Start + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle_coax" )
	end
	self:AddWeapon( weapon, 2 )

	-- turret rotation disabler
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( false )
		end
		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle_coax" )
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( true )
		end
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local Start = Muzzle.Pos

			local traceTurret = util.TraceLine( {
				start = Start,
				endpos = Start + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end

	self:AddWeapon( weapon, 2 )

	-- comm observe
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tanksights.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.CommMode ) then return end
		if not IsValid( base ) then return end
		base.CommMode:Close()
		base:SetHatch(false)
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.CommMode ) then return end
		if not IsValid( base ) then return end
		base.CommMode:Open()
		base:SetHatch(false)
	end

	self:AddWeapon( weapon, 3 )

	-- comm screen
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.CommMode ) then return end
		if not IsValid( base ) then return end
		base.CommMode:Open()
		base:SetHatch(false)
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.CommMode ) then return end
		if not IsValid( base ) then return end
		base.CommMode:Close()
		base:SetHatch(false)
	end

	self:AddWeapon( weapon, 3 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 500
	weapon.Delay = 0.15
	weapon.HeatRateUp = 0.135
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "mg_muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.EnableBallistics = true
		bullet.Force	= 4500
		bullet.HullSize 	= 0
		bullet.Damage	= 35
		bullet.Velocity = base.ProjectileVelocityCoaxial
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )
		base:PlayAnimation( "shot_mg" )
	end

	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		if not IsValid( base.SNDTurretMGf ) then return end
		base.SNDTurretMGf:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		if not IsValid( base.SNDTurretMGf ) then return end
		base.SNDTurretMGf:Stop()
	end

	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.CommMode ) then return end
		if not IsValid( base ) then return end
		base.CommMode:Open()
		base:SetHatch(true)
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.CommMode ) then return end
		if not IsValid( base ) then return end
		base.CommMode:Close()
		base:SetHatch(false)
	end

	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()
	
		if not active then
			base:SetPoseParameter("mg_yaw", 0 )
			base:SetPoseParameter("mg_pitch", 0 )
			return
		end

		if not IsValid( base ) then return end

		local pod = base:GetMGSeat()

		if not base:GetAI() and (not IsValid( pod ) or not IsValid( pod:GetDriver() )) then return end

		local Ang = base:WorldToLocalAngles( ent:GetAimVector():Angle() ) - Angle(0,base:GetTurretYaw(),0)
		Ang:Normalize()
		
		base:SetPoseParameter("mg_yaw", Ang.y )
		base:SetPoseParameter("mg_pitch", -Ang.p )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		local ID = base:LookupAttachment(  "mg_muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()

			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			base:PaintCrosshairSquare( MuzzlePos2D, COLOR_WHITE )


			base:LVSPaintHitMarker( MuzzlePos2D )
		if not self:GetMGSeat():GetThirdPersonMode() then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			if (MuzzlePos2D.x > -X and MuzzlePos2D.x < X * 2) and (MuzzlePos2D.y > -Y and MuzzlePos2D.y < Y * 2) then
				local black = Material( "lvs/halo.png" )
				local scope = Material( "lvs/sight_tiger_mg.png" )
				surface.SetMaterial( black )
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawTexturedRect( MuzzlePos2D.x - 28160, MuzzlePos2D.y - 15840, 56320, 31680 )
			
				surface.SetMaterial( scope )
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawTexturedRect( MuzzlePos2D.x - 600, MuzzlePos2D.y - 600, 1200, 1200 )
			else
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, X, Y )
			end
		end
	end
	end


	self:AddWeapon( weapon, 3 )
end

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(120.42,30.63,44.16), colorB = 200, colorA = 150, },
		},
		ProjectedTextures = {
			{ pos = Vector(120.42,30.63,44.16), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(120.42,30.63,44.16), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main+high",
		Sprites = {
			{ pos = Vector(120.42,30.63,44.16), colorB = 200, colorA = 150 },
		},
	},

}
