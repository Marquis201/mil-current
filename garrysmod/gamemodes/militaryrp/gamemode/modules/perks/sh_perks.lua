local mp = mp
local nw = nw
local net = net
local Material = Material

local dir = "materials/military_play/perks/"

mp.perks = mp.perks or {}
mp.perks.list = {}

local function addPerks(id, t)
	mp.perks.list[id] = t
end

addPerks("place_mine", {
	name = "Противотанковая мина",
	desc =
	[[Размещение противотанковой мины в установленном месте. Время жизни мины и количество ограничены. Чтобы активировать мину нажмите (Е)!]],
	icon = Material(dir .. "mines.png"),
	delay = 600,
	active = function(pl)
		local spawn_trace = util.QuickTrace(pl:GetShootPos(), pl:GetAimVector() * 1500, pl)
		if not spawn_trace.Hit or IsValid(spawn_trace.HitEntity) or spawn_trace.HitSky then
			mp.util.Notify(pl, NOTIFY_ERROR, "Смотрите на ровную поверхность или подойдите ближе!")
			return false
		end

		if spawn_trace.HitWorld and spawn_trace.HitNormal.z < 0.7 then
			mp.util.Notify(pl, NOTIFY_ERROR, "Неровная поверхность!")
			return false
		end

		local ent = ents.Create("perk_bomb")
		ent:SpawnFunction(pl, spawn_trace, "perk_bomb")
		ent:CPPISetOwner(pl)

		return true
	end
})

addPerks("ammo_crate", {
	name = "Ящик с боеприпасами",
	desc = [[Размещение ящика с боеприпасами на земле. Количество боеприпасов и время жизни ящика ограничены!]],
	icon = Material(dir .. "ammo_crate.png"),
	delay = 600,
	active = function(pl)
		local spawn_trace = util.QuickTrace(pl:GetShootPos(), pl:GetAimVector() * 1500, pl)
		if not spawn_trace.Hit or IsValid(spawn_trace.HitEntity) or spawn_trace.HitSky then
			mp.util.Notify(pl, NOTIFY_ERROR, "Смотрите на ровную поверхность или подойдите ближе!")
			return false
		end

		if spawn_trace.HitWorld and spawn_trace.HitNormal.z < 0.7 then
			mp.util.Notify(pl, NOTIFY_ERROR, "Неровная поверхность!")
			return false
		end

		local ent = ents.Create("perk_ammo")
		ent:SetPos(spawn_trace.HitPos)
		ent:Spawn()
		ent:Activate()
		ent:CPPISetOwner(pl)

		return true
	end
})

addPerks("armor_crate", {
	name = "Сумка с бронёй",
	desc = [[Размещение сумки с бронёй на земле. Количество брони и время жизни сумки ограничены!]],
	icon = Material(dir .. "armorkit.png"),
	delay = 600,
	active = function(pl)
		local spawn_trace = util.QuickTrace(pl:GetShootPos(), pl:GetAimVector() * 1500, pl)
		if not spawn_trace.Hit or IsValid(spawn_trace.HitEntity) or spawn_trace.HitSky then
			mp.util.Notify(pl, NOTIFY_ERROR, "Смотрите на ровную поверхность или подойдите ближе!")
			return false
		end

		if spawn_trace.HitWorld and spawn_trace.HitNormal.z < 0.7 then
			mp.util.Notify(pl, NOTIFY_ERROR, "Неровная поверхность!")
			return false
		end

		local ent = ents.Create("perk_armor")
		ent:SetPos(spawn_trace.HitPos)
		ent:Spawn()
		ent:Activate()
		ent:CPPISetOwner(pl)

		return true
	end
})

addPerks("repair_vehicle", {
	name = "Ремонт техники",
	desc = [[Скорость ремонта техники при помощи инструмента увеличивается.]],
	icon = Material(dir .. "vehicle.png"),
	delay = 600,
	duration = 60,
})

addPerks("medkit_crate", {
	name = "Сумка с медикаментами",
	desc = [[Размещение сумки с медикаментами на земле. Количество препаратов и время жизни сумки ограничены!]],
	icon = Material(dir .. "medkit.png"),
	delay = 600,
	active = function(pl)
		local spawn_trace = util.QuickTrace(pl:GetShootPos(), pl:GetAimVector() * 1500, pl)
		if not spawn_trace.Hit or IsValid(spawn_trace.HitEntity) or spawn_trace.HitSky then
			mp.util.Notify(pl, NOTIFY_ERROR, "Смотрите на ровную поверхность или подойдите ближе!")
			return false
		end

		if spawn_trace.HitWorld and spawn_trace.HitNormal.z < 0.7 then
			mp.util.Notify(pl, NOTIFY_ERROR, "Неровная поверхность!")
			return false
		end

		local ent = ents.Create("perk_medkit")
		ent:SetPos(spawn_trace.HitPos)
		ent:Spawn()
		ent:Activate()
		ent:CPPISetOwner(pl)

		return true
	end
})

addPerks("add_speed", {
	name = "Стимулятор",
	desc = [[Мгновенно восстанавливает часть стамины. Расход стамины замедляется, пока действует препарат.]],
	icon = Material(dir .. "stamina.png"),
	delay = 600,
	duration = 60,
	active = function(pl)
		pl:AddAP(50)
		pl:EmitSound("items/medshot4.wav", 45, 80, 1, CHAN_AUTO)

		return true
	end
})

addPerks("place_bomb", {
	name = "Авиаудар",
	desc = [[Сбрасывание бомбы в указанную точку. Точка и время сброса видны всем!]],
	icon = Material(dir .. "bomb.png"),
	delay = 600,
	active = function(pl)
		local spawn_trace = util.QuickTrace(pl:GetShootPos(), pl:GetAimVector() * 4000, pl)
		if not spawn_trace.Hit or IsValid(spawn_trace.HitEntity) or spawn_trace.HitSky then
			mp.util.Notify(pl, NOTIFY_ERROR, "Смотрите на ровную поверхность или подойдите ближе!")
			return false
		end

		if spawn_trace.HitWorld and spawn_trace.HitNormal.z < 0.7 then
			mp.util.Notify(pl, NOTIFY_ERROR, "Неровная поверхность!")
			return false
		end

		local ent = ents.Create("perk_rocket")
		ent:Spawn()
		ent:Activate()
		ent:SpawnFunction(pl, spawn_trace, "perk_rocket")

		return true
	end
})

addPerks("protect_damage", {
	name = "Бронежилет",
	desc = [[Снижает получаемый урон на время.]],
	icon = Material(dir .. "armor.png"),
	delay = 600,
	duration = 60,
	active = function(pl)
		pl:EmitSound("items/battery_pickup.wav", 45, 125, 1, CHAN_AUTO)

		return true
	end
})

nw.Register("mp.Perks")
	:Write(function(t)
		net.WriteString(t.id)
		net.WriteFloat(t.delay)
		net.WriteFloat(t.duration)
	end)
	:Read(function()
		local t = {
			id = net.ReadString(),
			delay = net.ReadFloat(),
			duration = net.ReadFloat()
		}

		return t
	end)
	:SetLocalPlayer()
