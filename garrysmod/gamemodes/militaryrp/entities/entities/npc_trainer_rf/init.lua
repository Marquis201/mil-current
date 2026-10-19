AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/arma3/russia/soldier.mdl')

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetMaxYawSpeed(90)

	self:SetTrigger(true)

	self:SetBodygroup(2, 8)
	self:SetBodygroup(5, 0)
	--self:SetBodygroup(4, 6)
	self:SetBodygroup(5, 16)

	self:Give("tfa_ins2_wpn_ak74izh")
end

function ENT:Use(pl)
	if pl:GetNetVar("QuestPlay.Qualification") then
		net.Start("QuestPlay.ContractMenu")
		net.Send(pl)

		return
	end
	local data = mp.QuestPlay.List["start_qualification"]

	if data.check and data.check(pl) then
		net.Start("QuestPlay.QualificationMenu")
		net.Send(pl)
	end
end

function ENT:Think()
	self:ResetSequence("idle_passive")
end
