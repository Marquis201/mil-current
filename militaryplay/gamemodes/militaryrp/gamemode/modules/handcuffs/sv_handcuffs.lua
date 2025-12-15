local nw = { "Carry", "ShowInfo", "Checker" }

for k, v in pairs(nw) do
	util.AddNetworkString("mp.HandCuff." .. v)
end

local ang = Angle
local mp = mp
local PLAYER = PLAYER
local IsValid = IsValid

local females = {
	["models/player/group01/female_01.mdl"] = true,
	["models/player/group01/female_02.mdl"] = true,
	["models/player/group01/female_03.mdl"] = true,
	["models/player/group01/female_04.mdl"] = true,
	["models/player/group01/female_05.mdl"] = true,
	["models/player/group01/female_06.mdl"] = true,
	["models/player/icpd/fbi2/female_03.mdl"] = true,
	["models/player/icpd/fbi2/female_04.mdl"] = true,
	["models/player/icpd/fbi2/female_06.mdl"] = true,
	["models/player/icpd/fbi2/female_07.mdl"] = true,
	["models/indianarp/matveicher/medic/medic_01_f.mdl"] = true,
	["models/indianarp/matveicher/medic/medic_02_f.mdl"] = true,
	["models/indianarp/matveicher/medic/medic_03_f.mdl"] = true,
	["models/indianarp/matveicher/medic/medic_04_f.mdl"] = true,
	["models/indianarp/matveicher/medic/medic_05_f.mdl"] = true,
	["models/indianarp/matveicher/medic/medic_06_f.mdl"] = true,
	["models/fearless/mayor2.mdl"] = true,
}

local function SetCuffsBone(bool, pl)
	if bool then
		if females[pl:GetModel()] then
			if pl:LookupBone("ValveBiped.Bip01_L_UpperArm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_UpperArm"), ang(15, 12, 0)) -- Left UpperArm
			end

			if pl:LookupBone("ValveBiped.Bip01_L_Forearm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_Forearm"), ang(15, 0, 0)) -- Left ForeArm
			end

			if pl:LookupBone("ValveBiped.Bip01_L_Hand") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_Hand"), ang(0, 0, 75)) -- Left Hand
			end

			if pl:LookupBone("ValveBiped.Bip01_R_Forearm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_Forearm"), ang(-15, 0, 0)) -- Right Forearm
			end

			if pl:LookupBone("ValveBiped.Bip01_R_Hand") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_Hand"), ang(0, 0, -75)) -- Right Hand
			end

			if pl:LookupBone("ValveBiped.Bip01_R_UpperArm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_UpperArm"), ang(-12, 16.6, 0)) -- Right Upperarm
			end
		else
			if pl:LookupBone("ValveBiped.Bip01_L_UpperArm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_UpperArm"), ang(16, 8.8, 0)) -- Left UpperArm
			end

			if pl:LookupBone("ValveBiped.Bip01_L_Forearm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_Forearm"), ang(15, 0, 0)) -- Left ForeArm
			end

			if pl:LookupBone("ValveBiped.Bip01_L_Hand") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_Hand"), ang(0, 0, 75)) -- Left Hand
			end

			if pl:LookupBone("ValveBiped.Bip01_R_Forearm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_Forearm"), ang(-15, 0, 0)) -- Right Forearm
			end

			if pl:LookupBone("ValveBiped.Bip01_R_Hand") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_Hand"), ang(0, 0, -75)) -- Right Hand
			end

			if pl:LookupBone("ValveBiped.Bip01_R_UpperArm") then
				pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_UpperArm"), ang(-16, 16.6, 0)) -- Right Upperarm
			end
		end
	else
		if pl:LookupBone("ValveBiped.Bip01_L_UpperArm") then
			pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_UpperArm"), ang(0, 0, 0)) -- Left UpperArm
		end

		if pl:LookupBone("ValveBiped.Bip01_L_Forearm") then
			pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_Forearm"), ang(0, 0, 0)) -- Left ForeArm
		end

		if pl:LookupBone("ValveBiped.Bip01_L_Hand") then
			pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_L_Hand"), ang(0, 0, 0)) -- Left Hand
		end

		if pl:LookupBone("ValveBiped.Bip01_R_Forearm") then
			pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_Forearm"), ang(0, 0, 0)) -- Right Forearm
		end

		if pl:LookupBone("ValveBiped.Bip01_R_Hand") then
			pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_Hand"), ang(0, 0, 0)) -- Right Hand
		end

		if pl:LookupBone("ValveBiped.Bip01_R_UpperArm") then
			pl:ManipulateBoneAngles(pl:LookupBone("ValveBiped.Bip01_R_UpperArm"), ang(0, 0, 0)) -- Right Upperarm
		end
	end
