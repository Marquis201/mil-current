AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "EFT Popper Laptop"
ENT.Category = "Fun + Games"
ENT.Author = "Darsu"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props/darsu_eft/laptop.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)

		self.NextUse = 0
		self.PoppersState = false
	end

	function ENT:PopDown()
		self:ResetSequence("down")
		self:EmitSound(
		table.Random({ "darsu_eft/arena_shooting_range_popper_fold.wav",
			"darsu_eft/arena_shooting_range_popper_fold2.wav", "darsu_eft/arena_shooting_range_popper_fold3.wav" }), 55)
		-- self:SetSolid(SOLID_NONE)
	end

	function ENT:PopUp()
		self:ResetSequence("up")
		-- self:SetSolid(SOLID_VPHYSICS)
		self:EmitSound("darsu_eft/shooting_range_popper_unfold.wav", 55)
	end

	function ENT:Use(activator, caller)
		if CurTime() < self.NextUse then return end

		self:EmitSound("darsu_eft/shooting_range_notebook_key.wav")

		self.NextUse = CurTime() + 0.5

		self.PoppersState = ! self.PoppersState

		for _, ent in ents.Iterator() do
			if ent:GetClass() == "sent_eft_popper" then
				if self.PoppersState then ent:PopDown(true) else ent:PopUp() end
			end
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
