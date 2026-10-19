local mp = mp
local netstream = netstream
local string_Implode = table.concat
local concommand = concommand
local Color = Color
local player = player
local color_white = color_white
local hook = hook
local IsValid = IsValid
local ents = ents

local function DealyCommad(pl)
	pl.NextChatRPCommad = pl.NextChatRPCommad or 0

	if pl.NextChatRPCommad > CurTime() then
		mp.util.Notify(pl, NOTIFY_ERROR,
			"Следующее использование этой команды через " .. math.Round(pl.NextChatRPCommad - CurTime()) .. " сек.")

		return false
	end

	pl.NextChatRPCommad = CurTime() + math.random(20, 30)

	return true
end

mp.commands.data = mp.commands.data or {}

function mp.commands.add(arg, callback)
	mp.commands.data[arg] = callback
end

function mp.commands.callback(pl, cmd, args, str)
	if pl.sg_jail then return end

	if (! (args[1]) or args == {}) then
		print("This is a basic command for mp gamemode.")
	end

	if table.HasValue(table.GetKeys(mp.commands.data), args[1]) then
		local com = args[1]
		-- table.remove(args, 1);
		mp.commands.data[com](pl, cmd, args)

		hook.Call("cmd.OnCommandRun", nil, pl, cmd, args)
	elseif (args[1] or args == {}) then
		print("Errors of the argument!")
	end
end

function mp.commands.autoComplete(commandName, args)
	local return_table = {}
	for _, name in pairs(table.GetKeys(mp.commands.data)) do
		table.insert(return_table, string.format("mp %s", name))
	end
	return return_table
end

local function CharacterChange(pl, cmd, args)
	pl:RequestCharacters(function(characters, player_data)
		netstream.Start(pl, "OpenCharacterMenu", { characters = characters })
	end)
end

mp.commands.add("char", CharacterChange)

-- local function Helmet(pl, cmd, args)
-- 	pl.helmet = not pl.helmet

-- 	local bnum = pl.helmet and 1 or 0

-- 	for k, v in pairs(pl:GetBodyGroups()) do
-- 		if v.name == "helmet" or v.name == "visor" then
-- 			pl:SetBodygroup(v.id, bnum)
-- 		end
-- 	end
-- end

-- mp.commands.add("helmet", Helmet)

local function EventRoom(pl, cmd, args)
	if not pl:IsAdmin() then return end

	netstream.Start(pl, "OpenEventroomMenu")
end

mp.commands.add("eventroom", EventRoom)

local function Event(pl, cmd, args)
	if not pl:IsAdmin() then return end

	table.remove(args, 1)
	local message = string_Implode(args, " ")

	netstream.Start(player.GetAll(), "EventMessage", string_Implode(args, " "))
end

mp.commands.add("event", Event)

local function comms(pl, cmd, args)
	if not pl:IsAdmin() then return end

	table.remove(args, 1)
	local message = string_Implode(args, " ")

	local snd = "transmission/launch.wav"
	if message == "" or message == " " then
		snd = "transmission/close.wav"
	end

	BroadcastLua([[surface.PlaySound("]] .. snd .. [[")]])

	SetGlobalBool("Laws", message)
end
mp.commands.add("comms", comms)

if CLIENT then
	local title_text = "Внимание!"
	local title_font = mp.font("40:Futura PT Light")
	local text_font = mp.font("30:Futura PT Light")
	local scrw, scrh = ScrW(), ScrH()
	local event_text

	netstream.Hook("EventMessage", function(message)
		event_text = message

		timer.Remove("EventMessage")
		timer.Create("EventMessage", 15, 1, function() event_text = nil end)
	end)

	hook.Add("HUDPaint", "EventMessage", function()
		if event_text then
			draw.SimpleText(title_text, title_font, scrw * .5, 200, mp.Color.ORANGE, 1, 1)
			draw.SimpleText(event_text, text_font, scrw * .5, 230, mp.Color.WHITE, 1, 1)
		end
	end)
end

local function ChangeRPID(pl, cmd, args)
	if pl:IsAdmin() then
		local steam_id = args[2]
		local target = player.GetBySteamID(steam_id)

		if string.match(steam_id, "STEAM_(%d+):(%d+):(%d+)") and IsValid(target) then
			local rpid = args[3]
			target:ChangeRPID(rpid)
		end
	end
end

mp.commands.add("rpid", ChangeRPID)

