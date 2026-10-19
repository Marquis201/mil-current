AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2025 by Cpt. Hazama,All rights reserved. ***
	No parts of this code or any of its contents may be reproduced,copied,modified or adapted,
	without the prior written consent of the author,unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/cpthazama/re5/em84.mdl"
ENT.StartHealth = 800
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.JumpParams = {
	MaxRise = 968,
	MaxDrop = 2560,
	MaxDistance = 1024,
}
ENT.HullType = HULL_HUMAN
ENT.VJ_NPC_Class = {"CLASS_WESKER","CLASS_JILL"}
ENT.InvestigateSoundMultiplier = 18
ENT.PropInteraction_MaxScale = 8

ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "bone17", -- If left empty, the base will attempt to calculate a position for first person
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
	"cpthazama/re5/em84/40.wav",
	"cpthazama/re5/em84/41.wav",
	"cpthazama/re5/em84/42.wav",
}
ENT.SoundTbl_CombatIdle = {
	"cpthazama/re5/em84/16.wav",
	"cpthazama/re5/em84/17.wav",
	"cpthazama/re5/em84/18.wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/re5/em84/50.wav",
	"cpthazama/re5/em84/51.wav",
	"cpthazama/re5/em84/52.wav",
	"cpthazama/re5/em84/53.wav",
	"cpthazama/re5/em84/54.wav",
	"cpthazama/re5/em84/55.wav",
	"cpthazama/re5/em84/56.wav",
	"cpthazama/re5/em84/57.wav",
	"cpthazama/re5/em84/58.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"cpthazama/re5/em84/19.wav",
	"cpthazama/re5/em84/20.wav",
	"cpthazama/re5/em84/21.wav",
	"cpthazama/re5/em84/22.wav",
	"cpthazama/re5/em84/23.wav",
	"cpthazama/re5/em84/45.wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/re5/em84/24.wav",
	"cpthazama/re5/em84/25.wav",
	"cpthazama/re5/em84/26.wav",
	"cpthazama/re5/em84/27.wav",
	"cpthazama/re5/em84/28.wav",
	"cpthazama/re5/em84/29.wav",
	"cpthazama/re5/em84/34.wav",
	"cpthazama/re5/em84/35.wav",
	"cpthazama/re5/em84/36.wav",
}
ENT.SoundTbl_PainDevice = {
	"cpthazama/re5/em84/49.wav",
}
ENT.SoundTbl_PainExplosion = {
	"cpthazama/re5/em84/30.wav",
	"cpthazama/re5/em84/31.wav",
	"cpthazama/re5/em84/32.wav",
	"cpthazama/re5/em84/33.wav",
	"cpthazama/re5/em84/38.wav",
}
ENT.SoundTbl_Recover = {
	"cpthazama/re5/em84/37.wav",
}
ENT.SoundTbl_RecoverDevice = {
	"cpthazama/re5/em84/46.wav",
	"cpthazama/re5/em84/47.wav",
	"cpthazama/re5/em84/48.wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/re5/em84/39.wav",
}
ENT.SoundTbl_Taunt = {
	"cpthazama/re5/em84/43.wav",
	"cpthazama/re5/em84/44.wav",
}

ENT.HasSoundTrack = true
-- ENT.SoundTbl_SoundTrack = {"cpthazama/re5/jill.mp3"}

