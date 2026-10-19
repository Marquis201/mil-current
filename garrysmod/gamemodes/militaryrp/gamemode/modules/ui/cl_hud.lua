--	ИНФОРМАЦИЯ НАД ГОЛОВОЙ	--

local mp = mp
local surface = surface

local font_name_3d = mp.font("100:Futura PT Book")
local font_name_admin = mp.font("25:Futura PT Book")
local font_name_rank = mp.font("22:Futura PT Book")
local time_font = mp.font("18:DIN Pro Regular")

local kill_text = "возрождение"

local ColorAlpha = ColorAlpha
local Lerp = Lerp
local FrameTime = FrameTime
local Vector, Angle = Vector, Angle
local Color = Color
local Material = Material
local draw = draw
local ScrW, ScrH = ScrW, ScrH
local IsValid = IsValid

local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)

local kill_icon = Material("hud/leaderboard_dead")
local button_icon = Material("gui/e.png")

local hide_quest = CreateClientConVar("hide_quest_menu", "0", true, false)

local function activeCamera()
	if not IsValid(LocalPlayer()) or not IsValid(LocalPlayer():GetActiveWeapon()) then return end
	_DRAWCAMERA = LocalPlayer():GetActiveWeapon():GetClass() == "gmod_camera"
end

hook.Add("PostDrawTranslucentRenderables", "3D2DNicks", function(bDepth, bSkybox)
	if (bSkybox) then return end
	if _DRAWCAMERA then return end

	local lp = LocalPlayer()
	local wh = (lp:IsAdmin() and lp:GetMoveType() == MOVETYPE_NOCLIP and lp:Alive() and not lp:InVehicle())

	local dist = wh and 3000 or 300

	if wh then
		for _, ent in ipairs(ents.FindInSphere(lp:GetPos(), 2000)) do
			if not IsValid(ent:CPPIGetOwner()) then continue end

			cam.Start2D()
			local offset = Vector(0, 0, 100)
			local ang = lp:EyeAngles()
			local pos = ent:GetPos() + offset + ang:Up()
			local d = math.floor(lp:GetPos():Distance(pos) / 10)
			pos = pos:ToScreen()
			local x, y = math.Clamp(pos.x, 0, ScrW() - 32), math.Clamp(pos.y, 0, ScrH() - 32)

			if d > 75 then
				if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
					if ent.AddDT then
						mp.Icon(x - 32, y, 64, 64, mp.Material.CIRCLE_SPEC, ColorAlpha(YELLOW, 125))
						mp.Icon(x - 12, y + 20, 24, 24, mp.Material.VEH_SPEC, C_B_150)
					end

					if ent:GetClass() == "prop_physics" then
						mp.Icon(x - 32, y, 64, 64, mp.Material.CIRCLE_SPEC, ColorAlpha(WHITE, 125))
						mp.Icon(x - 12, y + 20, 24, 24, mp.Material.PROP_SPEC, C_B_150)
					elseif ent:GetClass() == "alydus_destructiblefortification" then
						mp.Icon(x - 32, y, 64, 64, mp.Material.CIRCLE_SPEC, ColorAlpha(ORANGE, 125))
						mp.Icon(x - 12, y + 20, 24, 24, mp.Material.PROP_SPEC, C_B_150)
					end
				end
			end
			cam.End2D()
		end

		for _, pl in ipairs(player.GetAll()) do
			if pl == lp then continue end

			cam.Start2D()
			local offset = Vector(0, 0, 100)
			local ang = lp:EyeAngles()
			local pos = pl:GetPos() + offset + ang:Up()
			local d = math.floor(lp:GetPos():Distance(pos) / 10)
			pos = pos:ToScreen()
			local x, y = math.Clamp(pos.x, 0, ScrW() - 32), math.Clamp(pos.y, 0, ScrH() - 32)
			local rank = pl:GetNetVar("meta_rank")
			local profession = pl:GetNetVar("meta_features")

			if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
				if d > 50 then
					mp.Icon(x - 32, y, 64, 64, mp.Material.CIRCLE_SPEC, ColorAlpha(pl:GetJobColor(), 125))

					if profession then
						local icon = mp.profession[profession] and mp.profession[profession].icon

						if icon then
							mp.Icon(x - 12, y + 20, 24, 24, icon, C_B_150)
						end
					else
						mp.Icon(x - 12, y + 20, 24, 24, mp.Material.USER_SPEC, C_B_150)
					end
				else
					local addY = 0

					mp.Text("Имя: " .. pl:Name(), font_name_admin, x, y, mp.Color.WHITE, 1, 0)

					if rank then
						addY = addY + 18
						mp.Text("Ранг: " .. rank, font_name_rank, x, y + addY, mp.Color.BASE, 1, 0)
					end

					if pl:GetJobName() then
						addY = addY + 18
						mp.Text("Работа: " .. pl:GetJobName(), font_name_rank, x, y + addY, pl:GetJobColor(), 1, 0)
					end

					if profession then
						addY = addY + 18
						mp.Text("Специальность: " .. pl:FeatureName(), font_name_rank, x, y + addY, mp.Color.BASE, 1,
							0)
					end

					addY = addY + 18
					mp.Text("Здоровье: " .. pl:Health() .. "/" .. pl:GetMaxHealth(), font_name_rank, x, y + addY,
						mp.Color.GREEN, 1, 0)

					addY = addY + 18
					mp.Text("Броня: " .. pl:Armor() .. "/" .. pl:GetMaxArmor(), font_name_rank, x, y + addY,
						mp.Color.PURPLE, 1, 0)
				end
			end
			cam.End2D()
		end
	else
		for _, ent in ipairs(ents.FindInSphere(lp:GetPos(), dist)) do
			if IsValid(ent) and ent:GetClass() == "prop_ragdoll" and IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer() and not ent:GetOwner():Alive() then
				local pl = ent:GetOwner()

				ent.alpha_hud = ent.alpha_hud or 0

				local distance = lp:GetPos():Distance(ent:GetPos())

				if (distance < dist) then
					if (distance < dist - 100) then
						ent.alpha_hud = Lerp(FrameTime() * 10, ent.alpha_hud, 255)
					else
						ent.alpha_hud = Lerp(FrameTime() * 10, ent.alpha_hud, 0)
					end

					local offset = Vector(0, 0, 40)
					local ang = lp:EyeAngles()
					local pos = ent:EyePos() + offset + ang:Up()

					ang:RotateAroundAxis(ang:Forward(), 90)
					ang:RotateAroundAxis(ang:Right(), 90)

					cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)

					if pl:GetReviveInfo() and pl:GetReviveInfo().time > CurTime() then
						mp.Text(kill_text, font_name_admin, 31, -2, ColorAlpha(mp.Color.BASE_TO, ent.alpha_hud), 0, 0)
						mp.Text(kill_text, font_name_admin, 32, -3, ColorAlpha(mp.Color.WHITE, ent.alpha_hud), 0, 0)
						mp.Icon(0, 0, 24, 24, button_icon, ColorAlpha(mp.Color.WHITE, ent.alpha_hud))
					end


					mp.Icon(0, 20, 128, 128, kill_icon, ColorAlpha(mp.Color.WHITE, ent.alpha_hud))

					cam.End3D2D()
				else
					ent.alpha_hud = 0
				end
			end
		end

		for _, pl in ipairs(ents.FindInSphere(lp:GetPos(), dist)) do
			pl.alpha_hud = pl.alpha_hud or 0
			if IsValid(pl) and pl:GetClass() == "player" and pl:Alive() then
				local hide = lp:Team() ~= TEAM_OVERWATCH and (not pl:GetFaction() or pl:GetFaction() ~= lp:GetFaction())

				local distance = lp:GetPos():Distance(pl:GetPos())

				if (distance < dist) then
					if (distance < dist - 100) then
						pl.alpha_hud = Lerp(FrameTime() * 10, pl.alpha_hud, 255)
					else
						pl.alpha_hud = Lerp(FrameTime() * 10, pl.alpha_hud, 0)
					end

					local offset = Vector(0, 0, 80)
					local ang = lp:EyeAngles()
					local pos = pl:GetPos() + offset + ang:Up()
					local rank = pl:GetNetVar("meta_rank")
					local voice = pl:VoiceVolume()

					ang:RotateAroundAxis(ang:Forward(), 90)
					ang:RotateAroundAxis(ang:Right(), 90)

					cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.05)

					if lp ~= pl and voice and voice > 0.01 then
						mp.Icon(0, -100, 64, 64, mp.Material.VOICE, ColorAlpha(mp.Color.WHITE, pl.alpha_hud))
					end

					if not hide then
						if rank and mp.ranks[rank] and mp.ranks[rank].icon then
							mp.Icon(-92, -25, 92, 128, mp.ranks[rank].icon, ColorAlpha(mp.Color.WHITE, pl.alpha_hud))
							mp.Text(pl:Name(), font_name_3d, 17, -13, ColorAlpha(mp.Color.BASE_TO, pl.alpha_hud), 0, 0)
							mp.Text(pl:Name(), font_name_3d, 15, -15, ColorAlpha(mp.Color.WHITE, pl.alpha_hud), 0, 0)
						else
							mp.Text(pl:Name(), font_name_3d, 2, -13, ColorAlpha(mp.Color.BASE_TO, pl.alpha_hud), 1, 0)
							mp.Text(pl:Name(), font_name_3d, 0, -15, ColorAlpha(mp.Color.WHITE, pl.alpha_hud), 1, 0)
						end
					end
					cam.End3D2D()
				else
					pl.alpha_hud = 0
				end
			end
		end
	end
