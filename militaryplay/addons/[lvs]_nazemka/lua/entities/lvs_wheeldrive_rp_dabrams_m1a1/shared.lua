
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Abrams M1A1"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[MP/LVS] - РП Танки"

ENT.VehicleCategory = "Танки"
ENT.VehicleSubCategory = "РП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/abrams_m1a1/abrams.mdl"
ENT.MDL_DESTROYED = "models/diggercars/abrams_m1a1/ded.mdl"

ENT.GibModels = {
	"models/gibs/helicopter_brokenpiece_01.mdl",
	"models/gibs/helicopter_brokenpiece_02.mdl",
	"models/gibs/helicopter_brokenpiece_03.mdl",
	"models/combine_apc_destroyed_gib02.mdl",
	"models/combine_apc_destroyed_gib04.mdl",
	"models/combine_apc_destroyed_gib05.mdl",
	"models/props_c17/trappropeller_engine.mdl",
	"models/gibs/airboat_broken_engine.mdl",
}


ENT.AITEAM = 2

ENT.MaxHealth = 2500

--damage system
ENT.DSArmorIgnoreForce = 3000
ENT.CannonArmorPenetration = 59800
ENT.CannonArmorPenetration1km = 56000


ENT.TurretCheeks = 87000
ENT.TurretSide = 40000
ENT.Mask = 32000
ENT.FrontTop = 1200
ENT.Front = 46000
ENT.SideFront = 10000
ENT.Tracks = 15000
ENT.SideRear = 2000
ENT.Rear = 500
ENT.Top = 100

ENT.ProjectileVelocityCoaxial = 25000
ENT.ProjectileVelocityHighExplosive = 26000
ENT.ProjectileVelocityArmorPiercing = 30000

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 1350
ENT.MaxVelocityReverse = 550

ENT.EngineCurve = 0.1
ENT.EngineTorque = 150

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.lvsShowInSpawner = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.RandomColor = {
	{
		Skin = 1,
	},
	{
		Skin = 2,
	},
	{
		Skin = 3,
	},
	{
		Skin = 4,
	},
	{
		Skin = 5,
	},
}



ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/abrams/abrams_idle.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/abrams/abrams_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "CommSeat" )
	self:AddDT( "Entity", "LoaderSeat" )
	self:AddDT( "Entity", "TopGunnerSeat" )
	self:AddDT( "Bool", "UseHighExplosive" )
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/smoke_launcher.png")
	weapon.Ammo = 3
	weapon.Delay = 1
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.05
	weapon.UseableByAI = false
	weapon.Attack = function( ent )
		ent:TakeAmmo( 1 )

		local ID1 = ent:LookupAttachment( "s1" )
		local ID2 = ent:LookupAttachment( "s2" )

		local Muzzle1 = ent:GetAttachment( ID1 )
		local Muzzle2 = ent:GetAttachment( ID2 )

		if not Muzzle1 or not Muzzle2 then return end

		local Up = self:GetUp()

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

		local Ang3 = Muzzle1.Ang
		Ang3:RotateAroundAxis( Up, -15 )
		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Muzzle1.Pos )
		grenade:SetAngles( Ang3 )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Ang3:Forward() * 1000 ) 


		local Ang4 = Muzzle2.Ang
		Ang4:RotateAroundAxis( Up, 15 )
		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Muzzle2.Pos )
		grenade:SetAngles( Ang4 )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Ang4:Forward() * 1000 ) 
	end
	self:AddWeapon( weapon )

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
		grenade:SetPos( ent:LocalToWorld( Vector(-160,0,55) ) )
		grenade:SetAngles( ent:GetAngles() )
		grenade:SetParent( ent )
		grenade:Spawn()
		grenade:Activate()
		grenade:Enable()
		grenade:SetColor( Color(0,0,0,0) )
	end

	self:AddWeapon( weapon )

	-- driver hatch close
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hatch_closed.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base.DriverHatch ) then return end
		if not IsValid( base ) then return end
		base.DriverHatch:Close()
	end
	self:AddWeapon( weapon )

	-- driver hatch open
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hatch_opend.png")
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




	local weapon = {}
	weapon.Icon = true
	weapon.Ammo = 60
	weapon.Delay = 1
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.2

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
				base:PlayAnimation( "reload" )
				ent:SetHeat( 1 )
				ent:SetOverheated( true )

				if base:GetUseHighExplosive() then
					base:SetBodygroup(1, 1)
					base:TurretUpdateBallistics( base.ProjectileVelocityHighExplosive )
				else
					base:SetBodygroup(1, 0)
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

		base:PlayAnimation( "sreload" )

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


	-- coaxial machinegun
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
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
		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 20000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		if not IsValid( base.SNDTurretMG ) then return end
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
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
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
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end
	end

	self:AddWeapon( weapon, 2 )

	self:AddGunnerWeapons()
