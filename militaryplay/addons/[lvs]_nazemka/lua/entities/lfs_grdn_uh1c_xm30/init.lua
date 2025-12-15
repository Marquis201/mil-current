AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

local tracer_upk = 0
local Tracer_upk = false
function ENT:UpdateTracers_UPK()
	tracer_upk = tracer_upk + 1
	if tracer_upk >= self.TracerConvar:GetInt() then
		tracer_upk = 0
		return "red"
	else
		return false
	end
end

local tracer_shkas = 0
function ENT:UpdateTracers_SHKAS()
	tracer_shkas = tracer_shkas + 1
	if tracer_shkas >= self.TracerConvar:GetInt() then
		tracer_shkas = 0
		return "red"
	else
		return false
	end
end
local Tracer_m2 = false

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 150 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick()
	local PrimaryAmmo = self:GetAmmoPrimary()
	local SecondaryAmmo = self:GetAmmoSecondary()

	local loadout = self:GetLoadout()
	
	if loadout != self.OldLoadout then
		if loadout == 0 then
			self:SetAmmoSecondary(0)
			self:ResetBodygroups()
			self:ResetMissiles()
		else
			local loadoutData = self.MISSILES[loadout]
			self:SetAmmoSecondary(loadoutData.ammo)

			self:ResetBodygroups()
			for k, bgInfo in pairs(loadoutData.bodygroups) do
				self:SetBodygroup(bgInfo[1], bgInfo[2])
			end

			self:ResetMissiles()
			for k, posang in pairs(loadoutData.posang) do
				local pos, ang = posang[1], posang[2]
				local Missile = ents.Create( "prop_dynamic" )
				Missile:SetModel( loadoutData.model )
				Missile:SetPos( self:LocalToWorld(pos) )
				Missile:SetAngles( self:GetAngles() + ang )
				Missile:SetMoveType( MOVETYPE_NONE )
				Missile:Spawn()
				Missile:Activate()
				Missile:SetNotSolid( true )
				Missile:DrawShadow( false )
				Missile:SetParent( self )
				Missile.DoNotDuplicate = true
				Missile:SetRenderMode(RENDERGROUP_TRANSLUCENT)
				self:dOwner( Missile )
					
				table.insert( self.MissileEnts, Missile )
			end
		end
		if loadout == 3 then
			self:SetAmmoPrimary(12000)
		elseif loadout == 4 then
			self:SetAmmoPrimary(3000)
		elseif loadout == 5 then
			self:SetAmmoPrimary(1200)
		else
			self:SetAmmoPrimary(0)
		end
	elseif SecondaryAmmo > self.OldSecAmmo and loadout != 0 then
		local loadoutData = self.MISSILES[loadout]
		self:SetAmmoSecondary(loadoutData.ammo)

		self:ResetBodygroups()
		for k, bgInfo in pairs(loadoutData.bodygroups) do
			self:SetBodygroup(bgInfo[1], bgInfo[2])
		end

		self:ResetMissiles()
		for k, posang in pairs(loadoutData.posang) do
			if k > SecondaryAmmo then continue end
			local pos, ang = posang[1], posang[2]
			local Missile = ents.Create( "prop_dynamic" )
			Missile:SetModel( loadoutData.model )
			Missile:SetPos( self:LocalToWorld(pos) )
			Missile:SetAngles( self:GetAngles() + ang )
			Missile:SetMoveType( MOVETYPE_NONE )
			Missile:Spawn()
			Missile:Activate()
			Missile:SetNotSolid( true )
			Missile:DrawShadow( false )
			Missile:SetParent( self )
			Missile.DoNotDuplicate = true
			Missile:SetRenderMode(RENDERGROUP_TRANSLUCENT)
			self:dOwner( Missile )
				
			table.insert( self.MissileEnts, Missile )
		end
	end

	self.OldGunner = gunner
	self.OldLoadout = loadout
	self.OldPriAmmo = PrimaryAmmo
	self.OldSecAmmo = SecondaryAmmo

	local driverSeat, gunnerSeat = self:GetDriverSeat(), self:GetGunnerSeat()
	local driver, gunner = self:GetDriver(), gunnerSeat:GetDriver()

	if IsValid(gunner) then
		local eyeAngles = gunner:EyeAngles()
		local seatAngles = gunnerSeat:WorldToLocalAngles(eyeAngles)
		local turretAngles = self:WorldToLocalAngles(seatAngles)

		local yaw, pitch = math.Clamp(turretAngles.y, -75, 75), math.Clamp(turretAngles.p, -20, 20)

		self:SetPoseParameter("turret_yaw", yaw)
		self:SetPoseParameter("turret_pitch", pitch)
	elseif IsValid(driver) then
		local eyeAngles = driver:EyeAngles()
		local seatAngles = driverSeat:WorldToLocalAngles(eyeAngles)
		local turretAngles = self:WorldToLocalAngles(seatAngles)

		local yaw, pitch = math.Clamp(turretAngles.y, -75, 75), math.Clamp(turretAngles.p, -20, 20)

		self:SetPoseParameter("turret_yaw", yaw)
		self:SetPoseParameter("turret_pitch", pitch)
	end
