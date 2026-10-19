if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = CLIENT and "#insurgency_weapon_upgrade_foregrip" or "Foregrip"
ATTACHMENT.Description = {
	"#insurgency_weapon_upgrade_foregrip_desc",
	TFA.AttachmentColors["+"], "60% less vertical recoil", "20% less horizontal recoil",
	TFA.AttachmentColors["-"], "10% lower base accuracy", "5% lower scoped accuracy", "Marginally slower movespeed"
}
ATTACHMENT.Icon = "entities/ins2_att_grp.png"
ATTACHMENT.ShortName = "GRIP"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["basegrip"] = {
			["active"] = false
		},
		["foregrip"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["basegrip"] = {
			["active"] = false
		},
		["foregrip"] = {
			["active"] = true
		}
	},
	["Animations"] = {
		["draw"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "foregrip_draw"
		},
		["draw_first"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "foregrip_ready"
		},
		["shoot1"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "foregrip_fire"
		},
		["shoot1_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "foregrip_dryfire"
		},
		["reload"] = function(wep, val)
			val.type = TFA.Enum.ANIMATION_SEQ
			val.value = "foregrip_reload"

			if wep:Ext() then
				val.value = "foregrip_reload_ext"
			end

			return val, true
		end,
		["reload_empty"] = function(wep, val)
			val.type = TFA.Enum.ANIMATION_SEQ
			val.value = "foregrip_reloadempty"

			if wep:Ext() then
				val.value = "foregrip_reloadempty_ext"
			end

			return val, true
		end,
		["idle"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "foregrip_idle"
		},
		["holster"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "foregrip_holster"
		}
	},
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat * 0.4 end,
		["KickDown"] = function(wep,stat) return stat * 0.4 end,
		["KickHorizontal"] = function(wep,stat) return stat * 0.8 end,
		["Spread"] = function(wep,stat) return stat * 1.1 end,
		["IronAccuracy"] = function(wep,stat) return stat * 1.05 end
	},
	["MoveSpeed"] = function(wep,stat) return stat * 0.975 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 0.975 end,
	["HoldType"] = function(wep,stat)
		return "smg", true
	end,
	["SprintAnimation"] = {
		["loop"] = function(wep,val)
			if not wep.SprintAnimation.loop then return end
			val = table.Copy(val) or {}
			val["type"] = TFA.Enum.ANIMATION_SEQ --Sequence or act
			if val.value then
				val["value"] = "foregrip_sprint"
			end
			return val, true, false
		end
	},
	["IronAnimation"] = {
		["shoot"] = function(wep,val)
			if not wep.IronAnimation.shoot then return end
			val = table.Copy(val) or {}
			val["type"] = TFA.Enum.ANIMATION_ACT --Sequence or act
			if val.value then
				val["value"] = ACT_VM_PRIMARYATTACK_DEPLOYED_1
			end
			if val.value_empty then
				val["value_empty"] = ACT_VM_PRIMARYATTACK_DEPLOYED_3
			end
			return val, true, false
		end
	}
}

function ATTACHMENT:Attach( wep )
	wep.SetNW2Bool = wep.SetNW2Bool or wep.SetNWBool
	wep.GetNW2Bool = wep.GetNW2Bool or wep.GetNWBool

	function wep:Ext()
		return wep:GetNW2Bool("IsExt")
	end

	wep:SetNW2Bool("Foregrip",true)

	if TFA.Enum.ReadyStatus[wep:GetStatus()] then
		wep:ChooseIdleAnim()
		if game.SinglePlayer() then
			wep:CallOnClient("ChooseIdleAnim","")
		end
	end
end

function ATTACHMENT:Detach( wep )
	wep:SetNW2Bool("Foregrip",false)
	if TFA.Enum.ReadyStatus[wep:GetStatus()] then
		wep:ChooseIdleAnim()
		if game.SinglePlayer() then
			wep:CallOnClient("ChooseIdleAnim","")
		end
	end
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end