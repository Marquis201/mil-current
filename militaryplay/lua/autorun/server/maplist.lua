hook.Add( "Initialize", "changemapworkshop", function()
	if game.GetMap() == "gm_flatgrass" then
		timer.Create( "ChangeMap", 0,100,function()
		RunConsoleCommand("Changelevel","rp_military_play")
		end)
	end
end )