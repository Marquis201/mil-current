local path = "weapons/tfa_ins2_sr25_eft/"
local pref = "TFA_EFT_SR25"
local hudcolor = Color(255, 255, 255, 255)

TFA.AddWeaponSound(pref .. ".Magrelease", path .. "m14_magrelease.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "m14_magout.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "m14_magin.wav")
TFA.AddWeaponSound(pref .. ".Hit", path .. "m16_hit.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "m14_boltrelease.wav")
TFA.AddWeaponSound(pref .. ".Boltback", path .. "m14_boltback.wav")
TFA.AddWeaponSound(pref .. ".Empty", path .. "m14_empty.wav")
TFA.AddWeaponSound(pref .. ".ROF", path .. "m14_fireselect.wav")

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_sr25_eft", "vgui/hud/tfa_ins2_sr25_eft", hudcolor)
end