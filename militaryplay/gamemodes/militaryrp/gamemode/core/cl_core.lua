local Color = Color
local Material = Material
local notification = notification
local GM = GM
local hook = hook
local mp = mp
local NOTIFY_HINT = NOTIFY_HINT

mp.Color = {
	-- Default colors --
	WHITE = Color(255, 255, 255),
	BLACK = Color(0, 0, 0),
	RED = Color(255, 0, 0),
	GREEN = Color(55, 255, 55),
	BLUE = Color(0, 125, 255),
	CYAN = Color(125, 200, 255),
	BASE = Color(199, 181, 137),
	BASE_TO = Color(50, 50, 50),
	YELLOW = Color(255, 215, 0),
	ORANGE = Color(255, 150, 0),
	PURPLE = Color(200, 200, 255),

	-- Scoreboard --
	TIME = Color(255, 225, 150),

	-- Radio Menu --
	RADIO = Color(255, 168, 87),
}

WHITE = mp.Color.WHITE
BLACK = mp.Color.BLACK
RED = mp.Color.RED
GREEN = mp.Color.GREEN
BLUE = mp.Color.BLUE
ORANGE = mp.Color.ORANGE
YELLOW = mp.Color.YELLOW

mp.Material = {
	-- Default materials
	BACKGROUND = Material("background.png"),
	DMG = Material("dmg_effect.png"),
	CLOSE = Material("close.png"),
	GRADIENT_U = Material("vgui/gradient-u"),
	GRADIENT_L = Material("vgui/gradient-l"),
	GRADIENT_D = Material("vgui/gradient-d"),
	GRADIENT_R = Material("vgui/gradient-r"),
	GRADIENT_C = Material("gui/center_gradient"),
	DEAD = Material("dead.png"),
	VOICE = Material("voice.png"),
	SEATS = Material("seats.png"),

	-- CMenu
	MICRO_ON = Material("cmenu/micro_on.png"),
	MICRO_OFF = Material("cmenu/micro_off.png"),
	VOICE_ON = Material("cmenu/voice_on.png"),
	VOICE_OFF = Material("cmenu/voice_off.png"),
	FIRST_PERSON = Material("cmenu/first_person.png"),
	THIRD_PERSON = Material("cmenu/3d_person.png"),
	BLOOD = Material("context/blooding.png"),
	BURNS = Material("context/burns.png"),
	CONCUSSION = Material("context/concussion.png"),
	FRACTURE = Material("context/fracture.png"),
	HEAD = Material("context/head.png", "smooth"),
	LARM = Material("context/l_arm.png", "smooth"),
	LLEG = Material("context/l_leg.png", "smooth"),
	RARM = Material("context/r_arm.png", "smooth"),
	RLEG = Material("context/r_leg.png", "smooth"),
	TORSO = Material("context/torso.png", "smooth"),
	BODY = Material("context/body.png", "smooth"),
	BODY_TRASH = Material("context/body_trash.png", "smooth"),
	ARMOR = Material("context/armor.png"),
	HEALTH = Material("context/health.png"),
	AUTO = Material("cmenu/ammo_auto.png"),
	ONE_WEP = Material("cmenu/ammo_one.png"),
	CHARACTER = Material("cmenu/character.png"),
	CUSTOM_MENU = Material("cmenu/custom_menu.png"),
	RADIO_MENU = Material("cmenu/radio.png"),
	SAFE = Material("cmenu/safe_weapon.png"),

	-- Notification --
	CLEANUP = Material("notification/cleanup.png"),
	ERROR = Material("notification/error.png"),
	GENERIC = Material("notification/generic.png"),
	HINT = Material("notification/hint.png"),
	UNDO = Material("notification/undo.png"),

	-- Radio --
	MICRO = Material("radio/micro.png"),
	RADIO = Material("radio/radio.png"),
	SPEAK = Material("radio/speak.png"),

	-- Scoreboard --
	AVATAR = Material("tab/avatar_fon.png"),
	DEATH = Material("tab/death.png"),
	FRAGS = Material("tab/frags.png"),
	PINGS = Material("tab/pings.png"),
	OUTLINE = Material("tab/outline.png"),
	TAB_PATTERN_1 = Material("tab/tab_pattern_1.png"),
	TAB_PATTERN_2 = Material("tab/tab_pattern_2.png"),
	TAB_PATTERN_3 = Material("tab/tab_pattern_3.png"),
	TAB_PATTERN_4 = Material("tab/tab_pattern_4.png"),
	TAB_PATTERN_5 = Material("tab/tab_pattern_5.png"),
	TAB_PATTERN_1_1 = Material("tab/tab_pattern_1_1.png"),
	TAB_PATTERN_2_1 = Material("tab/tab_pattern_2_1.png"),
	TAB_PATTERN_3_1 = Material("tab/tab_pattern_3_1.png"),
	SET_MODEL = Material("tab/set_model.png"),

	-- Perks --
	LOCK = Material("perks/lock.png"),
	UNLOCK = Material("perks/unlock.png"),
	BACKGROUND_PERKS = Material("perks/background.png"),
	OPEN_PERKS = Material("perks/open.png"),
	ADD_PERKS = Material("perks/add.png"),
	CLOSE_PERKS = Material("perks/close.png"),
	SKIP_PERKS = Material("perks/skip.png"),

	-- Weapons --
	W_ONE = Material("weapons/one.png"),
	W_THREE = Material("weapons/three.png"),
	W_AUTO = Material("weapons/auto.png"),

	-- F1 Menu --
	LOGO = Material("help/logo.png", "smooth"),
	DISCORD = Material("help/discord.png", "smooth"),
	STEAM = Material("help/content.png", "smooth"),
	SITE = Material("help/site.png", "smooth"),
	RULES = Material("help/rules.png", "smooth"),
}

