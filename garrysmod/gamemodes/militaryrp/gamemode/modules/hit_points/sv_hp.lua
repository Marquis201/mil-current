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
local PercentFracture = 30
local PercentDamage = 0
local ExpBlooding = 0
local ExpFracture = 0
local ExpConcussion = 0

for k, v in ipairs(nets) do
	util.AddNetworkString(v)
end

function PlayerSpawnHP(ply)
	if ply.BeingRevived then return end
	timer.Create("IntHP", 1, 1, function()
		ply:HPinit()
	end)
end

hook.Add("PlayerSpawn", "PlayerSpawnHP", PlayerSpawnHP)

local stats = mp.body_stats

function PLAYER:HPinit()
	if not IsValid(self) then return end

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
	if not IsValid(self) then return end

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
	if not IsValid(self) then return end

	self.Head = math_Clamp(self.Head + val, 0, stats.head)
	self.Torso = math_Clamp(self.Torso + val, 0, stats.torso)
	self.LeftArm = math_Clamp(self.LeftArm + val, 0, stats.l_arm)
	self.RightArm = math_Clamp(self.RightArm + val, 0, stats.r_arm)
	self.LeftLeg = math_Clamp(self.LeftLeg + val, 0, stats.l_leg)
	self.RightLeg = math_Clamp(self.RightLeg + val, 0, stats.r_leg)

	self:HPUpdate()
end

function PLAYER:HPSetCustom(val)
	if not IsValid(self) then return end

	self.Head = math_Clamp(self.Head + stats.head * val, 0, stats.head)
	self.Torso = math_Clamp(self.Torso + stats.torso * val, 0, stats.torso)
	self.LeftArm = math_Clamp(self.LeftArm + stats.l_arm * val, 0, stats.l_arm)
	self.RightArm = math_Clamp(self.RightArm + stats.r_arm * val, 0, stats.r_arm)
	self.LeftLeg = math_Clamp(self.LeftLeg + stats.l_leg * val, 0, stats.l_leg)
	self.RightLeg = math_Clamp(self.RightLeg + stats.r_leg * val, 0, stats.r_leg)

	self:HPUpdate()
end

function PLAYER:HPBurns(bool)
	if not IsValid(self) then return end

	self.Burns = bool

	self:HPUpdate()
end

function PLAYER:HPConcussion(bool)
	self.Concussion = bool

	self:HPUpdate()
end

function PLAYER:HPBlooding(bool)
	if not IsValid(self) then return end

	self.Blooding = bool

	self:HPUpdate()
end

