local nets = {
	"hp_update",
	"hp_init",
	"hp_remove",
	"hp_refresh",
	"hp_dmgeffect",
}

local mp = mp
local hook = hook
local net = net
local PLAYER = PLAYER
local math_Clamp = math.Clamp

local HemocoagulationBlooding = 0
local PercentBlooding = 0
local PercentConcussion = 0
local PercentFracture = 0
local PercentDamage = 0
local ExpBlooding = 0
local ExpFracture = 0
local ExpConcussion = 0

for k, v in ipairs(nets) do
	util.AddNetworkString(v)
end

function PlayerSpawnHP(ply)
	timer.Create("IntHP", 1, 1, function()
		ply:HPinit()
	end)
end

hook.Add("PlayerSpawn", "PlayerSpawnHP", PlayerSpawnHP)

local stats = mp.body_stats

function PLAYER:HPinit()
	self.Head = stats.head
	self.Torso = stats.torso
	self.LeftArm = stats.l_arm
	self.RightArm = stats.r_arm
	self.LeftLeg = stats.l_leg
	self.RightLeg = stats.r_leg

	self.Blooding = false
	self.Fracture = false
	self.Concussion = false
	self.Burns = false

	net.Start("hp_init")
	net.Send(self)
end

function PLAYER:HPUpdate()
	net.Start("hp_update")
	net.WriteInt(self.Head, 11)
	net.WriteInt(self.Torso, 11)
	net.WriteInt(self.LeftArm, 11)
	net.WriteInt(self.RightArm, 11)
	net.WriteInt(self.LeftLeg, 11)
	net.WriteInt(self.RightLeg, 11)

	net.WriteBool(self.Blooding)
	net.WriteBool(self.Fracture)
	net.WriteBool(self.Concussion)
	net.WriteBool(self.Burns)
	net.Send(self)

	if self:GetConcussion() then
		self:SetDSP(16)
	else
		self:SetDSP(0)
	end
end

function PLAYER:HPSet(val)
	self.Head = math_Clamp(self.Head + val, 0, stats.head)
	self.Torso = math_Clamp(self.Torso + val, 0, stats.torso)
	self.LeftArm = math_Clamp(self.LeftArm + val, 0, stats.l_arm)
	self.RightArm = math_Clamp(self.RightArm + val, 0, stats.r_arm)
	self.LeftLeg = math_Clamp(self.LeftLeg + val, 0, stats.l_leg)
	self.RightLeg = math_Clamp(self.RightLeg + val, 0, stats.r_leg)

	self:HPUpdate()
end

function PLAYER:HPBurns(bool)
	self.Burns = bool

	self:HPUpdate()
end

function PLAYER:HPConcussion(bool)
	self.Concussion = bool

	self:HPUpdate()
end

function PLAYER:HPBlooding(bool)
	self.Blooding = bool

	self:HPUpdate()
end

function PLAYER:HPFracture(bool)
	self.Fracture = bool

	self:HPUpdate()
end

concommand.Add("hp_reoload", function(ply, cmd, args)
	ply:HPinit()
end)

function PLAYER:HPrefresh()
	net.Start("hp_refresh")
	net.Send(self)
end

local function PercentConcussionSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[25].level) then
		PercentConcussion = PERKS[25].effect
	elseif ply:HasLevel(PERKS[24].level) then
		PercentConcussion = PERKS[24].effect
	elseif ply:HasLevel(PERKS[23].level) then
		PercentConcussion = PERKS[23].effect
	else
		PercentConcussion = PERKS[23].effect + 5
	end

	return PercentConcussion
end

local function PercentFractureSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[3].level) then
		PercentFracture = PERKS[3].effect
	elseif ply:HasLevel(PERKS[2].level) then
		PercentFracture = PERKS[2].effect
	elseif ply:HasLevel(PERKS[1].level) then
		PercentFracture = PERKS[1].effect
	else
		PercentFracture = PERKS[1].effect + 5
	end

	return PercentFracture
end

local function ExpConcussionSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[25].level) then
		ExpConcussion = PERKS[25].exp
	elseif ply:HasLevel(PERKS[24].level) then
		ExpConcussion = PERKS[24].exp
	elseif ply:HasLevel(PERKS[23].level) then
		ExpConcussion = PERKS[23].exp
	else
		ExpConcussion = PERKS[23].exp + 5
	end

	return ExpConcussion
end


local function ExpFractureSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[3].level) then
		ExpFracture = PERKS[3].exp
	elseif ply:HasLevel(PERKS[2].level) then
		ExpFracture = PERKS[2].exp
	elseif ply:HasLevel(PERKS[1].level) then
		ExpFracture = PERKS[1].exp
	else
		ExpFracture = PERKS[1].exp + 5
	end

	return ExpFracture
