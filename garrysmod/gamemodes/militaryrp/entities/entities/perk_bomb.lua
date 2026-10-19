AddCSLuaFile()
DEFINE_BASECLASS("sw_base_bomb_v3")

local ImpSnds              = {}
ImpSnds[1]                 = "sw/bomb/impact_1.wav"
ImpSnds[2]                 = "sw/bomb/impact_2.wav"
ImpSnds[3]                 = "sw/bomb/impact_3.wav"

local WtrImpSnds           = {}
WtrImpSnds[1]              = "sw/bomb/impact_wtr_1.wav"
WtrImpSnds[2]              = "sw/bomb/impact_wtr_2.wav"
WtrImpSnds[3]              = "sw/bomb/impact_wtr_3.wav"

local DbrSnds              = {}
DbrSnds[1]                 = "sw/bomb/debris_1.wav"
DbrSnds[2]                 = "sw/bomb/debris_2.wav"
DbrSnds[3]                 = "sw/bomb/debris_3.wav"
DbrSnds[4]                 = "sw/bomb/debris_4.wav"

local ExpSnds              = {}
ExpSnds[1]                 = "sw/explosion/exp_sml_cls_1.wav"
ExpSnds[2]                 = "sw/explosion/exp_sml_cls_2.wav"
ExpSnds[3]                 = "sw/explosion/exp_sml_cls_3.wav"
ExpSnds[4]                 = "sw/explosion/exp_sml_cls_4.wav"
ExpSnds[5]                 = "sw/explosion/exp_sml_cls_5.wav"
ExpSnds[6]                 = "sw/explosion/exp_sml_cls_6.wav"
ExpSnds[7]                 = "sw/explosion/exp_sml_cls_7.wav"
ExpSnds[8]                 = "sw/explosion/exp_sml_cls_8.wav"

local FarExpSnds           = {}
FarExpSnds[1]              = "sw/explosion/exp_sml_dst_1.wav"
FarExpSnds[2]              = "sw/explosion/exp_sml_dst_2.wav"
FarExpSnds[3]              = "sw/explosion/exp_sml_dst_3.wav"
FarExpSnds[4]              = "sw/explosion/exp_sml_dst_4.wav"
FarExpSnds[5]              = "sw/explosion/exp_sml_dst_5.wav"
FarExpSnds[6]              = "sw/explosion/exp_sml_dst_6.wav"
FarExpSnds[7]              = "sw/explosion/exp_sml_dst_7.wav"
FarExpSnds[8]              = "sw/explosion/exp_sml_dst_8.wav"

local DstExpSnds           = {}
DstExpSnds[1]              = "sw/explosion/exp_sml_far_1.wav"
DstExpSnds[2]              = "sw/explosion/exp_sml_far_2.wav"
DstExpSnds[3]              = "sw/explosion/exp_sml_far_3.wav"
DstExpSnds[4]              = "sw/explosion/exp_sml_far_4.wav"
DstExpSnds[5]              = "sw/explosion/exp_sml_far_5.wav"
DstExpSnds[6]              = "sw/explosion/exp_sml_far_6.wav"
DstExpSnds[7]              = "sw/explosion/exp_sml_far_7.wav"
DstExpSnds[8]              = "sw/explosion/exp_sml_far_8.wav"

local WtrExpSnds           = {}
WtrExpSnds[1]              = "sw/explosion/exp_trp_1.wav"
WtrExpSnds[2]              = "sw/explosion/exp_trp_2.wav"
WtrExpSnds[3]              = "sw/explosion/exp_trp_3.wav"

--Main info
ENT.Type                   = "anim"
ENT.Spawnable              = false
ENT.AdminSpawnable         = false
ENT.AdminOnly              = false
ENT.PrintName              = "ТМ-62"
ENT.Author                 = "Shermann Wolf"
ENT.Contact                = "shermannwolf@gmail.com"
ENT.Category               = "Perks"
ENT.Editable               = true
ENT.SWBombV3               = true
ENT.Mine                   = true

--Visual
ENT.Model                  = "models/sw/rus/bombs/tm62.mdl"
ENT.Effect                 = "ins_rpg_explosion"
ENT.EffectAir              = "ins_rpg_explosion"
ENT.EffectWater            = "ins_water_explosion"
ENT.Decal                  = "scorch_1kg"
ENT.AngEffect              = true

