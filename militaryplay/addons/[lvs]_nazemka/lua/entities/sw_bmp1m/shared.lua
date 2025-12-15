
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "BMP-1M"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - БМП"

ENT.VehicleCategory = "БМП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/bmp1/bmp1m.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1500

ENT.SteerSpeed = 5
ENT.SteerReturnSpeed = 5

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 650
ENT.MaxVelocityReverse = 200

ENT.EngineCurve = 0.1
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 40

ENT.EngineSounds = {
	{
		sound = "sw/bmp1/bmp_engine_idle.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "sw/bmp1/bmp_engine_mid.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 90,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(38,-43,57.7),
		ang = Angle(-90,0,0)
	},
	{
		pos = Vector(38,-43,57.7),
		ang = Angle(-90,0,0)
	},
	{
		pos = Vector(38,-43,57.7),
		ang = Angle(-90,0,0)
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(122.4,44.7,48.2), colorA = 150 },
			{ pos = Vector(122.4,-44.7,48.2), colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-98.4,0.1,56.4), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
}
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
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Bool", "TurretDestroyed" )
	self:AddDT( "Bool", "UseHighExplosive" )
	self:AddDT( "Bool", "FLIR" )
	hook.Add( "LVS.PlayerLeaveVehicle", "ExitFLIR", function( ply, veh )
		print(ply:GetName().." exit a lvs vehicle")
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
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -10, 60 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	flir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a72_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a72_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat ) 
				end
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.85) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
	end
	flir.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = ply:EyeAngles()
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( flir, 2 )

	local pkt = {}
	pkt.Icon = Material("icons/pkt")
	pkt.Ammo = 2000
	pkt.Delay = 0.08
	pkt.HeatRateUp = 0.25
	pkt.HeatRateDown = 0.25
	pkt.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle_coax" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 10
		bullet.HullSize = 0
		bullet.EnableBallistics = true
		bullet.Damage	= 35
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)

		ent:TakeAmmo( 1 )
	end
	pkt.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Play()
	end
	pkt.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Stop()

		if not IsValid( base.SNDTurretMGstop ) then return end
		base.SNDTurretMGstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	pkt.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 70
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -10, 60 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	pkt.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a72_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a72_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat ) 
				end
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.85) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
	end
	pkt.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = ply:EyeAngles()
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( pkt, 2 )

	local cannon = {}
	cannon.Icon = true
	cannon.Ammo = 300
	cannon.Delay = 0.18
	cannon.HeatRateUp = 0.15
	cannon.HeatRateDown = 0.15
	cannon.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread = Vector(0.015,0.015,0.015)
		bullet.EnableBallistics = true

		if self:GetUseHighExplosive() then
			bullet.TracerName = "lvs_tracer_yellow"	
			bullet.Force	= 2500
			bullet.Damage	= 150
			bullet.HullSize 	= 3
			bullet.SplashDamage = 65
			bullet.SplashDamageRadius = 100
		else
			bullet.TracerName = "lvs_tracer_white"	
			bullet.Force = 8100
			bullet.Damage = 75
			bullet.HullSize = 1
		end
		
		bullet.Velocity = 19400
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )


		if IsValid(self) then
			local ID = self:LookupAttachment( "muzzle" )
			local Attachment = self:GetAttachment( ID )

			local Shell = ents.Create( "lvs_item_shell" )	
			if not IsValid( Shell ) then return end
			
			Shell.LifeTime = 2
			Shell:SetPos( Attachment.Pos - Attachment.Ang:Right()*3 - Attachment.Ang:Forward()*65 )
			Shell:SetAngles( Attachment.Ang+Angle(math.Rand(-3,2),90+math.Rand(-2,2),0) )
			Shell:SetModelScale(0.25)
			Shell:Spawn()
			Shell:Activate()
			Shell:SetOwner( self )
			Shell:SetCollisionGroup(1)
			
			local PhysObj = Shell:GetPhysicsObject()
			
			if not IsValid( PhysObj ) then return end
			
			PhysObj:ApplyForceCenter( Shell:GetRight() * 200 )
			PhysObj:AddVelocity(self:GetPhysicsObject():GetVelocity())				
		end

		ParticleEffect("muzzleflash_m590_3rd",Attachment.Pos,Attachment.Ang,nil)
		util.ScreenShake( Attachment.Pos, 1, 10, 1, 350, true, nil )

		local PhysObj = self:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -Attachment.Ang:Forward() * 5000, Attachment.Pos )
		end

		ent:TakeAmmo( 1 )
	end
	cannon.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Play()
		if not IsValid( base ) or not IsValid( base.SNDBelt ) then return end
		base.SNDBelt:Play()
	end
	cannon.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Stop()
		if not IsValid( base ) or not IsValid( base.SNDBelt ) then return end
		base.SNDBelt:Stop()
	end
	cannon.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ply = ent:GetDriver()
		if IsValid( ply ) then
			local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )
			if ent._oldSwitchType ~= SwitchType then
				ent._oldSwitchType = SwitchType
	
				if SwitchType then			
					if not self:GetUseHighExplosive() then
						self:SetUseHighExplosive( true )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )

						if not IsValid( base.SNDRld ) then return end
						base.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					else
						self:SetUseHighExplosive( false )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )
						
						if not IsValid( base.SNDRld ) then return end
						base.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					end
				end
			end
		end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 70
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -10, 60 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	cannon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a72_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a72_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat ) 
				end
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.85) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
	end
	cannon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = ply:EyeAngles()
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( cannon, 2 )
	
	local kornet = {}
	kornet.Icon = Material("icons/kornet")
	kornet.Ammo = 4
	kornet.Delay = 1
	kornet.HeatRateUp = 0.15
	kornet.HeatRateDown = 0.15
	kornet.Attack = function( ent )
		if IsValid(self:GetNWEntity("Missile")) then return end
		if not IsValid( self.SNDMis ) then return end
		self.SNDMis:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
				
		self._MuzzleID = self._MuzzleID and self._MuzzleID + 1 or 1
		if self._MuzzleID > 4 then
			self._MuzzleID = 1
		end
		local ID = self:LookupAttachment( "muzzle_atgm_"..self._MuzzleID )
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
		projectile.Armed = true
		projectile.Launcher = self
		projectile.GuidanceActive = true
		projectile.LaserGuided = true
		projectile.LaserCode = "view"
		projectile.target = tr.Entity
		projectile.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
		projectile:SetTracerScale(5)

		ParticleEffect("ins_weapon_rpg_frontblast",Muzzle.Pos,Muzzle.Ang,nil)
		util.ScreenShake( Muzzle.Pos, 1, 10, 1, 350, true, nil )
		
		self:SetNWEntity("Missile",projectile)

		ent:TakeAmmo(1)
	end
	kornet.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 70
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -10, 60 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	kornet.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a72_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a72_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat ) 
				end
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.85) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
	end
	kornet.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = ply:EyeAngles()
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( kornet, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
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
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a72_ap" )
				local zoom_mat2 = Material( "models/sw/shared/sights/new/sight_2a72_he" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
					surface.SetDrawColor( Color(55,55,55,255) )
					surface.SetMaterial( broken_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
				end		
				surface.SetDrawColor( Color(255,255,255,255) )
				if self:GetUseHighExplosive() then
					surface.SetMaterial( zoom_mat2 ) 
				else
					surface.SetMaterial( zoom_mat ) 
				end
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.85) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles(Turret.Ang).y )
		surface.SetMaterial( view_mat ) 
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, self:WorldToLocalAngles( ply:EyeAngles()).y )
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,40,90) or 0

				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Up()*3
				view.angles = ply:EyeAngles()
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( weapon, 2)
end

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