function PLAYER:HPFracture(bool)
	if not IsValid(self) then return end
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
	timer.Create("ConcussionTime", 1, 5, function()
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
		timer.Create("BloodTime", 1, 15 - SetTI(15, HemocoagulationBlooding), function()
			if timer.RepsLeft("BloodTime") > 1 then
				ply:SetHealth(ply:Health() - 1)

				if ply:Health() <= 0 then
					ply:Kill()
				end
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
	if ply:HasGodMode() then
		dmginfo:ScaleDamage(0)
		return
	end

	local attacker = dmginfo:GetAttacker()
	local amount = 1
	local dmg = dmginfo:GetDamage()

	if IsValid(attacker) and attacker:IsPlayer() then
		if attacker:GetFaction() and ply:GetFaction() and attacker:GetFaction() == ply:GetFaction() then
			amount = amount / 2
		end
		if attacker:HasGodMode() then
			dmginfo:ScaleDamage(0)
			return
		end

		if attacker:GetNetVar("mp.PlayerTir") then
			dmginfo:ScaleDamage(0)
		end
	end

	if dmginfo:IsBulletDamage() or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage() then
		if (hitgroup == HITGROUP_HEAD) then
			amount = amount * 1.25
			ply.Head = math.max(ply.Head - (dmg * amount), 0)
		elseif (hitgroup == HITGROUP_LEFTARM) then
			amount = amount * .25
			ply.LeftArm = math.max(ply.LeftArm - (dmg * amount), 0)
		elseif (hitgroup == HITGROUP_RIGHTARM) then
			amount = amount * .25
			ply.RightArm = math.max(ply.RightArm - (dmg * amount), 0)
		elseif (hitgroup == HITGROUP_LEFTLEG) then
			amount = amount * .35
			ply.LeftLeg = math.max(ply.LeftLeg - (dmg * amount), 0)
		elseif (hitgroup == HITGROUP_RIGHTLEG) then
			amount = amount * .35
			ply.RightLeg = math.max(ply.RightLeg - (dmg * amount), 0)
		else
			amount = amount * .5
			ply.Torso = math.max(ply.Torso - dmginfo:GetDamage(), 0)
		end
	end

	local scale = (amount - (1 / 100 * PercentDamage))

	local perk = ply:GetNetVar("mp.Perks") or {}
	if perk.id and perk.id == "protect_damage" and perk.duration > CurTime() then
		scale = scale * .8
	end

	dmginfo:ScaleDamage(scale)
	ply:HPUpdate()
end
hook.Add("ScalePlayerDamage", "ScalePlayerDamage", ScalePlayerDamage)


local function EntityTakeDamage(ply, dmginfo)
	if (! IsValid(ply) or ! ply:IsPlayer()) then return end
	if (dmginfo:GetDamage() <= 0) then return end
	if ply:HasGodMode() then return end

	local dmg = dmginfo:GetDamage()

	if (! dmginfo:IsBulletDamage()) then
		if (dmginfo:IsFallDamage()) then
			ply.RightLeg = math.max(ply.RightLeg - dmg / 2, 0)
			ply.LeftLeg = math.max(ply.LeftLeg - dmg / 2, 0)
		elseif (dmginfo:IsExplosionDamage() or dmginfo:IsDamageType(DMG_GENERIC) or dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_AIRBOAT)) then
			ply.Head = math.max(ply.Head - dmg / 2, 0)
			ply.LeftArm = math.max(ply.LeftArm - dmg / 2, 0)
			ply.RightArm = math.max(ply.RightArm - dmg / 2, 0)
			ply.LeftLeg = math.max(ply.LeftLeg - dmg / 2, 0)
			ply.RightLeg = math.max(ply.RightLeg - dmg / 2, 0)
			ply.Torso = math.max(ply.Torso - dmg / 2, 0)
		else
			ply.Head = math.max(ply.Head - dmg / 8, 0)
			ply.LeftArm = math.max(ply.LeftArm - dmg / 8, 0)
			ply.RightArm = math.max(ply.RightArm - dmg / 8, 0)
			ply.LeftLeg = math.max(ply.LeftLeg - dmg / 8, 0)
			ply.RightLeg = math.max(ply.RightLeg - dmg / 8, 0)
			ply.Torso = math.max(ply.Torso - dmg / 8, 0)
		end
	end

	local randomBlood = math.random(0, 100)
	local randomFracture = math.random(0, 100)
	local randomConcussion = math.random(0, 100)
	local randomHealth = math.random(0, 100)

	if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_BUCKSHOT) or dmginfo:IsDamageType(DMG_SNIPER) or dmginfo:IsDamageType(DMG_CLUB) then
		if not ply:GetBlooding() then
			if randomBlood <= PercentBlooding then
				ply.Blooding = true

				BloodingSystem(ply)
			end
		end

		if not ply:GetConcussion() and (ply:LastHitGroup() == HITGROUP_HEAD) then
			if ply:GetHead() <= 0 and ply:Health() < 25 then
				ply.Concussion = true

				ConcussionSystem(ply)
			else
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

	if ply:GetBrokenLimbs() and randomFracture <= PercentFracture then
		ply.Fracture = true

		timer.Create("RemoveFracture" .. ply:SteamID64(), 30, 1, function()
			ply:HPFracture(false)
		end)
	end

	if not ply:GetFracture() and (dmginfo:IsDamageType(DMG_FALL) or dmginfo:IsDamageType(DMG_BLAST)) then
		if randomFracture <= PercentFracture then
			ply.Fracture = true

			timer.Create("RemoveFracture" .. ply:SteamID64(), 30, 1, function()
				ply:HPFracture(false)
			end)
		end
	end

	net.Start("hp_dmgeffect")
	net.Send(ply)

	ply:HPUpdate()
end
hook.Add("EntityTakeDamage", "EntityTakeDamage", EntityTakeDamage)
