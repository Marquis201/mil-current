AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2025 by Cpt. Hazama,All rights reserved. ***
	No parts of this code or any of its contents may be reproduced,copied,modified or adapted,
	without the prior written consent of the author,unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/cpthazama/re5/em82a.mdl"
-- ENT.SoundTbl_SoundTrack = {"cpthazama/re5/wesker_uroboros.mp3"}

ENT.DamageMultiplier = 1.5
ENT.AdditionalControllerInstructions = {
	"[Passive] Due to PG67A/W overdose, Wesker's regenerative abilities are reduced",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit()
	self:SetBodygroup(self:FindBodygroupByName("glasses"),1)
	self:SetMaxHealth(self:Health() *1.35)
	self:SetHealth(self:GetMaxHealth())
	self.HealthRegenParams.Delay = VJ.SET(1,1)
	self.HasDoneSpeech = true

	self.Immune_Fire = true
	self.GodMode = true
	self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
	self:AddFlags(FL_NOTARGET)
	timer.Simple(0,function()
		if IsValid(self) then
			local _,dur = self:PlayAnim("stagger_idle",true,false,false,0,{OnFinish=function()
				self:PlaySound("cpthazama/re5/em82/intro1.wav",90,nil,true)
				self:PlayAnim("stagger_to_idle",true,false,false,0,{OnFinish=function()
					self:SetState()
					self:PlaySound("cpthazama/re5/em82/intro2.wav",90,nil,true)
					self.Immune_Fire = false
					self.GodMode = false
					self:RemoveFlags(FL_NOTARGET)
				end})
			end})
			self:Ignite(dur *2)
			self:PlaySound("cpthazama/re5/em82/53.wav",90,nil,true)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Taunt()
	if self:IsBusy("Activities") or CurTime() < (self.NextTauntT or 0) then return end
	local _,dur = self:PlayAnim("taunt1",true,false,false)
	self:PlaySound({"cpthazama/re5/em82/intro1.wav","cpthazama/re5/em82/intro2.wav"},75,nil,true)
	self.NextTauntT = CurTime() +dur
end