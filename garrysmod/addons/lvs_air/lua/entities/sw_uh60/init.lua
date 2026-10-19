AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat(Vector(120,25.3,43),Angle(0,-90,0))
	local CopilotSeat = self:AddPassengerSeat(Vector(120,-25.3,43),Angle(0,-90,0))

	local GunnerRSeat = self:AddPassengerSeat(Vector(67,-20,40),Angle(0,180,0))
	self:SetGunnerRSeat(GunnerRSeat)
	local GunnerLSeat = self:AddPassengerSeat(Vector(67,20,40),Angle(0,0,0))
	self:SetGunnerLSeat(GunnerLSeat)

	self:AddPassengerSeat(Vector(19,-30,40),Angle(0,-90,0))
	self:AddPassengerSeat(Vector(19,-10,40),Angle(0,-90,0))
	self:AddPassengerSeat(Vector(19,10,40),Angle(0,-90,0))
	self:AddPassengerSeat(Vector(19,30,40),Angle(0,-90,0))
	
	self:AddPassengerSeat(Vector(-2,-30,40),Angle(0,90,0))
	self:AddPassengerSeat(Vector(-2,-10,40),Angle(0,90,0))
	self:AddPassengerSeat(Vector(-2,10,40),Angle(0,90,0))
	self:AddPassengerSeat(Vector(-2,30,40),Angle(0,90,0))

	self:AddPassengerSeat(Vector(-47,-30,40),Angle(0,-90,0))
	self:AddPassengerSeat(Vector(-47,-10,40),Angle(0,-90,0))
	self:AddPassengerSeat(Vector(-47,10,40),Angle(0,-90,0))
	self:AddPassengerSeat(Vector(-47,30,40),Angle(0,-90,0))

	local GunnerRWeapon = GunnerRSeat:lvsGetWeapon()
	if IsValid( GunnerRWeapon ) then
		GunnerRWeapon:UnlockAimVector()
	end
	local GunnerLWeapon = GunnerLSeat:lvsGetWeapon()
	if IsValid( GunnerLWeapon ) then
		GunnerLWeapon:UnlockAimVector()
	end

	self:AddEngineSound( Vector(15,0,135) )
	self:AddFuelTank( Vector(-60,0,55), Angle(1.5,0,0), 350, Vector(-15,-35,-25),Vector(15,35,15) )

	local DoorLHandler =  self:AddDoorHandler( "!door_l", Vector(120,45,40), Angle(1.5,0,0), Vector(-20,-5,-5), Vector(20,5,40),  Vector(-20,-5,-5), Vector(20,5,40) )
	DoorLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorLHandler:LinkToSeat(DriverSeat)

	local DoorRHandler =  self:AddDoorHandler( "!door_r", Vector(120,-45,40), Angle(1.5,0,0), Vector(-20,-5,-5), Vector(20,5,40),  Vector(-20,-5,-5), Vector(20,5,40) )
	DoorRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRHandler:LinkToSeat(CopilotSeat)

	
	local IDR = self:LookupAttachment( "muzzle_r" )
	local MuzzleR = self:GetAttachment( IDR )
	self.SNDTurretMGR = self:AddSoundEmitter( self:WorldToLocal( MuzzleR.Pos ), "sw/vehicles/weapons/m134_loop.wav", "sw/vehicles/weapons/m134_interior_loop.wav" )
	self.SNDTurretMGR:SetSoundLevel( 95 )
	self.SNDTurretMGR:SetParent( self, IDR )
	
	self.SNDTurretMGRspin = self:AddSoundEmitter( self:WorldToLocal( MuzzleR.Pos ), "sw/vehicles/weapons/minigun_rotor_loop.wav", "sw/vehicles/weapons/minigun_rotor_loop.wav" )
	self.SNDTurretMGRspin:SetSoundLevel( 95 )
	self.SNDTurretMGRspin:SetParent( self, IDR )

	self.SNDTurretMGRstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleR.Pos ), "sw/vehicles/weapons/m134_lastshot.wav", "sw/vehicles/weapons/m134_interior_lastshot.wav" )
	self.SNDTurretMGRstop:SetSoundLevel( 95 )
	self.SNDTurretMGRstop:SetParent( self, IDR )

	local IDL = self:LookupAttachment( "muzzle_l" )
	local MuzzleL = self:GetAttachment( IDL )
	self.SNDTurretMGL = self:AddSoundEmitter( self:WorldToLocal( MuzzleL.Pos ), "sw/vehicles/weapons/m134_loop.wav", "sw/vehicles/weapons/m134_interior_loop.wav" )
	self.SNDTurretMGL:SetSoundLevel( 95 )
	self.SNDTurretMGL:SetParent( self, IDL )
	
	self.SNDTurretMGLspin = self:AddSoundEmitter( self:WorldToLocal( MuzzleL.Pos ), "sw/vehicles/weapons/minigun_rotor_loop.wav", "sw/vehicles/weapons/minigun_rotor_loop.wav" )
	self.SNDTurretMGLspin:SetSoundLevel( 95 )
	self.SNDTurretMGLspin:SetParent( self, IDL )

	self.SNDTurretMGLstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleL.Pos ), "sw/vehicles/weapons/m134_lastshot.wav", "sw/vehicles/weapons/m134_interior_lastshot.wav" )
	self.SNDTurretMGLstop:SetSoundLevel( 95 )
	self.SNDTurretMGLstop:SetParent( self, IDL )

	self.Rotor = self:AddRotor( Vector(14.9,0,138.75), Angle(3,0,0), 315, -4000 )
	self.Rotor:SetRotorEffects( true )
	self.Rotor:SetHP( 15 )
	function self.Rotor:OnDestroyed( base )
		base:SetBodygroup( 1, 2 )
		base:DestroyEngine()
		self:EmitSound( "physics/metal/metal_box_break2.wav" )
	end

	self.TailRotor = self:AddRotor( Vector(-384,-12.3,153.55), Angle(0,0,75), 67, -6000 )
	self.TailRotor:SetHP( 15 )
	function self.TailRotor:OnDestroyed( base )
		base:SetBodygroup( 2, 2 ) 
		base:DestroySteering( 2.5 )
		self:EmitSound( "physics/metal/metal_box_break2.wav" )
	end
