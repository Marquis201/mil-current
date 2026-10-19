util.AddNetworkString('StaminaShow')

local mp = mp
local CurTime = CurTime

function PLAYER:SetAP(point)
	self:SetNetVar('ActionPoint', math.Clamp(point, 0, self:GetMaxAP()))
end

function PLAYER:AddAP(point)
	local AP = self:GetAP()

	self:SetAP(AP + point)
end

function PLAYER:TakeAP(point)
	local AP = self:GetAP()

	self:SetAP(AP - point)
end

local function PlayerStats(pl, num)
	if not pl.OldWalkSpeed or not pl.OldRunSpeed or not pl.OldJumpPower then return end

	if num <= 10 then
		WalkSpeed = pl.OldWalkSpeed * .8
		RunSpeed = pl.OldRunSpeed * .5
		JumpPower = 0
	elseif pl:GetFracture() then
		WalkSpeed = pl.OldWalkSpeed * .5
		RunSpeed = pl.OldRunSpeed * .2
		JumpPower = 0
	elseif pl:GetBurns() then
		WalkSpeed = pl.OldWalkSpeed * .5
		RunSpeed = pl.OldRunSpeed * .5
		JumpPower = 0
	else
		WalkSpeed = pl.OldWalkSpeed
		RunSpeed = pl.OldRunSpeed
		JumpPower = pl.OldJumpPower
	end

	if JumpPower ~= pl:GetJumpPower() then
		pl:SetJumpPower(JumpPower)
	end

	if RunSpeed ~= pl:GetRunSpeed() then
		pl:SetRunSpeed(RunSpeed)
	end

	if WalkSpeed ~= pl:GetWalkSpeed() then
		pl:SetWalkSpeed(WalkSpeed)
	end
end

local addAP = 10

hook.Add("PlayerTick", "Stamina", function(pl, mv)
	if not pl:Alive() or pl:InVehicle() then return end

	local AP = pl:GetAP()
	local MaxAP = pl:GetMaxAP()
	local Move = pl:GetMoveType()
	local nextAddAP = 2

	pl.down_space = pl.down_space or 0

	local Sprint = pl:GetVelocity():Length2D() > pl:GetRunSpeed() * 0.6 and pl:IsSprinting() and pl:OnGround()
	pl.NextAddStamina = pl.NextAddStamina or 0
	pl.NextTakeStamina = pl.NextTakeStamina or 0
	pl.NextAddEXPStamina = pl.NextAddEXPStamina or 0

	if Sprint and not mv:KeyDown(IN_JUMP) and Move ~= MOVETYPE_NOCLIP and pl.NextTakeStamina < CurTime() and AP > 0 then
		pl:TakeAP(1)

		local time = 0.5

		local perk = pl:GetNetVar("mp.Perks") or {}
		if perk.id and perk.id == "add_speed" and perk.duration > CurTime() then
			time = 1
		end

		pl.NextAddStamina = CurTime() + nextAddAP
		pl.NextTakeStamina = CurTime() + time
	end

	if AP < MaxAP and pl.NextAddStamina < CurTime() then
		pl:AddAP(addAP)

		pl.NextAddStamina = CurTime() + 1
	end

	PlayerStats(pl, AP)
end)

hook.Add("KeyPress", "mp.Stamina", function(pl, key)
	if not pl:Alive() or pl:InVehicle() then return end

	local AP = pl:GetAP()
	local MaxAP = pl:GetMaxAP()
	local nextAddAP = 2

	pl.NextAddStamina = pl.NextAddStamina or 0

	if (key == IN_JUMP) and pl:OnGround() and AP > 0 then
		local take = 6
		local perk = pl:GetNetVar("mp.Perks") or {}
		if perk.id and perk.id == "add_speed" and perk.duration > CurTime() then
			take = 3
		end

		pl:TakeAP(take)
		pl.NextAddStamina = CurTime() + nextAddAP
	end
end)
