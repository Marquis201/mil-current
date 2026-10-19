local IsValid = IsValid
local ipairs = ipairs
local LocalPlayer = LocalPlayer
local Angle = Angle
local Vector = Vector
local ents_FindInSphere = ents.FindInSphere
local util_TraceLine = util.TraceLine
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local clra = ColorAlpha

local locked_mat = Material("icon16/lock.png", "smooth")
local unlocked_mat = Material("icon16/lock_open.png", "smooth")

local off_ang = Angle(0, 90, 90)
local col_background = Color(0, 0, 0, 125)

local f
local mp = mp

local gang_colors = {}
local alpha = 0

local title_font = mp.font("45:Futura PT Book")
local price_font = mp.font("85:Futura PT Book")

local Lerpalpha = 0
local CashDoor
local DealyAlpha = 0

hook.Add("PostDrawTranslucentRenderables", "mp.properties.drawinfo", function(bDrawingDepth, bDrawingSkybox)
	if bDrawingSkybox then return end

	local trace = {}
	local lp = LocalPlayer()
	local tr = lp:GetEyeTrace()
	local ent = tr.Entity
	Lerpalpha = Lerp(FrameTime() * 12, Lerpalpha, alpha)

	if IsValid(ent) and ! ent:IsVehicle() and ent:IsDoor() and ent:IsProperty() and lp:GetPos():Distance(ent:GetPos()) < 350 then
		CashDoor = ent
		alpha = 255
		DealyAlpha = CurTime() + 1
	else
		if DealyAlpha < CurTime() then
			alpha = 0

			if Lerpalpha <= 1 then
				CashDoor = nil
			end
		end
	end

	if IsValid(CashDoor) and ent:IsDoor() then
		local title
		local name
		local price
		local color

		ent = CashDoor

		local door_name = ent:GetPropertyName()
		local door_owner = ent:GetPropertyOwner()
		local door_group = ent:GetPropertyGroupName()
		local door_coowner = ent:GetPropertyCoowners()

		if ent:IsPropertyGroupOwned() then
			if door_name then
				title = door_name
			end

			if door_group then
				title = ""
			end

			if door_owner then
				local owner = door_owner
				name = IsValid(owner) and owner:Name() or "Номер занят"
			end

			price = door_group
			color = ent:GetPropertyGroupColor()
		elseif ent:IsPropertyGangOwned() and IsValid(door_owner) then
			local owner = door_owner

			title = door_name
			name = owner:Name()
			price = owner:GetGang()
			color = owner:GetGangColor()
		else
			if door_name == "" and not ent:IsPropertyOwned() then
				title = "Продается!"
			else
				title = door_name
			end

			if not ent:IsPropertyOwned() and ent:GetPropertyCost() > 0 then
				price = mp.format_money(ent:GetPropertyCost())
				color = GREEN
			else
				if IsValid(door_owner) then
					name = door_owner:Name()
					color = door_owner:GetJobColor()
				end

				for k = 1, #door_coowner do
					name = door_coowner[k]:Name() .. ' +' .. #door_coowner
					color = door_coowner[k]:GetJobColor()
				end
			end
		end

		local lw, tr
		lw = ent:LocalToWorld(ent:OBBCenter())
		lw.z = lw.z + 17.5

		trace.start = lp:GetPos() + lp:OBBCenter()
		trace.endpos = lw
		trace.filter = lp
		tr = util_TraceLine(trace)

		local text_pos = 0

		cam_Start3D2D(tr.HitPos + tr.HitNormal, tr.HitNormal:Angle() + off_ang, .055)
		local color_outline = clra(col_background, Lerpalpha)

		if title then
			draw.SimpleTextOutlined(title, title_font, 0, text_pos - 15, clra(color_white, Lerpalpha), 1, 0, 1,
				color_outline)
		end

		if name then
			text_pos = text_pos + 35

			draw.SimpleTextOutlined(name, title_font, 0, text_pos, clra(color, Lerpalpha), 1, 0, 1, color_outline)
		end

		if price then
			text_pos = text_pos + 50

			draw.SimpleTextOutlined(price, price_font, 0, text_pos, clra(color, Lerpalpha), 1, 0, 1, color_outline)
		end

		text_pos = text_pos + 75

		--draw.SimpleTextOutlined(!ent:GetNetVar("mp.DoorIsLocked") and "Открыто" or "Закрыто", title_font, 0, text_pos, clra(!ent:GetNetVar("mp.DoorIsLocked") and mp.Color.BASE or RED, Lerpalpha), 1, 0, 1, color_outline)

		if ent:GetNetVar("mp.DoorIsLocked") then
			surface.SetMaterial(mp.Material.LOCK)
		else
			surface.SetMaterial(mp.Material.UNLOCK)
		end
		surface.SetDrawColor(clra(color_white, Lerpalpha / 4))
		surface.DrawTexturedRect(-32, 164, 114 / 2, 136 / 2)
		cam_End3D2D()
	end
end)
