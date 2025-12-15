AddCSLuaFile()

SWEP.PrintName             = "Руки"
SWEP.Author                = "pack" -- The Maw
SWEP.Purpose               = "Удерживайте левую кнопку мыши, чтобы перетащить элементы."
SWEP.Category              = "Military Play | Прочее"

SWEP.ViewModel             = "models/weapons/c_medkit.mdl"
SWEP.WorldModel            = ""

-- SWEP.Category = "Supreme"
SWEP.Spawnable             = true
SWEP.AdminOnly             = true

SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.PropMasses            = {
	['models/props_c17/gravestone004a.mdl'] = 300,
}

function SWEP:Initialize()
	self:SetHoldType("normal")

	self.Time = 0
	self.Range = 150
end

function SWEP:Think()
	if (self.Drag and (not self.Owner:KeyDown(IN_ATTACK) or not IsValid(self.Drag.Entity))) then
		self.Drag = nil
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:Tick() -- Who was shit here?
end

function SWEP:SecondaryAttack()
end

if (CLIENT) then
	local x, y = ScrW() / 2, ScrH() / 2

	function SWEP:DrawHUD()
	end
end

function SWEP:PreDrawViewModel(vm, pl, wep)
	return true
end
