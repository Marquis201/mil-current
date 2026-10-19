local ColorAlpha = ColorAlpha
local mp = mp
local draw = draw
local surface = surface

local weaponMap = {}
local weaponName = {
	gmod_tool = "Тулган",
	weapon_physgun = "Физган",
	gmod_camera = "Камера",
	weapon_bugbait = "Говно",
	weapon_physcannon = "Гравитиган",
	tfa_fas2_ifak = "Аптечка",
	weapon_medkit = "Аптечка"
}

local sandbox = { "gmod_tool", "weapon_physgun", "gmod_camera", "weapon_bugbait", "weapon_physcannon", "weapon_medkit" }
local roleplay = { "weapon_fists", "anim_infront", "anim_holo", "anim_five", "anim_comlink", "anim_fuckoff",
	"anim_surrender", "anim_cross", "anim_point", "tfa_fas2_ifak", "sw_laser_pointer_v3", "tfa_realistic_taser",
	"weapon_lvsrepair", "revive_swep", "alydus_fortificationbuildertablet", "arrest_baton", "realistic_hook",
	"handcuffed", "unarrest_baton", "weapon_hands" }
local lite = { "weapon_357", "weapon_crowbar", "weapon_pistol", "weapon_smg1", "weapon_stunstick",
	"tfa_ins2_warface_bt_mp9", "tfa_ins2_colt_m45", "tfa_ins2_deagle", "tfa_ins2_glock_19", "tfa_inss2_hk_mp5a5",
	"tfa_ins2_uzi", "tfa_ins2_thanez_cobra", "tfa_at_kriss_vector", "tfa_ins2_wpn_m1911colt", "tfa_ins2_wpn_m45a1",
	"tfa_ins2_m9", "tfa_ins2_pm", "tfa_ins2_wpn_38revolver", "tfa_ins2_wpn_hkmp5kpdw", "tfa_ins2_mp7", "tfa_ins2_mr96",
	"tfa_eft_vityaz", "tfa_ins2_usp_match", "tfa_ins2_ump45", "tfa_ins2_walther_p99", }
local heavy = { "tfa_ins2_wpn_ac556", "tfa_ins2_acr", "tfa_ins2_ak103", "tfa_ins2_ak12", "tfa_at_ak_15",
	"tfa_ins2_wpn_ak74izh", "tfa_ins2_akm", "tfa_ins2_wpn_akms", "tfa_ins2_wpn_aks74ukor", "tfa_ins2_abakan",
	"tfa_inss_asval", "tfa_ins2_aug_a3", "tfa_ins2_warface_awm",
	"tfa_ins2_ax50_upver", "tfa_ins2_barrett_m98_bravo", "tfa_ins2_warface_cheytac_m200", "tfa_ins2_famas",
	"tfa_ins2_fn_fal", "tfa_ins2_wpn_hkg36compact", "tfa_ins2_fas2_g36c", "tfa_ins2_wpn_imigalilarm",
	"tfa_ins2_wpn_imigalilsar", "tfa_ins2_hk_mg36", "tfa_ins2_416c", "tfa_ins2_galil", "tfa_ins2_izh43sw",
	"tfa_ins2_k98", "tfa_ins2_wpn_l1a1", "tfa_ins2_wpn_m1a1carbine", "tfa_ins2_m1014", "tfa_ins2_wpn_mk14ebr",
	"tfa_ins2_wpn_coltm16a4", "tfa_ins2_wpn_m249saw", "tfa_m4tech", "tfa_ins2_wpn_m40a1", "tfa_ins2_m4a1",
	"tfa_ins2_wpn_coltm4a1", "tfa_ins2_m500", "tfa_ins2_wpn_mossberg590", "tfa_ins2_mk18", "tfa_ins2_nova",
	"tfa_ins2_warface_orsis_t5000", "tfa_ins2_pkp", "tfa_ins2_norinco_qbz97", "tfa_ins2_remington_m24_sws",
	"tfa_ins2_remington_m870", "tfa_ins2_pd2_remington_msr", "tfa_ins2_wpn_rpkalash",
	"tfa_ins2_l85a2", "tfa_ins2_scar_h_ssr",
	"tfa_ins2_wpn_sksimonov", "tfa_ins2_sks", "tfa_ins2_spas12", "tfa_ins2_sr25_eft", "tfa_eft_svd",
	"tfa_ins2_wpn_tozshotgun", "weapon_ar2", "weapon_crossbow", "weapon_shotgun" }

