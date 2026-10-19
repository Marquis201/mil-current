if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = ".308 Winchester Magazine"
ATTACHMENT.ShortName   = ".308 Win"

ATTACHMENT.Icon        = "entities/cdxmc_kraken_10_bullets_308_clip.png" 

ATTACHMENT.Description = { 
TFA.AttachmentColors["="], "Switch from .338 LM to an smaller .308 Win ammunition that sacrifices power for highter capacity and accuracy.",
TFA.AttachmentColors["+"], "Increases magazine capacity to 5 bullets more", "Increses Aim Accuracy", "Increses Hip Accuracy", "Decreases Recoil",
TFA.AttachmentColors["-"], "-30% Damage", "-30% Range", "-15% Muzzle Velocity" } 


ATTACHMENT.WeaponTable = {

	["Primary"] = {
		["ClipSize"] = function(wep,stat) return stat + 5 end,

		["IronAccuracy"] = function(wep,stat) return stat * 0.90 end,
		["Spread"] = function(wep,stat) return stat * 0.90 end,
		["SpreadRecovery"] = function(wep,stat) return stat * 1.05 end,
		
		["KickUp"] = function(wep,stat) return stat * 0.80 end,
		["KickDown"] = function(wep,stat) return stat * 0.80 end,
		["KickHorizontal"] = function(wep,stat) return stat * 0.70 end,	
		
		["Damage"] = function(wep,stat) return stat * 0.7 end,
		["Range"] = function(wep,stat) return stat * 0.7 end,
		["Velocity"] = function(wep,stat) return stat * 0.85 end,
	},
}

function ATTACHMENT:Attach(wep)
	if not wep.IsFirstDeploy then
		wep:Unload()
	end
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end