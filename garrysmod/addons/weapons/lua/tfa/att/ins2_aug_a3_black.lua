if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Black Finish"
ATTACHMENT.Description = { Color(256, 256, 256), "A black finish for your bullet spewer."}
ATTACHMENT.Icon = "entities/tfa_ins2_aug_a3_black.png"
ATTACHMENT.ShortName = "BLACK"

ATTACHMENT.WeaponTable = {}

ATTACHMENT.MaterialTable = {
	[1] = "models/weapons/aug/skins/black/a3_body",
	[2] = "models/weapons/aug/skins/black/a3_magazine",
}

function ATTACHMENT:Attach(wep)
	wep.MaterialTable = wep.MaterialTable or {}
	wep.MaterialTable[1] = self.MaterialTable[1]
	wep.MaterialTable[2] = self.MaterialTable[2]
	wep.MaterialCached = false
end

function ATTACHMENT:Detach(wep)
	wep.MaterialTable = wep.MaterialTable or {}
	wep.MaterialTable[1] = nil
	wep.MaterialTable[2] = nil
	wep.MaterialCached = false
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
