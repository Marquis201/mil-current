
TOOL.Category		= "LFS/LVS"
TOOL.Name			= "#tool.sw_loadout_editor_v3.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "loadout" ] = 0

if CLIENT then
	language.Add( "tool.sw_loadout_editor_v3.name", "Loadout Editor" )
	language.Add( "tool.sw_loadout_editor_v3.desc", "A tool used to set loadout on LFS/LVS-Vehicles" )
	language.Add( "tool.sw_loadout_editor_v3.0", "Left click on a LFS/LVS-Vehicle to set loadout,Right click to set 0 loadout." )
	language.Add( "tool.sw_loadout_editor_v3.1", "Left click on a LFS/LVS-Vehicle to set loadout,Right click to set 0 loadout." )
	language.Add( "tool.sw_loadout_editor_v3.loadout", "Loadout" )
end

function TOOL:LeftClick( trace )
	local ent = trace.Entity
	if not IsValid( ent ) or not (ent.LFS or ent.LVS) then return false end
	if isnumber(ent.Loadouts) then
		ent:SetLoadout( self:GetClientNumber( "loadout" ) )
	end
	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity
	if not IsValid( ent ) or not (ent.LFS or ent.LVS) then return false end
	if isnumber(ent.Loadouts) then
		ent:SetLoadout(0)
	end
	return true
end

function TOOL:Reload( trace )
end

function TOOL:Think()
end

function TOOL.BuildCPanel( panel )
	panel:AddControl( "Header", { Text = "#tool.sw_loadout_editor_v3.name", Description = "#tool.sw_loadout_editor_v3.desc" } )

	panel:AddControl( "Slider", 
	{
		Label 	= "#tool.sw_loadout_editor_v3.loadout",
		Type 	= "Int",
		Min 	= "0",
		Max 	= "50",
		Command = "sw_loadout_editor_v3_loadout",
		Help = false
	})
end