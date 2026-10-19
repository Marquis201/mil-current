--[[-------------------------------------------------------------------------
	Обязательные методы:
		:SetPrice()
		:SetDescription()

	Популярные:
		:SetTerm()            --> Срок действия в днях (по умолчанию 0, т.е. одноразовая активация)
		:SetStackable()       --> Разрешает покупать несколько одинаковых предметов
		:SetCategory()        --> Группирует предметы
		:SetIcon()            --> Картинка, модель или материал в качестве иконки (пример в файле)
		:SetHighlightColor()  --> Цвет заголовка
		:SetDiscountedFrom()  --> Скидка
		:SetOnActivate()      --> Свое действие при активации
		:SetCanSee(false)     --> Скрытый предмет
		:SetCanSee(function(pl) return pl:HasPurchase("vip") end) --> Альтернативное применение

	Полезное:
		gm-donate.net/docs    -->  Подробнее о методах и все остальные
		gm-donate.net/support -->  Быстрая помощь и настройка от нас
		gm-donate.net/mods    -->  Бесплатные модули
---------------------------------------------------------------------------]]

-- Ниже примеры с объяснением

--[[-------------------------------------------------------------------------
	Разрешаем покупать отмычку а F4 только донатерам (DarkRP)
	https://img.qweqwe.ovh/1493244432112.png -- частичное объяснение
---------------------------------------------------------------------------]]

--[[
IGS("Отмычка", "otmichka") -- второй параметр не должен(!) повторяться с другими предметами
	:SetPrice(1) -- 1 рубль

	-- 0 - одноразовое (Т.е. купил, выполнилось OnActivate и забыл. Полезно для валюты)
	-- 30 - месяц, 7 - неделя и т.д. :SetPerma() - навсегда
	:SetTerm(30)

	:SetDarkRPItem("lockpick") -- реальный класс энтити
	:SetDescription("Разрешает вам покупать отмычку") -- описание
	:SetCategory("Оружие") -- категория

	-- квадратная ИКОНКА (Не обязательно). Отобразится на главной странице. Может быть с прозрачностью
	-- хостинг картинок: https://t.me/cfr2bot
	:SetIcon("https://file.def.pm/2o6vPVqA.png")

	-- иконку можно указать материалом, либо моделькой
	:SetIcon("icon16/disk.png", "material") -- "material" в конце
	:SetIcon("models/props_junk/Shoe001a.mdl", "model") -- "model" и путь к модельке

	-- БАННЕР 1000х400 (Не обязательно). Отобразится в подробностях итема
	:SetImage("https://file.def.pm/B2yfE47Z.png")

	-- Этот предмет будут видеть только те, кто купил group_vip_30d. У group_vip_30d должен быть :SetNetworked(true)
	:SetCanSee(function(pl) return pl:HasPurchase("group_vip_30d") end)

	-- Для разработчиков. С этим методом :HasPurchase("uid") будет работать не только на SERVER, но и на CLIENT
	:SetNetworked(true)
--]]

--[[-------------------------------------------------------------------------
	Доступ к энтити, оружию и машинам через спавнменю
---------------------сука не выдается------------------------------------------------------]]
 --[[IGS("CheyTack M200", "cheytac_m200")
	:SetPrice(330)
	:SetTerm(30)
	:SetCategory("Оружие")
 	:SetNetworked(true)
 	:SetMeta("weapons", "tfa_ins2_warface_cheytac_m200")



	 IGS("AK-12", "ak_12")
	:SetPrice(230)
	:SetTerm(30)
	:SetCategory("Оружие")
 	:SetNetworked(true)
 	:SetMeta("weapons", "tfa_ins2_ak12")]]

--[[-------------------------------------------------------------------------
	Доступ к профессиям
---------------------------------------------------------------------------]]

IGS("Дельта на месяц", "deltanato")
	:SetCategory("Подразделения")
	:SetDescription("")
	:SetPrice(350)
	:SetTerm(30)
	:SetNetworked(true)

IGS("ССО на месяц", "ssorf")
	:SetCategory("Подразделения")
	:SetDescription("")
	:SetPrice(350)
	:SetTerm(30)
	:SetNetworked(true)
--]]



--[[-------------------------------------------------------------------------
	Донат группы
---------------------------------------------------------------------------]]

IGS("VIP - 30 дней", "vip_30")
    :SetPrice(799)
    :SetTerm(30)
    :SetCategory("Привилегии")
    :SetDescription(
        "VIP — улучшенный статус с расширенными возможностями.\n" ..
        "- Открывает доступ ко второму персонажу.\n" ..
        "- Открывает доступ к вайтлисту.\n" ..
        "- Административные команды."
    )
	:SetImage("materials/military_play/donate/vip.png")
    :SetOnActivate(function(pl)
        serverguard.player:SetRank(pl, "vip", 86400 * 30)
    end)


IGS("VIP - 60 дней", "vip_60")
    :SetPrice(1599)
    :SetTerm(60)
    :SetCategory("Привилегии")
	:SetImage("materials/military_play/donate/vip.png")
    :SetDescription(
        "VIP — улучшенный статус с расширенными возможностями.\n" ..
        "- Открывает доступ ко второму персонажу.\n" ..
        "- Открывает доступ к вайтлисту.\n" ..
        "- Административные команды."
    )
    :SetOnActivate(function(pl)
        serverguard.player:SetRank(pl, "vip", 86400 * 60)
    end)

IGS("VIP - 90 дней", "vip_90")
    :SetPrice(2399)
    :SetTerm(90)
    :SetCategory("Привилегии")
	:SetImage("materials/military_play/donate/vip.png")
    :SetDescription(
        "VIP — улучшенный статус с расширенными возможностями.\n" ..
        "- Открывает доступ ко второму персонажу.\n" ..
        "- Открывает доступ к вайтлисту.\n" ..
        "- Административные команды."
    )
    :SetOnActivate(function(pl)
        serverguard.player:SetRank(pl, "vip", 86400 * 90)
    end)


--[[-------------------------------------------------------------------------
	Другое
---------------------------------------------------------------------------]]
-- Продажа говорилки        : https://forum.gm-donate.net/t/1059
-- Продажа моделек игрока   : https://forum.gm-donate.net/t/1003
-- Увеличение лимита пропов : https://forum.gm-donate.net/t/481/2
-- Тестовая VIP и тд        : https://forum.gm-donate.net/t/369
-- Доп. броня при спавне    : https://forum.gm-donate.net/t/395/10
-- Различные купоны         : https://forum.gm-donate.net/t/14
-- Изменения цветов меню    : https://forum.gm-donate.net/t/2500
-- Для разработчиков        : https://forum.gm-donate.net/t/168
-- Проблемы ваши и игроков  : https://forum.gm-donate.net/t/3305
-- Отображать при условии   : https://forum.gm-donate.net/t/6060
-- Динамичная цена итема    : https://forum.gm-donate.net/t/2125
-- Прочие ништяки: https://forum.gm-donate.net/tag/рекомендуем