end

function ENT:SetRotor( PhysRot )
	self:SetBodygroup( 1, PhysRot and 0 or 1 ) 
end
function ENT:SetTailRotor( PhysRot )
	self:SetBodygroup( 2, PhysRot and 0 or 1 ) 
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
	if loadout == 0 then
		self:SetBodygroup(13,0)
		if not (self.OldLoadout == loadout) then
			self:SetMGR(false)
			self:SetMGL(false)
			self:RemoveWeapon(1)
			self:RemoveWeapon(2)
			self:RemoveWeapon(3)
			self:RemoveWeapon(4)
			self:SetNWInt("Loadout",loadout)
			self:InitWeapons()
		end
	else
		self:SetMGR(true)
		self:SetMGL(true)
		self:SetBodygroup(13,1)
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(2)
			self:RemoveWeapon(3)
			self:RemoveWeapon(4)
			self:SetNWInt("Loadout",loadout)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout

	local PhysRot = self:GetThrottle() < 0.85

	if not self:IsSteeringDestroyed() then
		self:SetTailRotor( PhysRot )
	else
		self:SetBodygroup(2,2)
	end

	if not self:IsEngineDestroyed() then
		self:SetRotor( PhysRot )
	else
		self:SetBodygroup(1,2)
	end

	if IsValid(self) then
		if self:GetEngineActive() then
			for k, v in pairs(ents.FindInSphere(self:GetPos(),3500)) do
				if v.GuidanceActive and v.Fired and v.Launcher != self and v != self:GetNWEntity("Missile") then
					if IsValid(v) then
						self.AlarmSND = CreateSound(self, "sw/misc/lock.wav")
						self.AlarmSND:PlayEx( 1, 120 )
						self.AlarmSND:ChangeVolume( 1, 1 )
						self.AlarmSND:SetSoundLevel( 90 )
					else
						if self.AlarmSND then
							self.AlarmSND:Stop()
							self.AlarmSND = nil
						end
					end				
				end
			end
		end
	end
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "sw/uh60/engine_start.wav" )
		self:SetBodygroup( 14, 1 ) 
	else
		self:EmitSound( "sw/uh60/engine_stop.wav" )
		self:SetBodygroup( 14, 0 ) 
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

--Fuel
function ENT:OnMaintenance()
	local FuelTank = self:GetFuelTank()

	if IsValid( FuelTank ) then
		FuelTank:ExtinguishAndRepair()

		if FuelTank:GetFuel() ~= 1 then
			FuelTank:SetFuel( 1 )

			self:OnRefueled()
		end
	end
end
function ENT:AddFuelTank( pos, ang, tanksize, mins, maxs )
	if IsValid( self:GetFuelTank() ) then return end

	local FuelTank = ents.Create( "sw_aircraft_fueltank" )

	if not IsValid( FuelTank ) then
		self:Remove()

		print("LVS: Failed to create fueltank entity. Vehicle terminated.")

		return
	end

	FuelTank:SetPos( self:LocalToWorld( pos ) )
	FuelTank:SetAngles( self:GetAngles() )
	FuelTank:Spawn()
	FuelTank:Activate()
	FuelTank:SetParent( self )
	FuelTank:SetBase( self )
	FuelTank:SetSize( tanksize or 600 )
	FuelTank:SetFuelType( 4 )
	FuelTank:SetMaxHP( self.MaxHealthFuelTank )
	FuelTank:SetHP( self.MaxHealthFuelTank )

	self:SetFuelTank( FuelTank )

	self:DeleteOnRemove( FuelTank )

	self:TransferCPPI( FuelTank )

	mins = mins or Vector(-15,-15,-5)
	maxs = maxs or Vector(15,15,5)

	debugoverlay.BoxAngles( self:LocalToWorld( pos ), mins, maxs, self:LocalToWorldAngles( ang ), 15, Color( 255, 255, 0, 255 ) )

	self:AddDS( {
		pos = pos,
		ang = ang,
		mins = mins,
		maxs =  maxs,
		Callback = function( tbl, ent, dmginfo )
			if not IsValid( FuelTank ) then return end

			FuelTank:TakeTransmittedDamage( dmginfo )

			if not FuelTank:GetDestroyed() then
				dmginfo:ScaleDamage( 0.25 )
			end
		end
	} )

	return FuelTank
end
function ENT:OnRefueled()
	local FuelTank = self:GetFuelTank()

	if not IsValid( FuelTank ) then return end

	FuelTank:EmitSound( "vehicles/jetski/jetski_no_gas_start.wav" )
end
function ENT:IsEngineStartAllowed()
	if hook.Run( "LVS.IsEngineStartAllowed", self ) == false then return false end

	if self:WaterLevel() > self.WaterLevelPreventStart then return false end

	local FuelTank = self:GetFuelTank()

	if IsValid( FuelTank ) and FuelTank:GetFuel() <= 0 then return false end

	return true
end