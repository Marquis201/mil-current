if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Long Barrel"
ATTACHMENT.ShortName   = "Long"

ATTACHMENT.Icon        = "entities/remington_870_barrel_long.png" 

ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "+10% Damage", "+10% Range", "-5% Spread", "-5% Aim Spread", "+2 Shells", "Decreases Recoil",
TFA.AttachmentColors["-"], "-15% Fire Rate", "-5% Move Speed", "-5% Aim Move Speed", "Increases Aim Time", "Decreases Spread Recovery" } 

ATTACHMENT.WeaponTable = {

	["Bodygroups_V"] = {
		[2] = 1
	},
	
	["Bodygroups_W"] = {
		[1] = 1
	},
	
	["ViewModelBoneMods"] = {
		["b_wpn_muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, -3.1, 0), angle = Angle(0, 0, 0) },
		["A_Suppressor"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, -3, 0), angle = Angle(0, 0, 0) },
	},
	
    ["WorldModelBoneMods"] = {
		["ATTACH_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, -3.2, 0), angle = Angle(0, 0, 0) },
	},

	["Primary"] = {
		["IronAccuracy"] = function(wep,stat) return stat * 0.95 end,
		["Spread"] = function(wep,stat) return stat * 0.95 end,
		["SpreadRecovery"] = function(wep,stat) return stat * 0.9 end,
		["RPM"] = function(wep,stat) return stat - 42 end,
		
		["Damage"] = function(wep,stat) return stat * 1.1 end,
		["Range"] = function(wep,stat) return stat * 1.1 end,
		["KickUp"] = function(wep,stat) return stat * 0.95 end,
		["KickDown"] = function(wep,stat) return stat * 0.95 end,
		["KickHorizontal"] = function(wep,stat) return stat * 0.95 end,
		
		["ClipSize"] = function(wep,stat) return stat + 2 end,
	},
	
	["MoveSpeed"] = function(wep,stat) return stat * 0.95 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 0.95 end,
	["IronSightTime"] = function(wep, val) return val * 1.1 end,
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