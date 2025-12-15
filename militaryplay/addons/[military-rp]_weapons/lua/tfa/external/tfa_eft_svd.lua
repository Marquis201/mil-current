local path = "weapons/svd/"
local pref = "TFA_EFT.SVD"

TFA.AddFireSound(pref .. ".1", path .. "svd_fire_close.wav", false, ")")
TFA.AddFireSound(pref .. ".2", path .. "svd_fire_close_silenced.wav", false, ")")

TFA.AddWeaponSound(pref .. ".Empty", path .. "svd_hammer.wav")
TFA.AddWeaponSound(pref .. ".Boltback", path .. "svd_slider_in.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "svd_slider_out.wav")
TFA.AddWeaponSound(pref .. ".Magrelease", path .. "svd_mag_button.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "svd_mag_out_quick.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "svd_mag_in.wav")