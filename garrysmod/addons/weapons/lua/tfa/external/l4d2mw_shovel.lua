if CLIENT then
	killicon.Add( "tfa_l4d2mw_shovel", "vgui/killicons/l4d2mw_shovel", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.Shovel.HitFlesh", { "weapons/l4d2mw_shovel/impactflesh.wav", "weapons/l4d2mw_shovel/impactflesh2.wav", "weapons/l4d2mw_shovel/impactflesh3.wav", "weapons/l4d2mw_shovel/impactflesh4.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.Shovel.HitWorld", { "weapons/l4d2mw_shovel/impactworld.wav", "weapons/l4d2mw_shovel/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.Shovel.Swing", { "weapons/l4d2mw_shovel/swing.wav", "weapons/l4d2mw_shovel/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.Shovel.Deploy", { "weapons/l4d2mw_shovel/deploy.wav" } )