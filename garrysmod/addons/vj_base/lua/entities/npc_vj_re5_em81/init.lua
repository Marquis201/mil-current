AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2025 by Cpt. Hazama,All rights reserved. ***
	No parts of this code or any of its contents may be reproduced,copied,modified or adapted,
	without the prior written consent of the author,unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/cpthazama/re5/em81.mdl"
ENT.StartHealth = 1500
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.HealthRegenParams = {
	Enabled = true,
	Amount = 1,
	Delay = VJ.SET(0.1,0.1),
	ResetOnDmg = true,
}
ENT.JumpParams = {
	MaxRise = 968,
	MaxDrop = 2560,
	MaxDistance = 1024,
}
ENT.HullType = HULL_HUMAN
ENT.VJ_NPC_Class = {"CLASS_WESKER"}
ENT.InvestigateSoundMultiplier = 18
ENT.PropInteraction_MaxScale = 8

ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "bone5", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(4, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}

ENT.FootData = {
    ["lfoot"] = {Range = 8, OnGround = true},
    ["rfoot"] = {Range = 8, OnGround = true},
}

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = "death"
ENT.DeathCorpseEntityClass = "prop_vj_animatable"

ENT.AnimTbl_MeleeAttack = {
	"attack_kick",
	"attack_kick_combo",
	"attack_kick_high",
	"attack_stomp",
	"attack_sweep",
	"attack_shift",
	"attack_uppercut"
}
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 43
ENT.MeleeAttackBleedEnemy = false
ENT.MeleeAttackBleedEnemyChance = 1
ENT.MeleeAttackBleedEnemyDamage = 1
ENT.MeleeAttackBleedEnemyTime = 0.1
ENT.MeleeAttackBleedEnemyReps = 35

ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_MinDistance = 500

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100
ENT.MainSoundPitch = VJ.SET(100,100)
ENT.FootStepPitch1 = 95
ENT.FootStepPitch2 = 110
ENT.HasExtraMeleeAttackSounds = true

local defExtra = {
	"cpthazama/re5/em81/111.wav",
	"cpthazama/re5/em81/112.wav",
	"cpthazama/re5/em81/120.wav",
	"cpthazama/re5/em81/121.wav",
	"cpthazama/re5/em81/123.wav",
}
local skewerExtra = {
	"cpthazama/re5/em81/118.wav",
	"cpthazama/re5/em81/124.wav",
}

ENT.SoundTbl_MeleeAttackExtra = defExtra

ENT.SoundTbl_Alert = {
	"cpthazama/re5/em81/35.wav",
	"cpthazama/re5/em81/36.wav",
	"cpthazama/re5/em81/37.wav",
	"cpthazama/re5/em81/41.wav",
	"cpthazama/re5/em81/42.wav",
	"cpthazama/re5/em81/43.wav",
	"cpthazama/re5/em81/44.wav",
}
ENT.SoundTbl_CombatIdle = {
	"cpthazama/re5/em81/45.wav",
	"cpthazama/re5/em81/46.wav",
	"cpthazama/re5/em81/50.wav",
	"cpthazama/re5/em81/vo_ignorant.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/re5/em81/47.wav",
	"cpthazama/re5/em81/48.wav",
}
ENT.SoundTbl_LostEnemy = {
	"cpthazama/re5/em81/38.wav",
	"cpthazama/re5/em81/39.wav",
	"cpthazama/re5/em81/40.wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/re5/em81/49.wav",
	"cpthazama/re5/em81/51.wav",
	"cpthazama/re5/em81/56.wav",
	"cpthazama/re5/em81/79.wav",
	"cpthazama/re5/em81/80.wav",
	"cpthazama/re5/em81/81.wav",
}
ENT.SoundTbl_EnterRage = {
	"cpthazama/re5/em81/32.wav",
	"cpthazama/re5/em81/33.wav",
	"cpthazama/re5/em81/34.wav",
	"cpthazama/re5/em81/vo_icantlose.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"cpthazama/re5/em81/57.wav",
	"cpthazama/re5/em81/58.wav",
	"cpthazama/re5/em81/59.wav",
	"cpthazama/re5/em81/60.wav",
	"cpthazama/re5/em81/61.wav",
	"cpthazama/re5/em81/62.wav",
	"cpthazama/re5/em81/63.wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/re5/em81/20.wav",
	"cpthazama/re5/em81/21.wav",
	"cpthazama/re5/em81/22.wav",
	"cpthazama/re5/em81/23.wav",
	"cpthazama/re5/em81/24.wav",
	"cpthazama/re5/em81/25.wav",
	"cpthazama/re5/em81/26.wav",
	"cpthazama/re5/em81/27.wav",
	"cpthazama/re5/em81/52.wav",
	"cpthazama/re5/em81/53.wav",
}
ENT.SoundTbl_PainStagger = {
	"cpthazama/re5/em81/28.wav",
	"cpthazama/re5/em81/29.wav",
	"cpthazama/re5/em81/54.wav",
	"cpthazama/re5/em81/55.wav",
	"cpthazama/re5/em81/82.wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/re5/em81/85.wav",
}
ENT.SoundTbl_Taunt = {
	"cpthazama/re5/em81/43.wav",
	"cpthazama/re5/em81/44.wav",
	"cpthazama/re5/em81/45.wav",
	"cpthazama/re5/em81/46.wav",
	"cpthazama/re5/em81/47.wav",
	"cpthazama/re5/em81/50.wav",
	"cpthazama/re5/em81/vo_seven.wav",
	"cpthazama/re5/em81/vo_precioustime.wav",
	"cpthazama/re5/em81/vo_playtimeover.wav",
	"cpthazama/re5/em81/vo_allyouhave.wav",
}

ENT.HasSoundTrack = true
-- ENT.SoundTbl_SoundTrack = {"cpthazama/re5/wesker_m3.mp3"}

