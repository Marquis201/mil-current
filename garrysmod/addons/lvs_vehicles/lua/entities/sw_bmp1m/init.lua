AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(57,27,25), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(-10,5,35), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local CommanderSeat = self:AddPassengerSeat( Vector(32,27,30), Angle(0,-90,0) )
	CommanderSeat.HidePlayer = true

	local Seat1 = self:AddPassengerSeat( Vector(-43,15,30), Angle(0,0,0) )
	Seat1.HidePlayer = true
	local Seat2 = self:AddPassengerSeat( Vector(-43,-15,30), Angle(0,180,0) )
	Seat2.HidePlayer = true
	local Seat3 = self:AddPassengerSeat( Vector(-75,15,30), Angle(0,0,0) )
	Seat3.HidePlayer = true
	local Seat4 = self:AddPassengerSeat( Vector(-75,-15,30), Angle(0,180,0) )
	Seat4.HidePlayer = true

	self:AddPassengerSeat( Vector(-80,30,55), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(-80,-30,55), Angle(0,180,0) )

	
	local HatchCHandler =  self:AddDoorHandler( "!hatch_driver", Vector(63,27,58), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3), Vector(-10,-10,-3), Vector(10,10,3) )
	HatchCHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchCHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchCHandler:LinkToSeat(DriverSeat)
	
	local HatchLHandler =  self:AddDoorHandler( "!hatch_commander", Vector(38,27,58), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3), Vector(-10,-10,-3), Vector(10,10,3) )
	HatchLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchLHandler:LinkToSeat(CommanderSeat)

	local HatchTHandler =  self:AddDoorHandler( "!hatch_gunner", Vector(-3,13,80), Angle(0,0,0), Vector(-5,-5,-3), Vector(5,5,3), Vector(-5,-5,-3), Vector(5,5,3) )
	HatchTHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchTHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchTHandler:LinkToSeat(GunnerSeat)

	local HatchFLHandler =  self:AddDoorHandler( "!hatch_pass_l1", Vector(-43,15,58), Angle(0,0,0), Vector(-15,-10,-3), Vector(15,10,3), Vector(-15,-10,-3), Vector(15,10,3) )
	HatchFLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchFLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchFLHandler:LinkToSeat(Seat1)

	local HatchFRHandler =  self:AddDoorHandler( "!hatch_pass_r1", Vector(-43,-15,58), Angle(0,0,0), Vector(-15,-10,-3), Vector(15,10,3), Vector(-15,-10,-3), Vector(15,10,3) )
	HatchFRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchFRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchFRHandler:LinkToSeat(Seat2)

	local HatchBLHandler =  self:AddDoorHandler( "!hatch_pass_l2", Vector(-110,15,55), Angle(0,0,0), Vector(-15,-15,-35), Vector(15,15,5), Vector(-15,-15,-35), Vector(15,15,5) )
	HatchBLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchBLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchBLHandler:LinkToSeat(Seat3)

	local HatchBRHandler =  self:AddDoorHandler( "!hatch_pass_r2", Vector(-110,-15,55), Angle(0,0,0), Vector(-15,-15,-35), Vector(15,15,5), Vector(-15,-15,-35), Vector(15,15,5) )
	HatchBRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchBRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchBRHandler:LinkToSeat(Seat4)

	self:AddEngine( Vector(60,-12,55), Angle(0,180,0) )
	self:AddFuelTank( Vector(-60,0,30), Angle(0,0,0), 600, LVS.FUELTYPE_DIESEL, Vector(25,8,25), Vector(-25,-8,-5) )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretHMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/bmp3/2a72_loop.wav", "sw/bmp3/2a72_interior_loop.wav" )
	self.SNDTurretHMG:SetSoundLevel( 95 )
	self.SNDTurretHMG:SetParent( self, ID )

	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/bmp1/pkt_loop.wav", "sw/bmp1/pkt_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )

	-- turret
	local TurretArmor = self:AddArmor( Vector(0,0,50), Angle(0,0,0), Vector(-28.25,-27,0), Vector(25,27,35), 500, 1800 )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	-- driver viewport weakspot
	self:AddDriverViewPort( Vector(63,27,58), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(-5,0,15), Vector(-5,0,50), Angle(0,0,0), Vector(-25,-27,0), Vector(30,27,25) )

	self:AddArmor( Vector(0,0,20), Angle(0,0,0), Vector(-105,-53,-9), Vector(140,53,40), 500, 1900 )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/2a72_loop.wav", "sw/vehicles/weapons/2a72_interior_loop.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )

	self.SNDTurretMGStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_interior_lastshot.wav" )
	self.SNDTurretMGStop:SetSoundLevel( 95 )
	self.SNDTurretMGStop:SetParent( self, IDC )

	
	local IDM = self:LookupAttachment( "muzzle_atgm_1" )
	local Mis1 = self:GetAttachment( IDM )
	self.SNDMis = self:AddSoundEmitter( self:WorldToLocal( Mis1.Pos ), "sw/rocket/tank_rocket_shot_1.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDMis:SetSoundLevel( 95 )
	self.SNDMis:SetParent( self, IDM)

	local ID = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( ID )
	self.SNDRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/autocannon_reload.wav" )
	self.SNDRld:SetSoundLevel( 95 )
	self.SNDRld:SetParent( self, ID )

	self.SNDBelt = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/belt_interior.wav" )
	self.SNDBelt:SetSoundLevel( 125 )
	self.SNDBelt:SetParent( self, ID )
end

function ENT:OnTick()

	local phys, waterlevel = self:GetPhysicsObject(), self:WaterLevel()
	local velocity = phys:GetVelocity():Length()
	
	if IsValid(phys) and waterlevel != 0 then
		phys:SetBuoyancyRatio(1)
		phys:ApplyTorqueCenter(self:GetRight()*velocity*150)
	else
		phys:SetBuoyancyRatio(0.0)
		phys:ApplyTorqueCenter(Vector(0,0,0))
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