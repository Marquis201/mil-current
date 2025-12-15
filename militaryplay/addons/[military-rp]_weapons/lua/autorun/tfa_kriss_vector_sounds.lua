//this part is for making kill icons
local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then
       killicon.Add(  "tfa_at_kriss_vector","vgui/hud/tfa_at_kriss_vector", icol  )
	end

	

sound.Add({
	name = 			"Weapon_kriss_vector.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tfa_at_kriss_vector/suppressed_fpvector.wav"
})