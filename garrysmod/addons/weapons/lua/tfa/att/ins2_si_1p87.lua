if not ATTACHMENT then
	ATTACHMENT = {}
end

local function GetBindName(bind, fallback)
	if input and input.LookupBinding then
		local keyname = input.LookupBinding(bind, true)

		if keyname then
			return keyname:upper()
		end
	end

	return fallback
end

ATTACHMENT.Name = "1P87"
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "5% higher zoom",
	TFA.AttachmentColors["-"], "5% higher zoom time",
	"",
	Color(0, 191, 255), string.format("Hold %s and press %s while aiming to switch reticle", GetBindName("+use", "USE key"), GetBindName("+reload", "Reload key")),
}
ATTACHMENT.Icon = "entities/tfa_ins2_si_1p87.png"
ATTACHMENT.ShortName = "1П87"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_1p87"] = {
			["active"] = true,
		},
		["sights_folded"] = {
			["active"] = false
		},
		["sight_1p87_lens"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_1p87"] = {
			["active"] = true
		},
		["sights_folded"] = {
			["active"] = false
		}
	},
	["IronSightsPos"] = function( wep, val )
		return wep.IronSightsPos_1P87 or val
	end,
	["IronSightsAng"] = function( wep, val )
		return wep.IronSightsAng_1P87 or val
	end,
	["Secondary"] = {
		["IronFOV"] = function( wep, val )
			return wep.Secondary.IronFOV_1P87 or val * 0.95
		end
	},
	["IronSightTime"] = function( wep, val )
		return val * 1.05
	end,
	["INS2_SightVElement"] = "sight_1p87",
	["SwitchableReticles"] = {
		"models/weapons/tfa_ins2/optics/1p87_cross",
		"models/weapons/tfa_ins2/optics/1p87_full",
		"models/weapons/tfa_ins2/optics/1p87_ring",
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