end)

--	УВЕДОМЛЕНИЯ	NOTIFY	--	--

local Notifications = {}
local FontNotify = mp.font("20:Futura PT Medium")

local function DrawNotification(x, y, w, h, text, icon, col, notif, alpha)
	local clr = ColorAlpha(col, alpha / 2)

	draw.RoundedBox(0, x, y, h + 2, h, clr)
	draw.RoundedBox(0, x + h + 6, y, w - h, h, clr)

	surface.SetDrawColor(clr)
	surface.DrawOutlinedRect(x, y, h + 2, h, 1)
	surface.DrawOutlinedRect(x + h + 6, y, w - h, h, 1)

	mp.Icon(x + 5, y + 3, 24, 24, icon, ColorAlpha(mp.Color.BASE_TO, alpha))

	mp.Text(text, FontNotify, x + 45, y + h / 2, ColorAlpha(mp.Color.BASE_TO, alpha), 0, 1)
end

function notification.AddLegacy(text, type, time)
	surface.SetFont(FontNotify)

	local w = surface.GetTextSize(text) + 40 + 10
	local h = 32
	local x = 20
	local y = 0

	table.insert(Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,
		text = text,
		col = mp.TypeNotify[type].Color,
		icon = mp.TypeNotify[type].Icon,
		start = CurTime(),
		time = CurTime() + time,
		alpha = 0,
	})

	surface.PlaySound(mp.Sound.NOTIFY)
