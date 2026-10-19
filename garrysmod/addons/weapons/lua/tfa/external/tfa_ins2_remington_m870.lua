local path = "/weapons/remington_870/"
local pref = "TFA_INS2.Remington_870"

TFA.AddFireSound(pref .. ".Fire", {path .. "870_shoot_1.wav", path .. "870_shoot_2.wav", path .. "870_shoot_3.wav"}, true, ")")
TFA.AddFireSound(pref .. ".Fire_Suppressed", {path .. "870_suppressed_1.wav", path .. "870_suppressed_2.wav", path .. "870_suppressed_3.wav"})

TFA.AddWeaponSound(pref .. ".Draw", path .. "870_draw.wav")

TFA.AddWeaponSound(pref .. ".Boltback", path .. "870_pumpback.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "870_pumpforward.wav")
TFA.AddWeaponSound(pref .. ".Empty", path .. "870_empty.wav")
TFA.AddWeaponSound(pref .. ".ShellInsert", {path .. "870_insertshell_1.wav", path .. "870_insertshell_2.wav", path .. "870_insertshell_3.wav"})
TFA.AddWeaponSound(pref .. ".ShellInsertSingle", {path .. "870_shell_in_1.wav", path .. "870_shell_in_2.wav", path .. "870_shell_in_3.wav"})

--[[
TFA.AddFireSound(pref .. ".Fire", {path .. "m870_1.wav"})

sound.Add({
name = "M870_ECHO_OUTDOORS",
channel = CHAN_WEAPON,
volume = 1.0,
level = 1000,
pitch = { 95, 105 },
sound = {"/weapons/remington_870/m870_open_echo.wav"}
})

sound.Add({
name = "M870_ECHO_INDOORS",
channel = CHAN_WEAPON,
volume = 1.0,
level = 1000,
pitch = { 100 },
sound = {"/weapons/remington_870/m870_indoor_echo.wav"}
})
--]]