local function ChangeNickname(pl, cmd, args)
	if pl:IsAdmin() then
		local steam_id = args[2]
		local target = player.GetBySteamID(steam_id)

		if string.match(steam_id, "STEAM_(%d+):(%d+):(%d+)") and IsValid(target) then
			local name = args[3]
			target:ChangeNickname(name)
		end
	end
end

mp.commands.add("name", ChangeNickname)

mp.commands.add("thirdperson", function(pl)
	netstream.Start(pl, "thirdperson_toggle")
end)

local function CharacterChange(pl, cmd, args)
	pl:RequestCharacters(function(characters, player_data)
		netstream.Start(pl, "OpenCharacterMenu", { characters = characters })
		pl.Characters = characters
	end)
end

mp.commands.add("char", CharacterChange)
mp.commands.add("character", CharacterChange)

local function Whitelist(pl, cmd, args)
	netstream.Start(pl, "OpenWhitelistMenu")
end

mp.commands.add("whitelist", Whitelist)
mp.commands.add("wh", Whitelist)

mp.commands.add("sit", function(pl)
	if pl:IsAdmin() then
		pl:SetPos(Vector(6387, -4885, 6160))
	end
end)

if SERVER then
	concommand.Add("mp", mp.commands.callback, mp.commands.autoComplete, "This is a basic command for mp gamemode.")
	netstream.Hook("mp.command.SendCommandsToServer", function(pl, data)
		mp.commands.callback(pl, data.cmd, data.args)
	end);

	hook.Add("PlayerSay", "mp.command.PlayerSay", function(pl, strMsg)
		if pl.sg_jail then return end

		strMsg = string.Explode(" ", strMsg)

		for k, v in pairs(mp.commands.data) do
			if "/" .. k == strMsg[1] then
				pl.NextRPCommad = pl.NextRPCommad or 0
				if pl.NextRPCommad > CurTime() then
					mp.util.Notify(pl, NOTIFY_ERROR, "Не используйте команды так часто!")

					return
				end

				pl.NextRPCommad = CurTime() + 2

				strMsg[1] = string.gsub(strMsg[1], "/", "")
				v(pl, "mp", strMsg)

				hook.Call("cmd.OnCommandRun", nil, pl, k, strMsg)

				return ""
			end
		end
	end)
else
	concommand.Add("mp", function(pl, cmd, args)
		if pl.sg_jail then return end

		netstream.Start("mp.command.SendCommandsToServer", {
			args = args,
			cmd = cmd
		})
	end, mp.commands.autoComplete, "This is a basic command for mp gamemode.")

	netstream.Hook("ChatMassage", function(data)
		local pCaller = data.pl
		if pCaller and pCaller:IsPlayer() then
			local color, pre = data.color, data.pre
			local postcolor = data.postcolor == false and "" or Color(255, 255, 255)
			local postname = data.postcolor == false and " " or ": "
			local text_color = data.text_color or Color(255, 255, 255)
			local name = data.drawname and data.drawname or pCaller:Name()
			chat.AddText(color, pre, pCaller:GetJobColor(), name, postcolor, postname, text_color, data.text)
		end
	end);

	netstream.Hook("RPCommands", function(...)
		chat.AddText(...)
	end);
end

mp.commands.add("thirdperson", function(pl)
	netstream.Start(pl, "thirdperson_toggle")
end)

local function OOCMassage(pl, cmd, args)
	if not DealyCommad(pl) then
		return
	end

	table.remove(args, 1)
	local strMsg = string_Implode(args, " ")
	netstream.Start(player.GetAll(), "ChatMassage", {
		pl = pl,
		pre = "〢 OOC ・ ",
		color = Color(140, 201, 216),
		text = strMsg
	})
end

mp.commands.add("ooc", OOCMassage)
mp.commands.add("c", OOCMassage)
mp.commands.add("/", OOCMassage)

local function AdvertMassage(pl, cmd, args)
	if not DealyCommad(pl) then
		return
	end

	table.remove(args, 1)
	local strMsg = string_Implode(args, " ")

	netstream.Start(player.GetAll(), "ChatMassage", {
		pl = pl,
		pre = "〢 Незащищенная сеть ・ ",
		color = Color(201, 179, 106),
		text = strMsg,
		text_color = Color(201, 179, 106)
	})
	--end
end

mp.commands.add("communicate", AdvertMassage)
mp.commands.add("com", AdvertMassage)


local function RP1Massage(pl, cmd, args)
	table.remove(args, 1)
	local strMsg = string_Implode(args, " ")
	netstream.Start(player.GetAll(), "ChatMassage", {
		pl = pl,
		pre = "〢 Глобальное Действие ・ ",
		color = Color(255, 173, 80),
		text = strMsg,
		text_color = Color(255, 173, 80)
	})
