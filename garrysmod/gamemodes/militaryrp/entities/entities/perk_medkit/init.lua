AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/sw/shared/backpack.mdl')

	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local pObj = self:GetPhysicsObject()
	pObj:EnableGravity(false)
	pObj:EnableMotion(false)
	pObj:EnableDrag(false)
	self:StartMotionController()
	self:PhysWake()
	self:DropToFloor()

	self:SetNWInt("perk_armor_amount", 10)
	self:SetNWFloat("perk_armor_remove", CurTime() + 300)

	timer.Simple(300, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
end

function ENT:Use(pl)
	local health = pl:Health()
	local maxhealth = pl:GetMaxHealth()

	if health >= maxhealth then
		mp.util.Notify(pl, NOTIFY_ERROR, "У вас максимально здоровья!")
		return
	end
	local amount = self:GetNWInt("perk_armor_amount")

	amount = amount - 1

	self:EmitSound("items/ammo_pickup.wav", 60, 110, .5, CHAN_AUTO)

	pl:SetHealth(maxhealth)

	local stats = mp.body_stats
	local val = .25
	pl.Head = math.Clamp(pl.Head + stats.head * val, 0, stats.head)
	pl.Torso = math.Clamp(pl.Torso + stats.torso * val, 0, stats.torso)
	pl.LeftArm = math.Clamp(pl.LeftArm + stats.l_arm * val, 0, stats.l_arm)
	pl.RightArm = math.Clamp(pl.RightArm + stats.r_arm * val, 0, stats.r_arm)
	pl.LeftLeg = math.Clamp(pl.LeftLeg + stats.l_leg * val, 0, stats.l_leg)
	pl.RightLeg = math.Clamp(pl.RightLeg + stats.r_leg * val, 0, stats.r_leg)

	pl.Blooding = false
	pl.Fracture = false
	pl.Concussion = false
	pl.Burns = false

	pl:HPUpdate()

	if amount <= 0 then
		self:Remove()
	else
		self:SetNWInt("perk_armor_amount", amount)
	end
end

function ENT:Think()

end
