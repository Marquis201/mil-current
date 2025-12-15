ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = ""
ENT.Author = ""
ENT.Category = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

hook.Add("Initialize","CreateBriefcaseBombCvars",function()
	if !ConVarExists("BriefcaseBomb_Countdown") then
		CreateConVar("BriefcaseBomb_Countdown", 30, { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "How long does it take for the bomb to explode?")
	end
    if !ConVarExists("BriefcaseBomb_Magnitude") then
		CreateConVar("BriefcaseBomb_Magnitude", 250, { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "How strong is the explosion?")
	end
    if !ConVarExists("BriefcaseBomb_BeepSound") then
		CreateConVar("BriefcaseBomb_BeepSound", 1, { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Should the briefcase beep?")
	end
	if CLIENT then
		local function funcCallback(CVar, PreviousValue, NewValue)
			net.Start("Briefcase_Convars_Change", true)
			net.WriteString(CVar)
			net.WriteFloat(tonumber(NewValue))
			net.SendToServer()
		end
		cvars.AddChangeCallback("BriefcaseBomb_Countdown", funcCallback)
		cvars.AddChangeCallback("BriefcaseBomb_Magnitude", funcCallback)
		cvars.AddChangeCallback("BriefcaseBomb_BeepSound", funcCallback)
	end
end)

if SERVER then
	util.AddNetworkString("Briefcase_Convars_Change")

	net.Receive("Briefcase_Convars_Change", function(len, ply)
		if !ply:IsAdmin() then
			return
		end
		local cvar_name = net.ReadString()
		local cvar_val = net.ReadFloat()
		RunConsoleCommand(cvar_name, cvar_val)
	end)

elseif CLIENT then
	hook.Add("PopulateToolMenu", "AddBriefcaseSettingsPanel", function()
		spawnmenu.AddToolMenuOption("Utilities", "Hoff's Addons", "BriefcaseSettingsPanel", "Briefcase Setup", "", "", function(cpanel)

			if !game.SinglePlayer() and !LocalPlayer():IsAdmin() then
				return
			end

			cpanel:NumSlider("Explosion Magnitude", "BriefcaseBomb_Magnitude", 1, 500, 0)
			cpanel:NumSlider("Countdown Time", "BriefcaseBomb_Countdown", 1, 300, 0)
			cpanel:CheckBox("Beep Sound", "BriefcaseBomb_BeepSound")
		end)
	end)
end
