local path = "weapons/cheytac_m200/"
local pref = "TFA_INS2.Warface_Cheytac_M200"

TFA.AddFireSound(pref .. ".Fire", {path .. "m200_shoot.wav" }, true, ")")
TFA.AddFireSound( pref .. ".Fire_Suppressed", { path .. "m200_suppressed.wav" })

TFA.AddWeaponSound( pref .. ".draw", path .. "m200_draw.wav" )

TFA.AddWeaponSound( pref .. ".BoltRelease", path .. "m200_boltforward.wav" )
TFA.AddWeaponSound( pref .. ".Boltback", path .. "m200_boltback.wav" )
TFA.AddWeaponSound( pref .. ".Boltforward", path .. "m200_boltup.wav" )
TFA.AddWeaponSound( pref .. ".BoltLatch", path .. "m200_boltdown.wav" )

TFA.AddWeaponSound( pref .. ".Magrelease", path .. "m200_magrelease.wav" )
TFA.AddWeaponSound( pref .. ".Magout", path .. "m200_clipout.wav" )
TFA.AddWeaponSound( pref .. ".Magin", path .. "m200_clipin.wav" )

TFA.AddWeaponSound( pref .. ".Empty", path .. "m200_empty.wav" )