if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "SilencerCo Osprey 9 9x19 sound suppressor"
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Less firing noise", 
TFA.AttachmentColors["+"], "12% less vertical recoil",
TFA.AttachmentColors["-"], "17% less bullet velocity",
TFA.AttachmentColors["-"], "10% higher zoom time" 
}
ATTACHMENT.Icon = "entities/eft_sil_osprey9.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "Osprey"

ATTACHMENT.WeaponTable = {
	["Bodygroups_V"] = {
        [2] =  2
    },
	["Bodygroups_W"] = {
        [2] =  2
    },
	["ViewModelBoneMods"] = {
	},
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat * 0.88 end,
		["KickDown"] = function(wep,stat) return stat * 0.88 end,
		["Velocity"] = function(wep,stat) return stat * 1.17 end,
		["Sound"] = function(wep,stat) return wep.Primary.SilencedSound or stat end
	},
	["MuzzleFlashEffect"] = "tfa_muzzleflash_silenced",
	["MuzzleAttachmentMod"] = function(wep,stat) return wep.MuzzleAttachmentSilenced or stat end,
	["Silenced"] = true,
	["IronSightTime"] = function( wep, val ) return val * 1.1 end,
}

function ATTACHMENT:Attach(wep)
	wep.Silenced = true
	wep:SetSilenced(wep.Silenced)
end

function ATTACHMENT:Detach(wep)
	wep.Silenced = false
	wep:SetSilenced(wep.Silenced)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
