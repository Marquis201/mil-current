if CLIENT then
	killicon.Add( "tfa_l4d2mw_bat", "vgui/killicons/l4d2mw_bat", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.Bat.HitFlesh", { "weapons/l4d2mw_bat/impactflesh.wav", "weapons/l4d2mw_bat/impactflesh2.wav", "weapons/l4d2mw_bat/impactflesh3.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.Bat.HitWorld", { "weapons/l4d2mw_bat/impactworld.wav", "weapons/l4d2mw_bat/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.Bat.Swing", { "weapons/l4d2mw_bat/swing.wav", "weapons/l4d2mw_bat/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.Bat.Deploy", { "weapons/l4d2mw_bat/deploy.wav" } )