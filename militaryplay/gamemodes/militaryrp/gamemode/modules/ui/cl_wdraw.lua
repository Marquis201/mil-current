local Alpha = 0
local Fov = 0
local scrw, scrh = ScrW(), ScrH()

local mp = mp
local ColorAlpha = ColorAlpha
local Color = Color
local vgui = vgui
local draw = draw
local surface = surface
local Lerp = Lerp
local FrameTime = FrameTime
local CurTime = CurTime
local TimedCos = TimedCos

local jail_font = mp.font("65:Futura PT Light")
local jail_text = "Вы арестованы"

local C_W_125 = ColorAlpha(mp.Color.WHITE, 125)

local Concussion = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0.6,
	["$pp_colour_colour"] = 0.3,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local Default = {
	["$pp_colour_addr"] = -0.01,
	["$pp_colour_addg"] = 0.01,
	["$pp_colour_addb"] = 0.015,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 1.05,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

hook.Add("HUDPaint", "mp.Hud", function()
	local pl = LocalPlayer()
	if (WeaponSelection:ShouldDraw()) then
		WeaponSelection:Draw()
	end

	Alpha = math.Approach(Alpha, 0, FrameTime() * 100)

	mp.Icon(0, 0, scrw, scrh / 4, mp.Material.GRADIENT_U, ColorAlpha(mp.Color.RED, Alpha))
	mp.Icon(0, scrh - scrh / 4, scrw, scrh / 4, mp.Material.GRADIENT_D, ColorAlpha(mp.Color.RED, Alpha))
	mp.Icon(scrw - scrw / 4, 0, scrw / 4, scrh, mp.Material.GRADIENT_R, ColorAlpha(mp.Color.RED, Alpha))
	mp.Icon(0, 0, scrw / 4, scrh, mp.Material.GRADIENT_L, ColorAlpha(mp.Color.RED, Alpha))

	if IsValid(pl) and pl:IsArrested() then
		mp.Text(jail_text, jail_font, scrw / 2, 50, C_W_125, 1, 0)
	end

	if IsValid(pl) and (pl:GetConcussion() or pl:GetReviveInfo()) then
		DrawColorModify(Concussion)
		DrawMotionBlur(0.3, 0.5, 0.05)

		mp.Icon(0, 0, scrw, scrh / 4, mp.Material.GRADIENT_U,
			ColorAlpha(mp.Color.BLACK, TimedCos(0.2, 125, -85, CurTime())))
		mp.Icon(0, scrh - scrh / 4, scrw, scrh / 4, mp.Material.GRADIENT_D,
			ColorAlpha(mp.Color.BLACK, TimedCos(0.2, 125, -85, CurTime())))
		mp.Icon(scrw - scrw / 4, 0, scrw / 4, scrh, mp.Material.GRADIENT_R,
			ColorAlpha(mp.Color.BLACK, TimedCos(0.2, 125, -85, CurTime())))
		mp.Icon(0, 0, scrw / 4, scrh, mp.Material.GRADIENT_L,
			ColorAlpha(mp.Color.BLACK, TimedCos(0.2, 125, -85, CurTime())))
	else
		DrawColorModify(Default)
	end
end)

net.Receive("hp_dmgeffect", function()
	local pl = LocalPlayer()
	Alpha = 50

	if IsValid(pl) and pl:GetBlooding() then
		surface.PlaySound("blooding.mp3")
	end
end)

hook.Add("PlayerTick", "mp.ActionPoints", function(pl, move)
	--[[local GetFov = pl:GetInfoNum("fov_desired", 75)
	local Sprint

	Sprint = pl:GetVelocity():Length2D() > pl:GetRunSpeed() * 0.6 and pl:IsSprinting() and pl:OnGround()

	if Sprint then
		Fov = Lerp(FrameTime() * 1, Fov, GetFov + 10)
	elseif not pl:OnGround() and not pl:IsSprinting() then
		Fov = Lerp(FrameTime() * 1, Fov, math.Clamp(GetFov + 10 * (pl:GetVelocity():Length() / 1000), 75, 110))
	else
		Fov = Lerp(FrameTime() * 1, Fov, GetFov)
	end

	pl:SetFOV(Fov)]]
end)