--Sounds
ENT.ImpactSound            = table.Random(ImpSnds)
ENT.WaterImpactSoundSound  = table.Random(WtrImpSnds)
ENT.DebrisSound            = table.Random(DbrSnds)
ENT.WhistleSound           = "sw/bomb/whistle.wav"
ENT.ExplosionSound         = table.Random(ExpSnds)
ENT.FarExplosionSound      = table.Random(FarExpSnds)
ENT.DistExplosionSound     = table.Random(DstExpSnds)
ENT.WaterExplosionSound    = table.Random(WtrExpSnds)
ENT.WaterFarExplosionSound = nil

--Physics
ENT.TraceLength            = 50
ENT.ImpactSpeed            = 25
ENT.ImpactDepth            = 2
ENT.Mass                   = 1
ENT.Durability             = 100

--Explosion
ENT.ExplosionDamage        = 5000
ENT.ExplosionRadius        = 50
ENT.BlastRadius            = 200
ENT.FragDamage             = 10
ENT.FragRadius             = 250
ENT.FragCount              = 150

ENT.ExplodedTime           = 300

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end
	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + tr.HitNormal)
	ent:SetAngles(Angle(0, ply:EyeAngles().y, 0))
	ent:Spawn()
	ent:Activate()
	ent:CPPISetOwner(ply)

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
	self:SetNWBool("IsMine", true)
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:PhysWake()
	local pObj = self:GetPhysicsObject()
	pObj:SetMass(self.Mass)
	pObj:EnableGravity(false)
	pObj:EnableMotion(false)
	pObj:EnableDrag(false)
	self:StartMotionController()
	self:PhysWake()
	self.InGround = false
	self.InEntity = false
	self.Exploded = false
	self.Buried = false
	self.Armed = false
	self.CurDurability = self.Durability
end

function ENT:PhysicsCollide(data, physobj)
end

function ENT:Use(activator, caller)
	if activator ~= self:CPPIGetOwner() then return end

	if ! self.Exploded and ! self.Armed then
		self:EmitSound(self.ArmSound)
		self.Armed = true
	end
end

function ENT:OnTick()
	if self.Armed and not self.Used then
		self:SetPos(self:GetPos() - self:GetUp() * 2)
		self:GetPhysicsObject():EnableMotion(false)
		self.Buried = true
		self.Used = true

		self:SetNWFloat("MineExploded", CurTime() + self.ExplodedTime)

		timer.Simple(self.ExplodedTime, function()
			if IsValid(self) and not self.Exploded then
				self.Exploded = true
				self:Explode(self:GetPos())
			end
		end)
	end

	if self.Armed and self.Buried and not self.Exploded then
		for k, v in pairs(ents.FindInSphere(self:LocalToWorld(self:OBBCenter()), self.ExplosionRadius)) do
			if IsValid(v) and (v:IsVehicle() or (v:IsPlayer() and v ~= self:CPPIGetOwner())) then
				timer.Simple(0.2, function()
					if IsValid(self) then
						self.Exploded = true
						self:Explode(self:GetPos())
					end
				end)

				break
			end
		end
	end
end

function ENT:Touch(ent)
	if self.Armed and self.Buried then
		if ent:IsVehicle() then
			self.Exploded = true
			self:Explode(self:GetPos())
		end
	end
end

