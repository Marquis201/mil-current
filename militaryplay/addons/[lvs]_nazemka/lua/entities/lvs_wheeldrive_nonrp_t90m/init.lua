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
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/t90m/cannon_120mm_m58_shot_01.wav", "lvs/vehicles/t90m/cannon_120mm_m58_shot_01.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local ID = self:LookupAttachment( "mg_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/t90m/loop_m1919.wav", "lvs/vehicles/t90m/loop_m1919.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_coax" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos - Muzzle.Ang:Up() * 140 - Muzzle.Ang:Forward() * 15 ), "lvs/vehicles/t90m/pkt_loop.wav", "lvs/vehicles/t90m/loop_m1918_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(0,0,30), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local MGSeat = self:AddPassengerSeat( Vector(0,0,30), Angle(0,-90,0) )
	MGSeat.HidePlayer = true
	self:SetMGSeat( MGSeat )

	local DoorHandler = self:AddDoorHandler( "^hatch1", Vector(58.84,0,56.58), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )
	self.DriverHatch = DoorHandler

	local DoorHandler = self:AddDoorHandler( "^hatch2", Vector(-11.57,-26.95,95.09), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( MGSeat )
	DoorHandler:SetParent( self, self:LookupAttachment( "comm_seat" ) )
	self.CommHatch = DoorHandler

	local DoorHandler = self:AddDoorHandler( "hatch3", Vector(-21.07,20.73,86.96), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )
	DoorHandler:SetParent( self, self:LookupAttachment( "gunner_seat" ) )

	self:AddEngine( Vector(-110,0,40), Angle(0,180,0) )
	self:AddFuelTank( Vector(-65,-20,40), Angle(0,0,0), 600, LVS.FUELTYPE_DIESEL, Vector(-13,-13,-13),Vector(12,13,13) )

	-- front upper plate
	local FrontUpper = self:AddArmor( Vector(98,0,47), Angle(-73,0,0), Vector(-1,-45,-32), Vector(1,45,32), 2000, self.FrontArmor )
	FrontUpper.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(6,1) end
	FrontUpper.OnRepaired = function( ent ) self:SetBodygroup(6,0) end
	FrontUpper:SetLabel( "FrontUpper" )

	-- front lower plate
	local FrontLower = self:AddArmor( Vector(116,0,27), Angle(46,0,0), Vector(-1,-45,-16), Vector(1,45,16), 6000, self.TurretBottomArmor )
	FrontLower.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(7,1) end
	FrontLower.OnRepaired = function( ent ) self:SetBodygroup(7,0) end
	FrontLower:SetLabel( "FrontLower" )
	-- upper plate
	self:AddArmor( Vector(-28,0,55), Angle(90,0,0), Vector(-2,-45,-96), Vector(2,45,96), 800, self.UpperArmor )
	-- rear
	self:AddArmor( Vector(-125,0,37), Angle(90,0,0), Vector(-21,-45,-11), Vector(21,45,11), 800, self.RearArmor )
	-- bottom
	self:AddArmor( Vector(-6,0,16), Angle(0,-90,0), Vector(-45,-112,-2), Vector(45,112,2), 800, self.SideArmor )

	-- left
	local Left = self:AddArmor( Vector(-6,44,36), Angle(90,0,0), Vector(-21,-2,-134), Vector(21,2,134), 6000, self.SideArmor )
	Left.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(9,1) end
	Left.OnRepaired = function( ent ) self:SetBodygroup(9,0) end
	Left:SetLabel( "Left" )

	-- right
	local Right = self:AddArmor( Vector(-6,-44,36), Angle(90,0,0), Vector(-21,-2,-134), Vector(21,2,134), 6000, self.SideArmor )
	Right.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(8,1) end
	Right.OnRepaired = function( ent ) self:SetBodygroup(8,0) end
	Right:SetLabel( "Right" )

	-- left skirt
	self:AddArmor( Vector(-3,68,40.4), Angle(0,0,0), Vector(-145,-13,-17), Vector(145,13,17), 1800, self.FrontArmor )
	-- right skirt
	self:AddArmor( Vector(-3,-68,40.4), Angle(0,0,0), Vector(-145,-13,-17), Vector(145,13,17), 1800, self.FrontArmor )



	-- neck
	self:AddArmor( Vector(-5,0,53), Angle(0,0,0), Vector(-54,-55,-7), Vector(54,55,7), 1400, self.SideArmor )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(-5,0,32), Vector(5,0,57), Angle(0,0,0), Vector(-30,-30,-7), Vector(30,30,7) )

	-- trailer hitch
	self:AddTrailerHitch( Vector(-112,0,22), LVS.HITCHTYPE_MALE )
	self:MakeTurretPhysics()
