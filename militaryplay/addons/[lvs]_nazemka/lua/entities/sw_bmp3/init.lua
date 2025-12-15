AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	self.ATGMs = 4
	local DriverSeat = self:AddDriverSeat( Vector(65,0,35), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(0,17,65), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local CommanderSeat = self:AddPassengerSeat( Vector(-3,-19,65), Angle(0,-90,0) )
	CommanderSeat.HidePlayer = true

	local NavigatorSeat = self:AddPassengerSeat( Vector(60,30,45), Angle(0,-90,0) )
	NavigatorSeat.HidePlayer = true
	self:SetNavigatorSeat( NavigatorSeat )

	local EngineerSeat = self:AddPassengerSeat( Vector(60,-30,45), Angle(0,-90,0) )
	EngineerSeat.HidePlayer = true
	self:SetEngineerSeat( EngineerSeat )

	local Seat1 = self:AddPassengerSeat( Vector(-60,0,45), Angle(0,-90,0) )
	Seat1.HidePlayer = true
	local Seat2 = self:AddPassengerSeat( Vector(-60,15,45), Angle(0,-90,0) )
	Seat2.HidePlayer = true
	local Seat3 = self:AddPassengerSeat( Vector(-60,-15,45), Angle(0,-90,0) )
	Seat3.HidePlayer = true
	local Seat4 = self:AddPassengerSeat( Vector(-60,30,45), Angle(0,-90,0) )
	Seat4.HidePlayer = true
	local Seat5 = self:AddPassengerSeat( Vector(-60,-30,45), Angle(0,-90,0) )
	Seat5.HidePlayer = true


	local HatchTLHandler =  self:AddDoorHandler( "!hatch_gunner", Vector(0,17,95), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3), Vector(-10,-10,-3), Vector(10,10,3) )
	HatchTLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchTLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchTLHandler:LinkToSeat(GunnerSeat)

	local HatchTRHandler =  self:AddDoorHandler( "!hatch_commander", Vector(0,-17,95), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3), Vector(-10,-10,-3), Vector(10,10,3) )
	HatchTRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchTRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchTRHandler:LinkToSeat(CommanderSeat)
	
	local HatchCHandler =  self:AddDoorHandler( "!hatch_driver", Vector(70,0,73), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3), Vector(-10,-10,-3), Vector(10,10,3) )
	HatchCHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchCHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchCHandler:LinkToSeat(DriverSeat)
	
	local HatchLHandler =  self:AddDoorHandler( "!hatch_navigator", Vector(65,30,73), Angle(0,13,0), Vector(-10,-15,-3), Vector(10,15,3), Vector(-10,-15,-3), Vector(10,15,3) )
	HatchLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchLHandler:LinkToSeat(NavigatorSeat)

	local HatchRHandler =  self:AddDoorHandler( "!hatch_engineer", Vector(65,-30,73), Angle(0,-13,0), Vector(-10,-15,-3), Vector(10,15,3), Vector(-10,-15,-3), Vector(10,15,3) )
	HatchRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchRHandler:LinkToSeat(EngineerSeat)

	local HatchBLHandler =  self:AddDoorHandler( "door_l", Vector(-80,15,65), Angle(0,0,0), Vector(-65,-15,-35), Vector(15,15,10), Vector(-65,-15,-35), Vector(15,15,10) )
	HatchBLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchBLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchBLHandler:LinkToSeat(Seat4)

	local HatchBRHandler =  self:AddDoorHandler( "door_r", Vector(-80,-15,65), Angle(0,0,0), Vector(-65,-15,-35), Vector(15,15,10), Vector(-65,-15,-35), Vector(15,15,10) )
	HatchBRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchBRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchBRHandler:LinkToSeat(Seat5)

	self:AddEngine( Vector(-85,0,40), Angle(0,180,0) )
	self:AddFuelTank( Vector(80,0,30), Angle(0,0,0), 600, LVS.FUELTYPE_DIESEL, Vector(25,45,25), Vector(-5,-45,-5) )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/bmp3/fire.wav", "sw/bmp3/fire_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self.SNDMis = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/rocket/tank_rocket_shot_1.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDMis:SetSoundLevel( 95 )
	self.SNDMis:SetParent( self, ID )

	local ID2 = self:LookupAttachment( "muzzle_2a72" )
	local Muzzle2 = self:GetAttachment( ID2 )
	self.SNDTurretHMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle2.Pos ), "sw/vehicles/weapons/2a72_loop.wav", "sw/vehicles/weapons/2a72_interior_loop.wav" )
	self.SNDTurretHMG:SetSoundLevel( 95 )
	self.SNDTurretHMG:SetParent( self, ID2 )

	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )
	
	self.SNDTurretMGStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_interior_lastshot.wav" )
	self.SNDTurretMGStop:SetSoundLevel( 95 )
	self.SNDTurretMGStop:SetParent( self, IDC )

	local IDR = self:LookupAttachment( "mg_r" )
	local MuzzleR = self:GetAttachment( IDR )
	self.SNDTurretMGR = self:AddSoundEmitter( self:WorldToLocal( MuzzleR.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_interior_loop.wav" )
	self.SNDTurretMGR:SetSoundLevel( 95 )
	self.SNDTurretMGR:SetParent( self, IDR )
	
	self.SNDTurretMGRStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleR.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_interior_lastshot.wav" )
	self.SNDTurretMGRStop:SetSoundLevel( 95 )
	self.SNDTurretMGRStop:SetParent( self, IDR )

	local IDL = self:LookupAttachment( "mg_l" )
	local MuzzleL = self:GetAttachment( IDL )
	self.SNDTurretMGL = self:AddSoundEmitter( self:WorldToLocal( MuzzleL.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_interior_loop.wav" )
	self.SNDTurretMGL:SetSoundLevel( 95 )
	self.SNDTurretMGL:SetParent( self, IDL )

	self.SNDTurretMGLStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleL.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_interior_lastshot.wav" )
	self.SNDTurretMGLStop:SetSoundLevel( 95 )
	self.SNDTurretMGLStop:SetParent( self, IDL )

	local ID = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( ID )
	self.SNDRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/bmp3/reload.wav" )
	self.SNDRld:SetSoundLevel( 95 )
	self.SNDRld:SetParent( self, ID )

	self.SNDRld2A72 = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/autocannon_reload.wav" )
	self.SNDRld2A72:SetSoundLevel( 95 )
	self.SNDRld2A72:SetParent( self, ID )

	self.SNDBelt = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/belt_interior.wav" )
	self.SNDBelt:SetSoundLevel( 125 )
	self.SNDBelt:SetParent( self, ID )
	
	local IDS1 = self:LookupAttachment( "smoke_1" )
	local Smoke1 = self:GetAttachment( IDS1 )
	self.SNDSmoke1 = self:AddSoundEmitter( self:WorldToLocal( Smoke1.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke1:SetSoundLevel( 95 )
	self.SNDSmoke1:SetParent( self, IDS1 )

	-- turret
	local TurretArmor = self:AddArmor( Vector(25,0,70), Angle(0,0,0), Vector(-52,-45,0), Vector(32,45,25), 500, 5000 )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	-- driver viewport weakspot
	self:AddDriverViewPort( Vector(63,27,58), Angle(0,0,0), Vector(-10,-10,-3), Vector(10,10,3) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(15,0,15), Vector(15,0,65), Angle(0,0,0), Vector(-25,-25,0), Vector(25,25,25) )

	self:AddArmor( Vector(0,0,30), Angle(0,0,0), Vector(-140,-62,-13), Vector(140,62,45), 500, 6000 )
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