
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

	local IsWeapon1 = LocalPlayer():lvsGetWeaponHandler():GetSelectedWeapon() == 2
	local IsWeapon2 = LocalPlayer():lvsGetWeaponHandler():GetSelectedWeapon() == 3

	local zoom_mat = Material( "models/sw/shared/sights/new/sight_leo2a4" )
	local zoom_mat_mg = Material( "models/sw/shared/sights/new/sight_leo2a4_mg" )
	local zoom_mat_apfsds = Material( "models/sw/shared/sights/new/sight_leo2a4_apfsds" )
	local zoom_mat_heat = Material( "models/sw/shared/sights/new/sight_leo2a4_heat" )
	local zoom_mat_he = Material( "models/sw/shared/sights/new/sight_leo2a4_he" )

	local X = ScrW() * 0.5
	local Y = ScrH() * 0.5
	local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
	if self:GetTurretDestroyed() then
		surface.SetDrawColor( Color(55,55,55,255) )
		surface.SetMaterial( broken_mat ) 
		surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
	end		
	surface.SetDrawColor( Color(255,255,255,255) )
	if IsWeapon1 then
		surface.SetMaterial( zoom_mat_mg )
	elseif IsWeapon2 then
		if self:GetShellType() == 0 then
			surface.SetMaterial( zoom_mat_apfsds ) 
		elseif self:GetShellType() == 1 then
			surface.SetMaterial( zoom_mat_heat ) 
		elseif self:GetShellType() == 2 then
			surface.SetMaterial( zoom_mat ) 
		end 	
	else
		surface.SetMaterial( zoom_mat )
	end
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