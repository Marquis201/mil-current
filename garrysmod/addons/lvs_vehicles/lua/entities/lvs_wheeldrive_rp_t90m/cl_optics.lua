
ENT.OpticsFov = 20
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {
	[2] = true,
}

local OldTargetOffset = 0
local RotationOffset = 0
local scope = Material( "lvs/sight_empty.png" )
local aim = Material( "lvs/sight_t90m_v2.png" )
local rot = Material( "lvs/sight_t90m_rot.png" )
local point = Material( "lvs/sight_ger_pointer.png" )

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	local Width = ScrW()
	local Height = ScrH()

	local ScopeSize = Height

	local TurretBallisticsValue = self:GetTurretCompensation()

	-- how much scope offsets
	local Offset = (TurretBallisticsValue / Height) * 50

	-- how fast it rotate
	local RotationSpeed = 8

	local StartOffsetWeapon1 = -9 -- start rotation weapon1
	local StartOffsetWeapon2 = -9 -- start rotation weapon2

	-- changes how much it rotate and direction of rotation
	local RotationOffsetMultiplicatorWeapon1 = -0.015
	local RotationOffsetMultiplicatorWeapon2 = -0.015

	local IsWeapon1 = LocalPlayer():lvsGetWeaponHandler():GetSelectedWeapon() == 1

	-- this will force MG scope when HE is selected
	if self:GetUseHighExplosive() and IsWeapon1 then
		IsWeapon1 = false
	end

	local TargetOffset = IsWeapon1 and StartOffsetWeapon1 or StartOffsetWeapon2
	local OffsetBallistics = -TurretBallisticsValue * (IsWeapon1 and RotationOffsetMultiplicatorWeapon1 or RotationOffsetMultiplicatorWeapon2)

	if OldTargetOffset ~= TargetOffset then
		OldTargetOffset = TargetOffset
		surface.PlaySound( "lvs/optics.wav" )
	end

	-- smoothing
	RotationOffset = RotationOffset + (TargetOffset + OffsetBallistics - RotationOffset) * RealFrameTime() * RotationSpeed

	surface.SetMaterial( scope )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 + Offset, ScopeSize, ScopeSize )

	-- black bar top + bottom
	surface.DrawRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 - ScopeSize + Offset, ScopeSize, ScopeSize )
	surface.DrawRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 + ScopeSize + Offset, ScopeSize, ScopeSize )

	-- black bar left + right
	surface.DrawRect( 0, 0, Width * 0.5 - ScopeSize * 0.5, Height )
	surface.DrawRect( Width * 0.5 + ScopeSize * 0.5, 0, Width * 0.5 - ScopeSize * 0.5, Height )

	surface.SetMaterial( aim )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5, ScopeSize, ScopeSize )

	-- reduces 'rot' scaling
	ScopeSize = ScopeSize * 1.5

	surface.SetMaterial( rot )
	surface.DrawTexturedRectRotated( Pos2D.x, Pos2D.y-1300 + Offset, ScopeSize, ScopeSize, RotationOffset )

end