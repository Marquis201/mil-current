ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Eitan"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] - БМП"
ENT.VehicleCategory = "БМП"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/eitan/eitan.mdl"
ENT.MDL_DESTROYED = "models/sw/ground/eitan/eitan_dmg.mdl"
ENT.MaxHealthEngine = 350
ENT.MaxHealthFuelTank = 250
ENT.DSArmorIgnoreForce = 1500
ENT.ProjectileVelocity = 17920

ENT.AITEAM = 2

ENT.MaxVelocity = 900
ENT.MaxVelocityReverse = 500
ENT.MaxHealth = 1500

ENT.EngineCurve = 0.35
ENT.EngineTorque = 150
ENT.EngineIdleRPM = 1500
ENT.EngineMaxRPM = 3000

ENT.TransGears = 6
ENT.TransGearsReverse = 3

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
	self:AddDT( "Entity", "CommanderSeat" )
	self:AddDT( "Bool", "Hatch" )
	self:AddDT( "Bool", "FLIR" )
	self:AddDT( "Bool", "TurretDestroyed" )
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
function ENT:GunnerInRange( Dir )
	return self:AngleBetweenNormal( self:GetForward(), Dir ) < 30
end
function ENT:InitWeapons()
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
		grenade:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
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
		grenade:GetPhysicsObject():SetVelocity( Dir * 750 ) 
		grenade:GetPhysicsObject():AddVelocity(self:GetPhysicsObject():GetVelocity())
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
	self:AddWeapon( smoke )

	local flir = {}
	flir.Icon = Material("icons/flir.png")
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
	flir.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local ID = base:LookupAttachment( "muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = base:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 
			
			base:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )

			base:LVSPaintHitMarker( MuzzlePos2D )
		end

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
	flir.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoomMg = self.curZoomMg and math.Clamp(self.curZoomMg + (zOut - zIn) * FrameTime() * 150,30,90) or 0

				local view = {}
				view.origin = Attachment.Pos
				view.angles = ply:EyeAngles()
				view.fov = self.curZoomMg
				return view	
			else
				local pos1 = self:LocalToWorld(Vector(-17,-15,108))
				return self:LVSCalcView( ply, pos1, ply:EyeAngles(), fov, pod )
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( flir, 2 )

	local m2 = {}
	m2.Icon = Material("icons/m2")
	m2.Clip = 200
	m2.Ammo = 2000
	m2.Delay = 0.1
	m2.ReloadSpeed = 5
	m2.OnReload = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		base:TurretUpdateBallistics( base.ProjectileVelocity, "muzzle" )
		base.SNDRld:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	m2.Attack = function( ent )
		local ID = self:LookupAttachment( "muzzle" )
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
		bullet.Velocity = 17900
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		ParticleEffect("muzzleflash_akm_3rd",Attachment.Pos,Attachment.Ang,nil)

		ent:TakeAmmo( 1 )
	end
	m2.StartAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Play()
	end
	m2.FinishAttack = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) or not IsValid( base.SNDTurret ) then return end
		base.SNDTurret:Stop()

		if not IsValid( base ) or not IsValid( base.SNDTurretStop ) then return end
		base.SNDTurretStop:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	m2.HudPaint = function( ent, X, Y, ply )
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
	m2.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoomMg = self.curZoomMg and math.Clamp(self.curZoomMg + (zOut - zIn) * FrameTime() * 150,30,90) or 0

				local view = {}
				view.origin = Attachment.Pos
				view.angles = ply:EyeAngles()
				view.fov = self.curZoomMg
				return view	
			else
				local pos1 = self:LocalToWorld(Vector(-17,-15,108))
				return self:LVSCalcView( ply, pos1, ply:EyeAngles(), fov, pod )
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( m2, 2 )

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
				local zoom_mat = Material( "models/sw/shared/sights/new/binoculars_us" )
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
	weapon.OnSelect = function( ent )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( false )
		end
		self:SetHatch(true)
	end
	weapon.OnDeselect = function( ent )local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( true )
		end
		self:SetHatch(false)
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local zIn = ply:KeyDown( IN_FORWARD ) and 1 or 0
				local zOut = ply:KeyDown( IN_BACK ) and 1 or 0
				self.curZoomCom = self.curZoomCom and math.Clamp(self.curZoomCom + (zOut - zIn) * FrameTime() * 150,10,90) or 0

				local pos1 = self:LocalToWorld(Vector(-17,-15,128))
				return self:LVSCalcView( ply, pos1, ply:EyeAngles(), self.curZoomCom, pod )
			else
				local pos1 = self:LocalToWorld(Vector(-17,-15,128))
				return self:LVSCalcView( ply, pos1, ply:EyeAngles(), fov, pod )
			end
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( weapon, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
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
	end
	weapon.OnDeselect = function( ent, old, new  )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if base.SetTurretEnabled then
			base:SetTurretEnabled( true )
		end
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
			local pos1 = self:LocalToWorld(Vector(-17,-15,108))
			return self:LVSCalcView( ply, pos1, ply:EyeAngles(), fov, pod )
		else
			return self:LVSCalcView( ply, pos, ply:EyeAngles(), fov, pod )
		end
	end
	self:AddWeapon( weapon, 2 )
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

ENT.ExhaustPositions = {
	{
		pos = Vector(55,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,80),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,75),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(55,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(40,-63,70),
		ang = Angle(0,220,0)
	},
	{
		pos = Vector(25,-63,70),
		ang = Angle(0,220,0)
	},
}
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
			{ pos = Vector(118,56.5,79), colorA = 150 },
			{ pos = Vector(118,-56.5,79), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(118,56.5,79), colorA = 150 },
			{ pos = Vector(118,-56.5,79), colorA = 150 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(120.6,50,79), colorA = 150 },
			{ pos = Vector(120.6,-50,79), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(120.6,50,79), colorA = 150 },
			{ pos = Vector(120.6,-50,79), colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		Sprites = {
			{ pos = Vector(142,39.35,52), colorA = 150 },
			{ pos = Vector(142,-39.35,52), colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(142,39.35,52), colorA = 150 },
			{ pos = Vector(142,-39.35,52), colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-162.4,-56.5,95.4), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-162.4,56.5,95.4), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(123.3,-44.1,78.35), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(72,-59,50), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(0,-59,45.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-72,-59,50), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-132.7,-59,50), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(123.3,44.1,78.35), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(72,59,50), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(0,59,45.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-72,59,50), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-132.7,59,50), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
}