end

function notification.Kill(id)
	for k, v in ipairs(Notifications) do
		if v.id == id then v.time = 0 end
	end
end

local function DrawPanelNotify()
	local pl = LocalPlayer()

	if IsValid(NOTIFY_PANEL) then NOTIFY_PANEL:Remove() end

	local PanelNotify = vgui.Create("EditablePanel")
	NOTIFY_PANEL = PanelNotify
	NOTIFY_PANEL:SetPos(0, 0)
	NOTIFY_PANEL:SetSize(ScrW() / 2, ScrH() / 3)
	function NOTIFY_PANEL:Paint()
		for k, v in ipairs(Notifications) do
			DrawNotification(math.floor(v.x) - 10, math.floor(v.y), v.w, v.h, v.text, v.icon, v.col, v, v.alpha)

			if k < 3 and v.time > CurTime() then
				v.alpha = math.Clamp(v.alpha + 10, 0, 255)
			else
				v.alpha = math.Clamp(v.alpha - 10, 0, 255)
			end

			v.y = Lerp(FrameTime() * 10, v.y, k * (v.h + 5))
		end

		for k, v in ipairs(Notifications) do
			if v.time < CurTime() then
				v.alpha = math.Clamp(v.alpha - 10, 0, 255)
			end

			if v.time < CurTime() and v.alpha < 5 then
				table.remove(Notifications, k)
			elseif v.alpha < 5 then
				table.remove(Notifications, k)
			end
		end
	end

	NOTIFY_PANEL.Think = function(self, w, h)
		if IsValid(NOTIFY_PANEL) and not pl:Alive() then
			NOTIFY_PANEL:Remove()
		end
	end
end

hook.Add("Think", "DrawNotifications", function()
	DrawPanelNotify()
end)

hook.Add("PlayerButtonDown", "PlayerButtonDownWikiExample2", function(pl, button)
	local wep = pl:GetActiveWeapon()

	if CLIENT and not IsFirstTimePredicted() then
		return
	end
end)

local LerpArmor = 0
local LerpHealth = 0

local X_t, Y_t = "X: ", "Y: "
local null = "000"
local firemode = "режим огня [E+R]"
local customization = "кастомизация [B]"

local FireModeSafe = "passive"  -- предохранитель
local FireModeAuto = "auto"     -- авто
local FireMode3Burst = "3burst" -- 3 выстр.
local FireMode2Burst = "2burst" -- 2 выстр.
local FireModeSemi = "semi"     -- одиночные

local points_text = "Сбережения"

local oxy = mp.font("20:Futura PT Medium")
local fire_font = mp.font("20:DIN Pro Regular")
local magazine_font = mp.font("40:mr_ApexMk3MediumG")
local ammo_font = mp.font("26:mr_ApexMk3MediumG")
local ammo_type = mp.font("20:Futura PT Light")
local title_font = mp.font("22:Futura PT Book")
local quest_font = mp.font("18:DIN Pro Regular")
local help_font = mp.font("16:DIN Pro Regular")
local quest_title_font = mp.font("20:mr_ApexMk3MediumG")
local title_help_font = mp.font("18:mr_ApexMk3MediumG")

local C_B_75 = ColorAlpha(mp.Color.BLACK, 75)
local C_B_200 = ColorAlpha(mp.Color.BLACK, 200)
local C_W_25 = ColorAlpha(mp.Color.WHITE, 25)
local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)
local C_W_45 = ColorAlpha(mp.Color.WHITE, 45)
local C_W_75 = ColorAlpha(mp.Color.BASE_TO, 75)
local C_W_2 = ColorAlpha(mp.Color.WHITE, 2)
local C_G_200 = ColorAlpha(Color(62, 255, 126), 200)
local C_Y_200 = ColorAlpha(mp.Color.YELLOW, 200)
local C_O_200 = ColorAlpha(mp.Color.ORANGE, 200)
local C_BL_200 = ColorAlpha(Color(86, 179, 255), 200)
local C_R_200 = ColorAlpha(mp.Color.RED, 200)
local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
local C_B_100 = ColorAlpha(mp.Color.BLACK, 100)

local LerpAlpha = 0
local LerpAP = 0
local alphaColor = 0


local color_bar = mp.Color.BASE
local color_red = Color(255, 100, 105)

local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
local ColorOutlineRed = ColorAlpha(mp.Color.RED, 25)
local ColorOutlineGreen = ColorAlpha(mp.Color.GREEN, 25)

