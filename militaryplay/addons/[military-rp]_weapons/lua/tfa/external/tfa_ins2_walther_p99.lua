local path = "/weapons/p99/"
local pref = "TFA_INS2.P99"
local hudcolor = Color(255, 80, 0, 191)

TFA.AddFireSound(pref .. ".Fire", path .. "fire.wav", true, ")")
TFA.AddFireSound(pref .. ".Fire_Suppressed", path .. "fire_suppressed.wav", false, ")")

TFA.AddWeaponSound(pref .. ".Safety", path .. "fireselect.wav")
TFA.AddWeaponSound(pref .. ".Boltback", path .. "slideback.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "slideforward.wav")
TFA.AddWeaponSound(pref .. ".Empty", path .. "empty.wav")
TFA.AddWeaponSound(pref .. ".Magrelease", path .. "magrelease.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "magout.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "magin_2.wav")
TFA.AddWeaponSound(pref .. ".MaginRelease", path .. "magrelease.wav")
TFA.AddWeaponSound(pref .. ".MagHit", path .. "maghit.wav")
TFA.AddWeaponSound(pref .. ".Boltslap", path .. "slideback.wav")