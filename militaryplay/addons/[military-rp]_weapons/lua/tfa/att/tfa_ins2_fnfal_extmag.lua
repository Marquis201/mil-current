if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = CLIENT and "#insurgency_weapon_upgrade_magazine_extended" or "Extended Magazines"
ATTACHMENT.Description = {
	TFA.AttachmentColors["+"], "#insurgency_weapon_upgrade_magazine_extended_desc", TFA.AttachmentColors["-"], "Marginally slower movespeed"
}
ATTACHMENT.Icon = "entities/ins2_att_mag_ext_rifle_30rd.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "MAG+"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["mag"] = {
			["active"] = false,
		},
		["mag_ext"] = {
			["active"] = true,
		}
	},
	["WElements"] = {
		["mag"] = {
			["active"] = false,
		},
		["mag_ext"] = {
			["active"] = true,
		}
	},
	["Animations"] = {
		["reload"] = function(wep, _val)
			if !wep:Foregrip() then
				local val = table.Copy(_val)
				val.type = TFA.Enum.ANIMATION_SEQ --Sequence or act
				val.value = "base_reload_ext"
				return (wep:CheckVMSequence(val.value) and val or _val), true, true
			end
		end,
		["reload_empty"] = function(wep, _val)
			if !wep:Foregrip() then
				local val = table.Copy(_val)
				val.type = TFA.Enum.ANIMATION_SEQ --Sequence or act
				val.value = "base_reload_empty_ext"
				if wep:CheckVMSequence("base_reloadempty_ext") then
					val.value = "base_reloadempty_ext"
				end
				return (wep:CheckVMSequence(val.value) and val or _val), true, true
			end
		end,
	},
	["Primary"] = {
		["ClipSize"] = function(wep, val)
			return 30
		end,
	},
	["MoveSpeed"] = function(wep,stat) return stat * 0.975 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 0.975 end
}

function ATTACHMENT:Attach(wep)
	wep.SetNW2Bool = wep.SetNW2Bool or wep.SetNWBool
	wep.GetNW2Bool = wep.GetNW2Bool or wep.GetNWBool

	wep:SetNW2Bool("IsExt",true)

	function wep:Foregrip()
		return wep:GetNW2Bool("IsForegrip")
	end

	if not wep.IsFirstDeploy then
		wep:Unload()
	end
end

function ATTACHMENT:Detach(wep)
	wep:SetNW2Bool("IsExt",false)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
