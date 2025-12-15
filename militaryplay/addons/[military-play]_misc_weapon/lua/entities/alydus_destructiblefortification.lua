 --[[
 - Destructible Fortifications Extension for Fortification Builder Tablet
 - 
 - /lua/entities/alydus_destructablefortification.lua
 - 
 - Feel free to modify, but please leave appropriate credit.
 - Do not reupload this (modified or original) to this workshop, however you may ruin modified versions on your servers.
 -
 - Thanks so much for the support with the addon since it's creation in 2018.
 -
 --]]

AddCSLuaFile()

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
else
	CreateConVar("alydus_enablefortificationdestructionmessage", 1)
end

function ENT:Initialize()
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "FortificationHealth")
	self:NetworkVar("Int", 1, "MaximumFortificationHealth")
end

function ENT:OnTakeDamage(dmg)
	if SERVER then
		local currentFortificationHealth = self:GetFortificationHealth()

		if currentFortificationHealth <= 0 then
			return false
		end

		if dmg:GetDamage() >= 1 then
			currentFortificationHealth = currentFortificationHealth - dmg:GetDamage()

			self:SetFortificationHealth(currentFortificationHealth)
		end
	end
end

function ENT:Think()
	if SERVER then
		if self.previousHealth != self:GetFortificationHealth() then
			self.previousHealth = self:GetFortificationHealth()
		end
		if self.previousHealth == 0 or self:GetFortificationHealth() <= 0 then
			self:EmitSound("physics/concrete/concrete_break2.wav")

			if GetConVar("alydus_enablefortificationdestructionmessage"):GetInt() == 1 and IsValid(self.isPlayerPlacedFortification) and self.isPlayerPlacedFortification:IsPlayer() then
				self.isPlayerPlacedFortification:ChatPrint("A fortification you owned has been destroyed!")
			end

			self:Remove()
		end
	end
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Spawnable = true

ENT.PrintName = "Destructable Fortification"
ENT.Author = "MP"
ENT.Contact = ""
ENT.Category = "Military Play | Ents"
ENT.Purpose = "A destructable fortification, can only be spawned using the fortification builder tablet."
ENT.Instructions = "Spawn by using the fortification builder tablet weapon."