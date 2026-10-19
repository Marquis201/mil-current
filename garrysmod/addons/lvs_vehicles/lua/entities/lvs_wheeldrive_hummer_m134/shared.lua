ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Hummer (M134)"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Автомобиль"

ENT.VehicleCategory = "Автомобиль"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/cars/usa/hummer/humvee_m134.mdl"

ENT.AITEAM = 1
ENT.MaxHealth = 1500

ENT.MaxVelocity = 2000
ENT.EngineTorque = 150
ENT.EngineIdleRPM = 300
ENT.EngineMaxRPM = 6000
ENT.SteerSpeed = 5

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn2.wav"
ENT.HornPos = Vector(40,0,35)

function ENT:OnSpawn()
    timer.Simple(0.1, function()
        if not IsValid(self) then return end

        self:SetSkin(1)
        self:SetBodygroup(0, 1)
    end)
end

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Bool", "Charging" )
	self:AddDT( "Bool", "Hatch" )
end

ENT.EngineSounds = {
	{
		sound = "vehicles/hummer/idle2.wav",
		Volume = 0.5,
		Pitch = 45,
		PitchMul = 75,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
		{
		sound = "vehicles/hummer/mid.wav",
		Volume = 1,
		Pitch = 40,
		PitchMul = 50,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(39.6,-35.24,73.29),
		ang = Angle(-90,0,0),
	},
	{
		pos = Vector(39.6,-35.24,73.29),
		ang = Angle(-90,0,0),
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		ProjectedTextures = {
			{ pos = Vector(86,30.2,41.75), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(90,19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
			{ pos = Vector(90,-19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
			{ pos = Vector(90,19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
			{ pos = Vector(90,-19.88,38.85), ang = Angle(0,0,0), colorB = 240, colorA = 215, shadows = true },
		},
	},
	{
	Trigger = "main",
		SubMaterialID = 15,
		Sprites = {
			{ pos = Vector(86,30.2,41.75), colorB = 240, colorA = 215 },
		},
	},
	{
	Trigger = "high",
		Sprites = {
			{ pos = Vector(90,19.88,38.85), colorB = 240, colorA = 215 },
			{ pos = Vector(90,-19.88,38.85), colorB = 240, colorA = 215 },
			{ pos = Vector(90,19.88,38.85), colorB = 240, colorA = 215 },
			{ pos = Vector(90,-19.88,38.85), colorB = 240, colorA = 215 },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 12,
		Sprites = {
			{ pos = Vector(86,30.2,41.75), colorG = 0, colorB = 0, colorA = 65 },
		}
	},
	{
		Trigger = "brake",
			{ pos = Vector(-90.85,34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,-34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,-34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
		Sprites = {
		}
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 12,
		Sprites = {
			{ pos = Vector(-90.85,34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
			{ pos = Vector(-90.85,-34.07,38.4), colorG = 0, colorB = 0, colorA = 65 },
		}
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ width = 35, height = 35, pos = Vector(-91.06,-40.25,37.05), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-87.16,-43.61,37.12), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(86.13,-36.05,41.39), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(83.63,-42.99,40.26), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ width = 35, height = 35, pos = Vector(-91.06,40.25,37.05), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-87.16,43.61,37.12), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(86.13,36.05,41.39), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(83.63,42.99,40.26), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
}


sound.Add({
	name = "m134_Shoot",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "vehicles/hummer/m134/m134_shoot.wav"
})

sound.Add({
	name = "m134_stop",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "vehicles/hummer/m134/m134_stop.wav"
})

sound.Add({
	name = "m134_reload",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "vehicles/hummer/m134/mg_reload.wav"
})

function ENT:CalcMainActivity( ply )
	--if ply ~= self:GetDriver() then return self:CalcMainActivityPassenger( ply ) end
	local Pod = ply:GetVehicle()
	if ply == self:GetDriver() then 
		ply.CalcIdeal = ACT_STAND
		ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )
		return ply.CalcIdeal, ply.CalcSeqOverride
	end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 
	
	if (Pod == self:GetGunnerSeat()) then
		if self:GetHatch() then
			ply.CalcIdeal = ACT_STAND
			ply.CalcSeqOverride = ply:LookupSequence( "idle_all_02" )
			return ply.CalcIdeal, ply.CalcSeqOverride
		end
		ply.CalcIdeal = ACT_STAND
		ply.CalcSeqOverride = ply:LookupSequence( "cidle_knife" )

		return ply.CalcIdeal, ply.CalcSeqOverride
	end

	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "sit" )

	return ply.CalcIdeal, ply.CalcSeqOverride
end

ENT.PlayerBoneManipulate = {
	[1] = {
		["ValveBiped.Bip01_R_UpperArm"] = Angle(0,35,0),
		["ValveBiped.Bip01_L_UpperArm"] = Angle(0,35,0),
		
		["ValveBiped.Bip01_R_Forearm"] = Angle(0,-55, 0),
		["ValveBiped.Bip01_L_Forearm"] = Angle(0, -55, 0),
	},
	[5] = {
		["ValveBiped.Bip01_R_Thigh"] = Angle(5,-10,0),
		["ValveBiped.Bip01_L_Thigh"] = Angle(-5,-6,0),
		
		["ValveBiped.Bip01_R_Calf"] = Angle(0,10,0),
		["ValveBiped.Bip01_L_Calf"] = Angle(0,10,0),
		
		["ValveBiped.Bip01_R_Foot"] = Angle(0,5,0),
		["ValveBiped.Bip01_L_Foot"] = Angle(0,5,0),
		
		["ValveBiped.Bip01_R_UpperArm"] = Angle(30,-45,0),
		["ValveBiped.Bip01_L_UpperArm"] = Angle(-30,-45,-10),

		["ValveBiped.Bip01_R_Forearm"] = Angle(0,-60, 0),
		["ValveBiped.Bip01_L_Forearm"] = Angle(0, -60, 0),
		
		["ValveBiped.Bip01_R_Hand"] = Angle(0,0, 0),
		["ValveBiped.Bip01_L_Hand"] = Angle(0,0,0),
	},
}

function ENT:GunnerInRange( Dir )
	return math.abs( self:WorldToLocalAngles( Dir:Angle() ).p ) < 30 and math.abs( self:WorldToLocalAngles( Dir:Angle() ).p ) > 0
end


function ENT:InitWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)
	
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent )
		self:SetHatch(false)
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	self:AddWeapon( weapon, 5)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 4000
	weapon.Delay = 0.01
	weapon.HeatRateUp = .14
	weapon.HeatRateDown = .15
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		if not base:GunnerInRange(ent:GetAimVector()) then return end
		
		if not IsValid( self.SoundEmitter ) then
					local ID = self:LookupAttachment( "muzzle" )
					local Attachment = self:GetAttachment( ID )
					self.SoundEmitter = self:AddSoundEmitter( self:WorldToLocal( Attachment.Pos ), "m134_Shoot", "m134_Shoot" )
					self.SoundEmitter:SetSoundLevel( 95 )
					--print("SoundEmitter created")
				end
		
		self:SetCharging(true)
		if self:GetCharging() then
			timer.Simple(1.5, function()
				--print("Starting charge timer: 1.5 seconds")
				if not IsValid( base ) then return end
				-- Check if entity still charging before continuing
				if self:GetCharging() then
					self:SetCharging(false)
					--print("Charge done")
					return
				end
			end)
		else
			return
		end
		if not self.IsChargingSoundPlaying then
			ent:EmitSound("vehicles/hummer/m134/m134_charge.wav")
			ent.IsChargingSoundPlaying = true
			--print("Playing charge sound")
		end
		
	end
	weapon.Attack = function( ent )
		self.barrelSpinAdd = self.barrelSpinAdd and (self.barrelSpinAdd - self.barrelSpinAdd * FrameTime() * 5) or 0
	    self.barrelSpin = self.barrelSpin and (self.barrelSpin + self.barrelSpinAdd) or 0
		
	    self:ManipulateBoneAngles( 3, Angle(0,0,self.barrelSpin) )
		self.barrelSpinAdd = 30
		
		
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		if not base:GunnerInRange(ent:GetAimVector()) then 
			if IsValid( self.SoundEmitter ) then
				self.SoundEmitter:Stop()
				--print("Stopping sound emitter")
			end
			return 
		end
		
		if self:GetCharging() then 
			--print("Can't attack, still charging")
			return 
		end
		

		if not IsValid( base ) then return end

		local Muzzle = base:GetAttachment( base:LookupAttachment( "muzzle" ) )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos

		local ply = ent:GetDriver()

		if IsValid( ply ) and ply:lvsKeyDown( "ZOOM" ) then
			local pod = ply:GetVehicle()

			if IsValid( pod ) and not pod:GetThirdPersonMode() then
				bullet.Dir = (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
			else
				bullet.Dir = (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
			end
		else
			bullet.Dir 	= (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
		end

		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 2500
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 5
		bullet.Velocity = 17500
		bullet.Attacker 	= ply



		
		ent:LVSFireBullet( bullet )
		ent:TakeAmmo( 1 )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )
		
		if IsValid( self.SoundEmitter ) then
			self.SoundEmitter:Play()
		end
		
	end
	
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		
		self:SetCharging(false)
		--print("Done firing")
		if IsValid( self.SoundEmitter ) then
			self.SoundEmitter:Stop()
			--print("Stopping sound emitter")
		end
		if ent.IsChargingSoundPlaying then
			ent:StopSound("vehicles/hummer/m134/m134_charge.wav")
			ent.IsChargingSoundPlaying = false
			--print("Stopping charge sound")
		end
		self:EmitSound( "m134_stop" )
		
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
		if not base:GunnerInRange(ent:GetAimVector()) then 
			if IsValid( self.SoundEmitter ) then
				self.SoundEmitter:Stop()
				--print("Stopping sound emitter")
			end
			return 
		end
		
		if not self:GetHatch() then return end
		
		if not ent:GetAI() and not IsValid( ent:GetDriver() ) then
			base:SetPoseParameter("mg_aim_pitch",  15 )
			base:SetPoseParameter("mg_aim_yaw", 0 )

			return
		end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		base:SetPoseParameter("mg_aim_yaw", Angles.y )
		base:SetPoseParameter("mg_aim_pitch",  -Angles.p )		
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()

		if not IsValid( base ) then 
			return LVS:CalcView( ent, ply, pos, angles, fov, pod )
		end

		if pod:GetThirdPersonMode() then
			--local posOld = ent:LocalToWorld(Vector(-5979.047852 -7008.534668 -11247.297852))
			local posOld = ent:LocalToWorld(Vector(0, 0, 0))
			pos = posOld + base:GetUp() * 100
		else
			pos = ent:LocalToWorld(Vector(0,0,40))
			--pos = Muzzle.Pos
		end
		return LVS:CalcView( base, ply, pos, angles, fov, pod )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		local Col = base:GunnerInRange( ent:GetAimVector() ) and COLOR_WHITE or COLOR_RED

		base:PaintCrosshairCenter( Pos2D, Col )

		base:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnSelect = function( ent )
		self:SetHatch(true)
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function( ent ) 
		ent:EmitSound( "m134_reload" )
	end
	self:AddWeapon( weapon, 5 )
end