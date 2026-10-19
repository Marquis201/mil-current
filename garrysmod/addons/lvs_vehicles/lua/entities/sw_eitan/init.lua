AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(30,21,55), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(30,90,40)

	local CommanderSeat = self:AddPassengerSeat( Vector(-15,-15,55), Angle(0,-90,0) )
	CommanderSeat.ExitPos = Vector(-15,-90,40)
	CommanderSeat.HidePlayer = true
	self:SetCommanderSeat(CommanderSeat)
	
	local GunnerWeapon = CommanderSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local Pass1Seat = self:AddPassengerSeat( Vector(-15,23,50), Angle(0,180,0) )
	Pass1Seat.ExitPos = Vector(-15,90,40)
	local Pass2Seat = self:AddPassengerSeat( Vector(-40,23,50), Angle(0,180,0) )
	Pass2Seat.ExitPos = Vector(-195,40,40)
	local Pass3Seat = self:AddPassengerSeat( Vector(-60,23,50), Angle(0,180,0) )
	Pass3Seat.ExitPos = Vector(-195,40,40)
	local Pass4Seat = self:AddPassengerSeat( Vector(-80,23,50), Angle(0,180,0) )
	Pass4Seat.ExitPos = Vector(-195,40,40)
	local Pass5Seat = self:AddPassengerSeat( Vector(-100,23,50), Angle(0,180,0) )
	Pass5Seat.ExitPos = Vector(-195,40,40)
	local Pass6Seat = self:AddPassengerSeat( Vector(-40,-23,50), Angle(0,0,0) )
	Pass6Seat.ExitPos = Vector(-195,-40,40)
	local Pass7Seat = self:AddPassengerSeat( Vector(-60,-23,50), Angle(0,0,0) )
	Pass7Seat.ExitPos = Vector(-195,-40,40)
	local Pass8Seat = self:AddPassengerSeat( Vector(-80,-23,50), Angle(0,0,0) )
	Pass8Seat.ExitPos = Vector(-195,-40,40)
	local Pass9Seat = self:AddPassengerSeat( Vector(-100,-23,50), Angle(0,0,0) )
	Pass9Seat.ExitPos = Vector(-195,-40,40)

	self:AddEngine( Vector(25,-25,80), Angle(0,0,0), Vector(-15,-25,-15), Vector(35,25,15) )
	self:AddFuelTank( Vector(-140,-40,80), Angle(0,0,0), 1000, LVS.FUELTYPE_DIESEL, Vector(-15,-15,-15), Vector(15,15,15) )

	local MainArmor = self:AddArmor( Vector(0,0,50), Angle(0,0,0), Vector(-165,-65,-30), Vector(165,65,55), 750, 3500 )
	MainArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	MainArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	self:SetTurretArmor( MainArmor )

	local HatchDHandler =  self:AddDoorHandler( "!hatch_driver", Vector(45.5,22,105), Angle(0,0,0), Vector(-15,-15,-5), Vector(15,15,5), Vector(-15,-15,-5), Vector(15,15,5) )
	HatchDHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchDHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchDHandler:LinkToSeat(DriverSeat)

	local HatchCHandler =  self:AddDoorHandler( "!hatch_commander", Vector(-16.66,-14.35,115), Angle(0,0,0), Vector(-15,-15,-5), Vector(15,15,5), Vector(-15,-15,-5), Vector(15,15,5) )
	HatchCHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchCHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchCHandler:LinkToSeat(CommanderSeat)
	self.ComHatchHandler = HatchCHandler
	
	local HatchGHandler =  self:AddDoorHandler( "!hatch_gunner", Vector(-16.66,14.35,105), Angle(0,0,0), Vector(-15,-15,-5), Vector(15,15,5), Vector(-15,-15,-5), Vector(15,15,5) )
	HatchGHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchGHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchGHandler:LinkToSeat(Pass1Seat)	

	local DoorHandler =  self:AddDoorHandler( "!door", Vector(-125.5,0,70), Angle(0,0,0), Vector(-5,-15,-35), Vector(5,15,35), Vector(-5,-15,-35), Vector(5,15,35) )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat(Pass9Seat)
	
	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	local IDS1 = self:LookupAttachment( "smoke_1" )
	local Smoke1 = self:GetAttachment( IDS1 )
	local IDS2 = self:LookupAttachment( "smoke_2" )
	local Smoke2 = self:GetAttachment( IDS2 )

	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/m2_loop.wav", "sw/vehicles/weapons/m2_interior_loop.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self.SNDTurretStop = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/m2_lastshot.wav", "sw/vehicles/weapons/m2_interior_lastshot.wav" )
	self.SNDTurretStop:SetSoundLevel( 95 )
	self.SNDTurretStop:SetParent( self, ID )

	self.SNDRld = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/mg_reload.wav", "" )
	self.SNDRld:SetSoundLevel( 95 )
	self.SNDRld:SetParent( self, ID )

	self.SNDSmoke1 = self:AddSoundEmitter( self:WorldToLocal( Smoke1.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke1:SetSoundLevel( 95 )
	self.SNDSmoke1:SetParent( self, IDS1 )

	self.SNDSmoke2 = self:AddSoundEmitter( self:WorldToLocal( Smoke2.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke2:SetSoundLevel( 95 )
	self.SNDSmoke2:SetParent( self, IDS2 )

	local WheelModel = "models/sw/ground/eitan/wheel.mdl"
	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.4,
			BrakeFactor = 2,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(103,53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(103,-53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
			self:AddWheel( {
				pos = Vector(41,53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(41,-53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 8,
			MaxTravel = 15,
			ControlArmLength = 25,
			SpringConstant = 10000,
			SpringDamping = 500,
			SpringRelativeDamping = 500,
		},
	} )
	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.6,
			BrakeFactor = 2,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-41,53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(-41,-53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
			self:AddWheel( {
				pos = Vector(-103,53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(-103,-53,26),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 8,
			MaxTravel = 15,
			ControlArmLength = 25,
			SpringConstant = 10000,
			SpringDamping = 500,
			SpringRelativeDamping = 500,
		},
	} )
end
function ENT:CalcDamage( dmginfo )
	if dmginfo:GetInflictor():GetNWBool("IsMine") == true then
		if dmginfo:GetDamageType() == DMG_BURN then
			dmginfo:SetDamage(100)
		end
		if dmginfo:GetDamageType() == DMG_BLAST then
			dmginfo:ScaleDamage(0.05)
		end
	end

	if dmginfo:IsDamageType( self.DSArmorIgnoreDamageType ) then return end

	if dmginfo:IsDamageType( self.DSArmorDamageReductionType ) then
		if dmginfo:GetDamage() ~= 0 then
			dmginfo:ScaleDamage( self.DSArmorDamageReduction )

			dmginfo:SetDamage( math.max(dmginfo:GetDamage(),1) )
		end
	end

	if dmginfo:IsDamageType( DMG_BLAST ) then
		local Inflictor = dmginfo:GetInflictor()

		if IsValid( Inflictor ) and isfunction( Inflictor.GetEntityFilter ) then
			for ents, _ in pairs( Inflictor:GetEntityFilter() ) do
				if ents == self then return end
			end
		end
	end

	local IsFireDamage = dmginfo:IsDamageType( DMG_BURN )
	local IsCollisionDamage = dmginfo:GetDamageType() == (DMG_CRUSH + DMG_VEHICLE)
	local CriticalHit = false

	if dmginfo:GetDamageForce():Length() < self.DSArmorIgnoreForce and not IsFireDamage then return end

	if not IsCollisionDamage then
		CriticalHit = self:CalcComponentDamage( dmginfo )
	end

	local Damage = dmginfo:GetDamage()

	if Damage <= 0 then return end

	local CurHealth = self:GetHP()

	local NewHealth = math.Clamp( CurHealth - Damage, -self:GetMaxHP(), self:GetMaxHP() )

	self:SetHP( NewHealth )

	if self:IsDestroyed() then return end

	local Attacker = dmginfo:GetAttacker() 

	if IsValid( Attacker ) and Attacker:IsPlayer() and not IsFireDamage then
		net.Start( "lvs_hitmarker" )
			net.WriteBool( CriticalHit )
		net.Send( Attacker )
	end

	if Damage > 1 and not IsCollisionDamage and not IsFireDamage then
		net.Start( "lvs_hurtmarker" )
			net.WriteFloat( math.min( Damage / 50, 1 ) )
		net.Send( self:GetEveryone() )
	end

	if NewHealth <= 0 then
		self:SetDestroyed( IsCollisionDamage )

		self:ClearPDS()

		self.FinalAttacker = dmginfo:GetAttacker() 
		self.FinalInflictor = dmginfo:GetInflictor()

		local Attacker = self.FinalAttacker
		if IsValid( Attacker ) and Attacker:IsPlayer() then
			net.Start( "lvs_killmarker" )
			net.Send( Attacker )
		end

		local ExplodeTime = self:PreExplode( math.Clamp((self:GetVelocity():Length() - 200) / 200,1.5,16) )

		timer.Simple( ExplodeTime, function()
			if not IsValid( self ) then return end
			self:Explode()
		end)
	end
end
function ENT:OnTick()
	self:AimTurret()
	if IsValid(self) then
		for k,v in pairs(self._WheelEnts) do
			if IsValid(v) then
				v:SetSkin(self:GetSkin())
			end
		end
		if IsValid(self:GetCommanderSeat()) and IsValid(self:GetCommanderSeat():GetDriver()) then
			if IsValid(self.ComHatchHandler) then
				local PoseValue = self:GetHatch() and 1 or 0
				local DoorHandler = self.ComHatchHandler
				DoorHandler:SetPoseMin( PoseValue )
			end
		else
			if IsValid(self.ComHatchHandler) then
				self:SetHatch(false)
				local PoseValue = self:GetHatch() and 1 or 0
				local DoorHandler = self.ComHatchHandler
				DoorHandler:SetPoseMin( PoseValue )
			end
		end
	end
end

--Screen fade
function ENT:OnSwitchSeat( ply, oldpod, newpod )
	ply:ScreenFade(SCREENFADE.IN, Color(0,0,0, 255), 5, 0.25)
	ply:EmitSound("sw/vehicles/seat_switch.wav")
end
function ENT:Use( ply )
	if not self:IsUseAllowed( ply ) then return end

	if not istable( self._DoorHandlers ) then
		self:SetPassenger( ply )

		return
	end

	if ply:KeyDown( IN_SPEED ) then return end

	local Handler = self:GetDoorHandler( ply )

	if not IsValid( Handler ) then
		if self:HasDoorSystem() and ply:GetMoveType() == MOVETYPE_WALK then
			return
		end

		self:SetPassenger( ply )

		return
	end

	local Pod = Handler:GetLinkedSeat()

	if not IsValid( Pod ) then Handler:Use( ply ) return end

	if not Handler:IsOpen() then Handler:Open( ply ) return end

	if Handler:IsOpen() then
		Handler:Close( ply )
	else
		Handler:OpenAndClose( ply )
	end

	if ply:KeyDown( IN_WALK ) then

		self:SetPassenger( ply )

		return
	end

	local DriverSeat = self:GetDriverSeat()

	if Pod ~= self:GetDriverSeat() then
		if IsValid( Pod:GetDriver() ) then
			self:SetPassenger( ply )
		else
			ply:EnterVehicle( Pod )
			ply:ScreenFade(SCREENFADE.IN, Color(0,0,0, 255), 5, 0.25)
			ply:EmitSound("sw/vehicles/seat_switch.wav")
			self:AlignView( ply )

			hook.Run( "LVS.UpdateRelationship", self )
		end

		return
	end

	if self:GetAI() then
		self:SetPassenger( ply )

		return
	end

	if IsValid( Pod:GetDriver() ) then
		self:SetPassenger( ply )

		return
	end

	if hook.Run( "LVS.CanPlayerDrive", ply, self ) ~= false then
		ply:EnterVehicle( Pod )
		ply:ScreenFade(SCREENFADE.IN, Color(0,0,0, 255), 5, 0.25)
		ply:EmitSound("sw/vehicles/seat_switch.wav")
		self:AlignView( ply )

		hook.Run( "LVS.UpdateRelationship", self )
	else
		hook.Run( "LVS.OnPlayerCannotDrive", ply, self )
	end
end
function ENT:SetPassenger( ply )
	if not IsValid( ply ) then return end

	local AI = self:GetAI()
	local DriverSeat = self:GetDriverSeat()
	local AllowedToBeDriver = hook.Run( "LVS.CanPlayerDrive", ply, self ) ~= false

	if IsValid( DriverSeat ) and not IsValid( DriverSeat:GetDriver() ) and not ply:KeyDown( IN_WALK ) and not AI and AllowedToBeDriver then
		ply:EnterVehicle( DriverSeat )
		ply:ScreenFade(SCREENFADE.IN, Color(0,0,0, 255), 5, 0.25)
		ply:EmitSound("sw/vehicles/seat_switch.wav")
		self:AlignView( ply )

		hook.Run( "LVS.UpdateRelationship", self )
	else
		local Seat = NULL
		local Dist = 500000

		for _, v in pairs( self:GetPassengerSeats() ) do
			if not IsValid( v ) or IsValid( v:GetDriver() ) then continue end
			if v:GetNWInt( "pPodIndex" ) == -1 then continue end

			local cDist = (v:GetPos() - ply:GetPos()):Length()

			if cDist < Dist then
				Seat = v
				Dist = cDist
			end
		end

		if IsValid( Seat ) then
			ply:EnterVehicle( Seat )
			ply:ScreenFade(SCREENFADE.IN, Color(0,0,0, 255), 5, 0.25)
			ply:EmitSound("sw/vehicles/seat_switch.wav")
			self:AlignView( ply, true )

			hook.Run( "LVS.UpdateRelationship", self )
		else
			if IsValid( DriverSeat ) then
				if not IsValid( self:GetDriver() ) and not AI then
					if AllowedToBeDriver then
						ply:EnterVehicle( DriverSeat )
						ply:ScreenFade(SCREENFADE.IN, Color(0,0,0, 255), 5, 0.25)
						ply:EmitSound("sw/vehicles/seat_switch.wav")
						self:AlignView( ply )

						hook.Run( "LVS.UpdateRelationship", self )
					else
						hook.Run( "LVS.OnPlayerCannotDrive", ply, self )
					end
				end
			else
				self:EmitSound( "doors/default_locked.wav" )
			end
		end
	end
end