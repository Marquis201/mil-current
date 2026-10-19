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
	self:SetNWInt("APSCharges",12)

	--Turret
	self:MakeTurretPhysics()

	-- engine
	self:AddEngine( Vector(-105,0,60), Angle(0,0,0), Vector(-15,-40,-25),Vector(40,40,0) )
	
	-- fuel tank
	self:AddFuelTank( Vector(75,-35,40), Angle(0,0,0), 800, LVS.FUELTYPE_DIESEL, Vector(-25,-15,13),Vector(30,15,-15) )

	-- driver viewport weakstop
	self:AddDriverViewPort( Vector(89,0,63.35), Angle(0,0,0), Vector(-3,-5,-3), Vector(3,5,3) )

	-- ammo rack weakspot
	local IDT = self:LookupAttachment( "turret" )
	local Turret = self:GetAttachment( IDT )
	self:AddAmmoRack( self:WorldToLocal(Turret.Pos-Turret.Ang:Up()*28), self:WorldToLocal(Turret.Pos), Angle(0,0,0), Vector(-40,-40,-10), Vector(40,40,10) )
	
	local DriverSeat = self:AddDriverSeat( Vector(85,0,25), Angle(0,-90,0) )
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

	local CommanderWeapon = CommanderSeat:lvsGetWeapon()
	if IsValid( CommanderWeapon ) then
		CommanderWeapon:UnlockAimVector()
	end

	local HatchDHandler = self:AddDoorHandler( "!hatch_driver", Vector(72.45,0,65), Angle(0,0,0), Vector(-8,-15,-5), Vector(8,15,5), Vector(-8,-15,-5), Vector(8,15,5) )
	HatchDHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchDHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchDHandler:LinkToSeat(DriverSeat)

	local HatchGHandler = self:AddDoorHandler( "!hatch_gunner", Vector(-21.8,24.9,95), Angle(0,0,0), Vector(-12,-12,-5), Vector(12,12,5), Vector(-12,-12,-5), Vector(12,12,5) )
	HatchGHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchGHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchGHandler:LinkToSeat(GunnerSeat)
	HatchGHandler:SetParent( self, self:LookupAttachment( "turret" ) )

	local HatchCHandler = self:AddDoorHandler( "!hatch_commander", Vector(-10.95,-31.28,103), Angle(0,0,0), Vector(-12,-12,-5), Vector(12,12,5), Vector(-12,-12,-5), Vector(12,12,5) )
	HatchCHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	HatchCHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	HatchCHandler:LinkToSeat(CommanderSeat)
	HatchCHandler:SetParent( self, self:LookupAttachment( "turret" ) )
	self.TurrHatchHandler = HatchCHandler

	self:AddArmor( Vector(88.95,0,51.841), Angle(0,0,0), Vector(-58.085,-51.1,-14.883), Vector(58.085,51.1,14.883), 2500, 71000 )
	self:AddArmor( Vector(88.95,0,27.539), Angle(0,0,0), Vector(-58.085,-51.1,-9.419), Vector(58.085,51.1,9.419), 2500, 21000 )
	self:AddArmor( Vector(-8,0,42.06), Angle(0,0,0), Vector(-50,-51.1,-23.35), Vector(50,51.1,23.35), 2500, 6000 )
	self:AddArmor( Vector(-108.18,0,42.06), Angle(0,0,0), Vector(-50,-51.1,-23.35), Vector(50,51.1,23.35), 2500, 1000 )
	self:AddArmor( Vector(5.236,-63.68,53.51), Angle(0,0,0), Vector(-152.475,-19.24,-15.15), Vector(152.475,19.24,15.15), 2500, 15000 )
	self:AddArmor( Vector(-6.3245,63.68,53.51), Angle(0,0,0), Vector(-163.93,-19.24,-15.15), Vector(163.93,19.24,15.15), 2500, 15000 )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	local IDC = self:LookupAttachment( "muzzle_coax" )
	local MuzzleC = self:GetAttachment( IDC )
	local IDM = self:LookupAttachment( "muzzle_mg" )
	local MuzzleRWS = self:GetAttachment( IDM )
	local IDS1 = self:LookupAttachment( "smoke_1" )
	local Smoke1 = self:GetAttachment( IDS1 )
	local IDS2 = self:LookupAttachment( "smoke_2" )
	local Smoke2 = self:GetAttachment( IDS2 )

	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "sw/t90m/cannon_fire.wav", "sw/t90m/cannon_fire_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_loop.wav", "sw/vehicles/weapons/pkt_interior_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, IDC )

	self.SNDMGRldInt = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/vehicles/mg_reload.wav" )
	self.SNDMGRldInt:SetSoundLevel( 95 )
	self.SNDMGRldInt:SetParent( self, IDT )

	self.SNDTurretMGstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleC.Pos ), "sw/vehicles/weapons/pkt_lastshot.wav", "sw/vehicles/weapons/pkt_interior_lastshot.wav" )
	self.SNDTurretMGstop:SetSoundLevel( 95 )
	self.SNDTurretMGstop:SetParent( self, IDC )

	self.SNDTurretRWS = self:AddSoundEmitter( self:WorldToLocal( MuzzleRWS.Pos ), "sw/vehicles/weapons/kord_loop.wav", "sw/vehicles/weapons/kord_interior_loop.wav" )
	self.SNDTurretRWS:SetSoundLevel( 95 )
	self.SNDTurretRWS:SetParent( self, IDM )

	self.SNDTurretRWSstop = self:AddSoundEmitter( self:WorldToLocal( MuzzleRWS.Pos ), "sw/vehicles/weapons/kord_lastshot.wav", "sw/vehicles/weapons/kord_interior_lastshot.wav" )
	self.SNDTurretRWSstop:SetSoundLevel( 95 )
	self.SNDTurretRWSstop:SetParent( self, IDM )

	self.SNDTurretRld = self:AddSoundEmitter( self:WorldToLocal( Turret.Pos ), "", "sw/t90m/reload.wav" )
	self.SNDTurretRld:SetSoundLevel( 95 )
	self.SNDTurretRld:SetParent( self, IDT )

	self.SNDSmoke1 = self:AddSoundEmitter( self:WorldToLocal( Smoke1.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke1:SetSoundLevel( 95 )
	self.SNDSmoke1:SetParent( self, IDS1 )

	self.SNDSmoke2 = self:AddSoundEmitter( self:WorldToLocal( Smoke2.Pos ), "sw/vehicles/weapons/smoke_grenade_launcher_1.wav", "sw/vehicles/weapons/smoke_grenade_launcher_interior_1.wav" )
	self.SNDSmoke2:SetSoundLevel( 95 )
	self.SNDSmoke2:SetParent( self, IDS2 )

	self.SNDEngineStart = self:AddSoundEmitter( self:GetPos(), "sw/t90m/engine_start.wav", "sw/t90m/engine_start_int.wav" )
	self.SNDEngineStart:SetSoundLevel( 95 )
	self.SNDEngineStart:SetParent( self )
	
	self.SNDEngineStop = self:AddSoundEmitter( self:GetPos(), "sw/t90m/engine_stop.wav", "sw/t90m/engine_stop_int.wav" )
	self.SNDEngineStop:SetSoundLevel( 95 )
	self.SNDEngineStop:SetParent( self )
end

function ENT:MakeTurretPhysics()
	local Turret = self:CreateTurretPhysics( {
		follow = "turret",
		mdl = "models/sw/ground/t90m/turret_physics_arena.mdl",
	} )
	self:SetTurretArmor( Turret )

	local IDT = self:LookupAttachment( "turret" )
	local TurretAtt = self:GetAttachment( IDT )
	
	local CheekRArmor = self:AddArmor( Vector(45.886,-52.07,15.663), Angle(0,0,0), Vector(-34.725,-33.325,-16.262), Vector(34.725,33.325,16.262), 2500, 126000, Turret )
	CheekRArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	CheekRArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local CheekLArmor = self:AddArmor( Vector(45.886,49.435,15.663), Angle(0,0,0), Vector(-34.725,-35.8,-16.262), Vector(34.725,35.8,16.262), 2500, 126000, Turret )
	CheekLArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	CheekLArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local MaskArmor = self:AddArmor( Vector(60.687,-2.6547,15.663), Angle(0,0,0), Vector(-18.310,-16.177,-13.723), Vector(18.310,16.177,13.723), 2500, 16000, Turret )
	MaskArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	MaskArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local Mask2Armor = self:AddArmor( Vector(26.597,-2.6547,15.663), Angle(0,0,0), Vector(-15.495,-16.177,-16.262), Vector(15.495,16.177,16.262), 2500, 76000, Turret )
	Mask2Armor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	Mask2Armor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local SideArmor = self:AddArmor( Vector(-35.138,0,13.828), Angle(0,0,0), Vector(-46.417,-79.862,-13.975), Vector(46.417,79.862,13.975), 2500, 24500, Turret )
	SideArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	SideArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local RearArmor = self:AddArmor( Vector(-113.95,0,17.66), Angle(0,0,0), Vector(-35.61,-57.554,-11.416), Vector(35.61,57.554,11.416), 2500, 500, Turret )
	RearArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	RearArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end

	local TopArmor = self:AddArmor( Vector(-35.138,0,30.087), Angle(0,0,0), Vector(-46.417,-57.265,-2.258), Vector(46.417,57.265,2.258), 2500, 800, Turret )
	RearArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	RearArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
end

function ENT:OnTick()
	self:AimTurret()
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
	
		if self:GetAPS() then
			if self:GetNWInt("APSCharges") > 0 then
				local ID = self:LookupAttachment( "turret" )
				local Turret = self:GetAttachment( ID )		
				
				for k, e in pairs( ents.FindInCone(Turret.Pos,Turret.Ang:Forward(),5000,math.cos(math.rad(120))) ) do
					if e != self and e.IsRocket == true and e.Armed == true and e.Launcher != self then
						if IsValid( e ) then
							self.AlertSound = CreateSound(self, "sw/aps/alert.wav")
							self.AlertSound:PlayEx( 1, 100 )
							self:SetNWEntity("APSTarget",e)
							if Turret.Pos:Distance(e:GetPos()) < 1500 then
								local tr = util.TraceLine( {
									start = Turret.Pos,
									endpos = e:GetPos(),
								} )
								if tr.Hit and not tr.HitWorld and not tr.HitSky then
									if e:GetNWBool("APSFired") then return end
									self:FireAPS(self:GetNWEntity("APSTarget"))
									self:SetNWInt("APSCharges",self:GetNWInt("APSCharges")-1)
								end
							end
						else
							if self.AlertSound then
								self.AlertSound:Stop()
							end
						end
					elseif e.Target == self or e.Engaged then
						if IsValid( e ) then
							self.AlertSound = CreateSound(self, "sw/aps/alert.wav")
							self.AlertSound:PlayEx( 1, 100 )
							self:SetNWEntity("APSTarget",e)
							if Turret.Pos:Distance(e:GetPos()) < 1500 then
								local tr = util.TraceLine( {
									start = Turret.Pos,
									endpos = e:GetPos(),
									filter = ent
								} )
								if tr.Hit and not tr.HitWorld and not tr.HitSky then
									if e:GetNWBool("APSFired") then return end
									self:FireAPS(self:GetNWEntity("APSTarget"))
									self:SetNWInt("APSCharges",self:GetNWInt("APSCharges")-1)
								end
							end
						else
							if self.AlertSound then
								self.AlertSound:Stop()
							end
						end
					elseif ( IsValid(e) ) and e:GetClass() == "rpg_missile" then 
						if IsValid( e ) then
							self.AlertSound = CreateSound(self, "sw/aps/alert.wav")
							self.AlertSound:PlayEx( 1, 100 )
							self:SetNWEntity("APSTarget",e)
							if Turret.Pos:Distance(e:GetPos()) < 1500 then
								local tr = util.TraceLine( {
									start = Turret.Pos,
									endpos = e:GetPos(),
									filter = ent
								} )
								if tr.Hit and not tr.HitWorld and not tr.HitSky then
									if e:GetNWBool("APSFired") then return end
									self:FireAPS(self:GetNWEntity("APSTarget"))
									self:SetNWInt("APSCharges",self:GetNWInt("APSCharges")-1)
								end
							end
						else
							if self.AlertSound then
								self.AlertSound:Stop()
							end
						end
					end
				end
			end
		end
	end
end
function ENT:FireAPS(target)
	if IsValid(target) then
		self._MuzzleID = self._MuzzleID and self._MuzzleID + 1 or 1
		if self._MuzzleID > 2 then
			self._MuzzleID = 1
		end
		local ID = self:LookupAttachment( "smoke_"..self._MuzzleID )
		local Attachment = self:GetAttachment( ID )
	
		if not Attachment then return end
		ParticleEffect("muzzleflash_m590_3rd",Attachment.Pos,Attachment.Ang,nil)
	
		if(target:WaterLevel() >= 1) then
			ParticleEffect("ins_water_explosion",target:GetPos(),Angle(0,0,0), nil)   
		else			   
			ParticleEffect("ins_rpg_explosion",target:GetPos(),Angle(0,0,0), nil)   
		end
		target:SetAngles(Angle(0,0,90))
		util.BlastDamage( self, self, target:GetPos(), 150, 2500 )
		local d = DamageInfo()
		d:SetDamage( 100 )
		d:SetAttacker(self)
		d:SetDamageType( DMG_MISSILEDEFENSE )
		target:TakeDamageInfo( d )
		target:SetNWBool("APSFired",true)
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
function ENT:OnMaintenance()
	self:SetNWInt("APSCharges",12)
end
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