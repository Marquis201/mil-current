if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Afghanistan Veteran"
ATTACHMENT.Description = {
	Color(209, 209, 209), "- We're 100% VETERAN.",
	Color(255, 255, 255), "- Me too."
}
ATTACHMENT.ShortName = "GUERILLA"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/aks74ukorveteran/weapon_aks74u_dm"
		},
		["foregrip"] = {
			material = "models/tfa_ins2_wpns/aks74ukorveteran/weapon_woodgrips_dm"
		}
	},
	["WElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/aks74ukorveteran/weapon_w_aks74u_dm"
		}
	},
	["MaterialTable_V"] = {
		[1] = "models/tfa_ins2_wpns/aks74ukorveteran/weapon_aks74u_dm"
	},
	["MaterialTable_W"] = {
		[1] = "models/tfa_ins2_wpns/aks74ukorveteran/weapon_w_aks74u_dm"
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end