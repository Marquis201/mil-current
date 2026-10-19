
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )
	if pod == self:GetGunnerSeat() and not pod:GetThirdPersonMode() then
		local Base = ply:lvsGetWeaponHandler()
		if not IsValid( Base ) then return end	
		local ID = self:LookupAttachment( "view" )
		local Attachment = self:GetAttachment( ID )
		if Attachment then
			pos = Attachment.Pos
			if ply:lvsKeyDown("ZOOM") then
				angles = Attachment.Ang

				local zIn = ply:KeyDown(IN_FORWARD) and 1 or 0
				local zOut = ply:KeyDown(IN_BACK) and 1 or 0
				self.GunZoom = self.GunZoom and math.Clamp(self.GunZoom + (zOut - zIn) * FrameTime() * 240,30,90) or 0
				fov = self.GunZoom
			end
		end
	elseif pod == self:GetGunnerSeat() and pod:GetThirdPersonMode() then
		local Base = ply:lvsGetWeaponHandler()
		if not IsValid( Base ) then return end	
		local ID = self:LookupAttachment( "muzzle_coax" )
		local Attachment = self:GetAttachment( ID )
		if Attachment then
			pos = Attachment.Pos+Attachment.Ang:Up()*50+Attachment.Ang:Right()*50
			if ply:lvsKeyDown("ZOOM") then
				angles = Attachment.Ang
			end
		end
	elseif pod == self:GetCommanderSeat() and not pod:GetThirdPersonMode() then
		local Base = ply:lvsGetWeaponHandler()
		if not IsValid( Base ) then return end	
		local ID = self:LookupAttachment( "sight_view" )
		local Attachment = self:GetAttachment( ID )
		if Attachment then
			pos = Attachment.Pos
			if ply:lvsKeyDown("ZOOM") then
				angles = Attachment.Ang

				local zIn = ply:KeyDown(IN_FORWARD) and 1 or 0
				local zOut = ply:KeyDown(IN_BACK) and 1 or 0
				self.ComZoom = self.ComZoom and math.Clamp(self.ComZoom + (zOut - zIn) * FrameTime() * 240,30,90) or 0
				fov = self.ComZoom
			end
		end
	elseif pod == self:GetCommanderSeat() and pod:GetThirdPersonMode() then
		local Base = ply:lvsGetWeaponHandler()
		if not IsValid( Base ) then return end	
		local ID = self:LookupAttachment( "sight_view" )
		local Attachment = self:GetAttachment( ID )
		if Attachment then
			pos = Attachment.Pos+Attachment.Ang:Up()*50+Attachment.Ang:Right()*50
			if ply:lvsKeyDown("ZOOM") then
				angles = Attachment.Ang
			end
		end
	end

	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end