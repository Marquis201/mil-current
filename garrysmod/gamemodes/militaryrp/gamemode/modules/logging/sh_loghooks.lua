local mp = mp
local IsValid = IsValid

do
	-- Props
	mp.logs.AddTerm("Prop", "#(#) создал #", {
		"Name",
		"SteamID",
		"Prop"
	})

	mp.logs.Create "props"
		:Hook("PlayerSpawnedProp", function(self, pl, mdl)
			local valid = IsValid(pl)
			local name = valid and pl:Name() or "invalid name"
			local steam = valid and pl:SteamID() or "invalid steamid"

			self:PlayerLog(pl, "Prop", name, steam, mdl)
		end)
end

do
	-- Tools
	mp.logs.AddTerm("Tool", "#(#) использовал на # принадлежащий #(#) с помощью #", {
		"Name",
		"SteamID",
		"Entity",
		"TargetName",
		"TargetSteamID",
		"Tool"
	})

	mp.logs.Create "toolgun"
		:Hook("PlayerToolEntity", function(self, pl, ent, tool)
			local valid = IsValid(pl)
			local name = valid and pl:Name() or "invalid name"
			local steam = valid and pl:SteamID() or "invalid steamid"

			if IsValid(ent) then
				if IsValid(ent:CPPIGetOwner()) then
					local owner = ent:CPPIGetOwner()
					self:PlayerLog(pl, "Tool", name, steam, ent:GetClass() or ent, owner:Name(),
						owner:SteamID(), tool)
				else
					self:PlayerLog(pl, "Tool", name, steam, ent:GetClass() or ent, "Unknown", "STEAM:0:0",
						tool)
				end
			end
		end)
end

do
	-- Physgun
	mp.logs.AddTerm("Physgun", "#(#) использовал физган на # принадлежащий #(#)", {
		"Name",
		"SteamID",
		"Ent",
		"TargetName",
		"TargetSteamID",
	})

	mp.logs.AddTerm("PhysgunPlayer", "#(#) поднял #(#)", {
		"Name",
		"SteamID",
		"TargetName",
		"TargetSteamID",
	})

	mp.logs.Create("physgun")
		:Hook("OnPhysgunPickup", function(self, pl, ent)
			local valid = IsValid(pl)
			local name = valid and pl:Name() or "invalid name"
			local steam = valid and pl:SteamID() or "invalid steamid"

			if IsValid(ent:CPPIGetOwner()) then
				local owner = ent:CPPIGetOwner()

				self:PlayerLog(pl, "Physgun", name, steam, ent:GetClass() or ent, owner:Name(), owner:SteamID())
			elseif ent:IsPlayer() then
				self:PlayerLog(pl, "PhysgunPlayer", name, steam, ent:Name(), ent:SteamID())
			else
				self:PlayerLog(pl, "Physgun", name, steam, ent:GetClass() or ent, "Unknown", "STEAM:0:0")
			end
		end)
end

do
	-- Kills
	mp.logs.AddTerm("Killed", "#(#) убил #(#) с помощью # #", {
		"Attacker Name",
		"Attacker SteamID",
		"TargetName",
		"TargetSteamID",
		"Weapon"
	})

	mp.logs.Create "Kill|deaths"
		:Hook("PlayerDeath", function(self, pl, ent, killer)
			if IsValid(killer) and killer:IsPlayer() then
				local w = killer:GetActiveWeapon()
				local wep
				if IsValid(w) then
					wep = w:GetClass()

					local t = weapons.Get(wep)
					if t and t.PrintName then
						wep = t.PrintName
					end
				else
					wep = "none"
				end

				local valid = IsValid(pl)
				local name = valid and pl:Name() or "invalid name"
				local steam = valid and pl:SteamID() or "invalid steamid"

				self:PlayerLog({ pl, killer }, "Killed", killer:Name(), killer:SteamID(), name, steam, wep, "")
			end
		end)
end


do
	-- Chat

	mp.logs.AddTerm("Chat", "#(#) написал: #", {
		"Name",
		"SteamID",
		"Text"
	})

	mp.logs.AddTerm("ChatTag", "#(#) написал в [#]: #", {
		"Name",
		"SteamID",
		"Text"
	})

	mp.logs.Create "chat"
		:Hook("PlayerSay", function(self, pl, text)
			if (text ~= "") and (text[1] ~= "!") and (text[1] ~= "/") then
				self:PlayerLog(pl, "Chat", pl:Name(), pl:SteamID(), text)
			end
		end)