local function drawAmmo(scrw, scrh, pl)
	local w, h = 256, 78
	local x = scrw - w - 15
	local y = scrh - h - 15

	local Wep = pl:GetActiveWeapon()

	if Wep and Wep:IsWeapon() and Wep:HasAmmo() then
		surface.SetFont(magazine_font)
		local tw, th = surface.GetTextSize(Wep:Clip1())
		tw = tw + 5

		if Wep:Clip1() > 0 then
			draw.SimpleText(Wep:Clip1(), magazine_font, x + 12, y + 2, ColorBackground_100, 0, 4)
			draw.SimpleText(Wep:Clip1(), magazine_font, x + 10, y, mp.Color.WHITE, 0, 4)
		end

		if pl:GetAmmoCount(Wep:GetPrimaryAmmoType()) > 0 then
			draw.SimpleText(pl:GetAmmoCount(Wep:GetPrimaryAmmoType()), ammo_font, x + tw + 12, y - 8,
				ColorBackground_100, 0, 4)
			draw.SimpleText(pl:GetAmmoCount(Wep:GetPrimaryAmmoType()), ammo_font, x + tw + 10, y - 10, C_W_100, 0,
				4)
		end

		if game.GetAmmoName(Wep:GetPrimaryAmmoType()) then
			draw.SimpleText("патроны: " .. game.GetAmmoName(Wep:GetPrimaryAmmoType()), ammo_type, x + w, y,
				C_W_100, 2, 4)
		end
	end

	if IsValid(Wep) and Wep.IsTFAWeapon and Wep:GetFireMode() then
		local fireMode = Wep:GetFireMode()

		draw.RoundedBox(0, x - 32, y + 5, 32, 32, ColorBackground_100)
		draw.RoundedBox(0, x - 32, y + 42, 32, 32, ColorBackground_100)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(x - 32, y + 5, 32, 32, 1)
		surface.DrawOutlinedRect(x - 32, y + 42, 32, 32, 1)

		local icon_fire = mp.Material.AUTO

		if fireMode == 3 then -- Safe mode
			icon_fire = mp.Material.SAFE
		elseif fireMode == 2 then -- Semi-auto
			icon_fire = mp.Material.ONE_WEP
		elseif fireMode == 3 then -- Burst
			icon_fire = mp.Material.AUTO
		elseif fireMode == 1 then -- Full-auto
			icon_fire = mp.Material.AUTO
		end

		mp.Icon(x - 28, y + 45, 24, 24, icon_fire, mp.Color.WHITE)
		mp.Icon(x - 28, y + 9, 24, 24, mp.Material.CUSTOM_MENU, mp.Color.WHITE)

		draw.SimpleText(customization, title_font, x - 38, y + 9, C_W_100, 2, 0)
		draw.SimpleText(firemode, title_font, x - 38, y + 45, C_W_100, 2, 0)
	end
end

local function IsVoiceKeyPressed()
	local voiceKey = input.LookupBinding("+voicerecord")
	if voiceKey and input.IsKeyDown(input.GetKeyCode(voiceKey)) then
		return true
	end
	return false
end

local function drawBackground(scrw, scrh, pl)
	local w, h = 256, 78
	local x = scrw - w - 10
	local y = scrh - h - 10

	draw.RoundedBox(0, x, y, w, h, ColorBackground_100)

	surface.SetDrawColor(ColorOutline)
	surface.DrawOutlinedRect(x, y, w, h, 1)
end

local function drawArmor(scrw, scrh, pl)
	local x = scrw - 255
	local y = scrh - 33
	local w, h = 200, 20
	local armor = pl:Armor()

	LerpArmor = Lerp(FrameTime() * 5, LerpArmor, armor)

	local getArmor = LerpArmor / pl:GetMaxArmor()
	local maxArmor = 1 / w
	getArmor = math.Clamp(getArmor, 0, 1)

	surface.SetDrawColor(C_B_150)
	surface.DrawRect(x, 5 + y, 98, 6)
	surface.DrawRect(x + 105, 5 + y, 96, 6)

	for i = 0, getArmor, maxArmor do
		surface.SetDrawColor(C_BL_200)
		if (i >= 0.485 and i < 0.515) then
			surface.SetDrawColor(0, 0, 0, 0)
		end
		surface.DrawLine(x, 5 + y, x, y + 10)
		x = x + 1
	end
	draw.RoundedBox(0, scrw - 48, y - 16, 32, 32, ColorBackground_100)

	surface.SetDrawColor(ColorOutline)
	surface.DrawOutlinedRect(scrw - 48, y - 16, 32, 32, 1)

	mp.Icon(scrw - 44, y - 12, 24, 24, mp.Material.ARMOR, C_BL_200)

	draw.SimpleText(armor, fire_font, scrw - 54, y - h + 3, C_W_200, 2, 0)
end

local function drawHealth(scrw, scrh, pl)
	local x = scrw - 255
	local y = scrh - 67
	local w, h = 200, 20
	local health = pl:Health()

	LerpHealth = Lerp(FrameTime() * 5, LerpHealth, health)

	local getHealth = LerpHealth / 100
	local maxHealth = 1 / w
	getHealth = math.Clamp(getHealth, 0, 1)

	surface.SetDrawColor(C_B_150)
	surface.DrawRect(x, 5 + y, 48, 6)
	surface.DrawRect(x + 52, 5 + y, 46, 6)
	surface.DrawRect(x + 102, 5 + y, 46, 6)
	surface.DrawRect(x + 152, 5 + y, 49, 6)

	local col_hp = C_G_200

	if getHealth == 0 then return end
	for i = 0, getHealth, maxHealth do
		if health < 25 then
			col_hp = C_R_200
		elseif health < 50 then
			col_hp = C_O_200
		elseif health < 75 then
			col_hp = C_Y_200
		else
			col_hp = C_G_200
		end

		surface.SetDrawColor(col_hp)
		if (i >= 0.235 and i < 0.265) or (i >= 0.485 and i < 0.515) or (i >= 0.735 and i < 0.765) then
			surface.SetDrawColor(0, 0, 0, 0)
		end
		surface.DrawLine(x, 5 + y, x, y + 10)
		x = x + 1
	end

	draw.RoundedBox(0, scrw - 48, y - 16, 32, 32, ColorBackground_100)

	surface.SetDrawColor(ColorOutline)
	surface.DrawOutlinedRect(scrw - 48, y - 16, 32, 32, 1)

	mp.Icon(scrw - 44, y - 12, 24, 24, mp.Material.HEALTH, col_hp)

	draw.SimpleText(health, fire_font, scrw - 54, y - h + 3, C_W_200, 2, 0)
