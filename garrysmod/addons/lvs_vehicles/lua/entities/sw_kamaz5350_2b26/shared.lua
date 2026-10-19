
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "KAMAZ-5350 2B26"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "[MP/LVS] Грузовики"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/ground/kamaz5350/kamaz5350_2b26.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1100
ENT.MaxVelocityReverse = 350
ENT.MaxHealth = 1000

ENT.EngineCurve = 0.35
ENT.EngineTorque = 150
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 4500

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn3.wav"
ENT.HornPos = Vector(150,0,60)

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
end
function ENT:InitWeapons()
	local mlrs = {}
	mlrs.Icon = Material("lvs/weapons/missile.png")
	mlrs.Ammo = 40
	mlrs.Delay = 0.3
	mlrs.HeatRateUp = 0
	mlrs.HeatRateDown = 0
	mlrs.Attack = function( ent )
		self._MuzzleID = self._MuzzleID and self._MuzzleID + 1 or 1
		if self._MuzzleID > 40 then
			self._MuzzleID = 1
		end
		local ID = self:LookupAttachment( "muzzle_"..self._MuzzleID )
		local Muzzle = self:GetAttachment( ID )
		if not Muzzle then return end
	
		local Driver = self:GetGunnerSeat():GetDriver()
	
		local projectile = ents.Create( "sw_rocket_9m22_v3" )
		projectile:SetPos( Muzzle.Pos+Muzzle.Ang:Forward()*150 )
		projectile:SetAngles( Muzzle.Ang+Angle(math.Rand(-3,3),math.Rand(-3,3),math.Rand(-3,3)) )
		projectile:Spawn()
		projectile:Activate()
		projectile:Launch()
		projectile.RocketTrail = "rockettrail"
		projectile.Armed = true
		projectile.Launcher = self
	
		ParticleEffect("ins_weapon_rpg_backblast",Muzzle.Pos,-Muzzle.Ang,nil)
		util.ScreenShake( Muzzle.Pos, 3, 20, 1, 500, true, nil )
	
		if not IsValid( self.SNDTurret ) then return end
		self.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		ent:TakeAmmo()
	end
	mlrs.OnThink = function( ent, active )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		local Angles = (IsValid(ent:GetDriver()) and base:WorldToLocalAngles( ent:GetAimVector():Angle() )) or Angle(0,0,0)
		Angles:Normalize()

		local Pitch = math.ApproachAngle( base:GetPoseParameter("cannon_pitch"), -Angles.p, 15*FrameTime() )
		local Yaw = math.ApproachAngle( base:GetPoseParameter("cannon_yaw"), Angles.y, 15*FrameTime() )

		if IsValid(ent:GetDriver()) and ent:GetDriver():lvsKeyDown("FREELOOK") then return end
		base:SetPoseParameter("cannon_yaw", Yaw )
		self:SetNWFloat("TurretYaw",base:GetPoseParameter("cannon_yaw"))
		base:SetPoseParameter("cannon_pitch", Pitch )
	end
	mlrs.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()
		if not IsValid( base ) then return end

		if not ent:GetDriverSeat():GetThirdPersonMode() then
			if ply:lvsKeyDown("ZOOM") then
				local zoom_mat = Material( "models/sw/shared/sights/new/sight_bm21" )
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

		local ID = base:LookupAttachment( "muzzle_5" )
		local Attachment = base:GetAttachment( ID )

		local color_red = Color(0,0,0,255)
		local HudTargets = {}
		local Grav = physenv.GetGravity()
		local FT = RealFrameTime()
		local Pos = Attachment.Pos
		local Vel = Attachment.Ang:Forward() * 4000
		cam.Start3D()
		local Iteration = 0
		while Iteration < 4000 do
			Iteration = Iteration + 0.005
		
			Vel = Vel + Grav * FT
		
			local StartPos = Pos
			local EndPos = Pos + Vel * FT
		
			local trace = util.TraceLine( {
				start = StartPos,
				endpos = EndPos,
				mask = MASK_SOLID_BRUSHONLY,
			} )

			Pos = EndPos
			self:SetNWVector("SightPos",Pos)
		
			if trace.Hit then
				break
			end
		end
		cam.End3D()	
		local TargetPos = Pos:ToScreen()
		surface.DrawCircle( TargetPos.x, TargetPos.y, 1.5 , color_red )
		surface.SetDrawColor(0,0,0,255)
		surface.DrawLine( TargetPos.x-4, TargetPos.y-4,TargetPos.x-13, TargetPos.y-13 )
		surface.DrawLine( TargetPos.x+3, TargetPos.y-4,TargetPos.x+12, TargetPos.y-13 )
		surface.DrawLine( TargetPos.x+3, TargetPos.y+3,TargetPos.x+12, TargetPos.y+12 )
		surface.DrawLine( TargetPos.x-4, TargetPos.y+3,TargetPos.x-13, TargetPos.y+12 )	

		surface.SetTextColor( 255, 255, 255,255 )
		surface.SetTextPos( (X*0.165), (Y/2) )
		surface.DrawText( "Координаты наведения:")  
		surface.SetTextPos( (X*0.165), (Y/2) + 16)
		surface.DrawText( "X: ~ "..math.Round(((math.ceil(100*Pos.x))/100)/1))  
		surface.SetTextPos( (X*0.165), (Y/2) + 32)
		surface.DrawText( "Y: ~ "..math.Round(((math.ceil(100*Pos.y))/100)/1))
		surface.SetTextPos( (X*0.165), (Y/2) + 48)
		surface.DrawText( "Z: ~ "..math.Round(((math.ceil(100*Pos.z))/100)/1))

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
		surface.DrawTexturedRectRotated( X, Y*1.9, ScrW()*0.085, ScrH()*0.15, ent:GetVehicle():WorldToLocalAngles( ent:GetAimVector():Angle()).y )
	end
	mlrs.CalcView = function( ent, ply, pos, angles, fov, pod )
		if not pod:GetThirdPersonMode() then
		   if ply:lvsKeyDown("ZOOM") then
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				--view.origin = Attachment.Pos
				--view.angles = Attachment.Ang
				--view.drawviewer = true

				view.origin = self:GetNWVector("SightPos")+Vector(0,0,self:GetPos():Distance(self:GetNWVector("SightPos"))*0.5)
				view.angles = Angle(90,Attachment.Ang.y,0)
				return view
			else
				local ID = self:LookupAttachment( "view" )
				local Attachment = self:GetAttachment( ID )
				local view = {}
				view.origin = Attachment.Pos+(Attachment.Ang:Forward()*10)
				return view	
			end
		else
			local ID = self:LookupAttachment( "muzzle_5" )
			local Attachment = self:GetAttachment( ID )
			return self:LVSCalcView( ply, Attachment.Pos+(Attachment.Ang:Up()*50)-(Attachment.Ang:Forward()*100), angles, fov, pod )
		end
	end
	self:AddWeapon( mlrs, 2 )
end

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/222/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 65,
		PitchMul = 15,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/222/eng_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
		ProjectedTextures = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
		ProjectedTextures = {
			{ pos = Vector(150,35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
			{ pos = Vector(150,-35.75,56.75), ang = Angle(0,0,0), colorA = 200 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-152,-40.75,43.4), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-152,40.75,43.4), colorG = 0, colorB = 0, colorA = 150 },	
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 3,
		Sprites = {
			{ pos = Vector(131.6,49.7,113.6), colorA = 200 },
		},
		ProjectedTextures = {
			{ pos = Vector(131.6,49.7,113.6), colorA = 200 },
		},
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ pos = Vector(164,-36.2,41.6), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(145.5,-50.55,69.4), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(86.5,-49.5,68.5), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(-152,-47,43.4), colorG = 150, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ pos = Vector(164,36.2,41.6), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(145.5,50.55,69.4), colorG = 150, colorB = 0, colorA = 150 },
			{ pos = Vector(86.5,49.5,68.5), colorG = 150, colorB = 0, colorA = 150 },	
			{ pos = Vector(-152,47,43.4), colorG = 150, colorB = 0, colorA = 150 },		
		},
	},
}