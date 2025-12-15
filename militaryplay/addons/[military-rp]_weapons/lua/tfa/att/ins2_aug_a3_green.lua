if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Green Finish"
ATTACHMENT.Description = { Color(34, 139, 34), "A green finish for your lovely weapon."}
ATTACHMENT.Icon = "entities/tfa_ins2_aug_a3_green.png"
ATTACHMENT.ShortName = "GREEN"

ATTACHMENT.WeaponTable = {}

ATTACHMENT.MaterialTable = {
	[1] = "models/weapons/aug/skins/green/a3_body",
	[2] = "models/weapons/aug/skins/green/a3_magazine",
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
