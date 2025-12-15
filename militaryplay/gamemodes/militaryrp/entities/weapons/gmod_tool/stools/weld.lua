
TOOL.Category = "Constraints"
TOOL.Name = "#tool.weld.name"

TOOL.ClientConVar[ "forcelimit" ] = "0"

function TOOL:LeftClick( trace )

	if ( self:GetOperation() == 1 ) then return false end
	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( CLIENT ) then
	
		if ( iNum > 0 ) then self:ClearObjects() end
		return true
	
	end
	
	self:SetOperation( 2 )
	
	if ( iNum == 0 ) then
	
		self:SetStage( 1 )
		return true
		
	end

	if ( iNum == 1 ) then
	
		-- Get client's CVars
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local nocollide = false

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )

		local constraint = constraint.Weld( Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide )
		if ( constraint ) then
		
			undo.Create( "Weld" )
				undo.AddEntity( constraint )
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()
			
			self:GetOwner():AddCleanup( "constraints", constraint )
		
		end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()
	
	end
	
	return true

end

function TOOL:RightClick( trace )
	self:LeftClick( trace )
end

function TOOL:Think()

	if ( self:NumObjects() < 1 ) then return end
	
	if ( self:GetOperation() == 1 ) then
	
		if ( SERVER && !IsValid( self:GetEnt( 1 ) ) ) then
		
			self:ClearObjects()
			return
		
		end
		
		if ( self:NumObjects() == 1 ) then
		
			self:UpdateGhostEntity()
			return
		
		end
		
		if ( SERVER && self:NumObjects() == 2 ) then
		
			local Phys1 = self:GetPhys( 1 )

			local cmd = self:GetOwner():GetCurrentCommand()
			
			local degrees = cmd:GetMouseX() * 0.05
			
			local angle = Phys1:RotateAroundAxis( self.RotAxis, degrees )
			
			Phys1:SetAngles( angle )
			
			-- Move so spots join up
			local TargetPos = self:GetPos( 2 ) + ( Phys1:GetPos() - self:GetPos( 1 ) )
			Phys1:SetPos( TargetPos )
			Phys1:Wake()
		
		end
	
	end

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	self:ClearObjects()

	return constraint.RemoveConstraints( trace.Entity, "Weld" )

end

function TOOL:FreezeMovement()

	return self:GetOperation() == 1 && self:GetStage() == 2

end

function TOOL:Holster()

	self:ClearObjects()

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description	= "#tool.weld.help" } )
	CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "weld_forcelimit", Type = "Float", Min = 0, Max = 1000, Help = true } )

end