ENT.DamageMultiplier = 1
--
local defMeleeAttacks = ENT.AnimTbl_MeleeAttack
local hitSnds = {
	[1] = "cpthazama/re5/em81/111.wav", -- Kick
	[2] = "cpthazama/re5/em81/112.wav", -- Punch
	[3] = "cpthazama/re5/em81/113.wav", -- Skewer
}
local missSnds = {
	"cpthazama/re5/em81/150.wav",
	"cpthazama/re5/em81/151.wav",
	"cpthazama/re5/em81/155.wav",
	"cpthazama/re5/em81/160.wav",
}
local stepExtraSnds = {
	"cpthazama/re5/em81/175.wav",
	"cpthazama/re5/em81/176.wav",
	"cpthazama/re5/em81/177.wav",
	"cpthazama/re5/em81/178.wav",
	"cpthazama/re5/em81/179.wav",
	"cpthazama/re5/em81/180.wav",
	"cpthazama/re5/em81/181.wav",
	"cpthazama/re5/em81/182.wav",
}
local dodgeSnds = {
	"cpthazama/re5/em81/97.wav",
	"cpthazama/re5/em81/98.wav",
	"cpthazama/re5/em81/99.wav",
	"cpthazama/re5/em81/100.wav",
	"cpthazama/re5/em81/101.wav",
	"cpthazama/re5/em81/102.wav",
	"cpthazama/re5/em81/103.wav",
	"cpthazama/re5/em81/104.wav",
	"cpthazama/re5/em81/105.wav",
}
local coatSnds = {
	"cpthazama/re5/em81/139.wav",
	"cpthazama/re5/em81/140.wav",
	"cpthazama/re5/em81/141.wav",
	"cpthazama/re5/em81/142.wav",
	"cpthazama/re5/em81/143.wav",
}
local coatFastSnds = {
	"cpthazama/re5/em81/136.wav",
	"cpthazama/re5/em81/137.wav",
	"cpthazama/re5/em81/138.wav",
}
// "cpthazama/re5/em81/184.wav" -- Gun Draw
// "cpthazama/re5/em81/168.wav" -- Gun Cock
// "cpthazama/re5/em81/166.wav" -- Gun Fire
// "cpthazama/re5/em81/167.wav" -- Gun Empty
// "cpthazama/re5/em81/185.wav" -- Gun Holster
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetPhysicsDamageScale(0)
	self.DeleteSounds = {}
	self.CurrentAttackSound = nil

	self.PistolIdle = self:GetSequenceActivity(self:LookupSequence("pistol_idle"))
	self.DodgeT = 0
	self.NextPistolFireT = 0
	self.PistolAmmo = 15
	self.InGunState = false
	self.Cont_SprintActive = false
	self.DefaultAttackDistance = 43
	self.MouthT = 0
	self.NextMouthMoveT = 0
	self.HasDoneSpeech = false
	self.SpeechSoundLockT = 0

	self:SetBoss(self.IsBossVersion or false)
	if self.IsBossVersion then
		self:SetBodygroup(self:FindBodygroupByName("glasses"),1)
		self.DefaultAttackDistance = 250
		self:SetMaxHealth(self:Health() *2)
		self:SetHealth(self:GetMaxHealth())
		self.HealthRegenParams.Amount = 5
	end

	if math.random(1,2) == 1 then
		self.CanFakeDeath = false
	end

	if self.OnInit then
		self:OnInit()
	end

	-- print("Before", self:Health(), self.DamageMultiplier)
	self.DisableExplosionStagger = GetConVar("vj_re5_wesker_noexplosionflinch"):GetBool()
	self.DisableDodgeEffects = GetConVar("vj_re5_wesker_nododgeeffects"):GetBool()
	local hpMult = GetConVar("vj_re5_wesker_hpmult"):GetFloat()
	if hpMult > 1 then
		self:SetHealth(self:Health() *hpMult)
		self:SetMaxHealth(self:Health())
	end
	local dmgMult = GetConVar("vj_re5_wesker_dmgmult"):GetFloat()
	if dmgMult > 1 then
		self.DamageMultiplier = self.DamageMultiplier *dmgMult
	end
	-- print("After", self:Health(), self.DamageMultiplier)

    for attName, var in pairs(self.FootData) do
        var.AttID = self:LookupAttachment(attName)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local knockbackValues = {
	["attack_kickheavy"] = function(self)
		return self:GetForward() *400 +self:GetUp() *200
	end,
	["attack_shift"] = function(self)
		return self:GetForward() *700 +self:GetUp() *200
	end,
	["attack_thrust"] = function(self)
		return self:GetForward() *900 +self:GetUp() *250
	end,
	["attack_parry"] = function(self)
		return self:GetForward() *900 +self:GetUp() *250
	end,
	["attack_sweep"] = function(self)
		return self:GetForward() *75 +self:GetUp() *275
	end,
	["attack_punchheavy"] = function(self)
		return self:GetForward() *500 +self:GetUp() *200
	end,
	["attack_uppercut"] = function(self)
		return self:GetForward() *10 +self:GetUp() *300
	end,
}
--
function ENT:MeleeAttackKnockbackVelocity(ent)
	-- if self.MeleeAttackKnockbackType == "attack_parry" then
	-- 	ParticleEffectAttach("vj_re5_wesker_zip",PATTACH_POINT_FOLLOW,ent,0)
	-- end
	return knockbackValues[self.MeleeAttackKnockbackType] && knockbackValues[self.MeleeAttackKnockbackType](self) or vector_origin
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	if status == "PreDamage" then
		ParticleEffect("vj_re5_wesker_hit", ent:NearestPoint(self:GetPos() +self:OBBCenter()), Angle())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key)
	-- print("Input: ",key)
	self.MeleeAttackKnockbackType = key
	local dmgMult = (((self.SprintT or 0) > CurTime() && 1.65 or 1) *(self:GetBoss() && 2 or 1)) *self.DamageMultiplier
	if key == "attack_kick" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 40 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = false
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_kickheavy" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 80 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_thrust" then
		VJ.EmitSound(self,VJ.PICK(coatFastSnds),75)
		self.MeleeAttackDamage = 110 *dmgMult
		self.MeleeAttackDamageType = bit.bor(DMG_CLUB,DMG_BLAST)
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = {"cpthazama/re5/em81/122.wav"}
		self:ExecuteMeleeAttack()
	elseif key == "attack_parry" then
		VJ.EmitSound(self,VJ.PICK(coatFastSnds),75)
		self.MeleeAttackDamage = 110 *dmgMult
		self.MeleeAttackDamageType = bit.bor(DMG_CLUB,DMG_BLAST)
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = {"cpthazama/re5/em81/122.wav"}
		self:ExecuteMeleeAttack()
	elseif key == "attack_stomp" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 50 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = false
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_sweep" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 30 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_punch" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 50 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = false
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_punchheavy" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 100 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = {"cpthazama/re5/em81/115.wav"}
		self:ExecuteMeleeAttack()
	elseif key == "attack_uppercut" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 75 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackBleedEnemy = false
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_skewer_appear" then
		local ent = self:GetEnemy()
		local cont = self.VJ_TheController
		ParticleEffectAttach("vj_re5_wesker_zip",PATTACH_POINT_FOLLOW,self,0)
		VJ.EmitSound(self,VJ.PICK(dodgeSnds),75,self:GetSoundPitch(self.GeneralSoundPitch))
		self.NoDrawT = CurTime() +0.05
		self:SetNoDraw(true)
		if IsValid(ent) then
			if IsValid(cont) then
				local startPos = self:GetPos() +self:OBBCenter()
				local tr = util.TraceHull({
					start = startPos,
					endpos = startPos +((ent:GetPos() +ent:OBBCenter()) -startPos):GetNormalized() *1200,
					filter = {self,ent},
					mins = Vector(-10,-10,-10),
					maxs = Vector(10,10,10),
					mask = MASK_NPCSOLID,
				})
				local hitPos = tr.HitPos +tr.HitNormal *16
				local downTr = util.TraceHull({
					start = hitPos,
					endpos = hitPos -Vector(0,0,32000),
					filter = self,
					mins = Vector(-10,-10,-10),
					maxs = Vector(10,10,10),
					mask = MASK_SOLID_BRUSHONLY,
				})
				local pos = downTr.HitPos +downTr.HitNormal *16
				for _,v in pairs(ents.FindInSphere(downTr.HitPos, 100)) do
					if (v:IsNPC() or v:IsPlayer() or v:IsNextBot()) && v != self && self:CheckRelationship(v) == VJ_RELATIONSHIP_NEUTRAL then
						pos = pos +((v:GetPos() +v:OBBCenter()) -pos):GetNormalized() *50
						break
					end
				end
				self:SetClearPos(pos)
			else
				local tr = util.TraceHull({
					start = ent:GetPos() +self:OBBCenter(),
					endpos = (ent:GetPos() +self:OBBCenter()) +ent:GetForward() *(ent:OBBMaxs().x +self:OBBMins().x),
					filter = {self,ent},
					mins = Vector(-10,-10,-10),
					maxs = Vector(10,10,10),
					mask = MASK_SOLID_BRUSHONLY,
				})
				if tr.Hit then
					self:SetClearPos(tr.HitPos)
				else
					self:SetClearPos(ent:GetPos() +ent:GetForward() *(ent:OBBMaxs().x +self:OBBMins().x))
				end
				self:SetAngles(Angle(0,(ent:GetPos() -self:GetPos()):Angle().y,0))
			end
		end
	elseif key == "attack_skewer" then
		VJ.EmitSound(self,VJ.PICK(coatFastSnds),75)
		self.MeleeAttackDamage = 150 *dmgMult
		self.MeleeAttackDamageType = DMG_SLASH
		self.HasMeleeAttackKnockBack = false
		self.MeleeAttackBleedEnemy = true
		self.SoundTbl_MeleeAttackExtra = skewerExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_parry_fx" then
		if self.DisableDodgeEffects != true then
			ParticleEffectAttach("vj_re5_wesker_zip",PATTACH_POINT_FOLLOW,self,0)
		end
		VJ.EmitSound(self,VJ.PICK(dodgeSnds),75,self:GetSoundPitch(self.GeneralSoundPitch))
		self.NoDrawT = CurTime() +0.05
		self:SetNoDraw(true)
	elseif key == "knife_draw" then
		VJ.EmitSound(self,"cpthazama/re5/em81/149.wav",75)
	elseif key == "knife_attack" then
		local proj = ents.Create("obj_vj_projectile_base")
		proj.Model = "models/weapons/w_knife_ct.mdl"
		proj:SetPos(self:GetAttachment(self:LookupAttachment("grab")).Pos)
		proj:SetAngles(self:GetAngles())
		proj.DoesDirectDamage = true
		proj.DirectDamage = 35
		proj.SoundTbl_Startup = {"cpthazama/re5/em81/183.wav"}
		proj.SoundTbl_OnCollide = {"cpthazama/re5/em81/119.wav"}
		proj:Spawn()
		proj:Activate()

		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self,self:GetEnemy(),"Line",proj:GetPos(),0.975,5000))
		end
	elseif key == "pistol_draw" then
		VJ.EmitSound(self,"cpthazama/re5/em81/184.wav",75)
		self:SetBodygroup(self:FindBodygroupByName("weapon"),1)
	elseif key == "pistol_cock" then
		VJ.EmitSound(self,"cpthazama/re5/em81/168.wav",75)
	elseif key == "pistol_holster" then
		VJ.EmitSound(self,"cpthazama/re5/em81/185.wav",75)
		self:SetBodygroup(self:FindBodygroupByName("weapon"),0)
	elseif key == "rocket_grab" then
		-- SafeRemoveEntity(self.ParryRocketEntity)
		-- local att = self:GetAttachment(self:LookupAttachment("grab"))
		-- local pos,ang = att.Pos,att.Ang
		-- local fakeRocket = ents.Create("prop_physics")
		-- fakeRocket:SetModel("models/weapons/w_missile_closed.mdl")
		-- fakeRocket:SetPos(pos)
		-- fakeRocket:SetAngles(ang)
		-- fakeRocket:Spawn()
		-- fakeRocket:SetParent(self,self:LookupAttachment("grab"))
		-- fakeRocket:AddEffects(EF_PARENT_ANIMATES)
		-- fakeRocket:SetMoveType(MOVETYPE_NONE)
		-- ParticleEffectAttach("vj_rocket_idle1", PATTACH_ABSORIGIN_FOLLOW, fakeRocket, 0)
		-- fakeRocket.Alive = true
		-- fakeRocket.LoopSound = CreateSound(fakeRocket,"weapons/rpg/rocket1.wav")
		-- fakeRocket.LoopSound:SetSoundLevel(80)
		-- fakeRocket.LoopSound:Play()
		-- hook.Add("EntityRemoved", fakeRocket, function(fakeRocket,ent)
		-- 	if ent != fakeRocket then return end
		-- 	fakeRocket.LoopSound:Stop()
		-- end)
		-- self:DeleteOnRemove(fakeRocket)
		-- self.ParryRocketEntity = fakeRocket
	elseif key == "rocket_stop" then
		if IsValid(self.ParryRocketEntity) then
			self.ParryRocketEntity.Alive = false
			VJ.EmitSound(self.ParryRocketEntity,"ambient/fire/mtov_flame2.wav",75)
			self.ParryRocketEntity:StopParticles()
			self.ParryRocketEntity.LoopSound:Stop()
		end
	elseif key == "rocket_toss" then
		SafeRemoveEntity(self.ParryRocketEntity)
		local att = self:GetAttachment(self:LookupAttachment("grab"))
		local pos,ang = att.Pos,att.Ang
		local fakeRocket = ents.Create("prop_physics")
		fakeRocket:SetModel("models/weapons/w_missile_closed.mdl")
		fakeRocket:SetPos(pos)
		fakeRocket:SetAngles(ang)
		fakeRocket:Spawn()
		SafeRemoveEntityDelayed(fakeRocket,10)
		local phys = fakeRocket:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(self:GetForward() *-1000 +self:GetUp() *200)
			phys:AddAngleVelocity(VectorRand() *500)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- if act == ACT_IDLE && self.InGunState then
	if act == ACT_IDLE && self.StartedFakeDeath then
		return ACT_VM_IDLE
	end
	if self.InGunState then
		if (act == ACT_WALK or act == ACT_RUN) then
			return ACT_RUN_STIMULATED
		elseif act == ACT_IDLE then
			return self.PistolIdle
		end
	end
	if IsValid(self.VJ_TheController) then
		local ply = self.VJ_TheController
		if act == ACT_IDLE && ply:KeyDown(IN_SPEED) then
			return ACT_SPRINT
		end
		if (act == ACT_WALK or act == ACT_RUN) then
			return ACT_RUN
			-- return ply:KeyDown(IN_SPEED) && ACT_SPRINT or ACT_RUN
		end
	else
		if (act == ACT_WALK or act == ACT_RUN) && (self.SprintT or 0) >= CurTime() then
			return ACT_SPRINT
		end
	end
	return baseclass.Get("npc_vj_creature_base").TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySound(sndTbl,level,pitch,setCurSnd)
	if !sndTbl or istable(sndTbl) && #sndTbl <= 0 then return 0 end
	if CurTime() < (self.SpeechSoundLockT or 0) then return 0 end
	local setCurSnd = setCurSnd or true
	if setCurSnd then
		self:StopAllSounds()
		if self.CurrentAttackSound then
			self.CurrentAttackSound:Stop()
		end
	end
	local sndName = VJ_PICK(sndTbl)
	local snd = VJ.CreateSound(self,sndName,level or 75,pitch or 100)
	if setCurSnd then
		self.CurrentAttackSound = snd
	end
	table.insert(self.DeleteSounds,snd)
	return SoundDuration(sndName)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply,controlEnt)
	controlEnt.VJC_Player_DrawHUD = false
	controlEnt.VJC_NPC_CanTurn = false
	controlEnt.VJC_Player_CanChatMessage = false
	self.JumpParams.Enabled = false

	ply:ChatPrint("Wesker Controls:")
	ply:ChatPrint("Press [LEFT-MOUSE] to attack / fire pistol")
	ply:ChatPrint("Hold [RIGHT-MOUSE] to toggle between melee and pistol")
	ply:ChatPrint("Press [E + LEFT-MOUSE] to use skewer attack")
	ply:ChatPrint("Press [E + L-ALT] to throw knife")
	ply:ChatPrint("Press [R] to taunt")
	ply:ChatPrint("Hold [SPACE] to dodge / parry")
	if self.AdditionalControllerInstructions then
		for _,v in ipairs(self.AdditionalControllerInstructions) do
			ply:ChatPrint(v)
		end
	end

	function controlEnt:OnThink()
		self.VJC_NPC_CanTurn = self.VJC_Camera_Mode == 2
		self.VJC_BullseyeTracking = self.VJCE_NPC:IsMoving() or self.VJC_Camera_Mode == 2
		self.VJCE_NPC:SetHP(self.VJCE_NPC:Health())
		self.VJCE_NPC:SetClip(self.VJCE_NPC.PistolAmmo)
	end

	hook.Add("PlayerButtonDown", self, function(self, ply, button)
		local cent = ply.VJ_TheControllerEntity
		if ply.VJ_IsControllingNPC == true && IsValid(cent) && IsValid(cent.VJCE_NPC) && cent.VJCE_NPC == self then
			self:OnKeyPressed(button,ply)
		end
	end)

	function controlEnt:CustomOnStopControlling()
		local valid = IsValid(npc)
		if valid then
			npc:SetStepHeight(18)
			npc.JumpParams.Enabled = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Movement(cont, ply, bullseyePos)
	if ply:KeyDown(IN_SPEED) then
		if self:IsMoving() then
			self:StopMoving()
		end
		self:FaceCertainPosition(bullseyePos, 0.2)
		self:SetStepHeight(26)
		-- if ply:KeyDown(IN_MOVELEFT) then
		-- 	self:SetAngles(Angle(0,(self:GetAngles().y -5) %360,0))
		-- elseif ply:KeyDown(IN_MOVERIGHT) then
		-- 	self:SetAngles(Angle(0,(self:GetAngles().y +5) %360,0))
		-- end
		return
	end
	self:SetStepHeight(18)
	baseclass.Get("npc_vj_creature_base").Controller_Movement(self, cont, ply, bullseyePos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKeyPressed(key,ply)
	local curTime = CurTime()
	local ent = self:GetEnemy()

	if key == KEY_R then
		self:Taunt()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Taunt()
	if self:IsBusy("Activities") or CurTime() < (self.NextTauntT or 0) then return end
	local _,dur = self:PlayAnim("taunt" .. math.random(1,4),true,false,false)
	self:PlaySound(self.SoundTbl_Taunt,75,nil,true)
	self.NextTauntT = CurTime() +dur
	for _,v in pairs(ents.FindInSphere(self:GetPos(), 1000)) do
		if (v:IsNPC() && v != self) && v.VJ_IsWesker && self:CheckRelationship(v) == D_HT then
			v:SetEnemy(self)
			v:Taunt()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ToggleGunState()
	local oldState = self.InGunState
	self.InGunState = !self.InGunState
	if oldState == false then
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		local _,dur = self:PlayAnim("pistol_draw",true,false,true,0,{OnFinish=function()
			self:SetState()
		end})
		self.NextPistolFireT = CurTime() +dur
		self.PistolAmmo = 15
	else
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		self:PlayAnim("pistol_holster",true,false,true,0,{OnFinish=function()
			self:SetState()
		end})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
	if status == "Init" then
		self.SprintT = 0
		self:SetBodygroup(self:FindBodygroupByName("weapon"),0)
		if self:GetBoss() then
			local data = self.EnemyData
			local visible = data.Visible
			local dist = data.DistanceNearest
			local movePos = self:GetPos()
			local doFX = false
			if dist > 900 then
				local tr = util.TraceHull({
					start = movePos +self:OBBCenter(),
					endpos = movePos +self:GetForward() *900,
					filter = self,
					mins = Vector(-10,-10,-10),
					maxs = Vector(10,10,10),
				})
				if tr.Hit then
					movePos = tr.HitPos +tr.HitNormal *16
				end
				doFX = true
			else
				if visible then
					if IsValid(cont) then
						local startPos = self:GetPos() +self:OBBCenter()
						local tr = util.TraceHull({
							start = startPos,
							endpos = startPos +((ent:GetPos() +ent:OBBCenter()) -startPos):GetNormalized() *1200,
							filter = {self,ent},
							mins = Vector(-10,-10,-10),
							maxs = Vector(10,10,10),
							mask = MASK_NPCSOLID,
						})
						local hitPos = tr.HitPos +tr.HitNormal *16
						local downTr = util.TraceHull({
							start = hitPos,
							endpos = hitPos -Vector(0,0,32000),
							filter = self,
							mins = Vector(-10,-10,-10),
							maxs = Vector(10,10,10),
							mask = MASK_SOLID_BRUSHONLY,
						})
						local pos = downTr.HitPos +downTr.HitNormal *16
						for _,v in pairs(ents.FindInSphere(downTr.HitPos, 100)) do
							if (v:IsNPC() or v:IsPlayer() or v:IsNextBot()) && v != self && self:CheckRelationship(v) == VJ_RELATIONSHIP_NEUTRAL then
								pos = pos +((v:GetPos() +v:OBBCenter()) -pos):GetNormalized() *50
								break
							end
						end
						movePos = pos
					else
						local dir = (enemy:GetPos() +enemy:OBBCenter()) -movePos
						dir.z = 0
						dir:Normalize()
						local tr = util.TraceHull({
							start = enemy:GetPos() +enemy:OBBCenter(),
							endpos = enemy:GetPos() -(dir *100),
							filter = self,
							mins = Vector(-10,-10,-10),
							maxs = Vector(10,10,10),
						})
						if tr.Hit then
							movePos = tr.HitPos +tr.HitNormal *16
						else
							movePos = enemy:GetPos() -(dir *100)
						end
						doFX = true
					end
				end
			end
			if doFX then
				self.DodgeT = CurTime() +0.25
				self:PlaySound(self.SoundTbl_Dodge,75,nil,true)
				ParticleEffectAttach("vj_re5_wesker_zip",PATTACH_POINT_FOLLOW,self,0)
				VJ.EmitSound(self,VJ.PICK(dodgeSnds),75,self:GetSoundPitch(self.GeneralSoundPitch))
				self.NoDrawT = CurTime() +0.05
				self:SetNoDraw(true)
				self:SetClearPos(movePos)
				self:SetAngles(Angle(0,(enemy:GetPos() -self:GetPos()):Angle().y,0))
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if !self.HasDoneSpeech && math.random(1,4) == 1 then
		timer.Simple(0.01,function()
			if IsValid(self) then
				self:StopAllSounds()
				if self.CurrentAttackSound then
					self.CurrentAttackSound:Stop()
				end
				self:PlaySound("cpthazama/re5/em81/vo_speech.wav",80,nil,true)
				self.SpeechSoundLockT = CurTime() +SoundDuration("cpthazama/re5/em81/vo_speech.wav")
				self.IdleSoundBlockTime = self.SpeechSoundLockT
				self.MouthT = self.SpeechSoundLockT
				self.NextMouthMoveT = 0
				self.HasDoneSpeech = true
			end
		end)
		return
	end
	if math.random(1,2) == 1 && !IsValid(self.VJ_TheController) then
		self:Taunt()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnResetEnemy()
	if self.InGunState && !IsValid(cont) then
		self:ToggleGunState()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(isAttacking, ent)
	local data = self.EnemyData
	local visible = data.Visible
	local dist = data.DistanceNearest
	local curTime = CurTime()
	local cont = self.VJ_TheController

	if self.InGunState then
		if IsValid(cont) && !cont:KeyDown(IN_ATTACK2) or !IsValid(cont) && (dist > 1250 or !visible) then
			self:ToggleGunState()
			return
		end
		self:FaceCertainEntity(ent, 0.2)
		if IsValid(cont) && cont:KeyDown(IN_ATTACK) or !IsValid(cont) && dist <= 1250 && visible then
			if self.NextPistolFireT < curTime && !self:IsBusy("Activities") then
				self:SetBodygroup(self:FindBodygroupByName("weapon"),1)
				self.PistolAmmo = self.PistolAmmo -1
				local _,dur
				if self:IsMoving() then
					_,dur = self:PlayAnim("pistol_fire_additive",false,false,false,0,{AlwaysUseGesture=true})
					self.NextPistolFireT = curTime +0.48
				else
					_,dur = self:PlayAnim("pistol_fire",true,false,true)
					self.NextPistolFireT = curTime +0.25
				end
				local bullet = {}
				bullet.Num = 1
				bullet.Src = self:GetAttachment(1).Pos
				bullet.Dir = ((ent:EyePos() -Vector(0,0,ent:OBBCenter().z *0.2)) -self:GetAttachment(1).Pos):GetNormalized()
				bullet.Spread = Vector(0.02,0.02,0)
				bullet.Tracer = 1
				bullet.Force = 5
				bullet.Damage = 20
				bullet.AmmoType = "Pistol"
				self:FireBullets(bullet)
				ParticleEffect("vj_rifle_full",self:GetAttachment(1).Pos,Angle())
				VJ.EmitSound(self,"cpthazama/re5/em81/166.wav",95,self:GetSoundPitch(self.GeneralSoundPitch))
				if self.PistolAmmo <= 0 then
					self.NextPistolFireT = curTime +1
					timer.Simple(dur *0.3,function()
						if IsValid(self) then
							self:ToggleGunState()
						end
					end)
				end
			end
		end
		return
	else
		if IsValid(cont) && cont:KeyDown(IN_ATTACK2) then
			self:ToggleGunState()
			return
		end
	end

	if (IsValid(cont) && cont:KeyDown(IN_JUMP) or !IsValid(cont)) && !IsValid(self.ParryRocketEntity) && !self:IsBusy("Activities") && curTime > (self.NextRocketParryCheckT or 0) then
		self.NextRocketParryCheckT = curTime +(IsValid(cont) && 0.1 or 0.15)
		-- print("Checking for rockets to parry")
		for _,v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
			if v:GetClass() == "rpg_missile" or v:GetClass() == "obj_vj_rocket" then
				-- self.ParryRocketEntity = v
				-- v:SetLocalVelocity(vector_origin)
				-- v:SetVelocity(vector_origin)
				-- local phys = v:GetPhysicsObject()
				-- if IsValid(phys) then
				-- 	phys:Sleep()
				-- 	phys:SetVelocity(vector_origin)
				-- end
				-- print("Parrying rocket: ", v)
				v:Remove()
				ParticleEffectAttach("vj_re5_wesker_zip",PATTACH_POINT_FOLLOW,self,0)
				VJ.EmitSound(self,VJ.PICK(dodgeSnds),75,self:GetSoundPitch(self.GeneralSoundPitch))
				self.NoDrawT = CurTime() +0.05
				self:SetNoDraw(true)
				self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
				local _,dur = self:PlayAnim("parry_rocket",true,false,false,0,{OnFinish=function()
					self:SetState()
				end})
				local att = self:GetAttachment(self:LookupAttachment("grab"))
				local pos,ang = att.Pos,att.Ang
				local fakeRocket = ents.Create("prop_physics")
				fakeRocket:SetModel("models/weapons/w_missile_closed.mdl")
				fakeRocket:SetPos(pos)
				fakeRocket:SetAngles(ang)
				fakeRocket:Spawn()
				fakeRocket:SetParent(self,self:LookupAttachment("grab"))
				fakeRocket:AddEffects(EF_PARENT_ANIMATES)
				fakeRocket:SetMoveType(MOVETYPE_NONE)
				ParticleEffectAttach("vj_rocket_idle1", PATTACH_ABSORIGIN_FOLLOW, fakeRocket, 0)
				fakeRocket.Alive = true
				fakeRocket.LoopSound = CreateSound(fakeRocket,"weapons/rpg/rocket1.wav")
				fakeRocket.LoopSound:SetSoundLevel(80)
				fakeRocket.LoopSound:Play()
				hook.Add("EntityRemoved", fakeRocket, function(fakeRocket,ent)
					if ent != fakeRocket then return end
					fakeRocket.LoopSound:Stop()
				end)
				self:DeleteOnRemove(fakeRocket)
				self.ParryRocketEntity = fakeRocket
				self.NextRocketParryCheckT = curTime +dur +0.15
				break
			end
		end
	end

	if (!IsValid(cont) && dist > 300 && dist <= 1000 && math.random(1,100) == 1 or IsValid(cont) && cont:KeyDown(IN_WALK) && cont:KeyDown(IN_USE)) && !self:IsBusy("Activities") && curTime > (self.NextKnifeAttackT or 0) then
		local _,dur = self:PlayAnim("attack_knife",true,false,true)
		self.NextKnifeAttackT = CurTime() +dur +(IsValid(cont) && 1 or math.random(4,6))
	end

	if !IsValid(cont) && dist > 1000 && dist <= 2000 && math.random(1,100) == 1 then
		if math.random(1,3) == 1 then
			self.AnimTbl_MeleeAttack = "attack_skewer"
			self.MeleeAttackDistance = 2000
		else
			self.AnimTbl_MeleeAttack = defMeleeAttacks
			self.MeleeAttackDistance = self.DefaultAttackDistance
		end
		if (self.SprintT or 0) < curTime then
			local _,dur = self:PlayAnim("idle_to_sprint",true,false,true)
			self:PlaySound(self.SoundTbl_EnterRage,80,nil,true)
			self.SprintT = curTime +dur +math.random(4,6)
		end
	else
		if IsValid(cont) && cont:KeyDown(IN_USE) then
			self.AnimTbl_MeleeAttack = "attack_skewer"
		else
			self.AnimTbl_MeleeAttack = self:GetSequenceName(self:GetSequence()) == "parry" && "parry_attack" or defMeleeAttacks
		end
		self.MeleeAttackDistance = self.DefaultAttackDistance
		if !IsValid(cont) && dist <= 1250 && dist > 450 && visible && math.random(1,100) == 1 && !self.InGunState then
			self:ToggleGunState()
		end
	end

	if !IsValid(cont) && (self.SprintT or 0) > curTime && self:IsMoving() or IsValid(cont) && cont:KeyDown(IN_SPEED) then
		self.AnimTbl_MeleeAttack = "attack_sprint"
		self.MeleeAttackDistance = 50
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.FootData then
		local checkPos = self:GetPos()
		for attName, var in pairs(self.FootData) do
			if !var.AttID then continue end
	
			local footPos = self:GetAttachment(var.AttID).Pos
			checkPos.x = footPos.x
			checkPos.y = footPos.y	
			if ((footPos -checkPos):LengthSqr()) > (var.Range *var.Range) then
				var.OnGround = false
			elseif !var.OnGround then
				var.OnGround = true
				self:FootStep(footPos, attName)
			end
		end
	end

	if self.Dead then self:SetAfterimage(false) return end
	local curTime = CurTime()
	local ent = self:GetEnemy() or self.VJ_TheControllerBullseye
	local cont = self.VJ_TheController
	local inSprint = self:GetSequenceActivity(self:GetIdealSequence()) == ACT_SPRINT

	self.HasMeleeAttack = !self.InGunState
	self.DisableChasingEnemy = self.InGunState
	if self:GetNoDraw() then
		self:AddFlags(FL_NOTARGET)
	end
	if curTime > (self.NoDrawT or 0) && self:GetNoDraw() then
		self:SetNoDraw(false)
		self:RemoveFlags(FL_NOTARGET)
	end
	if inSprint then
		self:SetMoveVelocity(self:GetMoveVelocity() *2)
		self:SetArrivalSpeed(9999)
	end
	self:SetAfterimage(inSprint or self.DodgeT > curTime)
	if (self.SpeechSoundLockT > curTime or self.MouthT > curTime) && self.NextMouthMoveT < curTime then
		local _,dur = self:VJ_ACT_PLAYACTIVITY("vjges_talk",false,false,false,0,{AlwaysUseGesture=true})
		local alt = math.Rand(0.3,1)
		if curTime -self.MouthT <= dur then
			alt = 1
		end
		self.NextMouthMoveT = curTime +(dur *alt)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	local dmg = dmginfo:GetDamage()
	local nextHP = self:Health() -dmg
	if nextHP <= 0 && self.CanFakeDeath != false then
		dmginfo:SetDamage(0)
		self:SetHealth(1)
		if !self.StartedFakeDeath then
			self.StartedFakeDeath = true
			self:ResetAI()
			self.EnemyDetection = false
			self.EnemyTouchDetection = false
			self:SetEnemy(nil)
			self:ClearEnemyMemory()
			self:CapabilitiesRemove(bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP))
			self:AddFlags(FL_NOTARGET)
			self:SetMaxYawSpeed(0)
			gamemode.Call("OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor())
			self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
			self:PlaySound("cpthazama/re5/em81/85.wav",80,nil,true)
			self:PlayAnim("death",true,false,false,0,{OnFinish=function()
				timer.Simple(5,function()
					if !IsValid(self) then return end
					self.HasSounds = true
					self:PlaySound("cpthazama/re5/em81/vo_icantlose.wav",80,nil,true)
					self:PlayAnim("recover_front",true,false,false,0,{OnFinish=function()
						self:SetState()
						self:RemoveFlags(FL_NOTARGET)
						self:SetMaxYawSpeed(self.TurningSpeed)
						self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP))
						self.StartedFakeDeath = false
						self.CanFakeDeath = false
						self.EnemyDetection = true
						self.EnemyTouchDetection = true
						self:SetHealth(self:GetMaxHealth() *0.5)
					end})
				end)
			end})
			self.HasSounds = false
		end
		return
	end
	if dmg <= 0 then return end
	local dmgtype = dmginfo:GetDamageType()
	local isBullet = bit.band(dmgtype, DMG_BULLET) == DMG_BULLET
	local isMelee = (bit.band(dmgtype, DMG_CLUB) == DMG_CLUB or bit.band(dmgtype, DMG_SLASH) == DMG_SLASH) && self:GetSequenceName(self:GetSequence()) != "attack_parry"
	local isExplosion = bit.band(dmgtype, DMG_BLAST) == DMG_BLAST

	if isBullet && self:GetSequenceName(self:GetSequence()) == "flinch_explosion" && !IsValid(self.VJ_TheController) && IsValid(self:GetEnemy()) then
		self:ResetAI()
		self:SetEnemy(dmginfo:GetAttacker() or self:GetEnemy())
		self.SprintT = CurTime() +math.random(4,6)
		self:PlaySound(self.SoundTbl_EnterRage,80,nil,true)
		return
	end

	if !IsValid(self.ParryRocketEntity) && (isBullet or isMelee) && !isExplosion && self.AttackState <= VJ.ATTACK_STATE_STARTED && (self.SprintT or 0) < CurTime() then
		if IsValid(self.VJ_TheController) && !self.VJ_TheController:KeyDown(IN_JUMP) then return end
		dmginfo:SetDamage(0)
		self:FaceCertainEntity(dmginfo:GetAttacker(), 0.2)
		self:DoDodge(isMelee,dmginfo)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDodge(doParry,dmginfo)
	self:StopMoving()
	local cont = IsValid(self.VJ_TheController)
	local goBehind = math.random(1,8) == (cont && 0 or 1)
	local doGun = !self.InGunState && math.random(1,3) == 1
	if !goBehind && doParry then
		local _,dur = self:PlayAnim("parry",true,false,true,0,{OnFinish=function()
			self:SetState()
		end})
		timer.Simple(0,function()
			if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "parry" then
				self:SetLocalVelocity(Vector())
				self:SetVelocity(Vector())
			end
		end)
		if math.random(1,cont && 1 or 2) == 1 then
			timer.Simple(dur *0.35,function()
				if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "parry" then
					self:ResetAI()
					-- if !cont && math.random(1,3) == 1 && IsValid(self:GetEnemy()) then
					-- 	self.SprintT = CurTime() +math.random(4,6)
					-- end
					self.AnimTbl_MeleeAttack = "attack_parry"
					self.MeleeAttackDistance = self.DefaultAttackDistance *2
				end
			end)
		end
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK,dur)
		if self.DisableDodgeEffects != true then
			ParticleEffectAttach("vj_re5_wesker_zip",PATTACH_POINT_FOLLOW,self,0)
		end
		VJ.EmitSound(self,VJ.PICK(dodgeSnds),75,self:GetSoundPitch(self.GeneralSoundPitch))
		self.NoDrawT = CurTime() +0.05
		self:SetNoDraw(true)
		return
	end
	self:ResetAI()
	local anim = VJ.PICK({"dodge_c_f","dodge_l_f","dodge_r_f","dodge_proj_f_l","dodge_proj_f_r"})
	local _,dur = self:PlayAnim(anim,true,false,true,0,{OnFinish=function(interrupted)
		if interrupted then return end
		-- self:SetState()
		self:ResetAI()
		-- if IsValid(self:GetEnemy()) then
		-- 	self:SCHEDULE_ALERT_CHASE(true)
		-- else
		-- 	self:SCHEDULE_IDLE_STAND()
		-- end
		if !goBehind && !IsValid(self.VJ_TheController) then
			if math.random(1,50) == 1 then
				self:Taunt()
			elseif math.random(1,12) == 1 && IsValid(self:GetEnemy()) then
				self.SprintT = CurTime() +math.random(4,6)		
			end
		end
	end})
	self.DodgeT = CurTime() +(dur *0.35)
	self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK,dur)
	self:PlaySound(self.SoundTbl_Dodge,75,nil,true)
	if self.DisableDodgeEffects != true then
		ParticleEffectAttach("vj_re5_wesker_zip",PATTACH_POINT_FOLLOW,self,0)
	end
	VJ.EmitSound(self,VJ.PICK(dodgeSnds),75,self:GetSoundPitch(self.GeneralSoundPitch))
	self.NoDrawT = CurTime() +0.05
	self:SetNoDraw(true)
	local attacker = dmginfo:GetAttacker()
	if IsValid(attacker) && attacker.GetEnemy && attacker:GetEnemy() == self && attacker.IgnoreEnemyUntil then
		attacker:SetEnemy(nil)
		attacker:IgnoreEnemyUntil(self, CurTime() +0.075)
	end
	if math.random(1,3) == 1 then
		local movePos = self:GetPos()
		local startPos = self:GetPos() +self:OBBCenter()
		local mins, maxs = self:GetCollisionBounds()
		local tr
		local moveDir
		if !cont && goBehind && IsValid(attacker) then
			local att = attacker
			moveDir = att:GetForward() *-100
			tr = util.TraceHull({
				start = att:GetPos() +att:OBBCenter(),
				endpos = att:GetPos() +att:OBBCenter() +moveDir,
				filter = {self,att},
				mins = mins,
				maxs = maxs,
				mask = MASK_NPCSOLID,
			})
			if tr.Hit then
				movePos = tr.HitPos +tr.HitNormal *24
			else
				movePos = att:GetPos() +moveDir
			end
		else
			moveDir = ((anim == "dodge_c_f" && self:GetForward() *75) or ((anim == "dodge_l_f" or anim == "dodge_proj_f_l") && self:GetRight() *-150 or self:GetRight() *150))
			tr = util.TraceHull({
				start = startPos,
				endpos = startPos +moveDir,
				filter = self,
				mins = mins,
				maxs = maxs,
				mask = MASK_NPCSOLID,
			})
			if tr.Hit then
				movePos = tr.HitPos +tr.HitNormal *24
			else
				movePos = self:GetPos() +moveDir
			end
		end
		local check = util.TraceHull({
			start = movePos +Vector(0,0,16),
			endpos = movePos +Vector(0,0,16),
			filter = self,
			mins = mins,
			maxs = maxs,
			mask = MASK_NPCSOLID,
		})
		local checkForSkybox = util.TraceHull({
			start = movePos,
			endpos = movePos -Vector(0,0,500),
			filter = self,
			mins = mins,
			maxs = maxs,
			mask = MASK_NPCSOLID,
		})
		if (!util.IsInWorld(movePos) or check.Hit) or checkForSkybox.HitSky then
			movePos = self:GetPos()
		end
		self:SetClearPos(movePos)
	end
	if goBehind then
		self:SetAngles(Angle(0,(dmginfo:GetAttacker():GetPos() -self:GetPos()):Angle().y,0))
		if doGun then
			timer.Simple(dur *0.2,function()
				if IsValid(self) then
					self:ToggleGunState()
				end
			end)
		end
	else
		if !cont && math.random(1,6) == 1 && IsValid(self:GetEnemy()) then
			self.SprintT = CurTime() +dur +math.random(4,6)
			self:PlaySound(self.SoundTbl_EnterRage,80,nil,true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local hitgroupAnims = {
	[HITGROUP_HEAD] = "flinch_head1",
	[HITGROUP_CHEST] = {"flinch_chest1","flinch_chest2"},
	[HITGROUP_LEFTARM] = {"flinch_left1","flinch_left2"},
	[HITGROUP_RIGHTARM] = {"flinch_right1","flinch_right2"},
}
local defFlinch = {"flinch_chest1","flinch_chest2"}
--
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	local dmgtype = dmginfo:GetDamageType()
	local isBullet = bit.band(dmgtype, DMG_BULLET) == DMG_BULLET
	if isBullet && self:GetSequenceName(self:GetSequence()) == "parry_rocket" && IsValid(self.ParryRocketEntity) && self.ParryRocketEntity.Alive then
		local fx = EffectData() -- Explosion
		fx:SetOrigin(self:GetPos() +self:OBBCenter())
		fx:SetScale(1.5)
		util.Effect("Explosion",fx,true,true)
		self:ResetAI()
		local dmgAttacker,dmgInflictor = dmginfo:GetAttacker(),dmginfo:GetInflictor()
		timer.Simple(0.001,function()
			if IsValid(self) then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(150)
				dmginfo:SetDamageType(DMG_DIRECT)
				dmginfo:SetAttacker(dmgAttacker or self)
				dmginfo:SetInflictor(dmgInflictor or self)
				dmginfo:SetDamagePosition(self:GetPos() +self:OBBCenter())
				self:TakeDamageInfo(dmginfo)
			end
		end)
		self:PlayAnim("parry_rocket_exploded",true,false,false,0,{OnFinish=function()
			self:ResetAI()
			if !IsValid(self.VJ_TheController) && IsValid(self:GetEnemy()) then
				self.SprintT = CurTime() +math.random(4,6)
				self:PlaySound(self.SoundTbl_EnterRage,80,nil,true)
			end
		end})
	end
	local isExplosion = bit.band(dmgtype, DMG_BLAST) == DMG_BLAST
	if isBullet && CurTime() > (self.SprintT or 0) && CurTime() > (self.NextBulletFlinchT or 0) && math.random(1,10) == 1 then
		local anim = hitgroupAnims[hitgroup] or defFlinch
		local _,dur = self:PlayAnim(VJ.PICK(anim),true,false,false)
		self.NextBulletFlinchT = CurTime() +(dur *0.35)
	elseif isExplosion && !self.DisableExplosionStagger then
		self:ResetAI()
		self:PlayAnim("flinch_explosion",true,false,true,0,{OnFinish=function(interrupted)
			if interrupted then return end
			self:SetState()
			if !IsValid(self.VJ_TheController) && IsValid(self:GetEnemy()) then
				self.SprintT = CurTime() +math.random(4,6)
				self:PlaySound(self.SoundTbl_EnterRage,80,nil,true)
			end
		end})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpse)
	corpse:ResetSequence(self:LookupSequence("death"))
	corpse:SetCycle(1)
	undo.ReplaceEntity(self, corpse)
	SafeRemoveEntityDelayed(corpse,60)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	self.MouthT = CurTime() +(SoundDuration(sdFile) *0.9)
	self.NextMouthMoveT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sndFootSteps = {
	[MAT_ANTLION] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_BLOODYFLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_CONCRETE] = {
		"player/footsteps/concrete1.wav",
		"player/footsteps/concrete2.wav",
		"player/footsteps/concrete3.wav",
		"player/footsteps/concrete4.wav",
	},
	[MAT_DIRT] = {
		"player/footsteps/dirt1.wav",
		"player/footsteps/dirt2.wav",
		"player/footsteps/dirt3.wav",
		"player/footsteps/dirt4.wav",
	},
	[MAT_FLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[MAT_GRATE] = {
		"player/footsteps/metalgrate1.wav",
		"player/footsteps/metalgrate2.wav",
		"player/footsteps/metalgrate3.wav",
		"player/footsteps/metalgrate4.wav",
	},
	[MAT_ALIENFLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav",
	},
	[74] = { -- Snow
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav",
	},
	[MAT_PLASTIC] = {
		"physics/plaster/drywall_footstep1.wav",
		"physics/plaster/drywall_footstep2.wav",
		"physics/plaster/drywall_footstep3.wav",
		"physics/plaster/drywall_footstep4.wav",
	},
	[MAT_METAL] = {
		"player/footsteps/metal1.wav",
		"player/footsteps/metal2.wav",
		"player/footsteps/metal3.wav",
		"player/footsteps/metal4.wav",
	},
	[MAT_SAND] = {
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav",
	},
	[MAT_FOLIAGE] = {
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav",
	},
	[MAT_COMPUTER] = {
		"physics/plaster/drywall_footstep1.wav",
		"physics/plaster/drywall_footstep2.wav",
		"physics/plaster/drywall_footstep3.wav",
		"physics/plaster/drywall_footstep4.wav",
	},
	[MAT_SLOSH] = {
		"player/footsteps/slosh1.wav",
		"player/footsteps/slosh2.wav",
		"player/footsteps/slosh3.wav",
		"player/footsteps/slosh4.wav",
	},
	[MAT_TILE] = {
		"player/footsteps/tile1.wav",
		"player/footsteps/tile2.wav",
		"player/footsteps/tile3.wav",
		"player/footsteps/tile4.wav",
	},
	[85] = { -- Grass
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav",
	},
	[MAT_VENT] = {
		"player/footsteps/duct1.wav",
		"player/footsteps/duct2.wav",
		"player/footsteps/duct3.wav",
		"player/footsteps/duct4.wav",
	},
	[MAT_WOOD] = {
		"player/footsteps/wood1.wav",
		"player/footsteps/wood2.wav",
		"player/footsteps/wood3.wav",
		"player/footsteps/wood4.wav",
		"player/footsteps/woodpanel1.wav",
		"player/footsteps/woodpanel2.wav",
		"player/footsteps/woodpanel3.wav",
		"player/footsteps/woodpanel4.wav",
	},
	[MAT_GLASS] = {
		"physics/glass/glass_sheet_step1.wav",
		"physics/glass/glass_sheet_step2.wav",
		"physics/glass/glass_sheet_step3.wav",
		"physics/glass/glass_sheet_step4.wav",
	}
}
--
function ENT:FootStep(pos,name)
	if !self:IsOnGround() then return end
	local tbl = self.SoundTbl_FootSteps or sndFootSteps
	if !tbl then return end
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +Vector(0,0,-150),
		filter = {self}
	})
	local mat = tr.MatType
	if mat && tbl[mat] == nil then
		mat = MAT_CONCRETE
	end
	if tr.Hit && tbl[mat] then
		VJ.EmitSound(self,VJ.PICK(tbl[mat]),(self.FootstepSoundLevel or 65),self:GetSoundPitch(self.FootstepSoundPitch))
	end
	VJ.EmitSound(self,VJ.PICK(stepExtraSnds),65)
	if self:WaterLevel() > 0 && self:WaterLevel() < 3 then
		VJ.EmitSound(self,"player/footsteps/wade" .. math.random(1,8) .. ".wav",self.FootstepSoundLevel,self:GetSoundPitch(self.FootstepSoundPitch))
	end
	if self.OnStep then
		self:OnStep(pos,name)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	for _,v in ipairs(self.DeleteSounds) do
		if v then
			v:Stop()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetClearPos(origin,disableGroundSnap)
	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()
	local pos = origin || self:GetPos()
	local savePos = pos
	local nearents = ents.FindInBox(pos +mins,pos +maxs)
	maxs.x = maxs.x *2
	maxs.y = maxs.y *2
	local zMax = 0
	local entTgt
	for _,ent in ipairs(nearents) do
		if(ent != self && ent:GetSolid() != SOLID_NONE && ent:GetSolid() != SOLID_BSP && gamemode.Call("ShouldCollide",self,ent) != false) then
			local obbMaxs = ent:OBBMaxs()
			if(obbMaxs.z > zMax) then
				zMax = obbMaxs.z
				entTgt = ent
			end
		end
	end
	local tbl_filter = {self,entTgt}
	local stayaway = zMax > 0
	if(!stayaway) then
		pos.z = pos.z +10
	else
		zMax = zMax +10
	end
	local left = Vector(0,1,0)
	local right = left *-1
	local forward = Vector(1,0,0)
	local back = forward *-1
	local trace_left = util.TraceLine({
		start = pos,
		endpos = pos +left *maxs.y,
		filter = tbl_filter
	})
	local trace_right = util.TraceLine({
		start = pos,
		endpos = pos +right *maxs.y,
		filter = tbl_filter
	})
	if(trace_left.Hit || trace_right.Hit) then
		if(trace_left.Fraction < trace_right.Fraction) then
			pos = pos +right *((trace_right.Fraction -trace_left.Fraction) *maxs.y)
		elseif(trace_right.Fraction < trace_left.Fraction) then
			pos = pos +left *((trace_left.Fraction -trace_right.Fraction) *maxs.y)
		end
	elseif(stayaway) then
		pos = pos +(math.random(1,2) == 1 && left || right) *maxs.y *1.8
		stayaway = false
	end
	local trace_forward = util.TraceLine({
		start = pos,
		endpos = pos +forward *maxs.x,
		filter = tbl_filter
	})
	local trace_backward = util.TraceLine({
		start = pos,
		endpos = pos +back *maxs.x,
		filter = tbl_filter
	})
	if(trace_forward.Hit || trace_backward.Hit) then
		if(trace_forward.Fraction < trace_backward.Fraction) then
			pos = pos +back *((trace_backward.Fraction -trace_forward.Fraction) *maxs.x)
		elseif(trace_backward.Fraction < trace_forward.Fraction) then
			pos = pos +forward *((trace_forward.Fraction -trace_backward.Fraction) *maxs.x)
		end
	elseif(stayaway) then
		pos = pos +(math.random(1,2) == 1 && forward || back) *maxs.x *1.8
		stayaway = false
	end
	if(stayaway) then -- We can't avoid whatever it is we're stuck in,let's try to spawn on top of it
		local start = entTgt:GetPos()
		start.z = start.z +zMax
		local endpos = start
		endpos.z = endpos.z +maxs.z
		local tr = util.TraceLine({
			start = start,
			endpos = endpos,
			filter = tbl_filter
		})
		if(!tr.Hit || (!tr.HitWorld && gamemode.Call("ShouldCollide",self,tr.Entity) == false)) then
			pos.z = start.z
			stayaway = false
		else -- Just try to move to whatever direction seems best
			local trTgt = trace_left
			if(trace_right.Fraction < trTgt.Fraction) then trTgt = trace_right end
			if(trace_forward.Fraction < trTgt.Fraction) then trTgt = trace_forward end
			if(trace_backward.Fraction < trTgt.Fraction) then trTgt = trace_backward end
			pos = pos +trTgt.Normal *maxs.x
		end
	end
	if !disableGroundSnap then
		local trDown = util.TraceLine({
			start = pos,
			endpos = pos +Vector(0,0,maxs.z *-2),
			filter = tbl_filter,
			-- collisiongroup = COLLISION_GROUP_WORLD,
		})
		if(trDown.Hit) then
			debugoverlay.Line(pos,trDown.HitPos,5,Color(255,255,255))
			debugoverlay.Box(pos,Vector(-2,-2,-2),Vector(2,2,2),5,Color(255,255,255))
			pos.z = trDown.HitPos.z
		end
	end
	-- pos.z = pos.z + 3
	-- debugoverlay.Box(pos,Vector(-2,-2,-2),Vector(2,2,2),5,Color(0,26,255))
	local minC,maxC = self:GetCollisionBounds()
	local corners = { // 4 corners
		Vector(minC.x,minC.y,0),
		Vector(minC.x,maxC.y,0),
		Vector(maxC.x,minC.y,0),
		Vector(maxC.x,maxC.y,0)
	}
	for _,v in pairs(corners) do
		if !util.IsInWorld(pos +v) then
			-- print("BAD CORNER: ",pos +v)
			debugoverlay.Box(pos,Vector(-2,-2,-2),Vector(2,2,2),5,Color(255,0,0))
			local toSafeDir = (savePos - v):GetNormalized()
			local trace1 = util.TraceLine({
				start = v,
				endpos = savePos,
				filter = tbl_filter,
				collisiongroup = COLLISION_GROUP_WORLD,
				output = {}
			})
			debugoverlay.Line(v,trace1.HitPos,5,Color(255,0,230))
			if trace1.Hit && util.IsInWorld(trace1.HitPos) then
				-- print("Found possible entry point:",trace1.HitPos)
				debugoverlay.Box(trace1.HitPos,Vector(-4,-4,-4),Vector(4,4,4),5,Color(255,0,230))
				local trace2 = util.TraceLine({
					start = trace1.HitPos,
					endpos = v,
					filter = tbl_filter,
					collisiongroup = COLLISION_GROUP_WORLD,
					output = {}
				})
				debugoverlay.Line(v,trace2.HitPos,5,Color(67,227,255))
				if trace2.Hit && util.IsInWorld(trace2.HitPos) then
					-- print("Final valid position near world edge:",trace2.HitPos)
					debugoverlay.Box(trace2.HitPos,Vector(-4,-4,-4),Vector(4,4,4),5,Color(67,227,255))
					pos = trace2.HitPos + trace2.HitNormal *16
				else
					pos = savePos
				end
			else
				pos = savePos
			end
			break
		end
	end
	if !util.IsInWorld(pos) then
		pos = savePos
	end
	pos = pos +Vector(0,0,6)

	debugoverlay.Line(self:GetPos(),pos,5,Color(47,255,0))
	debugoverlay.Box(pos,Vector(-2,-2,-2),Vector(2,2,2),5,Color(13,255,0))
	self:SetPos(pos)

	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunAI() -- Called from the engine every 0.1 seconds
	if self:GetState() == VJ_STATE_FREEZE or self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then self:MaintainActivity() return end
	if self:IsRunningBehavior() or self.bDoingEngineSchedule then return true end -- true = Run "MaintainSchedule" in engine
	//self:SetArrivalActivity(ACT_COWER)
	//self:SetArrivalSpeed(1000)
	local isMoving = self:IsMoving()
	
	-- Apply walk frames to both activities and sequences
	-- Parts of it replicate TASK_PLAY_SEQUENCE - https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc_schedule.cpp#L3312
	if !isMoving && self:GetSequenceMoveDist(self:GetSequence()) > 0 && ((self:GetSequence() == self:GetIdealSequence()) or (self:GetActivity() == ACT_DO_NOT_DISTURB)) && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC then
		local sprintActive = IsValid(self.VJ_TheController) && self.VJ_TheController:KeyDown(IN_SPEED)
		if sprintActive or !sprintActive && !self:IsSequenceFinished() then
			self:AutoMovement(self:GetAnimTimeInterval())
		end
	end
	
	-- If we are currently running a schedule then run it otherwise call "SelectSchedule" to decide what to do next
	local curSchedule = self.CurrentSchedule
	if curSchedule then
		-- Handle movement animations
			-- 1. Make sure the movement activity is the current activity
			-- 2. Compare the current movement sequence to the current ideal sequence, if they don't match then the movement activity may be outdated depending on the next check!
			-- 3. Compare their activities and continue if they don't match! A single activity can have multiple sequences tied to it, without this check it will cause it to bug out!
			-- 4. Force the ideal sequence to be the actual movement activity's sequence (including translated)
			-- This is needed because:
				-- 1. Often times translating alone will NOT update the movement animation!
				-- 2. Half of the time, the engine will NOT even call the translate function!
		if isMoving then
			local moveAct = self:GetMovementActivity()
			if self:GetActivity() == moveAct then
				self:SetMovementActivity(moveAct) -- Force update the movement sequence, aka "m_sequence" in the engine
				local moveSeq = self:GetMovementSequence()
				local idealSeq = self:GetIdealSequence()
				if moveSeq != idealSeq && self:GetSequenceActivity(moveSeq) != self:GetSequenceActivity(idealSeq) then
					self:SetIdealSequence(moveSeq)
				end
			end
		end
		
		self:DoSchedule(curSchedule)
		if curSchedule.CanBeInterrupted or self:IsScheduleFinished(curSchedule) or (curSchedule.HasMovement && !self:IsMoving()) then
			self:SelectSchedule()
		end
	else
		self:SelectSchedule()
	end
	
	//if !self.VJ_PlayingSequence then -- No longer needed for sequences as it is handled by ACT_DO_NOT_DISTURB
	self:MaintainActivity()
	//end
	
	-- Handle turning / facing
	local turnData = self.TurnData
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	
	if eneValid && !self.Dead then
		-- Handle "ConstantlyFaceEnemy" behavior
		if self.ConstantlyFaceEnemy && self:MaintainConstantlyFaceEnemy() then
			return
		end
		-- Face enemy for stationary types OR attacks
		if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary) or (self.AttackType && ((self.MeleeAttackAnimationFaceEnemy && !self.MeleeAttack_IsPropAttack && self.AttackType == VJ.ATTACK_TYPE_MELEE) or (self.GrenadeAttackAnimationFaceEnemy && self.AttackType == VJ.ATTACK_TYPE_GRENADE && self.EnemyData.Visible) or (self.RangeAttackAnimationFaceEnemy && self.AttackType == VJ.ATTACK_TYPE_RANGE) or ((self.LeapAttackAnimationFaceEnemy == true or (self.LeapAttackAnimationFaceEnemy == 2 && !self.LeapAttackHasJumped)) && self.AttackType == VJ.ATTACK_TYPE_LEAP))) then
			self:SetTurnTarget("Enemy")
			return
		end
	end
	
	if turnData.Type then
		-- If StopOnFace flag is set AND (Something has requested to take over by checking "ideal yaw != last set yaw") OR (we are facing ideal) then finish it!
		if turnData.StopOnFace && (self:GetIdealYaw() != turnData.LastYaw or self:IsFacingIdealYaw()) then
			self:ResetTurnTarget()
		else
			turnData.LastYaw = 0 -- To make sure the turning maintain works correctly
			local turnTarget = turnData.Target
			if turnData.Type == VJ.FACE_POSITION or (turnData.Type == VJ.FACE_POSITION_VISIBLE && self:VisibleVec(turnTarget)) then
				local resultAng = self:GetTurnAngle((turnTarget - self:GetPos()):Angle())
				if self.TurningUseAllAxis then
					local myAng = self:GetAngles()
					self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
				end
				self:SetIdealYawAndUpdate(resultAng.y)
				turnData.LastYaw = resultAng.y
			elseif IsValid(turnTarget) && (turnData.Type == VJ.FACE_ENTITY or (turnData.Type == VJ.FACE_ENTITY_VISIBLE && self:Visible(turnTarget))) then
				local resultAng;
				if self.TurningUseAllAxis then
					local myAng = self:GetAngles()
					resultAng = self:GetTurnAngle(((turnTarget:GetPos() + turnTarget:OBBCenter()) - self:GetPos()):Angle())
					self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
				else
					resultAng = self:GetTurnAngle((turnTarget:GetPos() - self:GetPos()):Angle())
				end
				self:SetIdealYawAndUpdate(resultAng.y)
				turnData.LastYaw = resultAng.y
			elseif eneValid && !self.Dead && (turnData.Type == VJ.FACE_ENEMY or (turnData.Type == VJ.FACE_ENEMY_VISIBLE && self.EnemyData.Visible)) then
				local resultAng;
				if self.TurningUseAllAxis then
					local myAng = self:GetAngles()
					resultAng = self:GetTurnAngle(((ene:GetPos() + ene:OBBCenter()) - self:GetPos()):Angle())
					self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
				else
					resultAng = self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle())
				end
				self:SetIdealYawAndUpdate(resultAng.y)
				turnData.LastYaw = resultAng.y
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetAI()
	self:SetState()
	-- self:StopMoving()
	self:ResetMoveCalc()
	self:SetNavType(NAV_GROUND)
	self:SetMoveType(MOVETYPE_STEP)
	if self.CurrentSchedule then
		self.CurrentSchedule = nil
		self.CurrentTask = nil
		self.CurrentTaskID = nil
	end
	self.NextIdleStandTime = 0
	self.NextIdleTime = 0
	self.NextChaseTime = 0
	self.AnimLockTime = 0
	self.PauseAttacks = false

	self.InGunState = false
	self:SetBodygroup(self:FindBodygroupByName("weapon"),0)
	self:SetAfterimage(false)
	SafeRemoveEntity(self.ParryRocketEntity)
end