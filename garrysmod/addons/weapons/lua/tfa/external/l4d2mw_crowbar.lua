if CLIENT then
	killicon.Add( "tfa_l4d2mw_crowbar", "vgui/killicons/l4d2mw_crowbar", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.Crowbar.HitFlesh", { "weapons/l4d2mw_crowbar/impactflesh.wav", "weapons/l4d2mw_crowbar/impactflesh2.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.Crowbar.HitWorld", { "weapons/l4d2mw_crowbar/impactworld.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.Crowbar.Swing", { "weapons/l4d2mw_crowbar/swing.wav", "weapons/l4d2mw_crowbar/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.Crowbar.Deploy", { "weapons/l4d2mw_crowbar/deploy.wav" } )