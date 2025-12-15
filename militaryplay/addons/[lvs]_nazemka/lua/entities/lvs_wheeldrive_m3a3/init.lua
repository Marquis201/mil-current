AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/m3a3/m242_out.wav", "lvs/vehicles/m3a3/m242_in.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_mg" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/m3a3/m240.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true


	local PassengerSeat1 = self:AddPassengerSeat( Vector(-50,15,33), Angle(0,180,10) )
	local PassengerSeat1 = self:AddPassengerSeat( Vector(-70,15,33), Angle(0,180,10) )
	local PassengerSeat1 = self:AddPassengerSeat( Vector(-90,15,33), Angle(0,180,10) )

	local DoorHandler = self:AddDoorHandler( "tow", Vector(0,0,0), Angle(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0) )
	self.Rockets = DoorHandler

	local DoorHandler = self:AddDoorHandler( "hatch_engine", Vector(102.4,-12.91,64.22), Angle(0,180,0), Vector(-15,-15,-15), Vector(15,15,15), Vector(-15,-15,-15), Vector(15,15,15) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	local Engine = self:AddEngine( Vector(94.6,-4.4,50.43), Angle(0,180,0) )
	Engine:SetDoorHandler( DoorHandler )

	local DoorHandler = self:AddDoorHandler( "hatch_driver", Vector(47.14,24.4,79.43), Angle(0,0,0), Vector(-15,-15,-15), Vector(15,15,15), Vector(-15,-15,-15), Vector(15,15,15) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hatch_rear", Vector(-120.7,0,51.67), Angle(0,180,0), Vector(-2,-30,-30), Vector(2,30,30), Vector(-2,-30,-30), Vector(40,30,30) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat1 )

	self:AddFuelTank( Vector(-75,0,40), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(0,-20,-18),Vector(18,20,18) )

	-- front up
	self:AddArmor( Vector(103,0,60), Angle(26,0,0), Vector(-32,-57,-2), Vector(32,57,2), 1200, self.PlateArmor )
	-- transm
	self:AddArmor( Vector(120,0,26), Angle(134,0,0), Vector(-14,-40,-5), Vector(14,40,5), 1500, self.DoublePlateArmor )
	-- front down
	self:AddArmor( Vector(118,0,34), Angle(134,0,0), Vector(-19,-57,-2.1), Vector(19,57,2.1), 1200, self.PlateArmor )

	-- left plate
	self:AddArmor( Vector(0,58,60), Angle(0,0,0), Vector(-127,-1,-16), Vector(127,1,16), 1000, self.PlateArmor )
	-- left box
	self:AddArmor( Vector(-29,63,60), Angle(0,0,0), Vector(-97,-4,-16), Vector(97,4,16), 1500, self.TracksArmor )
	-- left skirt
	self:AddArmor( Vector(0,61.5,43), Angle(0,0,0), Vector(-127,-1,-16), Vector(127,1,16), 1200, self.DoublePlateArmor )

	-- right plate
	self:AddArmor( Vector(0,-58,60), Angle(0,0,0), Vector(-127,-1,-16), Vector(127,1,16), 1000, self.PlateArmor )
	-- right box
	self:AddArmor( Vector(-7,-63,54), Angle(0,0,0), Vector(-36,-4,-7), Vector(36,4,7), 1500, self.TracksArmor )
	-- right skirt
	self:AddArmor( Vector(0,-61.5,49), Angle(0,0,0), Vector(-127,-1,-23), Vector(127,1,23), 1200, self.DoublePlateArmor )
	-- back door
	self:AddArmor( Vector(-113,0,50), Angle(78,0,0), Vector(-27,-33,-2), Vector(27,33,2), 1200, self.DoublePlateArmor )
	-- back plates
	self:AddArmor( Vector(-118,0,60), Angle(78,0,0), Vector(-17,-57,-2), Vector(17,57,2), 1000, self.PlateArmor )

	-- hatch
	self:AddArmor( Vector(51,27,66), Angle(0,0,0), Vector(-16,-15,-16), Vector(16,15,16), 1400, self.DoublePlateArmor )

	-- turret
	local TurretArmor = self:AddArmor( Vector(-13.5,-4,96), Angle(0,0,0), Vector(-48,-48,-15), Vector(48,48,15), 1500, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- base
	self:AddArmor( Vector(4,0,49), Angle(0,0,0), Vector(-129,-69,-32), Vector(129,69,32), 1200, self.BaseArmor )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(0,40,64), Vector(-5,0,70), Angle(0,0,0), Vector(-18,-6,-9), Vector(18,6,9) )
	self:AddAmmoRack( Vector(0,-40,64), Vector(-5,0,70), Angle(0,0,0), Vector(-18,-6,-9), Vector(18,6,9) )

	-- trailer hitch
	self:AddTrailerHitch( Vector(-100,0,24), LVS.HITCHTYPE_MALE )
end

function ENT:OnMaintenance()
	self:SetBodygroup( 1, 0 )
	self._swapMissile = nil
end
