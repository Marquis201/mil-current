if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Two Tone Camo"
ATTACHMENT.Description = { TFA.AttachmentColors["+"], "a other glock variation" }
ATTACHMENT.Icon = "entities/two_tone_camo.png"
ATTACHMENT.ShortName = "TWC"

ATTACHMENT.WeaponTable = {}

ATTACHMENT.MaterialTable = {
	[1] = "models/weapons/glock/thread",
	[2] = "models/weapons/glock/glock_d_2",
}

function ATTACHMENT:Attach(wep)
	wep.MaterialTable = wep.MaterialTable or {}
	for k, v in pairs(self.MaterialTable or {}) do
		wep.MaterialTable[k] = self.MaterialTable[k]
	end
	wep.MaterialCached = false
end

function ATTACHMENT:Detach(wep)
	wep.MaterialTable = wep.MaterialTable or {}
	for k, v in pairs(self.MaterialTable or {}) do
		wep.MaterialTable[k] = nil
	end
	wep.MaterialCached = false
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
