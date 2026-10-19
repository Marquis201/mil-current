local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then
       killicon.Add(  "tfa_ins2_glock_19",		"vgui/hud/ins2_glock_19", icol  )

end

sound.Add(
{
name = "Weapon_Glock19.Boltback",
channel = CHAN_ITEM,
volume = VOL_NORM,
soundlevel = SNDLVL_NORM,
sound = "weapons/glock_19/glock_slideback.wav"
} )
sound.Add(
{
name = "Weapon_Glock19.Boltrelease",
channel = CHAN_ITEM,
volume = VOL_NORM,
soundlevel = SNDLVL_NORM,
sound = "weapons/glock_19/glock_sliderelease.wav"
} )
sound.Add(
{
name = "Weapon_Glock19.Magout",
channel = CHAN_ITEM,
volume = VOL_NORM,
soundlevel = SNDLVL_NORM,
sound = "weapons/glock_19/glock_clipout.wav"
} )
sound.Add(
{
name = "Weapon_Glock19.Magin",
channel = CHAN_ITEM,
volume = VOL_NORM,
soundlevel = SNDLVL_NORM,
sound = "weapons/glock_19/glock_clipin.wav"
} )
sound.Add(
{
name = "Weapon_Glock19.MagHit",
channel = CHAN_ITEM,
volume = VOL_NORM,
soundlevel = SNDLVL_NORM,
sound = "weapons/glock_19/glock_maghit.wav"
} )

