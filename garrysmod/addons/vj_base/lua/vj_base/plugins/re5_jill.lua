/*--------------------------------------------------
	*** Copyright (c) 2026 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("Resident Evil 5 - Jill Valentine SNPC", "NPC")

VJ.AddConVar("vj_re5_jill_hpmult",1)
VJ.AddConVar("vj_re5_jill_dmgmult",1)

local vCat = "Resident Evil 5"
VJ.AddNPC("Jill Valentine","npc_vj_re5_em84",vCat)

VJ.AddParticle("particles/vj_re5_jill.pcf",{})

if CLIENT then
	hook.Add("PopulateToolMenu","VJ_ADDTOMENU_RE5_JILL",function()
		local textCol = Color(255,255,255)
		spawnmenu.AddToolMenuOption("DrVrej","SNPC Configures","Resident Evil 5 - Jill","Resident Evil 5 - Jill","","",function(Panel)
			Panel:AddControl("Slider",{Label = "Health Multiplier",min = 1,max = 10,Command = "vj_re5_jill_hpmult"})
			Panel:AddControl("Slider",{Label = "Damage Multiplier",min = 1,max = 10,Command = "vj_re5_jill_dmgmult"})
			Panel:AddControl("Checkbox",{Label = "Disable Wesker / Jill's HUD (Client-Side)",Command = "vj_re5_wesker_nohud"})
		end)
	end)
end