end

mp.commands.add("rp", RP1Massage)

-- local function Advert2Massage(pl, cmd, args)
-- 	table.remove(args, 1)
-- 	local strMsg = string_Implode(args, " ")
-- 	netstream.Start(player.GetAll(), "ChatMassage", {
-- 		pl = pl,
-- 		-- drawname = "",
-- 		pre = "[Локальная базовая сеть] ",
-- 		color = Color(83, 216, 187),
-- 		text = strMsg,
-- 		text_color = Color(83, 216, 187)
-- 	})
-- end

-- mp.commands.add("comm", Advert2Massage)

local function AdvertRANDOMMassage(pl, cmd, args)
	if not pl:IsAdmin() then return end

	table.remove(args, 1)
	local strMsg = string_Implode(args, " ")
	netstream.Start(player.GetAll(), "ChatMassage", {
		pl = pl,
		drawname = "",
		pre = "〢 Неизвестная частота ・ ",
		color = Color(172, 172, 172),
		text = strMsg,
		text_color = Color(172, 172, 172)
	})
end

mp.commands.add("rnd", AdvertRANDOMMassage)

local function MeMassage(pl, cmd, args)
	if not DealyCommad(pl) then
		return
	end

	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 300)) do
		if not IsValid(v) or not v:IsPlayer() then continue end
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "ChatMassage", {
		pl = pl,
		pre = "",
		color = pl:GetJobColor(),
		text = string_Implode(args, " "),
		postcolor = false,
		text_color = pl:GetJobColor()
	})
end

mp.commands.add("me", MeMassage)

local function NoRPMassage(pl, cmd, args)
	if not DealyCommad(pl) then
		return
	end

	table.remove(args, 1)
	local tblPlayers = {}
	local strMsg = string_Implode(args, " ")
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 300)) do
		if not IsValid(v) or not v:IsPlayer() then continue end
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "ChatMassage", {
		pl = pl,
		pre = "〢 LOOC ・ ",
		color = Color(140, 201, 216),
		text = strMsg
	})
end

mp.commands.add("l", NoRPMassage)
mp.commands.add("looc", NoRPMassage)

local function YellMassage(pl, cmd, args)
	table.remove(args, 1)
	local tblPlayers = {}
	local strMsg = string_Implode(args, " ")
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 650)) do
		if not IsValid(v) or not v:IsPlayer() then continue end
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "ChatMassage", {
		pl = pl,
		pre = "〢 Крик ・ ",
		color = Color(140, 201, 216),
		text = strMsg
	})
end

mp.commands.add("y", YellMassage)
mp.commands.add("yell", YellMassage)


local function WhisperMassage(pl, cmd, args)
	table.remove(args, 1)
	local tblPlayers = {}
	local strMsg = string_Implode(args, " ")
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 50)) do
		if not IsValid(v) or not v:IsPlayer() then continue end
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "ChatMassage", {
		pl = pl,
		pre = "〢 Шёпот ・ ",
		color = Color(138, 168, 113),
		text = strMsg
	})
end

mp.commands.add("w", WhisperMassage)
mp.commands.add("whisper", WhisperMassage)

local function DoMassage(pl, cmd, args)
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 300)) do
		if not IsValid(v) or not v:IsPlayer() then continue end
		table.insert(tblPlayers, v)
	end
	local rand = tostring(math.random(1, 100))
	netstream.Start(tblPlayers, "RPCommands", pl:GetJobColor(), string_Implode(args, " "),
		" (( " .. pl:Name() .. " ))")
end

mp.commands.add("do", DoMassage)


local function RollMassage(pl, cmd, args)
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 300)) do
		if not IsValid(v) or not v:IsPlayer() then continue end
		table.insert(tblPlayers, v)
	end
	local rand = tostring(math.random(1, 100))
	netstream.Start(tblPlayers, "RPCommands", pl, Color(240, 240, 240, 255), " кинул кубики, и ему выпало ",
		Color(0, 165, 240, 255), rand, Color(240, 240, 240, 255), ".")
end

mp.commands.add("roll", RollMassage)

local function TryMassage(pl, cmd, args)
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 300)) do
		if not IsValid(v) or not v:IsPlayer() then continue end

		table.insert(tblPlayers, v)
	end
	local try = math.random(0, 6) % 2 == 1 and "неудача" or "успех"
	netstream.Start(tblPlayers, "RPCommands", pl:GetJobColor(), pl, Color(240, 240, 240, 255), " ",
		string_Implode(args, " "), Color(0, 165, 240, 255), try, Color(240, 240, 240, 255), ".")
