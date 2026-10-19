ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true

ENT.PrintName = "Инструктор РФ"
ENT.Author = "Ozor"
ENT.Category = "Military Play | Ents"

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end