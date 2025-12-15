local path = "weapons/warface_orsis_t5000/"
local pref = "TFA_INS2.Warface_Orsis_T5000"

TFA.AddFireSound( pref .. ".Fire", {path .. "t5000_shoot_1.wav", path .. "t5000_shoot_2.wav", path .. "t5000_shoot_3.wav"}, true, ")")
TFA.AddFireSound( pref .. ".Fire_Suppressed", {path .. "t5000_shoot_suppressed_1.wav", path .. "t5000_shoot_suppressed_2.wav", path .. "t5000_shoot_suppressed_3.wav"})

TFA.AddWeaponSound( pref .. ".BoltRelease", path .. "t5000_boltforward.wav" )
TFA.AddWeaponSound( pref .. ".Boltback", path .. "t5000_boltback.wav" )
TFA.AddWeaponSound( pref .. ".Boltforward", path .. "t5000_boltup.wav" )
TFA.AddWeaponSound( pref .. ".BoltLatch", path .. "t5000_boltdown.wav" )

TFA.AddWeaponSound( pref .. ".Magrelease", path .. "t5000_magrelease.wav" )
TFA.AddWeaponSound( pref .. ".Magout", path .. "t5000_magout.wav" )
TFA.AddWeaponSound( pref .. ".Magin", path .. "t5000_magin.wav" )

TFA.AddWeaponSound( pref .. ".Empty", path .. "t5000_empty.wav" )