if CLIENT then
	killicon.Add( "tfa_l4d2mw_metalbat", "vgui/killicons/l4d2mw_metalbat", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.MetalBat.HitFlesh", { "weapons/l4d2mw_metalbat/impactflesh.wav", "weapons/l4d2mw_metalbat/impactflesh2.wav", "weapons/l4d2mw_metalbat/impactflesh3.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.MetalBat.HitWorld", { "weapons/l4d2mw_metalbat/impactworld.wav", "weapons/l4d2mw_metalbat/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.MetalBat.Swing", { "weapons/l4d2mw_metalbat/swing.wav", "weapons/l4d2mw_metalbat/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.MetalBat.Deploy", { "weapons/l4d2mw_metalbat/deploy.wav" } )