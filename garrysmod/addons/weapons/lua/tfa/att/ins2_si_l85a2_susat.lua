if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "SUSAT 4X"
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "4x zoom",
	TFA.AttachmentColors["-"], "20% higher zoom time",
	TFA.AttachmentColors["-"], "5% slower aimed walking",
}
ATTACHMENT.Icon = "entities/ins2_si_l85a2_susat.png"
ATTACHMENT.ShortName = "SUSAT"
ATTACHMENT.Base = "ins2_scope_base"
ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["scope_susat"] = {
			["active"] = function(wep, val) TFA.INS2.AnimateSight(wep) return true end,
			["ins2_sightanim_idle"] = "elcan_idle",
			["ins2_sightanim_iron"] = "elcan_zoom",
		}
	},
	["WElements"] = {
		["scope_susat"] = {
			["active"] = true
		}
	},
	["Secondary"] = {
		["ScopeZoom"] = function( wep, val ) return 4 end
	},
	["INS2_SightVElement"] = "scope_susat",
	["INS2_SightSuffix"] = "SUSAT"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end