local TOOL = TOOL
local Color = Color
local mp = mp

TOOL.Category = "Military Play"
TOOL.Name = "Спавнер фракций"

TOOL.ClientConVar["faction_name"] = "null"
TOOL.ClientConVar["faction_jobs"] = "0"

local mdl = "models/hunter/blocks/cube025x025x025.mdl"
local cd = CurTime() + .5

function TOOL:LeftClick(trace)
	if not SERVER then return end
	if cd > CurTime() then return end
	cd = CurTime() + .5
	local pl = self:GetOwner()
	if not pl:IsAdmin() then return end

	if trace.Entity and trace.Entity:IsWorld() and trace.HitPos:Distance(pl:GetPos()) < 300 then
		local faction, jobs = self:GetClientInfo("faction_name"), self:GetClientNumber("faction_jobs")

		if faction == "null" and jobs == "0" then return end
		local Ang = trace.HitNormal:Angle()
		Ang.pitch = Ang.pitch + 90

		local spawn = ents.Create("base_gmodentity")
		spawn:SetModel(mdl)
		spawn:SetAngles(Ang)
		local min = spawn:OBBMins()
		spawn:SetPos(trace.HitPos - trace.HitNormal * min.z)
		spawn:Spawn()
		spawn.owner = pl:SteamID()
		spawn:Activate()

		spawn:PhysicsInit(SOLID_VPHYSICS)
		spawn:SetMoveType(MOVETYPE_VPHYSICS)
		spawn:SetSolid(SOLID_VPHYSICS)
		spawn:DrawShadow(false)
		spawn:SetNoDraw(true)

		spawn:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = spawn:GetPhysicsObject()

		if (IsValid(phys)) then
			phys:Sleep()
		end

		if faction ~= "null" then
			spawn:SetNW2String("faction_name", faction)
		end

		if jobs ~= "0" then
			spawn:SetNW2Int("faction_jobs", jobs)
		end
	end
end

function TOOL:RightClick(trace)
	if not SERVER then return end
	if not self:GetOwner():IsAdmin() then return end

	if cd > CurTime() then return end
	cd = CurTime() + .5

	local ent = trace.Entity

	if ent and IsValid(ent) and (ent:GetNW2String("faction_name") or ent:GetNW2Int("faction_jobs")) then
		ent:Remove()
	end
end

function TOOL:UpdateGhostButton(ent, ply)
	if (! IsValid(ent)) then return end

	local trace = ply:GetEyeTrace()
	if (! trace.Hit or IsValid(trace.Entity) and ((ent:GetNW2String("faction_name") or ent:GetNW2Int("faction_jobs")) or trace.Entity:IsPlayer())) then
		ent:SetNoDraw(true)
		return
	end

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
	ent:SetAngles(ang)

	ent:SetNoDraw(false)
end

function TOOL:Think()
	if (! IsValid(self.GhostEntity)) then
		self:MakeGhostEntity(mdl, Vector(0, 0, 0), Angle(0, 0, 0))
	end

	self:UpdateGhostButton(self.GhostEntity, self:GetOwner())
end

function TOOL:Holster()
	self:ReleaseGhostEntity()

	if CLIENT then
		for k, v in ipairs(ents.FindByClass("base_gmodentity")) do
			if v:GetNW2String("faction_name") or v:GetNW2Int("faction_jobs") then
				v:SetNoDraw(true)
			end
		end
	end
end

function TOOL:Deploy()
	self:ReleaseGhostEntity()

	if CLIENT then
		for k, v in ipairs(ents.FindByClass("base_gmodentity")) do
			if v:GetNW2String("faction_name") or v:GetNW2Int("faction_jobs") then
				v:SetNoDraw(true)
			end
		end
	end
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header",
		{
			Description =
			"Создания спавна для фракций и профессий \n\nПоявление игроков на этих точках в приоритете. Если выбрать профессии и чужую фракцию, то оба условия будут положительны. \n\nТочки после рестарта пропадут"
		})

	do
		local factions = vgui.Create("CtrlListBox", CPanel)
		factions:AddOption("Не выбрано", { spawn_faction_faction_name = "null" })

		for k, v in pairs(mp.faction) do
			factions:AddOption(v.title, { spawn_faction_faction_name = k })
		end

		local left = vgui.Create("DLabel", CPanel)
		left:SetText("Фракция")
		left:SetDark(true)
		factions:SetHeight(25)
		factions:Dock(TOP)

		CPanel:AddItem(left, factions)
	end

	do
		local profession = vgui.Create("CtrlListBox", CPanel)
		profession:AddOption("Не выбрано", { spawn_faction_faction_jobs = "0" })

		for k, v in ipairs(mp.jobs) do
			profession:AddOption(v.Name, { spawn_faction_faction_jobs = k })
		end

		local left = vgui.Create("DLabel", CPanel)
		left:SetText("Профессии")
		left:SetDark(true)
		profession:SetHeight(25)
		profession:Dock(TOP)

		CPanel:AddItem(left, profession)
	end

	CPanel:AddControl("Button", { Label = "Удалить все точки", Command = "spawn_faction_remove", Description = "" })
end

if SERVER then
	concommand.Add("spawn_faction_remove", function(ply, cmd, args)
		if not ply:IsAdmin() then return end
		if cd > CurTime() then return end
		cd = CurTime() + .5

		for k, v in ipairs(ents.FindByClass("base_gmodentity")) do
			if v:GetNW2String("faction_name") or v:GetNW2Int("faction_jobs") then
				v:Remove()
			end
		end
	end)
else
	local color_red = Color(255, 75, 75)
	local font_name_admin = mp.font("25:Futura PT Book")

	function TOOL:DrawHUD()
		local pl = self:GetOwner()
		if not pl:IsAdmin() then return end

		for k, v in ipairs(ents.FindByClass("base_gmodentity")) do
			if v:GetNW2String("faction_name") or v:GetNW2Int("faction_jobs") then
				if v:GetNoDraw() then
					v:SetNoDraw(false)
				end

				cam.Start2D()
				local offset = Vector(0, 0, 10)
				local ang = pl:EyeAngles()
				local pos = v:GetPos() + offset + ang:Up()
				local d = math.floor(pl:GetPos():Distance(pos) / 10)
				pos = pos:ToScreen()
				local x, y = math.Clamp(pos.x, 0, ScrW() - 32), math.Clamp(pos.y, 0, ScrH() - 32)

				if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
					local addY = 0

					mp.Text("Спавнер", font_name_admin, x, y, mp.Color.WHITE, 1,
						0)

					addY = addY + 18


					if v:GetNW2String("faction_name") then
						mp.Text("Фракция: " .. v:GetNW2String("faction_name"), font_name_admin, x, y + addY,
							mp.Color.WHITE, 1,
							0)
					end


					if v:GetNW2String("faction_jobs") then
						local id = tonumber(v:GetNW2Int("faction_jobs"))
						local name = mp.jobs[id] and mp.jobs[id].Name or v:GetNW2Int("faction_jobs")

						addY = addY + 18
						mp.Text("Профессия: " .. name, font_name_admin, x, y + addY,
							mp.Color.WHITE,
							1, 0)
					end
				end
				cam.End2D()
			end
		end

		local ent = pl:GetEyeTrace().Entity
		if IsValid(ent) and (ent:GetNW2String("faction_name") or ent:GetNW2Int("faction_jobs")) then
			halo.Add({ ent }, color_red, 2, 2, 2)
		end
	end
end
