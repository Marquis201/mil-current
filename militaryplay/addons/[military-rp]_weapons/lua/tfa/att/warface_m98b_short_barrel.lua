if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Short Barrel"
ATTACHMENT.ShortName   = "Short"

ATTACHMENT.Icon        = "entities/warface_m98b_short_barrel.png" 

ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Increases Fire Rate", "Increases Spread Recovery", "Decreases Aim Time", "+5% Move Speed", "+5% Aim Move Speed",  
TFA.AttachmentColors["-"], "Increases Recoil", "Decreases Damage", "Decreases Range", "+15% Spread", "+15% Aim Spread",
}

ATTACHMENT.WeaponTable = {

	["Bodygroups_V"] = {
		[2] = 1
	},
	
	["Bodygroups_W"] = {
		[1] = 1
	},
	
	["ViewModelBoneMods"] = {
		["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -9), angle = Angle(0, 0, 0) },
		["A_Suppressor"] = { scale = Vector(1.07, 1.07, 1.07), pos = Vector(0, 0, -9), angle = Angle(0, 0, 0) },
    },
	
    ["WorldModelBoneMods"] = {
		["ATTACH_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(-10, 0.1, -0.3), angle = Angle(0, 0, 0) },
	},
	
	["Primary"] = {
		["IronAccuracy"] = function(wep,stat) return stat * 1.05 end,
		["Spread"] = function(wep,stat) return stat * 1.15 end,
		["SpreadRecovery"] = function(wep,stat) return stat * 1.15 end,
		
		["Damage"] = function(wep,stat) return stat * 0.89 end,
		["Range"] = function(wep,stat) return stat * 0.85 end,
	    ["RPM"] = function(wep,stat) return stat + 7 end,

		["KickUp"] = function(wep,stat) return stat * 1.11 end,
		["KickDown"] = function(wep,stat) return stat * 1.11 end,
	    ["KickHorizontal"] = function(wep,stat) return stat * 1.11 end,
	},
	
	["MoveSpeed"] = function(wep,stat) return stat * 1.06 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 1.06 end,
	["IronSightTime"] = function(wep, val) return val * 0.9 end,
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end