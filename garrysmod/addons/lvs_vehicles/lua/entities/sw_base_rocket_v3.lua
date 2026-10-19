AddCSLuaFile()

local StartSnds = {}
StartSnds[1] = "sw/rocket/rocket_start_01.wav"
StartSnds[2] = "sw/rocket/rocket_start_02.wav"
StartSnds[3] = "sw/rocket/rocket_start_03.wav"
StartSnds[4] = "sw/rocket/rocket_start_04.wav"

local ImpSnds = {}
ImpSnds[1] = "sw/bomb/impact_1.wav"
ImpSnds[2] = "sw/bomb/impact_2.wav"
ImpSnds[3] = "sw/bomb/impact_3.wav"

local WtrImpSnds = {}
WtrImpSnds[1] = "sw/bomb/impact_wtr_1.wav"
WtrImpSnds[2] = "sw/bomb/impact_wtr_2.wav"
WtrImpSnds[3] = "sw/bomb/impact_wtr_3.wav"

local DbrSnds = {}
DbrSnds[1] = "sw/bomb/debris_1.wav"
DbrSnds[2] = "sw/bomb/debris_2.wav"
DbrSnds[3] = "sw/bomb/debris_3.wav"
DbrSnds[4] = "sw/bomb/debris_4.wav"

local ExpSnds = {}
ExpSnds[1] = "sw/explosion/exp_tny_1.wav"
ExpSnds[2] = "sw/explosion/exp_tny_2.wav"
ExpSnds[3] = "sw/explosion/exp_tny_3.wav"

local FarExpSnds = {}
FarExpSnds[1] = "sw/explosion/exp_sml_dst_1.wav"
FarExpSnds[2] = "sw/explosion/exp_sml_dst_2.wav"
FarExpSnds[3] = "sw/explosion/exp_sml_dst_3.wav"
FarExpSnds[4] = "sw/explosion/exp_sml_dst_4.wav"
FarExpSnds[5] = "sw/explosion/exp_sml_dst_5.wav"
FarExpSnds[6] = "sw/explosion/exp_sml_dst_6.wav"
FarExpSnds[7] = "sw/explosion/exp_sml_dst_7.wav"
FarExpSnds[8] = "sw/explosion/exp_sml_dst_8.wav"

local DstExpSnds = {}
DstExpSnds[1] = "sw/explosion/exp_sml_far_1.wav"
DstExpSnds[2] = "sw/explosion/exp_sml_far_2.wav"
DstExpSnds[3] = "sw/explosion/exp_sml_far_3.wav"
DstExpSnds[4] = "sw/explosion/exp_sml_far_4.wav"
DstExpSnds[5] = "sw/explosion/exp_sml_far_5.wav"
DstExpSnds[6] = "sw/explosion/exp_sml_far_6.wav"
DstExpSnds[7] = "sw/explosion/exp_sml_far_7.wav"
DstExpSnds[8] = "sw/explosion/exp_sml_far_8.wav"

local WtrExpSnds = {}
WtrExpSnds[1] = "sw/explosion/exp_trp_1.wav"
WtrExpSnds[2] = "sw/explosion/exp_trp_2.wav"
WtrExpSnds[3] = "sw/explosion/exp_trp_3.wav"

sound.Add({
	name = "SW_ROCKET_ENG_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "sw/rocket/rocket_fly_loop.wav"
})

--Main info
ENT.Type                   = "anim"
ENT.Spawnable              = false
ENT.AdminSpawnable         = false
ENT.AdminOnly              = false
ENT.PrintName              = "Rocket basescript V3"
ENT.Author                 = "Shermann Wolf"
ENT.Contact                = "shermannwolf@gmail.com"
ENT.Category               = "SW Bombs V3"
ENT.Editable               = true
ENT.SWBombV3               = true
ENT.IsRocket               = true

--Visual
ENT.Model                  = "models/sw/rus/rockets/s1of.mdl"
ENT.Effect                 = "ins_m203_explosion"
ENT.EffectAir              = "ins_m203_explosion"
ENT.EffectWater            = "ins_water_explosion"
ENT.Decal                  = "scorch_25kg"
ENT.AngEffect              = true
ENT.RocketTrail            = "Small_mis_thrust"
ENT.RocketBurnoutTrail     = "Small_mis_burnout"
ENT.Tracer1Att             = nil
ENT.Tracer2Att             = nil
ENT.Engine1Att             = nil
ENT.Engine2Att             = nil

