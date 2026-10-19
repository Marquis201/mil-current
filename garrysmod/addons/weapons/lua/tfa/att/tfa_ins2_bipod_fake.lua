if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = CLIENT and "#insurgency_weapon_upgrade_bipod" or "Bipod"
ATTACHMENT.Description = { TFA.AttachmentColors["="], "Just a cosmetic attachment", "(this time I didn't succeed in implementing a fully functioning bipod)." }
ATTACHMENT.Icon = "entities/ins2_att_ub_bipod.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "BIPOD"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["bipod"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["bipod"] = {
			["active"] = true
		}
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