end


function ENT:MakeTurretPhysics()

	local Turret = self:CreateTurretPhysics( {
		follow = "turret_att",
		mdl = "models/diggercars/t90m/turret_col.mdl",
	} )
	self:SetTurretArmor( Turret )

	local Mask = self:AddArmor( Vector(52,0,16), Angle(0,0,0), Vector(-36,-72,-15), Vector(36,72,15), 4000, self.TurretArmor, Turret )
	Mask.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(10,1) end
	Mask.OnRepaired = function( ent ) self:SetBodygroup(10,0) end
	Mask:SetLabel( "Mask" )

	-- turret rear
	self:AddArmor( Vector(-101,0,16), Angle(0,0,0), Vector(-10,-17,-16), Vector(10,17,16), 1100, self.RearArmor, Turret )
	-- turret top
	self:AddArmor( Vector(-37,0,16), Angle(0,0,0), Vector(-54,-50,-16), Vector(54,50,16), 400, self.RearArmor, Turret )
	-- turret right
	self:AddArmor( Vector(-41,-45,16), Angle(0,-17,0), Vector(-63,-12,-15), Vector(63,12,15), 3200, self.TurretArmor, Turret )
	-- turret left
	self:AddArmor( Vector(-41,45,16), Angle(0,17,0), Vector(-63,-12,-15), Vector(63,12,15), 3200, self.TurretArmor, Turret )
end

function ENT:SpawnShell()
	local ID = self:LookupAttachment( "eject" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return end

	local Shell = ents.Create( "lvs_item_shell" )

	if not IsValid( Shell ) then return end

	Shell.MDL = "models/diggercars/t72b/shell.mdl"
	Shell.CollisionSounds = {
		"lvs/vehicles/pak40/shell_impact1.wav",
		"lvs/vehicles/pak40/shell_impact2.wav"
	}

	Shell:SetPos( Muzzle.Pos - Muzzle.Ang:Forward() * 1 )
	Shell:SetAngles( Muzzle.Ang + Angle(90,0,0) )
	Shell:Spawn()
	constraint.NoCollide( self:GetTurretArmor(), Shell, 0, 0 )
	Shell:Activate()
	Shell:SetOwner( self )

	local PhysObj = Shell:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	PhysObj:SetVelocityInstantaneous( Shell:GetRight() * 200 - Shell:GetForward() * 280 )
	PhysObj:SetAngleVelocityInstantaneous( Vector(20,-240,-840) )
end

function ENT:DoReloadSequence( delay )
	if self._ReloadActive then return end

	self._ReloadActive = true

	self:SetBodygroup(2, 1)

	timer.Simple(delay, function()
		if not IsValid( self ) then return end
		self:EmitSound("lvs/vehicles/t90m/t72_cannon_autoreload_01.wav", 75, 100, 1, CHAN_WEAPON )
		self:SetBodygroup(2, 0)
		self:PlayAnimation("eject")
		timer.Simple(1.1, function()
			if not IsValid( self ) then return end
			self:SpawnShell()
			self:SetBodygroup(2, 1)
		end)
	end)

	timer.Simple(4.2, function()
		if not IsValid( self ) then return end

		self:PlayAnimation("reload")
		timer.Simple(0.1, function()
			self:SetBodygroup(2, 0)
			if not IsValid( self ) then return end
			self._ReloadActive = nil
		end )
	end )

end

function ENT:DoAttackSequence()
	self:DoReloadSequence( 1 )
end


function ENT:GetMissileOffset()
	return Vector(0,0,50)
end
