AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(135,28.35,45), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(150,75,5)

	local NavigatorSeat = self:AddPassengerSeat( Vector(143,-28.35,53), Angle(0,-90,0) )
	NavigatorSeat.ExitPos = Vector(150,-75,5)

	local DoorLHandler = self:AddDoorHandler( "!door_l", Vector(175,43,40), Angle(0,180,0), Vector(0,-3,0), Vector(38,3,47), Vector(0,-3,0), Vector(38,3,47) )
	DoorLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorLHandler:LinkToSeat( DriverSeat )

	local DoorRHandler = self:AddDoorHandler( "!door_r", Vector(175,-43,40), Angle(0,180,0), Vector(0,-3,0), Vector(38,3,47), Vector(0,-3,0), Vector(38,3,47) )
	DoorRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRHandler:LinkToSeat( NavigatorSeat )

	local HoseHandler = self:AddDoorHandler( "!hose", Vector(-175,0,54.2), Angle(0,180,0), Vector(-5,-5,-5), Vector(5,5,5), Vector(-5,-5,-5), Vector(5,5,5) )
	HoseHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HoseHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	self:SetNWEntity("Hose",HoseHandler)	

	self:AddEngine( Vector(60,0,75), Angle(0,0,0), Vector(-26,-40,-15), Vector(30,40,15) )
	self:AddFuelTank( Vector(3,30,34.15), Angle(0,0,0), 1000, LVS.FUELTYPE_DIESEL, Vector(-25,-10,-10), Vector(25,10,10) )
	self:AddAmmoRack( Vector(29,-43,92), Vector(-106,0,95.6), Angle(0,0,0), Vector(-204,0,-47), Vector(0,80,0) )
	self:AddArmor( Vector(190,0,20), Angle(0,0,0), Vector(-370,-47,0), Vector(0,47,84), 1000, 3000 )

	local WheelModel = "models/sw/ground/hemtt/wheel.mdl"
	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 39,
			TorqueFactor = 0.25,
			BrakeFactor = 2,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(120.2,40,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(120.2,-40,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 10,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )
	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 39,
			TorqueFactor = 0.25,
			BrakeFactor = 2,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(65,43,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(65,-40,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 10,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )
	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.25,
			BrakeFactor = 2,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-76,40,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-76,-40,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 5,
			MaxTravel = 10,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )
	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.25,
			BrakeFactor = 2,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-130.5,40,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-130.5,-40,24.45),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
		},
		Suspension = {
			Height = 5,
			MaxTravel = 10,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )
	self:AddTrailerHitch( Vector(-157.6,0,37.4), LVS.HITCHTYPE_MALE )
end
function ENT:AddAmmoRack( pos, fxpos, ang, mins, maxs )
	local AmmoRack = ents.Create( "lvs_wheeldrive_ammorack" )

	if not IsValid( AmmoRack ) then
		self:Remove()

		print("LVS: Failed to create fueltank entity. Vehicle terminated.")

		return
	end

	AmmoRack:SetPos( self:LocalToWorld( pos ) )
	AmmoRack:SetAngles( self:GetAngles() )
	AmmoRack:Spawn()
	AmmoRack:Activate()
	AmmoRack:SetParent( self )
	AmmoRack:SetBase( self )
	AmmoRack:SetEffectPosition( fxpos )

	self:DeleteOnRemove( AmmoRack )

	self:TransferCPPI( AmmoRack )

	mins = mins or Vector(-30,-30,-30)
	maxs = maxs or Vector(30,30,30)

	debugoverlay.BoxAngles( self:LocalToWorld( pos ), mins, maxs, self:LocalToWorldAngles( ang ), 15, Color( 255, 0, 0, 255 ) )

	self:AddDS( {
		pos = pos,
		ang = ang,
		mins = mins,
		maxs =  maxs,
		Callback = function( tbl, ent, dmginfo )
			if not IsValid( AmmoRack ) then return end

			AmmoRack:TakeTransmittedDamage( dmginfo )

			if AmmoRack:GetDestroyed() then return end

			local OriginalDamage = dmginfo:GetDamage()

			dmginfo:SetDamage( math.min( 2, OriginalDamage ) )
		end
	} )

	return AmmoRack
