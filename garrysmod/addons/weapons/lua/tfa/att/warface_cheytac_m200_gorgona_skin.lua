if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Gorgona Skin"  -- skin name
ATTACHMENT.ShortName   = "Gorgon"        -- short name that displayed inside the icon

ATTACHMENT.Icon        = "entities/warface_cheytac_m200_gorgona_skin.png" 

ATTACHMENT.Description = {               -- skin description
	TFA.AttachmentColors["+"], "Gorgona skin from the warface battle pass gorgon.",
}

ATTACHMENT.WeaponTable = {

	MaterialTable = { -- materials that are present on both view- and worldmodel
	    [1] = "models/weapons/v_models/m200/bp09/sr08_bp09_a_diff",
	    [2] = "models/weapons/v_models/m200/bp09/sr08_bp09_b_diff",
	    [3] = "models/weapons/v_models/m200/set01/body_part2",
	    [4] = "models/weapons/v_models/m200/set01/extras_part1",
	    [5] = "models/weapons/v_models/m200/set01/fx_shell_col",
	    [6] = "models/weapons/v_models/m200/bp09/sr08_bp09_tp_diff",
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
