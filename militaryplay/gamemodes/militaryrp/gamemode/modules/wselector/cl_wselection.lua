local ColorAlpha = ColorAlpha
local mp = mp
local draw = draw
local surface = surface

local Timer = 0
local Alpha = 0
local Weapon_ID = 0
local WeaponsCount = 0

WeaponSelection = {}

local Time = 0
local Weapons = {}
local TitleOffset = 0

local function GetWeaponCaching(weps)
	local tmp = {}
	for k, v in pairs(weps) do
		table.insert(tmp, v)
	end
	return tmp
end

function WeaponSelection:Draw()
	local Counter = 0
	local offset = (table.Count(Weapons) * 18)
	TitleOffset = offset

	Timer = math.Clamp(Timer - 1, 0, 9999)

	local scrw, scrh = ScrW(), ScrH()

	for k, v in pairs(Weapons) do
		if (v and IsValid(v)) then
			Counter = Counter + 1

			local title = v:GetPrintName()

			if (string.find(title:lower(), "#")) then
				title = language.GetPhrase(title)
			end

			if (Counter == Weapon_ID) then
				WeaponSelection:DrawWeaponItem(title, scrw - 155, (scrh / 2) - offset, true, Counter)
			else
				WeaponSelection:DrawWeaponItem(title, scrw - 155, (scrh / 2) - offset, false, Counter)
			end

			offset = offset - 25
		end
	end
end

local select_font = mp.font("30:Futura PT Medium")
local n_font = mp.font("20:Futura PT Medium")
local p_font = mp.font("25:Futura PT Medium")

function WeaponSelection:DrawWeaponItem(name, posx, posy, is_selected, counter)
	local Pweapon = Weapon_ID - 1
	local Nweapon = Weapon_ID + 1
	local scrw, scrh = ScrW(), ScrH()
	local FT = FrameTime()

	if Timer <= 0 then
		Alpha = math.Approach(Alpha, 0, FT * 300)
	else
		Alpha = math.Approach(Alpha, 255, FT * 200)
	end

	local font = select_font

	if counter == Nweapon then
		font = n_font
	elseif counter == Pweapon then
		font = p_font
	end

	surface.SetFont(font)
	local t_w, t_h = surface.GetTextSize(is_selected and "▶ " .. name or name)

	t_w, t_h = t_w + 15, t_h


	if is_selected then
		draw.RoundedBox(0, scrw / 1.35 - 5, scrh / 2 - t_h / 2 + 2, t_w, t_h, ColorAlpha(mp.Color.BASE_TO, Alpha / 5))

		surface.SetDrawColor(ColorAlpha(mp.Color.BASE, Alpha / 2))
		surface.DrawOutlinedRect(scrw / 1.35 - 5, scrh / 2 - t_h / 2 + 2, t_w, t_h, 1)

		draw.SimpleText("▶ " .. name, select_font, scrw / 1.35 + 1, scrh / 2 + 1, ColorAlpha(mp.Color.BASE_TO, Alpha), 0,
			1)
		draw.SimpleText("▶ " .. name, select_font, scrw / 1.35, scrh / 2, ColorAlpha(mp.Color.ORANGE, Alpha), 0, 1)
	end

	if counter == Nweapon then
		draw.SimpleText(name, n_font, scrw / 1.35 + 1, scrh / 2 + 31, ColorAlpha(mp.Color.BASE_TO, Alpha), 0, 1)
		draw.SimpleText(name, n_font, scrw / 1.35, scrh / 2 + 30, ColorAlpha(mp.Color.WHITE, Alpha), 0, 1)
	end

	if counter == Pweapon then
		draw.SimpleText(name, p_font, scrw / 1.35 + 1, scrh / 2 - 29, ColorAlpha(mp.Color.BASE_TO, Alpha), 0, 1)
		draw.SimpleText(name, p_font, scrw / 1.35, scrh / 2 - 30, ColorAlpha(mp.Color.WHITE, Alpha), 0, 1)
	end
end

function WeaponSelection:ShouldDraw()
	if (Time and Time + 4 > CurTime()) then
		return true
	end

	return false
end

function WeaponSelection:InitialCall()
	Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())
	local Current_Weapon = LocalPlayer():GetActiveWeapon()
	WeaponsCount = table.Count(Weapons)
	Weapon_ID = table.KeyFromValue(Weapons, Current_Weapon)
	timer.Create("refresh_weapons", 0.5, 0, function()
		Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())
		WeaponsCount = table.Count(Weapons)
	end)
end

function WeaponSelection:SetSelection(id)
	if (LocalPlayer():InVehicle()) then return false end
	Time = CurTime()
	WeaponSelection:InitialCall()
	Weapon_ID = id
end

-- We Force it to Draw!
function WeaponSelection:Call()
	if (WeaponSelection:ShouldDraw()) then
		Time = CurTime()

		surface.PlaySound(mp.Sound.SELECT)
	else
		Time = CurTime()
		WeaponSelection:InitialCall()

		surface.PlaySound(mp.Sound.SELECT)
	end
end

function WeaponSelection:NextWeapon()
	if (WeaponsCount > 0) then
	end
	if (! Weapon_ID) then Weapon_ID = 1 end
	if (WeaponsCount == Weapon_ID) then
		Weapon_ID = 1
	else
		Weapon_ID = Weapon_ID + 1
	end
end

function WeaponSelection:PrevWeapon()
	if (WeaponsCount > 0) then
	end
	if (! Weapon_ID) then Weapon_ID = 1 end
	if (Weapon_ID == 1) then
		Weapon_ID = WeaponsCount
	else
		Weapon_ID = Weapon_ID - 1
	end
end

function WeaponSelection:SelectWeapon()
	if (Weapon_ID and Weapons[Weapon_ID] and IsValid(Weapons[Weapon_ID])) then
		RunConsoleCommand("use", Weapons[Weapon_ID]:GetClass())
		timer.Destroy("refresh_weapons")

		if Alpha <= 0 then
			Time = 0
		end
	end
end

hook.Add("PlayerBindPress", "bindlolwtf", function(ply, bind, pressed)
	local wep = ply:GetActiveWeapon()

	if not IsValid(ply) then return end
	if bind == "invnext" and pressed and ! input.IsMouseDown(MOUSE_LEFT) then
		if (! ply:InVehicle()) then
			WeaponSelection:Call()
			WeaponSelection:NextWeapon()

			Timer = 255
		end
		return true
	elseif bind == "invprev" and pressed and ! input.IsMouseDown(MOUSE_LEFT) then
		if (! ply:InVehicle()) then
			WeaponSelection:Call()
			WeaponSelection:PrevWeapon()

			Timer = 255
		end
		return true
	elseif bind == "+attack" then
		if (WeaponSelection:ShouldDraw()) then
			WeaponSelection:Call()
			WeaponSelection:SelectWeapon()

			Timer = 0
			return true
		end
	elseif string.sub(bind, 1, 4) == "slot" and pressed then
		if wep.CW20Weapon and wep.dt.State == CW_CUSTOMIZE then return end

		if (! ply:InVehicle()) then
			WeaponSelection:Call()
			WeaponSelection:SelectWeapon()

			local weapons = LocalPlayer():GetWeapons()

			WeaponSelection:SetSelection(tonumber(string.sub(bind, 5, 6)))

			Timer = 255
		end

		return true
	end
end)
