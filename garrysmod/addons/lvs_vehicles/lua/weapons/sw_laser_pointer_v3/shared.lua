AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.MaxPairDistance = 500^2
SWEP.Category = "Military Play | Прочее"
SWEP.Author = "Shermann Wolf"
SWEP.Contact = "shermannwolf@gmail.com"
SWEP.Purpose = ""
SWEP.Instructions = "Right click on bomb/missile/aircraft to pair it with your laser pointer,and left click to point target for it"
SWEP.PrintName = "Laser target designator"
SWEP.WorldModel = "models/sw/shared/weapons/w_binoculars.mdl"
SWEP.ViewModel = "models/sw/shared/weapons/v_binoculars.mdl"
SWEP.TarPos = nil
SWEP.Primary = {
	Ammo 		= "None",
	ClipSize 	= -1,
	DefaultClip = -1,
	Automatic 	= false,
	NextShot	= 0,
	FireRate	= 0.00001
}
SWEP.Secondary = SWEP.Primary
SWEP.NextReload = 0
SWEP.DrawAmmo = false
SWEP.Zoom = {}
SWEP.Zoom.FOV = 70
SWEP.Zoom.Rate = 0.035
SWEP.Zoom.Val = 0
SWEP.UseHands = true
local pairs = pairs
local IsValid = IsValid
local CLIENT = CLIENT
local SERVER = SERVER
local SINGLEPLAYER = game.SinglePlayer()
function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end
function SWEP:Initialize()
	self:SetNWEntity("PairedObj",nil)
	self:SetNWEntity("Projectile",nil)
	self:SetNWBool("Paired",false)
	self:SetHoldType("camera")
end
function SWEP:Holster(wep)
	return true
end
function SWEP:DrawHUD()
	surface.SetDrawColor(0,0,0,self.Zoom.Val*255)
	surface.SetTexture(surface.GetTextureID("models/sw/shared/sights/binoculars"))
	local X = ScrW()
	local Y = ScrH()
	surface.DrawTexturedRect(0,-(X-Y)/2,X,X)
end
function SWEP:CalcViewModelView(ViewModel,OldEyePos)
	if self.Zoom.Val > 0.8 then
		return Vector(0,0,0)
	else
		return OldEyePos - Vector(0,0,1.3)
	end
end
function SWEP:Think()
	local keydown = self.Owner:KeyDown(IN_ATTACK2)
	self.Zoom.Val = math.Clamp(self.Zoom.Val + (keydown and 0.1 or -0.1),0,1)
	if keydown and not self.IsZooming then
		self.IsZooming = true
		self.IsUnZooming = false
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	elseif !keydown and not self.IsUnZooming and self.IsZooming then
		self.IsZooming = false
		self.IsUnZooming = true		
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
end
function SWEP:CalcView(ply,pos,ang,fov)
	fov = fov - (self.Zoom.Val*self.Zoom.FOV)
	return pos,ang,fov
end
function SWEP:AdjustMouseSensitivity()
	return self.Owner:KeyDown(IN_ATTACK2) and 0.1 or 1
end
function SWEP:CanPrimaryAttack(ct)
	return self.Primary.NextShot <= ct
end
function SWEP:PrimaryAttack()
	local ct = CurTime()
	if not self:CanPrimaryAttack(ct) then return end
	self.Primary.NextShot = ct + self.Primary.FireRate
end
function SWEP:CanSecondaryAttack(ct)
end
function SWEP:SecondaryAttack()
end
function SWEP:CanReload(ct)
end
function SWEP:Reload()
end