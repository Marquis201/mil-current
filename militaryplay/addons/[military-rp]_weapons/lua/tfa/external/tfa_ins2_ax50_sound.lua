local path = "weapons/ax50/"
local pref = "TFA_INS2.AX50"

TFA.AddFireSound(pref .. ".Fire", {path .. "ax50_01.wav", path .. "ax50_02.wav"}, true, ")")
TFA.AddFireSound( pref .. ".Fire_Suppressed", { path .. "ax50_suppressed_fp.wav" })

TFA.AddWeaponSound( pref .. ".draw", path .. "ax50_draw3.wav" )

TFA.AddWeaponSound( pref .. ".BoltRelease", path .. "ax50_boltrelease2.wav" )
TFA.AddWeaponSound( pref .. ".Boltback", path .. "ax50_boltback2.wav" )
TFA.AddWeaponSound( pref .. ".Boltforward", path .. "ax50_boltforward2.wav" )
TFA.AddWeaponSound( pref .. ".BoltLatch", path .. "ax50_boltlatch2.wav" )

TFA.AddWeaponSound( pref .. ".Magrelease", path .. "ax50_magrelease.wav" )
TFA.AddWeaponSound( pref .. ".Magout", path .. "ax50_clipout.wav" )
TFA.AddWeaponSound( pref .. ".Magin", path .. "ax50_clipin2.wav" )

TFA.AddWeaponSound( pref .. ".Empty", path .. "ax50_empty.wav" )

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_ax50_upver", "vgui/hud/tfa_ins2_ax50_upver", Color( 0, 0, 0, 255 ))
end