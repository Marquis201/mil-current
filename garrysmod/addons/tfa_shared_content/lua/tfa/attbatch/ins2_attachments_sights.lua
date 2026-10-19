if not TFA_ATTACHMENT_ISUPDATING then TFAUpdateAttachments(false) return end

-- scopes (rt/ins2_scope_base)
TFA.Attachments.RegisterFromTable("ins2_si_2xrds", {
	Base = "ins2_scope_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_2xaimpoint" or "Aimpoint CompM2 2X",
	Description = { "#insurgency_weapon_upgrade_2xaimpoint_desc", TFA.AttachmentColors["="], "2x zoom", TFA.AttachmentColors["-"], "10% higher zoom time",  TFA.AttachmentColors["-"], "5% slower aimed walking" },
	Icon = "entities/ins2_si_2xrds.png",
	ShortName = "2XRDS",
	WeaponTable = {
		VElements = {
			scope_2xrds = { active = true, ins2_sightanim_idle = "4x_idle", ins2_sightanim_iron = "4x_zoom" },
		},
		WElements = {
			scope_2xrds = { active = true },
		},
		Secondary = {
			ScopeZoom = function( wep, val ) return 2 end
		},
		INS2_SightVElement = "scope_2xrds",
		INS2_SightSuffix = "2XRDS"
	}
})
TFA.Attachments.RegisterFromTable("ins2_si_c79", {
	Base = "ins2_scope_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_elcan" or "C79 Elcan",
	Description = { "#insurgency_weapon_upgrade_elcan_desc", TFA.AttachmentColors["="], "3.4x zoom", TFA.AttachmentColors["-"], "20% higher zoom time",  TFA.AttachmentColors["-"], "5% slower aimed walking" },
	Icon = "entities/ins2_si_c79.png",
	ShortName = "C79",
	WeaponTable = {
		VElements = {
			scope_c79 = { active = true, ins2_sightanim_idle = "elcan_idle", ins2_sightanim_iron = "elcan_zoom" },
		},
		WElements = {
			scope_c79 = { active = true },
		},
		Secondary = {
			ScopeZoom = function( wep, val ) return 3.4 end
		},
		INS2_SightVElement = "scope_c79",
		INS2_SightSuffix = "C79"
	}
})
TFA.Attachments.RegisterFromTable("ins2_si_mosin", {
	Base = "ins2_scope_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_scope_mosin" or "7X Scope",
	Description = { "#insurgency_weapon_upgrade_scope_mosin_desc", TFA.AttachmentColors["="], "7x zoom", TFA.AttachmentColors["-"], "30% higher zoom time", TFA.AttachmentColors["-"], "10% slower aimed walking" },
	Icon = "entities/ins2_si_mosin.png",
	ShortName = "MOSN",
	WeaponTable = {
		VElements = {
			scope_mosin = { active = true, ins2_sightanim_idle = "scope_idle", ins2_sightanim_iron = "scope_zoom" },
		},
		WElements = {
			scope_mosin = { active = true },
		},
		Secondary = {
			ScopeZoom = function(wep, val) return 7 end
		},
		INS2_SightVElement = "scope_mosin",
		INS2_SightSuffix = "Mosin"
	}
})
TFA.Attachments.RegisterFromTable("ins2_si_mx4", {
	Base = "ins2_scope_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_scope_m40a1" or "MX4 Scope",
	Description = { "#insurgency_weapon_upgrade_scope_m40a1_desc", TFA.AttachmentColors["="], "8.7x zoom", TFA.AttachmentColors["-"], "40% higher zoom time",  TFA.AttachmentColors["-"], "10% slower aimed walking" },
	Icon = "entities/ins2_si_mx4.png",
	ShortName = "MX4",
	WeaponTable = {
		VElements = {
			scope_mx4 = { active = true, ins2_sightanim_idle = "scope_idle", ins2_sightanim_iron = "scope_zoom" },
		},
		WElements = {
			scope_mx4 = { active = true },
		},
		Secondary = {
			ScopeZoom = function(wep, val) return 8.7 end
		},
		INS2_SightVElement = "scope_mx4",
		INS2_SightSuffix = "MX4"
	}
})
TFA.Attachments.RegisterFromTable("ins2_si_po4x", {
	Base = "ins2_scope_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_po4x24" or "PO 4x24P",
	Description = { "#insurgency_weapon_upgrade_po4x24_desc", TFA.AttachmentColors["="], "4x zoom", TFA.AttachmentColors["-"], "25% higher zoom time",  TFA.AttachmentColors["-"], "5% slower aimed walking" },
	Icon = "entities/ins2_si_po4x.png",
	ShortName = "PO4X",
	WeaponTable = {
		VElements = {
			scope_po4x = { active = true, ins2_sightanim_idle = "po_idle", ins2_sightanim_iron = "po_zoom" },
		},
		WElements = {
			scope_po4x = { active = true },
		},
		Secondary = {
			ScopeZoom = function( wep, val ) return 4 end
		},
		INS2_SightVElement = "scope_po4x",
		INS2_SightSuffix = "PO4X"
	}
})

