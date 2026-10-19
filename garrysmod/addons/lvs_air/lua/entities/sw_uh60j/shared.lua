ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "UH-60J"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "[MP/LVS] Воздух"
ENT.Subcategory = "[НАТО]"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.AirRefuelable		= true

ENT.HudColor = Color(0,255,0,150)
ENT.HudThirdPerson = true

ENT.MDL = "models/sw/avia/uh60/uh60j.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1000
ENT.MaxHealthFuelTank = 150

ENT.MaxVelocity = 1500

ENT.ThrustUp = 1
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.05
ENT.ThrottleRateDown = 0.05

ENT.TurnRatePitch = 0.75
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 0.75

ENT.ForceLinearDampingMultiplier = 1.5

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.EngineSounds = {
	{
		sound = "sw/uh60/rotor_loop_close.wav",
		sound_int = "sw/uh60/int_engine.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 105,
		UseDoppler = true,
	},
	{
		sound = "sw/uh60/rotor_loop_dist.wav",
		sound_int = "sw/uh60/rotor_loop_int.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
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

ENT.Loadouts = 1

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
	self:AddDT( "Int", "Loadout" , { KeyName = "loadout",	Edit = { type = "Int",	order = 3, min = 0, max = self.Loadouts, category = "Weapons"} } )
	self:AddDT( "Entity", "GunnerRSeat" )
	self:AddDT( "Entity", "GunnerLSeat" )
	self:AddDT( "Entity", "FuelTank" )
	self:AddDT( "Bool", "Doors" )
	self:AddDT( "Bool", "MGR" )
	self:AddDT( "Bool", "MGL" )
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

	local flares = {}
	flares.Icon = Material("icons/flares.png")
	flares.Ammo = 128
	flares.Delay = 0.25
	flares.HeatRateUp = 1.5
	flares.HeatRateDown = 0.75
	flares.UseableByAI = false
	flares.Attack = function( ent )
		self:EmitSound("sw/misc/flr_"..math.random(1,3)..".wav")
		local projectile = ents.Create("sw_flare_v3")
		projectile:SetPos(self:LocalToWorld(Vector(-173.2,21.5,61.45)))
		projectile:SetAngles(self:LocalToWorldAngles(Angle(-math.random(110,125),-math.random(25,35),0)))
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter(projectile:GetForward()*1000)

		local projectile = ents.Create("sw_flare_v3")
		projectile:SetPos(self:LocalToWorld(Vector(-173.2,-21.5,61.45)))
		projectile:SetAngles(self:LocalToWorldAngles(Angle(-math.random(110,125),math.random(25,35),0)))
		projectile:Spawn()
		projectile:Activate()
		projectile:GetPhysicsObject():ApplyForceCenter(projectile:GetForward()*1000)
		ent:TakeAmmo( 2 )	
	end
	flares.HudPaint = function( ent, X, Y, ply )
		if self:GetEngineActive() then
			local radar = {}
			radar.scale = ScrH()/4 -- 4 is scale
			radar.OffsetX = 16
			radar.OffsetY = ScrH()/3
			radar.x = ScrW()-radar.scale-radar.OffsetX
			radar.y = ScrH()-radar.scale-radar.OffsetY
			radar.radius = 35000
			radar.ping_colour = Color(0,255,0,255)
		
			self.NextPing = self.NextPing or 0
			local curtime = CurTime()
			local Pings = {}
			local vertices = {}
			for i=1,65 do
				local shift = math.fmod(CurTime()*0,360)
				local sizescale = 1
				local tab = {}
				tab.x = radar.x+radar.scale/2 + math.cos(math.rad((360/64)*i+shift)) * radar.scale/2 * 1
				tab.y = radar.y+radar.scale/2 + math.sin(math.rad((360/64)*i+shift)) * radar.scale/2 * 1
				tab.u = 0
				tab.v = 0
				table.insert(vertices,tab)
			end
			surface.SetTexture(surface.GetTextureID("vgui/white"))
			surface.SetDrawColor(0,100,0,255)
			surface.DrawPoly(vertices)
			draw.RoundedBox( 0, radar.x+radar.scale/2, radar.y, 1, radar.scale, Color(0,255,0,255) )
			draw.RoundedBox( 0, radar.x, radar.y+radar.scale/2, radar.scale, 1, Color(0,255,0,255) )
		
			for i, v in ipairs(ents.GetAll()) do
				local vdiff = v:GetPos()-self:GetPos()
				local dummy = nil
				if (vdiff:Length() > radar.radius) then dummy = nil else
					if ((v.LVS and (v:GetVehicleType() == "car" or v:GetVehicleType() == "tank") and v:GetEngineActive()) or (v.IsSimfphyscar)) and v != self then
						table.insert(Pings,v)
					end
					if (v.Fired or v.IsRocket or v.Armed or v.Burnt) and v != self then
						table.insert(Pings,v)
					end
				end
			end
			for k, v in pairs( ents.FindByClass( "gtav_cm_flare" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "sw_flr" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "sw_flare_v3" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "misc_flare" ) ) do
				table.insert(Pings,v)
			end
		
			local count = table.Count(Pings)
			if ( count > 0 ) then
				for k,v in ipairs(Pings) do
					radar.ping_colour = Color(255,255,0,255)
		
					local cx = radar.x+radar.scale/2
					local cy = radar.y+radar.scale/2
					local vdiff = v:GetPos()-self:GetPos()
			
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					px = (vdiff.x/radar.radius)
					py = (vdiff.y/radar.radius)
					z = math.sqrt( px*px + py*py )
					phi = math.deg( math.rad( math.atan2( px, py ) ) - math.rad( math.atan2( self:GetForward().x, self:GetForward().y ) ) + 90 )
					px = math.cos(phi)*z
					py = math.sin(phi)*z
					
					draw.RoundedBox( 8, cx+px*radar.scale/2-4, cy+py*radar.scale/2-4, 4, 4, radar.ping_colour )
				end
			end
		end
	end
	self:AddWeapon( flares )

	local doors = {}
	doors.Icon = Material("icons/ramp.png")
	doors.UseableByAI = false
	doors.Ammo = -1
	doors.Delay = 0
	doors.HeatRateUp = 0
	doors.HeatRateDown = 1
	doors.StartAttack = function( ent )
		if ent:GetDoors() == false then
			ent:SetDoors(true)
		else
			ent:SetDoors(false)
		end
	end
	doors.HudPaint = function( ent, X, Y, ply )
		if self:GetEngineActive() then
			local radar = {}
			radar.scale = ScrH()/4 -- 4 is scale
			radar.OffsetX = 16
			radar.OffsetY = ScrH()/3
			radar.x = ScrW()-radar.scale-radar.OffsetX
			radar.y = ScrH()-radar.scale-radar.OffsetY
			radar.radius = 35000
			radar.ping_colour = Color(0,255,0,255)
		
			self.NextPing = self.NextPing or 0
			local curtime = CurTime()
			local Pings = {}
			local vertices = {}
			for i=1,65 do
				local shift = math.fmod(CurTime()*0,360)
				local sizescale = 1
				local tab = {}
				tab.x = radar.x+radar.scale/2 + math.cos(math.rad((360/64)*i+shift)) * radar.scale/2 * 1
				tab.y = radar.y+radar.scale/2 + math.sin(math.rad((360/64)*i+shift)) * radar.scale/2 * 1
				tab.u = 0
				tab.v = 0
				table.insert(vertices,tab)
			end
			surface.SetTexture(surface.GetTextureID("vgui/white"))
			surface.SetDrawColor(0,100,0,255)
			surface.DrawPoly(vertices)
			draw.RoundedBox( 0, radar.x+radar.scale/2, radar.y, 1, radar.scale, Color(0,255,0,255) )
			draw.RoundedBox( 0, radar.x, radar.y+radar.scale/2, radar.scale, 1, Color(0,255,0,255) )
		
			for i, v in ipairs(ents.GetAll()) do
				local vdiff = v:GetPos()-self:GetPos()
				local dummy = nil
				if (vdiff:Length() > radar.radius) then dummy = nil else
					if ((v.LVS and (v:GetVehicleType() == "car" or v:GetVehicleType() == "tank") and v:GetEngineActive()) or (v.IsSimfphyscar)) and v != self then
						table.insert(Pings,v)
					end
					if (v.Fired or v.IsRocket or v.Armed or v.Burnt) and v != self then
						table.insert(Pings,v)
					end
				end
			end
			for k, v in pairs( ents.FindByClass( "gtav_cm_flare" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "sw_flr" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "sw_flare_v3" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "misc_flare" ) ) do
				table.insert(Pings,v)
			end
		
			local count = table.Count(Pings)
			if ( count > 0 ) then
				for k,v in ipairs(Pings) do
					radar.ping_colour = Color(255,255,0,255)
		
					local cx = radar.x+radar.scale/2
					local cy = radar.y+radar.scale/2
					local vdiff = v:GetPos()-self:GetPos()
			
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					px = (vdiff.x/radar.radius)
					py = (vdiff.y/radar.radius)
					z = math.sqrt( px*px + py*py )
					phi = math.deg( math.rad( math.atan2( px, py ) ) - math.rad( math.atan2( self:GetForward().x, self:GetForward().y ) ) + 90 )
					px = math.cos(phi)*z
					py = math.sin(phi)*z
					
					draw.RoundedBox( 8, cx+px*radar.scale/2-4, cy+py*radar.scale/2-4, 4, 4, radar.ping_colour )
				end
			end
		end
	end
	self:AddWeapon( doors )

	if loadout == 0 then
		local doors = {}
		doors.Icon = Material("icons/ramp.png")
		doors.UseableByAI = false
		doors.Ammo = -1
		doors.Delay = 0
		doors.HeatRateUp = 0
		doors.HeatRateDown = 1
		doors.StartAttack = function( ent )
			if self:GetMGR() == false then
				self:SetMGR(true)
			else
				self:SetMGR(false)
			end
		end
		self:AddWeapon( doors, 3 )

		
		local doors = {}
		doors.Icon = Material("icons/ramp.png")
		doors.UseableByAI = false
		doors.Ammo = -1
		doors.Delay = 0
		doors.HeatRateUp = 0
		doors.HeatRateDown = 1
		doors.StartAttack = function( ent )
			if self:GetMGL() == false then
				self:SetMGL(true)
			else
				self:SetMGL(false)
			end
		end
		self:AddWeapon( doors, 4 )
	else
		local mgr = {}
		mgr.Icon = Material("icons/mg3")
		mgr.Ammo = 1000
		mgr.Delay = 0.01
		mgr.HeatRateUp = 0.25
		mgr.HeatRateDown = 0.25
		mgr.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_r" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.EnableBallistics = true
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			self:ResetSequence("fire_r")
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		mgr.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGR ) then return end
			base.SNDTurretMGR:Play()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGRspin ) then return end
			base.SNDTurretMGRspin:Play()
		end
		mgr.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGR ) then return end
			base.SNDTurretMGR:Stop()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGRspin ) then return end
			base.SNDTurretMGRspin:Stop()
	
			if not IsValid( base ) or not IsValid( base.SNDTurretMGRstop ) then return end
			base.SNDTurretMGRstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		mgr.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_r" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
		end
		mgr.OnThink = function( ent, active )
			if not active or not self:GetMGR() then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = self:LookupAttachment( "muzzle_r" )
			local MG = self:GetAttachment( ID )
		
			if not MG then return end
			local trace = ent:GetEyeTrace()
			local _,Ang = WorldToLocal( Vector(0,0,0), (trace.HitPos - MG.Pos):GetNormalized():Angle(), Vector(0,0,0), self:LocalToWorldAngles( Angle(0,-90,0) ) )
			self:SetPoseParameter("pitch_r", -Ang.p )
			self:SetPoseParameter("yaw_r", -Ang.y )
		end
		mgr.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "muzzle_r" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos-Attachment.Ang:Forward()*55+Attachment.Ang:Up()*7
					view.angles = Attachment.Ang
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		self:AddWeapon( mgr, 3 )

		local mgl = {}
		mgl.Icon = Material("icons/mg3")
		mgl.Ammo = 1000
		mgl.Delay = 0.01
		mgl.HeatRateUp = 0.25
		mgl.HeatRateDown = 0.25
		mgl.Attack = function( ent )
			local ID = self:LookupAttachment( "muzzle_l" )
			local Attachment = self:GetAttachment( ID )
	
			if not Attachment then return end
	
			local bullet = {}
			bullet.Src 	= Attachment.Pos
			bullet.Dir 	= Attachment.Ang:Forward()
			bullet.Spread 	= Vector(0.025,0.025,0.025)
			bullet.TracerName = "lvs_tracer_yellow"
			bullet.Force	= 1300
			bullet.HullSize = 0
			bullet.EnableBallistics = true
			bullet.Damage	= 35
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			ent:LVSFireBullet( bullet )
	
			self:ResetSequence("fire_l")
			ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)
	
			ent:TakeAmmo( 1 )
		end
		mgl.StartAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGL ) then return end
			base.SNDTurretMGL:Play()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGLspin ) then return end
			base.SNDTurretMGLspin:Play()
		end
		mgl.FinishAttack = function( ent )
			local base = ent:GetVehicle()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGL ) then return end
			base.SNDTurretMGL:Stop()
			if not IsValid( base ) or not IsValid( base.SNDTurretMGLspin ) then return end
			base.SNDTurretMGLspin:Stop()
	
			if not IsValid( base ) or not IsValid( base.SNDTurretMGLstop ) then return end
			base.SNDTurretMGLstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		end
		mgl.HudPaint = function( ent, X, Y, ply )
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = base:LookupAttachment( "muzzle_l" )
			local Attachment = base:GetAttachment( ID )
	
			local tr = util.TraceLine( {
				start = Attachment.Pos,
				endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
				filter = base:GetCrosshairFilterEnts()
			} )
	
	
			local Crosshair = tr.HitPos:ToScreen() 
			base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
			base:LVSPaintHitMarker( Crosshair )
		end
		mgl.OnThink = function( ent, active )
			if not active or not self:GetMGR() then return end
			local base = ent:GetVehicle()
			if not IsValid( base ) then return end
	
			local ID = self:LookupAttachment( "muzzle_l" )
			local MG = self:GetAttachment( ID )
		
			if not MG then return end
			local trace = ent:GetEyeTrace()
			local _,Ang = WorldToLocal( Vector(0,0,0), (trace.HitPos - MG.Pos):GetNormalized():Angle(), Vector(0,0,0), self:LocalToWorldAngles( Angle(0,90,0) ) )
			self:SetPoseParameter("pitch_l", -Ang.p )
			self:SetPoseParameter("yaw_l", -Ang.y )
		end
		mgl.CalcView = function( ent, ply, pos, angles, fov, pod )
			if not pod:GetThirdPersonMode() then
				if ply:lvsKeyDown("ZOOM") then
					local ID = self:LookupAttachment( "muzzle_l" )
					local Attachment = self:GetAttachment( ID )
					local view = {}
					view.origin = Attachment.Pos-Attachment.Ang:Forward()*55+Attachment.Ang:Up()*7
					view.angles = Attachment.Ang
					return view	
				else
					return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
				end
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
			end
		end
		self:AddWeapon( mgl, 4 )
	end

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

		local Pitch = math.Clamp( math.ApproachAngle( base:GetPoseParameter("cam_pitch"), -Angles.p, 150*FrameTime() ), -90, 25 )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("cam_yaw"), Angles.y, 150*FrameTime())

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("cam_yaw", Yaw )
		base:SetPoseParameter("cam_pitch", Pitch )
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
		base:PaintCrosshairSquare( Crosshair, Color(255,255,255,255) )
		base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
		base:LVSPaintHitMarker( Crosshair )

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/camera" )
				local X = ScrW() * 0.5
				local Y = ScrH() * 0.5
				surface.SetDrawColor( Color(255,255,255,255) )
				surface.SetMaterial( zoom_mat ) 
				surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH(), 0 )

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
				surface.SetTextPos( (ScrW()*0.465), (ScrH()/1.85) )
				surface.SetFont("sw_digital")
				surface.DrawText( "DISTANCE: "..range )

				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						if self:GetFLIR() then	
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

		if self:GetEngineActive() then		
			local radar = {}
			radar.scale = ScrH()/4 -- 4 is scale
			radar.OffsetX = 16
			radar.OffsetY = ScrH()/3
			radar.x = ScrW()-radar.scale-radar.OffsetX
			radar.y = ScrH()-radar.scale-radar.OffsetY
			radar.radius = 35000
			radar.ping_colour = Color(0,255,0,255)
		
			self.NextPing = self.NextPing or 0
			local curtime = CurTime()
			local Pings = {}
			local vertices = {}
			for i=1,65 do
				local shift = math.fmod(CurTime()*0,360)
				local sizescale = 1
				local tab = {}
				tab.x = radar.x+radar.scale/2 + math.cos(math.rad((360/64)*i+shift)) * radar.scale/2 * 1
				tab.y = radar.y+radar.scale/2 + math.sin(math.rad((360/64)*i+shift)) * radar.scale/2 * 1
				tab.u = 0
				tab.v = 0
				table.insert(vertices,tab)
			end
			surface.SetTexture(surface.GetTextureID("vgui/white"))
			surface.SetDrawColor(0,100,0,255)
			surface.DrawPoly(vertices)
			draw.RoundedBox( 0, radar.x+radar.scale/2, radar.y, 1, radar.scale, Color(0,255,0,255) )
			draw.RoundedBox( 0, radar.x, radar.y+radar.scale/2, radar.scale, 1, Color(0,255,0,255) )
		
			for i, v in ipairs(ents.GetAll()) do
				local vdiff = v:GetPos()-self:GetPos()
				local dummy = nil
				if (vdiff:Length() > radar.radius) then dummy = nil else
					if ((v.LVS and (v:GetVehicleType() == "car" or v:GetVehicleType() == "tank") and v:GetEngineActive()) or (v.IsSimfphyscar)) and v != self then
						table.insert(Pings,v)
					end
					if (v.Fired or v.IsRocket or v.Armed or v.Burnt) and v != self then
						table.insert(Pings,v)
					end
				end
			end
			for k, v in pairs( ents.FindByClass( "gtav_cm_flare" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "sw_flr" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "sw_flare_v3" ) ) do
				table.insert(Pings,v)
			end
			for k, v in pairs( ents.FindByClass( "misc_flare" ) ) do
				table.insert(Pings,v)
			end
		
			local count = table.Count(Pings)
			if ( count > 0 ) then
				for k,v in ipairs(Pings) do
					radar.ping_colour = Color(255,255,0,255)
		
					local cx = radar.x+radar.scale/2
					local cy = radar.y+radar.scale/2
					local vdiff = v:GetPos()-self:GetPos()
			
					local ID = self:LookupAttachment( "view" )
					local Attachment = self:GetAttachment( ID )
					px = (vdiff.x/radar.radius)
					py = (vdiff.y/radar.radius)
					z = math.sqrt( px*px + py*py )
					phi = math.deg( math.rad( math.atan2( px, py ) ) - math.rad( math.atan2( self:GetForward().x, self:GetForward().y ) ) + 90 )
					px = math.cos(phi)*z
					py = math.sin(phi)*z
					
					draw.RoundedBox( 8, cx+px*radar.scale/2-4, cy+py*radar.scale/2-4, 4, 4, radar.ping_colour )
				end
			end
		end
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
				view.drawviewer = true
				return view	
			else
				return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), newfov, pod )
		end
	end
	self:AddWeapon( flir, 2 )
end