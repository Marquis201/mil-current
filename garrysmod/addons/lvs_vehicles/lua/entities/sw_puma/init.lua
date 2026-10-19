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
	self:SetSeekerDist(25000)
	self:SetSeekerAngle(5)
	self:SetLockTimer(3)
	
	--Turret
	self:MakeTurretPhysics()

	--Engine
	self:AddEngine( Vector(80,-15,55), Angle(0,180,0), Vector(-30,-35,-10), Vector(-30,-35,-10) )

	--Fuel
	self:AddFuelTank( Vector(138,0,45), Angle(-30,0,0), 400, LVS.FUELTYPE_DIESEL, Vector(-10,-35,-5),Vector(10,35,5) )

	--Armor
	self:AddArmor( Vector(105.6,0,66), Angle(0,0,0), Vector(-52,-80,-17), Vector(52,80,17), 500, 13500 )
	self:AddArmor( Vector(105.6,0,32), Angle(0,0,0), Vector(-52,-80,-17), Vector(52,80,17), 500, 4000 )
	self:AddArmor( Vector(-50.4,0,49), Angle(0,0,0), Vector(-104,-80,-34), Vector(104,80,34), 500, 6500 )

	local DriverSeat = self:AddDriverSeat( Vector(25,25,50), Angle(0,-90,0) )
	DriverSeat.ExitPos = Vector(35,100,20)
	local GunnerSeat = self:AddPassengerSeat( Vector(-5,-18,40), Angle(0,-90,0) )
	GunnerSeat.ExitPos = Vector(10,-100,20)
	local CommanderSeat = self:AddPassengerSeat( Vector(-5,18,40), Angle(0,-90,0) )
	CommanderSeat.ExitPos = Vector(-10,-100,20)
	self:SetGunnerSeat(GunnerSeat)
	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end
	DriverSeat.HidePlayer = true

	local HatchDHandler =  self:AddDoorHandler( "!hatch_driver", Vector(30,25,85), Angle(0,0,0), Vector(-15,-15,-5), Vector(15,15,5), Vector(-15,-15,-5), Vector(15,15,5) )
	HatchDHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchDHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchDHandler:LinkToSeat(DriverSeat)

	local HatchGHandler =  self:AddDoorHandler( "!hatch_gunner", Vector(-10,-21,85), Angle(0,0,0), Vector(-13,-13,-5), Vector(13,13,5), Vector(-13,-13,-5), Vector(13,13,5) )
	HatchGHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	HatchGHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	HatchGHandler:LinkToSeat(GunnerSeat)

	local PassSeat1 = self:AddPassengerSeat( Vector(-44.5,19,40), Angle(0,180,0) )
	PassSeat1.ExitPos = Vector(-180,40,20)
	local PassSeat2 =self:AddPassengerSeat( Vector(-44.5,-19,40), Angle(0,0,0) )
	PassSeat2.ExitPos = Vector(-180,-40,20)
	local PassSeat3 =self:AddPassengerSeat( Vector(-64.5,19,40), Angle(0,180,0) )
	PassSeat3.ExitPos = Vector(-180,40,20)
	local PassSeat4 =self:AddPassengerSeat( Vector(-64.5,-19,40), Angle(0,0,0) )
	PassSeat4.ExitPos = Vector(-180,-40,20)
	local PassSeat5 =self:AddPassengerSeat( Vector(-84.5,19,40), Angle(0,180,0) )
	PassSeat5.ExitPos = Vector(-180,40,20)
	local PassSeat6 =self:AddPassengerSeat( Vector(-84.5,-19,40), Angle(0,0,0) )
	PassSeat6.ExitPos = Vector(-180,-40,20)
	local PassSeat7 =self:AddPassengerSeat( Vector(-104.5,19,40), Angle(0,180,0) )
	PassSeat7.ExitPos = Vector(-180,40,20)
	local PassSeat8 =self:AddPassengerSeat( Vector(-104.5,-19,40), Angle(0,0,0) )
	PassSeat8.ExitPos = Vector(-180,-40,20)

	local IDT = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( IDT )
	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	local IDM = self:LookupAttachment( "missile_1" )
	local MuzzleM = self:GetAttachment( IDM )
	local IDS1 = self:LookupAttachment( "smoke_1" )
	local Smoke1 = self:GetAttachment( IDS1 )
	local IDS2 = self:LookupAttachment( "smoke_2" )
	local Smoke2 = self:GetAttachment( IDS2 )

	self.SNDTurretMis = self:AddSoundEmitter( self:WorldToLocal( MuzzleM.Pos ), "sw/rocket/missile_fire.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDTurretMis:SetSoundLevel( 95 )
	self.SNDTurretMis:SetParent( self, IDM )

	self.SNDATGMRld = self:AddSoundEmitter( self:WorldToLocal( MuzzleM.Pos ), "sw/rocket/rocket_reload_start_2.wav", "" )
	self.SNDATGMRld:SetSoundLevel( 95 )
	self.SNDATGMRld:SetParent( self, IDM )

	self.SNDATGMRldEnd = self:AddSoundEmitter( self:WorldToLocal( MuzzleM.Pos ), "sw/rocket/rocket_reload_end_2.wav", "" )
	self.SNDATGMRldEnd:SetSoundLevel( 95 )
	self.SNDATGMRldEnd:SetParent( self, IDM )

	self.SNDRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/weapons/bushmaster_fire_reload.wav" )
	self.SNDRld:SetSoundLevel( 125 )
	self.SNDRld:SetParent( self, IDT )

	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/bushmaster_fire.wav", "sw/vehicles/weapons/bushmaster_fire_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/mg42_loop.wav", "sw/vehicles/weapons/mg42_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	self.SNDTurretMGstop = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/vehicles/weapons/m240_lastshot.wav", "sw/vehicles/weapons/mg42_interior_lastshot.wav" )
	self.SNDTurretMGstop:SetSoundLevel( 95 )
	self.SNDTurretMGstop:SetParent( self, ID )

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
		mdl = "models/sw/ground/puma/turret_physics.mdl",
	} )
	self:SetTurretArmor( Turret )

	local IDT = self:LookupAttachment( "turret" )
	local TurretAtt = self:GetAttachment( IDT )
	local TurretAmmo = self:AddAmmoRack( Vector(-35,0,25), self:WorldToLocal(TurretAtt.Pos), Angle(0,0,0), Vector(-10,-15,-10), Vector(20,15,10), Turret )
	
	local Armor = self:AddArmor( Vector(11.111,0,20), Angle(0,0,0), Vector(-70,-50,-20), Vector(70,50,20), 2500, 3500, Turret )
	Armor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	Armor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
