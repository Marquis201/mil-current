if CLIENT then
	killicon.Add( "tfa_l4d2mw_machete", "vgui/killicons/l4d2mw_machete", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.Machete.HitFlesh", { "weapons/l4d2mw_machete/impactflesh.wav", "weapons/l4d2mw_machete/impactflesh2.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.Machete.HitWorld", { "weapons/l4d2mw_machete/impactworld.wav", "weapons/l4d2mw_machete/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.Machete.Swing", { "weapons/l4d2mw_machete/swing.wav", "weapons/l4d2mw_machete/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.Machete.Deploy", { "weapons/l4d2mw_machete/deploy.wav" } )