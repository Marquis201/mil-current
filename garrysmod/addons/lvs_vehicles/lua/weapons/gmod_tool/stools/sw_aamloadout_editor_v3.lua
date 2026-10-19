
TOOL.Category		= "LFS/LVS"
TOOL.Name			= "#tool.sw_aamloadout_editor_v3.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "aamloadout" ] = 0

if CLIENT then
	language.Add( "tool.sw_aamloadout_editor_v3.name", "AAM Loadout Editor" )
	language.Add( "tool.sw_aamloadout_editor_v3.desc", "A tool used to set AAM loadout on LFS/LVS-Vehicles" )
	language.Add( "tool.sw_aamloadout_editor_v3.0", "Left click on a LFS/LVS-Vehicle to set AAM loadout,Right click to set 0 loadout." )
	language.Add( "tool.sw_aamloadout_editor_v3.1", "Left click on a LFS/LVS-Vehicle to set AAM loadout,Right click to set 0 loadout." )
	language.Add( "tool.sw_aamloadout_editor_v3.AAMloadout", "Loadout" )
end

function TOOL:LeftClick( trace )
	local ent = trace.Entity
	if not IsValid( ent ) or not (ent.LFS or ent.LVS) then return false end
	if isnumber(ent.AAMLoadouts) then
		ent:SetAAMLoadout( self:GetClientNumber( "aamloadout" ) )
	end
	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity
	if not IsValid( ent ) or not (ent.LFS or ent.LVS) then return false end
	if isnumber(ent.AAMLoadouts) then
		ent:SetAAMLoadout(0)
	end
	return true
end

function TOOL:Reload( trace )
end

function TOOL:Think()
end

function TOOL.BuildCPanel( panel )
	panel:AddControl( "Header", { Text = "#tool.sw_aamloadout_editor_v3.name", Description = "#tool.sw_aamloadout_editor_v3.desc" } )

	panel:AddControl( "Slider", 
	{
		Label 	= "#tool.sw_aamloadout_editor_v3.AAMloadout",
		Type 	= "Int",
		Min 	= "0",
		Max 	= "10",
		Command = "sw_aamloadout_editor_v3_aamloadout",
		Help = false
	})
end