thirdperson_enabled = thirdperson_enabled or false
local dist = dist or 0
local freecam_ang = nil

-- meta.thirtperson = meta.thirtperson or {
--     x = 120,
--     y = 100,
--     z = 40
-- }
-- local x = 120
-- local y = 100
-- local z = 15

local xmin, xmax = 0, 200
local ymin, ymax = -100, 100
local zmin, zmax = -100, 100

local fov = 90
local dist = 1

local view = {}

thirtperson = thirtperson or {}
thirtperson.x = CreateClientConVar('thirtperson_x', "60", true, false)
thirtperson.y = CreateClientConVar('thirtperson_y', "60", true, false)
thirtperson.z = CreateClientConVar('thirtperson_z', "40", true, false)

hook.Add("CalcView", "mp.CalcView", function(pl, pos, ang, fov, nearz, farz)
	local wep = pl:GetActiveWeapon()

	pl.camera_ang = pl:EyeAngles()

	if wep and IsValid(wep) and wep.SWBWeapon and not cvar.GetValue("enable_thirdperson") and wep.dt then
		local w_pos, w_ang, w_fov = wep:CalcView(pl, pos, ang, fov)

		if wep.dt.State == SWB_AIMING then
			if wep.DelayedZoom then
				if CT > wep.AimTime then
					if wep.SnapZoom then
						wep.CurFOVMod = wep.ZoomAmount
					else
						wep.CurFOVMod = Lerp(FrameTime() * 15, wep.CurFOVMod, wep.ZoomAmount)
					end
				else
					wep.CurFOVMod = Lerp(FrameTime() * 15, wep.CurFOVMod, 0)
				end
			else
				if wep.SnapZoom then
					wep.CurFOVMod = wep.ZoomAmount
				else
					wep.CurFOVMod = Lerp(FrameTime() * 15, wep.CurFOVMod, wep.ZoomAmount)
				end
			end
		else
			wep.CurFOVMod = Lerp(FrameTime() * 15, wep.CurFOVMod, 0)
		end

		fov = math.Clamp(fov - wep.CurFOVMod, 5, 90)

		view.origin = w_pos
		view.fov = fov
		view.angles = pl.camera_ang
		view.drawviewer = false

		return view
	end

	local x = tonumber(thirtperson.x:GetString())
	local y = tonumber(thirtperson.y:GetString())
	local z = tonumber(thirtperson.z:GetString())

	y = y < .5 and (y - .5) / 2 or y - .5
	y = y * 2 * 30
	z = z < .5 and (z - .5) / 2 or z - .5
	z = z * 2 * -30

	if ((thirdperson_enabled or dist > 0)) or pl.sup_act then
		if (thirdperson_enabled) then
			dist = math.min(dist + (1 - dist) * FrameTime() * 4, 1)

			if (dist > .99) then
				dist = 1
			end
		else
			dist = math.max(dist - dist * FrameTime() * 10, 0)

			if (dist < .01) then
				dist = 0
				pl.BLACK = 0
			end
		end

		if (freecam_ang and ! pl:KeyDown(IN_WALK)) then
			pl.camera_ang = Angle(freecam_ang.p, freecam_ang.y, freecam_ang.r)
			freecam_ang = nil
		elseif (! freecam_ang and pl:KeyDown(IN_WALK)) then
			freecam_ang = Angle(pl.camera_ang.p, pl.camera_ang.y, pl.camera_ang.r)
		end

		pos = pos + (pl.camera_ang:Forward() * dist * (-math.Clamp(x, xmin, xmax))) +
			(pl.camera_ang:Right() * dist * (math.Clamp(y, ymin, ymax))) +
			(pl.camera_ang:Up() * dist * (math.Clamp(z, zmin, zmax)))

		local hulltr = util.TraceHull({
			start = pl:GetShootPos(),
			endpos = pos,
			filter = player.GetAll(),
			mask = MASK_SHOT_HULL,
			mins = Vector(-10, -10, -10),
			maxs = Vector(10, 10, 10)
		})

		if (hulltr.Hit) then
			pos = hulltr.HitPos + (pl:GetShootPos() - hulltr.HitPos):GetNormal() * 10
		end

		local aimtr = util.TraceLine({
			start = pos + (pl.camera_ang:Forward() * (-z + 45)),
			endpos = pos + (pl.camera_ang:Forward() * 100000),
			filter = pl
		})

		view.origin = pos
		view.fov = fov
		view.angles = pl.camera_ang
		view.drawviewer = true

		if (thirdperson_enabled and pl:GetMoveType() == MOVETYPE_NOCLIP) then
			pl:SetEyeAngles(freecam_ang or pl.camera_ang)
		end

		return view
	else
		if (view and view.drawviewer) then
			view.drawviewer = false
			return view
		end
	end
end)

hook.Add("ShouldDrawLocalPlayer", "Thirdperson_ShouldDrawPlayer", function(pPlayer)
	return thirdperson_enabled
end)

netstream.Hook("thirdperson_toggle", function(data)
	if ! (LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():Team() == TEAM_UNASSIGNED) then
		thirdperson_enabled = not thirdperson_enabled
	end
end)
