local path = "weapons/tfa_ins2/ak400/"
local pref = "TFA_INS2.AK400"
local hudcolor = Color(255, 80, 0, 191)

sound.Add({name = pref .. ".FireLoop", channel = CHAN_WEAPON, level = 140, pitch = 100, sound = ")" .. path .. "ak12_loop5.wav"})
sound.Add({name = pref .. ".FireLoop_Tail", channel = CHAN_WEAPON, level = 140, pitch = 100, sound = ")" .. path .. "ak12_tail2.wav"})
sound.Add({name = pref .. ".Semi", channel = CHAN_WEAPON, level = 140, pitch = 100, sound = ")" .. path .. "ak12_semi.wav"})

sound.Add({name = pref .. ".FireLoop_Silenced", channel = CHAN_WEAPON, level = 120, pitch = 100, sound = ")" .. path .. "ak12_silenced.wav"})
sound.Add({name = pref .. ".FireLoop_Silenced_Tail", channel = CHAN_WEAPON, level = 120, pitch = 100, sound = ")" .. path .. "ak12_silenced_loop.wav"})
sound.Add({name = pref .. ".Semi_Silenced", channel = CHAN_WEAPON, level = 120, pitch = 100, sound = ")" .. path .. "ak12_silenced_semi.wav"})

TFA.AddWeaponSound(pref .. ".Boltback", path .. "handling/ak74_boltback.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "handling/ak74_boltrelease.wav")
TFA.AddWeaponSound(pref .. ".Empty", path .. "handling/ak74_empty.wav")
TFA.AddWeaponSound(pref .. ".MagRelease", path .. "handling/ak74_magrelease.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "handling/ak74_magin.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "handling/ak74_magout.wav")
TFA.AddWeaponSound(pref .. ".MagoutRattle", path .. "handling/ak74_magout_rattle.wav")
TFA.AddWeaponSound(pref .. ".ROF", {path .. "handling/ak74_fireselect_1.wav", path .. "handling/ak74_fireselect_2.wav"})
TFA.AddWeaponSound(pref .. ".Rattle", path .. "handling/ak74_rattle.wav")

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_ak400", "vgui/killicons/tfa_ins2_ak400", hudcolor)
end