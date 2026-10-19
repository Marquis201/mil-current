ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Buggy"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Автомобиль"
ENT.VehicleCategory = "Автомобиль"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/vdvbuggy/vdvbuggy.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1150
ENT.MaxVelocityReverse = 500
ENT.MaxHealth = 1000

ENT.EngineCurve = 0.25
ENT.EngineTorque = 70
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 2500

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.Loadouts = 4

function ENT:OnSetupDataTables()
	self:AddDT( "Int", "Loadout" , { KeyName = "loadout",	Edit = { type = "Int",	order = 3, min = 1, max = self.Loadouts, category = "Weapons"} } )
	self:AddDT( "Entity", "GunnerSeat" )
end

function ENT:InitWeapons()
	local loadout = self:GetNWInt("Loadout")

	if loadout == 1 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
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
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)

			local PhysObj = self:GetPhysicsObject()
			if IsValid( PhysObj ) then
				PhysObj:ApplyForceOffset( -Attachment.Ang:Forward() * 500, Attachment.Pos )
			end
	
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
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
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
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
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
		self:AddWeapon( weapon, 3 )
	elseif loadout == 2 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "view_gshg" )
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
		self:AddWeapon( weapon, 3)

		local gshg = {}
		gshg.Icon = Material("lvs/weapons/mg.png")
		gshg.Ammo = 1000
		gshg.Delay = 0.01
		gshg.HeatRateUp = 0.25
		gshg.HeatRateDown = 0.25
		gshg.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_gshg" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
			
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
			self:ResetSequence("fire")
			local PhysObj = self:GetPhysicsObject()
			if IsValid( PhysObj ) then
				PhysObj:ApplyForceOffset( -Attachment.Ang:Forward() * 500, Attachment.Pos )
			end
	
			ent:TakeAmmo( 1 )
		end
		gshg.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretGShG ) then return end
			base.SNDTurretGShG:Play()
		end
		gshg.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretGShG ) then return end
			base.SNDTurretGShG:Stop()
			
			if not IsValid( base.SNDTurretGShGStop ) then return end
			base.SNDTurretGShGStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		gshg.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		gshg.HudPaint = function( ent, X, Y, ply )
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
			if not self:GetGunnerSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					base:PaintCrosshairCenter( Crosshair, Color(255,0,0,255) )	
					base:PaintCrosshairOuter( Crosshair, Color(255,0,0,255) )					
				else					
					base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
				end
			else				
				base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			end
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
		gshg.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "view_gshg" )
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
		self:AddWeapon( gshg, 3 )

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

			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
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
		self:AddWeapon( weapon, 3 )
	elseif loadout == 3 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
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
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 3400
			bullet.HullSize = 15
			bullet.Damage	= 60
			bullet.Velocity = 40000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
			local PhysObj = self:GetPhysicsObject()
			if IsValid( PhysObj ) then
				PhysObj:ApplyForceOffset( -Attachment.Ang:Forward() * 2500, Attachment.Pos )
			end
	
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
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
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
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
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
		self:AddWeapon( weapon, 3 )
	elseif loadout == 4 then
		local weapon = {}
		weapon.Icon = Material("lvs/weapons/tank_noturret.png")
		weapon.Ammo = -1
		weapon.Delay = 0
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
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
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
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
		ags.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
			   if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "view_ags" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos-Attachment.Ang:Right()*3.75+Attachment.Ang:Up()*4+Attachment.Ang:Forward()*15
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
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 110*FrameTime() ), -20, 40 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 110*FrameTime() )
	
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
		self:AddWeapon( weapon, 3 )
	end
end

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/222/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 45,
		PitchMul = 15,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/222/eng_loop.wav",
		Volume = 1,
		Pitch = 40,
		PitchMul = 50,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(67,18.5,36.75), colorA = 150 },
			{ pos = Vector(67,-18.5,36.75), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(67,18.5,36.75), colorA = 150 },
			{ pos = Vector(67,-18.5,36.75), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(76.1,7.7,27.2), colorA = 150 },
			{ pos = Vector(76.1,-7.7,27.2), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(76.1,7.7,27.2), colorA = 150 },
			{ pos = Vector(76.1,-7.7,27.2), colorA = 150 },
		},
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(60.5,-33.35,40), colorG = 150, colorB = 0, colorA = 150 },	
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(60.5,33.35,40), colorG = 150, colorB = 0, colorA = 150 },	
		},
	},
}