ENT.DamageMultiplier = 1
--
local defMeleeAttacks = ENT.AnimTbl_MeleeAttack
local hitSnds = {
	[1] = "cpthazama/re5/em84/77.wav", -- Kick
	[2] = "cpthazama/re5/em84/78.wav", -- Punch
}
local missSnds = {
	"cpthazama/re5/em84/107.wav",
	"cpthazama/re5/em84/108.wav",
	"cpthazama/re5/em84/112.wav",
}
local dodgeSnds = {
	"cpthazama/re5/em84/104.wav",
	"cpthazama/re5/em84/105.wav",
}
local coatSnds = {
	"cpthazama/re5/em84/127.wav",
	"cpthazama/re5/em84/128.wav",
	"cpthazama/re5/em84/129.wav",
}
local coatFastSnds = {
	"cpthazama/re5/em84/130.wav",
	"cpthazama/re5/em84/131.wav",
	"cpthazama/re5/em84/132.wav",
}
local deviceDmgSnds = {
	"cpthazama/re5/em84/71.wav",
	"cpthazama/re5/em84/72.wav",
	"cpthazama/re5/em84/73.wav",
	"cpthazama/re5/em84/74.wav",
	"cpthazama/re5/em84/75.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetPhysicsDamageScale(0)
	self.DeleteSounds = {}
	self.CurrentAttackSound = nil

	self.DodgeT = 0
	self.NextSMGFireT = 0
	self.SMGAmmo = 50
	self.InGunState = false
	self.Cont_SprintActive = false
	self.DefaultAttackDistance = 43
	self.MouthT = 0
	self.NextMouthMoveT = 0

	self:SetBoss(self.IsBossVersion or false)
	if self.IsBossVersion then
		self:SetMaxHealth(self:Health() *2)
		self:SetHealth(self:GetMaxHealth())
	end

	if self.OnInit then
		self:OnInit()
	end

	-- print("Before", self:Health(), self.DamageMultiplier)
	-- self.DisableExplosionStagger = GetConVar("vj_re5_jill_noexplosionflinch"):GetBool()
	-- self.DisableDodgeEffects = GetConVar("vj_re5_jill_nododgeeffects"):GetBool()
	self.DisableExplosionStagger = false
	self.DisableDodgeEffects = false
	local hpMult = GetConVar("vj_re5_jill_hpmult"):GetFloat()
	if hpMult > 1 then
		self:SetHealth(self:Health() *hpMult)
		self:SetMaxHealth(self:Health())
	end
	local dmgMult = GetConVar("vj_re5_jill_dmgmult"):GetFloat()
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
	["attack_holster"] = function(self)
		return self:GetForward() *200 +self:GetUp() *200
	end,
	["attack_rkick"] = function(self)
		return self:GetForward() *300 +self:GetUp() *200
	end,
	["attack_summersault_kick"] = function(self)
		return self:GetUp() *-700
	end,
	["attack_summersault_palms"] = function(self)
		return self:GetForward() *200 +self:GetUp() *-700
	end,
}
--
function ENT:MeleeAttackKnockbackVelocity(ent)
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
	if key == "attack_rkick" then
		VJ.EmitSound(self,VJ.PICK(coatSnds),75)
		self.MeleeAttackDamage = 20 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_holster" then
		self.MeleeAttackDamage = 30 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_summersault_kick" then
		self.MeleeAttackDamage = 30 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "attack_summersault_palms" then
		self.MeleeAttackDamage = 60 *dmgMult
		self.MeleeAttackDamageType = DMG_CLUB
		self.HasMeleeAttackKnockBack = true
		self.SoundTbl_MeleeAttackExtra = defExtra
		self:ExecuteMeleeAttack()
	elseif key == "weapons_draw" then
		VJ.EmitSound(self,"cpthazama/re5/em84/154.wav",75)
		self:SetBodygroup(self:FindBodygroupByName("weapons"),1)
	elseif key == "weapons_cock" then
		VJ.EmitSound(self,"cpthazama/re5/em84/146.wav",75)
	elseif key == "weapons_holster" then
		VJ.EmitSound(self,"cpthazama/re5/em84/155.wav",75)
		self:SetBodygroup(self:FindBodygroupByName("weapons"),0)
	elseif key == "weapons_spray_on" then
		self.WeaponSprayActive = true
		self.SMGAmmo = 50
		if self:GetSequenceName(self:GetSequence()) == "attack_slidefire" then
			VJ.EmitSound(self,"cpthazama/re5/em84/59.wav",75)
		end
	elseif key == "weapons_spray_off" then
		self.WeaponSprayActive = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self.InGunState then
		if act == ACT_IDLE then
			return ACT_IDLE_STIMULATED
		end
	end
	if IsValid(self.VJ_TheController) then
		local ply = self.VJ_TheController
		if (act == ACT_WALK or act == ACT_RUN) then
			return ply:KeyDown(IN_SPEED) && ACT_RUN or ACT_WALK
		end
	else
		-- if (act == ACT_WALK or act == ACT_RUN) then
		-- 	return (self.SprintT or 0) >= CurTime() && ACT_RUN or ACT_WALK
		-- end
	end
	return baseclass.Get("npc_vj_creature_base").TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySound(sndTbl,level,pitch,setCurSnd)
	if !sndTbl or istable(sndTbl) && #sndTbl <= 0 then return 0 end
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

	ply:ChatPrint("Jill Controls:")
	ply:ChatPrint("Press [LEFT-MOUSE] to attack / fire weapons")
	ply:ChatPrint("Hold [RIGHT-MOUSE] to toggle between melee and weapons")
	ply:ChatPrint("Press [LEFT-MOUSE + SHIFT] to perform ranged melee attacks")
	ply:ChatPrint("Press [E + L-ALT] to fire in all directions")
	ply:ChatPrint("Press [R] to taunt")
	ply:ChatPrint("Hold [SPACE] to dodge")
	if self.AdditionalControllerInstructions then
		for _,v in ipairs(self.AdditionalControllerInstructions) do
			ply:ChatPrint(v)
		end
	end

	function controlEnt:OnThink()
		self.VJC_NPC_CanTurn = self.VJC_Camera_Mode == 2
		self.VJC_BullseyeTracking = self.VJCE_NPC:IsMoving() && self.VJCE_NPC:GetIdealActivity() != ACT_RUN or self.VJC_Camera_Mode == 2
		self.VJCE_NPC:SetHP(self.VJCE_NPC:Health())
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
			npc.JumpParams.Enabled = true
		end
	end
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
	local _,dur = self:PlayAnim("taunt1",true,false,false)
	self:PlaySound(self.SoundTbl_Taunt,75,nil,true)
	self.NextTauntT = CurTime() +dur
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ToggleGunState()
	local oldState = self.InGunState
	self.InGunState = !self.InGunState
	if oldState == false then
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		self:CapabilitiesRemove(bit.bor(CAP_MOVE_GROUND))
		local _,dur = self:PlayAnim("weapons_draw",true,false,true,0,{OnFinish=function(interrupted)
			if self.LastSequence != "weapons_draw" then return end
			self:SetState()
		end})
		self.NextSMGFireT = CurTime() +dur
		self.SMGAmmo = 50
	else
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
		local _,dur = self:PlayAnim("weapons_holster",true,false,true,0,{OnFinish=function(interrupted)
			if self.LastSequence != "weapons_holster" then return end
			self:SetState()
		end})
		-- timer.Simple(dur *0.45,function()
		-- 	if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "weapons_holster" then
		-- 		self.AnimTbl_MeleeAttack = "attack_holster"
		-- 		self.MeleeAttackDistance = self.DefaultAttackDistance
		-- 		self.AnimLockTime = 0
		-- 		self.PauseAttacks = false
		-- 		self:SetState()
		-- 	end
		-- end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
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
function ENT:FireWeapons(ent)
	local curTime = CurTime()
	if self.NextSMGFireT < curTime && (IsValid(ent) && !self:IsBusy("Activities") or !IsValid(ent)) then
		self:SetBodygroup(self:FindBodygroupByName("weapons"),1)
		if IsValid(ent) then
			self.SMGAmmo = self.SMGAmmo -2
			self:PlayAnim("weapons_fire",false,false,false,0,{AlwaysUseGesture=true})
		end
		self.NextSMGFireT = curTime +0.04
		for i = 1,2 do
			local shootPos = self:GetAttachment(1).Pos
			if i == 2 then
				local fake = ents.Create("prop_vj_animatable")
				fake:SetModel("models/hunter/plates/plate.mdl")
				fake:SetPos(self:GetAttachment(2).Pos)
				fake:SetAngles(self:GetAttachment(2).Ang)
				fake:Spawn()
				fake:Activate()
				fake:SetNoDraw(true)
				fake:DrawShadow(false)
				-- fake:SetParent(self)
				fake:SetOwner(self)
				-- fake:Fire("SetParentAttachment", "muzzle_l", 0)
				self:DeleteOnRemove(fake)
				SafeRemoveEntity(fake,0)
				shootPos = fake:GetPos()
			end
			local bullet = {}
			bullet.Num = 1
			bullet.Src = shootPos
			if IsValid(ent) then
				bullet.Dir = ((ent:EyePos() -Vector(0,0,ent:OBBCenter().z *0.2)) -shootPos):GetNormalized()
			else
				bullet.Dir = self:GetAttachment(i).Ang:Forward()
			end
			bullet.Spread = Vector(0.06,0.06,0)
			bullet.Tracer = 1
			bullet.Force = 5
			bullet.Damage = 8
			bullet.AmmoType = "SMG1"
			self:FireBullets(bullet)
			ParticleEffect("vj_rifle_full",shootPos,Angle())
		end
		sound.Play("cpthazama/re5/em84/evo_fire.wav",self:GetPos() +self:OBBCenter(),95,self:GetSoundPitch(self.GeneralSoundPitch))
		-- VJ.EmitSound(self,"VJ.Weapon_SMG1.Single",95,self:GetSoundPitch(self.GeneralSoundPitch))
		if self.SMGAmmo <= 0 then
			self.NextSMGFireT = curTime +1
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local grenadeEnts = {npc_grenade_frag = true, grenade_hand = true, obj_spore = true, obj_grenade = true, obj_handgrenade = true, doom3_grenade = true, fas2_thrown_m67 = true, cw_grenade_thrown = true, obj_cpt_grenade = true, cw_flash_thrown = true, ent_hl1_grenade = true, rtbr_grenade_frag = true, ent_ins_m67 = true, ent_ins_rgd5 = true, csgo_hegrenade_projectile = true, csgo_incgrenade_projectile = true, bb_throwncssfrag = true, ent_doimills = true, ent_doimk2 = true, ent_doino69 = true, ent_doistielhandgranate = true, m9k_thrown_m61 = true, m9k_thrown_sticky_grenade = true, sent_uh_grenade = true, stalker_grenade_f1_ent = true, stalker_grenade_rgd_ent = true}
--
function ENT:OnThinkAttack(isAttacking, ent)
	local data = self.EnemyData
	local visible = data.Visible
	local dist = data.DistanceNearest
	local curTime = CurTime()
	local cont = self.VJ_TheController

	if self.InGunState then
		self.AnimTbl_MeleeAttack = "attack_holster"
		self.MeleeAttackDistance = self.DefaultAttackDistance
		if IsValid(cont) && !cont:KeyDown(IN_ATTACK2) or !IsValid(cont) && (dist > 1250 or !visible) then
			self:ToggleGunState()
			return
		end
		self:FaceCertainEntity(ent, 0.2)
		-- print("GunState: ",curTime, self.NextSMGFireT, IsValid(ent), self:IsBusy("Activities"))
		if IsValid(cont) && cont:KeyDown(IN_ATTACK) or !IsValid(cont) && dist <= 1250 && visible then
			self:FireWeapons(ent)
			if self.SMGAmmo <= 0 then
				self.NextSMGFireT = curTime +1
				self:ToggleGunState()
			end
		end
		return
	else
		if IsValid(cont) && cont:KeyDown(IN_ATTACK2) then
			self:ToggleGunState()
			return
		end
	end

	if (!IsValid(cont) && dist > 300 && dist <= 1000 && math.random(1,100) == 1 or IsValid(cont) && cont:KeyDown(IN_WALK) && cont:KeyDown(IN_USE)) && !self:IsBusy("Activities") && curTime > (self.NextSprayAttackT or 0) then
		local _,dur = self:PlayAnim("weapons_special_draw",true,false,true,0,{OnFinish=function(interrupted)
			if self.LastSequence != "weapons_special_draw" then return end
			self:PlayAnim("weapons_special_fire",true,false,false,0,{OnFinish=function(interrupted)
				if self.LastSequence != "weapons_special_fire" then return end
				self:PlayAnim("weapons_special_holster",true,false,false,0,{OnFinish=function(interrupted)
					if self.LastSequence != "weapons_special_holster" then return end
					self:SetState()
				end})
			end})
		end})
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK,dur)
		self.NextSprayAttackT = CurTime() +dur +(IsValid(cont) && 1 or math.random(4,6))
	end

	if !IsValid(cont) && dist > 700 && dist <= 2000 && math.random(1,100) == 1 then
		if (self.SprintT or 0) < curTime then
			local _,dur = self:PlayAnim("idle_to_run",true,false,true)
			-- self:PlaySound(self.SoundTbl_EnterRage,80,nil,true)
			self.SprintT = curTime +dur +math.random(4,6)
		end
	else
		if IsValid(cont) && cont:KeyDown(IN_USE) then
			self.AnimTbl_MeleeAttack = "attack_summersault"
		else
			-- if math.random(1,3) == 1 && dist > self.DefaultAttackDistance then
			-- 	self.AnimTbl_MeleeAttack = "attack_summersault"
			-- 	self.MeleeAttackDistance = 150
			-- else
				self.AnimTbl_MeleeAttack = "attack_rkick"
				self.MeleeAttackDistance = self.DefaultAttackDistance
			-- end
		end
		self.MeleeAttackDistance = self.DefaultAttackDistance
		if !IsValid(cont) && dist <= 1250 && dist > 150 && visible && math.random(1,70) == 1 && !self.InGunState then
			self:ToggleGunState()
		end
	end

	if !IsValid(cont) && self:GetIdealActivity() == ACT_RUN && self:GetPathTimeToGoal() >= 0.15 or IsValid(cont) && cont:KeyDown(IN_SPEED) then
		self.AnimTbl_MeleeAttack = {"attack_slidefire","attack_summersault"}
		self.MeleeAttackDistance = 50
	end

	if !IsValid(cont) then
		for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 400)) do
			if (ent.VJ_ID_Danger or ent.VJ_ID_Grenade or grenadeEnts[ent:GetClass()]) && self:Visible(ent) then
				if ent:GetClass() == "prop_ragdoll" then continue end
				local owner = ent:GetOwner()
				if !(IsValid(owner) && owner.IsVJBaseSNPC && ((self:GetClass() == owner:GetClass()) or (self:Disposition(owner) == D_LI))) then
					if math.random(1,3) == 1 then
						self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x)
							x.CanShootWhenMoving = true
							x.TurnData = {Type = VJ.FACE_ENEMY}
						end)
					else
						self:PlayAnim("dodge_b2",true,false,false)
						self:FaceCertainEntity(ent, 0.6)
					end
					break
				end
			end
		end
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

	if self.Dead then return end
	local curTime = CurTime()
	local ent = self:GetEnemy() or self.VJ_TheControllerBullseye
	local cont = self.VJ_TheController
	local inSprint = self:GetIdealActivity() == ACT_RUN

	self.HasMeleeAttack = !self.InGunState
	self.DisableChasingEnemy = self.InGunState
	self:SetClip(self.SMGAmmo)
	if self.DodgeT > curTime && !self.HasNoTargetFlag then
		self:AddFlags(FL_NOTARGET)
		self.HasNoTargetFlag = true
	elseif self.HasNoTargetFlag && self.DodgeT < curTime then
		self:RemoveFlags(FL_NOTARGET)
		self.HasNoTargetFlag = false
	end
	if inSprint then
		self:SetMoveVelocity(self:GetMoveVelocity() *2)
		self:SetArrivalSpeed(9999)
	end
	if self.WeaponSprayActive then
		self:FireWeapons()
	end
	if self.MouthT > curTime && self.NextMouthMoveT < curTime then
		local _,dur = self:VJ_ACT_PLAYACTIVITY("vjges_talk",false,false,false,0,{AlwaysUseGesture=true})
		local alt = math.Rand(0.3,1)
		if curTime -self.MouthT <= dur then
			alt = 1
		end
		self.NextMouthMoveT = curTime +(dur *alt)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local hasString = string.find
