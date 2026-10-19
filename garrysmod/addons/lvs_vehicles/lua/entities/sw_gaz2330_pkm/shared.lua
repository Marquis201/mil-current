ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "GAZ-2330 (ПКМ)"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Автомобиль"

ENT.VehicleCategory = "Автомобиль"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/gaz2330/gaz2330.mdl"

ENT.AITEAM = 2

--damage system
ENT.DSArmorIgnoreForce = nil

ENT.MaxVelocity = 1750
ENT.MaxVelocityReverse = 500
ENT.MaxHealth = 1000

ENT.EngineCurve = 0.25
ENT.EngineTorque = 100
ENT.EngineIdleRPM = 1500
ENT.EngineMaxRPM = 3000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.Loadouts = 6

local DefMats = {}
local DefClrs = {}
local ColorTab = 
{
	[ "$pp_colour_addr" ] 		= -.3,
	[ "$pp_colour_addg" ] 		= -.4,
	[ "$pp_colour_addb" ] 		= -.4,
	[ "$pp_colour_brightness" ] 	= .1,
	[ "$pp_colour_contrast" ] 	= 1,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0,
}	
local colBlack = Color( 0, 0, 0, 255 )
local pairs = pairs
local string = string
local render = render
local DoXRay = false
local function XRayMat()
	for k,v in pairs( ents.GetAll() ) do					
		if string.sub( (v:GetModel() or "" ), -3) == "mdl" then						
			local r = v:GetColor().r
			local g = v:GetColor().g
			local b = v:GetColor().b
			local a = v:GetColor().a
			if (a > 0) then								
				local entmat = v:GetMaterial()					
				if v:IsNPC() or v:IsPlayer() then								
					if not (r == 255 and g == 255 and b == 255 and a == 255) then
						DefClrs[ v ] = Color( r, g, b, a )
						v:SetColor(Color(255,255,255,255))
					end									
					if entmat ~= "xray/living" then
						DefMats[ v ] = entmat
						v:SetMaterial( "xray/living" )
					end
					
				else
					if not (r == 255 and g == 255 and b == 255 and a == 255) then
						DefClrs[ v ] = Color( r, g, b, a )
						v:SetColor(Color(255,255,255,255))
					end									
					if entmat ~= "xray/prop" then
						DefMats[ v ] = entmat
						v:SetMaterial( "xray/living" )
					end					
				end
			end							
		end					
	end							
end		
local function XRayFX() 
	DrawColorModify( ColorTab ) 
	DrawBloom(0,1,1,1,0,0,0,0,0 )
	DrawMotionBlur(FrameTime() * 50, 0.5, 0.05)
	DrawBokehDOF( 0.15, 1, 12 )
end

function ENT:OnSetupDataTables()
	self:AddDT( "Int", "Loadout" , { KeyName = "loadout",	Edit = { type = "Int",	order = 3, min = 1, max = self.Loadouts, category = "Weapons"} } )
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Bool", "FLIR" )
	self:AddDT( "Bool", "Hatch" )
	hook.Add( "LVS.PlayerLeaveVehicle", "ExitFLIR", function( ply, veh )
		if veh == self then
			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
	end )
end