end

local function drawStamina(scrw, scrh, pl)
	local w, h = 255, 8
	local x = scrw / 2 - w / 2
	local y = scrh - 50

	local AP = pl:GetAP()
	local MaxAP = pl:GetMaxAP()

	local procent = (MaxAP - AP) / MaxAP
	local clr = color_bar:Lerp(color_red, procent)

	LerpAlpha = Lerp(FrameTime() * 4, LerpAlpha, AP ~= MaxAP and w or 0)
	LerpAP = Lerp(FrameTime() * 6, LerpAP, AP * (w / 100))

	draw.RoundedBox(0, x, y, w, h, ColorAlpha(mp.Color.BLACK, LerpAlpha / 2))
	draw.RoundedBox(0, x, y, LerpAP, h,
		ColorAlpha(clr, AP < MaxAP / 3 and TimedCos(0.5, LerpAlpha / 2, -LerpAlpha / 3, CurTime()) or LerpAlpha))

	surface.SetDrawColor(ColorAlpha(ColorOutline, LerpAlpha / 2))
	surface.DrawOutlinedRect(x, y, w, h, 1)
end

local function drawLogo(scrw, scrh, pl)
	local size = 64

	local x, y = scrw - 10, 10
	local time = os.time()
	local timedata = os.date("%H:%M:%S / %d.%m.%Y", time)

	mp.Icon(x - size, y, size, size, mp.Material.LOGO_CMENU, color_white)
	draw.SimpleText("Military Play", ammo_font, x - size - 10, y + size * .55, C_W_200, 2, 4)
	draw.SimpleText(timedata, fire_font, x - size - 10, y + size * .55, C_W_100, 2, 0)

	draw.RoundedBox(0, x - size - 5, y + size * .2, 2, size * .7, C_W_45)
end

local function drawWallet(scrw, scrh, pl)
	local size = 44
	local x, y = 10, scrh - 10
	local t = mp.jobs[pl:Team()]
	local salary = t and t.salary
	local points = mp.FormatMoney(pl:GetPoints()) .. (salary and (" + " .. salary) or "")

	surface.SetFont(title_font)
	local tw = surface.GetTextSize(points)

	surface.SetFont(time_font)
	local tw2 = surface.GetTextSize(points_text)

	tw = tw + 10
	tw2 = tw2 + 10

	if tw2 > tw then
		tw = tw2
	end

	draw.RoundedBox(0, x, y - size, size + tw, size, ColorBackground_100)

	surface.SetDrawColor(ColorOutline)
	surface.DrawOutlinedRect(x, y - size, size + tw, size, 1)

	mp.Icon(x + 6, y - size + 6, 32, 32, mp.Material.WALLET, C_O_200)

	draw.SimpleText(points, title_font, x + 44, y - size / 2 + 3, C_W_200, 0, 4)
	draw.SimpleText(points_text, time_font, x + 44, y - size / 2 - 2, C_W_100, 0, 0)
end

if IsValid(mp.HUDQuestPanel) then
	mp.HUDQuestPanel:Remove()
end

