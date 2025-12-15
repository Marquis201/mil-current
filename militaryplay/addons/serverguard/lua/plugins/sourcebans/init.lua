--[[
	© 2015 Thriving Ventures Ltd do not share, re-distribute or modify
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local bError = false;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("external/sourcebans.lua", SERVERGUARD.STATE.SERVER);
plugin:IncludeFile("settings.lua", SERVERGUARD.STATE.SERVER);

local function LOAD_ACTIVE_BANS()
	sourcebans.GetAllActiveBans(function(data, errorText)
		if (!data and !bError) then
			error(errorText);
			bError = true;
			
			return;
		end;

		local banTable = {};

		for k, v in pairs(data) do
			banTable[v.SteamID] = {
				communityID = util.SteamIDTo64(v.SteamID),
				player 		= v.Name,
				reason 		= v.BanReason,
				startTime 	= tonumber(v.BanStart),
				endTime 	= tonumber(v.BanEnd),
				admin 		= v.AdminName,
				ip			= v.IPAddress
			};
		end;

		serverguard.banTable = banTable;
	end);
end;

plugin:Hook("serverguard.plugin.PostLoadConfig", "sourcebans.Initialize", function()
	sourcebans.Activate();
end);

plugin:Hook("Tick", "sourcebans.Tick", function()
	local sysTime = SysTime();

	if (!plugin.NextPollBans or sysTime >= plugin.NextPollBans) then
		plugin.NextPollBans = sysTime + 60; LOAD_ACTIVE_BANS();
	end;
end);

plugin:Hook("serverguard.PlayerBanned", "sourcebans.PlayerBanned", function(player, length, reason, admin)
	sourcebans.BanPlayer(player, length, reason, admin);
	
	return true;
end);

plugin:Hook("serverguard.PlayerBannedBySteamID", "sourcebans.PlayerBannedBySteamID", function(steamID, length, reason, admin, playerName)
	if (playerName != steamID) then
		sourcebans.BanPlayerBySteamID(steamID, length, reason, admin, playerName);
	else
		sourcebans.BanPlayerBySteamID(steamID, length, reason, admin);
	end;

	return true;
end);

plugin:Hook("serverguard.PlayerUnbanned", "sourcebans.PlayerUnbanned", function(steamID, admin)
	sourcebans.UnbanPlayerBySteamID(steamID, "ServerGuard", admin);
	serverguard.banTable[steamID] = nil;

	return true;
end);

plugin:Hook("serverguard.LoadBanData", "sourcebans.LoadBanData", function()
	LOAD_ACTIVE_BANS();

	return true;
end);