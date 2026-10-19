if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "No Stock"
ATTACHMENT.ShortName   = "Stock"

ATTACHMENT.Icon        = "entities/remington_870_nostock.png" 

ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "+10% Move Speed", "+10% Aim Move Speed", "Decreases Aim Time", "Increases Reload Speed",  
TFA.AttachmentColors["-"], "+25% Recoil", "+25% Spread", "+25% Aim Spread" }

ATTACHMENT.WeaponTable = {

	["Bodygroups_V"] = {
		[3] = 1
	},
	
	["Bodygroups_W"] = {
		[2] = 1
	},
	
	["Primary"] = {
		["IronAccuracy"] = function(wep,stat) return stat * 1.25 end,
		["Spread"] = function(wep,stat) return stat * 1.25 end,
		
		["KickUp"] = function(wep,stat) return stat * 1.25 end,
		["KickDown"] = function(wep,stat) return stat * 1.25 end,
		["KickHorizontal"] = function(wep,stat) return stat * 1.25 end,
	},
	
	["MoveSpeed"] = function(wep,stat) return stat * 1.1 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 1.1 end,
	["ShellTime"] = function(wep,stat) return stat * 0.95 end,
	["IronSightTime"] = function(wep, val) return val * 0.9 end,
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end