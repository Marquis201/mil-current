--	ИНФОРМАЦИЯ НАД ГОЛОВОЙ	--

local mp = mp
local alpha = 0
local font_name_3d = mp.font("100:Futura PT Light")
local ColorAlpha = ColorAlpha
local Lerp = Lerp
local FrameTime = FrameTime
local Vector, Angle = Vector, Angle
local Color = Color
local Material = Material
local draw = draw

hook.Add("PostDrawTranslucentRenderables", "3D2DNicks", function(bDepth, bSkybox)
	if (bSkybox) then return end

	local lp = LocalPlayer()

	for _, pl in ipairs(ents.FindInSphere(lp:GetPos(), 300)) do
		if IsValid(pl) and pl:GetClass() == "player" then
			if (! pl:Alive()) then return end
			local job = mp.jobs[pl:Team()]

			local distance = lp:GetPos():Distance(pl:GetPos())

			if (distance < 300) then
				if (distance < 200) then
					alpha = Lerp(FrameTime() * 10, alpha, 255)
				else
					alpha = Lerp(FrameTime() * 10, alpha, 0)
				end

				local offset = Vector(0, 0, 80)
				local ang = lp:EyeAngles()
				local pos = pl:GetPos() + offset + ang:Up()
				local rank = pl:GetNetVar("meta_rank")

				ang:RotateAroundAxis(ang:Forward(), 90)
				ang:RotateAroundAxis(ang:Right(), 90)

				cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.05)


				if rank and mp.ranks[rank] and mp.ranks[rank].icon then
					mp.Icon(-92, -25, 92, 128, mp.ranks[rank].icon, ColorAlpha(mp.Color.WHITE, alpha))
					mp.Text(pl:Name(), font_name_3d, 15, -15, ColorAlpha(mp.Color.WHITE, alpha), 0, 0)
				else
					mp.Text(pl:Name(), font_name_3d, 0, -15, ColorAlpha(mp.Color.WHITE, alpha), 1, 0)
				end
				cam.End3D2D()
			else
				alpha = 0
			end
		end
	end
end)

------------------------------

--	УВЕДОМЛЕНИЯ	NOTIFY	--	--

local Notifications = {}
local FontNotify = mp.font("20:mr_ApexMk3MediumG")

local TypeNotify = {
	[NOTIFY_GENERIC] = {
		Color = Color(255, 225, 125),
		Icon = Material("notification/generic.png"),
	},
	[NOTIFY_ERROR] = {
		Color = Color(255, 124, 124),
		Icon = Material("notification/error.png"),
	},
	[NOTIFY_UNDO] = {
		Color = Color(109, 160, 255),
		Icon = Material("notification/undo.png"),
	},
	[NOTIFY_CLEANUP] = {
		Color = Color(225, 225, 225),
		Icon = Material("notification/cleanup.png"),
	},
	[NOTIFY_HINT] = {
		Color = Color(142, 255, 157),
		Icon = Material("notification/hint.png"),
	}
}

local function DrawNotification(x, y, w, h, text, icon, col, notif, alpha)
	draw.RoundedBox(0, x, y, h + 2, h, ColorAlpha(col, alpha / 2))
	draw.RoundedBox(0, x + h + 6, y, w - h, h, ColorAlpha(col, alpha / 2))

	mp.Icon(x + 5, y + 3, 24, 24, icon, ColorAlpha(color_black, alpha))

	mp.Text(text, FontNotify, x + 45, y + h / 2, ColorAlpha(color_black, alpha), 0, 1)
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
		col = TypeNotify[type].Color,
		icon = TypeNotify[type].Icon,
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
				v.alpha = math.Clamp(v.alpha + 5, 0, 255)
			else
				v.alpha = math.Clamp(v.alpha - 5, 0, 255)
			end

			v.y = Lerp(FrameTime() * 10, v.y, k * (v.h + 5))
		end

		for k, v in ipairs(Notifications) do
			if v.time < CurTime() then
				v.alpha = math.Clamp(v.alpha - 2, 0, 255)
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

------------------------------

--	--	ГОЛОСОВОЙ ЧАТ	--	--

local function CreateVoiceHUD()
	mp.Icon(ScrW() / 2 - 16, ScrH() - 128, 32, 32, mp.Material.VOICE, ColorAlpha(mp.Color.WHITE, 200))
end

hook.Add("PlayerStartVoice", "mp.PlayerStartVoice", function(pl)
	hook.Add("HUDPaint", "CreateVoiceHUD", CreateVoiceHUD)
end)

hook.Add("PlayerEndVoice", "mp.PlayerEndVoice", function(pl)
	hook.Remove("HUDPaint", "CreateVoiceHUD")
end)

------------------------------

--	--	--	СТАМИНА	--	--	--

local LerpAlpha = 0
local LerpAP = 0
local alphaColor = 0

local scrw, scrh = ScrW(), ScrH()

local color_bar = mp.Color.BASE
local color_red = Color(255, 100, 105)

local function CreateStaminHUD()
	local pl = LocalPlayer()
	local AP = pl:GetAP()
	local MaxAP = pl:GetMaxAP()

	local procent = (MaxAP - AP) / MaxAP
	local clr = color_bar:Lerp(color_red, procent)

	LerpAlpha = Lerp(FrameTime() * 4, LerpAlpha, AP ~= MaxAP and 255 or 0)
	LerpAP = Lerp(FrameTime() * 6, LerpAP, AP * 2.5)

	draw.RoundedBox(4, scrw / 2 - 125, scrh - 70, 250, 8, ColorAlpha(mp.Color.BLACK, LerpAlpha / 2))
	draw.RoundedBox(4, scrw / 2 - 125, scrh - 70, LerpAP, 8,
		ColorAlpha(clr, AP < MaxAP / 3 and TimedCos(0.5, LerpAlpha / 2, -LerpAlpha / 3, CurTime()) or LerpAlpha))
end
hook.Add("HUDPaint", "CreateStaminHUD", CreateStaminHUD)
