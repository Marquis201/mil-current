AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_reflectorsight.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:SetLoadout(1)
	self:RemoveWeapon(1)
	self:RemoveWeapon(2)
	self:AddLoadouts(3)
	self:SetNWInt("Loadout",1)
	self:InitWeapons()
	
	local DriverSeat = self:AddDriverSeat( Vector(55,0,55), Angle(0,-90,0) )
	local GunnerSeat = self:AddPassengerSeat( Vector(115,0,45), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(55,-55,55)
	GunnerSeat.ExitPos = Vector(115,55,45)
	self:SetGunnerSeat(GunnerSeat)

	local Door1Handler = self:AddDoorHandler( "!door_r", Vector(70,-15,80), Angle(0,180,0), Vector(-30,-10,-15), Vector(30,10,15), Vector(-30,-10,-15), Vector(30,10,15) )
	Door1Handler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	Door1Handler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	Door1Handler:LinkToSeat( DriverSeat )

	local Door2Handler = self:AddDoorHandler( "!door_l", Vector(115,15,75), Angle(-30,180,0), Vector(-20,-10,-15), Vector(20,10,15), Vector(-20,-10,-15), Vector(20,10,15) )
	Door2Handler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	Door2Handler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	Door2Handler:LinkToSeat( GunnerSeat )
	
	self:AddEngineSound( Vector(-50,0,80) )
	self:AddFuelTank( Vector(0,0,35), Angle(0,0,0), 250, Vector(-45,-15,-10),Vector(45,15,10) )

	self.Rotor = self:AddRotor( Vector(0,0,144), Angle(0,0,0), 270, -4000 )
	self.Rotor:SetRotorEffects( true )
	self.Rotor:SetHP( 15 )
	function self.Rotor:OnDestroyed( base )
		base:DestroyEngine()
		base:SetBodygroup( 1, 1 ) 
		self:EmitSound( "physics/metal/metal_box_break2.wav" )
	end

	self.TailRotor = self:AddRotor( Vector(-326.6,-16.6,110.85), Angle(0,0,90), 55, -6000 )
	self.TailRotor:SetHP( 15 )
	function self.TailRotor:OnDestroyed( base )
		base:SetBodygroup( 2, 1 ) 
		base:DestroySteering( 2.5 )
		self:EmitSound( "physics/metal/metal_box_break2.wav" )
	end

	local IDL1 = self:LookupAttachment( "muzzle_mgl" )
	local MuzzleMGL = self:GetAttachment( IDL1 )
	self.SNDM134L = self:AddSoundEmitter( self:WorldToLocal( MuzzleMGL.Pos ), "sw/vehicles/weapons/m134_loop.wav", "sw/vehicles/weapons/m134_interior_loop.wav" )
	self.SNDM134L:SetSoundLevel( 95 )
	self.SNDM134L:SetParent( self,IDL1 )
	
	self.SNDM134Lspin = self:AddSoundEmitter( self:WorldToLocal( MuzzleMGL.Pos ), "sw/vehicles/weapons/minigun_rotor_loop.wav", "sw/vehicles/weapons/minigun_rotor_loop.wav" )
	self.SNDM134Lspin:SetSoundLevel( 95 )
	self.SNDM134Lspin:SetParent( self,IDL1 )

	self.SNDM134Lstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleMGL.Pos ), "sw/vehicles/weapons/m134_lastshot.wav", "sw/vehicles/weapons/m134_interior_lastshot.wav" )
	self.SNDM134Lstop:SetSoundLevel( 95 )
	self.SNDM134Lstop:SetParent( self,IDL1 )

	local IDR1 = self:LookupAttachment( "muzzle_mgr" )
	local MuzzleMGR = self:GetAttachment( IDR1 )
	self.SNDM134R = self:AddSoundEmitter( self:WorldToLocal( MuzzleMGR.Pos ), "sw/vehicles/weapons/m134_loop.wav", "sw/vehicles/weapons/m134_interior_loop.wav" )
	self.SNDM134R:SetSoundLevel( 95 )
	self.SNDM134R:SetParent( self,IDR1 )
	
	self.SNDM134Rspin = self:AddSoundEmitter( self:WorldToLocal( MuzzleMGR.Pos ), "sw/vehicles/weapons/minigun_rotor_loop.wav", "sw/vehicles/weapons/minigun_rotor_loop.wav" )
	self.SNDM134Rspin:SetSoundLevel( 95 )
	self.SNDM134Rspin:SetParent( self,IDR1 )

	self.SNDM134Rstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleMGR.Pos ), "sw/vehicles/weapons/m134_lastshot.wav", "sw/vehicles/weapons/m134_interior_lastshot.wav" )
	self.SNDM134Rstop:SetSoundLevel( 95 )
	self.SNDM134Rstop:SetParent( self,IDR1 )

	self.SNDXM18 = self:AddSoundEmitter( self:LocalToWorld(Vector(50,0,42.4)), "sw/vehicles/weapons/m134_loop.wav", "sw/vehicles/weapons/m134_interior_loop.wav" )
	self.SNDXM18:SetSoundLevel( 95 )
	self.SNDXM18:SetParent( self )
	
	self.SNDXM18spin = self:AddSoundEmitter( self:LocalToWorld(Vector(50,0,42.4)), "sw/vehicles/weapons/minigun_rotor_loop.wav", "sw/vehicles/weapons/minigun_rotor_loop.wav" )
	self.SNDXM18spin:SetSoundLevel( 95 )
	self.SNDXM18spin:SetParent( self )

	self.SNDXM18stop = self:AddSoundEmitter( self:LocalToWorld(Vector(50,0,42.4)), "sw/vehicles/weapons/m134_lastshot.wav", "sw/vehicles/weapons/m134_interior_lastshot.wav" )
	self.SNDXM18stop:SetSoundLevel( 95 )
	self.SNDXM18stop:SetParent( self )

	self.SNDXM35 = self:AddSoundEmitter( self:LocalToWorld(Vector(61.7,46.1,47.9)), "sw/vehicles/weapons/m197_loop.wav", "sw/vehicles/weapons/m197_interior_loop.wav" )
	self.SNDXM35:SetSoundLevel( 95 )
	self.SNDXM35:SetParent( self )

	local IDR2 = self:LookupAttachment( "muzzle_glr" )
	local MuzzleGLR = self:GetAttachment( IDR2 )
	self.SNDM129R = self:AddSoundEmitter( MuzzleGLR.Pos, "sw/ah1/m129_fire.wav", "sw/ah1/m129_fire_interior.wav" )
	self.SNDM129R:SetSoundLevel( 95 )
	self.SNDM129R:SetParent( self, IDR2 )

	local IDL2 = self:LookupAttachment( "muzzle_gll" )
	local MuzzleGLL = self:GetAttachment( IDL2 )
	self.SNDM129L = self:AddSoundEmitter( MuzzleGLL.Pos, "sw/ah1/m129_fire.wav", "sw/ah1/m129_fire_interior.wav" )
	self.SNDM129L:SetSoundLevel( 95 )
	self.SNDM129L:SetParent( self, IDL2 )

	self.SNDRktL = self:AddSoundEmitter( Vector(17,58.85,25), "sw/rocket/rocket_start_01.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDRktL:SetSoundLevel( 95 )
	self.SNDRktL:SetParent( self )

	self.SNDRktR = self:AddSoundEmitter( Vector(17,-58.85,25), "sw/rocket/rocket_start_01.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDRktR:SetSoundLevel( 95 )
	self.SNDRktR:SetParent( self )
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
function ENT:RemoveLoadouts()
	if self.Pods then
		for k,v in pairs (self.Pods) do
			if IsValid(v) then
				v:Remove()
			end
			v = nil
		end
		self.Pods = nil
	end
end

--Add loadouts
function ENT:AddLoadouts(b)
	local loadout = self:GetLoadout()
	if loadout == 1 or loadout == 5 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 1 and k <= 3 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/usa/weapons/xm18.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(-5,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
				end
			end
		end
	elseif loadout == 2 or loadout == 6 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 1 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/avia/ah1g/xm35.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
				end
			end
		end
	elseif loadout == 3 or loadout == 7 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 1 and k <= 5 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/usa/weapons/xm158.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(-5,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
				end
			end
		end
	elseif loadout == 4 or loadout == 8 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 1 and k <= 5 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/usa/weapons/aero7.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(-5,0,0)))
						pod:Spawn()
						pod:SetSkin(1)
						pod:SetBodygroup(1,1)
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
				end
			end
		end
	end
end

function ENT:OnTick()
	local loadout = self:GetLoadout()
	if loadout >= 1 then
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(2)
			self:AddLoadouts(4)
			self:SetNWInt("Loadout",loadout)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "sw/ah1/engine_start.wav" )
	else
		self:EmitSound( "sw/ah1/engine_stop.wav" )
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
	
	self:AddLoadouts(30)
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