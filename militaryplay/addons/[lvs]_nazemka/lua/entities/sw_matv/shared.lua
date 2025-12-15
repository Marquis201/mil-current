ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "M-ATV"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - Автомобиль"

ENT.VehicleCategory = "Автомобиль"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/matv/matv.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1100
ENT.MaxVelocityReverse = 500
ENT.MaxHealth = 1000

ENT.EngineCurve = 0.25
ENT.EngineTorque = 100
ENT.EngineIdleRPM = 1500
ENT.EngineMaxRPM = 3000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn2.wav"
ENT.HornPos = Vector(112,0,52)

ENT.Loadouts = 3

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
	self:AddDT( "Bool", "FLIR" )
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

	local flir = {}
	flir.Icon = Material("lvs/weapons/light.png")
	flir.Ammo = -1
	flir.Delay = 0
	flir.HeatRateUp = 0
	flir.HeatRateDown = 0
	flir.UseableByAI = false
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
	flir.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 70

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -20, 60 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		self:SetNWFloat("TurretYaw",base:GetPoseParameter("yaw"))
		base:SetPoseParameter("pitch", Pitch )
	end
	flir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "view" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_rws" )
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

				trtab = {}
				trtab.start = Attachment.Pos
				trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-"
				else
					range = range.."м"
				end
				surface.SetTextColor( 255, 0, 0, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.25) )
				surface.SetFont("sw_digital")
				surface.DrawText( "DISTANCE: "..range )

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

		local X = ScrW()/2
		local Y = ScrH()/2
		local body_mat = Material( "models/sw/shared/ui/traverse_body" )
		local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
		local view_mat = Material( "models/sw/shared/ui/traverse_view" )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( body_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
		surface.SetMaterial( turret_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:GetNWFloat("TurretYaw") )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
	end
	flir.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,20,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = ply:EyeAngles()
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( flir, 2 )
	
	if loadout == 1 then
		local m240 = {}
		m240.Icon = Material("icons/m240")
		m240.Ammo = 4500
		m240.Delay = 0.1
		m240.HeatRateUp = 0.1
		m240.HeatRateDown = 0.1
		m240.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_m240" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.EnableBallistics = true
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		m240.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretM240 ) then return end
			base.SNDTurretM240:Play()
		end
		m240.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretM240 ) then return end
			base.SNDTurretM240:Stop()

			if not IsValid( base.SNDTurretM240Stop ) then return end
			base.SNDTurretM240Stop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		m240.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "view" )
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
					local zoom_mat = Material( "models/sw/shared/sights/new/sight_rws" )
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
	
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."м"
					end
					surface.SetTextColor( 255, 0, 0, 255 )
					surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.25) )
					surface.SetFont("sw_digital")
					surface.DrawText( "DISTANCE: "..range )
	
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

			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:GetNWFloat("TurretYaw") )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
		end
		m240.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 90*FrameTime() ), -20, 60 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 90*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			self:SetNWFloat("TurretYaw",base:GetPoseParameter("yaw"))
			base:SetPoseParameter("pitch", Pitch )
		end
		m240.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,20,90) or 0
	
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoom
					return view	
				else
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = ply:EyeAngles()
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		self:AddWeapon( m240, 2 )
	elseif loadout == 2 then
		local m2 = {}
		m2.Icon = Material("icons/m2")
		m2.Ammo = 2000
		m2.Delay = 0.1
		m2.HeatRateUp = 0.1
		m2.HeatRateDown = 0.1
		m2.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_m2" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.015,0.015,0.015)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 3100
			bullet.HullSize = 15
			bullet.EnableBallistics = true
			bullet.Damage	= 60
			bullet.Velocity = 40000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		m2.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretM2 ) then return end
			base.SNDTurretM2:Play()
		end
		m2.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretM2 ) then return end
			base.SNDTurretM2:Stop()

			if not IsValid( base.SNDTurretM2Stop ) then return end
			base.SNDTurretM2Stop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		m2.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "view" )
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
					local zoom_mat = Material( "models/sw/shared/sights/new/sight_rws" )
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
	
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."м"
					end
					surface.SetTextColor( 255, 0, 0, 255 )
					surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.25) )
					surface.SetFont("sw_digital")
					surface.DrawText( "DISTANCE: "..range )
	
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

			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:GetNWFloat("TurretYaw") )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
		end
		m2.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 90*FrameTime() ), -20, 60 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 90*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			self:SetNWFloat("TurretYaw",base:GetPoseParameter("yaw"))
			base:SetPoseParameter("pitch", Pitch )
		end
		m2.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,20,90) or 0
	
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoom
					return view	
				else
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = ply:EyeAngles()
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		self:AddWeapon( m2, 2 )
	elseif loadout == 3 then
		local mk19 = {}
		mk19.Icon = Material("icons/40mm_he")
		mk19.Ammo = 448
		mk19.Delay = 0.15
		mk19.HeatRateUp = 0.3
		mk19.HeatRateDown = 0.3
		mk19.Attack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
			local ID = base:LookupAttachment( "muzzle_mk19" )
			local Muzzle = base:GetAttachment( ID )
			if not Muzzle then return end
			if not IsValid( ent ) then return end
	
			local pos = Muzzle.Pos 
			local ang = Muzzle.Ang:Forward()
			
			local grenade = ents.Create( "sw_base_shell_v3" )
			grenade:SetPos( pos )
			grenade:SetAngles( Muzzle.Ang+Angle(math.random(-2,2),math.random(-2,2),math.random(-2,2)) )
			grenade:Spawn()
			grenade:Activate()
			grenade:SetModel("models/Items/AR2_Grenade.mdl")
			grenade:SetDamage(1000)
			grenade:SetRadius(500)
			grenade:SetAttacker( ent:GetDriver() )
			grenade:GetPhysicsObject():AddVelocity( grenade:GetAngles():Forward() * 3500 )
			grenade:GetPhysicsObject():EnableDrag(false)
			if not IsValid( self.SNDTurretMK19 ) then return end
			self.SNDTurretMK19:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 1 + math.Rand(-1,1), 1 )
			ParticleEffect("muzzleflash_akm_3rd",Muzzle.Pos,Muzzle.Ang,nil)
			ent:TakeAmmo( 1 )
		end
		mk19.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "view" )
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
					local zoom_mat = Material( "models/sw/shared/sights/new/sight_rws" )
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
	
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."м"
					end
					surface.SetTextColor( 255, 0, 0, 255 )
					surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.25) )
					surface.SetFont("sw_digital")
					surface.DrawText( "DISTANCE: "..range )
	
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

			local X = ScrW()/2
			local Y = ScrH()/2
			local body_mat = Material( "models/sw/shared/ui/traverse_body" )
			local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
			local view_mat = Material( "models/sw/shared/ui/traverse_view" )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( body_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
			surface.SetMaterial( turret_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:GetNWFloat("TurretYaw") )
			surface.SetMaterial( view_mat ) 
			surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
		end
		mk19.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()
	
			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 90*FrameTime() ), -20, 60 )
			local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 90*FrameTime() )
	
			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			self:SetNWFloat("TurretYaw",base:GetPoseParameter("yaw"))
			base:SetPoseParameter("pitch", Pitch )
		end
		mk19.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
					local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
					self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,20,90) or 0
	
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = Attachment.Ang
					view.fov = self.curZoom
					return view	
				else
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos
					view.angles = ply:EyeAngles()
					return view	
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		self:AddWeapon( mk19, 2 )
	end

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "view" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_rws" )
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

				trtab = {}
				trtab.start = Attachment.Pos
				trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-"
				else
					range = range.."м"
				end
				surface.SetTextColor( 255, 0, 0, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.25) )
				surface.SetFont("sw_digital")
				surface.DrawText( "DISTANCE: "..range )

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

		local X = ScrW()/2
		local Y = ScrH()/2
		local body_mat = Material( "models/sw/shared/ui/traverse_body" )
		local turret_mat = Material( "models/sw/shared/ui/traverse_turret" )
		local view_mat = Material( "models/sw/shared/ui/traverse_view" )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( body_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, 0 )
		surface.SetMaterial( turret_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:GetNWFloat("TurretYaw") )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,20,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = ply:EyeAngles()
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( weapon, 2 )
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
			{ pos = Vector(111,33.15,50.2), colorA = 150 },
			{ pos = Vector(111,-33.15,50.2), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(111,33.15,50.2), colorA = 150 },
			{ pos = Vector(111,-33.15,50.2), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(111,33.15,50.2), colorA = 150 },
			{ pos = Vector(111,-33.15,50.2), colorA = 150 },
			{ pos = Vector(21.2,32.85,98.65), colorA = 150 },
			{ pos = Vector(21.2,-32.85,98.65), colorA = 150 },
			{ pos = Vector(-42.8,39.6,95.85), colorA = 150 },
			{ pos = Vector(-42.8,-39.6,95.85), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(111,33.15,50.2), colorA = 150 },
			{ pos = Vector(111,-33.15,50.2), colorA = 150 },
			{ pos = Vector(21.2,32.85,98.65), colorA = 150 },
			{ pos = Vector(21.2,-32.85,98.65), colorA = 150 },
			{ pos = Vector(-42.8,39.6,95.85), ang = Angle(0,45,0), colorA = 150 },
			{ pos = Vector(-42.8,-39.6,95.85), ang = Angle(0,-45,0), colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 3,
		Sprites = {
			{ pos = Vector(-98.65,-9,32.8), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(-98.65,-9,32.8), colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-102.7,39.55,45.65), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-102.7,-39.55,45.65), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-99.25,42.55,55), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-99.25,-42.55,55), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(-103.3,-25.35,47.15), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-102.9,-39.55,48.7), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-99.3,-42.8,57.85), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(102.6,-45.9,55.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(102.6,-45.9,53.7), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(102.6,-45,47.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(23.9,-33,95.35), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(109.3,-39.3,55.25), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(-103.3,25.35,47.15), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-102.9,39.55,48.7), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-99.3,42.8,57.85), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(102.6,45.9,55.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(102.6,45.9,53.7), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(102.6,45,47.45), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(23.9,33,95.35), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(109.3,39.3,55.25), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(38.3,0,83),
		ang = Angle(-90,0,0),
	},
	{
		pos = Vector(38.3,0,83),
		ang = Angle(-90,0,0),
	},
	{
		pos = Vector(38.3,0,83),
		ang = Angle(-90,0,0),
	},
}