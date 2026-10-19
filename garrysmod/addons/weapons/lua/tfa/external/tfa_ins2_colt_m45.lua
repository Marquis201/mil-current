local path = "/weapons/m1911/"
local pref = "TFA_INS2.Colt_M45"

TFA.AddFireSound(pref .. ".Fire", path .. "m1911_fire.wav", true, ")")
TFA.AddFireSound(pref .. ".Fire_Suppressed", path .. "m1911_suppressed.wav", false, ")")

TFA.AddWeaponSound(pref .. ".Safety", path .. "m1911_safety.wav")
TFA.AddWeaponSound(pref .. ".Boltback", path .. "m1911_boltback.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "m1911_boltrelease.wav")
TFA.AddWeaponSound(pref .. ".Empty", path .. "m1911_empty.wav")
TFA.AddWeaponSound(pref .. ".Magrelease", path .. "m1911_magrelease.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "m1911_magout.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "m1911_magin.wav")
TFA.AddWeaponSound(pref .. ".MagHit", path .. "m1911_maghit.wav")
