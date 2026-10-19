AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	-- engine
	self:AddEngine( Vector(-85,0,55), Angle(0,0,0) )
	
	-- fuel tank
	self:AddFuelTank( Vector(-65,0,55), Angle(0,0,0), 800, LVS.FUELTYPE_DIESEL, Vector(-11,-37,8),Vector(11,37,-8) )

	-- driver viewport weakstop
	self:AddDriverViewPort( Vector(80.4,0,57), Angle(0,0,0), Vector(-4,-4,-4), Vector(4,4,4) )

	-- ammo rack weakspot
	local ID = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( ID )
	self:AddAmmoRack( self:WorldToLocal(Turret.Pos-Turret.Ang:Up()*25), self:WorldToLocal(Turret.Pos), Angle(0,0,0), Vector(-30,-30,-10), Vector(30,30,10) )
	
	local DriverSeat = self:AddDriverSeat( Vector(60,0,26), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(-35.55,19.25,55), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat(GunnerSeat)

	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local CommanderSeat = self:AddPassengerSeat( Vector(-22,-24.2,55), Angle(0,-90,0) )
	CommanderSeat.HidePlayer = true
	self:SetCommanderSeat(CommanderSeat)

	local HatchDHandler = self:AddDoorHandler( "!hatch_driver", Vector(65.85,0,60), Angle(0,0,0), Vector(-8,-15,-5), Vector(8,15,5), Vector(-8,-15,-5), Vector(8,15,5) )
	HatchDHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchDHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchDHandler:LinkToSeat(DriverSeat)

	local HatchGHandler = self:AddDoorHandler( "!hatch_gunner", Vector(-4.25,16.75,75), Angle(0,0,0), Vector(-12,-12,-5), Vector(12,12,5), Vector(-12,-12,-5), Vector(12,12,5) )
	HatchGHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchGHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchGHandler:LinkToSeat(GunnerSeat)
	HatchGHandler:SetParent( self, self:LookupAttachment( "turret" ) )

	local HatchCHandler = self:AddDoorHandler( "!hatch_commander", Vector(6,-17.4,75), Angle(0,0,0), Vector(-12,-12,-5), Vector(12,12,5), Vector(-12,-12,-5), Vector(12,12,5) )
	HatchCHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchCHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchCHandler:LinkToSeat(CommanderSeat)
	HatchCHandler:SetParent( self, self:LookupAttachment( "turret" ) )
	self.TurrHatchHandler = HatchCHandler

	self:AddArmor( Vector(109.4,0,48.75), Angle(-67,0,0), Vector(-8,-36,-25), Vector(2,36,33), 2500, 71000 )
	self:AddArmor( Vector(122.3,0,28.25), Angle(67,0,0), Vector(-10,-36,-25), Vector(2,36,10), 2500, 12000 )
	self:AddArmor( Vector(0,0,40), Angle(0,0,0), Vector(-85,-40,-25), Vector(77,40,23), 2500, 14000 )
	self:AddArmor( Vector(-85,0,40), Angle(0,0,0), Vector(-45,-40,-25), Vector(0,40,23), 2500, 1000 )

	local TurretArmor = self:AddArmor( Vector(0,0,59), Angle(0,0,0), Vector(-50,-61,0), Vector(76,61,15), 5000, 116000 )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	local TurretTopArmor = self:AddArmor( Vector(0,0,73), Angle(0,0,0), Vector(-50,-61,0), Vector(76,61,5), 1000, 1000 )
	TurretTopArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretTopArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretTopArmor:SetLabel( "Turret" )
	self.TurretArmor = TurretArmor
	
	local ID1= self:LookupAttachment( "muzzle_1" )
	local Muzzle1 = self:GetAttachment( ID1 )
	local ID2 = self:LookupAttachment( "muzzle_2" )
	local Muzzle2 = self:GetAttachment( ID2 )
	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	local IDM = self:LookupAttachment( "missile_1" )
	local Missile = self:GetAttachment( IDM )
	local IDS1 = self:LookupAttachment( "smoke_1" )
	local Smoke1 = self:GetAttachment( IDS1 )
	local IDS2 = self:LookupAttachment( "smoke_2" )
	local Smoke2 = self:GetAttachment( IDS2 )

	self.SNDRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/autocannon_reload.wav" )
	self.SNDRld:SetSoundLevel( 95 )
	self.SNDRld:SetParent( self, ID )

	self.SNDBelt = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/belt_interior.wav" )
	self.SNDBelt:SetSoundLevel( 125 )
	self.SNDBelt:SetParent( self, ID )

	self.SNDTurret1 = self:AddSoundEmitter( self:WorldToLocal( Muzzle1.Pos ), "sw/vehicles/weapons/2a42_loop.wav", "sw/vehicles/weapons/2a42_interior_loop.wav" )
	self.SNDTurret1:SetSoundLevel( 95 )
	self.SNDTurret1:SetParent( self, ID1 )

	self.SNDTurret2 = self:AddSoundEmitter( self:WorldToLocal( Muzzle2.Pos ), "sw/vehicles/weapons/2a42_loop.wav", "sw/vehicles/weapons/2a42_interior_loop.wav" )
	self.SNDTurret2:SetSoundLevel( 95 )
	self.SNDTurret2:SetParent( self, ID2 )

	self.SNDTurret1stop = self:AddSoundEmitter( self:WorldToLocal( Muzzle1.Pos ), "sw/vehicles/weapons/2a42_lastshot.wav", "sw/vehicles/weapons/2a42_interior_lastshot.wav" )
	self.SNDTurret1stop:SetSoundLevel( 95 )
	self.SNDTurret1stop:SetParent( self, ID1 )

	self.SNDTurret2stop = self:AddSoundEmitter( self:WorldToLocal( Muzzle2.Pos ), "sw/vehicles/weapons/2a42_lastshot.wav", "sw/vehicles/weapons/2a42_interior_lastshot.wav" )
	self.SNDTurret2stop:SetSoundLevel( 95 )
	self.SNDTurret2stop:SetParent( self, ID2 )

	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )

	self.SNDTurretMGstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_interior_lastshot.wav" )
	self.SNDTurretMGstop:SetSoundLevel( 95 )
	self.SNDTurretMGstop:SetParent( self, IDC )

	self.SNDMissile = self:AddSoundEmitter( self:WorldToLocal( Missile.Pos ), "sw/rocket/tank_rocket_shot_1.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDMissile:SetSoundLevel( 95 )
	self.SNDMissile:SetParent( self, IDM )

	self.SNDSmoke1 = self:AddSoundEmitter( self:WorldToLocal( Smoke1.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke1:SetSoundLevel( 95 )
	self.SNDSmoke1:SetParent( self, IDS1 )

	self.SNDSmoke2 = self:AddSoundEmitter( self:WorldToLocal( Smoke2.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke2:SetSoundLevel( 95 )
	self.SNDSmoke2:SetParent( self, IDS2 )

	self.SNDEngineStart = self:AddSoundEmitter( self:GetPos(), "sw/bmpt72/engine_start.wav", "sw/bmpt72/engine_start_int.wav" )
	self.SNDEngineStart:SetSoundLevel( 95 )
	self.SNDEngineStart:SetParent( self )
	
	self.SNDEngineStop = self:AddSoundEmitter( self:GetPos(), "sw/bmpt72/engine_stop.wav", "sw/bmpt72/engine_stop_int.wav" )
	self.SNDEngineStop:SetSoundLevel( 95 )
	self.SNDEngineStop:SetParent( self )
end

function ENT:OnTick()
	if IsValid(self) then
		if IsValid(self:GetCommanderSeat()) and IsValid(self:GetCommanderSeat():GetDriver()) then
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

function ENT:OnEngineActiveChanged( Active )
	if Active then
		if not IsValid( self ) or not IsValid( self.SNDEngineStart ) then return end
		self.SNDEngineStart:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	else
		if not IsValid( self ) or not IsValid( self.SNDEngineStop ) then return end
		self.SNDEngineStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
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