ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.SW_ENT = true
ENT.PrintName = "Parachute"
ENT.Author = "Shermann Wolf"
ENT.Category = "MP Bombs | RU"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Open" )
	self:NetworkVar( "Int",1, "RopeLength", { KeyName = "ropelength", Edit = { type = "Int", order = 1,min = 0, max = 2500, category = "Misc"} } )
	self:NetworkVar( "Bool", 2, "AutoMode", { KeyName = "automode", Edit = { type = "Bool", category = "Misc"} } )
	self:SetRopeLength(50)
end