end

do
	-- Connects
	mp.logs.AddTerm("Connect", "#(#) подключился", {
		"Name",
		"SteamID"
	})
	mp.logs.AddTerm("Disconnect", "#(#) отключился", {
		"Name",
		"SteamID"
	})

	mp.logs.Create "connection"
		:Hook("PlayerInitialSpawn", function(self, pl)
			self:PlayerLog(pl, "Connect", pl:Name(), pl:SteamID())
		end)
		:Hook("PlayerDisconnected", function(self, pl)
			self:PlayerLog(pl, "Disconnect", pl:Name(), pl:SteamID())
		end)
end

do
	-- Damage
	mp.logs.AddTerm("Damage", "#(#) нанёс # урона #(#) с помощью # #", {
		"Attacker Name",
		"Attacker SteamID",
		"Damage",
		"TargetName",
		"TargetSteamID",
		"Weapon",
		"Reason"
	})

	mp.logs.AddTerm("FallDamage", "#(#) нанёс себе # урона", {
		"Attacker Name",
		"Attacker SteamID",
	})

	mp.logs.Create "damage"
		:Hook("EntityTakeDamage", function(self, ent, dmginfo)
			local attacker = dmginfo:GetAttacker()
			local validattacker = IsValid(attacker)
			local valident = IsValid(ent)

			if valident and ent:IsPlayer() and validattacker and attacker:IsPlayer() then
				local w = attacker:GetActiveWeapon()
				local wep

				if IsValid(w) then
					wep = w:GetClass()

					local t = weapons.Get(wep)
					if t and t.PrintName then
						wep = t.PrintName
					end
				else
					wep = "none"
				end
				self:Log("Damage", attacker:Name(), attacker:SteamID(), math.Round(dmginfo:GetDamage(), 0),
					ent:Name(),
					ent:SteamID(), wep, "")
			elseif valident and ent:IsPlayer() and validattacker and attacker:IsPlayer() and ent == attacker then
				self:Log("FallDamage", attacker:Name(), attacker:SteamID())
			end
		end)
end

