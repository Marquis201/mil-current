TOOL.Category = "Construction"
TOOL.Name = "Кнопка с ценой"
TOOL.name = "Кнопка с ценой"

TOOL.ClientConVar[ "keygroup" ] = "37"
TOOL.ClientConVar[ "description" ] = ""
TOOL.ClientConVar[ "inf_use" ] = "0"
TOOL.ClientConVar[ "cost" ] = "100"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

function TOOL:RightClick( trace, worldweld )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end

	local key = self:GetClientNumber( "keygroup" )
	local description = self:GetClientInfo( "description" )
	local inf_use = self:GetClientNumber( "inf_use" ) == 1
	local cost = math.Clamp(self:GetClientNumber( "cost" ), 100, 1000000)
	local ply = self:GetOwner()

	-- If we shot a button change its settings
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_button_pay" && trace.Entity:GetPlayer() == ply ) then
		trace.Entity:SetKey( key )
		trace.Entity:SetLabel( description )
		trace.Entity:Setinf_use( inf_use )
		trace.Entity:Setcost( cost )

		return true
	end

	if ( !self:GetSWEP():CheckLimit( "buttons" ) ) then return false end

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local button = MakePayButton( ply, Ang, trace.HitPos, key, description, inf_use, cost )

	local min = button:OBBMins()
	button:SetPos( trace.HitPos - trace.HitNormal * min.z )

	undo.Create( "Button" )
		undo.AddEntity( button )

		if ( worldweld && trace.Entity != NULL ) then
			local weld = constraint.Weld( button, trace.Entity, 0, trace.PhysicsBone, 0, 0, true )

			if ( IsValid( button:GetPhysicsObject() ) ) then button:GetPhysicsObject():EnableCollisions( false ) end
			button:SetCollisionGroup( COLLISION_GROUP_WORLD )
			button.nocollide = true

			ply:AddCleanup( "buttons", weld )
			undo.AddEntity( weld )
		end

		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:LeftClick( trace )

	return self:RightClick( trace, true )

end

if ( SERVER ) then

	function MakePayButton( pl, ang, pos, key, description, inf_use, cost, nocollide )

		if ( IsValid( pl ) && !pl:CheckLimit( "buttons" ) ) then return false end

		local button = ents.Create( "gmod_button_pay" )
		if ( !IsValid( button ) ) then return false end

		cost = math.Clamp(cost, 100, 1000000)
		button:SetAngles( ang )
		button:SetPos( pos )
		button:Spawn()

		button:SetPlayer( pl )
		button:SetKey( key )
		button:SetLabel( description )
		button:Setinf_use( inf_use )
		button:Setcost( cost )

		if ( nocollide == true ) then
			if ( IsValid( button:GetPhysicsObject() ) ) then button:GetPhysicsObject():EnableCollisions( false ) end
			button:SetCollisionGroup( COLLISION_GROUP_WORLD )
		end

		table.Merge( button:GetTable(), {
			key = key,
			pl = pl,
			nocollide = nocollide,
			description = description
		} )

		if ( IsValid( pl ) ) then
			pl:AddCount( "buttons", button )
			pl:AddCleanup( "buttons", button )
		end

		--DoPropSpawnedEffect( button )

		return button

	end

	duplicator.RegisterEntityClass( "gmod_button_pay", MakePayButton, "Ang", "Pos", "key", "description", "inf_use", "cost", "nocollide" )

end

function TOOL:UpdateGhostButton( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "gmod_button_pay" || trace.Entity:IsPlayer() ) ) then
		ent:SetNoDraw( true )
		return
	end

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( ang )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	local mdl = "models/maxofs2d/button_04.mdl"

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostButton( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.button.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "button", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.button.key", Command = "button_pay_keygroup" } )

	--CPanel:AddControl( "TextBox", { Label = "#tool.button.text", Command = "button_description", MaxLenth = "20" } )

	CPanel:AddControl( "CheckBox", { Label = "Дальнейшие использование после оплаты", Command = "button_pay_inf_use" } )

	CPanel:AddControl( "Slider", { Label = "Цена за использование", Command = "button_pay_cost", type = "int", min = 100, max = 1000000 } )
end