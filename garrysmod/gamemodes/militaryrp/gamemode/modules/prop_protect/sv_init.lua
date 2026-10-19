local string       = string
local IsValid      = IsValid
local util         = util

mp.pp              = mp.pp or {}

local toolFuncs    = {
	[0] = function(pl)
		return true
	end,
	[1] = function(pl)
		return pl:GetUserGroup() == "vip"
	end,
	[2] = function(pl)
		return pl:IsAdmin()
	end,
	[3] = function(pl)
		return pl:IsSuperAdmin()
	end,
	[4] = function(pl)
		return pl:GetUserGroup() == "founder"
	end,
}

local BlockedTools = {
	["button"]        = 0,
	["camera"]        = 0,
	["colour"]        = 0,
	["fading_door"]   = 0,
	["keypad"]        = 0,
	["lamp"]          = 3,
	["light"]         = 3,
	["material"]      = 0,
	["nocollide"]     = 0,
	["precision"]     = 0,
	["remover"]       = 0,
	["stacker"]       = 0,
	["textscreen"]    = 0,
	["weld"]          = 4,
	["advdupe2"]      = 1,
	["shadowremover"] = 3,
}

local devs         = {
	["founder"] = true,
	["curator"] = true,
}

function mp.PlayerCanManipulate(pl, ent)
	if ent:IsWorld() then return false end
	if ent:IsVehicle() and ! devs[pl:GetUserGroup()] then return false end
	if ent:IsPlayer() then return end
	if not IsValid(ent:CPPIGetOwner()) and not pl:IsAdmin() then return false end

	if IsValid(ent:CPPIGetOwner()) then
		local sharedProp = (ent:CPPIGetOwner().propBuddies and ent:CPPIGetOwner().propBuddies[pl]) and true or false
		local adminMode = pl:Team() == TEAM_ADMIN

		if sharedProp or adminMode or pl:IsSuperAdmin() then
			return true
		end
	end

	return (ent:CPPIGetOwner() == pl)
end

local can_dupe = {
	["prop_physics"] = true,
	["keypad"]       = true
}

function mp.PlayerCanTool(pl, ent, tool)
	if tool == "dev_tool" and ent:IsDoor() then
		return true
	end

	if IsValid(ent) and not pl:IsSuperAdmin() and ent:GetClass() != "prop_physics" and tool != "remover" then return false end

	local tool = tool:lower()

	if BlockedTools[tool] then
		local canTool = toolFuncs[BlockedTools[tool]](pl)
		if not canTool then
			file.Append("tool.txt", pl:SteamID() .. " tool:" .. tool)
			--mp.Notify(pl, NOTIFY_ERROR, term.Get("CannotTool"), tool)
			return canTool
		end
	end

	local EntTable =
		(tool == "adv_duplicator" and pl:GetActiveWeapon():GetToolObject().Entities) or
		(tool == "advdupe2" and pl.AdvDupe2 and pl.AdvDupe2.Entities) or
		(tool == "duplicator" and pl.CurrentDupe and pl.CurrentDupe.Entities)

	if EntTable && ! pl:IsAdmin() then
		if (not pl:GetPlayTime() or pl:GetPlayTime() < 36000) and ! pl:IsAdmin() then
			return mp.util.Notify(pl, NOTIFY_ERROR,
				"Для использования дубликатора нужно отыграть на сервере не менее 10 часов!")
		end
		for k, v in pairs(EntTable) do
			if not can_dupe[string.lower(v.Class)] then
				--mp.util.Notify(pl, NOTIFY_ERROR, term.Get("DupeRestrictedEnts"))
				return false
			end
		end
	end

	if ent:IsWorld() then
		return true
	elseif not IsValid(ent) then
		return false
	end

	local cantool = mp.PlayerCanManipulate(pl, ent)


	if (cantool == true) then
		hook.Call("PlayerToolEntity", GAMEMODE, pl, ent, tool)
	end

	return cantool
end

