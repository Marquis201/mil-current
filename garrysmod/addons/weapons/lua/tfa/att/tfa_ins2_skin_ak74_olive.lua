if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Olive Poly"
ATTACHMENT.Description = {
	Color(213, 255, 179), "- We're 100% OLIVE.",
	Color(255, 255, 255), "- Me too."
}
ATTACHMENT.ShortName = "OLIVE"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/ak74olive/weapon_ak74_dm"
		},
		["foregrip"] = {
			material = "models/tfa_ins2_wpns/ak74olive/weapon_woodgrips2_dm"
		}
	},
	["WElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/ak74olive/weapon_w_ak74_dm"
		}
	},
	["MaterialTable_V"] = {
		[1] = "models/tfa_ins2_wpns/ak74olive/weapon_ak74_dm"
	},
	["MaterialTable_W"] = {
		[1] = "models/tfa_ins2_wpns/ak74olive/weapon_w_ak74_dm"
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end