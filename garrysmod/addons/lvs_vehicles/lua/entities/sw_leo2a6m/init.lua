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
	self:MakeTurretPhysics()

	-- engine
	self:AddEngine( Vector(-110,0,55), Angle(0,0,0), Vector(-15,-40,-25),Vector(40,40,0) )
	
	-- fuel tank
	self:AddFuelTank( Vector(-30,25,55), Angle(0,0,0), 800, LVS.FUELTYPE_DIESEL, Vector(-35,-10,-25),Vector(0,10,0) )

	-- ammo rack weakspot
	local IDT = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( IDT )
	self:AddAmmoRack( Vector(60,20,37.4), self:WorldToLocal(Turret.Pos), Angle(0,0,0), Vector(-10,-15,-15), Vector(20,15,15) )
	
	local DriverSeat = self:AddDriverSeat( Vector(60,-20,12), Angle(0,-90,10) )
	DriverSeat.HidePlayer = false

	local GunnerSeat = self:AddPassengerSeat( Vector(20,-21,38), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat(GunnerSeat)

	self:SetGunnerSeat(GunnerSeat)
	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local CommanderSeat = self:AddPassengerSeat( Vector(-7,-21,48), Angle(0,-90,0) )
	--CommanderSeat.HidePlayer = true
	self:SetCommanderSeat(CommanderSeat)

	local LoaderSeat = self:AddPassengerSeat( Vector(0,23,65), Angle(0,-90,0) )
	LoaderSeat.HidePlayer = true
	self:SetLoaderSeat(LoaderSeat)

	local HatchDHandler = self:AddDoorHandler( "!hatch_driver", Vector(77,-31,57), Angle(0,0,0), Vector(-15,-15,-5), Vector(15,15,5), Vector(-15,-15,-5), Vector(15,15,5) )
	HatchDHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchDHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchDHandler:LinkToSeat(DriverSeat)

	local HatchLHandler = self:AddDoorHandler( "!hatch_loader", Vector(-5,20,95), Angle(0,0,0), Vector(-12,-12,-5), Vector(12,12,5), Vector(-12,-12,-5), Vector(12,12,5) )
	HatchLHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchLHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchLHandler:LinkToSeat(LoaderSeat)
	HatchLHandler:SetParent( self, self:LookupAttachment( "turret" ) )
	self.LoaderHatchHandler = HatchLHandler

	local HatchCHandler = self:AddDoorHandler( "!hatch_commander", Vector(-5,-22.5,95), Angle(0,0,0), Vector(-12,-12,-5), Vector(12,12,5), Vector(-12,-12,-5), Vector(12,12,5) )
	HatchCHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchCHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchCHandler:LinkToSeat(CommanderSeat)
	HatchCHandler:SetParent( self, self:LookupAttachment( "turret" ) )
	self.ComHatchHandler = HatchCHandler

	self:AddArmor( Vector(90,0,47), Angle(0,0,0), Vector(-35,-64,-0), Vector(20,64,12), 2500, 14000 )
	self:AddArmor( Vector(118.8,0,43.4), Angle(-59,0,0), Vector(-5,-39,-11), Vector(3,39,10), 2500, 42000 )
	self:AddArmor( Vector(125,0,38), Angle(0,0,0), Vector(-45,-39,-23), Vector(0,39,0), 2500, 27000 )
	self:AddArmor( Vector(54.5,-38.3,47), Angle(0,0,0), Vector(-83,-27,0), Vector(0,0,13), 1000, 7000 )
	self:AddArmor( Vector(-29,-38.3,47), Angle(0,0,0), Vector(-115,-27,0), Vector(0,0,20), 1000, 7000 )
	self:AddArmor( Vector(54.5,38.3,47), Angle(0,0,0), Vector(-83,0,0), Vector(0,27,13), 1000, 7000 )
	self:AddArmor( Vector(-29,38.3,47), Angle(0,0,0), Vector(-115,0,0), Vector(0,27,20), 1000, 7000 )
	self:AddArmor( Vector(127.5,-59.6,32), Angle(0,0,0), Vector(-91,-7,0), Vector(0,0,15.5), 1000, 9500 )
	self:AddArmor( Vector(127.5,59.6,32), Angle(0,0,0), Vector(-91,0,0), Vector(0,7,15.5), 1000, 9500 )
	self:AddArmor( Vector(-29,0,15), Angle(0,0,0), Vector(0,-39,0), Vector(110,39,42), 1000, 7000 )
	self:AddArmor( Vector(-29,0,15), Angle(0,0,0), Vector(-115, -39,0), Vector(0,39,45), 1000, 2000 )
	self:AddArmor( Vector(-29,0,59), Angle(5,0,0), Vector(-115,-39,-10), Vector(0,39,1), 1000, 2000 )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	local IDT = self:LookupAttachment( "muzzle_mg" )
	local MuzzleT = self:GetAttachment( IDT )
	local IDS1 = self:LookupAttachment( "smoke_1" )
	local Smoke1 = self:GetAttachment( IDS1 )
	local IDS2 = self:LookupAttachment( "smoke_2" )
	local Smoke2 = self:GetAttachment( IDS2 )

	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/leopard2a4/cannon_fire.wav", "sw/leopard2a4/cannon_fire_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/mg42_loop.wav", "sw/vehicles/weapons/mg42_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )

	self.SNDTurretMGstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/m240_lastshot.wav", "sw/vehicles/weapons/mg42_interior_lastshot.wav" )
	self.SNDTurretMGstop:SetSoundLevel( 95 )
	self.SNDTurretMGstop:SetParent( self, IDC )

	self.SNDTurretMGT = self:AddSoundEmitter( self:WorldToLocal( MuzzleT.Pos ), "sw/vehicles/weapons/mg42_loop.wav", "sw/vehicles/weapons/mg42_loop.wav" )
	self.SNDTurretMGT:SetSoundLevel( 95 )
	self.SNDTurretMGT:SetParent( self, IDT )

	self.SNDTurretMGTstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleT.Pos ), "sw/vehicles/weapons/m240_lastshot.wav", "sw/vehicles/weapons/m240_lastshot.wav" )
	self.SNDTurretMGTstop:SetSoundLevel( 95 )
	self.SNDTurretMGTstop:SetParent( self, IDT )

	self.SNDTurretRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/leopard2a4/reload.wav" )
	self.SNDTurretRld:SetSoundLevel( 95 )
	self.SNDTurretRld:SetParent( self, IDT )
	
	self.SNDMGRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "sw/vehicles/mg_reload.wav", "sw/vehicles/mg_reload.wav" )
	self.SNDMGRld:SetSoundLevel( 95 )
	self.SNDMGRld:SetParent( self, IDT )

	self.SNDMGRldInt = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/mg_reload.wav" )
	self.SNDMGRldInt:SetSoundLevel( 95 )
	self.SNDMGRldInt:SetParent( self, IDT )

	self.SNDSmoke1 = self:AddSoundEmitter( self:WorldToLocal( Smoke1.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke1:SetSoundLevel( 95 )
	self.SNDSmoke1:SetParent( self, IDS1 )

	self.SNDSmoke2 = self:AddSoundEmitter( self:WorldToLocal( Smoke2.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke2:SetSoundLevel( 95 )
	self.SNDSmoke2:SetParent( self, IDS2 )
end
function ENT:MakeTurretPhysics()
	local Turret = self:CreateTurretPhysics( {
		follow = "turret",
		mdl = "models/sw/ground/leopard2a6m/turret_physics.mdl",
	} )
	self:SetTurretArmor( Turret )

	local IDT = self:LookupAttachment( "turret" )
	local TurretAtt = self:GetAttachment( IDT )
	local TurretAmmo = self:AddAmmoRack( Vector(-55,20,20), self:WorldToLocal(TurretAtt.Pos), Angle(0,0,0), Vector(-10,-15,-10), Vector(20,15,10), Turret )

	local CheekRArmor = self:AddArmor( Vector(60,-29,0), Angle(0,0,0), Vector(-25,-25,0), Vector(33,20,30), 2500, 87000, Turret )
	CheekRArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	CheekRArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local CheekLArmor = self:AddArmor( Vector(60,29,0), Angle(0,0,0), Vector(-25,-20,0), Vector(33,25,30), 2500, 87000, Turret )
	CheekLArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	CheekLArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local MaskArmor = self:AddArmor( Vector(60,0,0), Angle(0,0,0), Vector(-25,-8,0), Vector(33,8,30), 2500, 37000, Turret )
	MaskArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	MaskArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local SideArmor = self:AddArmor( Vector(0,0,0), Angle(0,0,0), Vector(-27,-49,0), Vector(35,49,30), 2500, 29500, Turret )
	SideArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	SideArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local RearArmor = self:AddArmor( Vector(-27,0,0), Angle(0,0,0), Vector(-90,-49,0), Vector(0,49,30), 2500, 7000, Turret )
	RearArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	RearArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local TopArmor = self:AddArmor( Vector(0,0,30), Angle(0,0,0), Vector(-90,-40,0), Vector(10,40,10), 2500, 1000, Turret )
	RearArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	RearArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
end

function ENT:OnTick()
	self:AimTurret()
	if IsValid(self) then
		if IsValid(self:GetLoaderSeat()) and IsValid(self:GetLoaderSeat():GetDriver()) then
			if IsValid(self.LoaderHatchHandler) then
				local PoseValueL = self:GetHatchLoader() and 1 or 0
				local DoorHandlerL = self.LoaderHatchHandler
				DoorHandlerL:SetPoseMin( PoseValueL )
			end
		else
			if IsValid(self.LoaderHatchHandler) then
				self:SetHatchLoader(false)
				local PoseValueL = self:GetHatchLoader() and 1 or 0
				local DoorHandlerL = self.LoaderHatchHandler
				DoorHandlerL:SetPoseMin( PoseValueL )
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