local function drawQuest(scrw, scrh, pl)
	if IsValid(mp.HUDQuestPanel) then return end

	local wide, tall = 300, 240
	local x, y = scrw - wide - 10, 84

	mp.HUDQuestPanel = vgui.Create("EditablePanel")
	local fr = mp.HUDQuestPanel

	fr:SetPos(x, y)
	fr:SetSize(wide, tall)
	function fr:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	fr.Lerp = tall
	function fr:Think()
		local hide = hide_quest:GetBool()
		self.Lerp = Lerp(FrameTime() * 6, self.Lerp, hide and 42 or tall)

		fr:SetTall(self.Lerp)
		fr:SetAlpha(hide and 120 or 255)
	end

	local panel_title = vgui.Create("Panel", fr)
	panel_title:Dock(TOP)
	panel_title:SetTall(32)
	panel_title:DockMargin(5, 5, 5, 0)
	function panel_title:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

		surface.SetDrawColor(ColorOutline)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText("Задания", quest_title_font, w / 2 + 2, h / 2 + 2, ColorBackground_100, 1, 1)
		draw.SimpleText("Задания", quest_title_font, w / 2, h / 2, mp.Color.WHITE, 1, 1)
	end

	local RetryPanel = vgui.Create("DButton", panel_title)
	RetryPanel:Dock(LEFT)
	RetryPanel:SetWide(82)
	RetryPanel:SetText("ОБНОВИТЬ")
	RetryPanel:SetColor(Color(0, 0, 0, 0))
	RetryPanel:DockMargin(2, 2, 2, 2)
	RetryPanel.Hover = 0
	RetryPanel.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

		surface.SetDrawColor(ColorAlpha(mp.Color.WHITE, self.Hover / 2))
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText(self:GetText(), help_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
			1)
		draw.SimpleText(self:GetText(), help_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
	end

	RetryPanel.DoClick = function(self)
		if IsValid(mp.HUDQuestPanel) then
			mp.HUDQuestPanel:Remove()
		end
	end

	RetryPanel.OnCursorEntered = function(s)
		mp.ToolTip(s, "Обновить список заданий", mp.Color.BASE)
		surface.PlaySound(mp.Sound.CLICK)
	end

	local HidePanel = vgui.Create("DButton", panel_title)
	HidePanel:Dock(RIGHT)
	HidePanel:SetWide(72)
	HidePanel:SetText("СКРЫТЬ")
	HidePanel:SetColor(Color(0, 0, 0, 0))
	HidePanel:DockMargin(2, 2, 2, 2)
	HidePanel.Hover = 0
	HidePanel.Paint = function(self, w, h)
		if self:IsHovered() then
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 0)
		end

		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.WHITE, self.Hover / 100))

		surface.SetDrawColor(ColorAlpha(mp.Color.WHITE, self.Hover / 2))
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		draw.SimpleText(self:GetText(), help_font, w / 2, h / 2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1,
			1)
		draw.SimpleText(self:GetText(), help_font, w / 2, h / 2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
	end

	HidePanel.DoClick = function(self)
		local hide_quest_menu = GetConVar("hide_quest_menu")
		RunConsoleCommand("hide_quest_menu", hide_quest_menu:GetInt() == 1 and "0" or "1")
	end

	HidePanel.OnCursorEntered = function(s)
		mp.ToolTip(s, "Скрыть панель", mp.Color.BASE)
		surface.PlaySound(mp.Sound.CLICK)
	end

	local list_scroll = vgui.Create("DScrollPanel", fr)
	list_scroll:Dock(FILL)
	list_scroll:DockMargin(5, 5, 5, 5)
	list_scroll.Hover = 0
	list_scroll.VBar:SetWide(5)
	list_scroll.Paint = function(self, w, h)
		local x2, y2 = self:LocalCursorPos()

		if x2 < w and x2 > 0 and y2 < h and y2 > 0 then
			self.Hover = Lerp(FrameTime() * 5, self.Hover, 255)
		else
			self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
		end

		self.VBar:SetAlpha(self.Hover)
	end
	local sbar = list_scroll:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, C_B_100)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, mp.Color.BASE)

		mp.Icon(0, 0, w, h, mp.Material.GRADIENT_U, C_W_100)
	end

	list_scroll.create_quest = function()
		list_scroll:Clear()
		list_scroll:AlphaTo(255, 0.2, 0)

		local id = 0
		for k, v in pairs(mp.QuestPlay.List) do
			if v.retry then
				if not mp.QuestPlay:HasContract(pl, v.id) then continue end
			else
				if v.check and not v.check(pl) then continue end
			end

			id = id + 1
			local panel_quest = vgui.Create("Panel", list_scroll)
			panel_quest:Dock(TOP)
			panel_quest:SetTall(32)
			panel_quest:DockMargin(0, 0, 0, 5)
			panel_quest.contract = v.retry
			function panel_quest:Paint(w, h)
				local has = self.contract and not mp.QuestPlay:HasContract(LocalPlayer(), v.id) or
					mp.QuestPlay:HasQuest(LocalPlayer(), k)
				local color = has and C_G_200 or C_Y_200

				if has and not self.AlphaRemove then
					self.AlphaRemove = true

					self:AlphaTo(0, 1, 5, function()
						self:Remove()

						timer.Create("RefreshQuest", 1, 1, function()
							if IsValid(list_scroll) then
								list_scroll:AlphaTo(0, 1, 0, function()
									list_scroll.create_quest()
								end)
							end
						end)
					end)
				end

				draw.RoundedBox(0, 0, 0, w, h, ColorBackground_100)

				surface.SetDrawColor(ColorOutline)
				surface.DrawOutlinedRect(0, 0, w, h, 1)

				draw.RoundedBox(0, 5, 5, 25, 25, ColorBackground_100)

				surface.SetDrawColor(ColorOutline)
				surface.DrawOutlinedRect(5, 5, 25, 25, 1)

				draw.SimpleText("✪", font_name_admin, 17, 2.5, color, 1, 0)

				if v.retry and mp.QuestPlay:HasContract(pl, v.id) then
					local t = pl:GetNetVar("QuestPlay.ListContract")[v.id]

					draw.SimpleText("Время", help_font, w - 7.5, 2.5, mp.Color.BASE, 2, 0)
					draw.SimpleText(string.FormattedTime(t.time - CurTime(), "%02i:%02i"), time_font, w - 7.5, 20,
						mp.Color.WHITE, 2, 0)

					if v.count then
						draw.SimpleText("Прогресс", help_font, w - 7.5, 37, mp.Color.BASE, 2, 0)

						draw.SimpleText(t.count .. " из " .. v.count, time_font, w - 7.5, 52,
							mp.Color.WHITE, 2, 0)
					end
				end
			end

			local tilte_text = vgui.Create("DLabel", panel_quest)
			tilte_text:Dock(TOP)
			tilte_text:DockMargin(35, 5, v.retry and 70 or 5, 5)
			tilte_text:SetText(v.name)
			tilte_text:SetWrap(true)
			tilte_text:SetAutoStretchVertical(true)
			tilte_text:SetFont(quest_font)
			local help_text
			if v.help then
				help_text = vgui.Create("DLabel", panel_quest)
				help_text:Dock(TOP)
				help_text:DockMargin(10, 5, v.retry and 70 or 10, 5)
				help_text:SetText(v.help)
				help_text:SetWrap(true)
				help_text:SetAutoStretchVertical(true)
				help_text:SetFont(help_font)
				help_text:SetColor(C_W_100)
			end

			function panel_quest:PerformLayout()
				self:SetTall(math.Clamp(
					tilte_text:GetTall() + (IsValid(help_text) and help_text:GetTall() + 10 or 0) + 10, 36,
					999))
			end
		end

		--fr:SetAlpha(id <= 0 and 0 or 255)
	end

	list_scroll.create_quest()
