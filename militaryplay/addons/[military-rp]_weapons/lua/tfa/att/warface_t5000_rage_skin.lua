if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Rage Skin"     -- skin name
ATTACHMENT.ShortName   = "Rage"          -- short name that displayed inside the icon

ATTACHMENT.Icon        = "entities/warface_t5000_rage_skin.png" 

ATTACHMENT.Description = {               -- skin description
	TFA.AttachmentColors["+"], "Rage skin from the warface battle pass Berserk.",
--	TFA.AttachmentColors["="], "uses vgui/black for a texture",
}

ATTACHMENT.WeaponTable = {

	MaterialTable = { -- materials that are present on both view- and worldmodel
	    [2] = "models/weapons/v_models/t5000/bp07/sr37_bp07_diff",
	},
	
	-- MaterialTable_V = {}, -- separate table for viewmodel materials, overrides main table
	-- MaterialTable_W = {}, -- separate table for worldmodel materials, overrides main table
}

local function resetMatCache(att, wep)
	wep.MaterialCached = false
end

ATTACHMENT.Attach = resetMatCache
ATTACHMENT.Detach = resetMatCache

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
