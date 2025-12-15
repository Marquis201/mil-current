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

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 100 )
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
				local pos, ang = posang[1]*40, posang[2]
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
		if loadout == 2 or loadout == 3 then
			self:SetAmmoPrimary(800)
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
	Hidden = Color(255,255,255,0)
	Shown = Color(255,255,255,255)

	pod = self:AddPassengerSeat( Vector(50,14,-15), Angle(0, -90, 0) )
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
		[2] = {
			Vector(0.982189,1.48973,-0.637525),
			Vector(0.982189,-1.48973,-0.637525),
		},
		[3] = {
			Vector(0.789579,1.48973,-0.637525),
			Vector(0.789579,-1.48973,-0.637525),
		},
	}

	for k, pose in ipairs(poses[loadout]) do
		local pos = self:LocalToWorld(pose*40)
		self:TakePrimaryAmmo()

		local Tracer_UPK = self:UpdateTracers_UPK()
		local num = 0.3
		local ang = (self:GetAngles() + Angle(math.Rand(-num,num), math.Rand(-num,num), math.Rand(-num,num)))
		gred.CreateBullet(Driver,pos,ang,"wac_base_12mm",self.FILTER,nil,false,Tracer_UPK,20)

		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetAngles(ang)
		effectdata:SetEntity(self)
		util.Effect("gred_particle_aircraft_muzzle",effectdata)
	end

	self:SetNextPrimary(0.05)
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
		ent:SetAngles( self:LocalToWorldAngles( Angle(0,Ang,0) ) )
		ent:Spawn()
		ent:Activate()
		ent:SetOwner(self:GetDriver())
		ent.phys = ent:GetPhysicsObject()
		local p = self:GetPhysicsObject() 
		if IsValid(p) and IsValid(ent.phys) then ent.phys:AddVelocity(p:GetVelocity()) end
		constraint.NoCollide(self, ent, 0, 0)
		ent:Launch()

		self:TakeSecondaryAmmo(1)
		self:SetNextSecondary(0.5)

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
	local Loadout = self:GetLoadout()
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK ) and Loadout != 0
		end
		if self:GetAmmoSecondary() > 0 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
		self.Firing = Fire2
	end
	
	if Fire1 then
		self:PrimaryAttack()
	end
	
	if Fire2 then
		self:SecondaryAttack()
	end
	
	if self.OldFire ~= Fire1 then
		
		if Fire1 then
			self.wpn1 = CreateSound( self, "GRDN_M3_FIRE_LOOP" )
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
					
				self:EmitSound( "GRDN_M3_FIRE_LASTSHOT" .. math.random(1, 3) )
			end
		end
		
		self.OldFire = Fire1
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