end

local buttons_help = {
	{
		name = "F1",
		help = "Помощь",
	},

	{
		name = "F2",
		help = "Рация",
	},

	{
		name = "F3",
		help = "Разблокировать курсор",
	},

	{
		name = "F6",
		help = "Донат",
	},
}

local function drawButton(scrw, scrh, pl)
	local x, y = 20, scrh - 72

	for i = 1, #buttons_help do
		local v = buttons_help[i]

		draw.RoundedBox(4, x, y - 34 * i, 24, 24, C_W_200)
		draw.SimpleText(v.name, title_help_font, x + 11, y - 34 * i + 2, color_black, 1, 0)
		draw.SimpleText(v.help, time_font, x + 32, y - 34 * i + 2, C_W_200, 0, 0)
	end
end

local function drawJail(scrw, scrh, pl)
	local x, y = scrw / 2, scrh * .2

	local text = "Вы в джайле!"
	surface.SetFont(title_font)
	local tw = surface.GetTextSize(text)

	tw = tw + 40

	draw.RoundedBox(0, x - tw / 2, y - 35, tw, 70, ColorBackground_100)

	surface.SetDrawColor(ColorOutline)
	surface.DrawOutlinedRect(x - tw / 2, y - 35, tw, 70, 1)

	draw.SimpleText(text, font_name_admin, x, y, C_W_200, 1, 4)
	draw.SimpleText(string.FormattedTime(pl:GetNetVar("IsJail") - CurTime(), "%02i:%02i"), ammo_font, x, y, color_bar, 1,
		0)
end

local function hasPerk(pl)
	local features = pl:GetNetVar("meta_features")
	if not features or not mp.profession[features] or not mp.profession[features].perk then return false end

	return mp.profession[features].perk
end

if IsValid(mp.HUDPerkPanel) then
	mp.HUDPerkPanel:Remove()
end

local function drawPerk(scrw, scrh, pl)
	if IsValid(mp.HUDPerkPanel) then return end

	local wide, tall = 54, 54
	local x, y = 10, scrh / 1.7

	mp.HUDPerkPanel = vgui.Create("EditablePanel")
	local fr = mp.HUDPerkPanel

	fr:SetPos(x, y)
	fr:SetSize(wide, tall)
	function fr:Paint(w, h)
		local perk = pl:GetNetVar("mp.Perks")

		if not perk then return end
		local data = mp.perks.list[perk.id]
		if not data then return end

		local cd = CurTime()
		local deley = perk.delay > cd
		local duration = perk.duration > cd

		draw.RoundedBox(0, 0, 0, h, h, ColorBackground_100)

		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, h, h, ColorOutline)
		end

		mp.Icon(3, 3, 48, 48, data.icon, color_white)

		if duration then
			local progress = math.Clamp((h / data.duration) * (perk.duration - cd), 0, h)
			draw.RoundedBox(0, 0, h - progress, h, progress, ColorOutlineGreen)

			surface.SetDrawColor(ColorOutlineGreen)

			draw.SimpleText(string.FormattedTime(perk.duration - cd, "%02i:%02i"), fire_font, w / 2, h / 2,
				mp.Color.WHITE, 1, 1)
		elseif deley then
			local progress = math.Clamp((h / data.delay) * (perk.delay - cd), 0, h)
			draw.RoundedBox(0, 0, h - progress, h, progress, ColorOutlineRed)

			surface.SetDrawColor(ColorOutlineRed)

			draw.SimpleText(string.FormattedTime(perk.delay - cd, "%02i:%02i"), fire_font, w / 2, h / 2,
				mp.Color.WHITE, 1, 1)
		else
			surface.SetDrawColor(ColorOutline)

			draw.SimpleText("F4", oxy, w - 4, 2, mp.Color.ORANGE, 2, 0)
		end

		surface.DrawOutlinedRect(0, 0, h, h, 1)
	end

	fr.OnCursorEntered = function(s)
		local perk = pl:GetNetVar("mp.Perks")

		if not perk then return end
		local data = mp.perks.list[perk.id]
		if not data then return end

		mp.ToolTip(s, data.name .. " - " .. data.desc, mp.Color.BASE)
		surface.PlaySound(mp.Sound.CLICK)
	end
end

local function MainHUD()
	local pl = LocalPlayer()
	local scrw, scrh = ScrW(), ScrH()

	activeCamera()

	if pl:GetNetVar("IsJail") and pl:GetNetVar("IsJail") > CurTime() then
		drawJail(scrw, scrh, pl)
		return
	end
	if pl:InVehicle() then return end
	if _DRAWCAMERA then return end

	drawBackground(scrw, scrh, pl)
	drawArmor(scrw, scrh, pl)
	drawHealth(scrw, scrh, pl)
	drawAmmo(scrw, scrh, pl)
	drawStamina(scrw, scrh, pl)
	drawLogo(scrw, scrh, pl)
	drawWallet(scrw, scrh, pl)
	drawButton(scrw, scrh, pl)

	if IsVoiceKeyPressed() then
		mp.Icon(scrw / 2 - 16, scrh - 100, 32, 32, mp.Material.VOICE, C_W_100)
	end

	local tr = pl:GetEyeTrace().Entity

	if tr and tr:CPPIGetOwner() and not tr:IsWorld() then
		local owner = tr:CPPIGetOwner()

		if IsValid(owner) then
			local name = owner:Name()
			surface.SetFont(title_font)
			local tx, ty = surface.GetTextSize(name)
			tx = tx + 10
			ty = ty + 2

			draw.RoundedBox(0, 10, scrh / 3, tx, ty, ColorBackground_100)
			draw.SimpleText(name, title_font, 14, scrh / 3, C_W_200, 0, 0)
		end
	end
