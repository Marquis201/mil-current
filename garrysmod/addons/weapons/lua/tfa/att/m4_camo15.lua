if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Camo" -- skin name
ATTACHMENT.Description = {
}
ATTACHMENT.Icon = "entities/paintbrush.png"
ATTACHMENT.ShortName = "Camo" -- short name that displayed inside the icon

ATTACHMENT.WeaponTable = { -- run lua_run PrintTable(Entity(15):GetActiveWeapon():GetMaterials()) in console command to get where texture part are located
	--MaterialTable = { -- materials that are present on both view- and worldmodel
	--[15] = "models/weapons/cod_mw20159/oden_dreamkiller/stubby015",
	--[2] = "models/weapons/cod_mw20159/oden_dreamkiller/upper",
	--[3] = "models/weapons/cod_mw20159/oden_dreamkiller/flashider02",
	--[4] = "models/weapons/cod_mw20159/oden_dreamkiller/sights",
	--[5] = "models/weapons/cod_mw20159/oden_dreamkiller/lower",
	--[6] = "models/weapons/cod_mw20159/oden_dreamkiller/frontend",
	--[7] = "models/weapons/cod_mw20159/oden_dreamkiller/mag",
	--},
	 MaterialTable_V = {
	[3]	=	"models/qianru/camo/15/m4a1Tech_stock_d",
	[4] =	"models/qianru/camo/15/m4a1Tech_handle_d",
	[6] =	"models/qianru/camo/15/m4a1Tech_fore_d",
	[7] =	"models/qianru/camo/15/m4a1Tech_body_d"




	}, -- separate table for viewmodel materials, overrides main table
	 MaterialTable_W = {
	 [3]	=	"models/qianru/camo/15/m4a15Tech_stock_d"


	}, -- separate table for worldmodel materials, overrides main table
}

local function resetMatCache(att, wep)
	wep.MaterialCached = false
end

ATTACHMENT.Attach = resetMatCache
ATTACHMENT.Detach = resetMatCache

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end

