/*--------------------------------------------------
	*** Copyright (c) 2026 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("Resident Evil 5 - Wesker SNPCs", "NPC")

VJ.AddConVar("vj_re5_wesker_hpmult",1)
VJ.AddConVar("vj_re5_wesker_dmgmult",1)
VJ.AddConVar("vj_re5_wesker_noexplosionflinch",0)
VJ.AddConVar("vj_re5_wesker_nododgeeffects",0)
VJ.AddClientConVar("vj_re5_wesker_noafterimage","0")
VJ.AddClientConVar("vj_re5_wesker_nohud","0")

local vCat = "Resident Evil 5"
VJ.AddNPC("Albert Wesker (Jacketless)","npc_vj_re5_em80",vCat)
VJ.AddNPC("Albert Wesker (S.T.A.R.S.)","npc_vj_re5_em80b",vCat)
VJ.AddNPC("Albert Wesker","npc_vj_re5_em81",vCat)
VJ.AddNPC("Albert Wesker (EX)","npc_vj_re5_em81_boss",vCat)
VJ.AddNPC("Albert Wesker (Shirtless)","npc_vj_re5_em82a",vCat)
-- VJ.AddNPC("Albert Wesker (Uroboros)","npc_vj_re5_em82",vCat)

VJ.AddParticle("particles/vj_re5_wesker.pcf",{})

if CLIENT then
	hook.Add("PopulateToolMenu","VJ_ADDTOMENU_RE5_WESKER",function()
		local textCol = Color(255,255,255)
		spawnmenu.AddToolMenuOption("DrVrej","SNPC Configures","Resident Evil 5 - Wesker","Resident Evil 5 - Wesker","","",function(Panel)
			Panel:AddControl("Slider",{Label = "Health Multiplier",min = 1,max = 10,Command = "vj_re5_wesker_hpmult"})
			Panel:AddControl("Slider",{Label = "Damage Multiplier",min = 1,max = 10,Command = "vj_re5_wesker_dmgmult"})
			Panel:AddControl("Checkbox",{Label = "Disable Wesker Stagger From Explosions",Command = "vj_re5_wesker_noexplosionflinch"})
			Panel:AddControl("Checkbox",{Label = "Disable Wesker's Dodge Particles",Command = "vj_re5_wesker_nododgeeffects"})
			Panel:AddControl("Checkbox",{Label = "Disable Wesker's Afterimages (Client-Side)",Command = "vj_re5_wesker_noafterimage"})
			Panel:AddControl("Checkbox",{Label = "Disable Wesker / Jill's HUD (Client-Side)",Command = "vj_re5_wesker_nohud"})
		end)
	end)
end

if SERVER then -- Personal stuff
	function __WeskersFight(w1,w2,eZ,cont)
		if !game.SinglePlayer() or game.GetMap() != "gg_rustndust_high" then return end

		local removal = ents.Create("prop_vj_animatable")
		removal:SetPos(Vector(0,0,0))
		removal:Spawn()
		removal:SetSolid(SOLID_NONE)
		removal:SetNoDraw(true)
		removal:DrawShadow(false)
		removal:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		undo.Create("Wesker Fight")
			undo.AddEntity(removal)
			undo.SetPlayer(Entity(1))
		undo.Finish()

		local wesker1 = ents.Create(w1 or "npc_vj_re5_em80b")
		wesker1:SetPos(Vector(0,460,71))
		wesker1:SetAngles(Angle(0,-90,0))
		wesker1.VJ_NPC_Class = {"CLASS_WESKER1"}
		wesker1.AlliedWithPlayerAllies = false
		wesker1.PlayerFriendly = false
		wesker1:Spawn()
		wesker1:Activate()
		removal:DeleteOnRemove(wesker1)
		wesker1.VJ_NPC_Class = {"CLASS_WESKER1"}
		wesker1.AlliedWithPlayerAllies = false
		wesker1.PlayerFriendly = false
		if cont then
			timer.Simple(0.1,function()
				if IsValid(wesker1) then
					local obj = ents.Create("obj_vj_controller")
					obj.VJCE_Player = Entity(1)
					obj:SetControlledNPC(wesker1)
					obj:Spawn()
					obj:StartControlling()
				end
			end)
		end

		timer.Simple(0.05,function()
			if IsValid(removal) then
				local wesker2 = ents.Create(w2 or "npc_vj_re5_em80")
				wesker2:SetPos(Vector(0,-460,71))
				wesker2:SetAngles(Angle(0,90,0))
				wesker2.VJ_NPC_Class = {"CLASS_WESKER2"}
				wesker2.AlliedWithPlayerAllies = false
				wesker2.PlayerFriendly = false
				wesker2:Spawn()
				wesker2:Activate()
				wesker2.VJ_NPC_Class = {"CLASS_WESKER2"}
				wesker2.AlliedWithPlayerAllies = false
				wesker2.PlayerFriendly = false
				removal:DeleteOnRemove(wesker2)
			end
		end)

		if eZ then
			local zSpawner = ents.Create("sent_vj_nmrihr_z_sp")
			if !IsValid(zSpawner) then return end -- NMRiH Reanimated not installed, rip
			zSpawner:SetPos(Vector(-663.435059,-30.523085,76))
			zSpawner:SetAngles(Angle(0,0,0))
			zSpawner:Spawn()
			zSpawner:Activate()
			removal:DeleteOnRemove(zSpawner)

			local zSpawner = ents.Create("sent_vj_nmrihr_z_sp")
			if !IsValid(zSpawner) then return end -- NMRiH Reanimated not installed, rip
			zSpawner:SetPos(Vector(663.019470,2.803393,76))
			zSpawner:SetAngles(Angle(0,180,0))
			zSpawner:Spawn()
			zSpawner:Activate()
			removal:DeleteOnRemove(zSpawner)
		end
	end
end