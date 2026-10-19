if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Dark Finish"
ATTACHMENT.Description = {
	Color(39, 39, 39), "- We're 100% DARK.",
	Color(255, 255, 255), "- Me too."
}
ATTACHMENT.ShortName = "BLUE"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["basegrip"] = {
			material = "models/tfa_ins2_wpns/aks74ukorblack/weapon_aks74u_dm"
		}
	},
	["MaterialTable_V"] = {
		[1] = "models/tfa_ins2_wpns/aks74ukorblack/weapon_aks74u_dm"
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end