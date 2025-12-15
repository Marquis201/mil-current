if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Railed handguard"
ATTACHMENT.ShortName   = "Railed"

ATTACHMENT.Icon        = "entities/warface_cheytac_m200_railed.png" 

ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Allows Laser Attachments", "Decreases Weight",  
}

ATTACHMENT.WeaponTable = {

	["Bodygroups_V"] = {
		[2] = 1
	},
	
	["Bodygroups_W"] = {
		[2] = 1
	},
	
	["Primary"] = {
		["Spread"] = function(wep,stat) return stat * 0.95 end,
	},
	
	["MoveSpeed"] = function(wep,stat) return stat * 1.05 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 1.05 end,
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end