--Sounds
ENT.ArmSound               = "sw/bomb/arm.wav"
ENT.ImpactSound            = table.Random(ImpSnds)
ENT.WaterImpactSound       = table.Random(WtrImpSnds)
ENT.DebrisSound            = table.Random(DbrSnds)
ENT.WhistleSound           = "sw/bomb/whistle.wav"
ENT.ExplosionSound         = table.Random(ExpSnds)
ENT.FarExplosionSound      = table.Random(FarExpSnds)
ENT.DistExplosionSound     = table.Random(DstExpSnds)
ENT.WaterExplosionSound    = table.Random(WtrExpSnds)
ENT.WaterFarExplosionSound = nil
ENT.StartSound             = table.Random(StartSnds)
ENT.EngineSound            = "SW_ROCKET_ENG_LOOP"

--Physics
ENT.TraceLength            = 150
ENT.ImpactSpeed            = 500
ENT.ImpactDepth            = 0
ENT.Mass                   = 100
ENT.Durability             = 100
ENT.DetonateHeight         = 0
ENT.MaxVelocity            = 100
ENT.FuelBurnoutTime        = 1
ENT.RotationalForce        = 1000

--Explosion
ENT.DamageType             = DMG_BURN
ENT.ExplosionDamage        = 1000
ENT.ExplosionRadius        = 300
ENT.BlastRadius            = 450
ENT.FragDamage             = 25
ENT.FragRadius             = 600
ENT.FragCount              = 100
ENT.ArmorPenetration       = 1000
ENT.PenetrationDamage      = 1000

--Guidance
ENT.DiveHeight             = 0
ENT.Agility                = 100
ENT.HaveGuidance           = false
ENT.GuidanceActive         = false
ENT.LaserGuided            = false
ENT.LaserCode              = "view"
ENT.SpiralRate             = -0.4
ENT.SpiralRadius           = 0
ENT.IRunstable             = false
ENT.IRradius               = 0

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "AirDetonate", { KeyName = "airdetonate", Edit = { type = "Boolean", category = "Fuze" } })
	self:NetworkVar("Int", 1, "DetonateHeight",
		{ KeyName = "detonateheight", Edit = { type = "Int", min = 0, max = 2000, category = "Fuze" } })
	self:NetworkVar("Int", 2, "TracerScale")
	self:NetworkVar("Bool", 3, "RadioFuze", { KeyName = "radiofuze", Edit = { type = "Boolean", category = "Fuze" } })
	self:NetworkVar("Int", 4, "RadioFuzeRadius",
		{ KeyName = "radiofuzeradius", Edit = { type = "Int", min = 0, max = 5000, category = "Fuze" } })
end