end

local function ExpBloodingSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[6].level) then
		ExpBlooding = PERKS[6].exp
	elseif ply:HasLevel(PERKS[5].level) then
		ExpBlooding = PERKS[5].exp
	elseif ply:HasLevel(PERKS[4].level) then
		ExpBlooding = PERKS[4].exp
	else
		ExpBlooding = PERKS[4].exp + 1
	end

	return ExpBlooding
end

local function PercentBloodingSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[6].level) then
		PercentBlooding = PERKS[6].effect
	elseif ply:HasLevel(PERKS[5].level) then
		PercentBlooding = PERKS[5].effect
	elseif ply:HasLevel(PERKS[4].level) then
		PercentBlooding = PERKS[4].effect
	else
		PercentBlooding = PERKS[4].effect + 5
	end

	return PercentBlooding
end

local function PercentDamageSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[16].level) then
		PercentDamage = PERKS[16].effect
	elseif ply:HasLevel(PERKS[15].level) then
		PercentDamage = PERKS[15].effect
	elseif ply:HasLevel(PERKS[14].level) then
		PercentDamage = PERKS[14].effect
	else
		PercentDamage = 0
	end

	return PercentDamage
end

local function HemocoagulationSystem(ply)
	local PERKS = mp.Perks
	if ply:HasLevel(PERKS[28].level) then
		HemocoagulationBlooding = PERKS[28].effect
	elseif ply:HasLevel(PERKS[27].level) then
		HemocoagulationBlooding = PERKS[27].effect
	elseif ply:HasLevel(PERKS[26].level) then
		HemocoagulationBlooding = PERKS[26].effect
	else
		HemocoagulationBlooding = 0
	end

	return HemocoagulationBlooding
end

local function BurnsSystem(ply)
	timer.Create("BurnsTime", 1, 5, function()
		if timer.RepsLeft("BurnsTime") <= 1 then
			ply:HPBurns(false)
		end

		if not ply:GetBurns() then
			timer.Remove("BurnsTime")
		end
	end)
end

local function ConcussionSystem(ply)
	timer.Create("ConcussionTime", 1, 10, function()
		if timer.RepsLeft("ConcussionTime") <= 1 then
			ply:HPConcussion(false)
		end

		if not ply:GetConcussion() then
			timer.Remove("ConcussionTime")
		end
	end)
end

local function BloodingSystem(ply)
	if ply:GetBlooding() then
		HemocoagulationSystem(ply)

		timer.Create("BloodTime", 1, 30 - SetTI(30, HemocoagulationBlooding), function()
			if timer.RepsLeft("BloodTime") > 1 then
				ply:SetHealth(ply:Health() - 1)

				if ply:Health() <= 0 then
					ply:Kill()
				end

				ExpBloodingSystem(ply)
				ply:AddPlayerEXP(ExpBlooding, false)
			else
				ply:HPBlooding(false)
			end

			net.Start("hp_dmgeffect")
			net.Send(ply)

			if ! ply:GetBlooding() then
				timer.Remove("BloodTime")
			elseif ! ply:Alive() then
				timer.Remove("BloodTime")
			end
		end)
	end
end

local function ScalePlayerDamage(ply, hitgroup, dmginfo)
	if (! IsValid(ply) or ! ply:IsPlayer()) then return end
	local DmgLimbs
	local ArmorProtect

	PercentDamageSystem(ply)

	if (ply.Torso == 0) then
		DmgLimbs = 2
	else
		DmgLimbs = 1
	end

	if (ply:Armor() > 0) then
		ArmorProtect = 0.9
	else
		ArmorProtect = 1
	end

	if dmginfo:IsBulletDamage() or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage() then
		if (hitgroup == HITGROUP_HEAD) then
			dmginfo:ScaleDamage(1.25 * DmgLimbs - (1 / 100 * PercentDamage))
			ply.Head = math.max(ply.Head - dmginfo:GetDamage() * ArmorProtect, 0)
		elseif (hitgroup == HITGROUP_LEFTARM) then
			dmginfo:ScaleDamage(0.75 * DmgLimbs - (1 / 100 * PercentDamage))
			ply.LeftArm = math.max(ply.LeftArm - dmginfo:GetDamage(), 0)
		elseif (hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.75 * DmgLimbs - (1 / 100 * PercentDamage))
			ply.RightArm = math.max(ply.RightArm - dmginfo:GetDamage(), 0)
		elseif (hitgroup == HITGROUP_LEFTLEG) then
			ply.LeftLeg = math.max(ply.LeftLeg - dmginfo:GetDamage(), 0)
			dmginfo:ScaleDamage(0.75 * DmgLimbs - (1 / 100 * PercentDamage))
		elseif (hitgroup == HITGROUP_RIGHTLEG) then
			dmginfo:ScaleDamage(0.75 * DmgLimbs - (1 / 100 * PercentDamage))
			ply.RightLeg = math.max(ply.RightLeg - dmginfo:GetDamage(), 0)
		else
			dmginfo:ScaleDamage(1.25 * DmgLimbs - (1 / 100 * PercentDamage))
			ply.Torso = math.max(ply.Torso - dmginfo:GetDamage() * ArmorProtect, 0)
		end
	end

	ply:HPUpdate()