mp.Sound = {
	CLICK = "ui/click.wav",
	CLICK_2 = "ui/click_2.wav",
	CLICK_3 = "ui/click_3.wav",
	CLICK_4 = "ui/click_4.wav",
	CLICK_5 = "ui/click_5.wav",
	CLICK_6 = "ui/click_6.wav",
	CLICK_7 = "ui/click_7.wav",
	CLICK_8 = "ui/click_8.wav",
	CLICK_9 = "ui/click_9.wav",
	CLICK_10 = "ui/click_10.wav",

	DEPLOY = "ui/deploy.wav",
	DEPLOY_2 = "ui/deploy2.wav",

	ERROR = "ui/error.wav",
	ERROR_2 = "ui/error_2.wav",
	ERROR_3 = "ui/error_3.wav",
	ERROR_4 = "ui/error_4.wav",
	ERROR_5 = "ui/error_5.wav",

	HOVER = "ui/hover.wav",
	HOVER_2 = "ui/hover_2.wav",
	HOVER_3 = "ui/hover_3.wav",
	HOVER_4 = "ui/hover_4.wav",
	HOVER_5 = "ui/hover_5.wav",
	HOVER_6 = "ui/hover_6.wav",

	ROLLUP = "ui/rollup.wav",
	ROLLUP_2 = "ui/rollup2.wav",

	NOTIFY = "ui/rp_notify.wav",
	SELECT = "ui/select.wav",
	SIGNAL = "ui/signal.wav",
	DEATH = "ui/death.mp3",
}

function RemoveHud(name)
	local RemoveElement = {
		"CHudHealth",
		"CHudBattery",
		"CHudAmmo",
		"CHudSecondAmmo",
		"CHudCrosshair",
		"CHudGeiger",
		"CHudPoisonDamageIndicator",
		"CHudSquadStatus",
		"CHudTrain",
		"CHudVehicle",
		"CHudZoom",
		"CHUDQuickInfo",
		"CHudSuitPower",
		"CHudSecondaryAmmo",
		"CHudDeathNotice"
	}

	for k, v in pairs(RemoveElement) do
		if name == v then
			return false
		end
	end
end

hook.Add("HUDShouldDraw", "Remove", RemoveHud)

hook.Add("ChatText", "hide_joinleave", function(index, name, text, typ)
	if (typ == "joinleave") then return true end
end)

function GM:HUDAmmoPickedUp(itemName, amount)
	notification.AddLegacy("Боеприпасы " .. itemName .. ": " .. amount .. " шт.", NOTIFY_HINT, 4)
end

function GM:HUDWeaponPickedUp(itemName)
	notification.AddLegacy(itemName:GetPrintName(), NOTIFY_HINT, 4)
end

function GM:HUDItemPickedUp(itemName)
	notification.AddLegacy(itemName, NOTIFY_HINT, 4)
end

function GM:HUDDrawTargetID()
	return false
end

function GM:DrawDeathNotice()
	return false
end

function GM:SpawnMenuOpen()
	local pl = LocalPlayer()
	if not IsValid(pl) then return false end

	-- Проверка через ServerGuard
	if serverguard and serverguard.player then
		-- Проверка на конкретные группы
		local allowedRanks = {

		}

		local userGroup = serverguard.player:GetRank(pl)
		if userGroup and mp.config.spawn_menu[userGroup] then
			return true
		end

		-- Альтернативная проверка через права
		if serverguard.player:HasPermission(pl, "Spawnmenu") then
			return true
		end
	end

	return mp.config.spawn_menu[pl:GetUserGroup()]
end

local length = 1
local ease = 0.5
local amount = 25

hook.Add("PreGamemodeLoaded", "Reloaded_DVScrollBar_Control", function()
	local function sign(num)
		return num > 0
	end

	local function getBiggerPos(signOld, signNew, old, new)
		if signOld ~= signNew then return new end
		if signNew then
			return math.max(old, new)
		else
			return math.min(old, new)
		end
	end

	local dermaCtrs = vgui.GetControlTable("DVScrollBar")

	local tScroll = 0
	local newerT = 0

	function dermaCtrs:AddScroll(dlta)
		self.Old_Pos = nil
		self.Old_Sign = nil

		local OldScroll = self:GetScroll()

		dlta = dlta * amount

		local anim = self:NewAnimation(length, 0, ease)
		anim.StartPos = OldScroll
		anim.TargetPos = OldScroll + dlta + tScroll
		tScroll = tScroll + dlta

		local ctime = RealTime()
		local doing_scroll = true
		newerT = ctime

		anim.Think = function(anim, pnl, fraction)
			local nowpos = Lerp(fraction, anim.StartPos, anim.TargetPos)
			if ctime == newerT then
				self:SetScroll(getBiggerPos(self.Old_Sign, sign(dlta), self.Old_Pos, nowpos))
				tScroll = tScroll - (tScroll * fraction)
			end
			if doing_scroll then
				self.Old_Sign = sign(dlta)
				self.Old_Pos = nowpos
			end
			if ctime ~= newerT then doing_scroll = false end
		end

		return math.Clamp(self:GetScroll() + tScroll, 0, self.CanvasSize) ~= self:GetScroll()
	end

	derma.DefineControl("DVScrollBar", "Smooth Scrollbar", dermaCtrs, "Panel")
end)