end
function ENT:OnTick()
	if IsValid(self) then
		if IsValid(self:GetNWEntity("Hose")) then
			local HoseHandler = self:GetNWEntity("Hose")
			local state = HoseHandler:GetActive()
			if state == true then
				if not (HoseHandler.OldState == state) then
					if IsValid(HoseHandler:GetNWEntity("LastUser")) then
						self:GiveHose(HoseHandler:GetNWEntity("LastUser"))
					end
				end
			else
				if not (HoseHandler.OldState == state) then
					if IsValid(HoseHandler:GetNWEntity("LastUser")) then
						self:RemoveHose(HoseHandler:GetNWEntity("LastUser"))
					end
				end
			end
			HoseHandler.OldState = state
			if IsValid(HoseHandler:GetNWEntity("LastUser")) then			
				self:CheckHose(HoseHandler:GetNWEntity("LastUser"))
			end
		end
	end
end

--Refueling
function ENT:GiveHose( ply )
	self:EmitSound("common/wpn_select.wav")
	if self:GetFuelType() == 3 then
		ply:SetSuppressPickupNotices( true )
		ply:Give( "weapon_lvsaircraftfuelfiller" )
		ply:SetSuppressPickupNotices( false )
		ply:SelectWeapon( "weapon_lvsaircraftfuelfiller" )
		self:SetUser( ply )
	else
		ply:SetSuppressPickupNotices( true )
		ply:Give( "weapon_lvsfuelfiller" )
		ply:SetSuppressPickupNotices( false )
		ply:SelectWeapon( "weapon_lvsfuelfiller" )
		self:SetUser( ply )
		local SWEP = ply:GetWeapon( "weapon_lvsfuelfiller" )
		if not IsValid( SWEP ) then return end
		SWEP:SetFuelType( self:GetFuelType() )
	end
end
function ENT:RemoveHose( ply )
	if self:GetFuelType() == 3 then
		if ply:HasWeapon( "weapon_lvsaircraftfuelfiller" ) then
			ply:StripWeapon( "weapon_lvsaircraftfuelfiller" )
			ply:SwitchToDefaultWeapon()
		end
		self:SetUser( NULL )
	else
		if ply:HasWeapon( "weapon_lvsfuelfiller" ) then
			ply:StripWeapon( "weapon_lvsfuelfiller" )
			ply:SwitchToDefaultWeapon()
		end
		self:SetUser( NULL )
	end
end
function ENT:CheckHose( ply )
	if not ply:Alive() or ply:InVehicle() then

		self:RemoveHose( ply )

		return
	end

	local weapon = ply:GetActiveWeapon()

	if self:GetFuelType() == 3 then
		if not IsValid( weapon ) or weapon:GetClass() ~= "weapon_lvsaircraftfuelfiller" then
			self:RemoveHose( ply )
			return
		end	
	else
		if not IsValid( weapon ) or weapon:GetClass() ~= "weapon_lvsfuelfiller" then
			self:RemoveHose( ply )
	
			return
		end	
	end

	if (ply:GetPos() - self:GetPos()):LengthSqr() < 150000 then return end

	self:RemoveHose( ply )
end

--MRAP function
function ENT:CalcDamage( dmginfo )
	if dmginfo:GetInflictor():GetNWBool("IsMine") == true then
		if dmginfo:GetDamageType() == DMG_BURN then
			dmginfo:SetDamage(100)
		end
		if dmginfo:GetDamageType() == DMG_BLAST then
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
	if Handler == self:GetNWEntity("Hose") then
		self:GetNWEntity("Hose"):SetNWEntity("LastUser",ply)
	end

	if not IsValid( Pod ) then Handler:Use( ply ) return end

	if not Handler:IsOpen() then 
		Handler:Open( ply ) 
		return
	end

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