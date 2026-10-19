if CLIENT then
	killicon.Add( "tfa_l4d2mw_baton", "vgui/killicons/l4d2mw_baton", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.Baton.HitFlesh", { "weapons/l4d2mw_baton/impactflesh.wav", "weapons/l4d2mw_baton/impactflesh2.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.Baton.HitWorld", { "weapons/l4d2mw_baton/impactworld.wav", "weapons/l4d2mw_baton/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.Baton.Swing", { "weapons/l4d2mw_baton/swing.wav", "weapons/l4d2mw_baton/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.Baton.Deploy", { "weapons/l4d2mw_baton/deploy.wav" } )