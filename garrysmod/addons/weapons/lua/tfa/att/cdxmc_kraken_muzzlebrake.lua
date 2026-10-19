if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Muzzle Brake"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = {
	TFA.AttachmentColors["+"], "50% less recoil",
	TFA.AttachmentColors["-"], "10% less damage",
	TFA.AttachmentColors["-"], "20% less bullet velocity",
}
ATTACHMENT.Icon = "entities/tfa_ins2_mbrake.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "MBRK2"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["mbrake2"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["mbrake2"] = {
			["active"] = true
		}
	},
	["Primary"] = {
		["Damage"] = function(wep,stat) return stat * 0.9 end,
		["Recoil"] = function(wep,stat) return stat * 0.5 end,
	},
}


if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
