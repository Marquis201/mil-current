AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:Mount( ent )
	if IsValid( self._MountEnt ) or ent._IsMounted then return end

	if ent:IsPlayerHolding() then return end
	local ID = self:LookupAttachment( "muzzle" )
	local Attachment = self:GetAttachment( ID )

	ent:SetOwner( self )
	ent:SetPos( Attachment.Pos+Attachment.Ang:Up()*ent.CatapultPos or 0 )
	ent:SetAngles( Attachment.Ang )
	ent:SetlvsLockedStatus( true )
	ent:SetHP(ent:GetMaxHP())
	ent:WeaponRestoreAmmo()
	ent:OnMaintenance()


	ent._MountOriginalCollision = ent:GetCollisionGroup()
	self._MountEnt = ent
	ent._IsMounted = true

	ent:SetCollisionGroup( COLLISION_GROUP_WORLD )

	self._MountConstraint = constraint.Weld( ent, self, 0, 0, 0, false, false )

	ent:RebuildCrosshairFilterEnts()
end

function ENT:Dismount()
	if not IsValid( self._MountEnt ) or not IsValid( self._MountConstraint ) then return end

	self._MountConstraint:Remove()

	self._MountEnt._IsMounted = nil

	local ent = self._MountEnt

	timer.Simple(0.1, function()
		if not IsValid( ent ) then return end

		ent:SetOwner( NULL )
		ent:SetlvsLockedStatus( true )
		if not ent:IsPlayerHolding() then
			ent:SetEngineActive(true)
			ent:GetPhysicsObject():AddVelocity(ent:GetUp()*150)
			ent:GetPhysicsObject():AddVelocity(ent:GetForward()*1500)
		end
	end)

	timer.Simple(1,function()
		if ent._MountOriginalCollision then
			ent:SetCollisionGroup( ent._MountOriginalCollision )

			ent._MountOriginalCollision = nil
		end

		self._MountEnt.CrosshairFilterEnts = nil

		self._MountEnt = nil
	end)
end

function ENT:OnCollision( data, physobj )
	local ent = data.HitEntity

	if not IsValid( ent ) or not (ent.LVSUAV and ent.CatapultLaunchable) then return end

	timer.Simple(0, function()
		if not IsValid( self ) or not IsValid( ent ) then return end

		self:Mount( ent )
	end)
end

function ENT:OnTick()
	if not IsValid( self._MountEnt ) or not self._MountEnt:IsPlayerHolding() then return end

	self:Dismount()
end

function ENT:Use( ply )
	if not IsValid( self._MountEnt ) then return end

	self:Dismount()
end

function ENT:OnRemove()
	self:Dismount()
end