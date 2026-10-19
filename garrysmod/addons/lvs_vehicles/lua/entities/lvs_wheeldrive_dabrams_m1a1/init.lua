AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )
	local ID = self:LookupAttachment( "muzzle_m2" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/abrams/m2hb_loop.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_coax" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/abrams/m240.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/abrams/gun_out.wav", "lvs/vehicles/abrams/gun_in.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "hatch1", Vector(73.61,0,56.13), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "^mg_shot", Vector(0,0,0), Angle(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0) )
	DoorHandler:SetRate( 20 )
	DoorHandler.PlayOnce = function( ent )
		ent:Open()
		ent.sm_pp = 0
	end

	self.MgShot = DoorHandler

	self:AddEngine( Vector(-79.66,0,70), Angle(0,180,0) )
	self:AddFuelTank( Vector(-75,0,40), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(0,-20,-18),Vector(18,20,18) )

	-- trailer hitch
	self:AddTrailerHitch( Vector(-100,0,24), LVS.HITCHTYPE_MALE )
	self:MakeTurretPhysics()
	self:MakeTopGunnerSeat()
	self:MakeArmor()
end

function ENT:MakeTopGunnerSeat()

	local GunnerSeat = self:AddPassengerSeat( Vector(0,0,60), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	local DoorHandler = self:AddDoorHandler( "rd", Vector(-28.87,-20.27,104.24), Angle(0,0,0), Vector(-20,-20,-20), Vector(20,20,20), Vector(-20,-20,-20), Vector(20,20,20) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:SetParent( self, self:LookupAttachment( "turret_att" ) )
	DoorHandler:LinkToSeat( GunnerSeat )

	local TopGunnerSeat = self:AddPassengerSeat( Vector(0,0,60), Angle(0,-90,0) )
	TopGunnerSeat.HidePlayer = true
	self:SetTopGunnerSeat( TopGunnerSeat )

	local DoorHandler = self:AddDoorHandler( "ld", Vector(-28.51,16.69,96.26), Angle(0,0,0), Vector(-20,-20,-20), Vector(20,20,20), Vector(-20,-20,-20), Vector(20,20,20) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:SetParent( self, self:LookupAttachment( "turret_att" ) )
	DoorHandler:LinkToSeat( TopGunnerSeat )



	local ID = self:LookupAttachment( "muzzle_mg" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGt = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/abrams/m240.wav" )
	self.SNDTurretMGt:SetSoundLevel( 95 )
	self.SNDTurretMGt:SetParent( self, ID )

	self.TopGunnerDoorHandler = DoorHandler
end

function ENT:MakeArmor()
	-- front
	self:AddArmor( Vector(131,0,38), Angle(10,0,0), Vector(-10,-43,-14), Vector(10,43,14), 6000, self.Front )
	-- front top
	self:AddArmor( Vector(79,0,54), Angle(7,0,0), Vector(-45,-43,-2), Vector(45,43,2), 1500, self.FrontTop )
	-- front bottom
	self:AddArmor( Vector(89,0,24), Angle(-8,0,0), Vector(-32,-43,-2), Vector(32,43,2), 2500, self.FrontTop )

	-- right front top
	self:AddArmor( Vector(34,-42,46), Angle(0,0,0), Vector(-92,-1,-15), Vector(92,1,15), 2600, self.SideFront )
	-- left front top
	self:AddArmor( Vector(34,42,46), Angle(0,0,0), Vector(-92,-1,-15), Vector(92,1,15), 2600, self.SideFront )

	-- right rear top
	self:AddArmor( Vector(-112,-42,51), Angle(0,0,0), Vector(-54,-1,-20), Vector(54,1,20), 2600, self.SideRear )
	-- left rear top
	self:AddArmor( Vector(-112,42,51), Angle(0,0,0), Vector(-54,-1,-20), Vector(54,1,20), 2600, self.SideRear )

	-- right bottom
	self:AddArmor( Vector(-16,-42,25), Angle(0,0,0), Vector(-139,-1,-6), Vector(139,1,6), 700, self.Rear )
	-- left bottom
	self:AddArmor( Vector(-16,42,25), Angle(0,0,0), Vector(-139,-1,-6), Vector(139,1,6), 700, self.Rear )

	-- skirt right
	self:AddArmor( Vector(-13,-65,51), Angle(0,0,0), Vector(-150,-10,-20), Vector(150,10,20), 4000, self.Front )
	-- skirt left
	self:AddArmor( Vector(-13,65,51), Angle(0,0,0), Vector(-150,-10,-20), Vector(150,10,20), 4000, self.Front )

	-- rear
	self:AddArmor( Vector(-150,0,45), Angle(0,0,0), Vector(-15,-41,-26), Vector(15,41,26), 700, self.Rear )
	-- rear top
	self:AddArmor( Vector(-95,0,45), Angle(0,0,0), Vector(-40,-41,-26), Vector(40,41,26), 500, self.Rear )
	-- mid
	self:AddArmor( Vector(0,0,40), Angle(0,0,0), Vector(-58,-41,-21), Vector(58,41,21), 1500, self.SideRear )
end

function ENT:OnTick()
	self:AimTurret()

	local TopGunnerSeat = self:GetTopGunnerSeat()
	local DoorHandler = self.TopGunnerDoorHandler

	if not IsValid( DoorHandler ) or not IsValid( TopGunnerSeat ) then return end

	local PoseValue = IsValid( TopGunnerSeat:GetDriver() ) and 1 or 0

	if PoseValue ~= DoorHandler:GetPoseMin() then
		DoorHandler:SetPoseMin( PoseValue )
	end
end

function ENT:MakeTurretPhysics()

	local Turret = self:CreateTurretPhysics( {
		follow = "turret_att",
		mdl = "models/diggercars/abrams_m1a1/turret_col.mdl",
	} )
	self:SetTurretArmor( Turret )
	-- right cheek
	self:AddArmor( Vector(59,-43,20), Angle(0,0,0), Vector(-20,-27,-15), Vector(20,27,15), 8000, self.TurretCheeks, Turret )
	-- left cheek
	self:AddArmor( Vector(59,36,20), Angle(0,0,0), Vector(-20,-28,-15), Vector(20,28,15), 8000, self.TurretCheeks, Turret )
	-- mask
	self:AddArmor( Vector(59,-4,20), Angle(0,0,0), Vector(-23,-13,-15), Vector(23,13,15), 5000, self.Mask, Turret )
	-- right
	self:AddArmor( Vector(-35,-55,21), Angle(0,0,0), Vector(-73,-15,-17), Vector(73,15,17), 6000, self.TurretSide, Turret )
	-- left
	self:AddArmor( Vector(-35,49,21), Angle(0,0,0), Vector(-73,-15,-17), Vector(73,15,17), 6000, self.TurretSide, Turret )
	-- mid
	self:AddArmor( Vector(-35,-3,26), Angle(0,0,0), Vector(-74,-37,-22), Vector(74,37,22), 1000, self.Rear, Turret )
	-- neck
	self:AddArmor( Vector(-1,-2,4), Angle(0,0,0), Vector(-64,-64,-5), Vector(64,64,5), 1000, self.SideRear, Turret )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(-66,0,22), Vector(0,0,61), Angle(0,0,0), Vector(-16,-44,-9), Vector(16,44,9), Turret )

end

function ENT:GetMissileOffset()
	return Vector(0,0,50)
end
