local path = "/nb_416c/"
local pref = "TFA_INS2_416C"
local hudcolor = Color(255, 80, 0, 191)

TFA.AddFireSound(pref .. ".1", path .. "fire.wav", false, ")")
TFA.AddFireSound(pref .. ".2", path .. "fire_sup.wav", false, ")")

TFA.AddWeaponSound(pref .. ".Boltback", path .. "boltback.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "boltrelease.wav")
TFA.AddWeaponSound(pref .. ".Empty", path .. "empty.wav")
TFA.AddWeaponSound(pref .. ".Magrelease", path .. "magrelease.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "magout.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "magin.wav")
TFA.AddWeaponSound(pref .. ".Hit", path .. "hit.wav")
TFA.AddWeaponSound(pref .. ".ROF", path .. "fireselect.wav")

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_416c", "vgui/killicons/tfa_ins2_416c", hudcolor)
end