--
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if self.Dead then return end
	local dmgtype = dmginfo:GetDamageType()
	local isBullet = bit.band(dmgtype, DMG_BULLET) == DMG_BULLET
	local isMelee = (bit.band(dmgtype, DMG_CLUB) == DMG_CLUB or bit.band(dmgtype, DMG_SLASH) == DMG_SLASH) && self:GetSequenceName(self:GetSequence()) != "attack_parry"
	local isExplosion = bit.band(dmgtype, DMG_BLAST) == DMG_BLAST
	local curSeq = self:GetSequenceName(self:GetSequence())

	if (isBullet or isMelee) && !isExplosion && self.AttackState <= VJ.ATTACK_STATE_STARTED && !hasString(curSeq,"stagger") && self.LastSequence != "ground_idle" && self.LastSequence != "flinch_chest2" then
		if hitgroup == HITGROUP_GEAR then return end
		if IsValid(self.VJ_TheController) && !self.VJ_TheController:KeyDown(IN_JUMP) or !IsValid(self.VJ_TheController) && math.random(1,2) == 1 then return end
		dmginfo:SetDamage(0)
		self:FaceCertainEntity(dmginfo:GetAttacker(), 0.2)
		if !hasString(curSeq,"dodge") or hasString(curSeq,"dodge") && self:GetCycle() > 0.9 then
			self:DoDodge(dmginfo)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDodge(dmginfo)
	local cont = IsValid(self.VJ_TheController)
	local gunState = self.InGunState
	self:StopMoving()
	self:ResetAI()
	local anim = VJ.PICK({"dodge_b","dodge_b2","dodge_l","dodge_r"})
	if gunState then
		anim = VJ.PICK({"weapons_dodge_f","weapons_dodge_l","weapons_dodge_r"})
		self.SMGAmmo = 50
	end
	local _,dur = self:PlayAnim(anim,true,false,true,0,{OnFinish=function(interrupted,anim)
		-- if interrupted then return end
		if self.LastSequence != anim then return end
		self:ResetAI()
		if gunState then
			self:SetBodygroup(self:FindBodygroupByName("weapons"),1)
			self.InGunState = true
		else
			if !IsValid(self.VJ_TheController) then
				if math.random(1,50) == 1 then
					self:Taunt()
				end
			end
		end
	end})
	self.InGunState = gunState
	self:SetBodygroup(self:FindBodygroupByName("weapons"),gunState && 1 or 0)
	self.DodgeT = CurTime() +0.075
	self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK,dur)
	self:PlaySound(self.SoundTbl_Dodge,75,nil,true)
	if self.DisableDodgeEffects != true then
		ParticleEffectAttach("vj_re5_jill_dodge",PATTACH_POINT_FOLLOW,self,0)
	end
	local attacker = dmginfo:GetAttacker()
	if IsValid(attacker) && attacker.GetEnemy && attacker:GetEnemy() == self && attacker.IgnoreEnemyUntil then
		attacker:SetEnemy(nil)
		attacker:IgnoreEnemyUntil(self, CurTime() +0.075)
	end
	VJ.EmitSound(self,VJ.PICK(dodgeSnds),75,self:GetSoundPitch(self.GeneralSoundPitch))
