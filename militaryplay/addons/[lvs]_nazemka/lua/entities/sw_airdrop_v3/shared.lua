ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Category = "MP Bombs | RU"
ENT.ClassName = "sw_airdrop_v3"

ENT.PrintName = "Care package"

ENT.Spawnable = true
function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Open" )
	self:NetworkVar( "Float", 1, "HP")
	self:SetHP(250)
end