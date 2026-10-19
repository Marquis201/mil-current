
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

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	local ID = self:LookupAttachment( "muzzle" )
	local Attachment = self:GetAttachment( ID )

	local zoom_mat = Material( "models/sw/shared/sights/new/sight_rws" )
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
		range = range.."m"
	end
	surface.SetTextColor( 255, 0, 0, 255 )
	surface.SetTextPos( (ScrW()*0.340), (ScrH()/1.68) )
	surface.SetFont("sw_digital")
	surface.DrawText( "DISTANCE: "..range )
end