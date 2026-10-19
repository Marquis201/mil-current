AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(35,7,75), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true
	
	local GunnerSeat = self:AddPassengerSeat( Vector(38,-32,80), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat(GunnerSeat)

	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local PassSeat1 = self:AddPassengerSeat( Vector(-35,-43,45), Angle(0,0,0) )
	local PassSeat2 = self:AddPassengerSeat( Vector(-35,43,45), Angle(0,180,0) )
	local PassSeat3 = self:AddPassengerSeat( Vector(-55,-43,45), Angle(0,0,0) )
	local PassSeat4 = self:AddPassengerSeat( Vector(-55,43,45), Angle(0,180,0) )
	local PassSeat5 = self:AddPassengerSeat( Vector(-78,-43,45), Angle(0,0,0) )
	local PassSeat6 = self:AddPassengerSeat( Vector(-78,43,45), Angle(0,180,0) )
	local PassSeat7 = self:AddPassengerSeat( Vector(-100,-43,45), Angle(0,0,0) )
	local PassSeat8 = self:AddPassengerSeat( Vector(-100,43,45), Angle(0,180,0) )

	self:AddEngine( Vector(140,0,75), Angle(0,180,0), Vector(-35,-55,-25),Vector(35,55,5) )
	self:AddFuelTank( Vector(105,0,75), Angle(0,0,0), 600, LVS.FUELTYPE_DIESEL, Vector(-35,-55,-25),Vector(0,55,5) )

	-- turret
	local TurretArmor = self:AddArmor( Vector(22,0,107), Angle(0,0,0), Vector(-130,-56,-0), Vector(0,56,38), 500, 3500 )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	self:AddArmor( Vector(205,0,20), Angle(0,0,0), Vector(-346,-97,-0), Vector(0,97,92), 500, 3500 )

	local HatchDHandler = self:AddDoorHandler( "!hatch_driver", Vector(42.55,7.7,106), Angle(0,0,0), Vector(-15,-15,-5), Vector(15,15,5), Vector(-15,-15,-5), Vector(15,15,5) )
	HatchDHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchDHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchDHandler:LinkToSeat(DriverSeat)

	local HatchGHandler = self:AddDoorHandler( "!hatch_gunner", Vector(42.55,-31.6,106), Angle(0,0,0), Vector(-15,-15,-5), Vector(15,15,5), Vector(-15,-15,-5), Vector(15,15,5) )
	HatchGHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchGHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchGHandler:LinkToSeat(GunnerSeat)

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/2a42_loop.wav", "sw/vehicles/weapons/2a42_interior_loop.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self.SNDTurretStop = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/2a42_lastshot.wav", "sw/vehicles/weapons/2a42_interior_lastshot.wav" )
	self.SNDTurretStop:SetSoundLevel( 95 )
	self.SNDTurretStop:SetParent( self, ID )

	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )

	self.SNDTurretMGStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_interior_lastshot.wav" )
	self.SNDTurretMGStop:SetSoundLevel( 95 )
	self.SNDTurretMGStop:SetParent( self, IDC )

	local ID = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( ID )
	self.SNDRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/autocannon_reload.wav" )
	self.SNDRld:SetSoundLevel( 95 )
	self.SNDRld:SetParent( self, ID )

	self.SNDBelt = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/belt_interior.wav" )
	self.SNDBelt:SetSoundLevel( 125 )
	self.SNDBelt:SetParent( self, ID )
	
	local IDM = self:LookupAttachment( "missile_1" )
	local Mis1 = self:GetAttachment( IDM )
	self.SNDMis = self:AddSoundEmitter( self:WorldToLocal( Mis1.Pos ), "sw/rocket/wpn_atgm_ext_fire_02.wav", "sw/rocket/wpn_atgm_int_fire_02.wav" )
	self.SNDMis:SetSoundLevel( 95 )
	self.SNDMis:SetParent( self, IDM )

	local IDS1 = self:LookupAttachment( "smoke_1" )
	local Smoke1 = self:GetAttachment( IDS1 )
	self.SNDSmoke1 = self:AddSoundEmitter( self:WorldToLocal( Smoke1.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke1:SetSoundLevel( 95 )
	self.SNDSmoke1:SetParent( self, IDS1 )
end

function ENT:OnTick()
	local phys, waterlevel = self:GetPhysicsObject(), self:WaterLevel()
	local velocity = phys:GetVelocity():Length()
	
	if IsValid(phys) and waterlevel != 0 then
		self:WheelsOnGround(true)
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