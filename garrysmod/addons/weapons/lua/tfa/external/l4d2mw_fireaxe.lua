if CLIENT then
	killicon.Add( "tfa_l4d2mw_fireaxe", "vgui/killicons/l4d2mw_fireaxe", Color( 255, 255, 255, 255 ) )
end

TFA.AddFireSound( "L4D2_MW.FireAxe.HitFlesh", { "weapons/l4d2mw_fireaxe/impactflesh.wav", "weapons/l4d2mw_fireaxe/impactflesh2.wav", "weapons/l4d2mw_fireaxe/impactflesh3.wav" }, false, "^" )
TFA.AddFireSound( "L4D2_MW.FireAxe.HitWorld", { "weapons/l4d2mw_fireaxe/impactworld.wav", "weapons/l4d2mw_fireaxe/impactworld2.wav" }, false, "^" )
TFA.AddWeaponSound( "L4D2_MW.FireAxe.Swing", { "weapons/l4d2mw_fireaxe/swing.wav", "weapons/l4d2mw_fireaxe/swing2.wav" } )
TFA.AddWeaponSound( "L4D2_MW.FireAxe.Deploy", { "weapons/l4d2mw_fireaxe/deploy.wav" } )