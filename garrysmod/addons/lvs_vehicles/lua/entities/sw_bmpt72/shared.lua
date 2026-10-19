	
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "BMPT-72"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - БМП"
ENT.VehicleCategory = "БМП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/bmpt72/bmpt72.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 3000

ENT.DSArmorIgnoreForce = 4000
ENT.CannonArmorPenetration = 580 * 100 - 4000

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 170

ENT.EngineCurve = 0
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 7
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 35

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "sw/bmpt72/engine_idle.wav",
		sound_int = "sw/bmpt72/engine_idle_int.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "sw/bmpt72/engine.wav",
		sound_int = "sw/bmpt72/engine_int.wav",
		Volume = 1,
		Pitch = 30,
		PitchMul = 100,
		SoundLevel = 100,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{pos = Vector(-62.25,70.75,52.55),ang = Angle(20,90,0),},
	{pos = Vector(-65.25,70.75,52.55),ang = Angle(20,90,0),},
	{pos = Vector(-68.25,70.75,52.55),ang = Angle(20,90,0),},
	{pos = Vector(-62.25,70.75,52.55),ang = Angle(20,90,0),},
	{pos = Vector(-65.25,70.75,52.55),ang = Angle(20,90,0),},
	{pos = Vector(-68.25,70.75,52.55),ang = Angle(20,90,0),},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(119.3,30.2,45.85), colorA = 150 },
			{ pos = Vector(119.3,-30.2,45.85), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(119.3,30.2,45.85), colorA = 150 },
			{ pos = Vector(119.3,-30.2,45.85), colorA = 150 },	
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(119.3,30.2,45.85), colorA = 150 },
			{ pos = Vector(119.3,-30.2,45.85), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(119.3,30.2,45.85), colorA = 150 },
			{ pos = Vector(119.3,-30.2,45.85), colorA = 150 },	
		},
	},
	{
		Trigger = "brake",
		Sprites = {
			{ pos = Vector(-148.6,52.7,56), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-127.2,-47.2,54.15), colorG = 0, colorB = 0, colorA = 150 },
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
	self:AddDT( "Entity", "CommanderSeat" )
	self:AddDT( "Bool", "TurretDestroyed" )
	self:AddDT( "Int", "ShellType" )
	self:AddDT( "Bool", "FLIR" )
	self:AddDT( "Bool", "COMFLIR" )
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
	local smokegen = {}
	smokegen.Icon = Material("icons/smoke_generator")
	smokegen.UseableByAI = false
	smokegen.Ammo = 3
	smokegen.Delay = 1
	smokegen.HeatRateUp = 1
	smokegen.HeatRateDown = 0.05
	smokegen.Attack = function( ent )
		ent:TakeAmmo( 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( ent:LocalToWorld( Vector(-123.5,22.75,59.55) ) )
		grenade:SetAngles( ent:GetAngles() )
		grenade:SetParent( ent )
		grenade:Spawn()
		grenade:Activate()
		grenade:Enable()
		grenade:SetColor( Color(0,0,0,0) )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( ent:LocalToWorld( Vector(-123.5,-7.35,59.55) ) )
		grenade:SetAngles( ent:GetAngles() )
		grenade:SetParent( ent )
		grenade:Spawn()
		grenade:Activate()
		grenade:Enable()
		grenade:SetColor( Color(0,0,0,0) )
	end
	self:AddWeapon( smokegen )

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

		local AimRate = 50
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -5, 45 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )
		
		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	flir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )
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

				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a42" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.64), (ScrH()/1.55) )
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
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

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
		util.ScreenShake( Attachment.Pos, 1, 10, 1, 350, true, nil )

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

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -6, 60 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	pkt.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )
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

				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a42" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.64), (ScrH()/1.55) )
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
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

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
	self:AddWeapon( pkt, 2 )

	local cannon = {}
	cannon.Icon = true
	cannon.Ammo = 2000
	cannon.Delay = 0.075
	cannon.HeatRateUp = 0.15
	cannon.HeatRateDown = 0.15
	cannon.Attack = function( ent )
		self._MuzzleID = self._MuzzleID and self._MuzzleID + 1 or 1
		if self._MuzzleID > 2 then
			self._MuzzleID = 1
		end
		local ID = self:LookupAttachment( "muzzle_"..self._MuzzleID )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread = Vector(0.015,0.015,0.015)
		bullet.EnableBallistics = true

		if self:GetShellType() == 1 then
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

		ParticleEffect("muzzleflash_m590_3rd",Attachment.Pos,Attachment.Ang,nil)
		util.ScreenShake( Attachment.Pos, 1, 10, 1, 350, true, nil )

		if IsValid(self) then
			if self._MuzzleID == 1 then
				local ID = self:LookupAttachment( "muzzle_1" )
				local Attachment = self:GetAttachment( ID )

				local Shell = ents.Create( "lvs_item_shell" )	
				if not IsValid( Shell ) then return end
				
				Shell.LifeTime = 5
				Shell:SetPos( Attachment.Pos + Attachment.Ang:Right()*5 - Attachment.Ang:Forward()*85 )
				Shell:SetAngles( Attachment.Ang+Angle(math.random(-1,1),90,Attachment.Ang.p) )
				Shell:SetModelScale(0.25)
				Shell:Spawn()
				Shell:Activate()
				Shell:SetOwner( self )
				Shell:SetCollisionGroup(1)
				
				local PhysObj = Shell:GetPhysicsObject()
				
				if not IsValid( PhysObj ) then return end
				
				PhysObj:ApplyForceCenter( Shell:GetRight() * 200 )
				PhysObj:AddVelocity(self:GetPhysicsObject():GetVelocity())
			else
				local ID = self:LookupAttachment( "muzzle_2" )
				local Attachment = self:GetAttachment( ID )

				local Shell = ents.Create( "lvs_item_shell" )	
				if not IsValid( Shell ) then return end
				
				Shell.LifeTime = 5
				Shell:SetPos( Attachment.Pos - Attachment.Ang:Right()*5 - Attachment.Ang:Forward()*85 )
				Shell:SetAngles( Attachment.Ang+Angle(math.random(-1,1),90,Attachment.Ang.p) )
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
		end

		local PhysObj = self:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -Attachment.Ang:Forward() * 5000, Attachment.Pos )
		end

		ent:TakeAmmo( 1 )
	end
	cannon.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDBelt ) then return end
		base.SNDBelt:Play()
		if not IsValid( base ) or not IsValid( base.SNDTurret1 ) then return end
		base.SNDTurret1:Play()
		if not IsValid( base ) or not IsValid( base.SNDTurret2 ) then return end
		base.SNDTurret2:Play()
	end
	cannon.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDBelt ) then return end
		base.SNDBelt:Stop()
		if not IsValid( base ) or not IsValid( base.SNDTurret1 ) then return end
		base.SNDTurret1:Stop()
		if not IsValid( base ) or not IsValid( base.SNDTurret2 ) then return end
		base.SNDTurret2:Stop()

		if not IsValid( base.SNDTurret1stop ) then return end
		base.SNDTurret1stop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		if not IsValid( base.SNDTurret2stop ) then return end
		base.SNDTurret2stop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
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
					if self:GetShellType() == 0 then
						self:SetShellType( 1 )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )

						if not IsValid( base.SNDRld ) then return end
						base.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					elseif self:GetShellType() == 1 then
						self:SetShellType( 0 )
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

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -6, 60 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	cannon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )
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

				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a42" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.64), (ScrH()/1.55) )
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
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

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
	self:AddWeapon( cannon, 2 )

	local ataka = {}
	ataka.Icon = Material("icons/kornet")
	ataka.Ammo = 4
	ataka.Delay = 5
	ataka.HeatRateUp = 0
	ataka.HeatRateDown = 0.1
	ataka.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 50
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -5, 45 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	ataka.Attack = function( ent )
		if IsValid(self:GetNWEntity("Missile")) then return end
	
		if not IsValid( self.SNDMissile ) then return end
		self.SNDMissile:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
				
		self._MuzzleID = self._MuzzleID and self._MuzzleID + 1 or 1
		if self._MuzzleID > 4 then
			self._MuzzleID = 1
		end
		local ID = self:LookupAttachment( "missile_"..self._MuzzleID )
		local Muzzle = self:GetAttachment( ID )
		if not Muzzle then return end

		local Driver = ent:GetDriver()
		local TargetDir = Muzzle.Ang:Forward()
		local tr = util.TraceLine( {
			start = Muzzle.Pos,
			endpos = (Muzzle.Pos + TargetDir  * 999999),
			filter = ent
		} )
		local projectile = ents.Create("sw_rocket_9m120_v3")
		projectile:SetPos(Muzzle.Pos)
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
		ParticleEffect("ins_weapon_rpg_backblast",Muzzle.Pos-Muzzle.Ang:Forward()*80,Muzzle.Ang-Angle(0,180,0),nil)

		self:SetNWEntity("Missile",projectile)

		ent:TakeAmmo(1)
	end
	ataka.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )
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

				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a42" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.64), (ScrH()/1.55) )
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
	ataka.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

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
	self:AddWeapon( ataka, 2 )
	
	local smoke = {}
	smoke.Icon = Material("icons/smoke_launcher")
	smoke.Ammo = 12
	smoke.Delay = 0.5
	smoke.HeatRateUp = 0
	smoke.HeatRateDown = 0
	smoke.Attack = function( ent )
		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 2 then
			ent._MuzzleID = 1
		end

		local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )

		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		if not IsValid( self.SNDSmoke1 ) then return end
		self.SNDSmoke1:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Pos )
		grenade:SetAngles( Muzzle.Ang )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 

		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(0.75,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)

		ent:TakeAmmo( 1 )

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 2 then
			ent._MuzzleID = 1
		end

		local ID = self:LookupAttachment( "smoke_"..ent._MuzzleID )

		local Muzzle = self:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		if not IsValid( self.SNDSmoke2 ) then return end
		self.SNDSmoke2:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		local grenade = ents.Create( "lvs_item_smoke" )
		grenade:SetPos( Pos )
		grenade:SetAngles( Muzzle.Ang )
		grenade:Spawn()
		grenade:Activate()
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 

		if IsValid( grenade.TrailEntity ) then
			grenade.TrailEntity:Remove()
		end
		timer.Simple(0.75,function()
			if IsValid(grenade) then
				grenade:Enable()
				grenade:SetNoDraw(true)
				grenade:SetMoveType( MOVETYPE_NONE )
			end
		end)
	end
	smoke.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )
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

				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a42" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.64), (ScrH()/1.55) )
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
	smoke.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 70
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, AimRate*FrameTime() ), -5, 45 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, AimRate*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	smoke.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

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
	self:AddWeapon( smoke, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_coax" )
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

				local zoom_mat = Material( "models/sw/shared/sights/new/sight_2a42" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.64), (ScrH()/1.55) )
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
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

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

	local comflir = {}
	comflir.Icon = Material("lvs/weapons/light.png")
	comflir.Ammo = -1
	comflir.Delay = 0
	comflir.HeatRateUp = 0
	comflir.HeatRateDown = 0
	comflir.UseableByAI = false
	comflir.StartAttack = function( ent )
		if self:GetCOMFLIR() then
			self:SetCOMFLIR(false)
			self:EmitSound("sw/misc/switch_off.mp3")
			self:EmitSound("sw/misc/nv_off.wav")
		else
			self:SetCOMFLIR(true)
			self:EmitSound("sw/misc/switch_on.mp3")
			self:EmitSound("sw/misc/nv_on.wav")			
		end
	end
	comflir.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local AimRate = 80
		if self:GetTurretDestroyed() then
			AimRate = AimRate*0.25
		end

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("com_pitch"), -Angles.p, AimRate*FrameTime() ), -45, 45 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("com_yaw"), Angles.y, AimRate*FrameTime() )
		
		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("com_yaw", Yaw )
		base:SetPoseParameter("com_pitch", Pitch )
	end
	comflir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "view_com" )
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
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.35) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetCOMFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	end
	comflir.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

				local ID = self:LookupAttachment( "view_com" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view_com" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, angles, fov, pod )
		end
	end
	comflir.OnSelect = function( ent )
		self:SetHatch(false)
	end
	self:AddWeapon( comflir, 3 )

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
				view.origin = Attachment.Pos+Attachment.Ang:Right()*17.45+Attachment.Ang:Up()*25
				view.fov = self.curZoomCom
				return view	
			else
				local ID = self:LookupAttachment( "turret" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+Attachment.Ang:Right()*17.45+Attachment.Ang:Up()*25
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

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "view_com" )
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
				if self:GetTurretDestroyed() then
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
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.35) )
				surface.SetFont("sw_hud")
				surface.DrawText( "Дистанция: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetCOMFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then		
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
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoom = self.curZoom and math.Clamp(self.curZoom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

				local ID = self:LookupAttachment( "view_com" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				view.angles = Attachment.Ang
				view.fov = self.curZoom
				return view	
			else
				local ID = self:LookupAttachment( "view_com" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos
				return view	
			end
		else
			return self:LVSCalcView( ply, pos, angles, fov, pod )
		end
	end
	weapon.OnSelect = function( ent )
		self:SetHatch(false)
	end
	self:AddWeapon( weapon, 3 )
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