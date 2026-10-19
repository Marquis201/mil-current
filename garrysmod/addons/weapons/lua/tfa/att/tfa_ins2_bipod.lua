if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = CLIENT and "#insurgency_weapon_upgrade_bipod" or "Bipod"
ATTACHMENT.Description = {
	"#insurgency_weapon_upgrade_bipod_desc",
	"LALT (+walk) to deploy/undeploy", 
	TFA.AttachmentColors["+"],  "140% less recoil (vertical, horizontal)", "Easier to control recoil", 
	TFA.AttachmentColors["-"], "Marginally slower movespeed", "Limited vertical view", "Slower reload" 
}

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
	},
	["MoveSpeed"] = function(wep,stat) return stat * 0.975 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 0.975 end
}

function ATTACHMENT:Attach( wep )
	wep.SetNW2Bool = wep.SetNW2Bool or wep.SetNWBool
	wep.GetNW2Bool = wep.GetNW2Bool or wep.GetNWBool

	wep:SetNW2Bool("IsBipod",true)
end

function ATTACHMENT:Detach( wep )
	wep:SetNW2Bool("IsBipod",false)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end