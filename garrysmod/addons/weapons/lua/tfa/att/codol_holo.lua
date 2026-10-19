if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Holo Sight"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.AttachmentColors["+"], "5% higher zoom",TFA.AttachmentColors["+"], "Less Blowback", TFA.AttachmentColors["-"], "5% higher zoom time" }
ATTACHMENT.Icon = "entities/tfa_si_eotech.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "EOTECH"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_holo1"] = {
			["active"] = true
		},
		["sights_folded"] = {
			["active"] = false
		},
		["sight_holo_lens"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_holo1"] = {
			["active"] = true
		},
		["sights_folded"] = {
			["active"] = false
		},
		["sight_holo_lens"] = {
			["active"] = true
		}
	},
	["IronSightsPos"] = function( wep, val ) return wep.IronSightsPos_Holo or val end,
	["IronSightsAng"] = function( wep, val ) return wep.IronSightsAng_Holo or val end,
	["BlowbackVector"] = function( wep, val ) return wep.Blowback_Holo or val end,
	["Secondary"] = {
		["IronFOV"] = function( wep, val ) return wep.Secondary.IronFOV_Holo or val * 0.95 end
	},
	["IronSightTime"] = function( wep, val ) return val * 1.05 end,
	["INS2_SightVElement"] = "sight_holo1",
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
