
include("entities/lvs_wheeldrive_dodtiger/cl_optics.lua")

ENT.OpticsFov = 20
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {
	[1] = true,
}

ENT.OpticsCrosshairMaterial = Material( "lvs/circle_filled.png" )
ENT.OpticsCrosshairColor = Color(0,0,0,150)
ENT.OpticsCrosshairSize = 4

local circle = Material( "lvs/circle_hollow.png" )
local tri1 = Material( "lvs/bradley_cross.png" )
local tri2 = Material( "lvs/bradley_cross.png" )
local axis = Material( "lvs/bradley_cross.png" )
local scope = Material( "lvs/scope_viewblocked.png" )
local aim = Material( "lvs/bradley_cross.png" )

function ENT:PaintOpticsCrosshair( Pos2D )


	local Width = ScrW()
	local Height = ScrH()

	local ScopeSize = Height

	surface.SetMaterial( aim )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.25, Pos2D.y - ScopeSize * 0.25, ScopeSize/2, ScopeSize/2 )
end

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )

	local size = self.OpticsCrosshairSize

	surface.SetMaterial( self.OpticsCrosshairMaterial )
	surface.SetDrawColor( self.OpticsCrosshairColor )
	surface.DrawTexturedRect( Pos2D.x - size * 0.5, Pos2D.y - size * 0.5, size, size )

	local H05 = ScrH() * 0.5

	local ScrW = ScrW()
	local ScrH = ScrH()

	local diameter = ScrH + 64
	local radius = diameter * 0.5

	surface.SetMaterial( scope )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( Pos2D.x - radius, Pos2D.y - radius, diameter, diameter )

	-- black bar left + right
	surface.DrawRect( 0, 0, Pos2D.x - radius, ScrH )
	surface.DrawRect( Pos2D.x + radius, 0, Pos2D.x - radius, ScrH )
end