end
hook.Add("ScalePlayerDamage", "ScalePlayerDamage", ScalePlayerDamage)

local function EntityTakeDamage(ply, dmginfo)
	local PERKS = mp.Perks

	if (! IsValid(ply) or ! ply:IsPlayer()) then return end
	if (dmginfo:GetMaxDamage() <= 0) then return end

	if (! dmginfo:IsBulletDamage()) then
		if (dmginfo:IsFallDamage()) then
			ply.RightLeg = math.max(ply.RightLeg - dmginfo:GetDamage() / 2, 0)
			ply.LeftLeg = math.max(ply.LeftLeg - dmginfo:GetDamage() / 2, 0)
		elseif (dmginfo:IsExplosionDamage() or dmginfo:IsDamageType(DMG_GENERIC) or dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_AIRBOAT)) then
			ply.Head = math.max(ply.Head - dmginfo:GetDamage() / 2, 0)
			ply.LeftArm = math.max(ply.LeftArm - dmginfo:GetDamage() / 2, 0)
			ply.RightArm = math.max(ply.RightArm - dmginfo:GetDamage() / 2, 0)
			ply.LeftLeg = math.max(ply.LeftLeg - dmginfo:GetDamage() / 2, 0)
			ply.RightLeg = math.max(ply.RightLeg - dmginfo:GetDamage() / 2, 0)
			ply.Torso = math.max(ply.Torso - dmginfo:GetDamage() / 2, 0)
		else
			ply.Head = math.max(ply.Head - dmginfo:GetDamage() / 8, 0)
			ply.LeftArm = math.max(ply.LeftArm - dmginfo:GetDamage() / 8, 0)
			ply.RightArm = math.max(ply.RightArm - dmginfo:GetDamage() / 8, 0)
			ply.LeftLeg = math.max(ply.LeftLeg - dmginfo:GetDamage() / 8, 0)
			ply.RightLeg = math.max(ply.RightLeg - dmginfo:GetDamage() / 8, 0)
			ply.Torso = math.max(ply.Torso - dmginfo:GetDamage() / 8, 0)
		end
	end

	local randomBlood = math.random(0, 100)
	local randomFracture = math.random(0, 100)
	local randomConcussion = math.random(0, 100)
	local randomHealth = math.random(0, 100)

	if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_BUCKSHOT) or dmginfo:IsDamageType(DMG_SNIPER) or dmginfo:IsDamageType(DMG_CLUB) then
		if not ply:GetBlooding() then
			PercentBloodingSystem(ply)

			if randomBlood <= PercentBlooding then
				ply.Blooding = true

				BloodingSystem(ply)
			end
		end

		if not ply:GetConcussion() and (ply:LastHitGroup() == HITGROUP_HEAD) then
			if ply:GetHead() <= 0 and ply:Health() < 25 then
				ExpConcussionSystem(ply)
				ply:AddPlayerEXP(ExpConcussion, false)

				ply.Concussion = true

				ConcussionSystem(ply)
			else
				PercentConcussionSystem(ply)

				if randomConcussion <= PercentConcussion then
					ply.Concussion = true

					ConcussionSystem(ply)
				end
			end
		end
	end

	if not ply:GetBurns() and dmginfo:IsDamageType(DMG_BURN) then
		ply.Burns = true

		BurnsSystem(ply)
	end

	if ply:GetBrokenLimbs() then
		ExpFractureSystem(ply)
		ply:AddPlayerEXP(ExpFracture, false)

		ply.Fracture = true
	end

	if not ply:GetFracture() and (dmginfo:IsDamageType(DMG_FALL) or dmginfo:IsDamageType(DMG_BLAST)) then
		PercentFractureSystem(ply)

		if randomFracture <= PercentFracture then
			ply.Fracture = true
		end
	end

	if ply:HasLevel(PERKS[7].level) then
		if randomHealth == 1 then
			ply:SetHealth(ply:GetMaxHealth() / 2)
		end
	end

	net.Start("hp_dmgeffect")
	net.Send(ply)

	ply:HPUpdate()
end
hook.Add("EntityTakeDamage", "EntityTakeDamage", EntityTakeDamage)
