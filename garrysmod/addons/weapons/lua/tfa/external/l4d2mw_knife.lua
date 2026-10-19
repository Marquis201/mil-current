if CLIENT then
	killicon.Add( "tfa_l4d2mw_knife", "vgui/killicons/l4d2mw_knife", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.Knife.HitFlesh", { "weapons/l4d2mw_knife/impactflesh.wav", "weapons/l4d2mw_knife/impactflesh2.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.Knife.HitWorld", { "weapons/l4d2mw_knife/impactworld.wav", "weapons/l4d2mw_knife/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.Knife.Swing", { "weapons/l4d2mw_knife/swing.wav", "weapons/l4d2mw_knife/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.Knife.Deploy", { "weapons/l4d2mw_knife/deploy.wav" } )