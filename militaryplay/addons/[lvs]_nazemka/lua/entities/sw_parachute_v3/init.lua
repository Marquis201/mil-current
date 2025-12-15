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
		print("SW Bombs V3: Missing model. Entity terminated.")	
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
				self.Chute = ents.Create("prop_physics")
				self.Chute:SetModel("models/sw/shared/chute_1.mdl")	
				self.Chute:SetPos(self:GetPos()+self:GetUp()*25)
				self.Chute:SetAngles(self:GetAngles())
				self.Chute:Spawn()
				self.Chute:Activate()
				self.Chute.Owner=self.Owner
				self.Chute:PhysWake()
				self.Chute:GetPhysicsObject():EnableDrag(true)
				self.Chute:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
				self.Chute:GetPhysicsObject():SetMass(100)
				local Wire = constraint.Rope(self,self.Chute,0,0,Vector(0,-15,10),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
				if IsValid(self.Chute) then
					self.Chute:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
				end
			end
		else
			if self:GetVelocity():Length() <= 10 then
				if IsValid(self) then
					if self:GetOpen() == true and not self:IsPlayerHolding() then
						timer.Simple(3,function()
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
							self.Chute = ents.Create("prop_physics")
							self.Chute:SetModel("models/sw/shared/chute_1.mdl")	
							self.Chute:SetPos(self:GetPos()+self:GetUp()*25)
							self.Chute:SetAngles(self:GetAngles())
							self.Chute:Spawn()
							self.Chute:Activate()
							self.Chute.Owner=self.Owner
							self.Chute:PhysWake()
							self.Chute:GetPhysicsObject():EnableDrag(true)
							self.Chute:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
							self.Chute:GetPhysicsObject():SetMass(100)
							local Wire = constraint.Rope(self,self.Chute,0,0,Vector(0,-15,10),Vector(0,0,0),self:GetRopeLength(),0,0,1 )
						elseif OpenSwitch and Open == true then
							if IsValid(self.Chute) then
								self.Chute:Remove()
							end
							self:SetOpen(false)
						end
						self.OldOpenSwitch = OpenSwitch
					end
				end
			end		
		end
	end
	if IsValid(self.Chute) then
		self.Chute:GetPhysicsObject():SetDragCoefficient(self:GetVelocity():Length()*10)
	end
	return true
end

function ENT:OnRemove()
	if IsValid(self.Chute) then
		self.Chute:Remove()
	end
end