AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(46,23,24.5), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(-150,0,30)

	local GunnerSeat = self:AddPassengerSeat( Vector(-27,8,60), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	GunnerSeat.ExitPos = Vector(-150,25,30)
	self:SetGunnerSeat(GunnerSeat)

	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local CommanderSeat = self:AddPassengerSeat( Vector(-27,-22,60), Angle(0,-90,0) )
	CommanderSeat.HidePlayer = true
	CommanderSeat.ExitPos = Vector(-150,-25,30)
	self:SetCommanderSeat(CommanderSeat)

	self:AddPassengerSeat( Vector(30,23,30), Angle(0,90,0) )

	local Pass1 = self:AddPassengerSeat( Vector(-45,23,32), Angle(0,180,0) )
	Pass1.ExitPos = Vector(-150,25,30)
	local Pass2 = self:AddPassengerSeat( Vector(-45,-23,32), Angle(0,0,0) )
	Pass2.ExitPos = Vector(-150,-25,30)

	local Pass3 = self:AddPassengerSeat( Vector(-60,23,32), Angle(0,180,0) )
	Pass3.ExitPos = Vector(-150,25,30)
	local Pass4 = self:AddPassengerSeat( Vector(-60,-23,32), Angle(0,0,0) )
	Pass4.ExitPos = Vector(-150,-25,30)

	local Pass5 = self:AddPassengerSeat( Vector(-75,23,32), Angle(0,180,0) )
	Pass5.ExitPos = Vector(-150,25,30)
	local Pass6 = self:AddPassengerSeat( Vector(-75,-23,32), Angle(0,0,0) )
	Pass6.ExitPos = Vector(-150,-25,30)

	local HatchDHandler =  self:AddDoorHandler( "!hatch_driver", Vector(55,23,75), Angle(0,0,0), Vector(-17,-17,-10), Vector(17,17,3), Vector(-17,-17,-10), Vector(17,17,3) )
	HatchDHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchDHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchDHandler:LinkToSeat(DriverSeat)

	local HatchGHandler =  self:AddDoorHandler( "!hatch_gunner", Vector(-19,10,99), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3), Vector(-10,-10,-3), Vector(10,10,3) )
	HatchGHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchGHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchGHandler:SetParent( self, self:LookupAttachment( "turret" ) )
	HatchGHandler:LinkToSeat(GunnerSeat)

	local HatchCHandler =  self:AddDoorHandler( "!hatch_commander", Vector(-19,-18.6,100), Angle(0,0,0), Vector(-13,-13,-5), Vector(13,13,5), Vector(-13,-13,-5), Vector(13,13,5) )
	HatchCHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchCHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchCHandler:SetParent( self, self:LookupAttachment( "turret" ) )
	HatchCHandler:LinkToSeat(CommanderSeat)

	local HatchPHandler =  self:AddDoorHandler( "!hatch_pass", Vector(-75,0,70), Angle(0,0,0), Vector(-20,-25,-5), Vector(15,25,10), Vector(-20,-25,-5), Vector(15,25,10) )
	HatchPHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchPHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchPHandler:LinkToSeat(Pass5)

	local DoorHandler =  self:AddDoorHandler( "!door", Vector(-100,11.7,45), Angle(0,0,0), Vector(-5,-15,-20), Vector(5,15,20), Vector(-5,-15,-20), Vector(5,15,20) )
	DoorHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorHandler:LinkToSeat(Pass6)

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretHMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/bushmaster_fire.wav", "sw/vehicles/weapons/bushmaster_fire_interior.wav" )
	self.SNDTurretHMG:SetSoundLevel( 95 )
	self.SNDTurretHMG:SetParent( self, ID )

	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/m240_loop.wav", "sw/vehicles/weapons/m240_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )

	self.SNDTurretMGStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/m240_lastshot.wav", "sw/vehicles/weapons/m240_interior_lastshot.wav" )
	self.SNDTurretMGStop:SetSoundLevel( 95 )
	self.SNDTurretMGStop:SetParent( self, IDC )

	local ID = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( ID )
	self.SNDRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/autocannon_reload.wav" )
	self.SNDRld:SetSoundLevel( 95 )
	self.SNDRld:SetParent( self, ID )

	local IDS1 = self:LookupAttachment( "smoke_l" )
	local Smoke1 = self:GetAttachment( IDS1 )
	self.SNDSmoke1 = self:AddSoundEmitter( self:WorldToLocal( Smoke1.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke1:SetSoundLevel( 95 )
	self.SNDSmoke1:SetParent( self, IDS1 )

	local IDM = self:LookupAttachment( "missile_1" )
	local Missile = self:GetAttachment( IDM )
	self.SNDMissile = self:AddSoundEmitter( self:WorldToLocal( Missile.Pos ), "sw/rocket/tank_rocket_shot_1.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDMissile:SetSoundLevel( 95 )
	self.SNDMissile:SetParent( self, IDM )

	self:AddEngine( Vector(40,-23,54), Angle(0,180,0), Vector(-25,-20,-20), Vector(25,20,15) )
	self:AddFuelTank( Vector(-8,-6.7,20), Angle(0,0,0), 600, LVS.FUELTYPE_DIESEL, Vector(-15,-15,-0),Vector(15,15,15) )

	-- turret
	local TurretArmor = self:AddArmor( Vector(-8,-6.7,75), Angle(0,0,0), Vector(-40,-48,0), Vector(45,35,25), 125, 2500 )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	-- driver viewport weakspot
	self:AddDriverViewPort( Vector(48.8,24,75), Angle(0,0,0), Vector(-15,-15,-2), Vector(15,15,2) )

	-- ammo rack weakspot
	self.M242_Rack = self:AddAmmoRack( Vector(Vector(-8,-6.7,35)), Vector(-8,-6.7,75), Angle(0,0,0), Vector(-15,-15,-0),Vector(15,15,15) )
	self.BGM71_Rack = self:AddAmmoRack( Vector(Vector(-60,-35,55)), Vector(-8,-6.7,75), Angle(0,0,0), Vector(-27,-8,-16),Vector(20,8,8) )
	self.M242_Rack:SetMaxHP(75)
	self.BGM71_Rack:SetMaxHP(50)

	self:AddArmor( Vector(0,0,15), Angle(0,0,0), Vector(-113,-58,-0), Vector(120,58,60), 125, 3000 )

	self:AddTrailerHitch( Vector(-110,0,25.25), LVS.HITCHTYPE_MALE )
end

function ENT:OnTick()
	if IsValid(self:GetNWEntity("Missile")) then
		if not IsValid(self:GetNWEntity("Wire")) then
			self:GetNWEntity("Missile"):SetOwner(nil)
			self:GetNWEntity("Missile").GuidanceActive = false
			self:SetNWEntity("Missile",nil)			
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