do
	-- Police

	mp.logs.AddTerm("Wanted", "#(#) объявил розыск на #(#) за #", {
		"Officer Name",
		"Officer SteamID",
		"Name",
		"SteamID",
		"Reason"
	})

	mp.logs.AddTerm("UnWanted", "#(#) отменил розыск на #(#)", {
		"Officer Name",
		"Officer SteamID",
		"Name",
		"SteamID",
	})

	mp.logs.AddTerm("cuff", "#(#) надел наручники на #(#)", {
		"Officer Name",
		"Officer SteamID",
		"Name",
		"SteamID",
	})

	mp.logs.AddTerm("uncuffed", "#(#) снял наручники с #(#)", {
		"Officer Name",
		"Officer SteamID",
		"Name",
		"SteamID",
	})

	mp.logs.AddTerm("ArrestedEntity", "#(#) уничтожил # игрока #(#)", {
		"Officer Name",
		"Officer SteamID",
		"Entity",
		"Name",
		"SteamID",
	})
	mp.logs.AddTerm("ArrestedPlayer", "#(#) арестовал #(#) на # сек. По причине #.", {
		"Officer Name",
		"Officer SteamID",
		"Name",
		"SteamID",
		"Time",
		"Reason"
	})
	mp.logs.AddTerm("UnArrestedPlayer", "#(#) снял арест #(#)", {
		"Officer Name",
		"Officer SteamID",
		"Name",
		"SteamID",
	})

	mp.logs.AddTerm("OnTaser", "#(#) использловал тайзер на #(#)", {
		"Name",
		"SteamID",
		"Target Name",
		"Target SteamID",
	})

	mp.logs.Create "police"
		:Hook("OnPlayerTaser", function(self, pl, actor)
			if not IsValid(actor) then return end

			self:PlayerLog(pl, "OnTaser", pl:Name(), pl:SteamID(), actor:Name(), actor:SteamID())
		end)

		:Hook("PlayerWanted", function(self, pl, actor, reason)
			if IsValid(actor) then
				self:PlayerLog({ pl, actor }, "Wanted", actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID(),
					reason)
			end
		end)
		:Hook("PlayerUnwanted", function(self, pl, actor, reason)
			if IsValid(actor) then
				self:PlayerLog({ pl, actor }, "UnWanted", actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
			end
		end)
		:Hook("PlayerArrested", function(self, pl, actor, time, reason)
			if not IsValid(actor) then return end

			self:PlayerLog({ pl, actor } or pl, "ArrestedPlayer", actor:Name(), actor:SteamID(), pl:Name(),
				pl:SteamID(), time or 0, reason or "Неизвестно")
		end)
		:Hook("PlayerUnArrested", function(self, pl, actor)
			if not IsValid(actor) then return end

			self:PlayerLog({ pl, actor }, "UnArrestedPlayer", actor:Name(), actor:SteamID(), pl:Name(),
				pl:SteamID())
		end)
		:Hook("PlayerCuf", function(self, pl, actor)
			if not IsValid(actor) then return end

			self:PlayerLog({ pl, actor }, "cuff", actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end)
		:Hook("PlayerUnCuffed", function(self, pl, actor)
			if not IsValid(actor) then return end

			self:PlayerLog({ pl, actor }, "uncuffed", actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end)
end

do
	-- RPCommands
	mp.logs.AddTerm("RpCommands", "#(#) использовал #: #", {
		"Name",
		"SteamID",
		"Command",
		"Args"
	})

	mp.logs.Create("rpcommands")
		:Hook("cmd.OnCommandRun", function(self, pl, cmd, args)
			local processedArgs = {}

			if istable(args) then
				for _, arg in ipairs(args) do
					if isentity(arg) and IsValid(arg) then
						if arg:IsPlayer() then
							table.insert(processedArgs, string.format("%s [%s]", arg:Name(), arg:SteamID()))
						else
							table.insert(processedArgs, tostring(arg))
						end
					else
						table.insert(processedArgs, tostring(arg))
					end
				end
				args = table.concat(processedArgs, " | ")
			else
				args = tostring(args or "nil")
			end

			local cmdName = isfunction(cmd.GetName) and cmd:GetName() or tostring(cmd)
			self:PlayerLog(pl, "RpCommands", pl:Name(), pl:SteamID(), cmdName, args)
		end)
end

do
	-- Admins
	mp.logs.AddTerm("ACommands", "#(#) использовал #: #", {
		"Name",
		"SteamID",
		"Command",
		"Args"
	})

	mp.logs.Create("admin_command")
		:Hook("serverguard.RanCommand", function(self, pl, cmd, notify, args)
			local processedArgs = {}
			if istable(args) then
				for _, arg in ipairs(args) do
					if IsValid(arg) and arg:IsPlayer() then
						table.insert(processedArgs, arg:Name() .. " | " .. arg:SteamID())
					else
						table.insert(processedArgs, tostring(arg))
					end
				end
			end
			local argsString = istable(args) and table.concat(processedArgs, " ") or tostring(args)

			local name = IsValid(pl) and pl:Name() or "console"
			local steam = IsValid(pl) and pl:SteamID() or "console"

			self:PlayerLog(pl, "ACommands", name, steam, cmd.command, argsString)
		end)
end

do
	mp.logs.AddTerm("WhitelistJob", "#(#) изменил работу #(#) на # (Время: #)", {
		"Name",
		"SteamID",
		"Target Name",
		"Target SteamID",
		"Job",
		"Time",
	})

	mp.logs.AddTerm("WhitelistRank", "#(#) изменил звание #(#) на # (Время: #)", {
		"Name",
		"SteamID",
		"Target Name",
		"Target SteamID",
		"Job",
		"Time",
	})

	mp.logs.AddTerm("WhitelistProfession", "#(#) изменил специальность #(#) на # (Время: #)", {
		"Name",
		"SteamID",
		"Target Name",
		"Target SteamID",
		"Profession",
		"Time",
	})

	mp.logs.AddTerm("WhitelistModel", "#(#) изменил модель #(#) на #", {
		"Name",
		"SteamID",
		"Target Name",
		"Target SteamID",
		"Model",
	})

	mp.logs.AddTerm("WhitelistAccess", "#(#) изменил разрешения #(#)", {
		"Name",
		"SteamID",
		"Target Name",
		"Target SteamID",
	})

	mp.logs.Create "whitelist"
		:Hook("PlayerWhiteListJob", function(self, pl, actor, job, time)
			if not IsValid(actor) then return end

			time = (time == 0) and "навсегда" or time

			self:PlayerLog(pl, "WhitelistJob", pl:Name(), pl:SteamID(), actor:Name(), actor:SteamID(), job, time)
		end)
		:Hook("PlayerWhiteListRank", function(self, pl, actor, rank, time)
			if not IsValid(actor) then return end

			time = (time == 0) and "навсегда" or time

			self:PlayerLog(pl, "WhitelistRank", pl:Name(), pl:SteamID(), actor:Name(), actor:SteamID(), rank, time)
		end)
		:Hook("PlayerWhiteListProfession", function(self, pl, actor, profession, time)
			if not IsValid(actor) then return end

			time = (time == 0) and "навсегда" or time

			self:PlayerLog(pl, "WhitelistProfession", pl:Name(), pl:SteamID(), actor:Name(), actor:SteamID(), profession,
				time)
		end)
		:Hook("PlayerWhiteListModel", function(self, pl, actor, model)
			if not IsValid(actor) then return end

			self:PlayerLog(pl, "WhitelistModel", pl:Name(), pl:SteamID(), actor:Name(), actor:SteamID(), model)
		end)
		:Hook("PlayerWhiteListAccess", function(self, pl, actor)
			if not IsValid(actor) then return end

			self:PlayerLog(pl, "WhitelistAccess", pl:Name(), pl:SteamID(), actor:Name(), actor:SteamID())
		end)
end

--[[

do
	-- Dupes
	mp.logs.AddTerm("Dupe", "#(#) создал копию с # энтити и # ограничениями", {
		"Name",
		"SteamID",
	})

	mp.logs.Create "dublicator"
		:Hook("PlayerSpawnDupe", function(self, pl, file, ents, constraints)
			self:PlayerLog(pl, "Dupe", pl:Name(), pl:SteamID(), #ents, #constraints)
		end)
end

do
	-- NLR
	mp.logs.AddTerm('EnterNLR', '#(#) вошел в зону NLR с оставшимися # секундами', {
		'Name',
		'SteamID',
		'Time'
	})

	mp.logs.AddTerm('ExitNLR', '#(#) вышел с зоны NLR с оставшимися # секундами', {
		'Name',
		'SteamID',
		'Time'
	})


	mp.logs.Create 'nlr'
		:Hook('PlayerEnterNLRZone', function(self, pl, time)
			self:PlayerLog(pl, 'EnterNLR', pl:Name(), pl:SteamID(), math.Round(time, 0))
		end)
		:Hook('PlayerLeaveNLRZone', function(self, pl, time)
			self:PlayerLog(pl, 'ExitNLR', pl:Name(), pl:SteamID(), math.Round(time, 0))
		end)
end

do
	-- Reports
	mp.logs.AddTerm('Freps.close', '#(#) закрыл жалобу игрока #(#)', {
		'Admin Name',
		'Admin SteamID',
		'TargetName',
		'TargetSteamID',
	})

	mp.logs.AddTerm('Freps.accept', '#(#) принял жалобу игрока #(#)', {
		'Admin Name',
		'Admin SteamID',
		'TargetName',
		'TargetSteamID',
	})

	mp.logs.AddTerm('Freps.send', '#(#) написал жалобу: #', {
		'Имя',
		'SteamID',
		'Text'
	})

	mp.logs.Create 'reports'
		:Hook('PlayerSitRequestAccept', function(self, pl, reporter)
			if not IsValid(reporter) then return end

			self:PlayerLog(pl, 'Freps.accept', pl:Name(), pl:SteamID(), reporter:Name(), reporter:SteamID())
		end)
		:Hook('PlayerSitRequestClose', function(self, pl, reporter)
			if not IsValid(reporter) then return end

			self:PlayerLog(pl, 'Freps.close', pl:Name(), pl:SteamID(), reporter:Name(), reporter:SteamID())
		end)
		:Hook('PlayerSitRequestOpened', function(self, pl, text)
			self:PlayerLog(pl, 'Freps.send', pl:Name(), pl:SteamID(), text)
		end)
end
]]