-- sights
TFA.Attachments.RegisterFromTable("ins2_si_base", {
	Name = "INS2 Sight Base",
	WeaponTable = {
		VElements = {
			rail_sights = { active = true },
			sights_folded = { active = false },
		},
		WElements = {
			rail_sights = { active = true },
			sights_folded = { active = false },
		}
	}
})

TFA.Attachments.RegisterFromTable("ins2_si_folded", {
	Base = "ins2_si_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_flipsights" or "Folded Sights",
	Description = { TFA.AttachmentColors["+"], "Easier to aim", TFA.AttachmentColors["-"], "5% higher zoom time" },
	Icon = "entities/ins2_att_fsi.png",
	ShortName = "FSI",

	WeaponTable = {
		VElements = { sights_folded = { active = true } },
		WElements = { sights_folded = { active = true } },
		IronSightsPos = function( wep, val ) return wep.IronSightsPos_Folded or val end,
		IronSightsAng = function( wep, val ) return wep.IronSightsAng_Folded or val end,
		IronSightTime = function( wep, val ) return val * 1.05 end
	}
})
TFA.Attachments.RegisterFromTable("ins2_si_eotech", {
	Base = "ins2_si_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_holographic" or "EOTech 552",
	Description = { "#insurgency_weapon_upgrade_holographic_desc", TFA.AttachmentColors["="], "5% higher zoom", TFA.AttachmentColors["-"], "5% higher zoom time" },
	Icon = "entities/ins2_si_eotech.png",
	ShortName = "EOTECH",

	WeaponTable = {
		VElements = {
			sight_eotech = { active = true, ins2_sightanim_idle = "idle", ins2_sightanim_iron = "zoom", },
			sight_eotech_lens = { active = true },
		},
		WElements = {
			sight_eotech = { active = true },
			sight_eotech_lens = { active = true },
		},
		IronSightsPos = function( wep, val ) return wep.IronSightsPos_EOTech or val end,
		IronSightsAng = function( wep, val ) return wep.IronSightsAng_EOTech or val end,
		Secondary = {
			IronFOV = function( wep, val ) return wep.Secondary.IronFOV_EOTech or val * 0.95 end
		},
		IronSightTime = function( wep, val ) return val * 1.05 end,
		INS2_SightVElement = "sight_eotech",
	}
})
TFA.Attachments.RegisterFromTable("ins2_si_kobra", {
	Base = "ins2_si_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_kobra" or "Kobra Reflex Sight",
	Description = { "#insurgency_weapon_upgrade_kobra_desc", TFA.AttachmentColors["="], "5% higher zoom", TFA.AttachmentColors["-"], "5% higher zoom time" },
	Icon = "entities/ins2_si_kobra.png",
	ShortName = "KOBRA",

	WeaponTable = {
		VElements = {
			sight_kobra = { active = true, ins2_sightanim_idle = "idle", ins2_sightanim_iron = "zoom" },
			sight_kobra_lens = { active = true },
		},
		WElements = {
			sight_kobra = { active = true },
			sight_kobra_lens = { active = true },
		},
		IronSightsPos = function( wep, val ) return wep.IronSightsPos_Kobra or val end,
		IronSightsAng = function( wep, val ) return wep.IronSightsAng_Kobra or val end,
		Secondary = {
			IronFOV = function( wep, val ) return wep.Secondary.IronFOV_Kobra or val * 0.95 end
		},
		IronSightTime = function( wep, val ) return val * 1.05 end,
		INS2_SightVElement = "sight_kobra",
	}
})
TFA.Attachments.RegisterFromTable("ins2_si_rds", {
	Base = "ins2_si_base",
	Name = CLIENT and "#insurgency_weapon_upgrade_aimpoint" or "Aimpoint CompM2",
	Description = { "#insurgency_weapon_upgrade_aimpoint_desc", TFA.AttachmentColors["="], "10% higher zoom", TFA.AttachmentColors["-"], "7.5% higher zoom time" },
	Icon = "entities/ins2_si_rds.png",
	ShortName = "RDS",

	WeaponTable = {
		VElements = {
			sight_rds = { active = true, ins2_sightanim_idle = "4x_idle", ins2_sightanim_iron = "4x_zoom" },
			sight_rds_lens = { active = true },
		},
		WElements = {
			sight_rds = { active = true },
			sight_rds_lens = { active = true },
		},
		IronSightsPos = function( wep, val ) return wep.IronSightsPos_RDS or val end,
		IronSightsAng = function( wep, val ) return wep.IronSightsAng_RDS or val end,
		Secondary = {
			IronFOV = function( wep, val ) return wep.Secondary.IronFOV_RDS or val * 0.9 end
		},
		IronSightTime = function( wep, val ) return val * 1.075 end,
		INS2_SightVElement = "sight_rds",
	}
})