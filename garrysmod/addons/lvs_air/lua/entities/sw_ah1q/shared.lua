ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "AH-1Q"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Воздух"
ENT.Subcategory = "[НАТО]"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.HudColor = Color(255,255,255,150)
ENT.HudThirdPerson = false

ENT.MDL = "models/sw/avia/ah1q/ah1q.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1000
ENT.MaxHealthFuelTank = 150

ENT.MaxVelocity = 1500

ENT.ThrustUp = 1
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.1
ENT.ThrottleRateDown = 0.1

ENT.TurnRatePitch = 0.75
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 0.5

ENT.ForceLinearDampingMultiplier = 1.75

ENT.ForceAngleMultiplier = 1.1
ENT.ForceAngleDampingMultiplier = 1.1

ENT.EngineSounds = {
	{
		sound = "sw/ah1/engine.wav",
		sound_int = "sw/ah1/engine_int.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 200,
		PitchMul = 70,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 105,
		UseDoppler = true,
	},
	{
		sound = "",
		sound_int = "sw/ah1/rotor_loop_int.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 70,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 105,
		UseDoppler = true,
	},
	{
		sound = "sw/vehicles/rotor_far.wav",
		sound_int = "",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 150,
		UseDoppler = true,
	},
}

--Pylons
ENT.Pylons = {
	Vector(0,0,0),
	Vector(10,44,46),
	Vector(10,-44,46),
	Vector(0,65.6,47),
	Vector(0,-65.6,47),
}
ENT.Loadouts = 6

local DefClrs = {}
local ColorTab = 
{
	[ "$pp_colour_addr" ] 		= 0,
	[ "$pp_colour_addg" ] 		= 0,
	[ "$pp_colour_addb" ] 		= 0,
	[ "$pp_colour_brightness" ] = -0.1,
	[ "$pp_colour_contrast" ] 	= 1,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0,
}
local pairs = pairs
local string = string
local render = render
local DoM65 = false
local function M65FX() 
	DrawColorModify( ColorTab ) 
	DrawBokehDOF( 0.75, 1, 5 )
end

function ENT:OnSetupDataTables()
	self:AddDT( "Int", "Loadout" , { KeyName = "loadout",	Edit = { type = "Int",	order = 3, min = 1, max = self.Loadouts, category = "Weapons"} } )
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "FuelTank" )
end

