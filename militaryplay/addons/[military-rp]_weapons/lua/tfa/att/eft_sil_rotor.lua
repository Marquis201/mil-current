if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Rotor 43 7.62x54R muzzle brake-compensator"
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Less firing noise", 
TFA.AttachmentColors["+"], "4% less vertical recoil",
TFA.AttachmentColors["-"], "12% less bullet velocity",
TFA.AttachmentColors["-"], "10% higher zoom time" 
}
ATTACHMENT.Icon = "entities/eft_sil_rotor.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "ROTOR"

ATTACHMENT.WeaponTable = {
	["Bodygroups_V"] = {
        [1] =  1
    },
	["Bodygroups_W"] = {
        [1] =  1
    },
	["ViewModelBoneMods"] = {
	},
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat * 0.96 end,
		["KickDown"] = function(wep,stat) return stat * 0.96 end,
		["Primary.Velocity"] = function(wep,stat) return stat * 0.88 end,
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
