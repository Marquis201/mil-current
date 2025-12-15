local mp = mp
local Vector = Vector
local Color = Color
local surface = surface
local draw = draw
local LocalPlayer = LocalPlayer
local ColorAlpha = ColorAlpha
local CurTime = CurTime

local death_text = "ВЫ МЕРТВЫ"
local enter_text = "Нажмите [ПРОБЕЛ] чтобы возродиться"
local enter_text_2 = "или дождитесь помощи!"

local time_font = mp.font("100:Futura PT Light")
local death_font = mp.font("40:Futura PT Medium")
local enter_font = mp.font("25:Futura PT Medium")

local color_red = Color(225, 75, 70)

local DEATH_MENU
local function UIDeath()
	if IsValid(DEATH_MENU) then DEATH_MENU:Remove() end

	local pl = LocalPlayer()
	local data = pl:GetReviveInfo()

	if not data then return end
	local time = data.death

	local sw, sh = ScrW(), ScrH()
	local pcol = Vector(pl:GetInfo("cl_playercolor"))
	local col = Color(pcol.x * 255, pcol.y * 255, pcol.z * 255)
	local respawn_time = data.time
	local TM = nil
	local LerpTM = sw

	pl:SetDSP(130)

	timer.Create("DeathTimer", 1, time - 1, function()
		surface.PlaySound(mp.Sound.CLICK_10)
	end)

	local DeathMenu = vgui.Create("EditablePanel")
	DEATH_MENU = DeathMenu
	DEATH_MENU:SetSize(sw, sh)
	DEATH_MENU:SetPos(0, 0)
	DEATH_MENU:SetAlpha(0)
	DEATH_MENU:AlphaTo(200, 0.1, 0)
	DEATH_MENU.Paint = function(self, w, h)
		if not pl:GetReviveInfo() then
			self:Remove()
			return
		end
		if not respawn_time then return end

		--draw.RoundedBox(0, 0, 0, w, h, color_black)

		TM = math.Round(respawn_time - CurTime())

		local t = TM * sw / time

		LerpTM = Lerp(FrameTime() * 1, LerpTM, t)

		if respawn_time >= CurTime() then
			if TM > 0 then
				draw.RoundedBox(0, w * .5 - (LerpTM * .5), h - 2, LerpTM, 2, mp.Color.WHITE)

				draw.SimpleText(TM, time_font, w * .5, h * .5, mp.Color.WHITE, 1, 1)
				draw.SimpleText(death_text, death_font, w * .5, h * .5 - 70,
					ColorAlpha(color_red, TimedCos(0.2, 100, -50, CurTime())), 1, 1)
			end
		else
			draw.SimpleText(enter_text, enter_font, sw * 0.5, sh - h * .5, mp.Color.WHITE, 1, 1)
			draw.SimpleText(enter_text_2, enter_font, sw * 0.5, sh - h * .5 + 20, mp.Color.WHITE, 1, 1)

			if input.IsKeyDown(KEY_SPACE) and respawn_time < CurTime() then
				net.Start("mp.Revive.Spawn")
				net.SendToServer()
			end
		end
	end

	DEATH_MENU.Think = function(self)
		self:MoveToBack()
	end
end

net.Receive("mp.DeathScreen", UIDeath)