if SERVER then
	local angle_reg = Angle(0, 0, 0)
	local angle_dif = Angle(-90, 0, 0)
	local Normal = Vector(1, 1, 0)
	local Normal2 = Vector(0.1, 1, 1)
	local trlength = Vector(0, 0, 9000)
	local angle_zero = Angle()
	local angle_1 = Angle(-90, 0, 0)

	function ENT:SpawnFunction(ply, tr, ClassName)
		if not tr.Hit then return end
		local ent = ents.Create(ClassName)
		ent:SetPos(tr.HitPos + tr.HitNormal)
		ent:SetAngles(Angle(0, ply:EyeAngles().y, 0))
		ent:Spawn()
		ent:Activate()

		ent.StartSound            = table.Random(StartSnds)
		ent.ImpactSound           = table.Random(ImpSnds)
		ent.WaterImpactSoundSound = table.Random(WtrImpSnds)
		ent.DebrisSound           = table.Random(DbrSnds)
		ent.ExplosionSound        = table.Random(ExpSnds)
		ent.FarExplosionSound     = table.Random(FarExpSnds)
		ent.DistExplosionSound    = table.Random(DstExpSnds)
		ent.WaterExplosionSound   = table.Random(WtrExpSnds)

		return ent
	end

	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:PhysWake()
		local pObj = self:GetPhysicsObject()
		pObj:SetMass(self.Mass)
		pObj:EnableGravity(false)
		pObj:EnableMotion(true)
		pObj:EnableDrag(false)
		self:StartMotionController()
		self:PhysWake()
		self.InGround = false
		self.InEntity = false
		self.Exploded = false
		self.Armed = false
		self.CurDurability = self.Durability
		self.AirDetTicks = 0
		self.MaxVelocityUnitsSquared = self.MaxVelocity and self:ConvertMetersToUnits(self.MaxVelocity ^ 2) or nil
	end

	--Arming
	function ENT:Use(activator, caller)
		if ! self.Exploded and ! self.Armed then
			self:EmitSound(self.ArmSound)
			self.Armed = true
			self:Launch()
		end
	end

	function ENT:Launch()
		if self.Exploded or self.Burnt or self.Fired then return end

		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		local phys = self:GetPhysicsObject()

		if ! IsValid(phys) then return end

		self.ImpactSpeed = 10

		self.Fired = true
		self:SetNWBool("Fired", true)

		constraint.RemoveAll(self)

		phys:Wake()
		phys:EnableMotion(true)


		self:InitLaunch(phys)
	end

	function ENT:InitLaunch(phys)
		self:EmitSound(self.StartSound)
		util.ScreenShake(self:GetPos(), 1, 10, 1, 150 + self.ExplosionRadius, true, nil)
		self:SetBodygroup(1, 1)

		phys:AddAngleVelocity(Vector(self.RotationalForce or 0, 0, 0))

		if self.RocketTrail then
			timer.Simple(0, function()
				if ! IsValid(self) then return end

				if self.Engine1Att then
					local ID = self:LookupAttachment(self.Engine1Att)
					ParticleEffectAttach(self.RocketTrail, PATTACH_POINT_FOLLOW, self, ID)
				end
				if self.Engine2Att then
					local ID = self:LookupAttachment(self.Engine2Att)
					ParticleEffectAttach(self.RocketTrail, PATTACH_POINT_FOLLOW, self, ID)
				end
				if not self.Engine1Att and not self.Engine2Att then
					ParticleEffectAttach(self.RocketTrail, PATTACH_ABSORIGIN_FOLLOW, self, 1)
				end

				if self.Tracer1Att then
					if self.TracerEffect then
						local ID = self:LookupAttachment(self.Tracer1Att)
						ParticleEffectAttach(self.TracerEffect, PATTACH_POINT_FOLLOW, self, ID)
					end
				end
				if self.Tracer2Att then
					if self.TracerEffect then
						local ID = self:LookupAttachment(self.Tracer2Att)
						ParticleEffectAttach(self.TracerEffect, PATTACH_POINT_FOLLOW, self, ID)
					end
				end
			end)
		end

		if self.FuelBurnoutTime and self.FuelBurnoutTime != 0 then
			timer.Simple(self.FuelBurnoutTime, function()
				if ! IsValid(self) then return end

				self.Burnt = true
				self:SetNWBool("Burnt", true)
				self:StopParticles()
				self:StopSound(self.EngineSound)
				self:StopSound(self.StartSound)

				if self.Engine1Att then
					local ID = self:LookupAttachment(self.Engine1Att)
					ParticleEffectAttach(self.RocketBurnoutTrail, PATTACH_POINT_FOLLOW, self, ID)
				end
				if self.Engine2Att then
					local ID = self:LookupAttachment(self.Engine2Att)
					ParticleEffectAttach(self.RocketBurnoutTrail, PATTACH_POINT_FOLLOW, self, ID)
				end
				if not self.Engine1Att and not self.Engine2Att then
					ParticleEffectAttach(self.RocketBurnoutTrail, PATTACH_ABSORIGIN_FOLLOW, self, 1)
				end
				if self.Tracer1Att then
					if self.TracerEffect then
						local ID = self:LookupAttachment(self.Tracer1Att)
						ParticleEffectAttach(self.TracerEffect, PATTACH_POINT_FOLLOW, self, ID)
					end
				end
				if self.Tracer2Att then
					if self.TracerEffect then
						local ID = self:LookupAttachment(self.Tracer2Att)
						ParticleEffectAttach(self.TracerEffect, PATTACH_POINT_FOLLOW, self, ID)
					end
				end
			end)
		end
	end

	--Think
	function ENT:ConvertMetersToUnits(Meters)
		return Meters / 0.01905
	end

	function ENT:ConvertUnitsToMeters(Units)
		return Units * 0.01905
	end

	function ENT:Think()
		self:NextThink(CurTime())
		if self:IsPlayerHolding() then
			self:SetNWBool("IsPlayerHolding", true)
		else
			self:SetNWBool("IsPlayerHolding", false)
		end
		if self.Armed then
			if self:GetAirDetonate() then
				if IsValid(self) and (self:GetVelocity():Length() > self.ImpactSpeed) and not self:IsPlayerHolding() then
					self.AirDetTicks = self.AirDetTicks + 1
					if self.AirDetTicks >= 50 then
						local tr = util.TraceLine({
							start  = self:LocalToWorld(self:OBBCenter()),
							endpos = self:LocalToWorld(self:OBBCenter()) - Vector(0, 0, self:GetDetonateHeight()),
							filter = self,
						})
						if tr.Hit then
							self.Exploded = true
							self:Explode(self:GetPos())
						end
					end
				end
			end
			if self.CruiseMode and self.GuidanceActive then
				local ph = self:GetPhysicsObject()
				local target = self.target:LocalToWorld(self.targetOffset)
				local tr = util.TraceLine({
					start = self:GetPos(),
					endpos = (self:GetPos() + (self:GetAngles():Forward() * 7500) - (self:GetAngles():Up() * 2500)),
					filter = { self }
				})
				if tr.Hit then
					local distance = self:GetPos():Distance(target)
					if distance > 10000 then
						ph:AddVelocity(self:GetAngles():Up() * 500)
					end
				end
			end
			if self.GuidanceActive then
				self:LaserGuidance()
				self:Guidance(self:GetPhysicsObject())
				if IsValid(self.target) then
					if self.WithOffset then
						self.TargetForwardOffset = self:GetPos():Distance(self.target:GetPos()) /
						(self.OffsetMultiplier or 2)
						self.targetOffset = self.target:WorldToLocal(self.target:GetPos() +
						(self.target:GetForward() * self.TargetForwardOffset))
					end
				end
				if self.IRunstable == true then
					for _, e in pairs(ents.FindInCone(self:GetPos(), self:GetForward(), 1500, math.cos(math.rad(self.SeekerCone)))) do
						if IsValid(e) and e:GetClass() == "misc_flare" then
							local tr = util.TraceLine({
								start = self:GetPos(),
								endpos = e:GetPos(),
							})
							if tr.Hit and tr.Entity == e then
								self.LaserGuided = false
								self.target = e
							end
						end
						if IsValid(e) and e:GetClass() == "sw_flr" then
							local tr = util.TraceLine({
								start = self:GetPos(),
								endpos = e:GetPos(),
							})
							if tr.Hit and tr.Entity == e then
								self.LaserGuided = false
								self.target = e
							end
						end
						if IsValid(e) and e:GetClass() == "sw_flare_v3" then
							local tr = util.TraceLine({
								start = self:GetPos(),
								endpos = e:GetPos(),
							})
							if tr.Hit and tr.Entity == e then
								self.LaserGuided = false
								self.target = e
							end
						end
					end
				end
			end
			if self:GetRadioFuze() then
				for _, e in pairs(ents.FindInSphere(self:GetPos(), self:GetRadioFuzeRadius())) do
					if IsValid(e) and e != self.Launcher then
						if self.LaserGuided == true then
							if e.IsRocket == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
							if e.Fired == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
							if e.Armed == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
							if e.Burnt == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
							if ((e.LFS and e:GetEngineActive()) or ((e:GetClass() == "lvs_helicopter_engine" or e:GetClass() == "lvs_fighterplane_engine") and e:GetBase():GetEngineActive()) or (e.isWacAircraft and e.active)) then
								self.Exploded = true
								self:Explode()
							end
						else
							if ((e.LFS and e:GetEngineActive()) or ((e:GetClass() == "lvs_helicopter_engine" or e:GetClass() == "lvs_fighterplane_engine") and e:GetBase():GetEngineActive()) or (e.isWacAircraft and e.active)) then
								self.Exploded = true
								self:Explode()
							end

							if e.IsRocket == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
							if e.Fired == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
							if e.Armed == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
							if e.Burnt == true and e.Launcher != self.Launcher then
								self.Exploded = true
								self:Explode()
							end
						end
					end
				end
			end
			if self:GetNWBool("Fired") == true then
				if not self.Burnt then
					local phys = self:GetPhysicsObject()

					if IsValid(phys) then
						if self.MaxVelocityUnitsSquared and phys:GetVelocity():LengthSqr() < self.MaxVelocityUnitsSquared then
							phys:ApplyForceCenter(self:GetForward() * 500000)
						end
					end
				end
			end
		end
		if self.InGround or self.InEntity then
			if self:IsPlayerHolding() then
				self.InGround = false
				self.InEntity = false
			end
		end

		self:OnTick()
		return true
	end

	function ENT:OnTick()
	end

	--Flight physics
	function ENT:PhysicsSimulate(phys, deltatime)
		if self.GuidanceActive or IsValid(self.target) then return end
		phys:Wake()
		local ForceLinear, ForceAngle = phys:CalculateForceOffset(physenv.GetGravity(),
			phys:LocalToWorld(phys:GetMassCenter() + Vector(10, 0, 0)))
		ForceAngle = ForceAngle - phys:GetAngleVelocity() * 30
		if self.RotationalForce and self.Fired then
			phys:AddAngleVelocity(Vector(self.RotationalForce, 0, 0))
		end
		return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
	end

	--Guidance
	function ENT:LaserGuidance()
		if self.Armed and not (self.InGround or self.InEntity) then
			if self.LaserGuided then
				if IsValid(self.Launcher) then
					local Parent = self.Launcher
					local phys = self:GetPhysicsObject()
					local ID = Parent:LookupAttachment(self.LaserCode)
					local Attachment = Parent:GetAttachment(ID)
					if Parent:GetAttachment(ID) then
						local TargetDir = Attachment.Ang:Forward()
						local tr = util.TraceLine({
							start = Attachment.Pos,
							endpos = (Attachment.Pos + TargetDir * 999999),
							filter = { self, Parent, Parent.wheel_C, Parent.wheel_R, Parent.wheel_L }
						})
						self.target = tr.Entity
						self.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
						phys:SetVelocity(self:GetVelocity() + self:GetAngles():Forward() * 50)
					end
				end
			end
		end
	end

	function ENT:Guidance(ph)
		if self.target != NULL then
			if IsValid(self.target) or self.target:GetClass() == "worldspawn" then
				if not (self.InGround or self.Armed or self.InEntity) then return end
				local pos = self:GetPos()
				local vel = self:WorldToLocal(pos + ph:GetVelocity()) * 0.4
				vel.x = 0
				local target = self.target:LocalToWorld(self.targetOffset)
				local v = self:WorldToLocal(target +
				Vector(0, 0, math.Clamp((pos * Normal):Distance(target * Normal) / 5 - 10, 0, self.DiveHeight or 0)))
				:GetNormal()
				if isnumber(self.Agility) then
					v.y = math.Clamp(v.y * 10, -1, 1) * self.Agility
					v.z = math.Clamp(v.z * 10, -1, 1) * self.Agility
				else
					v.y = math.Clamp(v.y * 10, -1, 1) * 10
					v.z = math.Clamp(v.z * 10, -1, 1) * 10
				end
				if self.Fired then
					if self.SpiralRadius > 0 then
						self.SpiralRadius = self.SpiralRadius - FrameTime() * (self.StabilisationTime or 50)
					end
					if self.SpiralRadius < 0 then
						self.SpiralRadius = self.SpiralRadius + FrameTime() * (self.StabilisationTime or 50)
					end
					if self.SpiralRate > 0 then
						self.SpiralRate = self.SpiralRate - FrameTime()
					end
					if self.SpiralRate < 0 then
						self.SpiralRate = self.SpiralRate + FrameTime()
					end
				end
				if self.SpiralRadnom then
					ph:AddAngleVelocity(
						ph:GetAngleVelocity() * self.SpiralRate
						+
						Vector(math.Rand(-self.SpiralRadius, self.SpiralRadius),
							math.Rand(-self.SpiralRadius, self.SpiralRadius),
							math.Rand(-self.SpiralRadius, self.SpiralRadius))
						+ Vector(0, -vel.z, vel.y)
						+ Vector(0, -v.z, v.y)
					)
				else
					ph:AddAngleVelocity(
						ph:GetAngleVelocity() * self.SpiralRate
						+ Vector(self.SpiralRadius, self.SpiralRadius, self.SpiralRadius)
						+ Vector(0, -vel.z, vel.y)
						+ Vector(0, -v.z, v.y)
					)
				end
				ph:AddVelocity(self:GetForward() - self:LocalToWorld(vel * Normal2) + pos)
			end
		end
	end

	--Taking damage
	function ENT:OnTakeDamage(dmginfo)
		if self.Exploded then return end
		local inflictor = dmginfo:GetInflictor()
		local attacker = dmginfo:GetAttacker()
		if IsValid(inflictor) and (inflictor.IsGredBomb or inflictor.lvsProjectile or inflictor.SWBombV3) then return end
		self:TakePhysicsDamage(dmginfo)
		self.CurDurability = self.CurDurability - dmginfo:GetDamage()
		if self.Armed then
			if self.CurDurability <= 0 then
				self.Exploded = true
				self:Explode(self:GetPos())
			end
		else
			if ! self.Armed and ! self.Fired then
				self:EmitSound(self.ArmSound)
				self.Armed = true
				self:Launch()
			end
		end
	end

	--Explosion
	function ENT:Explode(pos)
		if ! self.Exploded then return end
		if ! self.Armed then return end
		pos = self:LocalToWorld(self:OBBCenter())
		--[[if(self:WaterLevel() >= 1) then
			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0,0,9000),
				filter  = self,
			}) 			
			local tr2 = util.TraceLine({
				start = tr.HitPos,
				endpos = tr.HitPos - Vector(0,0,9000),
				filter = self,
				mask = MASK_WATER + CONTENTS_TRANSLUCENT,
			})			
			if tr2.Hit then
				ParticleEffect(self.EffectWater, tr2.HitPos,(self.AngEffect and angle_dif or angle_reg), nil)
			end
		else			
			local tr = util.TraceLine({
				start = pos,
				endpos = pos - Vector(0, 0, self.TraceLength),
				filter = self,
			})
			if tr.HitWorld then
				ParticleEffect(self.Effect,pos,(self.AngEffect and angle_dif or angle_reg),nil)			
			else
				ParticleEffect(self.EffectAir,pos,(self.AngEffect and angle_dif or angle_reg),nil)
			end
		end]]

		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetScale(5)
		effectdata:SetMagnitude(25)
		util.Effect("Explosion", effectdata, true, true)

		if self.HEAT then
			local heat    = {}
			heat.Src      = self:GetPos()
			heat.Dir      = self:GetAngles():Forward()
			heat.Spread   = Vector(0, 0, 0)
			heat.Force    = self.ArmorPenetration + math.Rand(-self.ArmorPenetration / 10, self.ArmorPenetration / 10)
			heat.HullSize = self.HEATRadius or 0
			heat.Damage   = self.PenetrationDamage + math.Rand(-self.PenetrationDamage / 5, self.PenetrationDamage / 5)
			heat.Velocity = 10000
			heat.Attacker = self.Owner
			LVS:FireBullet(heat)

			--Blast wave
			if self.ExplosionRadius > 0 then
				--util.BlastDamage( self, ((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or game.GetWorld()), pos, self.ExplosionRadius,self.ExplosionDamage )
				--self:BlastDoors(self, pos, 10)
			end

			--Frags
			if self.FragCount > 0 then
				self:Fragmentation(self, pos, 10000, self.FragDamage, self.FragRadius,
					((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or game.GetWorld()))
			end

			debugoverlay.Text(pos + Vector(0, 0, 10), "Penetration: " .. heat.Force, 5)
			debugoverlay.Text(pos - Vector(0, 0, 10), "Damage: " .. heat.Damage, 5)
			debugoverlay.Sphere(pos, self.ExplosionRadius, 5, Color(200, 150, 0, 100), false)
			debugoverlay.Sphere(pos, self.FragRadius, 5, Color(200, 200, 0, 100), false)
		else
			debugoverlay.Sphere(pos, self.ExplosionRadius, 5, Color(255, 0, 0, 100), false)
			debugoverlay.Sphere(pos, self.BlastRadius, 5, Color(200, 150, 0, 100), false)
			debugoverlay.Sphere(pos, self.FragRadius, 5, Color(200, 200, 0, 100), false)

			--Deadly zone
			if self.ExplosionRadius > 0 then
				for k, v in pairs(ents.FindInSphere(pos, self.ExplosionRadius)) do
					if v:IsValid() and not v.SWBombV3 then
						local dmg = DamageInfo()
						dmg:SetInflictor(self)
						dmg:SetDamage(self.ExplosionDamage)
						dmg:SetDamageType(self.DamageType)
						dmg:SetAttacker((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or
						game.GetWorld())
						v:TakeDamageInfo(dmg)
					end
				end
			end

			--Blast wave
			--[[if self.BlastRadius > 0 then
				util.BlastDamage( self, ((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or game.GetWorld()), pos, self.BlastRadius,self.ExplosionDamage/2 )
				self:BlastDoors(self, pos, 10)
			end]]

			--Frags
			if self.FragCount > 0 then
				self:Fragmentation(self, pos, 10000, self.FragDamage, self.FragRadius,
					((IsValid(self:GetCreator()) and self:GetCreator()) or self.Attacker or game.GetWorld()))
			end
		end

		swv3.CreateSound(pos, false, self.ExplosionSound, self.FarExplosionSound, self.DistExplosionSound)
		timer.Simple(0, function()
			if ! IsValid(self) then return end
			self:Remove()
		end)
	end

	--Impact
	function ENT:PhysicsCollide(data, physobj)
		if self:GetVelocity():Length() >= self.ImpactSpeed then
			if self.Armed then
				self.Exploded = true
				self:Explode(self:GetPos())
			else
				if ! self.Armed and ! self.Fired then
					self:EmitSound(self.ArmSound)
					self.Armed = true
					self:Launch()
				end
			end
		end
	end

	--Door blasting
	function ENT:IsDoor(ent)
		local Class = ent:GetClass()

		return (Class == "prop_door") or (Class == "prop_door_rotating") or (Class == "func_door") or
		(Class == "func_door_rotating")
	end

	function ENT:BlastDoors(blaster, pos, power, range, ignoreVisChecks)
		for k, door in pairs(ents.FindInSphere(pos, 40 * power * (range or 1))) do
			if self:IsDoor(door) then
				local proceed = ignoreVisChecks

				if not proceed then
					local tr = util.QuickTrace(pos, door:LocalToWorld(door:OBBCenter()) - pos, blaster)
					proceed = IsValid(tr.Entity) and (tr.Entity == door)
				end

				if proceed then
					self:BlastDoor(door, (door:LocalToWorld(door:OBBCenter()) - pos):GetNormalized() * 1000)
				end
			end
			if door:GetClass() == "func_breakable_surf" then
				door:Fire("Break")
			end
		end
	end

	function ENT:BlastDoor(ent, vel)
		local Moddel, Pozishun, Ayngul, Muteeriul, Skin = ent:GetModel(), ent:GetPos(), ent:GetAngles(),
			ent:GetMaterial(), ent:GetSkin()
		sound.Play("Wood_Crate.Break", Pozishun, 60, 100)
		sound.Play("Wood_Furniture.Break", Pozishun, 60, 100)
		ent:Fire("unlock", "", 0)
		ent:Fire("open", "", 0)
		ent:SetNoDraw(true)
		ent:SetNotSolid(true)

		if Moddel and Pozishun and Ayngul then
			local Replacement = ents.Create("prop_physics")
			Replacement:SetModel(Moddel)
			Replacement:SetPos(Pozishun + Vector(0, 0, 1))
			Replacement:SetAngles(Ayngul)

			if Muteeriul then
				Replacement:SetMaterial(Muteeriul)
			end

			if Skin then
				Replacement:SetSkin(Skin)
			end

			Replacement:SetModelScale(.9, 0)
			Replacement:Spawn()
			Replacement:Activate()

			if vel then
				Replacement:GetPhysicsObject():SetVelocity(vel)

				timer.Simple(0, function()
					if IsValid(Replacement) then
						Replacement:GetPhysicsObject():ApplyForceCenter(vel * 100)
					end
				end)
			end

			timer.Simple(3, function()
				if IsValid(Replacement) then
					Replacement:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				end
			end)

			timer.Simple(30, function()
				if IsValid(ent) then
					ent:SetNotSolid(false)
					ent:SetNoDraw(false)
				end

				if IsValid(Replacement) then
					Replacement:Remove()
				end
			end)
		end
	end

	--Frags
	function ENT:Fragmentation(shooter, origin, fragNum, fragDmg, fragMaxDist, attacker, direction, spread, zReduction)
		shooter = shooter or game.GetWorld()
		zReduction = zReduction or 2

		local Spred = Vector(0, 0, 0)
		local BulletsFired, MaxBullets, disperseTime = 0, self.FragCount, .5

		if fragNum >= 12000 then
			disperseTime = 2
		elseif fragNum >= 6000 then
			disperseTime = 1
		end

		for i = 1, fragNum do
			timer.Simple((i / fragNum) * disperseTime, function()
				local Dir

				if direction and spread then
					Dir = Vector(direction.x, direction.y, direction.z)
					Dir = Dir + VectorRand() * math.Rand(0, spread)
					Dir:Normalize()
				else
					Dir = VectorRand()
				end

				if zReduction then
					Dir.z = Dir.z / zReduction
					Dir:Normalize()
				end

				local Tr = util.QuickTrace(origin, Dir * fragMaxDist, shooter)

				if Tr.Hit and not Tr.HitSky and not Tr.HitWorld and (BulletsFired < MaxBullets) then
					local LowFrag = (Tr.Entity.IsVehicle and Tr.Entity:IsVehicle()) or Tr.Entity.LFS or Tr.Entity.LVS or
					Tr.Entity.EZlowFragPlease

					if (not LowFrag) or (LowFrag and math.random(1, 4) == 2) then
						local firer = (IsValid(shooter) and shooter) or game.GetWorld()

						firer:FireBullets({
							Attacker = attacker,
							Damage = fragDmg,
							Force = fragDmg / 8,
							Num = 1,
							Src = origin,
							Tracer = 0,
							Dir = Dir,
							Spread = Spred,
							AmmoType = "Buckshot"
						})
						BulletsFired = BulletsFired + 1
					end
				end
			end)
		end
	end
end

if CLIENT then
	function ENT:Initialize()
		self.snd = CreateSound(self, self.WhistleSound)
		self.snd:SetSoundLevel(110)
		self.snd:PlayEx(0, 150)

		self.EngSND = CreateSound(self, self.EngineSound)
	end

	function ENT:CalcDoppler()
		local Ent = LocalPlayer()
		local ViewEnt = Ent:GetViewEntity()

		local sVel = self:GetVelocity()
		local oVel = Ent:GetVelocity()
		local SubVel = oVel - sVel
		local SubPos = self:GetPos() - Ent:GetPos()

		local DirPos = SubPos:GetNormalized()
		local DirVel = SubVel:GetNormalized()
		local A = math.acos(math.Clamp(DirVel:Dot(DirPos), -1, 1))
		return (1 + math.cos(A) * SubVel:Length() / 13503.9)
	end

	function ENT:Think()
		if self.snd then
			self.snd:ChangePitch(100 * self:CalcDoppler(), 1)
			self.snd:ChangeVolume(math.Clamp(-(self:GetVelocity().z + 1000) / 3000, 0, 1), 2)
		end
		if self.Fired then
			self.EngSND:Play()
		end
		if self:GetNWBool("Fired", false) and not self:GetNWBool("IsPlayerHolding", true) then
			if self:GetTracerScale() then
				if self.Tracer1Att and not self.TracerEffect then
					self.Tracer = Material("sprites/animglow02")
					self.Tracer:SetVector("$color", Vector(255, 0, 0))
					if IsValid(self.Emitter) then
						local particle
						for i = 0, 1 do
							local ID = self:LookupAttachment(self.Tracer1Att)
							local Attachment = self:GetAttachment(ID)
							particle = self.Emitter:Add(self.Tracer, Attachment.Pos)
							if particle then
								particle:SetVelocity(self:GetVelocity())
								particle:SetDieTime(0.015)
								particle:SetAirResistance(0)
								particle:SetStartAlpha(255)
								particle:SetStartSize(self:GetTracerScale() * 2)
								particle:SetEndSize(self:GetTracerScale() * 2)
								particle:SetRoll(math.Rand(-1, 1))
								particle:SetGravity(Vector(0, 0, 0))
								particle:SetCollide(false)
							end
						end
					else
						self.Emitter = ParticleEmitter(self:GetPos(), false)
					end
				end
				if self.Tracer2Att and not self.TracerEffect then
					self.Tracer = Material("sprites/animglow02")
					self.Tracer:SetVector("$color", Vector(255, 0, 0))
					if IsValid(self.Emitter) then
						local particle
						for i = 0, 1 do
							local ID = self:LookupAttachment(self.Tracer2Att)
							local Attachment = self:GetAttachment(ID)
							particle = self.Emitter:Add(self.Tracer, Attachment.Pos)
							if particle then
								particle:SetVelocity(self:GetVelocity())
								particle:SetDieTime(0.015)
								particle:SetAirResistance(0)
								particle:SetStartAlpha(255)
								particle:SetStartSize(self:GetTracerScale() * 2)
								particle:SetEndSize(self:GetTracerScale() * 2)
								particle:SetRoll(math.Rand(-1, 1))
								particle:SetGravity(Vector(0, 0, 0))
								particle:SetCollide(false)
							end
						end
					else
						self.Emitter = ParticleEmitter(self:GetPos(), false)
					end
				end
				if not self.Tracer1Att and not self.Tracer2Att then
					self.Tracer = Material("sprites/animglow02")
					self.Tracer:SetVector("$color", Vector(255, 0, 0))
					if IsValid(self.Emitter) then
						local particle
						for i = 0, 1 do
							particle = self.Emitter:Add(self.Tracer, self:GetPos())
							if particle then
								particle:SetVelocity(self:GetVelocity())
								particle:SetDieTime(0.015)
								particle:SetAirResistance(0)
								particle:SetStartAlpha(255)
								particle:SetStartSize(self:GetTracerScale() * 2)
								particle:SetEndSize(self:GetTracerScale() * 2)
								particle:SetRoll(math.Rand(-1, 1))
								particle:SetGravity(Vector(0, 0, 0))
								particle:SetCollide(false)
							end
						end
					else
						self.Emitter = ParticleEmitter(self:GetPos(), false)
					end
				end
			end
		end
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:SoundStop()
		if self.snd then
			self.snd:Stop()
		end
	end

	function ENT:OnRemove()
		self:SoundStop()
	end
end
