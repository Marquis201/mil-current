
SWEP.Base                       = "tfa_gun_base"
SWEP.Spawnable                  = false -- Can you, as a normal user, spawn this?
SWEP.AdminSpawnable             = false -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair              = true      -- Draw the crosshair?
SWEP.PrintName                  = "TOZ"       -- Weapon name (Shown on HUD)
SWEP.Category                   = "Military Play | Оружие" -- The category.
local path 						= "models/tfa_ins2_wpns/shells/"
SWEP.LuaShellModel 				= path .. "rifleshell.mdl"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self.StatCache_Blacklist["Primary.IronAccuracy"] = true
	self:ClearStatCache()
end

function SWEP:Think2(...)
	if self.SubCategory == "Sidearms" then
		self.Primary_TFA.IronAccuracy = 0.0115
	elseif self.SubCategory == "Battle Rifles" then
		self.Primary_TFA.IronAccuracy = 0.0095
	elseif self.Type != "Sniper Rifle" and self.Type != "Shotgun" then
		self.Primary_TFA.IronAccuracy = 0.0105
	elseif self.Type == "Shotgun" then
		self.LuaShellModel = path .. "shotgunshell.mdl"
	end

	if self.Type != "Shotgun" and self.SubCategory != "Sidearms" and self.SubCategory != "Sub-Machine Guns" then
		self.LuaShellModel = path .. "rifleshell.mdl"
		self.LuaShellScale = .55
	elseif self.Type == "Sub-Machine Gun" or self.SubCategory == "Sidearms" then
		self.LuaShellModel = path .. "pistolshell.mdl"
		self.LuaShellScale = .6
	end

	BaseClass.Think2(self,...)
end