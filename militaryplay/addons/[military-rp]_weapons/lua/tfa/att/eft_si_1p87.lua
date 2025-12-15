if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Mechanical Sight"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["="], "5% higher zoom", 
TFA.AttachmentColors["+"], "5% lower zoom time" 
}
ATTACHMENT.Icon = "entities/ms.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "1P87"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_1p87"] = {
			["active"] = function(wep, val) TFA.INS2.AnimateSight(wep) return true end,
			["ins2_sightanim_idle"] = "idle",
			["ins2_sightanim_iron"] = "zoom",
		},
		["sight_1p87_lens"] = {
			["active"] = true
		},
		["carryhandle"] = {
			["active"] = false
		},
		["sights_base_f"] = {
			["active"] = false
		},
		["sights_base_r"] = {
			["active"] = false
		},
		["sights_base_folded_f"] = {
			["active"] = true
		},
		["sights_base_folded_r"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_1p87"] = {
			["active"] = true
		},
		["sights_folded"] = {
			["active"] = false
		},
		["sight_1p87_lens"] = {
			["active"] = true
		}
	},
	["IronSightsPos"] = function( wep, val ) return wep.IronSightsPos_1P87 or val end,
	["IronSightsAng"] = function( wep, val ) return wep.IronSightsAng_1P87 or val end,
	["Secondary"] = {
		["IronFOV"] = function( wep, val ) return wep.Secondary.IronFOV_1P87 or val * 0.95 end
	},
	["IronSightTime"] = function( wep, val ) return val * 0.95 end,
	["INS2_SightVElement"] = "sight_1p87",
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
