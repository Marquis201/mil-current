AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:SetLoadout(1)
	self:SetNWInt("Loadout",1)
	self:RemoveWeapon(2)
	self:InitWeapons()

	local DriverSeat = self:AddDriverSeat( Vector(-5,20,45), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(20,70,5)

	local GunnerSeat = self:AddPassengerSeat( Vector(0,-20,50), Angle(0,-90,0) )
	GunnerSeat.ExitPos = Vector(20,-70,5)

	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local PassSeat1 = self:AddPassengerSeat( Vector(-30,20,50), Angle(0,-90,0) )
	PassSeat1.ExitPos = Vector(-10,70,5)

	local PassSeat2 = self:AddPassengerSeat( Vector(-30,-20,50), Angle(0,-90,0) )
	PassSeat2.ExitPos = Vector(-10,-70,5)

	local DoorFLHandler = self:AddDoorHandler( "!door_fl", Vector(15,35,45), Angle(0,180,0), Vector(-15,-3,-5), Vector(20,3,45), Vector(-15,-3,-5), Vector(20,3,45) )
	DoorFLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorFLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorFLHandler:LinkToSeat( DriverSeat )

	local DoorFRHandler = self:AddDoorHandler( "!door_fr", Vector(15,-35,45), Angle(0,180,0), Vector(-15,-3,-5), Vector(20,3,45), Vector(-15,-3,-5), Vector(20,3,45) )
	DoorFRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorFRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorFRHandler:LinkToSeat( GunnerSeat )

	local DoorRLHandler = self:AddDoorHandler( "!door_rl", Vector(-25,35,45), Angle(0,180,0), Vector(-15,-3,-5), Vector(20,3,45), Vector(-15,-3,-5), Vector(20,3,45) )
	DoorRLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRLHandler:LinkToSeat( PassSeat1 )

	local DoorRRHandler = self:AddDoorHandler( "!door_rr", Vector(-25,-35,45), Angle(0,180,0), Vector(-15,-3,-5), Vector(20,3,45), Vector(-15,-3,-5), Vector(20,3,45) )
	DoorRRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRRHandler:LinkToSeat( PassSeat2 )

	self:AddEngine( Vector(80,0,65) )
	self:AddFuelTank( Vector(-53,22,40), Angle(0,0,0), 1000, LVS.FUELTYPE_PETROL, Vector(-10,-10,-10), Vector(10,10,10) )

	self:AddArmor( Vector(0,0,50), Angle(0,0,0), Vector(-105,-50,-35), Vector(45,50,50), 500, 1500 )
	self:AddArmor( Vector(70,0,45), Angle(0,0,0), Vector(-25,-50,-25), Vector(45,50,30), 750, 2000 )

	local IDM240 = self:LookupAttachment( "muzzle_m240" )
	local MuzzleM240 = self:GetAttachment( IDM240 )
	self.SNDTurretM240 = self:AddSoundEmitter( self:WorldToLocal( MuzzleM240.Pos ), "sw/vehicles/weapons/m240_loop.wav", "sw/vehicles/weapons/m240_interior_loop.wav" )
	self.SNDTurretM240:SetSoundLevel( 95 )
	self.SNDTurretM240:SetParent( self, IDM240 )

	self.SNDTurretM240Stop = self:AddSoundEmitter( self:WorldToLocal( MuzzleM240.Pos ), "sw/vehicles/weapons/m240_lastshot.wav", "sw/vehicles/weapons/m240_interior_lastshot.wav" )
	self.SNDTurretM240Stop:SetSoundLevel( 95 )
	self.SNDTurretM240Stop:SetParent( self, IDM240 )

	local IDM2 = self:LookupAttachment( "muzzle_m2" )
	local MuzzleM2 = self:GetAttachment( IDM2 )
	self.SNDTurretM2 = self:AddSoundEmitter( self:WorldToLocal( MuzzleM2.Pos ), "sw/vehicles/weapons/m2_loop.wav", "sw/vehicles/weapons/m2_interior_loop.wav" )
	self.SNDTurretM2:SetSoundLevel( 95 )
	self.SNDTurretM2:SetParent( self, IDM2 )

	self.SNDTurretM2Stop = self:AddSoundEmitter( self:WorldToLocal( MuzzleM2.Pos ), "sw/vehicles/weapons/m2_lastshot.wav", "sw/vehicles/weapons/m2_interior_lastshot.wav" )
	self.SNDTurretM2Stop:SetSoundLevel( 95 )
	self.SNDTurretM2Stop:SetParent( self, IDM2 )

	local IDMK19 = self:LookupAttachment( "muzzle_mk19" )
	local MuzzleMK19 = self:GetAttachment( IDMK19 )
	self.SNDTurretMK19 = self:AddSoundEmitter( self:WorldToLocal( MuzzleMK19.Pos ), "sw/vehicles/weapons/mk_shot.wav", "sw/vehicles/weapons/mk_interior_shot.wav" )
	self.SNDTurretMK19:SetSoundLevel( 95 )
	self.SNDTurretMK19:SetParent( self, IDMK19 )

	local WheelModel = "models/sw/ground/matv/wheel.mdl"
	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 45,
			TorqueFactor = 0,
			BrakeFactor = 2,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(73.45,35,23),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(73.45,-35,23),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 2,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 50000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 2,
			BrakeFactor = 2,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-75,35,23),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-75,-35,23),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 2,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 50000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
	self:AddTrailerHitch( Vector(-108,0,40.5), LVS.HITCHTYPE_MALE )
end
--Remove loadouts
function ENT:RemoveWeapon( PodID )
	if not PodID or PodID <= 1 then
		PodID = 1
	end
	
	if not self.WEAPONS[ PodID ] then
		self.WEAPONS[ PodID ] = {}
	end

	self.WEAPONS[ PodID ] = {}
end
function ENT:OnTick()
	local loadout = self:GetLoadout()
	if loadout == 1 then
		self:SetBodygroup(1,0)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(2)
			self:SetNWInt("Loadout",1)
			self:InitWeapons()
		end
	elseif loadout == 2 then
		self:SetBodygroup(1,1)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(2)
			self:SetNWInt("Loadout",2)
			self:InitWeapons()
		end
	elseif loadout == 3 then
		self:SetBodygroup(1,2)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(2)
			self:SetNWInt("Loadout",3)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout
	if IsValid(self) then
		for k,v in pairs(self._WheelEnts) do
			if IsValid(v) then
				v:SetSkin(self:GetSkin())
			end
		end
	end
end
function ENT:CalcDamage( dmginfo )
	if dmginfo:GetInflictor():GetNWBool("IsMine") == true then
		if dmginfo:GetDamageType() == DMG_BURN then
			print("Burn damage")
			dmginfo:SetDamage(100)
		end
		if dmginfo:GetDamageType() == DMG_BLAST then
			print("Blast damage")
			dmginfo:ScaleDamage(0.1)
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