function ENT:InitWeapons()
	local loadout = self:GetNWInt("Loadout")

	if loadout == 1 or loadout == 4 then	
		local xm18 = {}
		xm18.Icon = Material("lvs/weapons/mg.png")
		xm18.Ammo = 3000
		xm18.Delay = 0.01
		xm18.HeatRateUp = 0.25
		xm18.HeatRateDown = 0.25
		xm18.Attack = function( ent )
			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(50,44,42.4))
			bullet.Dir 	= self:LocalToWorldAngles(Angle(-5,0,0)):Forward()
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.EnableBallistics = true
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.Damage	= 35
			bullet.Velocity = 17380
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
			ParticleEffect("muzzleflash_akm_3rd",self:LocalToWorld(Vector(50,44,42.4)),self:LocalToWorldAngles(Angle(-5,0,0)),nil)

			local bullet = {}
			bullet.Src 	= self:LocalToWorld(Vector(50,-44,42.4))
			bullet.Dir 	= self:LocalToWorldAngles(Angle(-5,0,0)):Forward()
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.EnableBallistics = true
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.Damage	= 35
			bullet.Velocity = 17380
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
			ParticleEffect("muzzleflash_akm_3rd",self:LocalToWorld(Vector(50,-44,42.4)),self:LocalToWorldAngles(Angle(-5,0,0)),nil)

			ent:TakeAmmo( 2 )
		end
		xm18.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDXM18 ) then return end
			base.SNDXM18:Play()
			if not IsValid( base ) or not IsValid( base.SNDXM18spin ) then return end
			base.SNDXM18spin:Play()
		end
		xm18.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDXM18 ) then return end
			base.SNDXM18:Stop()
			if not IsValid( base ) or not IsValid( base.SNDXM18spin ) then return end
			base.SNDXM18spin:Stop()
		
			if not IsValid( base ) or not IsValid( base.SNDXM18stop ) then return end
			base.SNDXM18stop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		self:AddWeapon( xm18 )
	elseif loadout == 2 or loadout == 5 then
		local ffar = {}
		ffar.Icon = Material("lvs/weapons/missile.png")
		ffar.Ammo = 76
		ffar.Delay = 0.1
		ffar.HeatRateUp = 0
		ffar.HeatRateDown = 0
		ffar.Attack = function( ent )
			local fS = {
				Vector(41.5,-54,43),
				Vector(42.75,-30.25,36.25),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)

			if not IsValid( self.SNDRktL ) then return end
			self.SNDRktL:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local fS2 = {
				Vector(41.5,54,43),
				Vector(42.75,30.25,36.25),
			}
			self.NumSec2 = self.NumSec2 and self.NumSec2 + 1 or 1
			if self.NumSec2 > 2 then self.NumSec2 = 1 end
			local Pos2 = self:LocalToWorld(fS2[self.NumSec]+Vector(0,math.Rand(-7,7),math.Rand(-7,7)))
			ParticleEffect("ins_weapon_rpg_frontblast",self:LocalToWorld(fS2[self.NumSec]),self:GetAngles(),self)

			local projectile = ents.Create("sw_rocket_ffar_v3")
			projectile:SetPos(Pos2)
			projectile:SetAngles(self:GetAngles()+Angle(-5+math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			
			projectile.RocketTrail = "rockettrail"
			projectile.Armed = true
			projectile.FragCount = 0
			projectile.FragRadius = 0
			projectile.Launcher = self
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)

			if not IsValid( self.SNDRktR ) then return end
			self.SNDRktR:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	
			ent:TakeAmmo( 2 )	
		end
		self:AddWeapon( ffar )
	end

	local M65 = {}
	M65.Icon = Material("icons/flir.png")
	M65.Ammo = -1
	M65.Delay = 0
	M65.HeatRateUp = 0
	M65.HeatRateDown = 0
	M65.UseableByAI = false
	M65.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle_mgr" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )

		local Crosshair = tr.HitPos:ToScreen() 

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local ID = base:LookupAttachment( "view" )
				local Attachment = base:GetAttachment( ID )
				trtab = {}
				trtab.start = Attachment.Pos
				trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
				trtab.filter = self
				local tr = util.TraceLine(trtab)
				local Crosshair2 = tr.HitPos:ToScreen() 
				local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
				if tr.HitSky then
					range = "-"
				else
					range = range.."m"
				end
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
				surface.SetFont("sw_digital")
				surface.DrawText( "Range: "..range )

				surface.SetTextColor( 255, 255, 255,255 )
				surface.SetTextPos( (X*0.165), (Y/2) )
				surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
				surface.SetTextPos( (X*0.165), (Y/2) + 16)
				surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
				surface.SetTextPos( (X*0.165), (Y/2) + 32)
				surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))

				local startpos =  Attachment.Pos
				local TracePlane = util.TraceLine( {
					start = startpos,
					endpos = (startpos + Attachment.Ang:Forward() * 90000),
				} )
				local HitPlane = TracePlane.HitPos:ToScreen()
					
				local ang = Attachment.Ang.y
				local ComAngSN = 0.55 * math.sin(math.rad(ang))
				local ComAngCN = 1 * math.cos(math.rad(ang))
				local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
				local ComAngCE = 1 * math.cos(math.rad(ang-270))
				local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
				local ComAngCW = 1 * math.cos(math.rad(ang-90))
				local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
				local ComAngCS = 1 * math.cos(math.rad(ang-180))

				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
				surface.DrawText( "N" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
				surface.DrawText( "E" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
				surface.DrawText( "W" )  
				surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
				surface.DrawText( "S" )  

				local zoom_mat = Material( "models/sw/shared/sights/camera" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )

				base:PaintCrosshairSquare( Crosshair2, Color(255,255,255,255) )
				base:PaintCrosshairCenter( Crosshair2, Color(255,255,255,255) )
				base:LVSPaintHitMarker( Crosshair2 )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", M65FX )
						
						DoM65 = true
					else
						hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
						DoM65 = false	
						for ent,clr in pairs( DefClrs ) do
							if ent:IsValid() then
								ent:SetRenderMode(RENDERMODE_TRANSALPHA)
								ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
							end
						end			
						DefClrs = {}
					end
				end
			else
				local tr = util.TraceLine( {
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
					filter = ent:GetVehicle():GetCrosshairFilterEnts()
				} )
				local HitPilot = tr.HitPos:ToScreen()
				local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
				self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
				base:PaintCrosshairCenter( HitPlane, self.HudColor )

				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoM65 = false		
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end
				DefClrs = {}
			end
		else
			hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
			DoM65 = false		
			for ent,clr in pairs( DefClrs ) do
				if ent:IsValid() then
					ent:SetRenderMode(RENDERMODE_TRANSALPHA)
					ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
				end
			end
			DefClrs = {}
		end
		base:PaintCrosshairOuter( Crosshair, self.HudColor )
		base:PaintCrosshairCenter( Crosshair, self.HudColor )
		base:LVSPaintHitMarker( Crosshair )
	end
	M65.OnThink = function( ent, active )
		if not active then return end
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end
	
		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 25 )
		local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("yaw", Yaw )
		base:SetPoseParameter("pitch", Pitch )
	end
	M65.CalcView = function( ent, ply, pos, angles, fov, pod )
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
				view.drawviewer = true
				return view	
			else
				return self:LVSCalcView( ply, pos, angles, newfov, pod )
			end
		else
			return self:LVSCalcView( ply, pos, angles, newfov, pod )
		end
	end
	self:AddWeapon( M65, 2 )

	if loadout <= 3 then
		local m134 = {}
		m134.Icon = Material("lvs/weapons/mg.png")
		m134.Ammo = 8000
		m134.Delay = 0.01
		m134.HeatRateUp = 0.25
		m134.HeatRateDown = 0.25
		m134.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_mgl" )
			local Attachment = self:GetAttachment( ID )

			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()		
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.EnableBallistics = true
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.Damage	= 35
			bullet.Velocity = 17380
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos, Attachment.Ang,nil)

			local ID = self:LookupAttachment( "muzzle_mgr" )
			local Attachment = self:GetAttachment( ID )

			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()		
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.EnableBallistics = true
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.Damage	= 35
			bullet.Velocity = 17380
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos, Attachment.Ang,nil)

			ent:TakeAmmo( 1 )
		end
		m134.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDM134L ) then return end
			base.SNDM134L:Play()
			if not IsValid( base ) or not IsValid( base.SNDM134Lspin ) then return end
			base.SNDM134Lspin:Play()

			if not IsValid( base ) or not IsValid( base.SNDM134R ) then return end
			base.SNDM134R:Play()
			if not IsValid( base ) or not IsValid( base.SNDM134Rspin ) then return end
			base.SNDM134Rspin:Play()
		end
		m134.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDM134L ) then return end
			base.SNDM134L:Stop()
			if not IsValid( base ) or not IsValid( base.SNDM134Lspin ) then return end
			base.SNDM134Lspin:Stop()

			if not IsValid( base ) or not IsValid( base.SNDM134R ) then return end
			base.SNDM134R:Stop()
			if not IsValid( base ) or not IsValid( base.SNDM134Rspin ) then return end
			base.SNDM134Rspin:Stop()
		
			if not IsValid( base ) or not IsValid( base.SNDM134Lstop ) then return end
			base.SNDM134Lstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			if not IsValid( base ) or not IsValid( base.SNDM134Rstop ) then return end
			base.SNDM134Rstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		m134.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end

			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()

			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 25 )
			local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )

			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		m134.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end

			local ID = base:LookupAttachment( "muzzle_mgr" )
			local Attachment = base:GetAttachment( ID )

			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local Crosshair = tr.HitPos:ToScreen() 

			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local ID = base:LookupAttachment( "view" )
					local Attachment = base:GetAttachment( ID )
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local Crosshair2 = tr.HitPos:ToScreen() 
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."m"
					end
					surface.SetTextColor( 255, 255, 255, 255 )
					surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
					surface.SetFont("sw_digital")
					surface.DrawText( "Range: "..range )

					surface.SetTextColor( 255, 255, 255,255 )
					surface.SetTextPos( (X*0.165), (Y/2) )
					surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
					surface.SetTextPos( (X*0.165), (Y/2) + 16)
					surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
					surface.SetTextPos( (X*0.165), (Y/2) + 32)
					surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))

					local startpos =  Attachment.Pos
					local TracePlane = util.TraceLine( {
						start = startpos,
						endpos = (startpos + Attachment.Ang:Forward() * 90000),
					} )
					local HitPlane = TracePlane.HitPos:ToScreen()
					
					local ang = Attachment.Ang.y
					local ComAngSN = 0.55 * math.sin(math.rad(ang))
					local ComAngCN = 1 * math.cos(math.rad(ang))
					local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
					local ComAngCE = 1 * math.cos(math.rad(ang-270))
					local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
					local ComAngCW = 1 * math.cos(math.rad(ang-90))
					local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
					local ComAngCS = 1 * math.cos(math.rad(ang-180))

					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
					surface.DrawText( "N" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
					surface.DrawText( "E" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
					surface.DrawText( "W" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
					surface.DrawText( "S" )  

					local zoom_mat = Material( "models/sw/shared/sights/camera" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )

					base:PaintCrosshairSquare( Crosshair2, Color(255,255,255,255) )
					base:PaintCrosshairCenter( Crosshair2, Color(255,255,255,255) )
					base:LVSPaintHitMarker( Crosshair2 )

					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", M65FX )
						
							DoM65 = true
						else
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoM65 = false	
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefClrs = {}
						end
					end
				else
					local tr = util.TraceLine( {
						start = ply:EyePos(),
						endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
						filter = ent:GetVehicle():GetCrosshairFilterEnts()
					} )
					local HitPilot = tr.HitPos:ToScreen()
					local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
					self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
					base:PaintCrosshairCenter( HitPlane, self.HudColor )

					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoM65 = false		
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoM65 = false		
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end
				DefClrs = {}
			end
			base:PaintCrosshairOuter( Crosshair, self.HudColor )
			base:PaintCrosshairCenter( Crosshair, self.HudColor )
			base:LVSPaintHitMarker( Crosshair )
		end
		m134.CalcView = function( ent, ply, pos, angles, fov, pod )
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
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, angles, newfov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, angles, newfov, pod )
			end
		end
		self:AddWeapon( m134, 2 )
	else
		local m129 = {}
		m129.Icon = Material("lvs/weapons/mc.png")
		m129.Ammo = 600
		m129.Delay = 0.15
		m129.HeatRateUp = 0.25
		m129.HeatRateDown = 0.25
		m129.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_gll" )
			local Attachment = self:GetAttachment( ID )

			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()		
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_autocannon"
			bullet.EnableBallistics = true
			bullet.Force	= 5000
			bullet.HullSize = 10
			bullet.Damage	= 80
			bullet.Velocity = 4800
			bullet.SplashDamage = 60
			bullet.SplashDamageRadius = 160
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
			ParticleEffect("muzzleflash_m590_3rd",Attachment.Pos, Attachment.Ang,nil)

			if not IsValid( self.SNDM129L ) then return end
			self.SNDM129L:PlayOnce( 200 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			local ID = self:LookupAttachment( "muzzle_glr" )
			local Attachment = self:GetAttachment( ID )

			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()		
			bullet.TracerName = "lvs_tracer_autocannon"
			bullet.EnableBallistics = true
			bullet.Force	= 5000
			bullet.HullSize = 10
			bullet.Damage	= 80
			bullet.Velocity = 4800
			bullet.SplashDamage = 60
			bullet.SplashDamageRadius = 160
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
			ParticleEffect("muzzleflash_m590_3rd",Attachment.Pos, Attachment.Ang,nil)

			if not IsValid( self.SNDM129R ) then return end
			self.SNDM129R:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			ent:TakeAmmo( 2 )
		end
		m129.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end

			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()

			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 25 )
			local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )

			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		m129.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end

			local ID = base:LookupAttachment( "muzzle_mgr" )
			local Attachment = base:GetAttachment( ID )

			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local Crosshair = tr.HitPos:ToScreen() 

			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local ID = base:LookupAttachment( "view" )
					local Attachment = base:GetAttachment( ID )
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local Crosshair2 = tr.HitPos:ToScreen() 
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."m"
					end
					surface.SetTextColor( 255, 255, 255, 255 )
					surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
					surface.SetFont("sw_digital")
					surface.DrawText( "Range: "..range )

					surface.SetTextColor( 255, 255, 255,255 )
					surface.SetTextPos( (X*0.165), (Y/2) )
					surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
					surface.SetTextPos( (X*0.165), (Y/2) + 16)
					surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
					surface.SetTextPos( (X*0.165), (Y/2) + 32)
					surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))

					local startpos =  Attachment.Pos
					local TracePlane = util.TraceLine( {
						start = startpos,
						endpos = (startpos + Attachment.Ang:Forward() * 90000),
					} )
					local HitPlane = TracePlane.HitPos:ToScreen()
					
					local ang = Attachment.Ang.y
					local ComAngSN = 0.55 * math.sin(math.rad(ang))
					local ComAngCN = 1 * math.cos(math.rad(ang))
					local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
					local ComAngCE = 1 * math.cos(math.rad(ang-270))
					local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
					local ComAngCW = 1 * math.cos(math.rad(ang-90))
					local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
					local ComAngCS = 1 * math.cos(math.rad(ang-180))

					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
					surface.DrawText( "N" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
					surface.DrawText( "E" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
					surface.DrawText( "W" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
					surface.DrawText( "S" )  

					local zoom_mat = Material( "models/sw/shared/sights/camera" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )

					base:PaintCrosshairSquare( Crosshair2, Color(255,255,255,255) )
					base:PaintCrosshairCenter( Crosshair2, Color(255,255,255,255) )
					base:LVSPaintHitMarker( Crosshair2 )

					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", M65FX )
						
							DoM65 = true
						else
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoM65 = false	
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefClrs = {}
						end
					end
				else
					local tr = util.TraceLine( {
						start = ply:EyePos(),
						endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
						filter = ent:GetVehicle():GetCrosshairFilterEnts()
					} )
					local HitPilot = tr.HitPos:ToScreen()
					local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
					self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
					base:PaintCrosshairCenter( HitPlane, self.HudColor )

					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoM65 = false		
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoM65 = false		
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end
				DefClrs = {}
			end
			base:PaintCrosshairOuter( Crosshair, self.HudColor )
			base:PaintCrosshairCenter( Crosshair, self.HudColor )
			base:LVSPaintHitMarker( Crosshair )
		end
		m129.CalcView = function( ent, ply, pos, angles, fov, pod )
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
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, angles, newfov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, angles, newfov, pod )
			end
		end
		self:AddWeapon( m129, 2 )
	end

	if loadout == 3 or loadout == 6 then
		local bgm71 = {}
		bgm71.Icon = Material("icons/bgm71")
		bgm71.Ammo = 8
		bgm71.Delay = 1
		bgm71.HeatRateUp = 0
		bgm71.HeatRateDown = 0
		bgm71.Attack = function( ent )
			if IsValid(self:GetNWEntity("Missile")) then return end
	
			local fS = {
				Vector(32,61,40),
				Vector(32,-61,40),
			}
			self.NumSec = self.NumSec and self.NumSec + 1 or 1
			if self.NumSec > 2 then self.NumSec = 1 end
			local Pos = self:LocalToWorld(fS[self.NumSec])
			ParticleEffect("ins_weapon_rpg_frontblast",Pos,self:LocalToWorldAngles(Angle(-5,0,0)),self)

			local ID = self:LookupAttachment( "view" )
			local Sight = self:GetAttachment( ID )
			local Driver = ent:GetDriver()
			local TargetDir = Sight.Ang:Forward()
			local tr = util.TraceLine( {
				start = Sight.Pos,
				endpos = (Sight.Pos + TargetDir  * 999999),
				filter = ent:GetVehicle():GetCrosshairFilterEnts()
			} )
			local projectile = ents.Create("sw_rocket_bgm71_v3")
			projectile:SetPos(Pos)
			projectile:SetAngles(self:LocalToWorldAngles(Angle(-5,0,0)))
			projectile:Spawn()
			projectile:Activate()
			projectile:Launch()
			projectile.WireGuided = true
			projectile.Armed = true
			projectile.Launcher = self
			projectile.GuidanceActive = true
			projectile.LaserGuided = true
			projectile.LaserCode = "view"
			projectile.RocketTrail = "rockettrail"
			projectile.target = tr.Entity
			projectile.targetOffset = tr.Entity:WorldToLocal(tr.HitPos)
			projectile:SetTracerScale(5)
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)
			
			if not IsValid( self.SNDMsl ) then return end
			self.SNDMsl:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
			
			self:SetNWEntity("Missile",projectile)
	
			ParticleEffect("ins_weapon_rpg_frontblast",Pos,self:GetAngles(),self)
	
			ent:TakeAmmo( 1 )	
		end
		bgm71.OnThink = function( ent, active )
			if not active then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end

			local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
			Angles:Normalize()

			local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("pitch"), -Angles.p, 120*FrameTime() ), -50, 25 )
			local Yaw = math.Clamp( math.ApproachAngle( base:GetPoseParameter("yaw"), Angles.y, 120*FrameTime() ), -115, 115 )

			if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
			base:SetPoseParameter("yaw", Yaw )
			base:SetPoseParameter("pitch", Pitch )
		end
		bgm71.HudPaint = function( ent, X, Y, ply )
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

			if not ent:GetDriverSeat():GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					trtab = {}
					trtab.start = Attachment.Pos
					trtab.endpos = (Attachment.Pos + Attachment.Ang:Forward() * 900000)
					trtab.filter = self
					local tr = util.TraceLine(trtab)
					local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
					if tr.HitSky then
						range = "-"
					else
						range = range.."m"
					end
					surface.SetTextColor( 255, 255, 255, 255 )
					surface.SetTextPos( (ScrW()*0.475), (ScrH()/1.85) )
					surface.SetFont("sw_digital")
					surface.DrawText( "Range: "..range )

					surface.SetTextColor( 255, 255, 255,255 )
					surface.SetTextPos( (X*0.165), (Y/2) )
					surface.DrawText( "X: "..math.Round(((math.ceil(100*tr.HitPos.x))/100)/1))  
					surface.SetTextPos( (X*0.165), (Y/2) + 16)
					surface.DrawText( "Y: "..math.Round(((math.ceil(100*tr.HitPos.y))/100)/1))
					surface.SetTextPos( (X*0.165), (Y/2) + 32)
					surface.DrawText( "Z: "..math.Round(((math.ceil(100*tr.HitPos.z))/100)/1))

					local startpos =  Attachment.Pos
					local TracePlane = util.TraceLine( {
						start = startpos,
						endpos = (startpos + Attachment.Ang:Forward() * 90000),
					} )
					local HitPlane = TracePlane.HitPos:ToScreen()
					
					local ang = Attachment.Ang.y
					local ComAngSN = 0.55 * math.sin(math.rad(ang))
					local ComAngCN = 1 * math.cos(math.rad(ang))
					local ComAngSE = 0.55 * math.sin(math.rad(ang-270))
					local ComAngCE = 1 * math.cos(math.rad(ang-270))
					local ComAngSW = 0.55 * math.sin(math.rad(ang-90))
					local ComAngCW = 1 * math.cos(math.rad(ang-90))
					local ComAngSS = 0.55 * math.sin(math.rad(ang-180))
					local ComAngCS = 1 * math.cos(math.rad(ang-180))

					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSN*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCN*(ScrW()/ScrH())) )
					surface.DrawText( "N" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSE*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCE*(ScrW()/ScrH())) )
					surface.DrawText( "E" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSW*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCW*(ScrW()/ScrH())) )
					surface.DrawText( "W" )  
					surface.SetTextPos( HitPlane.x+(ScrW()/2)*(ComAngSS*(ScrH()/ScrW())), HitPlane.y-150*(ComAngCS*(ScrW()/ScrH())) )
					surface.DrawText( "S" )  

					local zoom_mat = Material( "models/sw/shared/sights/camera" )
					local X = ScrW() * 0.5
					local Y = ScrH() * 0.5
					surface.SetDrawColor( Color(255,255,255,255) )
					surface.SetMaterial( zoom_mat ) 
					surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )

					base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
					base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
					base:LVSPaintHitMarker( Crosshair )

					if IsValid(ent:GetDriverSeat():GetDriver()) then
						if not ent:GetDriverSeat():GetThirdPersonMode() then	
							hook.Add( "RenderScreenspaceEffects", "XRay_RenderModify", M65FX )
						
							DoM65 = true
						else
							hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
							DoM65 = false	
							for ent,clr in pairs( DefClrs ) do
								if ent:IsValid() then
									ent:SetRenderMode(RENDERMODE_TRANSALPHA)
									ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
								end
							end			
							DefClrs = {}
						end
					end
				else
					local tr = util.TraceLine( {
						start = ply:EyePos(),
						endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500000,
						filter = ent:GetVehicle():GetCrosshairFilterEnts()
					} )
					local HitPilot = tr.HitPos:ToScreen()
					local HitPlane = self:GetEyeTrace( true ).HitPos:ToScreen()
					self:PaintHeliFlightInfo( X, Y, ply, HitPlane )
					base:PaintCrosshairCenter( HitPlane, self.HudColor )

					hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
					DoM65 = false		
					for ent,clr in pairs( DefClrs ) do
						if ent:IsValid() then
							ent:SetRenderMode(RENDERMODE_TRANSALPHA)
							ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
						end
					end
					DefClrs = {}
				end
			else
				hook.Remove( "RenderScreenspaceEffects", "XRay_RenderModify" )
				DoM65 = false		
				for ent,clr in pairs( DefClrs ) do
					if ent:IsValid() then
						ent:SetRenderMode(RENDERMODE_TRANSALPHA)
						ent:SetColor(Color(clr.r, clr.g, clr.b, clr.a))
					end
				end
				DefClrs = {}
			end
			base:PaintCrosshairSquare( Crosshair, self.HudColor )
			base:PaintCrosshairCenter( Crosshair, self.HudColor )
			base:LVSPaintHitMarker( Crosshair )
		end
		bgm71.CalcView = function( ent, ply, pos, angles, fov, pod )
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
					view.drawviewer = true
					return view	
				else
					return self:LVSCalcView( ply, pos, angles, newfov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, angles, newfov, pod )
			end
		end
		self:AddWeapon( bgm71, 2 )
	end
end