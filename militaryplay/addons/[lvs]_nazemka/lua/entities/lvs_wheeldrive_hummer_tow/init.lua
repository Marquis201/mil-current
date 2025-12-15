AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(3.75,28,22), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(40,100,20)
	local PassSeat2 = self:AddPassengerSeat(  Vector(10,-28,28), Angle(0,-90,0) )
	PassSeat2.ExitPos = Vector(40,-100,20)
	local PassSeat3 = self:AddPassengerSeat( Vector(-24,28,28), Angle(0,-90,0) )
	PassSeat3.ExitPos = Vector(-80,100,20)
	local PassSeat4 = self:AddPassengerSeat( Vector(-24,-28,28), Angle(0,-90,0) )
	PassSeat4.ExitPos = Vector(-80,-100,20)
	local GunnerSeat5 = self:AddPassengerSeat( Vector(-10,0,20), Angle(0,-90,0) )
	GunnerSeat5.ExitPos = Vector(-150,0,20)
	self:SetGunnerSeat( GunnerSeat5 )
	GunnerSeat5.HidePlayer = true
	local ID = self:LookupAttachment( "yaw" )
	local Attachment = self:GetAttachment( ID )

	if Attachment then
		local Pos,Ang = LocalToWorld( Vector(0,0,0), Angle(0,0,0), Attachment.Pos, Attachment.Ang )

		GunnerSeat:SetParent( NULL )
		GunnerSeat:SetPos( Pos )
		GunnerSeat:SetAngles( Ang )
		GunnerSeat:SetParent( self )
	end

	self:AddEngine( Vector(60,0,42), Angle(5,0,0), Vector(-15,-5,-5), Vector(10,5,5) )
	self:AddFuelTank( Vector(-65.58,-35.62,47), Angle(0,0,0), 150, LVS.FUELTYPE_DIESEL, Vector(-10,-5,-5), Vector(8,5,5) )
	self:AddTrailerHitch( Vector(-97.5,0,26), LVS.HITCHTYPE_MALE )

	local WheelModel = "models/cars/usa/hummer/wheels.mdl"
	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.5,
			BrakeFactor = 2,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(67.75,40,16),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
				radius = 17,
			} ),
			self:AddWheel( {
				pos = Vector(67.75,-40,16),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
				radius = 17,
			} ),
		},
		Suspension = {
			Height = 5,
			MaxTravel = 7,
			ControlArmLength = 10,
			SpringConstant = 20000,
			SpringDamping = 3000,
			SpringRelativeDamping = 3000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.5,
			BrakeFactor = 3,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-60,40,16),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
				radius = 17,
			} ),

			self:AddWheel( {
				pos = Vector(-60,-40,16),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
				radius = 17,
			} ),
		},
		Suspension = {
			Height = 5,
			MaxTravel = 7,
			ControlArmLength = 10,
			SpringConstant = 20000,
			SpringDamping = 3000,
			SpringRelativeDamping = 3000,
		},
	} )
	for _, wheel in pairs( self:GetWheels() ) do
		if not IsValid( wheel ) then continue end

		wheel:SetModelScale( 0.95 )
	end
end