end

function ENT:OnTick()
	self:AimTurret()
end

--Seeker
function ENT:Seeker()
	if IsValid(self) then
		local ID = self:LookupAttachment( "view" )
		local Attachment = self:GetAttachment( ID )
		self.guided_nextThink = self.guided_nextThink or 0
		self.FindTime = self.FindTime or 0
		self.nextFind = self.nextFind or 0
		
		local curtime = CurTime()
		
		if self.FindTime + self:GetLockTimer() < curtime and IsValid( self:GetClosestEnt() ) then
			self.Locked = true
		else
			self.Locked = false
		end
		
		if self.Locked ~= self:GetIsLocked() then
			self:SetIsLocked( self.Locked )
			if self.Locked then
				self.LockSND = CreateSound(self, "sw/puma/lock.wav")
				self.LockSND:PlayEx( 1, 100 )		
				if self.TrackSND then
					self.TrackSND:Stop()
					self.TrackSND = nil
				end
			else
				if self.LockSND then
					self.LockSND:Stop()
					self.LockSND = nil
				end
			end
		end
		
		if self.nextFind < curtime then
			self.nextFind = curtime + self:GetLockTimer()
			self.FoundVehicles = {}
			
			for k, v in pairs( ents.GetAll() ) do
				if (v.LVS and (v:GetVehicleType() == "car" or v:GetVehicleType() == "tank") and v:GetEngineActive()) or v.IsSimfphyscar then						
					table.insert( self.FoundVehicles, v )
				end
			end
		end
		
		if self.guided_nextThink < curtime then
			self.guided_nextThink = curtime + 0.25
			self.FoundVehicles = self.FoundVehicles or {}
			local AimForward = Attachment.Ang:Forward()
			local startpos = Attachment.Pos
	
			local Vehicles = {}
			local ClosestEnt = NULL
			local ClosestDist = 0
			
			for k, v in pairs( self.FoundVehicles  ) do
				if IsValid( v ) then
					local sub = (v:GetPos() - startpos)
					local toEnt = sub:GetNormalized()
					local dist = sub:Length()
					local Ang = math.acos( math.Clamp( AimForward:Dot( toEnt ) ,-1,1) ) * (200 / math.pi)
					
					if Ang < self:GetSeekerAngle() and dist < self:GetSeekerDist() and self:CanSeeMis( v ) then
						table.insert( Vehicles, v )
						
						local stuff = WorldToLocal( v:GetPos(), Angle(0,0,0), startpos, self:GetAngles() + Angle(90,0,0) )
						stuff.z = 0
						local dist = stuff:Length()
					
						if not IsValid( ClosestEnt ) then
							ClosestEnt = v
							ClosestDist = dist
						end
						
						if dist < ClosestDist then
							ClosestDist = dist
							if ClosestEnt ~= v then
								ClosestEnt = v
							end
						end
					end
				else
					self.FoundVehicles[k] = nil
				end
			end
			
			if self:GetClosestEnt() ~= ClosestEnt then
				self:SetClosestEnt( ClosestEnt )
				self:SetClosestDist( ClosestDist )
				self.FindTime = curtime
				if IsValid( ClosestEnt ) then
					self.TrackSND = CreateSound(self, "sw/puma/track.wav")
					self.TrackSND:PlayEx( 1, 100 )
					self.TrackSND:ChangeVolume( 1, 1 )
				else
					if self.TrackSND then
						self.TrackSND:Stop()
						self.TrackSND = nil
					end
				end
			end
			if not IsValid( ClosestEnt ) then
				if self.TrackSND then
					self.TrackSND:Stop()
					self.TrackSND = nil
				end
			end
		end
	else
		self:SetIsLocked(false)
		if self.TrackSND then
			self.TrackSND:Stop()
		end
		if self.LockSND then
			self.LockSND:Stop()
		end
	end	
end
function ENT:CanSeeMis( entity )
	local ID = self:LookupAttachment( "view" )
	local Attachment = self:GetAttachment( ID )
	local pos = entity:LocalToWorld(entity:OBBCenter())
	local tr = util.TraceLine( {
		start = Attachment.Pos,
		endpos = pos,
	} )
	if not (tr.HitWorld or tr.HitSky)then
		return (tr.HitPos - pos):Length() < 75000
	else
		return false
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