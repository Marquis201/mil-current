TFA.INS2 = TFA.INS2 or {}
local pref, path

-- Universal
pref, path = "TFA_INS2.", "weapons/ins2/uni/"
TFA.AddWeaponSound(pref .. "PistolDraw", {path .. "uni_pistol_draw_01.wav", path .. "uni_pistol_draw_02.wav", path .. "uni_pistol_draw_03.wav" } ) --, "weapons/ins2/uni/bash1.wav"})
TFA.AddWeaponSound(pref .. "PistolHolster", path .. "uni_pistol_holster.wav")
TFA.AddWeaponSound(pref .. "Draw", {path .. "uni_weapon_draw_01.wav", path .. "uni_weapon_draw_02.wav", path .. "uni_weapon_draw_03.wav" } ) --, "weapons/ins2/uni/bash1.wav"})
TFA.AddWeaponSound(pref .. "Holster", path .. "uni_weapon_holster.wav")

TFA.AddWeaponSound(pref .. "IronIn", {path .. "uni_ads_in_01.wav", path .. "uni_ads_in_02.wav", path .. "uni_ads_in_03.wav", path .. "uni_ads_in_04.wav", path .. "uni_ads_in_05.wav", path .. "uni_ads_in_06.wav" } )
TFA.AddWeaponSound(pref .. "IronOut", path .. "uni_ads_out_01.wav")
TFA.AddWeaponSound(pref .. "LeanIn", {path .. "uni_lean_in_01.wav", path .. "uni_lean_in_02.wav", path .. "uni_lean_in_03.wav", path .. "uni_lean_in_04.wav" } )

TFA.AddWeaponSound(pref .. "GLBeginReload", {path .. "uni_gl_beginreload_01.wav", path .. "uni_gl_beginreload_02.wav", path .. "uni_gl_beginreload_03.wav" } )

TFA.AddSound(pref .. "BipodSwivel", CHAN_STATIC, 0.35, 75, 100, {path .. "uni_bipod_swivel_01.wav", path .. "uni_bipod_swivel_02.wav", path .. "uni_bipod_swivel_03.wav", path .. "uni_bipod_swivel_04.wav", path .. "uni_bipod_swivel_05.wav"})

-- Flashlight
path = "weapons/ins2/player/"
TFA.AddSound(pref .. "FlashlightOn", CHAN_ITEM, 0.2, 75, 100, path .. "flashlight_on.wav")
TFA.AddSound(pref .. "FlashlightOff", CHAN_ITEM, 0.2, 75, 100, path .. "flashlight_off.wav")

-- GP30
pref, path = "TFA_INS2_GP30.", "weapons/ins2/gp30/"
TFA.AddFireSound(pref .. "1", path .. "gp30_fp.wav", true, ")" )
TFA.AddWeaponSound(pref .. "Deselect", path .. "handling/gp30_deselect.wav" )
TFA.AddWeaponSound(pref .. "Select", path .. "handling/gp30_select.wav" )
TFA.AddWeaponSound(pref .. "GrenadeIn", { path .. "handling/gp30_insertgrenade_01.wav", path .. "handling/gp30_insertgrenade_02.wav" } )
TFA.AddWeaponSound(pref .. "GrenadeInClick", path .. "handling/gp30_insertgrenade_click.wav" )
TFA.AddWeaponSound(pref .. "Empty", path .. "handling/gp30_empty.wav" )

-- M203
pref, path = "TFA_INS2_M203.", "weapons/ins2/m203/"
TFA.AddFireSound(pref .. "1", path .. "m203_fp.wav", true, ")")
TFA.AddWeaponSound(pref .. "Deselect", path .. "handling/m203_deselect.wav")
TFA.AddWeaponSound(pref .. "Select", path .. "handling/m203_select.wav")
TFA.AddWeaponSound(pref .. "Empty", path .. "handling/m203_empty.wav")
TFA.AddWeaponSound(pref .. "GrenadeIn", {path .. "handling/m203_insertgrenade_01.wav", path .. "handling/m203_insertgrenade_02.wav"})
TFA.AddWeaponSound(pref .. "CloseBarrel", path .. "handling/m203_closebarrel.wav")
TFA.AddWeaponSound(pref .. "OpenBarrel", path .. "handling/m203_openbarrel.wav")