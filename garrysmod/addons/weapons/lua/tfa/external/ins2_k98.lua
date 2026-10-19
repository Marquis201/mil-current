local path = "weapons/tfa_ins2/k98/"
local pref = "TFA_INS2_K98"
local hudcolor = Color(255, 80, 0, 191)

TFA.AddFireSound(pref .. ".1", path .. "mosin_fp.wav", true, ")" )
TFA.AddFireSound(pref .. ".2", path .. "mosin_suppressed_fp.wav", true, ")" )

TFA.AddWeaponSound(pref .. ".Boltback", path .. "mosin_boltback.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "mosin_boltrelease.wav")
TFA.AddWeaponSound(pref .. ".Boltforward", path .. "mosin_boltforward.wav")
TFA.AddWeaponSound(pref .. ".BoltLatch", path .. "mosin_boltlatch.wav")
TFA.AddWeaponSound(pref .. ".Roundin", { path .. "mosin_bulletin_1.wav", path .. "mosin_bulletin_2.wav", path .. "mosin_bulletin_3.wav", path .. "mosin_bulletin_4.wav" } )
TFA.AddWeaponSound(pref .. ".Empty", path .. "mosin_empty.wav")

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_k98", "vgui/killicons/tfa_ins2_k98", hudcolor)
end

