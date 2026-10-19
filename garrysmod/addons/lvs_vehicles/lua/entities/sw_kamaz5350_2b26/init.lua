AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(95,27,60), Angle(0,-90,0) )
	local NavigatorSeat = self:AddPassengerSeat( Vector(105,-27,65), Angle(0,-90,0) )
	local CommanderSeat = self:AddPassengerSeat( Vector(105,0,65), Angle(0,-90,0) )

	self:SetGunnerSeat(NavigatorSeat)

	local DoorLHandler = self:AddDoorHandler( "!door_l", Vector(115,50,65), Angle(0,180,0), Vector(-25,-1,-15), Vector(25,1,45), Vector(-25,-1,-15), Vector(25,1,45) )
	DoorLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorLHandler:LinkToSeat( DriverSeat )

	local DoorRHandler =  self:AddDoorHandler( "!door_r", Vector(115,-50,65), Angle(0,180,0), Vector(-25,-1,-15), Vector(25,1,45),  Vector(-25,-1,-15), Vector(25,1,45) )
	DoorRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRHandler:LinkToSeat( NavigatorSeat )

	local HatchTHandler =  self:AddDoorHandler( "!hatch", Vector(105,0,120), Angle(0,180,0), Vector(-15,-15,-5), Vector(15,15,5),  Vector(-15,-15,-5), Vector(15,15,5) )
	HatchTHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchTHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchTHandler:LinkToSeat( CommanderSeat )

	self:AddEngine( Vector(145,0,55) )

	self:AddFuelTank( Vector(25,30,40), Angle(0,0,0), 1500, LVS.FUELTYPE_DIESEL )

	local WheelModel = "models/sw/ground/kamaz5350/wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(93.7,45,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),
			self:AddWheel( {
				pos = Vector(93.7,-45,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
		},
		Suspension = {
			Height = 5,
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
			TorqueFactor = 1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-49.6,45,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-49.6,-45,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-108.6,45,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-108.6,-45,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
		},
		Suspension = {
			Height = 4,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 50000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	local ID = self:LookupAttachment( "muzzle_1" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/rocket/tank_rocket_shot_1.wav", "sw/rocket/tank_rocket_shot_1.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self:AddTrailerHitch( Vector(-158,0,43), LVS.HITCHTYPE_MALE )
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