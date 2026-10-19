include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("cl_optics.lua")
include("cl_tankview.lua")

function ENT:OnSpawn()
	self:CreateBonePoseParameter( "suspension_left_1", 40, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_2", 41, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_3", 42, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_4", 43, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_5", 44, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_left_6", 45, nil, nil, Vector(0,10,0), Vector(0,-10,0) )

	self:CreateBonePoseParameter( "suspension_right_1", 46, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_2", 47, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_3", 48, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_4", 49, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_5", 50, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
	self:CreateBonePoseParameter( "suspension_right_6", 51, nil, nil, Vector(0,10,0), Vector(0,-10,0) )
end

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:SetPoseParameter( "vehicle_steer", steer )
	self:SetPoseParameter( "tacho_gauge", engine_rpm / 5000 )
	self:SetPoseParameter( "temp_gauge", temperature )
	self:SetPoseParameter( "fuel_gauge", fuel )
	self:SetBonePoseParameter( "!alt_gauge", ammeter )
	self:SetPoseParameter( "oil_gauge", oil )
	self:SetPoseParameter( "vehicle_gauge", speed_kmh / 100 )
	self:SetPoseParameter( "throttle_pedal", throttle )
	self:SetPoseParameter( "brake_pedal", brake )
	self:SetPoseParameter( "handbrake_pedal", handbrake )
	self:SetPoseParameter( "clutch_pedal", clutch )

	local GearIDtoPose = {
		[-1] = 0,
		[1] = 4,
		[2] = 6,
		[3] = 9,
		[4] = 11,
		[5] = 14,
	}

	self:SetPoseParameter( "gear",  self:QuickLerp( "gear", (GearIDtoPose[ gear ] or 1) ) )

	local hours = os.date( "%H" )
	local min = os.date( "%M" ) 
	local sec = os.date( "%S" )

	self:SetPoseParameter( "hour", hours + min / 60 )
	self:SetPoseParameter( "minute", min + sec / 60 )
	self:SetPoseParameter( "second", sec )

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
		self:EmitSound( "lvs/vehicles/t72b/t72b_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "lvs/vehicles/t72b/t72_engine_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end
