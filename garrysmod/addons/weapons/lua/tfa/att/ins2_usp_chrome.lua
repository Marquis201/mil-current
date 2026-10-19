if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Chrome Finish"
ATTACHMENT.Description = { TFA.AttachmentColors["+"], "Chrome", "Shiny" }
ATTACHMENT.Icon = "entities/tfa_ins2_usp_match_chrome.png"
ATTACHMENT.ShortName = "CHROME"

ATTACHMENT.WeaponTable = {
	MaterialTable_V = {
		[1] = "models/weapons/tfa_ins2/usp_match/skins/chrome/usp_weapon",
		[2] = "models/weapons/tfa_ins2/usp_match/skins/chrome/usp_match",
	},
	MaterialTable_W = {
		[1] = "models/weapons/tfa_ins2/usp_match/skins/chrome/usp_weapon",
		[2] = "models/weapons/tfa_ins2/usp_match/skins/chrome/usp_match",
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
