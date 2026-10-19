local model = "models/hoff/weapons/briefcasebomb/w_briefcasebomb.mdl"
local classname = "briefcase_bomb"
local ShouldSetOwner = true

-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
-------------------------------

--------------------
-- Spawn Function --
--------------------
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 25
	local ent = ents.Create( classname )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	if ShouldSetOwner then
		ent.Owner = ply
	end
	return ent

end

----------------
-- Initialize --
----------------
function ENT:Initialize()

	self:SetModel( model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	local CountdownTimer = ConVarExists("BriefcaseBomb_Countdown") and GetConVar("BriefcaseBomb_Countdown"):GetInt() or 30
	self:SetNWInt("CountdownTimer", CountdownTimer)

	timer.Create("BriefcaseFuse" .. self:EntIndex(),1,0,function()
		if !IsValid(self) then
			return
		end
		local CurrentCountdown = self:GetNWInt("CountdownTimer")
		if CurrentCountdown - 1 <= 0 then
			timer.Remove("BriefcaseFuse" .. self:EntIndex())
			self:Explode()
		else
			if ConVarExists("BriefcaseBomb_BeepSound") and GetConVar("BriefcaseBomb_BeepSound"):GetBool() then
				self:EmitSound(Sound("weapons/c4/c4_beep1.wav"), 65)
			end
			self:SetNWInt("CountdownTimer", CurrentCountdown - 1)
		end
	end)
end

function ENT:Explode()
	local explode = ents.Create( "env_explosion" )
	explode:SetPos( self:GetPos() )

	explode:SetOwner( self:GetOwner() ) 
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", GetConVar("BriefcaseBomb_Magnitude"):GetString() )
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 )

	local shake = ents.Create( "env_shake" )
		shake:SetOwner( self:GetOwner() )
		shake:SetPos( self:GetPos() )
		shake:SetKeyValue( "amplitude", "2000" )
		shake:SetKeyValue( "radius", "400" )
		shake:SetKeyValue( "duration", "2.5" )
		shake:SetKeyValue( "frequency", "255" )
		shake:SetKeyValue( "spawnflags", "4" )
		shake:Spawn()
		shake:Activate()
		shake:Fire( "StartShake", "", 0 )

	self:Remove()
end

-----------------
-- Take Damage -- 
-----------------
function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

------------
-- On use --
------------
function ENT:Use( activator, caller )
	if self:GetNWBool("bBeingUsed") == true then
		return
	end
	self:SetNWBool("bBeingUsed", true)

	if IsValid(activator) then
		if activator:HasWeapon("weapon_hoff_briefcasebomb") then
			if !activator:GetActiveWeapon():GetNWBool("bDefusing") then
				activator:StripWeapon("weapon_hoff_briefcasebomb")
			else
				return
			end
		end
		activator:Give("weapon_hoff_briefcasebomb")
		activator:SelectWeapon("weapon_hoff_briefcasebomb")
		timer.Simple(0.5, function()
			if !IsValid(activator) or !IsValid(activator:GetActiveWeapon()) or activator:GetActiveWeapon():GetClass() != "weapon_hoff_briefcasebomb" then
				return
			end
			activator:GetActiveWeapon():StartDefuse(self:GetPos(), self:GetAngles(), self:GetNWInt("CountdownTimer"))
			activator:AddFlags(FL_ATCONTROLS)
			self:Remove()
		end)
	end
end

-----------
-- Think --
-----------
function ENT:Think()

end

-----------
-- Touch --
-----------
function ENT:Touch(ent)

end

--------------------
-- PhysicsCollide -- 
--------------------
function ENT:PhysicsCollide( data, physobj )

end