if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "C792 Elcan"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.AttachmentColors["="], TFA.AttachmentColors["="], "5% higher zoom",  TFA.AttachmentColors["-"], "5% higher zoom time" }
ATTACHMENT.Icon = "entities/ins2_si_c79.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "C792"
ATTACHMENT.Base = "ins2_scope_base"
ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["scope_c792"] = {
			["active"] = function(wep, val) TFA.INS2.AnimateSight(wep) return true end,
			["ins2_sightanim_idle"] = "elcan_idle",
			["ins2_sightanim_iron"] = "elcan_zoom",
		}
	},
	["WElements"] = {
		["scope_c792"] = {
			["active"] = true
		}
	},
	["Secondary"] = {
		["ScopeZoom"] = function( wep, val ) return 3.4 end
	},
	["INS2_SightVElement"] = "scope_c792",
	["INS2_SightSuffix"] = "C792"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end