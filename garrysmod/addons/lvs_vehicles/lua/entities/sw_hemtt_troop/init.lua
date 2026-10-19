AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(135,28.35,45), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(150,75,5)

	local NavigatorSeat = self:AddPassengerSeat( Vector(143,-28.35,53), Angle(0,-90,0) )
	NavigatorSeat.ExitPos = Vector(150,-75,5)

	local PassSeat1 = self:AddPassengerSeat( Vector(5,-34,70), Angle(0,0,0) )
	PassSeat1.ExitPos = Vector(-250,-20,5)

	local PassSeat2 = self:AddPassengerSeat( Vector(5,34,70), Angle(0,180,0) )
	PassSeat2.ExitPos = Vector(-250,20,5)

	local PassSeat3 = self:AddPassengerSeat( Vector(-25,-34,70), Angle(0,0,0) )
	PassSeat3.ExitPos = Vector(-250,-20,5)

	local PassSeat4 = self:AddPassengerSeat( Vector(-25,34,70), Angle(0,180,0) )
	PassSeat4.ExitPos = Vector(-250,20,5)

	local PassSeat5 = self:AddPassengerSeat( Vector(-55,-34,70), Angle(0,0,0) )
	PassSeat5.ExitPos = Vector(-250,-20,5)

	local PassSeat6 = self:AddPassengerSeat( Vector(-55,34,70), Angle(0,180,0) )
	PassSeat6.ExitPos = Vector(-250,20,5)
	
	local PassSeat7 = self:AddPassengerSeat( Vector(-85,-34,70), Angle(0,0,0) )
	PassSeat7.ExitPos = Vector(-250,-20,5)

	local PassSeat8 = self:AddPassengerSeat( Vector(-85,34,70), Angle(0,180,0) )
	PassSeat8.ExitPos = Vector(-250,20,5)

	local PassSeat9 = self:AddPassengerSeat( Vector(-115,-34,70), Angle(0,0,0) )
	PassSeat9.ExitPos = Vector(-250,-20,5)

	local PassSeat10 = self:AddPassengerSeat( Vector(-115,34,70), Angle(0,180,0) )
	PassSeat10.ExitPos = Vector(-250,20,5)

	local PassSeat11 = self:AddPassengerSeat( Vector(-145,-34,70), Angle(0,0,0) )
	PassSeat11.ExitPos = Vector(-250,-20,5)

	local PassSeat12 = self:AddPassengerSeat( Vector(-145,34,70), Angle(0,180,0) )
	PassSeat12.ExitPos = Vector(-250,20,5)

	local DoorLHandler = self:AddDoorHandler( "!door_l", Vector(175,43,40), Angle(0,180,0), Vector(0,-3,0), Vector(38,3,47), Vector(0,-3,0), Vector(38,3,47) )
	DoorLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorLHandler:LinkToSeat( DriverSeat )

	local DoorRHandler = self:AddDoorHandler( "!door_r", Vector(175,-43,40), Angle(0,180,0), Vector(0,-3,0), Vector(38,3,47), Vector(0,-3,0), Vector(38,3,47) )
	DoorRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRHandler:LinkToSeat( NavigatorSeat )

	local HatchHandler = self:AddDoorHandler( "!hatch", Vector(-178,43,57), Angle(0,180,0), Vector(-3,0,0), Vector(3,86,27), Vector(-3,0,0), Vector(3,86,27) )
	HatchHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchHandler:LinkToSeat( PassSeat12 )

	self:AddEngine( Vector(60,0,75), Angle(0,0,0), Vector(-26,-40,-15), Vector(30,40,15) )
	self:AddFuelTank( Vector(3,30,34.15), Angle(0,0,0), 1000, LVS.FUELTYPE_DIESEL, Vector(-25,-10,-10), Vector(25,10,10) )

	self:AddArmor( Vector(190,0,20), Angle(0,0,0), Vector(-370,-45,0), Vector(0,45,84), 1000, 3000 )

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