end

function ENT:ResetBodygroups()
	for i=1, 6 do
		self:SetBodygroup(i, 0)
	end
end

function ENT:ResetMissiles()
	if not self.MissileEnts then self.MissileEnts = {} return end
	if #self.MissileEnts == 0 then return end
	for k, missile in ipairs(self.MissileEnts) do
		if IsValid(missile) then
			missile:Remove()
		end
	end
	self.MissileEnts = {}
end

function ENT:RunOnSpawn()
	self.TracerConvar = GetConVar("gred_sv_tracers")
	self.nextTurretFire = CurTime()
	self.nextGunnerAim = CurTime()
	Hidden = Color(255,255,255,0)
	Shown = Color(255,255,255,255)

	pod = self:AddPassengerSeat( Vector(80,23.3904,-17), Angle(0, -90, 0) )
	self:SetGunnerSeat(pod)

	self.MissileEnts = {}
	self.FILTER = self
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local PrimaryAmmo = self:GetAmmoPrimary()
	local loadout = self:GetLoadout()
	
	local poses = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {Vector(0.748666, 2.14445, -0.479032), Vector(0.748666, -2.14445, -0.479032)},
		[4] = {Vector(1.143, 1.65244, -0.722582), Vector(1.143, -1.65244, -0.722582)},
		[5] = {Vector(1.55406, 1.77615, -0.552474), Vector(1.55406, -1.77615, -0.552474)},
	}

	for k, pose in ipairs(poses[loadout]) do
		local pos = self:LocalToWorld(pose*40)
		self:TakePrimaryAmmo()

		local Tracer_SHKAS = self:UpdateTracers_SHKAS()
		local num = 0.3
		local ang = (self:GetAngles() + Angle(math.Rand(-num,num), math.Rand(-num,num), math.Rand(-num,num)))

		if loadout == 5 then
			gred.CreateBullet(Driver,pos,ang,loadout == 5 and "wac_base_30mm" or "wac_base_7mm",self.FILTER,nil,false,Tracer_SHKAS,20)
		else
			local bullet = {}
			bullet.Num 	= 1
			bullet.Src 	= pos
			bullet.Dir 	= ang:Forward()
			bullet.Spread 	= Vector( 0.02,  0.02, 0 )
			bullet.Tracer	= 1
			bullet.TracerName	= "lfs_tracer_red"
			bullet.Force	= 10
			bullet.HullSize 	= 5
			bullet.Damage	= 30
			bullet.Attacker 	= Driver
			bullet.AmmoType = "Pistol"
			bullet.Callback = function(att, tr, dmginfo)
				dmginfo:SetDamageType(DMG_AIRBOAT)
			end
			
			self:FireBullets( bullet )
		end

		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetAngles(ang)
		effectdata:SetEntity(self)
		effectdata:SetAttachment(11)
		util.Effect("gred_particle_aircraft_muzzle",effectdata)
	end

	self:SetNextPrimary(0.05)
end

