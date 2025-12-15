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
    self:SetModel("models/sw/shared/airdrop_large.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(3)
    self:SetVar(1, 22)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:SetMass(5000)
    end
    self:SetBodygroup(1,1)
    self.Broken = false
    self.Smoking = false
    self.SmokeAmount = 100
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
                    self:SetBodygroup(1,0)

                    self.Chute1 = ents.Create("prop_physics")
                    self.Chute1:SetModel("models/sw/shared/chute_2.mdl")	
                    self.Chute1:SetPos(self:GetPos()+self:GetRight()*250+self:GetUp()*25)
                    self.Chute1:SetAngles(self:GetAngles())
                    self.Chute1:Spawn()
                    self.Chute1:Activate()
                    self.Chute1.Owner=self.Owner
                    self.Chute1:PhysWake()
                    self.Chute1:GetPhysicsObject():EnableDrag(true)
                    self.Chute1:GetPhysicsObject():SetMass(100)
                    local Wire1 = constraint.Rope(self,self.Chute1,0,0,Vector(0,0,72),Vector(0,0,0),500,0,0,1 )

                    self.Chute2 = ents.Create("prop_physics")
                    self.Chute2:SetModel("models/sw/shared/chute_2.mdl")	
                    self.Chute2:SetPos(self:GetPos()-self:GetRight()*250+self:GetUp()*25)
                    self.Chute2:SetAngles(self:GetAngles())
                    self.Chute2:Spawn()
                    self.Chute2:Activate()
                    self.Chute2.Owner=self.Owner
                    self.Chute2:PhysWake()
                    self.Chute2:GetPhysicsObject():EnableDrag(true)
                    self.Chute2:GetPhysicsObject():SetMass(100)
                    local Wire2 = constraint.Rope(self,self.Chute2,0,0,Vector(0,0,72),Vector(0,0,0),500,0,0,1 )

                    self.Chute3 = ents.Create("prop_physics")
                    self.Chute3:SetModel("models/sw/shared/chute_2.mdl")	
                    self.Chute3:SetPos(self:GetPos()+self:GetForward()*250+self:GetUp()*25)
                    self.Chute3:SetAngles(self:GetAngles())
                    self.Chute3:Spawn()
                    self.Chute3:Activate()
                    self.Chute3.Owner=self.Owner
                    self.Chute3:PhysWake()
                    self.Chute3:GetPhysicsObject():EnableDrag(true)
                    self.Chute3:GetPhysicsObject():SetMass(100)
                    local Wire3 = constraint.Rope(self,self.Chute3,0,0,Vector(0,0,72),Vector(0,0,0),500,0,0,1 )

                    if IsValid(self.Chute1) then
                        self.Chute1:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*1)
                    end
                    if IsValid(self.Chute2) then
                        self.Chute2:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*1)
                    end
                    if IsValid(self.Chute3) then
                        self.Chute3:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*1)
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
                                self:SetBodygroup(1,1)
                                if IsValid(self.Chute1) then                              
                                    self.Chute1:Remove()
                                end
                                if IsValid(self.Chute2) then                              
                                    self.Chute2:Remove()
                                end
                                if IsValid(self.Chute3) then                              
                                    self.Chute3:Remove()
                                end
                                self:SetOpen(false)
                                self.Smoking = true
                            end
                        end
                    end)
                end
            end
        end
    end

    if self.Smoking then
        if self.Broken then return end
        if self.SmokeAmount >= 1 then
            self.NextSmoke = self.NextSmoke or 0
            if self.NextSmoke < CurTime() then
                self.NextSmoke = CurTime() + 0.01
                self.SmokeAmount = self.SmokeAmount - 1
                local effectdata = EffectData()
                effectdata:SetOrigin( self:GetPos()+self:GetUp() * 10 )
                effectdata:SetColor(255,0,0,255)
                util.Effect( "sw_practice_smoke_v3", effectdata )
            end
        end
    end

    if self:GetHP() <= 0 then
        if !self.Broken then
            self:SetBodygroup(2,math.random(1,9))
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
        ply:GiveAmmo( (priMag*3), priAmmo )
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
    self.Smoking = false
    local tab = self:GetTable()
    if tab[1] == 22 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 21 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,1)
        end
    elseif tab[1] == 20 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 19 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,2)
        end
    elseif tab[1] == 18 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end       
    elseif tab[1] == 17 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,3)
        end    
    elseif tab[1] == 16 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end     
    elseif tab[1] == 15 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,4)
        end            
    elseif tab[1] == 14 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 13 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,5)
        end            
    elseif tab[1] == 12 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 11 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,6)
        end        
    elseif tab[1] == 10 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 9 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,7)
        end
    elseif tab[1] == 8 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end    
    elseif tab[1] == 7 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,8)
        end
    elseif tab[1] == 6 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 5 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,9)
        end
    elseif tab[1] == 4 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 3 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
            self:SetBodygroup(2,10)
        end
    elseif tab[1] == 2 then
        if giveammo(ply) == true then
            tab[1] = tab[1] - 1
        end
    elseif tab[1] == 1 then
        if giveammo(ply) == true then
            self:SetBodygroup(2,11)
            self.Broken = true
        end
    end
end

--Damage
function ENT:PhysicsCollide( data )
	if data.Speed > 5 and data.DeltaTime > 0.1 then
		local VelDif = data.OurOldVelocity:Length() - data.OurNewVelocity:Length()

		if VelDif > 20 then
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
    if IsValid(self.Chute1) then                              
        self.Chute1:Remove()
    end
    if IsValid(self.Chute2) then                              
        self.Chute2:Remove()
    end
    if IsValid(self.Chute3) then                              
        self.Chute3:Remove()
    end
end