if CLIENT then
	killicon.Add( "tfa_l4d2mw_katana", "vgui/killicons/l4d2mw_katana", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.Katana.HitFlesh", { "weapons/l4d2mw_katana/impactflesh.wav", "weapons/l4d2mw_katana/impactflesh2.wav", "weapons/l4d2mw_katana/impactflesh3.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.Katana.HitWorld", { "weapons/l4d2mw_katana/impactworld.wav", "weapons/l4d2mw_katana/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.Katana.Swing", { "weapons/l4d2mw_katana/swing.wav", "weapons/l4d2mw_katana/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.Katana.Deploy", { "weapons/l4d2mw_katana/deploy.wav" } )