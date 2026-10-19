DEFINE_BASECLASS("tfa_gun_base")
SWEP.Skins = {}
SWEP.Skin = ""
SWEP.Callback = {}
SWEP.VMPos = Vector(0.879, 0.804, -1)
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse
SWEP.ProceduralHolsterEnabled = true
SWEP.ProceduralHolsterTime = 0.0
SWEP.ProceduralHolsterPos = Vector(0, 0, 0)
SWEP.ProceduralHolsterAng = Vector(0, 0, 0)
SWEP.NoStattrak = false
SWEP.NoNametag = false
SWEP.TracerCount = 1
SWEP.TracerName = "tfa_tracer_csgo" -- Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerDelay		= 0.0 --Delay for lua tracer effect
SWEP.IsTFACSGOWeapon = true

--These are particle effects INSIDE a pcf file, not PCF files, that are played when you shoot.

TFA = TFA or {}
TFA.CSGO = TFA.CSGO or {}
TFA.CSGO.Skins = TFA.CSGO.Skins or {}

function SWEP:Initialize()
	BaseClass.Initialize(self)


	if SERVER then
		self:CallOnClient("ReadSkin", "")
	end
end

local bgcolor = Color(0, 0, 0, 255 * 0.78)
local btntextcol = Color(191, 191, 191, 255 * 0.9)
local btntextdisabledcol = Color(63, 63, 63, 255 * 0.9)

local emptyFunc = function() end

local SkinMenuFrame

local sp = game.SinglePlayer()





SWEP.LerpLight = Vector(1, 1, 1)

SWEP.VElements = nil

local stattrak_cv = GetConVar("cl_tfa_csgo_stattrack") or CreateClientConVar("cl_tfa_csgo_stattrack", 1, true, true)
local dostattrak


local nametag_cv = GetConVar("cl_tfa_csgo_nametag") or CreateClientConVar("cl_tfa_csgo_nametag", 1, true, true)
local donametag


local shells_cv = GetConVar("cl_tfa_csgo_2dshells") or CreateClientConVar("cl_tfa_csgo_2dshells", 1, true, true)

local shellsoverride
function SWEP:UpdateShells()
	if SERVER then
		shellsoverride = (IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and self:GetOwner():GetInfoNum(shells_cv:GetName(), 0) > 0) and "tfa_shell_csgo" or nil
	else
		shellsoverride = shells_cv:GetBool() and "tfa_shell_csgo" or nil
	end

	local statname = "ShellEffectOverride"

	if self:GetStat(statname) ~= shellsoverride then
		self.ShellEffectOverride = shellsoverride
		self:ClearStatCache(statname)
	end
end

function SWEP:MakeShell(...)
	self:UpdateShells()

	return BaseClass.MakeShell(self, ...)
end

function SWEP:Think2(...)
	if ((CLIENT and IsValid(LocalPlayer()) and LocalPlayer() ~= self.Owner) or SERVER) and self.Skin ~= self:GetNWString("skin") then
		self.Skin = self:GetNWString("skin")
		self:UpdateSkin()
	end



	BaseClass.Think2(self, ...)
end

function SWEP:SetBodyGroupVM(k, v)
	if isstring(k) then
		local vals = k:Split(" ")
		k = vals[1]
		v = vals[2]
	end

	self.Bodygroups_V[k] = v

	if SERVER then
		self:CallOnClient("SetBodyGroupVM", "" .. k .. " " .. v)
	end
end

local cv_chamber = GetConVar("sv_tfa_csgo_chambering") or CreateConVar("sv_tfa_csgo_chambering", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow round-in-the-chamber on TFA CS:GO weapons?")

function SWEP:CanChamber(...)
	if not cv_chamber:GetBool() then return false end

	return BaseClass.CanChamber(self, ...)
end
