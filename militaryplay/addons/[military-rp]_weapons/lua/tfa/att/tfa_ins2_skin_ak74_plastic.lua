if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Green Plastic"
ATTACHMENT.Description = {
	Color(0, 100, 0), "- We're 100% GREEN.",
	Color(255, 255, 255), "- Me too."
}
ATTACHMENT.ShortName = "GREEN"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/ak74plastic/weapon_ak74_dm"
		}
	},
	["WElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/ak74plastic/weapon_w_ak74_dm"
		}
	},
	["MaterialTable_V"] = {
		[1] = "models/tfa_ins2_wpns/ak74plastic/weapon_ak74_dm"
	},
	["MaterialTable_W"] = {
		[1] = "models/tfa_ins2_wpns/ak74plastic/weapon_w_ak74_dm"
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end