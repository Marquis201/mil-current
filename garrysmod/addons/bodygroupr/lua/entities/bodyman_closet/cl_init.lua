include("shared.lua")

surface.CreateFont("bodyman_3d2d_large", {
	font = "Roboto",
	size = 128,
	weight = 800,
	antialias = true
})

surface.CreateFont("bodyman_3d2d_small", {
	font = "Roboto",
	size = 72,
	weight = 800,
	antialias = true
})

function ENT:Draw()
	self:DrawModel()

    if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
        local Ang = LocalPlayer():GetAngles()

        Ang:RotateAroundAxis( Ang:Forward(), 90)
        Ang:RotateAroundAxis( Ang:Right(), 90)

        cam.Start3D2D(self:GetPos()+self:GetUp()*90, Ang, 0.05)
            render.PushFilterMin(TEXFILTER.ANISOTROPIC)
                draw.ShadowSimpleText( 'Шкаф с броней', "Playernik1", -3, -70, Color(245, 5, 65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
                draw.ShadowSimpleText( 'Изменение экипировки', "Playerinfo", -3, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
            render.PopFilterMin()
        cam.End3D2D()
    end

end