end
---------------------------------------------------------------------------------------------------------------------------------------------
local hitgroupAnims = {
	[HITGROUP_CHEST] = {"flinch_chest"},
	[HITGROUP_GEAR] = {"flinch_chest2"},
	[HITGROUP_LEFTARM] = "flinch_l",
	[HITGROUP_RIGHTARM] = "flinch_r",
	[HITGROUP_LEFTLEG] = "flinch_l_leg",
	[HITGROUP_RIGHTLEG] = "flinch_r_leg",
}
local defFlinch = {"flinch_l","flinch_r"}
--
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	local dmgtype = dmginfo:GetDamageType()
	local isBullet = bit.band(dmgtype, DMG_BULLET) == DMG_BULLET
	local isExplosion = bit.band(dmgtype, DMG_BLAST) == DMG_BLAST
	local isDeadlyDMG = (bit.band(dmgtype, DMG_CRUSH) == DMG_CRUSH or IsValid(dmginfo:GetAttacker()) && dmginfo:GetAttacker().VJ_ID_Boss) or hitgroup == HITGROUP_GEAR && dmginfo:GetDamage() > 10
	if isBullet && CurTime() > (self.SprintT or 0) && CurTime() > (self.NextBulletFlinchT or 0) && math.random(1,hitgroup == HITGROUP_GEAR && 1 or 10) == 1 then
		self:ResetAI()
		local anim = hitgroupAnims[hitgroup] or defFlinch
		local pickedAnim = VJ.PICK(anim)
		local _,dur = self:PlayAnim(pickedAnim,true,false,false)
		local sdPos = dmginfo:GetDamagePosition()
		timer.Simple(0.01,function()
			if IsValid(self) && pickedAnim == "flinch_chest2" then
				self:PlaySound(self.SoundTbl_PainDevice,75,nil,true)
				timer.Simple(dur *0.35,function()
					if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "flinch_chest2" then
						self:PlaySound("cpthazama/re5/em84/32.wav",75,nil,true)
					end
				end)
				timer.Simple(dur *0.75,function()
					if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "flinch_chest2" then
						self:PlaySound("cpthazama/re5/em84/48.wav",75,nil,true)
					end
				end)
				for i = 0,9 do
					timer.Simple(i *0.88,function()
						if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "flinch_chest2" then
							sound.Play(VJ.PICK(deviceDmgSnds),sdPos,75)
							local bonePos,boneAng = self:GetBonePosition(self:LookupBone("bone15"))
							bonePos = bonePos +self:GetForward() *10
							local effectData = EffectData()
							effectData:SetOrigin(bonePos)
							effectData:SetNormal((self:GetPos() -bonePos):GetNormalized())
							util.Effect("StunstickImpact",effectData)
						end
					end)
				end
			end
		end)
		self.NextBulletFlinchT = CurTime() +(dur *(pickedAnim == "flinch_chest2" && 0.35 or 1))
	elseif isDeadlyDMG then
		self:ResetAI()
		VJ.EmitSound(self,deviceDmgSnds,70)
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		self:SetMaxYawSpeed(0)
		self:PlayAnim("stagger_fall",true,false,true,0,{OnFinish=function(interrupted)
			if self.LastSequence != "stagger_fall" then return end
			self:PlayAnim("ground_idle",true,false,false,0,{OnFinish=function(interrupted)
				if self.LastSequence != "ground_idle" then return end
				VJ.EmitSound(self,deviceDmgSnds,70)
				self:SetMaxYawSpeed(self.TurningSpeed)
				local _,dur = self:PlayAnim("ground_recover2",true,false,false,0,{OnFinish=function(interrupted)
					if self.LastSequence != "ground_recover2" then return end
					self:SetState()
				end})
				for i = 0,9 do
					timer.Simple(i *0.83,function()
						if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "ground_recover2" then
							local bonePos,boneAng = self:GetBonePosition(self:LookupBone("bone15"))
							bonePos = bonePos +self:GetForward() *10
							sound.Play(VJ.PICK(deviceDmgSnds),bonePos,75)
							local effectData = EffectData()
							effectData:SetOrigin(bonePos)
							effectData:SetNormal((self:GetPos() -bonePos):GetNormalized())
							util.Effect("StunstickImpact",effectData)
						end
					end)
				end
				self:PlaySound(self.SoundTbl_PainDevice,75,nil,true)
				timer.Simple(dur *0.38,function()
					if IsValid(self) && self:GetSequenceName(self:GetSequence()) == "ground_recover2" then
						self:PlaySound(self.SoundTbl_RecoverDevice,75,nil,true)
					end
				end)
			end})
		end})
	elseif isExplosion && !self.DisableExplosionStagger then
		self:ResetAI()
		self:SetAngles(Angle(0,(dmginfo:GetDamagePosition() -self:GetPos()):Angle().y,0))
		self:PlaySound(self.SoundTbl_PainExplosion,75,nil,true)
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		self:SetMaxYawSpeed(0)
		self:PlayAnim("stagger_explosion" .. math.random(1,2),true,false,false,0,{OnFinish=function(interrupted)
			if self.LastSequence != "stagger_explosion1" && self.LastSequence != "stagger_explosion2" then return end
			self:PlayAnim("ground_idle",true,false,false,0,{OnFinish=function(interrupted)
				if self.LastSequence != "ground_idle" then return end
				self:PlaySound(self.SoundTbl_Recover,75,nil,true)
				self:SetMaxYawSpeed(self.TurningSpeed)
				self:PlayAnim("ground_recover1",true,false,true,0,{OnFinish=function(interrupted)
					if self.LastSequence != "ground_recover1" then return end
					self:SetState()
				end})
			end})
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
		VJ.EmitSound(self,"cpthazama/re5/em84/" .. math.random(1,2) .. ".wav",(self.FootstepSoundLevel or 65),self:GetSoundPitch(self.FootstepSoundPitch))
	end
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
function ENT:ResetAI()
	self:SetState()
	self:SetMaxYawSpeed(self.TurningSpeed)
	-- self:StopMoving()
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
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

	self.WeaponSprayActive = false
	self.InGunState = false
	self:SetBodygroup(self:FindBodygroupByName("weapons"),0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeActivity(newAct)
	self.LastActivity = self:GetActivity()
	self.LastSequence = self:GetSequenceName(self:GetSequence())
end