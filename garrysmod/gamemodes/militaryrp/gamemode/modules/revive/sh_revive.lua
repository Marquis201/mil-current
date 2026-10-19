local mp = mp
local nw = nw
local PLAYER = PLAYER
local ColorAlpha = ColorAlpha

mp.Revive = mp.Revive or {}
mp.Revive.time = 5

function PLAYER:GetReviveInfo()
	return self:GetNetVar("revive.Info")
end

function PLAYER:GetRevive()
	return self:GetNetVar("isRevive")
end

nw.Register("isRevive")
	:Write(net.WriteFloat)
	:Read(net.ReadFloat)
	:SetPlayer()

nw.Register "revive.Info"
	:Write(function(v)
		net.WriteFloat(v.time)
		net.WriteFloat(v.death)
		net.WriteEntity(v.killer)
	end)
	:Read(function()
		local t = {}

		t.time = net.ReadFloat()
		t.death = net.ReadFloat()
		t.killer = net.ReadEntity()

		return t
	end)
	:SetPlayer()

if CLIENT then
	hook.Add("OnEntityCreated", "RevivalClientRagdollRemove", function(ent)
		if ent:GetClass() == "class C_HL2MPRagdoll" then
			ent:SetNoDraw(true)
		end
	end)

	local LerpAlpha = 0
	local LerpBar = 0
	local alphaColor = 0
	local text_font = mp.font("25:Futura PT Light")

	local scrw, scrh = ScrW(), ScrH()
	local color_bar = mp.Color.RED

	local function ReviveHUD()
		local pl = LocalPlayer()
		if not pl:GetRevive() then
			LerpBar = 0
			return
		end

		local procent = (mp.Revive.time - (pl:GetRevive() - CurTime())) * (250 / mp.Revive.time)
		local clr = color_bar:Lerp(mp.Color.BASE, procent / 250)

		LerpAlpha = Lerp(FrameTime() * 8, LerpAlpha, procent and 255 or 0)
		LerpBar = Lerp(FrameTime() * 8, LerpBar, procent)

		LerpBar = math.Clamp(LerpBar, 0, 250)

		draw.RoundedBox(4, scrw / 2 - 125, scrh / 2 + 45, 250, 8, ColorAlpha(mp.Color.BLACK, LerpAlpha / 2))
		draw.RoundedBox(4, scrw / 2 - 125, scrh / 2 + 45, LerpBar, 8,
			ColorAlpha(clr, LerpAlpha))

		draw.SimpleText("возрождение", text_font, scrw / 2, scrh / 2 + 40, ColorAlpha(mp.Color.WHITE, LerpAlpha), 1, 4)
	end
	hook.Add("HUDPaint", "ReviveHUD", ReviveHUD)
end