local grenade = { "tfa_ins2_wpn_at4", "tfa_ins2_wpn_rpg7", "weapon_hoff_briefcasebomb", "weapon_rpg", "weapon_slam" }

for k, v in ipairs(sandbox) do
	weaponMap[v] = { Slot = 1 }
end

for k, v in ipairs(roleplay) do
	weaponMap[v] = { Slot = 2 }
end

for k, v in ipairs(lite) do
	weaponMap[v] = { Slot = 3 }
end

for k, v in ipairs(heavy) do
	weaponMap[v] = { Slot = 4 }
end

for k, v in ipairs(grenade) do
	weaponMap[v] = { Slot = 5 }
end

do
	local clr, mat = Color, Material

	local math_clamp, table_Count, table_Empty, math_Round = math.Clamp, table.Count, table.Empty, math.Round
	local vec, ang = Vector, Angle

	local ui_lerp, alpha = Lerp, ColorAlpha
	local roundedBox, roundedBoxEx = draw.RoundedBox, draw.RoundedBoxEx

	local function getWeaponSlot(wep)
		local class = wep:GetClass()
		if string.sub(class, 1, 3) == "bb_" then return 3 end
		if string.sub(class, 1, 4) == "csgo" or string.sub(class, #class - 4, #class) == "ghost" then return 5 end
		local sub_11 = string.sub(class, 1, 11)
		if sub_11 == "weapon_cuff" then return 2 end
		if sub_11 == "weapon_vape" then return 6 end

		if (wep.GetSwitcherSlot) then
			wep.Slot = wep:GetSwitcherSlot()
		end

		local map = weaponMap[class]

		if wep.CW20Weapon then
			return (map and map.Slot) or 3
		else
			return (map and map.Slot) or (wep.Slot and math_clamp(wep.Slot, 2, 4)) or 2
		end
	end

	local weaponsByCategory = {}
	local weaponsByOrder = {}
	local weaponsByClass = {}
	local selectedWeapon = -1
	local lastCache = CurTime()

	local categories_weapons = {
		{
			name = "Песочница",
		},

		{
			name = "Ролеплей",
		},

		{
			name = "Легкое",
		},

		{
			name = "Тяжелое",
		},

		{
			name = "Взрывчатка",
		},

		{
			name = "Другое",
		},
	}

	local function ensureWeapons(force)
		local pl = LocalPlayer()
		local weps = pl:GetWeapons()

		if (lastCache <= CurTime() or force) then
			weaponsByCategory = {}
			weaponsByOrder = {}
			weaponsByClass = {}

			for k, cat in ipairs(categories_weapons) do
				local wepSlot = k
				weaponsByCategory[wepSlot] = {}

				for _, wep in pairs(weps) do
					if (getWeaponSlot(wep) == wepSlot) then
						local ind = table.insert(weaponsByCategory[wepSlot], {
							ID = #weaponsByOrder + 1,
							Class = wep:GetClass(),
							Name = (weaponName[wep:GetClass()]) or wep.PrintName or wep:GetClass()
						})

						weaponsByOrder[#weaponsByOrder + 1] = weaponsByCategory[wepSlot][ind]
						weaponsByClass[wep:GetClass()] = weaponsByCategory[wepSlot][ind]
					end
				end
			end
		end

		if (selectedWeapon == 0 and IsValid(pl:GetActiveWeapon()) and weaponsByClass[pl:GetActiveWeapon():GetClass()]) then
			selectedWeapon = weaponsByClass[pl:GetActiveWeapon():GetClass()].ID
		end

		lastCache = CurTime() + 0.25
	end

	local showTime = 0
	local fadeTime = 0
	local a = 0
	local LerpAlpha = 0

	local ColorBackground = ColorAlpha(mp.Color.BASE_TO, 200)
	local ColorBackground_100 = ColorAlpha(mp.Color.BASE_TO, 150)
	local ColorOutline = ColorAlpha(mp.Color.BASE, 25)

	local cat_font = mp.font("20:DIN Pro Regular")
	local name_font = mp.font("20:Futura PT Book")

	local function TruncateString(str, maxLen)
		if utf8.len(str) <= maxLen then
			return str
		else
			return utf8.sub(str, 1, maxLen) .. "..."
		end
	end

	local function UIWeaponSelector(pl, scrw, scrh)
		local w, h = 184, 28
		local st = SysTime()
		if LerpAlpha and showTime and LerpAlpha <= 10 and showTime + 0.25 <= st then return end

		ensureWeapons()

		if (showTime <= st) then
			a = ui_lerp((st - showTime) / 0.1, 255, 0)
		else
			a = ui_lerp((st - fadeTime) / 0.1, 0, 255)
		end

		LerpAlpha = ui_lerp(FrameTime() * 6, LerpAlpha or 0, a or 0)

		local not_clear_cat = 0

		for k, cat in ipairs(categories_weapons) do
			if not weaponsByCategory[k] then continue end
			if #weaponsByCategory[k] < 1 then continue end
			not_clear_cat = not_clear_cat + 1
		end

		local x, y = (scrw - not_clear_cat * (w + 5)) * 0.5, 0

		if (showTime <= st) then
			y = ui_lerp((st - showTime) / 0.1, 255, -196)
		else
			y = ui_lerp((st - fadeTime) / 0.1, 0, 24)
		end

		LerpY = ui_lerp(FrameTime() * 6, LerpY or 0, y or 0)

		if LerpY == -196 then return end

		local last_checked = 0
		for k, cat in ipairs(categories_weapons) do
			if weaponsByCategory[k] and #weaponsByCategory[k] < 1 then continue end
			last_checked = last_checked + 1
			local x, y = x + ((last_checked - 1) * (w + 10)), LerpY
			local wepSlot = k

			draw.NoTexture()
			draw.RoundedBox(0, x + 2 + h, y, w - h - 2, h, ColorBackground)
			draw.RoundedBox(0, x, y, h, h, ColorBackground)

			surface.SetDrawColor(ColorOutline)
			surface.DrawOutlinedRect(x + 2 + h, y, w - h - 2, h, 1)
			surface.DrawOutlinedRect(x, y, h, h, 1)

			draw.SimpleText(cat.name, cat_font, x + w / 2 + 2 + h / 2, y + h * 0.5 - 1, alpha(WHITE, LerpAlpha), 1, 1)
			draw.SimpleText(wepSlot, cat_font, x + h / 2, y + h * 0.5 - 1, alpha(WHITE, LerpAlpha), 1, 1)

			if weaponsByCategory[wepSlot] then
				for i, wep in ipairs(weaponsByCategory[wepSlot]) do
					local y = y + (i * (h + 2))
					--local select_mat
					local select_col
					local select_col2 = WHITE

					--[[if wepSlot == 1 then
						select_mat = rp.materials.hudselectconstr
					elseif wepSlot == 2 then
						select_mat = rp.materials.hudselectknife
					elseif wepSlot == 3 then
						select_mat = rp.materials.hudselectwep
					elseif wepSlot == 4 then
						select_mat = rp.materials.hudselectother
					elseif wepSlot == 5 then
						select_mat = rp.materials.hudselectknife
					elseif wepSlot == 6 then
						select_mat = rp.materials.hudselectvape
					end

					draw.UIImage(x, y, w, h, alpha(WHITE, LerpAlpha), select_mat)]]

					if (wep.ID == selectedWeapon) then
						select_col = alpha(mp.Color.ORANGE, 100)
					elseif IsValid(pl:GetActiveWeapon()) and wep and weaponsByClass[pl:GetActiveWeapon():GetClass()] and wep.ID == weaponsByClass[pl:GetActiveWeapon():GetClass()].ID then
						select_col = alpha(mp.Color.BASE, LerpAlpha)
						select_col2 = mp.Color.BASE_TO
					else
						select_col = alpha(mp.Color.WHITE, 0)
					end

					draw.RoundedBox(0, x + 2 + h, y, w - h - 2, h, ColorBackground_100)

					draw.RoundedBox(0, x + 2 + h, y, w - h - 2, h, select_col)

					surface.SetDrawColor(ColorOutline)
					surface.DrawOutlinedRect(x + 2 + h, y, w - h - 2, h, 1)

					surface.SetDrawColor(select_col)
					surface.DrawOutlinedRect(x + 2 + h, y, w - h - 2, h, 1)


					draw.SimpleText(TruncateString(wep.Name, 16), name_font, x + w / 2 + 2 + h / 2, y + h * 0.5 - 1,
						select_col2, 1, 1)

					--draw.SimpleText(wep.Name, n_font, x + 36, y + (h * 0.5) - 2, select_col, 0, 1)
					--draw.SimpleText(i, n_font, x + 16, y + (h * 0.5) - 2, select_col, 1, 1)
				end
			end
		end
	end

	local lastSnd = 0

	hook.Add("PlayerBindPress", "mp.wepswitch.PlayerBindPress", function(pl, bind, pressed)
		if (not pressed) then return end
		if (not pl:Alive()) then return end
		if pl:InVehicle() then return end

		if (not IsValid(pl:GetActiveWeapon())) then
			if #pl:GetWeapons() > 1 then
				RunConsoleCommand("use", table.Random(pl:GetWeapons()):GetClass())
			end

			return
		end

		if pl:GetActiveWeapon().dt and pl:GetActiveWeapon().dt.State and pl:GetActiveWeapon().dt.State == 4 then return end
		if (#pl:GetWeapons() <= 0) then return end
		local wep = pl:GetActiveWeapon()

		if IsValid(wep) and wep.SWBWeapon and wep.dt and (wep.dt.State == SWB_AIMING) and wep.AdjustableZoom then return end

		if ((bind == "invprev") or (bind == "invnext") or (string.sub(bind, 1, 4) == "slot")) and (not pl:KeyDown(IN_ATTACK)) then
			if (string.sub(bind, 1, 3) == "inv") then
				if (showTime < SysTime()) then
					ensureWeapons(true)
					selectedWeapon = weaponsByClass[pl:GetActiveWeapon():GetClass()].ID
				end

				local scroll = (bind == "invprev") and -1 or 1
				selectedWeapon = selectedWeapon + scroll

				if (not weaponsByOrder[selectedWeapon]) then
					selectedWeapon = (scroll == 1 and 1) or #weaponsByOrder
				end
			else -- using number keys
				if (showTime < SysTime()) then
					ensureWeapons(true)
					fadeTime = SysTime()
				end

				local slot = tonumber(string.sub(bind, -1))
				if (not categories_weapons[slot]) then return end
				if #weaponsByCategory[slot] < 1 then return end

				if (weaponsByCategory[slot][1]) then
					local found = false

					for k, v in ipairs(weaponsByCategory[slot]) do
						if (v.ID == selectedWeapon) then
							found = true

							if (weaponsByCategory[slot][k + 1]) then
								selectedWeapon = v.ID + 1
							else
								selectedWeapon = weaponsByCategory[slot][1].ID
							end

							break
						end
					end

					if (not found) then
						selectedWeapon = weaponsByCategory[slot][1].ID
					end
				end
			end

			ensureWeapons(true)
			showTime = SysTime() + 2

			if (lastSnd < SysTime() - 0.05) then
				--surface.PlaySound(rp.sounds.hover5)
				lastSnd = SysTime()
			end
		elseif (showTime > SysTime() and bind == "+attack") then
			if (IsValid(pl:GetActiveWeapon()) and weaponsByOrder[selectedWeapon] and weaponsByClass[pl:GetActiveWeapon():GetClass()] and selectedWeapon ~= weaponsByClass[pl:GetActiveWeapon():GetClass()].ID) then
				RunConsoleCommand("use", weaponsByOrder[selectedWeapon].Class)
			end

			showTime = 0
			fadeTime = SysTime()
			--surface.PlaySound(rp.sounds.click3)

			return true
		elseif (bind == "phys_swap") then
			showTime = 0
		end
	end)

	hook.Add("HUDPaint", "mp.wepswitch.HUDPaint", function()
		local pl = LocalPlayer()
		local scrw, scrh = ScrW(), ScrH()

		UIWeaponSelector(pl, scrw, scrh)
	end)
end
