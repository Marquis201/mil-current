if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "PSO-1 1x/4x Scope"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "4x zoom", 
TFA.AttachmentColors["-"], "30% higher zoom time",  
TFA.AttachmentColors["-"], "5% slower aimed walking",
}
ATTACHMENT.Icon = "entities/eft_si_pso.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "PSO"
ATTACHMENT.Base = "ins2_scope_base"
ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["scope_pso"] = {
			["active"] = function(wep, val) TFA.INS2.AnimateSight(wep) return true end,
			["ins2_sightanim_idle"] = "elcan_idle",
			["ins2_sightanim_iron"] = "elcan_zoom",
		},
		["rail_sights"] = {
			["active"] = false
		},
		["sights_base_f"] = {
			["active"] = false
		},
		["sights_base_r"] = {
			["active"] = false
		},
		["sights_base_folded_f"] = {
			["active"] = true
		},
		["sights_base_folded_r"] = {
			["active"] = true
		}
	},
	["Bodygroups_W"] = {
        [2] =  1
    },
	["ViewModelBoneMods"] = {
		["A_RenderPoint"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["A_Optic"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0.5, 1.5, -0.7), angle = Angle(0, 0, 0) }
	},
	["WElements"] = {
		["scope_elcan"] = {
			["active"] = true
		}
	},
	["Secondary"] = {
		["ScopeZoom"] = function( wep, val ) return 4 + (4/2) end
	},
	["IronSightTime"] = function(wep, val) return val * 1.3 end,
	["IronSightMoveSpeed"] = function(stat) return stat * 0.95 end,
	["INS2_SightVElement"] = "scope_pso",
	["INS2_SightSuffix"] = "PSO"
	
}

function ATTACHMENT:Attach(wep)

end

function ATTACHMENT:Detach(wep)

end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