end

function ENT:AddGunnerWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_m2" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_autocannon"
		bullet.Force	= 3900
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 50
		bullet.Velocity = 25000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		if not IsValid( base.SNDTurretMGf ) then return end

		base:PlayAnimation( "shot_mg" )

		base.SNDTurretMGf:Play()
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Stop()
		base.SNDTurretMGf:EmitSound( "lvs/vehicles/abrams/m2hb_last.wav" )
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local pod = base:GetCommSeat()

		if not ent:GetAI() and (not IsValid( pod ) or not IsValid( pod:GetDriver() )) then return end

		local Ang = base:WorldToLocalAngles( ent:GetAimVector():Angle() ) - Angle(0,base:GetTurretYaw(),0)
		Ang:Normalize()

		base:SetPoseParameter("comm_yaw", Ang.y )
		base:SetPoseParameter("comm_pitch", -Ang.p )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		local ID = base:LookupAttachment( "cupola_sight" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local Start = Muzzle.Pos

			local traceTurret = util.TraceLine( {
				start = Start,
				endpos = Start + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			base:PaintCrosshairCenter( MuzzlePos2D, Col )
			base:LVSPaintHitMarker( MuzzlePos2D )
		end
		if not self:GetCommSeat():GetThirdPersonMode() and ply:lvsKeyDown("ZOOM") then
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
	self:AddWeapon( weapon, 3 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.08
	weapon.HeatRateUp = 0.15
	weapon.HeatRateDown = 0.3
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_mg" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 20000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		if not IsValid( base.SNDTurretMGt ) then return end

		base.MgShot:PlayOnce() -- shoot anim

		base.SNDTurretMGt:Play()
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGt ) then return end

		base.SNDTurretMGt:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGt ) or not base.SNDTurretMGt:GetActive() then return end

		base.SNDTurretMGt:Stop()
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local pod = base:GetTopGunnerSeat()

		if not ent:GetAI() and (not IsValid( pod ) or not IsValid( pod:GetDriver() )) then return end

		local Ang = base:WorldToLocalAngles( ent:GetAimVector():Angle() ) - Angle(0,base:GetTurretYaw(),0)
		Ang:Normalize()

		base:SetPoseParameter("mg_yaw", Ang.y )
		base:SetPoseParameter("mg_pitch", -Ang.p )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_mg" )

		local Muzzle = base:GetAttachment( ID )

		local pod = ply:GetVehicle()

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 
		base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )

		base:LVSPaintHitMarker( Pos2D )
		end
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon, 5 )
end


ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(138.68,34.19,50.43), colorB = 200, colorA = 150, },
			{ pos = Vector(139.73,-38.19,50.93), colorB = 200, colorA = 150, },
			{ pos = Vector(-171.3,64.5,65), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-171.3,-64.5,65), colorG = 0, colorB = 0, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(138.68,34.19,50.43), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(139.73,-38.19,50.93), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(138.68,34.19,50.43), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(139.73,-38.19,50.93), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main+high",
		SubMaterialID = 4,
		SubMaterialBrightness = 2,
		Sprites = {
			{ pos = Vector(138.68,34.19,50.43), colorB = 200, colorA = 150 },
			{ pos = Vector(139.73,-38.19,50.93), colorB = 200, colorA = 150 },
		},
	},

	{
		Trigger = "brake",
		Sprites = {
			{ pos = Vector(-171.3,64.5,65), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-171.3,-64.5,65), colorG = 0, colorB = 0, colorA = 150 },
		}
	},

	{
		Trigger = "main",
		SubMaterialID = 9,
	},
	{
		Trigger = "main",
		SubMaterialID = 13,
	},
	{
		Trigger = "main",
		SubMaterialID = 16,
	},
	{
		Trigger = "main",
		SubMaterialID = 24,
	},
	{
		Trigger = "main",
		SubMaterialID = 25,
	},
}


sound.Add( {
	name = "LVS.ABRAMS_OPEN",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 75,
	pitch = {100, 140},
	sound = {
		"lvs/vehicles/abrams/open.wav",
	}
} )
sound.Add( {
	name = "LVS.ABRAMS_SHELL1",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 75,
	pitch = {80, 120},
	sound = {
		"lvs/vehicles/abrams/shell1.wav",
	}
} )
sound.Add( {
	name = "LVS.ABRAMS_SHELL2",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 75,
	pitch = {80, 120},
	sound = {
		"lvs/vehicles/abrams/shell2.wav",
	}
} )
sound.Add( {
	name = "LVS.ABRAMS_LOAD",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 75,
	pitch = {80, 120},
	sound = {
		"lvs/vehicles/abrams/load.wav",
	}
} )