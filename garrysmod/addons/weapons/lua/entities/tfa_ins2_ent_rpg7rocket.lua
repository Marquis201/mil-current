AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end

function ENT:Initialize()
    if SERVER then
        local size = 0.5
        self:SetModel( "models/tfa_ins2_wpns/rpg7/w_rpg7_projectile.mdl" )
        --[[self:SetMoveType( MOVETYPE_FLY )
        self:SetSolid( SOLID_BBOX )
        self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
        self:SetCollisionBounds(Vector(-size, -size, -size), Vector(size, size, size))]]
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
        local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(50)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
		end
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
        self:DrawShadow( true )
    end
end

function ENT:Think()
    if IsFirstTimePredicted() then
        local tr = EffectData()
        tr:SetOrigin(self:GetPos())
        tr:SetEntity(self)
        util.Effect("tfa_ins2_smoketrail", tr)
    end
end

function ENT:PhysicsCollide( data, phys )
    self:Touch()
end

function ENT:Touch()
    if SERVER then
        util.BlastDamage( self, self.Owner, self:GetPos(), 120, 255 )
        for _, ent in pairs(ents.FindInSphere(self:GetPos(), 150)) do
            if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
                ent:SetVelocity((ent:GetPos() - self:GetPos()):GetNormalized() * 150)
            end
            if IsValid(ent) and ent:IsNPC() and ent:Visible( self ) and ( table.HasValue( { "npc_combinegunship", "npc_helicopter", "npc_turret_floor", "npc_turret_ground", "npc_turret_ceiling" }, ent:GetClass() ) ) then
                ent:SetHealth(1)
                ent:Fire("selfdestruct","",.5)
            end
        end
        if self:WaterLevel() <= 0 then
            self:EmitSound("TFA_INS2_AT4.Detonate")
        else
            self:EmitSound("TFA_INS2_AT4.waterDetonate")
        end
        local ex = EffectData()
        ex:SetOrigin(self:GetPos())
        util.Effect("Explosion", ex)
        local tr = util.TraceLine( {
            start = self:GetPos(),
            endpos = self:GetPos() + self:GetForward() * 50000,
            filter = ent,
            mask = MASK_SHOT		
        } )
        util.ScreenShake(self:GetPos(), 10, 5, 1, 750 )
        util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
        self:Remove()
    end
end