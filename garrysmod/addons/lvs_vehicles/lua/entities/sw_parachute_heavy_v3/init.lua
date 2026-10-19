AddCSLuaFile("shared.lua")
AddCSLuaFile( "cl_init.lua" )
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
	self:SetModel("models/sw/shared/backpack.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:AddFlags( FL_OBJECT )
	local PObj = self:GetPhysicsObject()
	if not IsValid( PObj ) then 
		self:Remove()	
		print("SW Bombs V2: Missing model. Entity terminated.")	
		return
	end	
	self:PhysWake() 
end

function ENT:Think()
	self:NextThink(CurTime()+0.05)
	if self:GetAutoMode() then
		if self:GetVelocity():Length() >= 500 then
			if self:GetOpen() == false and not self:IsPlayerHolding() then
				self:SetOpen(true)
				self:EmitSound("sw/misc/chute_1.wav")
				self.Chute1 = ents.Create("prop_physics")
				self.Chute1:SetModel("models/sw/shared/chute_2.mdl")	
				self.Chute1:SetPos(self:GetPos()+self:GetRight()*250+self:GetUp()*25)
				self.Chute1:SetAngles(self:GetAngles())
				self.Chute1:Spawn()
				self.Chute1:Activate()
				self.Chute1.Owner=self.Owner
				self.Chute1:PhysWake()
				self.Chute1:GetPhysicsObject():EnableDrag(true)
				self.Chute1:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
				self.Chute1:GetPhysicsObject():SetMass(100)
				local Wire1 = constraint.Rope(self,self.Chute1,0,0,Vector(0,0,0),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
	
				self.Chute2 = ents.Create("prop_physics")
				self.Chute2:SetModel("models/sw/shared/chute_2.mdl")	
				self.Chute2:SetPos(self:GetPos()-self:GetRight()*250+self:GetUp()*25)
				self.Chute2:SetAngles(self:GetAngles())
				self.Chute2:Spawn()
				self.Chute2:Activate()
				self.Chute2.Owner=self.Owner
				self.Chute2:PhysWake()
				self.Chute2:GetPhysicsObject():EnableDrag(true)
				self.Chute2:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
				self.Chute2:GetPhysicsObject():SetMass(100)
				local Wire2 = constraint.Rope(self,self.Chute2,0,0,Vector(0,0,0),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
	
				self.Chute3 = ents.Create("prop_physics")
				self.Chute3:SetModel("models/sw/shared/chute_2.mdl")	
				self.Chute3:SetPos(self:GetPos()+self:GetForward()*250+self:GetUp()*25)
				self.Chute3:SetAngles(self:GetAngles())
				self.Chute3:Spawn()
				self.Chute3:Activate()
				self.Chute3.Owner=self.Owner
				self.Chute3:PhysWake()
				self.Chute3:GetPhysicsObject():EnableDrag(true)
				self.Chute3:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
				self.Chute3:GetPhysicsObject():SetMass(100)
				local Wire3 = constraint.Rope(self,self.Chute3,0,0,Vector(0,0,0),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
			end
		else
			if self:GetVelocity():Length() <= 10 then
				if IsValid(self) then
					if self:GetOpen() == true and not self:IsPlayerHolding() then
						timer.Simple(3,function()
							if IsValid(self) then
								if self:GetOpen() == true and not self:IsPlayerHolding() then
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
								end
							end
						end)
					end
				end
			end
		end
	else
		for _, e in pairs(ents.FindInSphere(self:GetPos(), 500)) do
			if e == self.Owner then
				if IsValid( e ) then
					local Open = self:GetOpen()
					OpenSwitch = self.Owner:KeyDown(IN_SCORE)
					if self.OldOpenSwitch ~= OpenSwitch then
						if OpenSwitch and Open == false then
							self:SetOpen(true)
							self:EmitSound("sw/misc/chute_1.wav")
							self.Chute1 = ents.Create("prop_physics")
							self.Chute1:SetModel("models/sw/shared/chute_2.mdl")	
							self.Chute1:SetPos(self:GetPos()+self:GetRight()*250+self:GetUp()*25)
							self.Chute1:SetAngles(self:GetAngles())
							self.Chute1:Spawn()
							self.Chute1:Activate()
							self.Chute1.Owner=self.Owner
							self.Chute1:PhysWake()
							self.Chute1:GetPhysicsObject():EnableDrag(true)
							self.Chute1:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
							self.Chute1:GetPhysicsObject():SetMass(100)
							local Wire1 = constraint.Rope(self,self.Chute1,0,0,Vector(0,-15,10),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
				
							self.Chute2 = ents.Create("prop_physics")
							self.Chute2:SetModel("models/sw/shared/chute_2.mdl")	
							self.Chute2:SetPos(self:GetPos()-self:GetRight()*250+self:GetUp()*25)
							self.Chute2:SetAngles(self:GetAngles())
							self.Chute2:Spawn()
							self.Chute2:Activate()
							self.Chute2.Owner=self.Owner
							self.Chute2:PhysWake()
							self.Chute2:GetPhysicsObject():EnableDrag(true)
							self.Chute2:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
							self.Chute2:GetPhysicsObject():SetMass(100)
							local Wire2 = constraint.Rope(self,self.Chute2,0,0,Vector(0,-15,10),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
				
							self.Chute3 = ents.Create("prop_physics")
							self.Chute3:SetModel("models/sw/shared/chute_2.mdl")	
							self.Chute3:SetPos(self:GetPos()+self:GetForward()*250+self:GetUp()*25)
							self.Chute3:SetAngles(self:GetAngles())
							self.Chute3:Spawn()
							self.Chute3:Activate()
							self.Chute3.Owner=self.Owner
							self.Chute3:PhysWake()
							self.Chute3:GetPhysicsObject():EnableDrag(true)
							self.Chute3:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
							self.Chute3:GetPhysicsObject():SetMass(100)
							local Wire3 = constraint.Rope(self,self.Chute3,0,0,Vector(0,-15,10),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
						elseif OpenSwitch and Open == true then
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
						end
						self.OldOpenSwitch = OpenSwitch
					end
				end
			end		
		end
	end
	if IsValid(self.Chute1) then
		self.Chute1:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
	end
	if IsValid(self.Chute2) then
		self.Chute2:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
	end
	if IsValid(self.Chute3) then
		self.Chute3:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
	end
	return true
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