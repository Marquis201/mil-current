if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Laser Railed"
ATTACHMENT.ShortName   = "LASRR"
ATTACHMENT.Icon        = "entities/ins2_att_ub_laser.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "Laser + Flashlight Modules", 
    TFA.AttachmentColors["+"], "Improved laser visible distance", 
    TFA.AttachmentColors["+"], "20% lower base spread", 
    TFA.AttachmentColors["+"], "20% lower base spread", 
    TFA.AttachmentColors["-"], "15% higher max spread", 
}

ATTACHMENT.WeaponTable = {

	["VElements"] = {
		["laser"] = {
			["active"] = true
		},
		
		["laser_modkit"] = {
			["active"] = true
		},
		
		["laser_beam"] = {
			["active"] = true
		}
	},
	
	["WElements"] = {
		["laser"] = {
			["active"] = true
		},
		
		["laser_beam"] = {
			["active"] = true
		}
	},
	
	["Primary"] = {
		["Spread"] = function(wep,stat) return math.max( stat * 0.8, stat - 0.01 ) end,
		["SpreadMultiplierMax"] = function(wep,stat) return stat * ( 1 / 0.8 ) * 1.15 end
	},
	
	["LaserSightAttachment"]      = function(wep,stat) return wep.LaserSightModAttachment end,
	["LaserSightAttachmentWorld"] = function(wep,stat) return wep.LaserSightModAttachmentWorld or wep.LaserSightModAttachment end,

	["LaserDistance"]        = 12 * 150,
--	["LaserDistanceVisual"]  = 12 * 4,
	["laserFOV"]             = 0.8,

	["FlashlightAttachment"] = 1,
	["FlashlightDistance"]   = 10 * 80,
	["FlashlightBrightness"] = 8,
	["FlashlightFOV"]        = 50,
	
	FlashlightSoundToggleOn  = Sound("TFA_INS2.FlashlightOn"),
	FlashlightSoundToggleOff = Sound("TFA_INS2.FlashlightOff"),
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end