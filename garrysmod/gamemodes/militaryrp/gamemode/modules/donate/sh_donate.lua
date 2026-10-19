local mp = mp

mp.promocode = mp.promocode or {}

local function addpromo(id, t)
	mp.promocode[id] = t
end

--[[addpromo("УНИКАЛЬНЫЙ ID", {
	name = "Название промокода",
	limit = Количество активаций,
	check = function(pl) -- Дополнительная проверка (например для админа if not pl:IsAdmin() then return false end)
		return true
	end,
	add = function(pl) -- Функция при успешной активации промокода
		pl:AddIGSFunds(500)  --- сколько дает в рубликах
	end
})]]

addpromo("militaryplaystart", {
	name = "Military Play",
	limit = 1,
	check = function(pl)
		if pl:SteamID() ~= "STEAM_0:1:455594560" then return false end

		return true
	end,
	add = function(pl)
		pl:AddIGSFunds(350)
	end
})

addpromo("UPMILPLAY", {
	name = "Military Play",
	limit = 1,
	check = function(pl)
		if pl:SteamID() ~= "STEAM_0:1:455594560" then return false end

		return true
	end,
	add = function(pl)
		pl:AddIGSFunds(100)
	end
})



