if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "PP-19-01 'Vityaz' 9x19 sound suppressor"
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Less firing noise", 
TFA.AttachmentColors["+"], "9% less vertical recoil",
TFA.AttachmentColors["-"], "16% less bullet velocity",
TFA.AttachmentColors["-"], "10% higher zoom time" 
}
ATTACHMENT.Icon = "entities/eft_sil_pbs.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "PBS"

ATTACHMENT.WeaponTable = {
	["Bodygroups_V"] = {
        [2] =  1
    },
	["Bodygroups_W"] = {
        [2] =  1
    },
	["ViewModelBoneMods"] = {
	},
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat * 0.91 end,
		["KickDown"] = function(wep,stat) return stat * 0.91 end,
		["Velocity"] = function(wep,stat) return stat * 1.16 end,
		["Sound"] = function(wep,stat) return wep.Primary.SilencedSound or stat end
	},
	["MuzzleFlashEffect"] = "tfa_muzzleflash_silenced",
	["MuzzleAttachmentMod"] = function(wep,stat) return wep.MuzzleAttachmentSilenced or stat end,
	["Silenced"] = true,
	["IronSightTime"] = function( wep, val ) return val * 1.2 end,
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
