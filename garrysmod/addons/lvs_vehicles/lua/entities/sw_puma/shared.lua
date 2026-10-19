
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Puma"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - БМП"
ENT.VehicleCategory = "БМП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

--damage system
ENT.DSArmorIgnoreForce = 500
ENT.ProjectileVelocityATGM = 99999
ENT.ProjectileVelocityHighExplosive = 21600
ENT.ProjectileVelocityArmorPiercing = 28100
ENT.ProjectileVelocityCoaxial = 16400

ENT.MDL = "models/sw/ground/puma/puma.mdl"
ENT.MDL_DESTROYED = "models/sw/ground/puma/puma_dmg.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1500

ENT.SteerSpeed = 10
ENT.SteerReturnSpeed = 10

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 300

ENT.EngineCurve = 0.2
ENT.EngineTorque = 300

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 4
ENT.TransGearsReverse = 4
ENT.MouseSteerAngle = 40

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
	DrawSobel( 0.25 )
	DrawMotionBlur(FrameTime() * 30, 0.5, 0.05)
	DrawBokehDOF( 0.75, 1, 5 )
end
function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Bool", "TurretDestroyed" )
	self:AddDT( "Bool", "UseHighExplosive" )
	self:AddDT( "Bool", "FLIR" )
	self:AddDT( "Bool", "Ramp" )
	self:AddDT( "Entity", "ClosestEnt" )
	self:AddDT( "Float", "ClosestDist" )
	self:AddDT( "Bool", "IsLocked" )
	self:AddDT( "Int", "LockTimer" )
	self:AddDT( "Int", "SeekerAngle" )
	self:AddDT( "Int", "SeekerDist" )
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
	local ramp = {}
	ramp.Icon = Material("icons/ramp.png")
	ramp.UseableByAI = false
	ramp.Ammo = -1
	ramp.Delay = 0
	ramp.HeatRateUp = 0
	ramp.HeatRateDown = 1
	ramp.StartAttack = function( ent )
		if self:GetRamp() == false then
			self:SetRamp(true)
		else
			self:SetRamp(false)
		end
	end
	self:AddWeapon( ramp )

	local flir = {}
	flir.Icon = Material("icons/flir.png")
	flir.Ammo = -1
	flir.Delay = 0
	flir.HeatRateUp = 0
	flir.HeatRateDown = 1
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
	end
	flir.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityATGM, "muzzle" )
	end
	self:AddWeapon( flir, 2 )

	local mg3 = {}
	mg3.Icon = Material("icons/mg3")
	mg3.Clip = 1000
	mg3.Ammo = 2000
	mg3.Delay = 0.05
	mg3.ReloadSpeed = 5
	mg3.OnReload = function( ent )
		local base = ent:GetVehicle()
		base.SNDMGRldInt:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	mg3.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos-Attachment.Ang:Forward()*73+Attachment.Ang:Right()*8+Attachment.Ang:Up()*8
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 1300
		bullet.HullSize = 0
		bullet.EnableBallistics = true
		bullet.Damage	= 35
		bullet.Velocity = 16400
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",bullet.Src,Attachment.Ang,nil)

		ent:TakeAmmo( 1 )
	end
	mg3.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Play()
	end
	mg3.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurretMG ) then return end
		base.SNDTurretMG:Stop()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGstop ) then return end
		base.SNDTurretMGstop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	mg3.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )
		local Attachment = base:GetAttachment( ID )

		local tr = util.TraceLine( {
			start = Attachment.Pos-Attachment.Ang:Forward()*100-Attachment.Ang:Right()*25+Attachment.Ang:Up()*10,
			endpos = Attachment.Pos + Attachment.Ang:Forward() * 500000,
			filter = base:GetCrosshairFilterEnts()
		} )


		local Crosshair = tr.HitPos:ToScreen() 
		base:PaintCrosshairCenter( Crosshair, Color(255,255,255,255) )
		base:LVSPaintHitMarker( Crosshair )

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
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
	end
	mg3.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityCoaxial, "muzzle" )
	end
	self:AddWeapon( mg3, 2 )

	local cannon = {}
	cannon.Icon = true
	cannon.Clip = 100
	cannon.Ammo = 400
	cannon.Delay = 0.3
	cannon.ReloadSpeed = 7
	cannon.OnReload = function( ent )
		local base = ent:GetVehicle()
		base.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	cannon.Attack = function( ent )

		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		if not Attachment then return end

		local bullet = {}
		bullet.Src 	= Attachment.Pos
		bullet.Dir 	= Attachment.Ang:Forward()
		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.EnableBallistics = true

		if self:GetUseHighExplosive() then
			bullet.TracerName = "lvs_tracer_yellow"	
			bullet.Force	= 9000
			bullet.Damage	= 175
			bullet.HullSize 	= 3
			bullet.SplashDamage = 65
			bullet.SplashDamageRadius = 100
			bullet.Velocity = 21600
		else
			bullet.TracerName = "lvs_tracer_white"	
			bullet.Force = 12100
			bullet.Damage = 150
			bullet.HullSize = 1
			bullet.Velocity = 28100
		end
		
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		if not IsValid( self.SNDTurret ) then return end
		self.SNDTurret:PlayOnce( 150 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		ParticleEffect("muzzleflash_m590_3rd",Attachment.Pos,Attachment.Ang,nil)
		util.ScreenShake( Attachment.Pos, 1, 10, 1, 350, true, nil )

		local ID = self:LookupAttachment( "muzzle" )
		local Attachment = self:GetAttachment( ID )

		local Shell = ents.Create( "lvs_item_shell" )	
		if not IsValid( Shell ) then return end
				
		Shell.LifeTime = 5
		Shell:SetPos( Attachment.Pos + Attachment.Ang:Right()*25 - Attachment.Ang:Forward()*135 )
		Shell:SetAngles( Attachment.Ang+Angle(math.random(-1,1),90,Attachment.Ang.p) )
		Shell:SetModelScale(0.25)
		Shell:Spawn()
		Shell:Activate()
		Shell:SetOwner( self )
		Shell:SetCollisionGroup(1)
				
		local PhysObj = Shell:GetPhysicsObject()
				
		if not IsValid( PhysObj ) then return end
				
		PhysObj:ApplyForceCenter( Shell:GetForward() * -200 )
		PhysObj:AddVelocity(self:GetPhysicsObject():GetVelocity())

		ent:TakeAmmo( 1 )
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
						base:TurretUpdateBallistics( base.ProjectileVelocityHighExplosive, "muzzle" )

						if not IsValid( base.SNDRld ) then return end
						base.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					else
						self:SetUseHighExplosive( false )
						ent:SetHeat( 1 )
						ent:SetOverheated( true )
						base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
						
						if not IsValid( base.SNDRld ) then return end
						base.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
					end
				end
			end
		end
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
	end
	cannon.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if base:GetUseHighExplosive() then
			base:TurretUpdateBallistics( base.ProjectileVelocityHighExplosive, "muzzle" )
		else
			base:TurretUpdateBallistics( base.ProjectileVelocityArmorPiercing, "muzzle" )
		end
	end
	self:AddWeapon( cannon, 2 )

	local spike = {}
	spike.Icon = Material("icons/bgm71")
	spike.Ammo = 6
	spike.Delay = 5
	spike.HeatRateUp = 0
	spike.HeatRateDown = 1
	spike.OnOverheat = function( ent )
		local base = ent:GetVehicle()
		base.SNDATGMRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		timer.Simple(10,function()
			if IsValid(self) then
				self:SetNWBool("LastMis",false)
				ent:SetOverheated( false )
				ent:SetHeat( 0 )
				base.SNDATGMRldEnd:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
			end
		end)
	end
	spike.Attack = function( ent )
		if self:GetIsLocked() and IsValid(self:GetClosestEnt()) then		
			self._MuzzleID = self._MuzzleID and self._MuzzleID + 1 or 1
			if self._MuzzleID > 2 then
				self._MuzzleID = 1
			end
			if self._MuzzleID == 2 then
				self:SetNWBool("LastMis",true)
			end
			local ID = self:LookupAttachment( "missile_"..self._MuzzleID )
			local Muzzle = self:GetAttachment( ID )
			if not Muzzle then return end
				
			local projectile = ents.Create("sw_rocket_spikelr_v3")
			projectile:SetPos(Muzzle.Pos)
			projectile:SetAngles(Muzzle.Ang)
			projectile:Spawn()
			projectile:Activate()
			projectile:GetPhysicsObject():AddVelocity(projectile:GetForward()*1000)
			constraint.NoCollide(self,projectile,0,0)
			constraint.NoCollide(projectile,self,0,0)		
			projectile.RocketTrail = "rockettrail"
			projectile.RocketBurnoutTrail = "Med_mis_burnout"  
			projectile.GuidanceActive = true
			projectile.target = self:GetClosestEnt()
			projectile.SkyfallMode = true
			projectile.targetOffset = projectile.target:WorldToLocal(projectile.target:GetPos()+(projectile.target:GetUp()*500))
			projectile.DiveHeight = 100
			projectile:SetTracerScale(5)
			projectile.calcTarget = function(r)
				if !IsValid(r.target) then
					return r:GetPos() + r:GetForward()
				else
					return r.target:LocalToWorld(r.targetOffset)
				end
			end
			self:SetIsLocked(false)


			timer.Simple(0.5,function()
				if IsValid(projectile) then
					projectile:Launch()
					projectile.Armed = true
					projectile.Launcher = self
				end
			end)
			if self.TrackSND then
				self.TrackSND:Stop()
			end
			if self.LockSND then
				self.LockSND:Stop()
			end

			if not IsValid( self.SNDTurretMis ) then return end
			self.SNDTurretMis:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

			ParticleEffect("ins_weapon_rpg_frontblast",Muzzle.Pos,Muzzle.Ang,self)
			ent:TakeAmmo( 1 )	
		end
	end
	spike.OnThink = function( ent, active )
		if IsValid(ent) then
			if self:GetNWBool("LastMis") == true then
				ent:SetHeat( 1 )
				ent:SetOverheated( true )
			end
		end

		if not active then 
			self:SetIsLocked(false)
			if self.TrackSND then
				self.TrackSND:Stop()
			end
			if self.LockSND then
				self.LockSND:Stop()
			end
			return
		end
		self:Seeker()
	end
	spike.HudPaint = function( ent, X, Y, ply )
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
				if IsValid(ent:GetDriverSeat():GetDriver()) then
					if not ent:GetDriverSeat():GetThirdPersonMode() then	
						surface.SetDrawColor( Color( 255, 255,255, 255 ) )
						-- Box
						surface.DrawLine( ScrW()/2.57, ScrH()/2.45, ScrW()/1.62, ScrH()/2.45 ) --Top Line
						surface.DrawLine( ScrW()/2.57, ScrH()/1.6875, ScrW()/1.62, ScrH()/1.6875 ) -- Bottom Line
						surface.DrawLine( ScrW()/2.57, ScrH()/1.6875, ScrW()/2.57, ScrH()/2.45 ) -- Left Line
						surface.DrawLine( ScrW()/1.62, ScrH()/1.6875, ScrW()/1.62, ScrH()/2.45 ) -- Right Line

						if IsValid(self:GetClosestEnt()) then
							local pos = ( self:GetClosestEnt():LocalToWorld(self:GetClosestEnt():OBBCenter()) ):ToScreen()
							surface.DrawLine( 0, pos.y, ScrW(), pos.y ) 
							surface.DrawLine( pos.x, 0, pos.x, ScrH() ) 
							
							local pos = ( self:GetClosestEnt():LocalToWorld(self:GetClosestEnt():OBBCenter()) ):ToScreen()
							local tly = ScrH()/250
							local tly2 = ScrH()/200
							local tlx = ScrW()/153.6
							local tlx2 = ScrW()/307.2
							surface.SetDrawColor( Color( 255, 255,255, 255 ) )
							-- Top left
							surface.DrawLine( pos.x-tlx, (pos.y-tly2)-tly, pos.x-tlx2, (pos.y-tly2)-tly ) -- horizontal line
							surface.DrawLine( pos.x-tlx, (pos.y-tly2)-tly, pos.x-tlx, (pos.y-tly2)+tly ) -- vertical line	
							-- Bottom right
							surface.DrawLine( pos.x+tlx, (pos.y+tly2)+tly, pos.x+tlx2, (pos.y+tly2)+tly ) -- horizontal line
							surface.DrawLine( pos.x+tlx, (pos.y+tly2)+tly, pos.x+tlx, (pos.y+tly2)-tly ) -- vertical line
							-- Bottom left
							surface.DrawLine( pos.x-tlx, (pos.y+tly2)+tly, pos.x-tlx2, (pos.y+tly2)+tly ) -- horizontal line
							surface.DrawLine( pos.x-tlx, (pos.y+tly2)+tly, pos.x-tlx, (pos.y+tly2)-tly ) -- vertical line
							-- Top Right
							surface.DrawLine( pos.x+tlx, (pos.y-tly2)-tly, pos.x+tlx2, (pos.y-tly2)-tly ) -- horizontal line
							surface.DrawLine( pos.x+tlx, (pos.y-tly2)-tly, pos.x+tlx, (pos.y-tly2)+tly ) -- vertical line
						end

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
	end
	spike.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityATGM, "muzzle" )
	end
	self:AddWeapon( spike, 2 )

	local smoke = {}
	smoke.Icon = Material("icons/smoke_launcher")
	smoke.Ammo = 8
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
		grenade:GetPhysicsObject():SetVelocity( Dir * 500 ) 
		grenade:SetCollisionGroup(20)

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
		grenade:GetPhysicsObject():SetVelocity( Dir * 500 ) 
		grenade:SetCollisionGroup(20)

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
	end
	smoke.OnSelect = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocityATGM, "muzzle" )
	end
	self:AddWeapon( smoke, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
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
	end
	weapon.OnSelect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( false )
		end
		base:TurretUpdateBallistics( base.ProjectileVelocityATGM, "muzzle_1" )
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon, 2 )
end
ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(144,61.85,54.7), colorA = 150 },
			{ pos = Vector(144,-61.85,54.7), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(144,61.85,54.7), colorA = 150 },
			{ pos = Vector(144,-61.85,54.7), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(144,61.85,54.7), colorA = 150 },
			{ pos = Vector(144,-61.85,54.7), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(144,61.85,54.7), colorA = 150 },
			{ pos = Vector(144,-61.85,54.7), colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		Sprites = {
			{ pos = Vector(-152,50.6,51), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-152,-50.6,51), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(-151,-72.45,37.1), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-125.8,-79.5,44.85), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-18.2,-79.8,41), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(104,-80,41), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(113,-79.1,58.35), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(139.4,-63.9,61.4), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(-151,72.45,37.1), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-125.8,79.5,44.85), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-18.2,79.8,41), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(104,80,41), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(113,79.1,58.35), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(139.4,63.9,61.4), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
}
ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/halftrack/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/halftrack/eng_loop.wav",
		Volume = 1,
		Pitch = 25,
		PitchMul = 100,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/halftrack/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 25,
		PitchMul = 100,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
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

	if self.TrackSND then
		self.TrackSND:Stop()
	end
	if self.LockSND then
		self.LockSND:Stop()
	end
end