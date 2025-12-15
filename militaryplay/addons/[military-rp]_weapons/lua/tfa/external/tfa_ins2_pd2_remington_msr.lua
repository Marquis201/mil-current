local path = "weapons/msr/"
local pref = "TFA_INS2.PD2_MSR"

TFA.AddFireSound( pref .. ".Fire", {path .. "msr_fire.wav"}, true, ")")
TFA.AddFireSound( pref .. ".Fire_Suppressed", {path .. "snip_sil_2.wav"})

TFA.AddWeaponSound( pref .. ".BoltRelease", path .. "msr_boltup.wav" )
TFA.AddWeaponSound( pref .. ".Boltback", path .. "msr_boltback.wav" )
TFA.AddWeaponSound( pref .. ".Boltforward", path .. "msr_boltforward.wav" )
TFA.AddWeaponSound( pref .. ".BoltLatch", path .. "msr_boltdown.wav" )

TFA.AddWeaponSound( pref .. ".Magrelease", path .. "msr_magrelease.wav" )
TFA.AddWeaponSound( pref .. ".Magout", path .. "msr_magout.wav" )
TFA.AddWeaponSound( pref .. ".Magin", path .. "msr_magin.wav" )

TFA.AddWeaponSound( pref .. ".Empty", path .. "m40a1_empty.wav" )