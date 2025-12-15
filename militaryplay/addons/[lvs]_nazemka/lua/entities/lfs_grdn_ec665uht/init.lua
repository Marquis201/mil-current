--DO NOT EDIT OR REUPLOAD THIS FILE

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
	ent:SetPos( tr.HitPos + tr.HitNormal * 90 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick()
	local gunner = self:GetGunner()
	if IsValid(gunner) and gunner:Alive() then
		self.gunnerNextInput = self.gunnerNextInput or 0

		local verticalAxis = ((gunner:KeyDown(IN_FORWARD) and 1 or 0) - (gunner:KeyDown(IN_BACK)and 1 or 0)) * self:GetAimZoom()/70
		local horizontalAxis = ((gunner:KeyDown(IN_MOVERIGHT) and 1 or 0) - (gunner:KeyDown(IN_MOVELEFT)and 1 or 0)) * self:GetAimZoom()/70
		local zoomAxis = (gunner:KeyDown(IN_JUMP) and 1 or 0) - (gunner:KeyDown(IN_SPEED)and 1 or 0)
		local setMarker, gunnerFocus = gunner:KeyDown(IN_ATTACK), gunner:KeyDown(IN_ATTACK2)

		local aimH = self:GetAimH()+horizontalAxis

		self:SetAimV(math.Clamp(self:GetAimV()+verticalAxis, -50, 50))
		self:SetAimH(aimH)
		self:SetAimZoom(math.Clamp(self:GetAimZoom()+zoomAxis, 25, 80))

		self:SetPoseParameter("cam_yaw", self:GetAimH())
		self:SetPoseParameter("cam_pitch", self:GetAimV())

		if gunnerFocus and self.gunnerNextInput < CurTime() then
			self:SetGunnerFocus(not self:GetGunnerFocus())

			self.gunnerNextInput = CurTime() + 0.2
		end

		if setMarker and self.gunnerNextInput < CurTime() then
			local att = self:GetAttachment(self:LookupAttachment("cam_point"))
			local tr = util.QuickTrace(att.Pos, att.Ang:Forward()*50000, self)
			self:SetMarker(tr.HitPos)

			self.gunnerNextInput = CurTime() + 0.1
		end
	end

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
		if loadout == 1 then
			self:SetAmmoPrimary(1000)
		elseif loadout == 4 then
			self:SetAmmoPrimary(1000)
		elseif loadout == 5 then
			self:SetAmmoPrimary(500)
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

	local driver = self:GetDriver()

	if driver != self.OldDriver and IsValid(self.OldDriver) then
		local leftKnee, rightKnee = self.OldDriver:LookupBone("ValveBiped.Bip01_L_Calf"), self.OldDriver:LookupBone("ValveBiped.Bip01_R_Calf")
		if leftKnee and rightKnee then
			self.OldDriver:ManipulateBoneAngles(leftKnee, Angle(0, 0, 0))
			self.OldDriver:ManipulateBoneAngles(rightKnee, Angle(0, 0, 0))
		end
	end

	if driver:IsValid() then
		local leftKnee, rightKnee = driver:LookupBone("ValveBiped.Bip01_L_Calf"), driver:LookupBone("ValveBiped.Bip01_R_Calf")
		if leftKnee and rightKnee then
			driver:ManipulateBoneAngles(leftKnee, Angle(0, -50, 0))
			driver:ManipulateBoneAngles(rightKnee, Angle(-15, -50, -10))
		end
	end

	self.OldDriver = driver
	local gunner = self:GetGunner()

	if gunner != self.OldGunner and IsValid(self.OldGunner) then
		local leftKnee, rightKnee = self.OldGunner:LookupBone("ValveBiped.Bip01_L_Calf"), self.OldGunner:LookupBone("ValveBiped.Bip01_R_Calf")
		if leftKnee and rightKnee then
			self.OldGunner:ManipulateBoneAngles(leftKnee, Angle(0, 0, 0))
			self.OldGunner:ManipulateBoneAngles(rightKnee, Angle(0, 0, 0))
		end
	end

	if gunner:IsValid() then
		local leftKnee, rightKnee = gunner:LookupBone("ValveBiped.Bip01_L_Calf"), gunner:LookupBone("ValveBiped.Bip01_R_Calf")
		if leftKnee and rightKnee then
			gunner:ManipulateBoneAngles(leftKnee, Angle(15, -50, 10))
			gunner:ManipulateBoneAngles(rightKnee, Angle(0, -50, 0))
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

	pod = self:AddPassengerSeat( Vector(1,0,0.01)*40, Angle(0, -90, 0) )
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
		[1] = {
			Vector(1.37593,1.4182,-0.450804),
			Vector(1.37593,-1.4182,-0.450804),
		},
		[2] = {},
		[3] = {},
		[4] = {
			Vector(1.37593,1.4182,-0.450804),
			Vector(1.37593,-1.4182,-0.450804),
		},
		[5] = {
			Vector(1.37593,1.4182,-0.450804),
		},
	}

	for k, pose in ipairs(poses[loadout]) do
		local pos = self:LocalToWorld(pose*40)
		self:TakePrimaryAmmo()

		local Tracer_UPK = self:UpdateTracers_UPK()
		local num = 0.3
		local ang = (self:GetAngles() + Angle(math.Rand(-num,num), math.Rand(-num,num), math.Rand(-num,num)))
		gred.CreateBullet(Driver,pos,ang,"wac_base_20mm",self.FILTER,nil,false,Tracer_UPK,20)

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
		local mPos = self:LocalToWorld(LoadoutData.posang[SecondaryAmmo][1]*40)
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
	self:SetAmmoPrimary( self:GetMaxAmmoPrimary() )
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
					
				self:EmitSound( "GRDN_M3_FIRE_LASTSHOT" )
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

function ENT:ToggleLandingGear()
	self.LandingGearUp = not self.LandingGearUp
	
	self:OnLandingGearToggled( self.LandingGearUp )
end

function ENT:RaiseLandingGear()
	if not self.LandingGearUp then
		self.LandingGearUp = true
		
		self:OnLandingGearToggled( self.LandingGearUp )
	end
end

function ENT:DeployLandingGear()
	if self.LandingGearUp then
		self.LandingGearUp = false
		
		self:OnLandingGearToggled( self.LandingGearUp )
	end
end

function ENT:HandleLandingGear()
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		local KeyJump = Driver:lfsGetInput( "VSPEC" )
		
		if self.OldKeyJump ~= KeyJump then
			self.OldKeyJump = KeyJump
			if KeyJump then
				self:ToggleLandingGear()
				self:PhysWake()
			end
		end
	end
	
	local TValAuto = (self:GetStability() > 0.3) and 0 or 1
	local TValManual = self.LandingGearUp and 0 or 1
	
	local TVal = self.WheelAutoRetract and TValAuto or TValManual
	local Speed = FrameTime()/3
	local Speed2 = Speed * math.abs( math.cos( math.rad( self:GetLGear() * 180 ) ) )
	
	self:SetLGear( self:GetLGear() + math.Clamp(TVal - self:GetLGear(),-Speed,Speed) )
	self:SetRGear( self:GetRGear() + math.Clamp(TVal - self:GetRGear(),-Speed2,Speed2) )
end