hook.Add( "LVS:Initialize", "SW Controls keys", function()
	local KEYS = {
		{
			name = "+ZOOM",
			category = "Misc",
			name_menu = "Cam zoom in",
			cmd = "lvs_cam_zoom_in"
		},
		{
			name = "-ZOOM",
			category = "Misc",
			name_menu = "Cam zoom out",
			cmd = "lvs_cam_zoom_out"
		},
		{
			name = "AIRBRAKE",
			category = "Misc",
			name_menu = "Airbrake",
			cmd = "lvs_airbrake"
		},
		{
			name = "BAILOUT",
			category = "Misc",
			name_menu = "Bail out",
			cmd = "lvs_bailout"
		},
		{
			name = "CHUTE",
			category = "Misc",
			name_menu = "Brake chute",
			cmd = "lvs_brake_chute"
		},
	}

	for _, v in pairs( KEYS ) do
		LVS:AddKey( v.name, v.category, v.name_menu, v.cmd, v.default )
	end
end )