-- local model = ClientsideModel( "models/weapons/w_stalker_vss.mdl" )
-- model:SetNoDraw( true )
local localPlayer
local tableweapons = setmetatable({}, {__call = function(s,a,...)s[a] = {...}end})
local Vector, Angle = Vector, Angle

-- RPG
tableweapons("stalker_rpg", "ValveBiped.Bip01_Spine1", Vector(1.5, 14, 7.5),  Angle(-90, 100, 0))
tableweapons("stalker_rg6", "ValveBiped.Bip01_Spine1", Vector(0.7, -5, 8), Angle(0, -85, -5))

-- ... существующие FAS2 оружия ...

-- TFA Snipers
tableweapons("tfa_ins2_wpn_ak74izh",  "ValveBiped.Bip01_Spine1", Vector(1.75, 16, -6.25),  Angle(0, 280, 0), Vector(1.75, 16, 6),  Angle(180, 280, 0))
tableweapons("tfa_ins2_wpn_svd",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_m14",  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_m24",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_sv98",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))

-- TFA Rifles
tableweapons("tfa_ins2_wpn_ak74izh",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_akm",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_ak74",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_aks74u",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_ak105",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_ak12",  "ValveBiped.Bip01_Spine1", Vector(1.75, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_m4a1",  "ValveBiped.Bip01_Spine1", Vector(2.25, 13, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_m16a4",  "ValveBiped.Bip01_Spine1", Vector(2.25, 13, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_hk416",  "ValveBiped.Bip01_Spine1", Vector(2.8, 13, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_scar",  "ValveBiped.Bip01_Spine1", Vector(2.5, 12, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_g36",  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_aug",  "ValveBiped.Bip01_Spine1", Vector(2, 11, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_fal",  "ValveBiped.Bip01_Spine1", Vector(2, 13, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_g3",  "ValveBiped.Bip01_Spine1", Vector(1.5, 15, -7),  Angle(0, 280, 0))

-- TFA SMGs
tableweapons("tfa_ins2_wpn_pp19",  "ValveBiped.Bip01_Spine1", Vector(1.75, 14, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_mp5",  "ValveBiped.Bip01_Spine1", Vector(2, 14, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_mp5k",  "ValveBiped.Bip01_Spine1", Vector(2, 14, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_ump45",  "ValveBiped.Bip01_Spine1", Vector(2.5, 13, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_mp7",  "ValveBiped.Bip01_Spine1", Vector(2, 12, -6.25),  Angle(0, 280, 0), Vector(2, 12, 6),  Angle(180, 280, 0))
tableweapons("tfa_ins2_wpn_p90",  "ValveBiped.Bip01_Spine1", Vector(2, 11, -6.25),  Angle(0, 280, 0), Vector(2, 11, 6),  Angle(180, 280, 0))

-- TFA Shotguns
tableweapons("tfa_ins2_wpn_toz34",  "ValveBiped.Bip01_Spine1", Vector(2, 15, -6.25),  Angle(0, 280, 0), Vector(2, 15, 6),  Angle(180, 280, 0))
tableweapons("tfa_ins2_wpn_mp133",  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_m590",  "ValveBiped.Bip01_Spine1", Vector(2, 15, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_m3s90",  "ValveBiped.Bip01_Spine1", Vector(1.5, 15, -7),  Angle(0, 280, 0))

-- TFA Machine Guns
tableweapons("tfa_ins2_wpn_pkm",  "ValveBiped.Bip01_Spine1", Vector(2, 13, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_rpk",  "ValveBiped.Bip01_Spine1", Vector(2, 14, -7),  Angle(0, 280, 0))
tableweapons("tfa_ins2_wpn_m249",  "ValveBiped.Bip01_Spine1", Vector(2.5, 12, -7),  Angle(0, 280, 0))

local model_rpg = "models/weapons/mysterious/world/explosives/rpg7.mdl"
local model_bulldog = "models/weapons/mysterious/world/explosives/rg6.mdl"

-- ... существующие функции CreateModel, ExtraDraw ...

local psyHelmet = ClientsideModel("models/psihelem.mdl")
psyHelmet:SetNoDraw(true)

local detector_vel = ClientsideModel("models/kali/miscstuff/stalker/detector_veles.mdl")
detector_vel:SetNoDraw(true)

local MAX_DISTANCE = 2500 * 1000

local function DrawDetector(p, detector_vel, pos, ang)
  detector_vel:SetModelScale(0.7, 0)
  ang:RotateAroundAxis(ang:Right(), -90)
  ang:RotateAroundAxis(ang:Forward(), -85)
  ang:RotateAroundAxis(ang:Up(), 270)
  pos = pos + (ang:Forward() * -7.35) + ang:Up() * 7.6 + ang:Right() * -2.3

  detector_vel:SetPos(pos)
  detector_vel:SetAngles(ang)

  detector_vel:SetRenderOrigin(pos)
  detector_vel:SetRenderAngles(ang)
  detector_vel:SetupBones()
  detector_vel:DrawModel()
  detector_vel:SetRenderOrigin()
  detector_vel:SetRenderAngles()
end

-- Создаем ConVar для включения/выключения системы
CreateClientConVar("cl_weaponback", "1", true, false, "Включить отображение оружия за спиной", 0, 1)

hook.Add("PostPlayerDraw", "ModelPaint", function(p)
  if not p:IsValid() or not p:Alive() then return end;

  -- Проверяем настройку клиента
  if not GetConVar("cl_weaponback"):GetBool() then return end

  local localPlayer = localPlayer or LocalPlayer()
  if localPlayer:GetPos():DistToSqr(p:GetPos()) > MAX_DISTANCE then return end

  -- Отрисовка psyHelmet
  if p:GetNetVar("AntiBrain") == true then
    local attach_id = p:LookupBone("ValveBiped.Bip01_Head1")
    if attach_id then
      local pos, ang = p:GetBonePosition(attach_id)

      psyHelmet:SetModelScale(1.1, 0)
      ang:RotateAroundAxis(ang:Up(), 0)
      ang:RotateAroundAxis(ang:Forward(), -90)
      ang:RotateAroundAxis(ang:Right(), -90)
      pos = pos + (ang:Forward() * -1) + ang:Up() * -1 + ang:Right() * 1.5

      psyHelmet:SetPos(pos)
      psyHelmet:SetAngles(ang)

      psyHelmet:SetRenderOrigin(pos)
      psyHelmet:SetRenderAngles(ang)
      psyHelmet:SetupBones()
      psyHelmet:DrawModel()
      psyHelmet:SetRenderOrigin()
      psyHelmet:SetRenderAngles()
    end
  end

  -- Отрисовка оружия
  local c_wpn = p:GetNetVar("c_wpn")
  local m_wpn = p:GetNetVar("m_wpn")

  local active_weapon = p:GetActiveWeapon()
  local class = IsValid(active_weapon) and active_weapon:GetClass() or ""

  if class == "stalker_rpg" and p:HasWeapon("stalker_rpg") and p:HasWeapon("stalker_rg6") then
    ExtraDrawBulldog(p)
  elseif class == "stalker_rg6" and p:HasWeapon("stalker_rg6") and p:HasWeapon("stalker_rpg") then
    ExtraDrawRPG(p)
  elseif class ~= "stalker_rpg" and p:HasWeapon("stalker_rpg") then
    ExtraDrawRPG(p)
  elseif class ~= "stalker_rg6" and p:HasWeapon("stalker_rg6") then
    ExtraDrawBulldog(p)
  end

  if c_wpn and m_wpn and p:HasWeapon(c_wpn) and tableweapons[c_wpn] then
    if not p.mdl then
      p.mdl = ClientsideModel("models/weapons/w_stalker_vss.mdl")
      p.mdl:SetNoDraw(true)
    end

    if not p.mdlrpg then
      p.mdlrpg = ClientsideModel("models/weapons/w_stalker_rpg.mdl")
      p.mdlrpg:SetNoDraw(true)
    end

    if p.mdl:GetModel() ~= m_wpn then p.mdl:SetModel(m_wpn) end
    if c_wpn == "stalker_rpg" then return end

    ExtraDraw(p, c_wpn)
  end

  local c_wpn2 = p:GetNetVar("c_wpn2")
  local m_wpn2 = p:GetNetVar("m_wpn2")

  if c_wpn2 and m_wpn2 and p:HasWeapon(c_wpn2) and tableweapons[c_wpn2] and c_wpn ~= "stalker_rpg" then
    if not p.mdl2 then
      p.mdl2 = ClientsideModel("models/weapons/w_stalker_vss.mdl")
      p.mdl2:SetNoDraw(true)
    end

    if p.mdl2:GetModel() ~= m_wpn2 then p.mdl2:SetModel(m_wpn2) end
    local Paint2 = tableweapons[c_wpn2]
    local pos2, ang2_custom
    if Paint2[4] and Paint2[5] then
      pos2 = Paint2[4]
      ang2_custom = Paint2[5]
    else
      -- Mirror first position for second: flip 180 degrees, shift z by 14 (up)
      pos2 = Vector(Paint2[2][1], Paint2[2][2], Paint2[2][3] + 14)
      ang2_custom = Angle(Paint2[3][1] + 180, Paint2[3][2], Paint2[3][3])
    end
    local infoBone2 = p:LookupBone(Paint2[1])
    if not infoBone2 or infoBone2 <= 0 then return end

    local bonePos2, ang2 = p:GetBonePosition(infoBone2)
    local Right2 = ang2:Right()
    local Up2 = ang2:Up()
    local Forward2 = ang2:Forward()

    ang2:RotateAroundAxis(Right2, ang2_custom[1])
    ang2:RotateAroundAxis(Up2, ang2_custom[2])
    ang2:RotateAroundAxis(Forward2, ang2_custom[3])

    bonePos2 = bonePos2 + pos2[1] * Right2
    bonePos2 = bonePos2 + pos2[2] * Forward2
    bonePos2 = bonePos2 + pos2[3] * Up2

    p.mdl2:SetRenderOrigin(bonePos2)
    p.mdl2:SetRenderAngles(ang2)
    p.mdl2:DrawModel()
    p.mdl2:SetupBones()

    -- Reset bodygroups
    local bgs2 = p.mdl2:GetBodyGroups()
    for i = 1, #bgs2 do
      p.mdl2:SetBodygroup(i-1, 0)
    end

    -- Set attachments
    local attachments2 = p:GetNetVar("Attachments", {})
    if attachments2[c_wpn2] then
      local wep2 = p:GetWeapon(c_wpn2)
      if IsValid(wep2) then
        -- Для FAS2 оружия
        if wep2.AttachmentBGs then
          for att, status in pairs(attachments2[c_wpn2]) do
            if status == 1 and wep2.AttachmentBGs[att] then
              local bgData = wep2.AttachmentBGs[att]
              p.mdl2:SetBodygroup(bgData.bg - 1, bgData.sbg)
            end
          end
        -- Для TFA оружия (базовая поддержка)
        elseif wep2.CustomBodygroups then
          -- Здесь можно добавить логику для TFA аттачментов при необходимости
        end
      end
    end

    -- Масштабирование для TFA оружия
    if c_wpn2:find("tfa_") then
      p.mdl2:SetModelScale(.95)
    end
  end
end)