end

function PLAYER:SetCarry(pl)
	self:SetNetVar("isCarry", pl)
end

function PLAYER:SetCarried(pl)
	if not pl then
		if self:GetCollisionGroup() ~= COLLISION_GROUP_WEAPON then
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

			timer.Simple(2, function()
				if IsValid(self) then
					self:SetCollisionGroup(0)
				end
			end)
		end
	end
	self:SetNetVar("isCarried", pl)
end

function PLAYER:HandCuff(actor)
	local wep = self:Give("handcuffs")
	self:SetActiveWeapon(wep)
	--self:SelectWeapon("keys")
	self:SetNetVar("isHandcuffed", true)
	hook.Call("PlayerCuf", GAMEMODE, self, actor)

	self:SetWalkSpeed(self.OldWalkSpeed / 2.5)
	self:SetRunSpeed(self.OldRunSpeed / 2.5)

	SetCuffsBone(true, self)
end

function PLAYER:UnHandCuff(actor)
	self:SetNetVar("isHandcuffed", false)
	hook.Call("PlayerUnCuffed", GAMEMODE, self, actor)
	self:StripWeapon("handcuffs")
	self:SwitchToDefaultWeapon()
	self:SetWalkSpeed(self.OldWalkSpeed)
	self:SetRunSpeed(self.OldRunSpeed)
	self:SelectWeapon("keys")

	if IsValid(self:isCarried()) then
		self:isCarried():SetCarry(nil)
		self:SetCarried(nil)
	end

	SetCuffsBone(false, self)
end

hook.Add("PlayerDeath", "zip::OnDeath", function(pl)
	if pl:isHandcuffed() then
		pl:UnHandCuff(pl)
	end

	if pl:isCarry() and IsValid(pl:isCarry()) then
		pl:isCarry():SetCarried(nil)
		pl:SetCarry(nil)
	end

	if pl:isCarried() and IsValid(pl:isCarried()) then
		pl:isCarried():SetCarry(nil)
		pl:SetCarried(nil)
	end
end)

hook.Add("PlayerArrestPlayer", "zip::OnArrest", function(pl)
	if not IsValid(pl) then return end

	if pl:isHandcuffed() then
		pl:UnHandCuff(pl)
	end

	if pl:isCarry() and IsValid(pl:isCarry()) then
		pl:isCarry():SetCarried(nil)
		pl:SetCarry(nil)
	end

	if pl:isCarried() and IsValid(pl:isCarried()) then
		pl:isCarried():SetCarry(nil)
		pl:SetCarried(nil)
	end
end)

hook.Add("PlayerUnArrested", "zip::UnArrest", function(pl)
	if pl:isHandcuffed() then
		pl:UnHandCuff(pl)
	end

	if pl:isCarry() and IsValid(pl:isCarry()) then
		pl:isCarry():SetCarried(nil)
		pl:SetCarry(nil)
	end

	if pl:isCarried() and IsValid(pl:isCarried()) then
		pl:isCarried():SetCarry(nil)
		pl:SetCarried(nil)
	end
end)

hook.Add("PlayerDisconnected", "zip::Disconnected", function(pl)
	if pl:isCarry() and IsValid(pl:isCarry()) then
		pl:isCarry():SetCarried(nil)
	end
end)
hook.Add("PlayerSwitchWeapon", "zip::PlayerSwitchWeapon", function(pl, oldWeapon, newWeapon)
	return pl:isHandcuffed()
end)

