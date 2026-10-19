function AddAmmoType(name, text)
game.AddAmmoType({name = name,
dmgtype = DMG_BLAST})

if CLIENT then
language.Add(name .. "_ammo", text)
end
end

AddAmmoType("PanzerFaust3 Rocket", "PanzerFaust3 Rocket")
