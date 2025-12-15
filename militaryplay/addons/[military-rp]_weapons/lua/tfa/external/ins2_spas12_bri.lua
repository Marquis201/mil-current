local path = "weapons/tfa_ins2/spas12/"

TFA.AddFireSound("TFA_INS2_SPAS12.1", path .. "fire.wav", true, ")" )
TFA.AddFireSound("TFA_INS2_SPAS12.2", path .. "m590_suppressed_fp.wav", true, ")" )
TFA.AddWeaponSound("TFA_INS2_SPAS12.Draw", { path .. "uni_weapon_draw_01.wav", path .. "uni_weapon_draw_02.wav", path .. "uni_weapon_draw_03.wav" } ) --, path .. "bash1.wav"})
TFA.AddWeaponSound("TFA_INS2_SPAS12.Holster", path .. "uni_weapon_holster.wav")
TFA.AddWeaponSound("TFA_INS2_SPAS12.Boltback", path .. "PumpBack.wav")
TFA.AddWeaponSound("TFA_INS2_SPAS12.Boltrelease", path .. "PumpForward.wav")
TFA.AddWeaponSound("TFA_INS2_SPAS12.ShellInsert", { path .. "insertshell-1.wav", path .. "insertshell-2.wav", path .. "insertshell-3.wav" } )
TFA.AddWeaponSound("TFA_INS2_SPAS12.ShellInsertSingle", { path .. "insertshell-1.wav", path .. "insertshell-2.wav", path .. "insertshell-3.wav" } )
TFA.AddWeaponSound("TFA_INS2_SPAS12.Empty", path .. "m590_empty.wav")

TFA.AddWeaponSound("TFA_INS2_SPAS12.IronIn", {path .. "uni_ads_in_01.wav", path .. "uni_ads_in_02.wav", path .. "uni_ads_in_03.wav", path .. "uni_ads_in_04.wav", path .. "uni_ads_in_05.wav", path .. "uni_ads_in_06.wav" } )
TFA.AddWeaponSound("TFA_INS2_SPAS12.IronOut", path .. "uni_ads_out_01.wav")