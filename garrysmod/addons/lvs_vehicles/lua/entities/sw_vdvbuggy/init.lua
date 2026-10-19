AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:SetLoadout(1)
	self:SetNWInt("Loadout",1)
	self:RemoveWeapon(3)
	self:InitWeapons()

	local DriverSeat = self:AddDriverSeat( Vector(-15,23,15), Angle(0,-90,0) )
	local NavigatorSeat = self:AddPassengerSeat( Vector(-5,-23,23), Angle(0,-90,0) )
	local GunnerSeat = self:AddPassengerSeat( Vector(-40,0,45), Angle(0,-90,0) )
	self:SetGunnerSeat(GunnerSeat)

	DriverSeat.ExitPos = Vector(0,70,5)
	NavigatorSeat.ExitPos = Vector(0,-70,5)
	GunnerSeat.ExitPos = Vector(-100,0,5)
	GunnerSeat.HidePlayer = true

	self:AddEngine( Vector(50,0,30) )
	self:AddFuelTank( Vector(50,-15,30), Angle(0,0,0), 400, LVS.FUELTYPE_PETROL, Vector(-5,-5,-5), Vector(5,5,5) )

	local ID1 = self:LookupAttachment( "muzzle_pkp" )
	local MuzzlePkp = self:GetAttachment( ID1 )
	self.SNDTurretPkp = self:AddSoundEmitter( self:WorldToLocal( MuzzlePkp.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_loop.wav" )
	self.SNDTurretPkp:SetSoundLevel( 95 )
	self.SNDTurretPkp:SetParent( self, ID1 )

	self.SNDTurretPkpStop = self:AddSoundEmitter( self:WorldToLocal( MuzzlePkp.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_lastshot.wav" )
	self.SNDTurretPkpStop:SetSoundLevel( 95 )
	self.SNDTurretPkpStop:SetParent( self, ID1 )

	local ID2 = self:LookupAttachment( "muzzle_kord" )
	local MuzzleKord = self:GetAttachment( ID2 )
	self.SNDTurretKord = self:AddSoundEmitter( self:WorldToLocal( MuzzleKord.Pos ), "sw/vehicles/weapons/kord_loop.wav", "sw/vehicles/weapons/kord_loop.wav" )
	self.SNDTurretKord:SetSoundLevel( 95 )
	self.SNDTurretKord:SetParent( self, ID2 )
	
	self.SNDTurretKordStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleKord.Pos ), "sw/vehicles/weapons/kord_lastshot.wav", "sw/vehicles/weapons/kord_lastshot.wav" )
	self.SNDTurretKordStop:SetSoundLevel( 95 )
	self.SNDTurretKordStop:SetParent( self, ID2 )

	local ID3 = self:LookupAttachment( "muzzle_ags" )
	local MuzzleAgs = self:GetAttachment( ID3 )
	self.SNDTurretAgs = self:AddSoundEmitter( self:WorldToLocal( MuzzleAgs.Pos ), "sw/vehicles/weapons/ags_shot.wav", "sw/vehicles/weapons/ags_shot.wav" )
	self.SNDTurretAgs:SetSoundLevel( 95 )
	self.SNDTurretAgs:SetParent( self, ID3 )

	local ID4 = self:LookupAttachment( "muzzle_gshg" )
	local MuzzleGShG = self:GetAttachment( ID4 )
	self.SNDTurretGShG = self:AddSoundEmitter( self:WorldToLocal( MuzzleGShG.Pos ), "sw/vehicles/weapons/yakb127_loop.wav", "sw/vehicles/weapons/yakb127_loop.wav" )
	self.SNDTurretGShG:SetSoundLevel( 95 )
	self.SNDTurretGShG:SetParent( self, ID4 )

	self.SNDTurretGShGStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleGShG.Pos ), "sw/vehicles/weapons/yakb127_lastshot.wav", "sw/vehicles/weapons/yakb127_lastshot.wav" )
	self.SNDTurretGShGStop:SetSoundLevel( 95 )
	self.SNDTurretGShGStop:SetParent( self, ID4 )

	local WheelModel = "models/sw/ground/vdvbuggy/wheel.mdl"
	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 35,
			TorqueFactor = 0.5,
			BrakeFactor = 2,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(58.35,35,15.55),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(58.35,-35,15.55),
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
			TorqueFactor = 1,
			BrakeFactor = 2,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-51.6,35,15.55),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-51.6,-35,15.55),
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

	self:AddTrailerHitch( Vector(-105,0,23.6), LVS.HITCHTYPE_MALE )
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
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",1)
			self:InitWeapons()
		end
	elseif loadout == 2 then
		self:SetBodygroup(1,1)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",2)
			self:InitWeapons()
		end
	elseif loadout == 3 then
		self:SetBodygroup(1,2)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",3)
			self:InitWeapons()
		end
	elseif loadout == 4 then
		self:SetBodygroup(1,3)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",4)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout
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