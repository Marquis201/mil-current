AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal )
	ent:SetAngles( Angle(0, ply:EyeAngles().y, 0 ) )
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply
	return ent
end
function ENT:Initialize()
    self:SetModel("models/sw/shared/airdrop.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(3)
    self:SetVar(1, 10)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
    self.Broken = false
end
function ENT:Think()
    self:NextThink(CurTime()+0.05)
    if self:GetVelocity():Length() >= 500 then
        timer.Simple(1,function()
            if IsValid(self) then
                if self.Broken then return end
                if self:GetOpen() == false and not self:IsPlayerHolding() then
                    self:SetOpen(true)
                    self:EmitSound("sw/misc/chute_1.wav")
                    self.Chute = ents.Create("prop_physics")
                    self.Chute:SetModel("models/sw/shared/chute_2.mdl")	
                    self.Chute:SetPos(self:GetPos()+self:GetUp()*25)
                    self.Chute:SetAngles(self:GetAngles())
                    self.Chute:Spawn()
                    self.Chute:Activate()
                    self.Chute.Owner=self.Owner
                    self.Chute:PhysWake()
                    self.Chute:GetPhysicsObject():EnableDrag(true)
                    self.Chute:GetPhysicsObject():SetMass(100)
                    local Wire = constraint.Rope(self,self.Chute,0,0,Vector(30,0,20),Vector(0,0,0),150,0,0,1 )
                    if IsValid(self.Chute) then
                        self.Chute:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*1)
                    end
                end
            end
        end)
    else
        if self:GetVelocity():Length() <= 10 then
            if IsValid(self) then
                if self:GetOpen() == true and not self:IsPlayerHolding() then
                    timer.Simple(1,function()
                        if IsValid(self) then
                            if self:GetOpen() == true and not self:IsPlayerHolding() then
                                if IsValid(self.Chute) then
                                    self.Chute:Remove()
                                end

                                self:SetOpen(false)
                            end
                        end
                    end)
                end
            end
        end
    end

    if self:GetHP() <= 0 then
        if !self.Broken then
            self.Broken = true
        end
    end
end
function giveammo(ply)
    local wep = ply:GetActiveWeapon()
    local priAmmo = wep:GetPrimaryAmmoType()
    local secAmmo = wep:GetSecondaryAmmoType()
    local priMag = wep:GetMaxClip1()
    local secMag = wep:GetMaxClip2()
    if priAmmo == -1 and secAmmo == -1 then
        return false
    end
    if priMag ~= -1 then
        ply:GiveAmmo( (priMag*2), priAmmo )
        if secAmmo ~= -1 then
            ply:GiveAmmo( 1, secAmmo )
        end
        return true
    elseif priMag == -1 then
        ply:GiveAmmo( 1, priAmmo )
        return true
    end
    if priAmmo == -1 and secMag ~= -1 then
        ply:GiveAmmo( 1, secAmmo )
        return true
    end
    return false
end
function ENT:Use( ply )
    if self.Broken then return end
    local tab = self:GetTable()
    if tab[1] == 10 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 9 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 8 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 7 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 6 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 5 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 4 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 3 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 2 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 1 then
        if giveammo(ply) == true then
            self:Remove()
        end
    end
end

--Damage
function ENT:PhysicsCollide( data )
	if data.Speed > 5 and data.DeltaTime > 0.1 then
		local VelDif = data.OurOldVelocity:Length() - data.OurNewVelocity:Length()

		if VelDif > 50 then
			self:SetHP( self:GetHP() - VelDif*2 )
		end
	end
end
function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )

	local Damage = dmginfo:GetDamage()
	local CurHealth = self:GetHP()
	local NewHealth = CurHealth - Damage
	local ShieldCanBlock = dmginfo:IsBulletDamage() or dmginfo:IsDamageType( DMG_AIRBOAT )

	self:SetHP( NewHealth )
end

function ENT:OnRemove()
	if IsValid(self.Chute) then
		self.Chute:Remove()
	end
end