function ENTITY:CPPISetOwner(pl)
	if not IsValid(pl) then return end

	self:SetNetVar("IsOwner", pl)
end

--
-- Workarounds
--
PLAYER._AddCount = PLAYER._AddCount or PLAYER.AddCount
function PLAYER:AddCount(t, ent)
	if IsValid(ent) then
		ent:CPPISetOwner(self)
	end
	return self:_AddCount(t, ent)
end

local abadonedclasses = {
	["ch_bitminer_power_cable_end"] = true,
	["ch_bitminer_power_cable"] = true,
	["gmod_hands"] = true,
}

ENTITY._SetPos = ENTITY._SetPos or ENTITY.SetPos
function ENTITY.SetPos(self, pos, force)
	if IsValid(self) and (! util.IsInWorld(pos)) and (not self:IsPlayer()) and (! abadonedclasses[self:GetClass()]) and ! force then
		self:Remove()
		return
	end
	return self:_SetPos(pos)
end

local PHYS = FindMetaTable("PhysObj")
PHYS._SetPos = PHYS._SetPos or PHYS.SetPos
function PHYS.SetPos(self, pos)
	if IsValid(self) and (! util.IsInWorld(pos)) then
		--self:Remove()
		return
	end
	return self:_SetPos(pos)
end

ENTITY._SetAngles = ENTITY._SetAngles or ENTITY.SetAngles
function ENTITY:SetAngles(ang)
	if not ang then return self:_SetAngles(ang) end
	ang.p = ang.p % 360
	ang.y = ang.y % 360
	ang.r = ang.r % 360
	return self:_SetAngles(ang)
end

if undo then
	local AddEntity, SetPlayer, Finish = undo.AddEntity, undo.SetPlayer, undo.Finish
	local Undo = {}
	local UndoPlayer
	function undo.AddEntity(ent, ...)
		if type(ent) ~= "boolean" and IsValid(ent) then table.insert(Undo, ent) end
		AddEntity(ent, ...)
	end

	function undo.SetPlayer(ply, ...)
		UndoPlayer = ply
		SetPlayer(ply, ...)
	end

	function undo.Finish(...)
		if IsValid(UndoPlayer) then
			for k, v in pairs(Undo) do
				v:CPPISetOwner(UndoPlayer)
			end
		end
		Undo = {}
		UndoPlayer = nil

		Finish(...)
	end
end

duplicator.BoneModifiers = {}
duplicator.EntityModifiers["VehicleMemDupe"] = nil
for k, v in pairs(duplicator.ConstraintType) do
	if (k ~= "Weld") and (k ~= "NoCollide") then
		duplicator.ConstraintType[k] = nil
	end
end

--[[rp.AddCommand("shareprops", function(pl, args, text)
	pl.propBuddies = pl.propBuddies or {}

	if pl.propBuddies[args] then
		mp.util.Notify(pl, NOTIFY_SUCCESS, term.Get("UnsharedPropsYou"), args)
		mp.util.Notify(args, NOTIFY_SUCCESS, term.Get("UnsharedProps"), pl)
		pl.propBuddies[args] = false
	else
		mp.util.Notify(pl, NOTIFY_SUCCESS, term.Get("SharedPropsYou"), args)
		mp.util.Notify(args, NOTIFY_SUCCESS, term.Get("SharedProps"), pl)
		pl.propBuddies[args] = true
	end

	pl:SetNetVar("ShareProps", pl.propBuddies)
end)
	:AddParam(cmd.PLAYER_ENTITY)]]

-- Overwrite
--[[concommand.Add("gmod_admin_cleanup", function(pl, cmd, args)
	if pl:SteamID() != "STEAM_0:1:116650278" then
		pl:Notify(NOTIFY_ERROR, term.Get("CantAdminCleanup"))
		return
	end
	if args[1] then
		for k, v in ipairs(ents.GetAll()) do
			if (v:GetClass() == args[1]) then
				v:Remove()
			end
		end
	end
end)]]
