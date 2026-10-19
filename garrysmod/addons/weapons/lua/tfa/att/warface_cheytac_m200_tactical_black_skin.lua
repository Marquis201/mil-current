if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Tactical Black"  -- skin name
ATTACHMENT.ShortName   = "Black"           -- short name that displayed inside the icon

ATTACHMENT.Icon        = "entities/warface_cheytac_m200_tactical_black_skin.png" 

ATTACHMENT.Description = {                 -- skin description
	TFA.AttachmentColors["+"], "Tactical black camo for true soldiers.",
}

ATTACHMENT.WeaponTable = {

	MaterialTable = { -- materials that are present on both view- and worldmodel
     	[1] = "models/weapons/v_models/m200/set01/sr08_a_set01_diff",
    	[2] = "models/weapons/v_models/m200/set01/sr08_b_set01_diff",
    	[3] = "models/weapons/v_models/m200/set01/body_part2",
    	[4] = "models/weapons/v_models/m200/set01/extras_part1",
    	[5] = "models/weapons/v_models/m200/set01/fx_shell_col",
    	[6] = "models/weapons/v_models/m200/set01/sr08_set01_tp_diff",
	},
}

local function resetMatCache(att, wep)
	wep.MaterialCached = false
end

ATTACHMENT.Attach = resetMatCache
ATTACHMENT.Detach = resetMatCache

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end