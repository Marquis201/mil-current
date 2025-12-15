/* 

Telekinesis SWEP
Gurrazor

*/

// Credits / Useage
SWEP.Author = "Gurrazor";
SWEP.Contact = "gurrazor@live.com";
SWEP.Purpose = "A dangerous and unique admin swep.";
SWEP.Instructions = "Primary Fire: Fling props\nSecondary Fire: Select / Deselect Props";

// Who can make it?
SWEP.Spawnable = false;
SWEP.AdminSpawnable = true;

// Models
SWEP.ViewModel = "models/weapons/v_hands.mdl";
SWEP.WorldModel = "models/weapons/w_fists_t.mdl";

// Primary Fire Information
SWEP.Primary.ClipSize = 10;
SWEP.Primary.DefaultClip = 12;
SWEP.Primary.Automatic = true;
SWEP.Primary.Ammo = "none";

// Secondary Fire Information
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

// Selected props
props = {};

local ShootSound = Sound( "Metal.SawbladeStick" );

/*--
Reload does nothing
--*/
function SWEP:Reload()

end

// Called on init
// Make sure that the player has a table to work from
function SWEP.Initialize()
	//self.Owner:PrintMessage( 2, "SWEP Initializing for player " .. self.Owner:EntIndex( ) );
end

// Select/Deselect
function SWEP:Select( iEnt, iPlayer )
if (!IsValid(iEnt) or !IsValid(Entity(iPlayer))) then
return end
	// Select
	//player.GetByID(iPlayer):PrintMessage( 2, "Select it!" );
	props[iPlayer ][iEnt:EntIndex()] = iEnt;
end
function SWEP:Deselect( iEnt, iPlayer )
if (!IsValid(iEnt) or !IsValid(Entity(iPlayer))) then
return end
	// Deselect
	//player.GetByID(iPlayer):PrintMessage( 2, "Deselect that hoe" );
	props[ iPlayer ][ iEnt:EntIndex( ) ] = nil;
end

/*--
Think does nothing
--*/
function SWEP:Think()

end
/*--
PrimaryAttack
--*/
function SWEP:PrimaryAttack( )
	// Trace to point
	local tr = self.Owner:GetEyeTrace();

	// Point traced
	local iTarget = tr.HitPos;
	//self.Owner:PrintMessage( 2, "Target: " .. tostring(iTarget) );
	
	//self.Weapon:EmitSound( ShootSound );
	self.BaseClass.ShootEffects( self );

	// Server Side only.
	// Whee
	if ( !SERVER ) then return end
	
	if ( ! ( props[ self.Owner:EntIndex( ) ] ) ) then 	props[ self.Owner:EntIndex( ) ] = {} end
	
	local playerProps = props[ self.Owner:EntIndex( ) ];
	
	for k,v in pairs( playerProps ) do
		local iEnt = v;
    if ( ! ents.GetByIndex( k ) ) or not IsValid(iEnt) then
    self:Deselect( iEnt, self.Owner:EntIndex( ) )
    continue;
    end
		
		// Make sure that the person throwing it, owns
		// it
		iEnt:SetPhysicsAttacker( self.Owner );
		
		//self.Owner:PrintMessage( 2, "Throwing ent " .. k );
		
		local iEntPos = iEnt:GetPos();
		local iOffset = iEntPos - iTarget;
		
		//self.Owner:PrintMessage( 2, "(" .. tostring(iEntPos) .. ") - (" .. tostring(iTarget) .. ") = (" .. tostring(iOffset) ..")" );
		
		local iMass = iEnt:GetPhysicsObject():GetMass()
		local iSpeed = iMass * 5000 * -1; // Mass times constant in the right direction
		
		//self.Owner:PrintMessage( 2, "Mass: [" .. iMass .. "]\nSpeed: [" .. iSpeed .. "]"  );
		
		local iTargetNormal = iOffset:GetNormal();
		local iTargetForce = iTargetNormal * iSpeed; // * Vector( iSpeed, iSpeed, iSpeed );
		
		//self.Owner:PrintMessage( 2, "Target Normal: " .. tostring( iTargetNormal ) .. " to force is " .. tostring(iTargetForce) );
		
		// FLING
		iEnt:GetPhysicsObject():ApplyForceCenter( iTargetForce );	
		//self.Owner:PrintMessage( 2, "Flung!" );
	end
	
	//self.Owner:PrintMessage( 2, "Done." );
end

/*--
SecondaryAttack
--*/
function SWEP:SecondaryAttack()
	// Debug
	//self.Owner:PrintMessage( 2, "Secondary Attack" );
	
	// Trace First
	local tr = self.Owner:GetEyeTraceNoCursor();
	local iEnt = tr.Entity;
	
	// We can only select ents. Durr.
	if (!IsValid(iEnt)) then
		return;
	end;
	
	// You can't fling players with your mind. They might retaliate.
	if ( ( iEnt:IsPlayer( ) ) ) then return end
	
	// Make a shiny little effect
	local effectdata = EffectData();
	effectdata:SetOrigin( iEnt:GetPos( ) );
	effectdata:SetNormal( tr.HitNormal );
	effectdata:SetMagnitude( 2 );
	effectdata:SetScale( 0.5 );
	effectdata:SetRadius( 4 );
	util.Effect( "Sparks", effectdata );
	
	// Serverside Only
	if ( !SERVER ) then return end
	
	if ( ! ( props[ self.Owner:EntIndex( ) ] ) ) then 	props[ self.Owner:EntIndex( ) ] = {} end
	
	// Select/Deselect
	if (props[self.Owner:EntIndex()][iEnt:EntIndex()]) then
		self:Deselect(iEnt, self.Owner:EntIndex( ));
	else
		self:Select(iEnt, self.Owner:EntIndex());
	end
end 