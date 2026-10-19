AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:SetLoadout(4)
	self:SetNWInt("Loadout",1)
	self:RemoveWeapon(1)
	self:RemoveWeapon(3)
	self:InitWeapons()

	self.HornSND = self:AddSoundEmitter( Vector(115,0,50), "lvs/horn2.wav" )
	self.HornSND:SetSoundLevel( 75 )
	self.HornSND:SetDoppler( true )

	local DriverSeat = self:AddDriverSeat( Vector(0,25,40), Angle(0,-90,0) )
	local NavigatorSeat = self:AddPassengerSeat( Vector(10,-25,45), Angle(0,-90,0) )
	local GunnerSeat = self:AddPassengerSeat( Vector(-20,-25,45), Angle(0,-90,0) )
	self:SetGunnerSeat(GunnerSeat)

	DriverSeat.ExitPos = Vector(-10,70,5)
	NavigatorSeat.ExitPos = Vector(-10,-70,5)
	GunnerSeat.ExitPos = Vector(-10,-70,5)
	GunnerSeat.HidePlayer = true
	
	local Seat1 = self:AddPassengerSeat( Vector(-20,33,45), Angle(0,-90,0) )
	Seat1.ExitPos = Vector(-10,70,5)
	local Seat3 = self:AddPassengerSeat( Vector(-65.6,23,45), Angle(0,180,0) )
	Seat3.ExitPos = Vector(-150,25,5)
	local Seat4 = self:AddPassengerSeat( Vector(-65.6,-23,45), Angle(0,0,0) )
	Seat4.ExitPos = Vector(-150,-25,5)
	local Seat5 = self:AddPassengerSeat( Vector(-88.1,23,45), Angle(0,180,0) )
	Seat5.ExitPos = Vector(-150,25,5)
	local Seat6 = self:AddPassengerSeat( Vector(-88.1,-23,45), Angle(0,0,0) )
	Seat6.ExitPos = Vector(-150,-25,5)

	self:AddEngine( Vector(70,0,65) )
	self:AddFuelTank( Vector(-18.3,40,38), Angle(0,0,0), 1000, LVS.FUELTYPE_PETROL, Vector(-15,-5,-5), Vector(15,5,5) )

	local DoorLHandler = self:AddDoorHandler( "!door_l", Vector(19.3,49,54.45), Angle(0,180,0), Vector(-19,-1,-24), Vector(19,1,30), Vector(-19,-1,-24), Vector(19,1,30) )
	DoorLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorLHandler:LinkToSeat( DriverSeat )

	local DoorRHandler =  self:AddDoorHandler( "!door_r", Vector(19.3,-49,54.45), Angle(0,180,0), Vector(-19,-1,-24), Vector(19,1,30), Vector(-19,-1,-24), Vector(19,1,30) )
	DoorRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRHandler:LinkToSeat( NavigatorSeat )

	local DoorCHandler =  self:AddDoorHandler( "door", Vector(-107,0,56), Angle(0,180,0), Vector(-1,-38,-24), Vector(1,38,30), Vector(-1,-38,-24), Vector(1,38,30) )
	DoorCHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorCHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorCHandler:LinkToSeat( Seat6 )

	local HatchHandler =  self:AddDoorHandler( "hatch", Vector(-36.4,0,95), Angle(0,0,0), Vector(-25,-25,-3), Vector(25,25,3), Vector(-25,-25,-3), Vector(25,25,3) )
	HatchHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	self.TurrHatchHandler = HatchHandler

	self:AddArmor( Vector(70,0,46.6), Angle(0,0,0), Vector(-30,-49,-27), Vector(37,49,23), 1000, 1500 )
	self:AddArmor( Vector(0,0,46.6), Angle(0,0,0), Vector(-110,-49,-27), Vector(40,49,50), 500, 1000 )

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

	local ID4 = self:LookupAttachment( "muzzle_atgm" )
	local MuzzleATGM = self:GetAttachment( ID4 )
	self.SNDTurretATGM = self:AddSoundEmitter( self:WorldToLocal( MuzzleATGM.Pos ), "sw/rocket/wpn_atgm_ext_fire_01.wav", "sw/rocket/wpn_atgm_ext_fire_01.wav" )
	self.SNDTurretATGM:SetSoundLevel( 95 )
	self.SNDTurretATGM:SetParent( self, ID4 )

	local ID5 = self:LookupAttachment( "muzzle_rws" )
	local MuzzleRWS = self:GetAttachment( ID5 )
	self.SNDTurretRWS = self:AddSoundEmitter( self:WorldToLocal( MuzzleRWS.Pos ), "sw/vehicles/weapons/kord_loop.wav", "sw/vehicles/weapons/kord_interior_loop.wav" )
	self.SNDTurretRWS:SetSoundLevel( 95 )
	self.SNDTurretRWS:SetParent( self, ID5 )
	
	self.SNDTurretRWSStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleRWS.Pos ), "sw/vehicles/weapons/kord_lastshot.wav", "sw/vehicles/weapons/kord_interior_lastshot.wav" )
	self.SNDTurretRWSStop:SetSoundLevel( 95 )
	self.SNDTurretRWSStop:SetParent( self, ID5 )

	local IDS = self:LookupAttachment( "smoke_1" )
	local Smoke = self:GetAttachment( IDS )
	self.SNDSmoke = self:AddSoundEmitter( self:WorldToLocal( Smoke.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke:SetSoundLevel( 95 )
	self.SNDSmoke:SetParent( self, IDS )

	local WheelModel = "models/sw/ground/gaz2330/wheel.mdl"
	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 35,
			TorqueFactor = 0,
			BrakeFactor = 2,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(72.8,43,23.4),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),
			self:AddWheel( {
				pos = Vector(72.8,-43,23.4),
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
			TorqueFactor = 1.5,
			BrakeFactor = 2,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-71.2,43,23.4),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(-71.2,-43,23.4),
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
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",1)
			self:InitWeapons()
			local GunnerWeapon = self:GetGunnerSeat():lvsGetWeapon()
			if IsValid( GunnerWeapon ) then
				GunnerWeapon:LockAimVector()
			end
		end
	elseif loadout == 2 then
		self:SetBodygroup(1,1)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",2)
			self:InitWeapons()
			local GunnerWeapon = self:GetGunnerSeat():lvsGetWeapon()
			if IsValid( GunnerWeapon ) then
				GunnerWeapon:LockAimVector()
			end
		end
	elseif loadout == 3 then
		self:SetBodygroup(1,2)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",3)
			self:InitWeapons()
			local GunnerWeapon = self:GetGunnerSeat():lvsGetWeapon()
			if IsValid( GunnerWeapon ) then
				GunnerWeapon:LockAimVector()
			end
		end
	elseif loadout == 4 then
		self:SetBodygroup(1,3)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",4)
			self:InitWeapons()
			local GunnerWeapon = self:GetGunnerSeat():lvsGetWeapon()
			if IsValid( GunnerWeapon ) then
				GunnerWeapon:LockAimVector()
			end
		end
	elseif loadout == 5 then
		self:SetBodygroup(1,4)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",5)
			self:InitWeapons()
			local GunnerWeapon = self:GetGunnerSeat():lvsGetWeapon()
			if IsValid( GunnerWeapon ) then
				GunnerWeapon:LockAimVector()
			end
		end
	elseif loadout == 6 then
		self:SetBodygroup(1,5)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(3)
			self:SetNWInt("Loadout",6)
			self:InitWeapons()

			local GunnerWeapon = self:GetGunnerSeat():lvsGetWeapon()
			if IsValid( GunnerWeapon ) then
				GunnerWeapon:UnlockAimVector()
			end
		end
	end
	self.OldLoadout = loadout

	if IsValid(self) then
		if IsValid(self:GetGunnerSeat()) and IsValid(self:GetGunnerSeat():GetDriver()) then
			if IsValid(self.TurrHatchHandler) then
				local PoseValue = self:GetHatch() and 1 or 0
				local DoorHandler = self.TurrHatchHandler
				DoorHandler:SetPoseMin( PoseValue )
			end
		else
			if IsValid(self.TurrHatchHandler) then
				self:SetHatch(false)
				local PoseValue = self:GetHatch() and 1 or 0
				local DoorHandler = self.TurrHatchHandler
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