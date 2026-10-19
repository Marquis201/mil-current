AddCSLuaFile()
DEFINE_BASECLASS("sw_base_rocket_v3")

local StartSnds            = {}
StartSnds[1]               = "sw/rocket/rocket_start_01.wav"
StartSnds[2]               = "sw/rocket/rocket_start_02.wav"
StartSnds[3]               = "sw/rocket/rocket_start_03.wav"
StartSnds[4]               = "sw/rocket/rocket_start_04.wav"

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
ExpSnds[1]                 = "sw/explosion/exp_tny_1.wav"
ExpSnds[2]                 = "sw/explosion/exp_tny_2.wav"
ExpSnds[3]                 = "sw/explosion/exp_tny_3.wav"

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
ENT.PrintName              = "РОС-132"
ENT.Author                 = "Shermann Wolf"
ENT.Contact                = "shermannwolf@gmail.com"
ENT.Category               = "Perks"
ENT.Editable               = true
ENT.SWBombV3               = true

--Visual
ENT.Model                  = "models/sw/rus/rockets/ros132.mdl"
ENT.Effect                 = "ins_c4_explosion"
ENT.EffectAir              = "ins_c4_explosion"
ENT.EffectWater            = "ins_water_explosion"

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
ENT.StartSound             = table.Random(StartSnds)

--Physics
ENT.TraceLength            = 150
ENT.ImpactSpeed            = 500
ENT.ImpactDepth            = 0
ENT.Mass                   = 100
ENT.Durability             = 100
ENT.MaxVelocity            = 350
ENT.FuelBurnoutTime        = 1.5

--Explosion
ENT.ExplosionDamage        = 3000
ENT.ExplosionRadius        = 125
ENT.BlastRadius            = 250
ENT.FragDamage             = 25
ENT.FragRadius             = 375
ENT.FragCount              = 100
ENT.ExplodedTime           = 4

if SERVER then
	util.AddNetworkString("mp.perks.SendExplodedPos")
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end
	local pos = tr.HitPos + tr.HitNormal
	local ent = ents.Create(ClassName)
	ent:SetPos(pos)
	ent:SetAngles(Angle(0, ply:EyeAngles().y, 0))
	ent:CPPISetOwner(ply)

	timer.Simple(self.ExplodedTime, function()
		if IsValid(ent) then
			ent:Spawn()
			ent:Activate()
			ent:SetPos(ent:GetPos() + ent:GetUp() * 3500)
		end
	end)

	net.Start("mp.perks.SendExplodedPos")
	net.WriteVector(pos)
	net.Broadcast()

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
	local simple_off = Vector(0, 0, 50)

	local ang = Angle(0, 90, 90)
	local pos
	local title = "(E) Активировать"

	local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
	local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
	local ColorOutlineRed = ColorAlpha(mp.Color.RED, 25)

	local title_font = mp.font("200:Futura PT Book")
	local LerpPos, LerpAlpha = 0, 0

	local listBomb = {}

	local cam = cam
	local draw = draw

	hook.Add("PostDrawTranslucentRenderables", "mp.perks.ExplodedPos", function(bDepth, bSkybox)
		if (bSkybox) then return end

		for k, v in pairs(listBomb) do
			if not v.time or v.time < CurTime() then
				listBomb[k] = nil
				continue
			end

			local getpos = v.pos
			local pl = LocalPlayer()
			local dist = pl:GetPos():Distance(getpos)

			pos = getpos + simple_off

			ang.y = (pl:EyeAngles().y - 90)

			LerpAlpha = Lerp(FrameTime() * 5, LerpAlpha, (dist > 1000) and 0 or 100)
			LerpPos = Lerp(FrameTime() * 4, LerpPos, (dist > 1000) and 150 or 0)

			local m = Matrix()
			m:SetTranslation(getpos)

			cam.PushModelMatrix(m)
			render.SetMaterial(meshMaterial)
			Draw3DCircle_filled(375, 30, Color(125, 45, 45, LerpAlpha))
			cam.PopModelMatrix()

			if LerpAlpha <= 1 then return end

			local time = v.time

			cam.Start3D2D(pos, ang, 0.05)

			local title2 = "Авиаудар: " ..
				string.FormattedTime(time - CurTime(), "%02i:%02i")

			surface.SetFont(title_font)
			local tw2, th2 = surface.GetTextSize(title2)

			tw2 = tw2 + 50
			th2 = th2 + 30

			draw.RoundedBox(0, -tw2 / 2, LerpPos, tw2, th2, ColorAlpha(ColorBackground_100, LerpAlpha))

			surface.SetDrawColor(ColorAlpha(ColorOutlineRed, LerpAlpha))
			surface.DrawOutlinedRect(-tw2 / 2, LerpPos, tw2, th2, 3)

			draw.SimpleText(title2, title_font, 0,
				th2 / 2 + LerpPos, ColorAlpha(mp.Color.RED, LerpAlpha * 2), 1, 1)


			cam.End3D2D()
		end
	end)


	net.Receive("mp.perks.SendExplodedPos", function()
		local getpos = net.ReadVector()
		local id = #listBomb + 1

		listBomb[id] = {
			pos = getpos,
			time = CurTime() + 4
		}

		timer.Create(id .. "BombExplodedSound", 2, 3, function()
			EmitSound("ambient/alarms/klaxon1.wav", getpos, 0, CHAN_STATIC, 1, 100, 0, 75)
		end)
	end)
end
