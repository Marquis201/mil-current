AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2025 by Cpt. Hazama,All rights reserved. ***
	No parts of this code or any of its contents may be reproduced,copied,modified or adapted,
	without the prior written consent of the author,unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/cpthazama/re5/em82.mdl"
ENT.StartHealth = 5000
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.HealthRegenParams = {
	Enabled = true,
	Amount = 20,
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

local atkDefault = {
	"attack_right1"
}
local atkDefaultBoth = {
	"attack_right1",
	"attack_left1",
	"attack_left2",
}
ENT.AnimTbl_MeleeAttack = atkDefault
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 90

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100
ENT.FootStepPitch1 = 95
ENT.FootStepPitch2 = 110

ENT.HasSoundTrack = true
-- ENT.SoundTbl_SoundTrack = {"cpthazama/re5/wesker_uroboros.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.DeleteSounds = {}
	self.CurrentAttackSound = nil

	self.MouthT = 0
	self.NextMouthMoveT = 0

	self.T_AttackWhipLoop = self:GetSequenceActivity(self:LookupSequence("attack_whip_loop"))

    for attName, var in pairs(self.FootData) do
        var.AttID = self:LookupAttachment(attName)
    end

	self:SetBodygroup(self:FindBodygroupByName("tentacles_side"),1)
	self:SetBodygroup(self:FindBodygroupByName("metal_left"),1)
	-- self:SetBodygroup(self:FindBodygroupByName("metal_right"),1)

	timer.Simple(0,function()
		if !IsValid(self) then return end
		local _,dur = self:PlayAnim("intro",true,false,false)
		self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK,dur)
		timer.Simple(dur *0.065,function()
			if IsValid(self) then
				self:PlaySound("cpthazama/re5/em82/intro1.wav",90,nil,true)
			end
		end)
		timer.Simple(dur *0.18,function()
			if IsValid(self) then
				util.ScreenShake(self:GetPos(), 12, 150, 1, 1000)
			end
		end)
		timer.Simple(dur *0.62,function()
			if IsValid(self) then
				self:PlaySound("cpthazama/re5/em82/53.wav",90,nil,true)
			end
		end)
		timer.Simple(dur *0.93,function()
			if IsValid(self) then
				self:PlaySound("cpthazama/re5/em82/intro2.wav",90,nil,true)
			end
		end)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key)
	-- print("Input: ",key)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self.InLargeAttackState then
		if (act == ACT_WALK or act == ACT_RUN) then
			return ACT_RUN
		elseif act == ACT_IDLE then
			return ACT_IDLE_STIMULATED
		end
	end
	if self.Atk_WhipActive && (act == ACT_IDLE or act == ACT_WALK or act == ACT_RUN) then
		return self.T_AttackWhipLoop
	end
	if (act == ACT_WALK or act == ACT_RUN) then
		return ACT_WALK
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

	ply:ChatPrint("Wesker (Uroboros) Controls:")
	-- ply:ChatPrint("Press [LEFT-MOUSE] to attack / fire pistol")
	-- ply:ChatPrint("Hold [RIGHT-MOUSE] to toggle between melee and pistol")
	-- ply:ChatPrint("Press [E + L-ALT] to throw knife")
	-- ply:ChatPrint("Press [R] to taunt")
	-- ply:ChatPrint("Hold [SPACE] to dodge / parry")

	function controlEnt:OnThink()
		self.VJC_NPC_CanTurn = self.VJC_Camera_Mode == 2
		self.VJC_BullseyeTracking = self.VJC_Camera_Mode == 2
	end

	function controlEnt:CustomOnStopControlling()
		local valid = IsValid(npc)
		if valid then
			npc.JumpParams.Enabled = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(isAttacking, ent)
	local data = self.EnemyData
	local visible = data.Visible
	local dist = data.DistanceNearest
	local curTime = CurTime()
	local cont = self.VJ_TheController

	if (!IsValid(cont) && math.random(1,150) == 1 && visible && dist <= 700 or IsValid(cont) && cont:KeyDown(IN_ATTACK2)) && !self.Atk_WhipActive then
		self.Atk_WhipActive = true
		self.HasMeleeAttack = false
		local _,dur = self:PlayAnim("attack_whip_start",true,false,false)
		self.Atk_WhipActiveTime = curTime +dur +math.Rand(8,15)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Atk_WhipActive && CurTime() > self.Atk_WhipActiveTime then
		self.Atk_WhipActive = false
		self.HasMeleeAttack = true
		self:PlayAnim("attack_whip_end",true,false,false)
	end
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

	-- if self.MouthT > CurTime() && self.NextMouthMoveT < CurTime() then
	-- 	local _,dur = self:VJ_ACT_PLAYACTIVITY("vjges_talk",false,false,false,0,{AlwaysUseGesture=true})
	-- 	local alt = math.Rand(0.3,1)
	-- 	if CurTime() -self.MouthT <= dur then
	-- 		alt = 1
	-- 	end
	-- 	self.NextMouthMoveT = CurTime() +(dur *alt)
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- local hitgroupAnims = {
-- 	[HITGROUP_HEAD] = "flinch_head1",
-- 	[HITGROUP_CHEST] = {"flinch_chest1","flinch_chest2"},
-- 	[HITGROUP_LEFTARM] = {"flinch_left1","flinch_left2"},
-- 	[HITGROUP_RIGHTARM] = {"flinch_right1","flinch_right2"},
-- }
-- local defFlinch = {"flinch_chest1","flinch_chest2"}
-- --
-- function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
-- 	local dmgtype = dmginfo:GetDamageType()
-- 	local isBullet = bit.band(dmgtype, DMG_BULLET) == DMG_BULLET
-- 	if isBullet && self:GetSequenceName(self:GetSequence()) == "parry_rocket" && IsValid(self.ParryRocketEntity) && self.ParryRocketEntity.Alive then
-- 		local fx = EffectData() -- Explosion
-- 		fx:SetOrigin(self:GetPos() +self:OBBCenter())
-- 		fx:SetScale(1.5)
-- 		util.Effect("Explosion",fx,true,true)
-- 		self:SetState()
-- 		SafeRemoveEntity(self.ParryRocketEntity)
-- 		self:PlayAnim("parry_rocket_exploded",true,false,false)
-- 	end
-- 	local isExplosion = bit.band(dmgtype, DMG_BLAST) == DMG_BLAST
-- 	if isBullet && CurTime() > (self.SprintT or 0) && CurTime() > (self.NextBulletFlinchT or 0) && math.random(1,10) == 1 then
-- 		local anim = hitgroupAnims[hitgroup] or defFlinch
-- 		local _,dur = self:PlayAnim(VJ.PICK(anim),true,false,false)
-- 		self.NextBulletFlinchT = CurTime() +(dur *0.35)
-- 	elseif isExplosion then
-- 		self:PlayAnim("flinch_explosion",true,false,true)
-- 	end
-- end
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