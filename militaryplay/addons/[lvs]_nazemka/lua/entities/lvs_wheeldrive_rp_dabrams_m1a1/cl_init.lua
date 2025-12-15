include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("cl_optics.lua")
include("cl_tankview.lua")
include("cl_attached_playermodels.lua")

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:SetPoseParameter( "vehicle_steer", steer )
	self:SetPoseParameter( "tacho_gauge", engine_rpm / 6000 )
	self:SetPoseParameter( "temp_gauge", temperature )
	self:SetPoseParameter( "fuel_gauge", fuel )
	self:SetPoseParameter( "oil_gauge", oil )
	self:SetPoseParameter( "alt_gauge", ammeter )
	self:SetPoseParameter( "vehicle_gauge", speed_kmh / 60 )
	self:SetPoseParameter( "throttle_pedal", throttle )
	self:SetPoseParameter( "brake_pedal", brake )
	self:SetPoseParameter( "handbrake_pedal", handbrake )
	self:SetPoseParameter( "clutch_pedal", clutch )


end

function ENT:OnSpawn()
	self:CreateBonePoseParameter( "suspension_left_1", 46, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_2", 47, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_3", 48, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_4", 49, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_5", 50, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_6", 51, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_7", 52, nil, nil, Vector(0,10,0), Vector(0,-10,0) )

	self:CreateBonePoseParameter( "suspension_right_1", 53, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_2", 54, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_3", 55, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_4", 56, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_5", 57, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_6", 58, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_7", 59, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
end

local switch = Material("lvs/weapons/change_ammo.png")
local AP = Material("lvs/weapons/bullet_ap.png")
local HE = Material("lvs/weapons/tank_cannon.png")
function ENT:DrawWeaponIcon( PodID, ID, x, y, width, height, IsSelected, IconColor )
	local Icon = self:GetUseHighExplosive() and HE or AP

	surface.SetMaterial( Icon )
	surface.DrawTexturedRect( x, y, width, height )

	local ply = LocalPlayer()

	if not IsValid( ply ) or self:GetSelectedWeapon() ~= 1 then return end

	surface.SetMaterial( switch )
	surface.DrawTexturedRect( x + width + 5, y + 7, 24, 24 )

	local buttonCode = ply:lvsGetControls()[ "CAR_SWAP_AMMO" ]

	if not buttonCode then return end

	local KeyName = input.GetKeyName( buttonCode )

	if not KeyName then return end

	draw.DrawText( KeyName, "DermaDefault", x + width + 17, y + height * 0.5 + 7, Color(0,0,0,IconColor.a), TEXT_ALIGN_CENTER )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/abrams/abrams_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "lvs/vehicles/abrams/abrams_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end


function ENT:PreDraw()
	self:DrawGunner()
	self:DrawComm()
	self:DrawLoader()
	self:DrawTopGunner()
	return true
end

function ENT:PreDrawTranslucent()
	self:DrawGunner()
	self:DrawComm()
	self:DrawLoader()
	self:DrawTopGunner()
	return true
end
