
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

	local IsWeapon1 = LocalPlayer():lvsGetWeaponHandler():GetSelectedWeapon() == 3
	local IsWeapon2 = LocalPlayer():lvsGetWeaponHandler():GetSelectedWeapon() == 4
	local IsWeapon3 = LocalPlayer():lvsGetWeaponHandler():GetSelectedWeapon() == 5
	local WeaponReady = LocalPlayer():lvsGetWeaponHandler():GetNWOverheated() == false

	local zoom_mat = Material( "models/sw/shared/sights/new/sight_sosnau_day" )
	local zoom_mat_night = Material( "models/sw/shared/sights/new/sight_sosnau_night" )
	local X = ScrW() * 0.5
	local Y = ScrH() * 0.5
	local broken_mat = Material( "models/sw/shared/sights/new/brokensight_overlay" )
	if self:GetTurretDestroyed() then
		surface.SetDrawColor( Color(55,55,55,255) )
		surface.SetMaterial( broken_mat ) 
		surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )
	end		
	surface.SetDrawColor( Color(255,255,255,255) )
	if self:GetFLIR() and self:GetEngineActive() and not self:GetTurretDestroyed() then
		local noise_mat = Material( "models/sw/shared/noise" )
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( noise_mat ) 
		surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )

		surface.SetMaterial( zoom_mat_night ) 
		surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )

		--weapon status
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(X/1.55, Y*1.5, X/6.4, Y/10.8)

		surface.SetFont("T90M_A_SIGHT_NIGHT")
		surface.SetTextColor(Color(255,255,255,255))
		surface.SetTextPos(X/1.55, Y*1.5)
		if WeaponReady then
			surface.DrawText("ГОТ")
		else
			surface.DrawText("ОЖД")
		end	

		--weapon type
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(X/0.83, Y*1.5, X/6.4, Y/10.8)

		surface.SetFont("T90M_A_SIGHT_NIGHT")
		surface.SetTextColor(Color(255,255,255,255))
		surface.SetTextPos(X/0.83, Y*1.5)
		if IsWeapon1 then
			surface.DrawText("ПКТ")	
		elseif IsWeapon2 then
			surface.DrawText("ОСН")
		elseif IsWeapon3 then
			surface.DrawText("ДЫМ")
		else
			surface.DrawText("ОСН")
		end	

		--shell type
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(X/1.21, Y*1.5, X/6.4, Y/10.8)

		surface.SetFont("T90M_A_SIGHT_NIGHT")
		surface.SetTextColor(Color(255,255,255,255))
		surface.SetTextPos(X/1.21, Y*1.5)
		if IsWeapon2 then
			if self:GetShellType() == 0 then
				surface.DrawText("ОБПС")
			elseif self:GetShellType() == 1 then
				surface.DrawText("КУМ")
			elseif self:GetShellType() == 2 then
				surface.DrawText("ОФ")
			elseif self:GetShellType() == 3 then
				surface.DrawText("ПТУР")
			end
		else
			surface.DrawText("БР")
		end

		--rangefinder
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(X/0.98, Y*1.5, X/6.4, Y/10.8)
		
		local ID2 = self:LookupAttachment( "view" )
		local Sight = self:GetAttachment( ID2 )
		trtab = {}
		trtab.start = Sight.Pos
		trtab.endpos = (Sight.Pos + Sight.Ang:Forward() * 900000)
		trtab.filter = self
		local tr = util.TraceLine(trtab)
		local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
		if tr.HitSky then
			range = "-----"
		else
			range = range
		end

		surface.SetFont("T90M_A_SIGHT_NIGHT")
		surface.SetTextColor(Color(255,255,255,255))
		surface.SetTextPos(X/0.98, Y*1.5)
		surface.DrawText(range)
	else
		surface.SetMaterial( zoom_mat )
		surface.DrawTexturedRectRotated( X, Y, ScrW(), ScrH()*1.75, 0 )

		--rangefinder
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(X/2, Y*1.65, X, Y/2)

		surface.SetDrawColor(Color(175,0,0,150))
		surface.DrawRect(X/1.115, Y*1.665, X/4.8, Y/10.8)

		surface.SetDrawColor(Color(175,0,0,150))
		surface.DrawRect(X/1.115, Y*1.765, X/4.8, Y/10.8)

		surface.SetFont("T90M_A_SIGHT_NIGHT")
		surface.SetTextColor(Color(255,0,0,255))
		surface.SetTextPos(X/1.115, Y*1.765)
		if IsWeapon2 then
			if self:GetShellType() == 0 then
				surface.DrawText("ОБПС")
			elseif self:GetShellType() == 1 then
				surface.DrawText("КУМ")
			elseif self:GetShellType() == 2 then
				surface.DrawText("ОФ")
			elseif self:GetShellType() == 3 then
				surface.DrawText("ПТУР")
			end
		else
			surface.DrawText("БР")
		end
		
		local ID2 = self:LookupAttachment( "view" )
		local Sight = self:GetAttachment( ID2 )
		trtab = {}
		trtab.start = Sight.Pos
		trtab.endpos = (Sight.Pos + Sight.Ang:Forward() * 900000)
		trtab.filter = self
		local tr = util.TraceLine(trtab)
		local range = (math.ceil(100*(tr.StartPos:Distance(tr.HitPos)*0.024))/100)
		if tr.HitSky then
			range = "-----"
		else
			range = range
		end

		surface.SetFont("T90M_A_SIGHT_NIGHT")
		surface.SetTextColor(Color(255,0,0,255))
		surface.SetTextPos(X/1.115, Y*1.665)
		surface.DrawText(range)
	end
end