function ENT:TurretAttack()
	if self:GetTurretAmmo() <= 0 or CurTime() < self.nextTurretFire then return end
	
	local Driver = self:GetDriver()
	local Gunner = self:GetGunnerSeat():GetDriver()

	local Tracer_UPK = self:UpdateTracers_UPK()
	local num = 0.3
	local pos = self:GetAttachment(1).Pos
	local ang = (self:GetAttachment(1).Ang + Angle(math.Rand(-num,num), math.Rand(-num,num), math.Rand(-num,num)))
	timer.Simple(0.5, function()
		gred.CreateBullet(Driver,pos,ang,"wac_base_40mm",self.FILTER,nil,false,Tracer_UPK,20)
	end)
	
	self:SetTurretAmmo(self:GetTurretAmmo() - 1)

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetAngles(ang)
	effectdata:SetEntity(self)
	effectdata:SetAttachment(11)
	util.Effect("gred_particle_aircraft_muzzle",effectdata)

	self.nextTurretFire = CurTime() + 60/625
end

function ENT:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	local SecondaryAmmo = self:GetAmmoSecondary()
	local Loadout = self:GetLoadout()
	if Loadout == 0 then return end
	local LoadoutData = self.MISSILES[Loadout]

	if not (SecondaryAmmo <= 0) then
		local ent = ents.Create(LoadoutData.entity)
		local mPos = self:LocalToWorld(LoadoutData.posang[SecondaryAmmo][1])
		local Ang = self:WorldToLocal( mPos ).y > 0 and -1 or 1
		ent:SetPos( mPos )
		ent.IsOnPlane = true
		ent:SetAngles( self:LocalToWorldAngles( Angle(-2,0,0) ) )
		ent:Spawn()
		ent:Activate()
		ent:SetOwner(self:GetDriver())
		ent.phys = ent:GetPhysicsObject()
		local p = self:GetPhysicsObject() 
		if IsValid(p) and IsValid(ent.phys) then ent.phys:AddVelocity(p:GetVelocity()) end
		constraint.NoCollide(self, ent, 0, 0)
		ent:Launch()

		self:TakeSecondaryAmmo(1)
		self:SetNextSecondary(0.2)

		if LoadoutData.caps_bodygroup then self:SetBodygroup(LoadoutData.caps_bodygroup, 0) end

		self.MissileEnts[SecondaryAmmo]:Remove()
	end
end

function ENT:ReloadWeapon()
	local loadout = self:GetLoadout()
	if loadout == 0 then
		self:SetAmmoSecondary(0)
		self:ResetBodygroups()
		self:ResetMissiles()
		return
	end
	local loadoutData = self.MISSILES[loadout]
	self:SetAmmoSecondary(loadoutData.ammo)

	self:ResetBodygroups()
	for k, bgInfo in pairs(loadoutData.bodygroups) do
		self:SetBodygroup(bgInfo[1], bgInfo[2])
	end

	self:ResetMissiles()
	for k, posang in pairs(loadoutData.posang) do
		local pos, ang = posang[1], posang[2]
		local Missile = ents.Create( "prop_dynamic" )
		Missile:SetModel( loadoutData.model )
		Missile:SetPos( self:LocalToWorld(pos) )
		Missile:SetAngles( self:GetAngles() + ang )
		Missile:SetMoveType( MOVETYPE_NONE )
		Missile:Spawn()
		Missile:Activate()
		Missile:SetNotSolid( true )
		Missile:DrawShadow( false )
		Missile:SetParent( self )
		Missile.DoNotDuplicate = true
		Missile:SetRenderMode(RENDERGROUP_TRANSLUCENT)
		self:dOwner( Missile )
			
		table.insert( self.MissileEnts, Missile )
	end

	self:OnReloadWeapon()
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:OnEngineStarted()
end

