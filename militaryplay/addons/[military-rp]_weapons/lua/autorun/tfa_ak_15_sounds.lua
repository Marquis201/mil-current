//this part is for making kill icons
local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then
       killicon.Add(  "tfa_at_ak_15","vgui/hud/tfa_at_ak_15", icol  )
	end

	

sound.Add({
	name = 			"Weapon_ak_15.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tfa_at_ak_15/suppressed_fp15.wav"
})