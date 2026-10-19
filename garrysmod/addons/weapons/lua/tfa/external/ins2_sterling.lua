local path = "weapons/tfa_ins2/sterling/"
local pref = "TFA_INS2.STERLING"
local hudcolor = Color(255, 80, 0, 191)

TFA.AddFireSound(pref .. ".1", path .. "sterling_fp.wav", false, ")")
TFA.AddFireSound(pref .. ".2", path .. "sterling_suppressed_fp.wav", false, ")")

TFA.AddWeaponSound(pref .. ".Magrelease", path .. "Sterling_magrelease.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "Sterling_magin.wav")
TFA.AddWeaponSound(pref .. ".Maghit", path .. "Sterling_maghit.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "Sterling_magout.wav")
TFA.AddWeaponSound(pref .. ".Empty", path .. "Sterling_empty.wav")
-- TFA.AddWeaponSound(pref .. ".Boltlock", path .. "Sterling_boltlock.wav")
-- TFA.AddWeaponSound(pref .. ".Boltunlock", path .. "Sterling_boltunlock.wav")
TFA.AddWeaponSound(pref .. ".Boltback", path .. "Sterling_boltback.wav")
-- TFA.AddWeaponSound(pref .. ".ROF", path .. "Sterling_fireselect.wav")
TFA.AddWeaponSound(pref .. ".StockOpen_01", path .. "Sterling_stockopen_01.wav")
TFA.AddWeaponSound(pref .. ".StockOpen_02", path .. "Sterling_stockopen_02.wav")

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_ump45", "vgui/killicons/tfa_ins2_ump45", hudcolor)
end