function ENT:OnEngineStopped()
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()
	local gunnerSeat = self:GetGunnerSeat()
	local gunner = gunnerSeat:GetDriver()
	local Loadout = self:GetLoadout()
	local FireT = false
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK ) and Loadout != 0
		end
		if self:GetAmmoSecondary() > 0 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
		if self:GetTurretAmmo() > 0 then
			FireT = Driver:KeyDown( IN_ATTACK )
		end
		self.Firing = Fire2
	end
	if IsValid(gunner) then
		if self:GetTurretAmmo() > 0 then
			FireT = gunner:KeyDown( IN_ATTACK )
		end
		if self.nextGunnerAim < CurTime() and gunner:KeyDown(IN_ATTACK2) then
			self:SetIsGunnerAiming(not self:GetIsGunnerAiming())
			self.nextGunnerAim = CurTime() + 0.5
		end
	end
	
	if Fire1 then
		self:PrimaryAttack()
	end

	if FireT then
		self:TurretAttack()
	end
	
	if Fire2 then
		self:SecondaryAttack()
	end
	
	if self.OldFire ~= Fire1 then
		
		if Fire1 then
			self.wpn1 = CreateSound( self, Loadout != 5 and "GRDN_M134_FIRE_LOOP6K" or "GRDN_M3_FIRE_LOOP6K" )
			self.wpn1:Play()
			self:CallOnRemove( "stopmesounds1", function( ent )
				if ent.wpn1 then
					ent.wpn1:Stop()
				end
			end)
		else
			if self.OldFire == true then
				if self.wpn1 then
					self.wpn1:Stop()
				end
				self.wpn1 = nil
			end
		end
		
		self.OldFire = Fire1
	end

	if self.OldFireT ~= FireT then
		
		if FireT then
			self.wpnF = CreateSound( self, "GRDN_XM140_FIRE_LOOP" )
			self.wpnF:Play()
			self:CallOnRemove( "stopmesoundsF", function( ent )
				if ent.wpnF then
					ent.wpnF:Stop()
				end
			end)
		else
			if self.OldFireT == true then
				if self.wpnF then
					self.wpnF:Stop()
				end
				self.wpnF = nil
			end
		end
		
		self.OldFireT = FireT
	end
	
	if self.OldFire2 ~= Fire2 then
		if Fire2 then
			self:SecondaryAttack()
		end
		self.OldFire2 = Fire2
	end
end

function ENT:OnEngineStartInitialized()
	self:EmitSound( "grdn/engine/engineheli/start.wav")
end

function ENT:OnEngineStopInitialized()
	self:EmitSound( "grdn/engine/engineheli/stop.wav")
end

function ENT:OnRotorDestroyed()
	self:EmitSound( "physics/metal/metal_box_break2.wav" )
	
	self:SetHP(1)
	
	timer.Simple(2, function()
		if not IsValid( self ) then return end
		self:Destroy()
	end)
end

function ENT:OnRotorCollide( Pos, Dir )
	local effectdata = EffectData()
		effectdata:SetOrigin( Pos )
		effectdata:SetNormal( Dir )
	util.Effect( "manhacksparks", effectdata, true, true )

	self:EmitSound( "ambient/materials/roust_crash"..math.random(1,2)..".wav" )
end

function ENT:CheckRotorClearance()
	local angUp = self:GetRotorAngle()
	local Up = angUp:Up()
	local Forward = angUp
	Forward:RotateAroundAxis( Up, -CurTime() * 2000 )
	Forward = Forward:Forward()
	
	local position = self:GetRotorPos()

	local tr = util.TraceLine( {
		start = position,
		endpos = (position + Forward * self:GetRotorRadius()),
		filter = function( ent ) 
			if ent == self or ent:IsPlayer() then 
				return false
			end
			
			return true
		end
	} )
	
	self.RotorHitCount = self.RotorHitCount or 0
	
	if tr.Hit then
		self.RotorHit = true
		
		self.RotorHitCount = self.RotorHitCount + 1
	else 
		self.RotorHit = false
		
		self.RotorHitCount = math.max(self.RotorHitCount - 1 * FrameTime(),0)
	end
	
	if self.RotorHit ~= self.oldRotorHit then
		self.oldRotorHit = self.RotorHit
		if self.RotorHit then
			self:OnRotorCollide( tr.HitPos, tr.HitNormal )
		end
	end
end