local nextSpec = 0
hook.Add("Move", "zip::Move", function(pl, mv)
	if not IsValid(pl) then return end

	if IsValid(pl:isCarried()) then
		local dist = pl:GetPos():Distance(pl:isCarried():GetPos())
		local LerpZiptied = LerpVector(0.15, pl:GetPos(), pl:isCarried():GetPos())

		if dist > 45 then
			mv:SetOrigin(LerpZiptied)
			pl:SelectWeightedSequence(ACT_WALK)
			mv:SetVelocity((LerpZiptied - pl:GetPos()):GetNormal() * 200)

			-- Отключаем коллизию
			if pl:GetCollisionGroup() ~= COLLISION_GROUP_WEAPON then
				pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			end
		end

		if dist > 250 then
			mp.util.Notify("yellow", pl, "Ведущий вас человек далеко, залом снят!")
			mp.util.Notify("yellow", pl:isCarried(), "Вы слишком далеко от человека, залом снят!")
			pl:isCarried():SetCarry(nil)
			pl:SetCarried(nil)
		end
	end
end)

hook.Add("PlayerCanPickupWeapon", "zip::canweapon", function(pl, weapon)
	if pl:isHandcuffed() or pl:isCarried() then
		return false
	end
end)

net.Receive("mp.HandCuff.ShowInfo", function(_, pl)
	pl.NextCarryPlayer = pl.NextCarryPlayer or 0
	if pl.NextCarryPlayer > CurTime() then return end

	pl.NextCarryPlayer = CurTime() + 1

	local wep = pl:GetActiveWeapon()
	local target = pl:GetEyeTrace().Entity

	if not target:IsPlayer() or not target:isHandcuffed() then return end
	if pl:GetPos():Distance(target:GetPos()) > 150 then
		mp.util.Notify("red", pl, "Игрок находится далеко!")
		return
	end
	if not IsValid(wep) or wep:GetClass() ~= "handcuffed" then return end

	target:ConCommand("mp pass")
end)

net.Receive("mp.HandCuff.Checker", function(_, pl)
	pl.NextCarryPlayer = pl.NextCarryPlayer or 0
	if pl.NextCarryPlayer > CurTime() then return end

	pl.NextCarryPlayer = CurTime() + 1

	local wep = pl:GetActiveWeapon()
	local target = pl:GetEyeTrace().Entity

	if not target:IsPlayer() or not target:isHandcuffed() then return end
	if pl:GetPos():Distance(target:GetPos()) > 150 then
		mp.util.Notify("red", pl, "Игрок находится далеко!")
		return
	end
	if not IsValid(wep) or wep:GetClass() ~= "handcuffed" then return end

	local has = false
	mp.util.Notify("base", pl, "Обыск оружия:")

	for k, v in ipairs(target:GetWeapons()) do
		if mp.config.skip_checker[v:GetClass()] then continue end

		pl:ChatPrint()
		mp.util.Notify("yellow", pl, v:GetPrintName())

		has = true
	end

	if not has then
		mp.util.Notify("red", pl, "Ничего не найдено!")
	end
end)

net.Receive("mp.HandCuff.Carry", function(_, pl)
	pl.NextCarryPlayer = pl.NextCarryPlayer or 0
	if pl.NextCarryPlayer > CurTime() then return end

	pl.NextCarryPlayer = CurTime() + 1

	local wep = pl:GetActiveWeapon()
	local target = pl:GetEyeTrace().Entity

	if not target:IsPlayer() or not target:isHandcuffed() then return end
	if pl:GetPos():Distance(target:GetPos()) > 150 then
		mp.util.Notify("red", pl, "Игрок находится далеко!")
		return
	end
	if not IsValid(wep) or wep:GetClass() ~= "handcuffed" then return end
	if IsValid(target:isCarried()) and target:isCarried() ~= pl then return end

	if target:isCarried() and target:isCarried() == pl then
		timer.Create("UnCollisionPlayer_" .. target:SteamID64(), 1, 1, function()
			if IsValid(target) then
				target:SetCollisionGroup(COLLISION_GROUP_NONE)
			end
		end)

		target:SetCarried(nil)
		pl:SetCarry(nil)
	elseif not target:isCarried() then
		target:SetCarried(pl)
		pl:SetCarry(target)
	end
end)
