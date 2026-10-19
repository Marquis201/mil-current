if CLIENT then
	killicon.Add( "tfa_l4d2mw_etool", "vgui/killicons/l4d2mw_etool", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.ETool.HitFlesh", { "weapons/l4d2mw_etool/impactflesh.wav", "weapons/l4d2mw_etool/impactflesh2.wav", "weapons/l4d2mw_etool/impactflesh3.wav", "weapons/l4d2mw_etool/impactflesh4.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.ETool.HitWorld", { "weapons/l4d2mw_etool/impactworld.wav", "weapons/l4d2mw_etool/impactworld2.wav", "weapons/l4d2mw_etool/impactworld3.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.ETool.Swing", { "weapons/l4d2mw_etool/swing.wav", "weapons/l4d2mw_etool/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.ETool.Deploy", { "weapons/l4d2mw_etool/deploy.wav" } )