function ENT:InitWeapons()
	local loadout = self:GetNWInt("Loadout")

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/horn.png")
	weapon.Ammo = -1
	weapon.Delay = 0.5
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.Attack = function( ent ) end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.HornSND ) then return end
		ent.HornSND:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.HornSND ) then return end
		ent.HornSND:Stop()
	end
	self:AddWeapon( weapon )

	local smoke = {}
	smoke.Icon = Material("icons/smoke_launcher")
	smoke.Ammo = 4
	smoke.Delay = 0.5
	smoke.HeatRateUp = 0
	smoke.HeatRateDown = 0
	smoke.Attack = function( ent )
		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 4 then
			ent._MuzzleID = 1
		end

		local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )

		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		if not IsValid( self.SNDSmoke ) then return end
		self.SNDSmoke:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Pos )
		grenade:SetAngles( Muzzle.Ang )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 

		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(1,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)

		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 4 then
			ent._MuzzleID = 1
		end

		local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )

		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		if not IsValid( self.SNDSmoke ) then return end
		self.SNDSmoke:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Pos )
		grenade:SetAngles( Muzzle.Ang )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 

		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(1,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)
	end
	self:AddWeapon( smoke )

	if loadout == 1 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( weapon, 3)

		local weapon = {}
		weapon.Icon = Material("icons/binocular.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		weapon.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_russian" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end
			end

			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = self.curZoomCom
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( weapon, 3 )
	elseif loadout == 2 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( weapon, 3)

		local pkp = {}
		pkp.Icon = Material("icons/pkm")
		pkp.Ammo = 250
		pkp.Delay = 0.08
		pkp.HeatRateUp = 0.25
		pkp.HeatRateDown = 0.25
		pkp.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_pkp" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		pkp.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretPkp ) then return end
			base.SNDTurretPkp:Play()
		end
		pkp.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretPkp ) then return end
			base.SNDTurretPkp:Stop()
			
			if not IsValid( base.SNDTurretPkpStop ) then return end
			base.SNDTurretPkpStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		pkp.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		pkp.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_pkp" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		pkp.OnSelect = function( ent )
			self:SetHatch(true)
		end
		pkp.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "view_pkp" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = 60
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		self:AddWeapon( pkp, 3 )

		local weapon = {}
		weapon.Icon = Material("icons/binocular.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		weapon.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_russian" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end
			end

			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = self.curZoomCom
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( weapon, 3 )
	elseif loadout == 3 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( weapon, 3)

		local kord = {}
		kord.Icon = Material("icons/kord")
		kord.Ammo = 150
		kord.Delay = 0.1
		kord.HeatRateUp = 0.1
		kord.HeatRateDown = 0.1
		kord.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_kord" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 3400
			bullet.HullSize = 15
			bullet.Damage	= 60
			bullet.Velocity = 40000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )

			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)

			ent:TakeAmmo( 1 )
		end
		kord.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretKord ) then return end
			base.SNDTurretKord:Play()
		end
		kord.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretKord ) then return end
			base.SNDTurretKord:Stop()
			
			if not IsValid( base.SNDTurretKordStop ) then return end
			base.SNDTurretKordStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		kord.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		kord.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_kord" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		kord.OnSelect = function( ent )
			self:SetHatch(true)
		end
		kord.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "view_kord" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = 60
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		self:AddWeapon( kord, 3 )

		local weapon = {}
		weapon.Icon = Material("icons/binocular.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		weapon.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_russian" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end
			end

			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = self.curZoomCom
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( weapon, 3 )
	elseif loadout == 4 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( weapon, 3)

		local ags = {}
		ags.Icon = Material("icons/vog30")
		ags.Ammo = 100
		ags.Delay = 0.135
		ags.HeatRateUp = 0.3
		ags.HeatRateDown = 0.3
		ags.Attack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
			local ID = base:LookupAttachment( "muzzle_ags" )
			local Muzzle = base:GetAttachment( ID )
			if not Muzzle then return end
			if not IsValid( ent ) then return end
	
			local pos = Muzzle.Pos 
			local ang = Muzzle.Ang:Forward()
			
			local grenade = ents.Create( "sw_base_shell_v3" )
			grenade:SetPos( pos )
			grenade:SetAngles( Muzzle.Ang+Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			grenade:Spawn()
			grenade:Activate()
			grenade:SetModel("models/Items/AR2_Grenade.mdl")
			grenade:SetAttacker( ent:GetDriver() )
			grenade:GetPhysicsObject():SetVelocity( grenade:GetForward() * 3000 )
			grenade:GetPhysicsObject():EnableDrag(false)
			grenade:SetDamage(750)
			grenade:SetRadius(400)
			self.SNDTurretAgs:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			ParticleEffect("muzzleflash_m590_3rd",Muzzle.Pos,Muzzle.Ang,nil)
			local PhysObj = self:GetPhysicsObject()
			if IsValid( PhysObj ) then
				PhysObj:ApplyForceOffset( -Muzzle.Ang:Forward() * 10000, Muzzle.Pos )
			end

			ent:TakeAmmo( 1 )
		end
		ags.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		ags.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_ags" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )

			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/10" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
					if self:GetHP() < (self:GetMaxHP()/2) then
						surface.SetDrawColor( Color(55,55,55,255) )
						surface.SetMaterial( broken_mat ) 
						surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
					end		
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end
			end
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		ags.OnSelect = function( ent )
			self:SetHatch(true)
		end
		ags.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "view_ags" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = 60
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		self:AddWeapon( ags, 3 )

		local weapon = {}
		weapon.Icon = Material("icons/binocular.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		weapon.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_russian" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end
			end

			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = self.curZoomCom
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( weapon, 3 )
	elseif loadout == 5 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.HudPaint = function( ent, X, Y, ply )
			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( weapon, 3)

		local flir = {}
		flir.Icon = Material("lvs/weapons/light.png")
		flir.Ammo = -1
		flir.Delay = 0
		flir.HeatRateUp = 0
		flir.HeatRateDown = 0
		flir.UseableByAI = false
		flir.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -10, 15 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		flir.StartAttack = function( ent )
			if self:GetFLIR() then
				self:SetFLIR(false)
				self:EmitSound("sw/misc/switch_off.mp3")
				self:EmitSound("sw/misc/nv_off.wav")
			else
				self:SetFLIR(true)
				self:EmitSound("sw/misc/switch_on.mp3")
				self:EmitSound("sw/misc/nv_on.wav")			
			end
		end
		flir.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_atgm" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/24" )
					local zoom_mat2 = Material( "models/sw/shared/sights/24_flir" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
					if self:GetHP() < (self:GetMaxHP()/2) then
						surface.SetDrawColor( Color(55,55,55,255) )
						surface.SetMaterial( broken_mat ) 
						surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
					end
					surface.SetDrawColor( Color(255,255,255,255) )
					if self:GetFLIR() then
						surface.SetMaterial( zoom_mat2 ) 
					else
						surface.SetMaterial( zoom_mat ) 
					end
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
	
					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							if self:GetFLIR() and not (self:GetHP() < (self:GetMaxHP()/2)) then		
								hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
								hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
						
								DoXRay = true
							else
								hook.Remove( "RenderScene", "XRay_ApplyMats" )
								hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
								DoXRay = false
								for ent,mat in pairs( DefMats ) do
									if ent:IsValid() then
										ent:SetMaterial( mat )
									end
								end				
								for ent,clr in pairs( DefClrs ) do
									if ent:IsValid() then
										ent:SetRenderMode(RENDERMODE_TRANSALPHA)
										ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
									end
								end
								DefMats = {}
								DefClrs = {}
							end
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end			
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefMats = {}
							DefClrs = {}
						end
					end
				else
					hook.Remove( "RenderScene", "XRay_ApplyMats" )
					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoXRay = false
					for ent,mat in pairs( DefMats ) do
						if ent:IsValid() then
							ent:SetMaterial( mat )
						end
					end			
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end			
					DefMats = {}
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		flir.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomATGM = self.curZoomATGM and math.Clamp(self.curZoomATGM + (zOut - zIn) * FrameTime() * 150,10,90) or 0

					local ID = self:LookupAttachment( "view_kornet" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoomATGM
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		flir.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( flir, 3 )
	
		local kornet = {}
		kornet.Icon = Material("icons/kornet")
		kornet.Ammo = 10
		kornet.Delay = 5
		kornet.HeatRateUp = 0
		kornet.HeatRateDown = 0.1
		kornet.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -10, 15 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		kornet.Attack = function( ent )
			if IsValid(self:GetNWEntity("Missile")) then return end
			self.SNDTurretATGM:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					
			local ID = self:LookupAttachment( "muzzle_atgm" )
			local Muzzle = self:GetAttachment( ID )
			if not Muzzle then return end
	
			local Driver = ent:GetDriver()
			local TargetDir = Muzzle.Ang:Forward()
			local tr = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = (Muzzle.Pos + TargetDir  * 999999),
				filter = ent
			} )
			local projectile = ents.Create("sw_rocket_9m133_v3")
			projectile:SetPos(Muzzle.Pos+Muzzle.Ang:Forward()*50)
			projectile:SetAngles(Muzzle.Ang)
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.DiveHeight = 50
			projectile.SpiralRate = -0.001
			projectile.SpiralRadius = 100
			projectile.Armed = true
			projectile.Launcher = self
			projectile.GuidanceActive = true
			projectile.LaserGuided = true
			projectile.LaserCode = "view_kornet"
			projectile.target = tr.Entity
			projectile.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
			projectile:SetTracerScale(5)
			
			self:SetNWEntity("Missile",projectile)
	
			ent:TakeAmmo(1)
		end
		kornet.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_atgm" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/24" )
					local zoom_mat2 = Material( "models/sw/shared/sights/24_flir" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
					if self:GetHP() < (self:GetMaxHP()/2) then
						surface.SetDrawColor( Color(55,55,55,255) )
						surface.SetMaterial( broken_mat ) 
						surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
					end
					surface.SetDrawColor( Color(255,255,255,255) )
					if self:GetFLIR() then
						surface.SetMaterial( zoom_mat2 ) 
					else
						surface.SetMaterial( zoom_mat ) 
					end
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
	
					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							if self:GetFLIR() and not (self:GetHP() < (self:GetMaxHP()/2)) then		
								hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
								hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
						
								DoXRay = true
							else
								hook.Remove( "RenderScene", "XRay_ApplyMats" )
								hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
								DoXRay = false
								for ent,mat in pairs( DefMats ) do
									if ent:IsValid() then
										ent:SetMaterial( mat )
									end
								end				
								for ent,clr in pairs( DefClrs ) do
									if ent:IsValid() then
										ent:SetRenderMode(RENDERMODE_TRANSALPHA)
										ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
									end
								end
								DefMats = {}
								DefClrs = {}
							end
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end			
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefMats = {}
							DefClrs = {}
						end
					end
				else
					hook.Remove( "RenderScene", "XRay_ApplyMats" )
					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoXRay = false
					for ent,mat in pairs( DefMats ) do
						if ent:IsValid() then
							ent:SetMaterial( mat )
						end
					end			
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end			
					DefMats = {}
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		kornet.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomATGM = self.curZoomATGM and math.Clamp(self.curZoomATGM + (zOut - zIn) * FrameTime() * 150,10,90) or 0

					local ID = self:LookupAttachment( "view_kornet" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoomATGM
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		kornet.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( kornet, 3 )

		local weapon = {}
		weapon.Icon = Material("icons/binocular.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		weapon.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_russian" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end
			end

			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )

			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
		weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = self.curZoomCom
					view.drawviewer = true
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = 90
					view.drawviewer = true
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, angles, fov, pod )
			end
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( weapon, 3 )
	elseif loadout == 6 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.HudPaint = function( ent, X, Y, ply )
			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( weapon, 3)

		local flir = {}
		flir.Icon = Material("lvs/weapons/light.png")
		flir.Ammo = -1
		flir.Delay = 0
		flir.HeatRateUp = 0
		flir.HeatRateDown = 0
		flir.UseableByAI = false
		flir.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 50 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		flir.StartAttack = function( ent )
			if self:GetFLIR() then
				self:SetFLIR(false)
				self:EmitSound("sw/misc/switch_off.mp3")
				self:EmitSound("sw/misc/nv_off.wav")
			else
				self:SetFLIR(true)
				self:EmitSound("sw/misc/switch_on.mp3")
				self:EmitSound("sw/misc/nv_on.wav")			
			end
		end
		flir.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_rws" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/sight_arbalet" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
					if self:GetHP() < (self:GetMaxHP()/2) then
						surface.SetDrawColor( Color(55,55,55,255) )
						surface.SetMaterial( broken_mat ) 
						surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
					end
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
	
					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							if self:GetFLIR() and not (self:GetHP() < (self:GetMaxHP()/2)) and self:GetEngineActive() then		
								hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
								hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
						
								DoXRay = true
							else
								hook.Remove( "RenderScene", "XRay_ApplyMats" )
								hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
								DoXRay = false
								for ent,mat in pairs( DefMats ) do
									if ent:IsValid() then
										ent:SetMaterial( mat )
									end
								end				
								for ent,clr in pairs( DefClrs ) do
									if ent:IsValid() then
										ent:SetRenderMode(RENDERMODE_TRANSALPHA)
										ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
									end
								end
								DefMats = {}
								DefClrs = {}
							end
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end			
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefMats = {}
							DefClrs = {}
						end
					end
				else
					hook.Remove( "RenderScene", "XRay_ApplyMats" )
					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoXRay = false
					for ent,mat in pairs( DefMats ) do
						if ent:IsValid() then
							ent:SetMaterial( mat )
						end
					end			
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end			
					DefMats = {}
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		flir.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomRWS = self.curZoomRWS and math.Clamp(self.curZoomRWS + (zOut - zIn) * FrameTime() * 150,10,90) or 0

					local ID = self:LookupAttachment( "view_rws" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoomRWS
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		flir.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( flir, 3 )

		local kord = {}
		kord.Icon = Material("icons/nsvt")
		kord.Ammo = 450
		kord.Delay = 0.1
		kord.HeatRateUp = 0.1
		kord.HeatRateDown = 0.1
		kord.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_rws" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.EnableBallistics = true
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 3400
			bullet.HullSize = 15
			bullet.Damage	= 60
			bullet.Velocity = 40000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		kord.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretRWS ) then return end
			base.SNDTurretRWS:Play()
		end
		kord.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretRWS ) then return end
			base.SNDTurretRWS:Stop()

			if not IsValid( base.SNDTurretRWSStop ) then return end
			base.SNDTurretRWSStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		kord.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -20, 50 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		kord.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_rws" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/sight_arbalet" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
					if self:GetHP() < (self:GetMaxHP()/2) then
						surface.SetDrawColor( Color(55,55,55,255) )
						surface.SetMaterial( broken_mat ) 
						surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
					end
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
	
					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							if self:GetFLIR() and not (self:GetHP() < (self:GetMaxHP()/2)) and self:GetEngineActive() then		
								hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
								hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
						
								DoXRay = true
							else
								hook.Remove( "RenderScene", "XRay_ApplyMats" )
								hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
								DoXRay = false
								for ent,mat in pairs( DefMats ) do
									if ent:IsValid() then
										ent:SetMaterial( mat )
									end
								end				
								for ent,clr in pairs( DefClrs ) do
									if ent:IsValid() then
										ent:SetRenderMode(RENDERMODE_TRANSALPHA)
										ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
									end
								end
								DefMats = {}
								DefClrs = {}
							end
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end			
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefMats = {}
							DefClrs = {}
						end
					end
				else
					hook.Remove( "RenderScene", "XRay_ApplyMats" )
					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoXRay = false
					for ent,mat in pairs( DefMats ) do
						if ent:IsValid() then
							ent:SetMaterial( mat )
						end
					end			
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end			
					DefMats = {}
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		kord.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomRWS = self.curZoomRWS and math.Clamp(self.curZoomRWS + (zOut - zIn) * FrameTime() * 150,10,90) or 0

					local ID = self:LookupAttachment( "view_rws" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoomRWS
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		kord.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( kord, 3 )

		local smoke = {}
		smoke.Icon = Material("icons/smoke_launcher")
		smoke.Ammo = 4
		smoke.Delay = 0.5
		smoke.HeatRateUp = 0
		smoke.HeatRateDown = 0
		smoke.Attack = function( ent )
			ent:TakeAmmo( 1 )
	
			ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1
	
			if ent._MuzzleID > 4 then
				ent._MuzzleID = 1
			end
	
			local ID = self:LookupAttachment( "smoke_rws_"..ent._MuzzleID )
	
			local Muzzle = self:GetAttachment( ID )
	
			if not Muzzle then return end
	
			local Pos = Muzzle.Pos
			local Dir =  Muzzle.Ang:Forward()
	
			if not IsValid( self.SNDSmoke ) then return end
			self.SNDSmoke:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			local grenade = ents.Create( "lvs_item_smoke" )
			grenade:SetPos( Pos )
			grenade:SetAngles( Muzzle.Ang )
			grenade:Spawn()
			grenade:Activate()
			grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 
	
			if IsValid( grenade.TrailEntity ) then
				grenade.TrailEntity:Remove()
			end
			timer.Simple(1,function()
				if IsValid(grenade) then
					grenade:Enable()
					grenade:SetNoDraw(true)
					grenade:SetMoveType( MOVETYPE_NONE )
				end
			end)
	
			ent:TakeAmmo( 1 )
	
			ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1
	
			if ent._MuzzleID > 4 then
				ent._MuzzleID = 1
			end
	
			local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )
	
			local Muzzle = self:GetAttachment( ID )
	
			if not Muzzle then return end
	
			local Pos = Muzzle.Pos
			local Dir =  Muzzle.Ang:Forward()
	
			if not IsValid( self.SNDSmoke ) then return end
			self.SNDSmoke:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			local grenade = ents.Create( "lvs_item_smoke" )
			grenade:SetPos( Pos )
			grenade:SetAngles( Muzzle.Ang )
			grenade:Spawn()
			grenade:Activate()
			grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 
	
			if IsValid( grenade.TrailEntity ) then
				grenade.TrailEntity:Remove()
			end
			timer.Simple(1,function()
				if IsValid(grenade) then
					grenade:Enable()
					grenade:SetNoDraw(true)
					grenade:SetMoveType( MOVETYPE_NONE )
				end
			end)
		end
		smoke.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 70*FrameTime() ), -10, 15 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 70*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		smoke.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_rws" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/sight_arbalet" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
					if self:GetHP() < (self:GetMaxHP()/2) then
						surface.SetDrawColor( Color(55,55,55,255) )
						surface.SetMaterial( broken_mat ) 
						surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
					end
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
	
					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							if self:GetFLIR() and self:GetEngineActive() and not (self:GetHP() < (self:GetMaxHP()/2)) then		
								hook.Add( "RenderScene", "XRay_ApplyMats", XRayMat )
								hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", XRayFX )
						
								DoXRay = true
							else
								hook.Remove( "RenderScene", "XRay_ApplyMats" )
								hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
								DoXRay = false
								for ent,mat in pairs( DefMats ) do
									if ent:IsValid() then
										ent:SetMaterial( mat )
									end
								end				
								for ent,clr in pairs( DefClrs ) do
									if ent:IsValid() then
										ent:SetRenderMode(RENDERMODE_TRANSALPHA)
										ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
									end
								end
								DefMats = {}
								DefClrs = {}
							end
						else
							hook.Remove( "RenderScene", "XRay_ApplyMats" )
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoXRay = false
							for ent,mat in pairs( DefMats ) do
								if ent:IsValid() then
									ent:SetMaterial( mat )
								end
							end			
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefMats = {}
							DefClrs = {}
						end
					end
				else
					hook.Remove( "RenderScene", "XRay_ApplyMats" )
					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoXRay = false
					for ent,mat in pairs( DefMats ) do
						if ent:IsValid() then
							ent:SetMaterial( mat )
						end
					end			
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end			
					DefMats = {}
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScene", "XRay_ApplyMats" )
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoXRay = false
				for ent,mat in pairs( DefMats ) do
					if ent:IsValid() then
						ent:SetMaterial( mat )
					end
				end			
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end			
				DefMats = {}
				DefClrs = {}
			end
	
			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
		end
		smoke.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomRWS = self.curZoomRWS and math.Clamp(self.curZoomRWS + (zOut - zIn) * FrameTime() * 150,10,90) or 0

					local ID = self:LookupAttachment( "view_rws" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoomRWS
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		smoke.OnSelect = function( ent )
			self:SetHatch(false)
		end
		self:AddWeapon( smoke, 3 )

		local weapon = {}
		weapon.Icon = Material("icons/binocular.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_russian" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end
			end

			local ID = self:LookupAttachment( "turret" )
			local Turret = self:GetAttachment( ID )
			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y+90 )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )

			hook.Remove( "RenderScene", "XRay_ApplyMats" )
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoXRay = false
			for ent,mat in pairs( DefMats ) do
				if ent:IsValid() then
					ent:SetMaterial( mat )
				end
			end			
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end			
			DefMats = {}
			DefClrs = {}
		end
		weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0
	
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.fov = self.curZoomCom
					return view	
				else
					local ID = self:LookupAttachment( "turret" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos+Attachment.Ang:Up()*25
					view.angles = ply:EyeAngles()
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		weapon.OnSelect = function( ent )
			self:SetHatch(true)
		end
		self:AddWeapon( weapon, 3 )
	end
end

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/222/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 65,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/222/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(102.4,30.85,47.8), colorA = 150 },
			{ pos = Vector(102.4,-30.85,47.8), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(102.4,30.85,47.8), colorA = 150 },
			{ pos = Vector(102.4,-30.85,47.8), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(98.7,39.8,49.65), colorA = 150 },
			{ pos = Vector(98.7,-39.8,49.65), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(98.7,39.8,49.65), colorA = 150 },
			{ pos = Vector(98.7,-39.8,49.65), colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(52.3,-42,51.6), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-105.3,-42,32.9), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(98.7,-39.8,51), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(52.3,-49.45,51.6), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-105.3,-44.65,32.9), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(98.7,39.8,51), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(52.3,49.45,51.6), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-105.3,44.65,32.9), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
}

function ENT:OnRemoved()
	hook.Remove( "RenderScene", "XRay_ApplyMats" )
	hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
	DoXRay = false
	for ent,mat in pairs( DefMats ) do
		if ent:IsValid() then
			ent:SetMaterial( mat )
		end
	end			
	for ent,clr in pairs( DefClrs ) do
		if ent:IsValid() then
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
		end
	end			
	DefMats = {}
	DefClrs = {}
end