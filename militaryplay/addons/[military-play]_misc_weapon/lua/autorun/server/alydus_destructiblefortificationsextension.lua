 --[[
 - Destructible Fortifications Extension for Fortification Builder Tablet
 - 
 - /lua/autorun/server/alydus_destructablefortificationsextension.lua
 - 
 - Feel free to modify, but please leave appropriate credit.
 - Do not reupload this (modified or original) to this workshop, however you may ruin modified versions on your servers.
 -
 - Thanks so much for the support with the addon since it's creation in 2018.
 -
 --]]

alydusDestructibleFortificationExtension = true

CreateConVar("alydus_defaultfortificationhealth", 500)

hook.Add("PlayerButtonDown", "Alydus_PlayerButtonDown_RepairFortificationsButton", function(ply, button)
	if button == KEY_G and IsValid(ply) and ply:IsPlayer() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "alydus_fortificationbuildertablet" and ply:GetActiveWeapon():GetIsBootingUp() == false and IsValid(ply:GetEyeTrace().Entity) and ply:GetEyeTrace().Entity:GetClass() == "alydus_destructiblefortification" then
		local health = ply:GetEyeTrace().Entity:GetFortificationHealth()
		if GetConVar("alydus_defaultfortificationhealth"):GetInt() > (tonumber(health) + 5) then
			ply:GetEyeTrace().Entity:SetFortificationHealth(ply:GetEyeTrace().Entity:GetFortificationHealth() + 25)
			ply:EmitSound("items/battery_pickup.wav")
		else
			ply:GetEyeTrace().Entity:SetFortificationHealth(GetConVar("alydus_defaultfortificationhealth"):GetInt())
		end
	end
end)