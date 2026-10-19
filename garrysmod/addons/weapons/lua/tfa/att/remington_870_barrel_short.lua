if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Short Barrel"
ATTACHMENT.ShortName   = "Short"

ATTACHMENT.Icon        = "entities/remington_870_barrel_short.png" 

ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "+10% Fire Rate", "+5% Move Speed", "+5% Aim Move Speed", "Decreases Aim Time", "Increases Spread Recovery",  
TFA.AttachmentColors["-"], "-10% Damage", "-10% Range", "+10% Spread", "+5% Aim Spread", "-3 Shells", "Increases Recoil" }

ATTACHMENT.WeaponTable = {

	["Bodygroups_V"] = {
		[2] = 2
	},
	
	["Bodygroups_W"] = {
		[1] = 2
	},
	
	["ViewModelBoneMods"] = {
		["b_wpn_muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 2.9, 0), angle = Angle(0, 0, 0) },
		["A_Suppressor"] = { scale = Vector(0.9, 1, 0.9), pos = Vector(0, 3.05, 0), angle = Angle(0, 0, 0) },
		["A_LaserFlashlight"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 90) },
	},
	
    ["WorldModelBoneMods"] = {
		["ATTACH_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 3.05, 0), angle = Angle(0, 0, 0) },
	},
	
	["Primary"] = {
		["IronAccuracy"] = function(wep,stat) return stat * 1.05 end,
		["Spread"] = function(wep,stat) return stat * 1.1 end,
		["SpreadRecovery"] = function(wep,stat) return stat * 1.15 end,
		["RPM"] = function(wep,stat) return stat + 28 end,
		
		["Damage"] = function(wep,stat) return stat * 0.9 end,
		["Range"] = function(wep,stat) return stat * 0.9 end,
		["KickUp"] = function(wep,stat) return stat * 1.05 end,
		["KickDown"] = function(wep,stat) return stat * 1.05 end,
		["KickHorizontal"] = function(wep,stat) return stat * 1.05 end,

		["ClipSize"] = function(wep,stat) return stat - 3 end,
	},
	
	["MoveSpeed"] = function(wep,stat) return stat * 1.05 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 1.05 end,
	["IronSightTime"] = function(wep, val) return val * 0.9 end,
}

function ATTACHMENT:Attach(wep)
	if not wep.IsFirstDeploy then
		wep:Unload()
	end
end

function ATTACHMENT:Attach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end