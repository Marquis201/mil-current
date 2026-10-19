include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")

ENT.TurretBallisticsProjectileVelocity = ENT.ProjectileVelocityArmorPiercing -- default value what the vehicle spawns with
ENT.TurretBallisticsMuzzleAttachment = "muzzle" -- default value what the vehicle spawns with
ENT.TurretBallisticsViewAttachment = "view"

ENT.TurretAimRate = 60

ENT.TurretPodIndex = 2

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"

ENT.TurretPitchPoseParameterName = "pitch"
ENT.TurretPitchMin = -45
ENT.TurretPitchMax = 10
ENT.TurretPitchMul = -1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "yaw"
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0