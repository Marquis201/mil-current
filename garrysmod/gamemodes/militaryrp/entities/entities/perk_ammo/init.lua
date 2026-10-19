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
	local has = false

	pl.NextUseAmmoPerk = pl.NextUseAmmoPerk or 0
	if pl.NextUseAmmoPerk > CurTime() then return end

	for _, weapon in ipairs(pl:GetWeapons()) do
		if weapon:Clip1() > 0 then
			has = true
			pl:GiveAmmo(weapon:Clip1() * 3, weapon:GetPrimaryAmmoType())
		end

		if weapon:Clip2() > 0 then
			has = true

			pl:GiveAmmo(weapon:Clip2() * 3, weapon:GetSecondaryAmmoType())
		end
	end

	if not has then pl.NextUseAmmoPerk = CurTime() + 2 return end


	local amount = self:GetNWInt("perk_armor_amount")
	amount = amount - 1

	self:EmitSound("items/ammo_pickup.wav", 60, 110, .5, CHAN_AUTO)

	if amount <= 0 then
		self:Remove()
	else
		self:SetNWInt("perk_armor_amount", amount)
	end
end

function ENT:Think()

end