if CLIENT then
	local surface = surface
	local mesh = mesh
	local meshMaterial = CreateMaterial("mp_mesh_material", "UnlitGeneric", {
		["$basetexture"] = "color/white",
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1,
		["$nocull"] = 1,
		["$ignorez"] = 1
	})

	local function Draw3DCircle_filled(r2, segCount, col)
		local normal_up = Vector(0, 0, 2)
		local r = col.r
		local g = col.g
		local b = col.b
		local a = col.a
		local wedge_radians = math.pi * 2 / segCount
		local a0sin = math.sin(0)
		local a0cos = math.cos(0)
		local ang
		local a1cos, a1sin
		local p00x, p00y, p11x, p11y, p10x, p10y
		mesh.Begin(MATERIAL_TRIANGLES, segCount * 2 + 2)

		for i = 1, segCount do
			ang = i * wedge_radians
			a1cos = math.cos(ang)
			a1sin = math.sin(ang)
			p00x = 0
			p00y = 0
			local p01x = a0cos * r2
			local p01y = a0sin * r2
			p11x = 0
			p11y = 0
			p10x = a1cos * r2
			p10y = a1sin * r2
			mesh.Color(r, g, b, a)
			mesh.Normal(normal_up)
			mesh.Position(Vector(p10x, p10y, 0))
			mesh.AdvanceVertex()
			mesh.Color(r, g, b, a)
			mesh.Normal(normal_up)
			mesh.Position(Vector(p01x, p01y, 0))
			mesh.AdvanceVertex()
			mesh.Color(r, g, b, a)
			mesh.Normal(normal_up)
			mesh.Position(Vector(p00x, p00y, 0))
			mesh.AdvanceVertex()
			mesh.Color(r, g, b, a)
			mesh.Normal(normal_up)
			mesh.Position(Vector(p00x, p00y, 0))
			mesh.AdvanceVertex()
			mesh.Color(r, g, b, a)
			mesh.Normal(normal_up)
			mesh.Position(Vector(p11x, p11y, 0))
			mesh.AdvanceVertex()
			mesh.Color(r, g, b, a)
			mesh.Normal(normal_up)
			mesh.Position(Vector(p10x, p10y, 0))
			mesh.AdvanceVertex()
			a0sin = a1sin
			a0cos = a1cos
		end

		return mesh.End()
	end


	local ColorAlpha = ColorAlpha
	local simple_off = Vector(0, 0, 25)

	local ang = Angle(0, 90, 90)
	local pos
	local title = "(E) Активировать"

	local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
	local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
	local ColorOutlineRed = ColorAlpha(mp.Color.RED, 25)

	local title_font
	local LerpPos, LerpAlpha = 0, 0

	function ENT:Draw()
		title_font = title_font or mp.font("75:Futura PT Book")

		local pl = LocalPlayer()
		local dist = pl:GetPos():Distance(self:GetPos())

		self:DrawModel()

		if pl ~= self:CPPIGetOwner() then return end

		pos = self:GetPos() + simple_off

		ang.y = (pl:EyeAngles().y - 90)

		LerpAlpha = Lerp(FrameTime() * 5, LerpAlpha, (dist > 200) and 0 or 300)
		LerpPos = Lerp(FrameTime() * 4, LerpPos, (dist > 200) and 150 or 0)

		local m = Matrix()
		local frac = 1 - math.Clamp((dist - self.FragRadius) / 300, 0, 1)
		m:SetTranslation(self:GetPos())

		cam.PushModelMatrix(m)
		render.SetMaterial(meshMaterial)
		Draw3DCircle_filled(self.FragRadius, 30, Color(125, 45, 45, frac * 100))
		Draw3DCircle_filled(self.ExplosionRadius, 30, Color(45, 65, 125, frac * 100))
		cam.PopModelMatrix()

		if LerpAlpha <= 1 then return end

		local time = self:GetNWFloat("MineExploded")

		cam.Start3D2D(pos, ang, 0.05)

		if time and time > CurTime() then
			local title2 = "Самоуничтожение: " ..
				string.FormattedTime(time - CurTime(), "%02i:%02i")

			surface.SetFont(title_font)
			local tw2, th2 = surface.GetTextSize(title2)

			tw2 = tw2 + 50
			th2 = th2 + 30

			draw.RoundedBox(0, -tw2 / 2, LerpPos, tw2, th2, ColorAlpha(ColorBackground_100, LerpAlpha / 2))

			surface.SetDrawColor(ColorAlpha(ColorOutlineRed, LerpAlpha / 2))
			surface.DrawOutlinedRect(-tw2 / 2, LerpPos, tw2, th2, 3)

			draw.SimpleText(title2, title_font, 0,
				th2 / 2 + LerpPos, ColorAlpha(mp.Color.RED, LerpAlpha), 1, 1)
		else
			surface.SetFont(title_font)
			local tw, th = surface.GetTextSize(title)

			tw = tw + 50
			th = th + 30

			draw.RoundedBox(0, -tw / 2, LerpPos, tw, th, ColorAlpha(ColorBackground_100, LerpAlpha / 2))

			surface.SetDrawColor(ColorAlpha(ColorOutline, LerpAlpha / 2))
			surface.DrawOutlinedRect(-tw / 2, LerpPos, tw, th, 3)

			draw.SimpleText(title, title_font, 0, th / 2 + LerpPos, ColorAlpha(mp.Color.BASE, LerpAlpha), 1, 1)
		end

		cam.End3D2D()
	end
end
