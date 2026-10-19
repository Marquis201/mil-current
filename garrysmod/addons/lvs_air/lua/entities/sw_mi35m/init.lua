AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_reflectorsight.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:SetLoadout(1)
	self:RemoveWeapon(1)
	self:RemoveWeapon(2)
	self:AddLoadouts(6)
	self:SetNWInt("Loadout",1)
	self:InitWeapons()

	self:SetSeekerDist(15000)
	self:SetSeekerAngle(2)
	self:SetLockTimer(0.25)

	local DriverSeat = self:AddDriverSeat( Vector(135,1,73), Angle(0,-90,20) )
	DriverSeat.ExitPos = Vector(115,-75,35)
	local GunnerSeat = self:AddPassengerSeat( Vector(190,0,50), Angle(0,-90,20) )
	GunnerSeat.ExitPos = Vector(165,75,35)

	self:SetGunnerSeat(GunnerSeat)
	local GunnerWeapon = GunnerSeat:lvsGetWeapon()
	if IsValid( GunnerWeapon ) then
		GunnerWeapon:UnlockAimVector()
	end

	local SeatR1 = self:AddPassengerSeat( Vector(5,-5,60), Angle(0,180,0) )
	SeatR1.ExitPos = Vector(50,-75,35)
	local SeatL1 = self:AddPassengerSeat( Vector(5,5,60), Angle(0,0,0) )
	SeatL1.ExitPos = Vector(50,75,35)
	local SeatR2 = self:AddPassengerSeat( Vector(-20,-5,60), Angle(0,180,0) )
	SeatR2.ExitPos = Vector(50,-75,35)
	local SeatL2 = self:AddPassengerSeat( Vector(-20,5,60), Angle(0,0,0) )
	SeatL2.ExitPos = Vector(50,75,35)

	local Cockpit1Handler = self:AddDoorHandler( "!cockpit_1", Vector(140,-30,70), Angle(0,180,0), Vector(-10,-15,0), Vector(20,1,35), Vector(-10,-15,0), Vector(20,1,35) )
	Cockpit1Handler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	Cockpit1Handler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	Cockpit1Handler:LinkToSeat( DriverSeat )
	
	local Cockpit2Handler = self:AddDoorHandler( "!cockpit_2", Vector(195,26,55), Angle(0,180,0), Vector(-20,-1,0), Vector(20,35,35), Vector(-20,-1,0), Vector(20,35,35) )
	Cockpit2Handler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	Cockpit2Handler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	Cockpit2Handler:LinkToSeat( GunnerSeat )

	local DoorRHandler =  self:AddDoorHandler( "door_r", Vector(50,-38,55), Angle(0,180,0), Vector(-20,-1,-5), Vector(30,1,45),  Vector(-20,-1,-5), Vector(30,1,45) )
	DoorRHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorRHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorRHandler:LinkToSeat(SeatR2)

	local DoorLHandler =  self:AddDoorHandler( "door_l", Vector(50,38,55), Angle(0,180,0), Vector(-20,-1,-5), Vector(30,1,45),  Vector(-20,-1,-5), Vector(30,1,45) )
	DoorLHandler:SetSoundOpen( "vehicles/atv_ammo_open.wav" )
	DoorLHandler:SetSoundClose( "vehicles/atv_ammo_close.wav"  )
	DoorLHandler:LinkToSeat(SeatL2)
	
	self:AddEngineSound( Vector(50,0,145) )
	self:AddFuelTank( Vector(-110,0,100), Angle(0,0,0), 200, Vector(-15,-25,-30),Vector(35,25,30) )

	self.Rotor = self:AddRotor( Vector(0,0,175), Angle(5,0,2), 350, -4000 )
	self.Rotor:SetRotorEffects( true )
	self.Rotor:SetHP( 15 )
	function self.Rotor:OnDestroyed( base )
		base:DestroyEngine()
		base:SetBodygroup(19,1)
		self:EmitSound( "physics/metal/metal_box_break2.wav" )
	end

	self.TailRotor = self:AddRotor( Vector(-445,25,183.5), Angle(0,0,90), 80, -6000 )
	self.TailRotor:SetHP( 15 )
	function self.TailRotor:OnDestroyed( base )
		base:DestroySteering( 2.5 )
		base:SetBodygroup(18,1)
		self:EmitSound( "physics/metal/metal_box_break2.wav" )
	end

	local IDR = self:LookupAttachment( "muzzle_1" )
	local MuzzleR = self:GetAttachment( IDR )
	self.SNDTurretR = self:AddSoundEmitter( self:WorldToLocal( MuzzleR.Pos ), "sw/vehicles/weapons/upk23_loop.wav", "sw/vehicles/weapons/zsu234_interior_loop.wav" )
	self.SNDTurretR:SetSoundLevel( 95 )
	self.SNDTurretR:SetParent( self, IDR )

	local IDL = self:LookupAttachment( "muzzle_2" )
	local MuzzleL = self:GetAttachment( IDL )
	self.SNDTurretL = self:AddSoundEmitter( self:WorldToLocal( MuzzleL.Pos ), "sw/vehicles/weapons/upk23_loop.wav", "sw/vehicles/weapons/zsu234_interior_loop.wav" )
	self.SNDTurretL:SetSoundLevel( 95 )
	self.SNDTurretL:SetParent( self, ID )

	self.SNDTurretRStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleR.Pos ), "sw/vehicles/weapons/upk23_lastshot.wav", "sw/vehicles/weapons/zsu234_interior_lastshot.wav" )
	self.SNDTurretRStop:SetSoundLevel( 95 )
	self.SNDTurretRStop:SetParent( self, IDR )

	self.SNDTurretLStop = self:AddSoundEmitter( self:WorldToLocal( MuzzleL.Pos ), "sw/vehicles/weapons/upk23_lastshot.wav", "sw/vehicles/weapons/zsu234_interior_lastshot.wav" )
	self.SNDTurretLStop:SetSoundLevel( 95 )
	self.SNDTurretLStop:SetParent( self, ID )

	
	self.SNDUpk = self:AddSoundEmitter( Vector(9,0,71), "sw/vehicles/weapons/upk23_loop.wav", "sw/vehicles/weapons/zsu234_interior_loop.wav" )
	self.SNDUpk:SetSoundLevel( 95 )
	self.SNDUpk:SetParent( self )

	self.SNDUpkStop = self:AddSoundEmitter( Vector(9,0,71), "sw/vehicles/weapons/upk23_lastshot.wav", "sw/vehicles/weapons/zsu234_interior_lastshot.wav" )
	self.SNDUpkStop:SetSoundLevel( 95 )
	self.SNDUpkStop:SetParent( self )

	self.SNDRktL = self:AddSoundEmitter( Vector(-6,64.5,65.75), "sw/rocket/rocket_start_01.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDRktL:SetSoundLevel( 95 )
	self.SNDRktL:SetParent( self )

	self.SNDRktR = self:AddSoundEmitter( Vector(-6,-63.35,61), "sw/rocket/rocket_start_01.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDRktR:SetSoundLevel( 95 )
	self.SNDRktR:SetParent( self )

	self.SNDMsl = self:AddSoundEmitter( Vector(-6,0,52.7), "sw/rocket/wpn_atgm_close_fire_01.wav", "sw/rocket/wpn_atgm_int_fire_01.wav" )
	self.SNDMsl:SetSoundLevel( 95 )
	self.SNDMsl:SetParent( self )
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
	if self:GetLoadout() == 1 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b8v20.mdl")
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
	elseif self:GetLoadout() == 2 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b13.mdl")
						pod:SetBodygroup(1,1)
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
	elseif self:GetLoadout() == 3 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/upk23.mdl")
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
	elseif self:GetLoadout() == 4 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b8v20.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m114_launcher.mdl")
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
	elseif self:GetLoadout() == 5 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b13.mdl")
						pod:SetBodygroup(1,1)
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m114_launcher.mdl")
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
	elseif self:GetLoadout() == 6 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/upk23.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m114_launcher.mdl")
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
	elseif self:GetLoadout() == 7 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b8v20.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m120_launcher.mdl")
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
	elseif self:GetLoadout() == 8 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b13.mdl")
						pod:SetBodygroup(1,1)
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m120_launcher.mdl")
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
	elseif self:GetLoadout() == 9 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/upk23.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m120_launcher.mdl")
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
	elseif self:GetLoadout() == 10 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b8v20.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m39_launcher.mdl")
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
	elseif self:GetLoadout() == 11 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/b13.mdl")
						pod:SetBodygroup(1,1)
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m39_launcher.mdl")
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
	elseif self:GetLoadout() == 12 then
		self:RemoveLoadouts()
		if istable(self.Pylons) then
			self.Pods = {}
			for k,v in pairs(self.Pylons) do
				if (b && k <= b) or true then
					if k > 0 and k <= 2 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/upk23.mdl")
						pod:SetPos(self:LocalToWorld(v))
						pod:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
						pod:Spawn()
						pod:Activate()
						pod:SetParent(self)
						table.insert( self.Pods, pod )
					end
					if k > 2 and k <= 4 then
						local pod = ents.Create("prop_dynamic")
						pod:SetModel("models/sw/rus/weapons/9m39_launcher.mdl")
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
	end
end

--Think
function ENT:OnTick()
	local loadout = self:GetLoadout()
	if loadout >= 1 then
		if not (self.OldLoadout == loadout) then
			self:RemoveWeapon(1)
			self:RemoveWeapon(2)
			self:AddLoadouts(6)
			self:SetNWInt("Loadout",loadout)
			self:InitWeapons()
		end
	end
	self.OldLoadout = loadout
	local HP = self:GetHP()
	local MaxHP = self:GetMaxHP()

	if HP <= MaxHP/2 then
		if self:GetSkin() == 0 then
			self:SetSkin(1)
		end
		if self:GetSkin() == 2 then
			self:SetSkin(3)
		end
		if self:GetSkin() == 4 then
			self:SetSkin(5)
		end
		if self:GetSkin() == 6 then
			self:SetSkin(7)
		end
		if self:GetSkin() == 8 then
			self:SetSkin(9)
		end
		if self:GetSkin() == 10 then
			self:SetSkin(11)
		end
		if self:GetSkin() == 12 then
			self:SetSkin(13)
		end
	else
		if self:GetSkin() == 1 then
			self:SetSkin(0)
		end
		if self:GetSkin() == 3 then
			self:SetSkin(2)
		end
		if self:GetSkin() == 5 then
			self:SetSkin(4)
		end
		if self:GetSkin() == 7 then
			self:SetSkin(6)
		end
		if self:GetSkin() == 9 then
			self:SetSkin(8)
		end
		if self:GetSkin() == 11 then
			self:SetSkin(10)
		end
		if self:GetSkin() == 13 then
			self:SetSkin(12)
		end
	end

	if IsValid(self) then
		if self:GetEngineActive() then
			for k, v in pairs(ents.FindInSphere(self:GetPos(),3500)) do
				if v.GuidanceActive and v.Fired and v.Launcher != self and v != self:GetNWEntity("Missile") then
					if IsValid(v) then
						self.AlarmSND = CreateSound(self, "sw/misc/lock.wav")
						self.AlarmSND:PlayEx( 1, 120 )
						self.AlarmSND:ChangeVolume( 1, 1 )
						self.AlarmSND:SetSoundLevel( 120 )
					else
						if self.AlarmSND then
							self.AlarmSND:Stop()
							self.AlarmSND = nil
						end
					end				
				end
			end
		end
	end
end

--Seeker
function ENT:Seeker()
	if IsValid(self) then
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
				self.LockSND = CreateSound(self, "sw/misc/lock.wav")
				self.LockSND:PlayEx( 1, 50 )		
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
				if ((v.LFS and v:GetEngineActive()) or (v.LVS and (v:GetVehicleType() == "helicopter" or v:GetVehicleType() == "plane") and v:GetEngineActive()) or (v.isWacAircraft and v.active)) then						
					table.insert( self.FoundVehicles, v )
				end
			end
		end
		
		if self.guided_nextThink < curtime then
			self.guided_nextThink = curtime + 0.25
			self.FoundVehicles = self.FoundVehicles or {}
			local AimForward = self:GetAimVector()
			local startpos = self:LocalToWorld(Vector(250,0,50))
	
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
					self.TrackSND = CreateSound(self, "sw/misc/track.wav")
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
	local startpos = self:LocalToWorld(Vector(250,0,50))

	local pos = entity:GetPos()
	local tr = util.TraceLine( {
		start = startpos,
		endpos = pos,
	} )
	if not (tr.HitWorld or tr.HitSky)then
		return (tr.HitPos - pos):Length() < 75000
	else
		return false
	end
end
function ENT:OnRemove()
	self:SetIsLocked(false)
	if self.TrackSND then
		self.TrackSND:Stop()
	end
	if self.LockSND then
		self.LockSND:Stop()
	end
end

--Engine sound
function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "sw/mi24a/engine_start.wav" )
	else
		self:EmitSound( "sw/mi24a/engine_stop.wav" )
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