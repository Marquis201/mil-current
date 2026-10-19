include("shared.lua")

DEFINE_BASECLASS( SWEP.Base )

SWEP.StatTrakBoneCheck = false
SWEP.NameTagBoneCheck = false

function SWEP:PreDrawViewModel(vm, wep, ply)
	
	return BaseClass.PreDrawViewModel(self, vm, wep, ply)
end

local cv_dropmags = GetConVar("cl_tfa_csgo_magdrop") or CreateClientConVar("cl_tfa_csgo_magdrop", "1", true, true, "Drop magazine on weapon reload?")
local cv_maglife = GetConVar("cl_tfa_csgo_maglife") or CreateClientConVar("cl_tfa_csgo_maglife", "15",true,true, "Magazine Lifetime")

SWEP.MagLifeTime = 15

function SWEP:DropMag()
	if not cv_dropmags or not cv_dropmags:GetBool() then return end

	if not cv_maglife then
		cv_maglife = GetConVar("cl_tfa_csgo_maglifelife")
	end

	if cv_life then
		self.LifeTime = cv_life:GetInteger()
	end

	if not self.MagModel then return end

	local mag = ents.CreateClientProp()

	mag:SetModel(self.MagModel)
	mag:SetMaterial(self:GetMaterial())
	for i = 1, #self:GetMaterials() do
		mag:SetSubMaterial(i - 1, self:GetSubMaterial(i - 1))
	end -- full skin support

	local pos, ang = self:GetPos(), self:GetAngles()

	if self:IsFirstPerson() and self:VMIV() then
		local vm = self.OwnerViewModel
		ang = vm:GetAngles()
		pos = vm:GetPos() - ang:Up() * 8
	end

	mag:SetPos(pos)
	mag:SetAngles(ang)

	mag:PhysicsInit(SOLID_VPHYSICS)
	mag:PhysWake()

	mag:SetMoveType(MOVETYPE_VPHYSICS) -- we call it AFTER physics init

	mag:Spawn()

	SafeRemoveEntityDelayed(mag, self.MagLifeTime)
end