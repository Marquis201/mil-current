local pistolweapons = {
  ["fas2_fn57"] = true,
  ["fas2_cz75"] = true,
  ["fas2_cz75_auto"] = true,
  ["fas2_colt1911"] = true,
  ["fas2_berreta92fs"] = true,
  ["fas2_fnp45"] = true,
  ["fas2_fnx45"] = true,
  ["fas2_glock19"] = true,
  ["fas2_hpsa"] = true,
  ["fas2_usp"] = true,
  ["fas2_usp_match"] = true,
  ["fas2_deserteagle"] = true,
  ["fas2_sig220"] = true,
  ["fas2_walther"] = true,
  ["fas2_aps"] = true,
  ["fas2_oc33"] = true,
  ["fas2_gsh18"] = true,
  ["fas2_pm"] = true,
  ["fas2_grach"] = true,
  ["fas2_pb"] = true,
  ["fas2_fort12"] = true,
  ["fas2_fort17"] = true,
  ["fas2_f1"] = true,
  ["fas2_rgd5"] = true,
}
hook.Add("PlayerSwitchWeapon", "WeaponSwitchExample", function(p, oldWeapon, newWeapon)
  if p:GetNetVar("Anim") --[[ && p:GetNWString("An") ~= "Сесть Скрестив Ноги" ]] then return true end;
  if newWeapon:GetClass() == p:GetNetVar("c_wpn") then
    p:SetNetVar("c_wpn", "")
    p:SetNetVar("m_wpn", "")
    return
  end
  if newWeapon:GetClass() == p:GetNetVar("c_wpn2") then
    p:SetNetVar("c_wpn2", "")
    p:SetNetVar("m_wpn2", "")
    return
  end
  if ! IsValid(oldWeapon) then return end
  if ! oldWeapon:GetClass():find("fas2_") then return end
  if pistolweapons[p:GetActiveWeapon():GetClass()] then return end
  local holdtype = oldWeapon:GetHoldType():lower()

  if holdtype == "pistol" or holdtype == "revolver" or holdtype == "normal" then return end

  -- Prevent placing the same weapon in multiple slots
  if oldWeapon:GetClass() == p:GetNetVar("c_wpn") or oldWeapon:GetClass() == p:GetNetVar("c_wpn2") then return end

  -- RPG is handled separately, not in slots
  if oldWeapon:GetClass() == "stalker_rpg" then return end

  -- Alternate between slots, overwriting the current slot
  local toggle = p:GetNetVar("slot_toggle") or 0
  if toggle == 0 then
    p:SetNetVar("c_wpn", oldWeapon:GetClass())
    p:SetNetVar("m_wpn", oldWeapon:GetModel())
    p:SetNetVar("slot_toggle", 1)
  else
    p:SetNetVar("c_wpn2", oldWeapon:GetClass())
    p:SetNetVar("m_wpn2", oldWeapon:GetModel())
    p:SetNetVar("slot_toggle", 0)
  end
end)
