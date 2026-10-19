if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Guerilla"
ATTACHMENT.Description = {
	Color(218, 198, 132), "- We're 100% GUERILLA.",
	Color(255, 255, 255), "- Me too."
}
ATTACHMENT.ShortName = "GUERILLA"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/aks74ukorguerilla/weapon_aks74u_dm"
		},
		["foregrip"] = {
			material = "models/tfa_ins2_wpns/aks74ukorguerilla/weapon_woodgrips_dm"
		}
	},
	["WElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/aks74ukorguerilla/weapon_w_aks74u_dm"
		}
	},
	["MaterialTable_V"] = {
		[1] = "models/tfa_ins2_wpns/aks74ukorguerilla/weapon_aks74u_dm"
	},
	["MaterialTable_W"] = {
		[1] = "models/tfa_ins2_wpns/aks74ukorguerilla/weapon_w_aks74u_dm"
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end