end

hook.Add("HUDPaint", "mp.MainHUD", MainHUD)

local function ThinkHUD()
	local pl = LocalPlayer()
	local scrw, scrh = ScrW(), ScrH()

	drawQuest(scrw, scrh, pl)

	local perk = hasPerk(pl)

	if perk then
		drawPerk(scrw, scrh, pl)
	end
end

hook.Add("Think", "mp.ThinkHUD", ThinkHUD)

local function WeaponDraw(pl)
	if pl:GetPos():Distance(LocalPlayer():GetPos()) or pl:GetNetVar("IsJail") > 1500 then return end

	local spec = pl:GetNetVar("meta_features")

	if spec and pl:Alive() then
		local Weapons = mp.profession[spec] and mp.profession[spec].draw_weapon

		if Weapons then
			local wep = weapons.Get(Weapons)
			local active = pl:GetActiveWeapon()

			if IsValid(wep) and (active:GetClass() ~= Weapons) and pl:HasWeapon(Weapons) then
				if not IsValid(pl.DrawWeaponSpec) then
					local model = ClientsideModel(wep.WorldModel)

					if IsValid(model) then
						model:SetNoDraw(true)
						model:SetPredictable(false)
						model:DrawShadow(false)
						model:DestroyShadow()
						model:SetMoveType(MOVETYPE_NONE)
						model:SetParent(pl)
						pl.DrawWeaponSpec = model
					end
				else
					if pl.DrawWeaponSpec:GetModel() ~= wep.WorldModel then
						pl.DrawWeaponSpec:SetModel(wep.WorldModel)
					end
				end
			else
				if IsValid(pl.DrawWeaponSpec) then
					pl.DrawWeaponSpec:Remove()
				end
			end
		else
			if IsValid(pl.DrawWeaponSpec) then
				pl.DrawWeaponSpec:Remove()
			end
		end
	end

	local model = pl.DrawWeaponSpec

	if not IsValid(model) then return end

	local mat = pl:GetBoneMatrix(pl:LookupBone("ValveBiped.Bip01_Spine2"))

	if not mat then return end

	local pos = mat:GetTranslation()
	local ang = mat:GetAngles()
	---- изменения оружия
	pos = pos + (ang:Right() * 4)
	pos = pos + (ang:Forward() * 6)
	pos = pos + (ang:Up() * 1)

	ang:RotateAroundAxis(ang:Right(), 185)
	ang:RotateAroundAxis(ang:Forward(), -170)
	ang:RotateAroundAxis(ang:Up(), 0)

	model:SetModelScale(.9)
	model:SetPos(pos)
	model:SetAngles(ang)

	model:SetRenderOrigin(pos)
	model:SetRenderAngles(ang)
	model:SetupBones()
	model:DrawModel()
	model:SetRenderOrigin()
	model:SetRenderAngles()
end

hook.Add("PostPlayerDraw", "mp.WeaponDraw", WeaponDraw)

local function SwitchWeaponDraw(pl, old, new)

end
hook.Add("PlayerSwitchWeapon", "mp.WeaponDraw", SwitchWeaponDraw)

net.Receive("QuestPlay.UpdateQuest", function()
	if IsValid(mp.HUDQuestPanel) then
		mp.HUDQuestPanel:Remove()
	end
end)

local lowhp = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -.2,
	["$pp_colour_contrast"] = 1.3,
	["$pp_colour_colour"] = .3,
	["$pp_colour_mulr"] = 0.05,
	["$pp_colour_mulg"] = 0.05,
	["$pp_colour_mulb"] = 0.05
}

local def = {
	["$pp_colour_addr"]       = .89, -- Добавляет красный
	["$pp_colour_addg"]       = .88, -- Добавляет зеленый
	["$pp_colour_addb"]       = .87, -- Добавляет синий
	["$pp_colour_brightness"] = -.88, -- Меняет яркость                         -1.70 (old)
	["$pp_colour_contrast"]   = .9, -- Контрасность                              1.05 (old)
	["$pp_colour_colour"]     = 1.05, -- Общий цвет (усиливает все цвета разом)        1.08 (old)
	["$pp_colour_mulr"]       = -0.05, -- -0.1 усиливает красный(установлено в минус, чтобы погасить избыток)
	["$pp_colour_mulg"]       = -0.05, -- -0.1 усиливает зеленый(установлено в минус, чтобы погасить избыток)
	["$pp_colour_mulb"]       = .5  -- -0.1 усиливает синий(установлено в минус, чтобы погасить избыток)
}

local function ColorModify()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	ply.ShowLowHP = ply.ShowLowHP or 0

	if (ply:Health() <= 15) and ply.ShowLowHP > CurTime() then
		DrawColorModify(lowhp)
		DrawMotionBlur(0.4, 0.8, 0.01)
	else
		DrawColorModify(def)
		DrawBloom(.65, 1, 2, 2, 0.5, 0.5, 0.5, 0.5, 0.5)
	end
end
hook.Add("RenderScreenspaceEffects", "rp.hud.ColorModify", ColorModify)