end

mp.commands.add("try", TryMassage)

local function NatoMessage(pl, cmd, args)
	if pl:GetFaction() ~= "nato" then return end

	if not DealyCommad(pl) then
		return
	end

	table.remove(args, 1)

	netstream.Start(mp.util.GetNato(), "ChatMassage", {
		pl = pl,
		pre = "〢 Защищенная сеть НАТО ・ ",
		color = pl:GetJobColor(),
		text = string_Implode(args, " "),
		postcolor = false,
		text_color = color_white
	})
end

mp.commands.add("nato", NatoMessage)

local function RFMessage(pl, cmd, args)
	if pl:GetFaction() ~= "rf" then return end

	if not DealyCommad(pl) then
		return
	end

	table.remove(args, 1)

	netstream.Start(mp.util.GetRF(), "ChatMassage", {
		pl = pl,
		pre = "〢 Защищенная сеть РФ ・ ",
		color = pl:GetJobColor(),
		text = string_Implode(args, " "),
		postcolor = false,
		text_color = color_white
	})
end

mp.commands.add("rf", RFMessage)

local function PassMessage(pl, cmd, args)
	local tblPlayers = {}
	for _, v in ipairs(ents.FindInSphere(pl:GetPos(), 300)) do
		if not IsValid(v) or not v:IsPlayer() then continue end
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "ChatMassage", {
		pl = pl,
		pre = "〢 Документы ・ ",
		color = pl:GetJobColor(),
		text = "Должность: " ..
			pl:GetJobName() .. ". | Звание: " .. pl:GetNetVar("meta_rank") .. ". | Специальность: " .. pl:FeatureName(),
		postcolor = false,
		text_color = pl:GetJobColor()
	})
end

mp.commands.add("pass", PassMessage)

if CLIENT then
	local round            = math.Round
	local LocalPlayer      = LocalPlayer
	local SetClipboardText = SetClipboardText

	concommand.Add("_pos", function()
		local p = LocalPlayer():GetPos()
		local t = ("Vector(%d, %d, %d)"):format(round(p.x), round(p.y), round(p.z))
		SetClipboardText(t)
		print(t)
	end)

	concommand.Add("_epos", function()
		local p = LocalPlayer():EyePos()
		local t = ("Vector(%d, %d, %d)"):format(round(p.x), round(p.y), round(p.z))
		SetClipboardText(t)
		print(t)
	end)

	concommand.Add("_tpos", function()
		local p = LocalPlayer():GetEyeTrace().HitPos
		local t = ("Vector(%d, %d, %d)"):format(round(p.x), round(p.y), round(p.z))
		SetClipboardText(t)
		print(t)
	end)

	concommand.Add("_ang", function()
		local p = LocalPlayer():GetAngles()
		local t = ("Angle(%d, %d, %d)"):format(round(p.p), round(p.y), round(p.r))
		SetClipboardText(t)
		print(t)
	end)

	local tb = {}
	local s
	local id = 1

	concommand.Add("_ent", function()
		local p = LocalPlayer():GetEyeTrace().Entity
		local pos = p:GetPos()
		local ang = p:GetAngles()
		if not s then
			local t = ([[{mdl = "%s", class = "%s", pos = Vector(%d, %d, %d), ang = Angle(%d, %d, %d)},]]):format(
				p:GetModel(), p:GetClass(), round(pos.x), round(pos.y), round(pos.z), round(ang.p), round(ang.y),
				round(ang.r))
			tb[id] = t
			s = true
		else
			local t = ([[{mdl = "%s", class = "%s", pos = Vector(%d, %d, %d), ang = Angle(%d, %d, %d)},]]):format(
				p:GetModel(), p:GetClass(), round(pos.x), round(pos.y), round(pos.z), round(ang.p), round(ang.y),
				round(ang.r))
			tb[id] = tb[id] .. t

			id = #tb + 1
			s = false
		end
	end)

	concommand.Add("_ent_pos", function()
		local p = LocalPlayer():GetEyeTrace().Entity
		local pos = p:GetPos()
		local t = ("Vector(%d, %d, %d)"):format(round(pos.x), round(pos.y), round(pos.z))

		SetClipboardText(t)
		print(t)
	end)

	concommand.Add("_ent_copy", function()
		local t = "{\n"
		for k, v in ipairs(tb) do
			t = t .. "	" .. v .. "\n"
		end
		t = t .. "}"

		tb = {}
		id = 1
		s = nil
		SetClipboardText(t)
		print(t)
	end)
end
